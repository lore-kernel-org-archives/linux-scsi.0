From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: [PATCH v3 1/2] Hard disk S3 resume time optimization
Date: Tue, 14 Jan 2014 16:31:40 -0800
Message-ID: <20140115003140.GB15067@linux.intel.com>
References: <20140108005607.GB29556@linux.intel.com>
 <20140111191315.GC3257@mtj.dyndns.org>
 <20140113195544.GA13900@linux.intel.com>
 <20140113203007.GA3480@mtj.dyndns.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:48938 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaAOAbm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jan 2014 19:31:42 -0500
Content-Disposition: inline
In-Reply-To: <20140113203007.GA3480@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, rjw@rjwysocki.net

On resume, the ATA port driver currently waits until the AHCI controller
finishes executing the port wakeup command. This patch changes the
ata_port_resume callback to issue the wakeup and then return immediately,
thus allowing the next device in the pm queue to resume. Any commands
issued to the AHCI hardware during the wakeup will be queued up and
executed once the port is physically online. Thus no information is lost.

This patch applies to all ata resume callbacks: resume, restore, and thaw for
code simplicity. The primary benefit is to S3 resume.

The return value from ata_resume_async is now an indicator of whether 
the resume was initiated, rather than if it was completed. I'm letting the ata
driver assume control over its own error reporting in this case (which it does
already). If you look at the ata_port resume code you'll see that the
ata_port_resume callback returns the status of the ahci_port_resume callback,
which is always 0. So I don't see any harm in ignoring it.

If somebody requests suspend while ATA port resume is still running, the
request is queued until the resume has completed. I've tested
that case very heavily. Basically if you do two suspends in a row (within
seconds of each other) you lose any performance benefit, but that's a use
case that should happen only very rarerly (and wouldn't be expected to
be of any power benefit since too many sequential suspends actually
takes more power than just letting the machine stay in run mode).

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

 drivers/ata/libata-core.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 1393a58..ba69325 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5326,7 +5326,7 @@ bool ata_link_offline(struct ata_link *link)
 #ifdef CONFIG_PM
 static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
-			       int *async)
+			       bool async, int *async_result)
 {
 	struct ata_link *link;
 	unsigned long flags;
@@ -5336,8 +5336,8 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
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
@@ -5349,7 +5349,7 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 	ap->pm_mesg = mesg;
 	if (async)
-		ap->pm_result = async;
+		ap->pm_result = async_result;
 	else
 		ap->pm_result = &rc;
 
@@ -5372,7 +5372,8 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	return rc;
 }
 
-static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int *async)
+static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg,
+				     bool async, int *async_result)
 {
 	/*
 	 * On some hardware, device fails to respond after spun down
@@ -5384,14 +5385,14 @@ static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int
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
@@ -5416,27 +5417,28 @@ static int ata_port_poweroff(struct device *dev)
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
 }
 
 static int ata_port_resume(struct device *dev)
 {
 	int rc;
 
-	rc = ata_port_resume_common(dev, PMSG_RESUME);
+	rc = ata_port_resume_common(dev, PMSG_RESUME, true);
 	if (!rc) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
@@ -5477,7 +5479,7 @@ static int ata_port_runtime_suspend(struct device *dev)
 
 static int ata_port_runtime_resume(struct device *dev)
 {
-	return ata_port_resume_common(dev, PMSG_AUTO_RESUME);
+	return ata_port_resume_common(dev, PMSG_AUTO_RESUME, false);
 }
 
 static const struct dev_pm_ops ata_port_pm_ops = {
@@ -5500,13 +5502,13 @@ static const struct dev_pm_ops ata_port_pm_ops = {
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
 
