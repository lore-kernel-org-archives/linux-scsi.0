From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH/RESEND v2 1/2] SATA disk resume time optimization,
 asynchronous ata_port_resume
Date: Thu, 17 Oct 2013 12:36:07 -0700
Message-ID: <20131017193607.GB11747@linux.intel.com>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32577 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758172Ab3JQTf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Oct 2013 15:35:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com

On resume, the ATA port driver currently waits until the AHCI controller finishes executing the port wakeup command. This patch changes the ata_port_resume callback to issue the wakeup and then return immediately, thus allowing the next device in the pm queue to resume. Any commands issued to the AHCI hardware during the wakeup will be queued up and executed once the port is physically online. Thus no information is lost, and although the wait time itself isn't removed, it doesn't hold up the rest of the system.

In combination with the sd_resume patch, this patch greatly reduces S3 system resume time on systems with SATA drives. This is accomplished by removing the drive spinup time from the system resume delay. Applying these two patches allows SATA disks to resume asynchronously without holding up system resume; thus allowing the UI to come online sooner. There may be a short period after resume where the disks are still spinning up in the background, but the user shouldn't notice since the OS can function with the data left in RAM.

This patch only changes the behavior of the resume callback, not restore, thaw, or runtime-resume. This is because thaw and restore are used after a suspend-to-disk, which means that an image needs to be read from swap and reloaded into RAM. The swap disk will always need to be fully restored/thawed in order for resume to continue.

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

 drivers/ata/libata-core.c | 48 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 83b1a9f..3fc8afc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5311,7 +5311,7 @@ bool ata_link_offline(struct ata_link *link)
 #ifdef CONFIG_PM
 static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
-			       int *async)
+			       bool async, int *async_result)
 {
 	struct ata_link *link;
 	unsigned long flags;
@@ -5321,8 +5321,8 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	 * progress.  Wait for PM_PENDING to clear.
 	 */
 	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
-		if (async) {
-			*async = -EAGAIN;
+		if (async && async_result) {
+			*async_result = -EAGAIN;
 			return 0;
 		}
 		ata_port_wait_eh(ap);
@@ -5334,7 +5334,7 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 	ap->pm_mesg = mesg;
 	if (async)
-		ap->pm_result = async;
+		ap->pm_result = async_result;
 	else
 		ap->pm_result = &rc;
 
@@ -5357,7 +5357,8 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	return rc;
 }
 
-static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int *async)
+static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg,
+				     bool async, int *async_result)
 {
 	/*
 	 * On some hardware, device fails to respond after spun down
@@ -5369,14 +5370,14 @@ static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int
 	 */
 	unsigned int ehi_flags = ATA_EHI_QUIET | ATA_EHI_NO_AUTOPSY |
 				 ATA_EHI_NO_RECOVERY;
-	return ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
+	return ata_port_request_pm(ap, mesg, 0, ehi_flags, async, async_result);
 }
 
 static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 {
 	struct ata_port *ap = to_ata_port(dev);
 
-	return __ata_port_suspend_common(ap, mesg, NULL);
+	return __ata_port_suspend_common(ap, mesg, false, NULL);
 }
 
 static int ata_port_suspend(struct device *dev)
@@ -5401,27 +5402,42 @@ static int ata_port_poweroff(struct device *dev)
 }
 
 static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
-				    int *async)
+				    bool async, int *async_result)
 {
 	int rc;
 
 	rc = ata_port_request_pm(ap, mesg, ATA_EH_RESET,
-		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async, async_result);
 	return rc;
 }
 
-static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
+static int ata_port_resume_common(struct device *dev, pm_message_t mesg,
+				  bool async)
 {
 	struct ata_port *ap = to_ata_port(dev);
 
-	return __ata_port_resume_common(ap, mesg, NULL);
+	return __ata_port_resume_common(ap, mesg, async, NULL);
+}
+
+static int ata_port_resume_async(struct device *dev)
+{
+	int rc;
+
+	rc = ata_port_resume_common(dev, PMSG_RESUME, true);
+	if (!rc) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return rc;
 }
 
 static int ata_port_resume(struct device *dev)
 {
 	int rc;
 
-	rc = ata_port_resume_common(dev, PMSG_RESUME);
+	rc = ata_port_resume_common(dev, PMSG_RESUME, false);
 	if (!rc) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
@@ -5462,12 +5478,12 @@ static int ata_port_runtime_suspend(struct device *dev)
 
 static int ata_port_runtime_resume(struct device *dev)
 {
-	return ata_port_resume_common(dev, PMSG_AUTO_RESUME);
+	return ata_port_resume_common(dev, PMSG_AUTO_RESUME, false);
 }
 
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
-	.resume = ata_port_resume,
+	.resume = ata_port_resume_async,
 	.freeze = ata_port_do_freeze,
 	.thaw = ata_port_resume,
 	.poweroff = ata_port_poweroff,
@@ -5485,13 +5501,13 @@ static const struct dev_pm_ops ata_port_pm_ops = {
  */
 int ata_sas_port_async_suspend(struct ata_port *ap, int *async)
 {
-	return __ata_port_suspend_common(ap, PMSG_SUSPEND, async);
+	return __ata_port_suspend_common(ap, PMSG_SUSPEND, true, async);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_async_suspend);
 
 int ata_sas_port_async_resume(struct ata_port *ap, int *async)
 {
-	return __ata_port_resume_common(ap, PMSG_RESUME, async);
+	return __ata_port_resume_common(ap, PMSG_RESUME, true, async);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_async_resume);
 

