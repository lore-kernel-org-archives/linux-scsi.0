From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 14/18] libata: export ata_port suspend/resume
 infrastructure for sas
Date: Sat, 10 Mar 2012 23:28:56 -0800
Message-ID: <20120311072856.6320.53728.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2CKHNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2012 03:13:45 -0400
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>

Reuse ata_port_{suspend|resume}_common for sas.  This path is chosen
over adding coordination between ata-tranport and sas-transport because
libsas wants to revalidate the domain at resume-time at the host level.
It can not validate links have resumed properly until libata has had a
chance to perform its revalidation, and any sane placing of an ata_port
in the sas-transport model would delay it's resumption until after the
host.

Export the common portion of port suspend/resume (bypass pm_runtime),
and allow sas to perform these operations asynchronously (similar to the
libsas async-ata probe implmentation).  Async operation is determined by
having an external, rather than stack based, location for storing the
result of the operation.

Reviewed-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c |   58 ++++++++++++++++++++++++++++++++++++---------
 include/linux/libata.h    |    2 ++
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bd79c8b..a13c36d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5241,16 +5241,20 @@ bool ata_link_offline(struct ata_link *link)
 #ifdef CONFIG_PM
 static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
-			       int wait)
+			       int *async)
 {
 	struct ata_link *link;
 	unsigned long flags;
-	int rc;
+	int rc = 0;
 
 	/* Previous resume operation might still be in
 	 * progress.  Wait for PM_PENDING to clear.
 	 */
 	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
+		if (async) {
+			*async = -EAGAIN;
+			return 0;
+		}
 		ata_port_wait_eh(ap);
 		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
@@ -5259,10 +5263,10 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	spin_lock_irqsave(ap->lock, flags);
 
 	ap->pm_mesg = mesg;
-	if (wait) {
-		rc = 0;
+	if (async)
+		ap->pm_result = async;
+	else
 		ap->pm_result = &rc;
-	}
 
 	ap->pflags |= ATA_PFLAG_PM_PENDING;
 	ata_for_each_link(link, ap, HOST_FIRST) {
@@ -5275,7 +5279,7 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* wait and check result */
-	if (wait) {
+	if (!async) {
 		ata_port_wait_eh(ap);
 		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
@@ -5285,9 +5289,8 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 #define to_ata_port(d) container_of(d, struct ata_port, tdev)
 
-static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
+static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int *async)
 {
-	struct ata_port *ap = to_ata_port(dev);
 	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;
 
@@ -5302,10 +5305,17 @@ static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 	if (mesg.event == PM_EVENT_SUSPEND)
 		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
 
-	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, 1);
+	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
 	return rc;
 }
 
+static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
+{
+	struct ata_port *ap = to_ata_port(dev);
+
+	return __ata_port_suspend_common(ap, mesg, NULL);
+}
+
 static int ata_port_suspend(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
@@ -5330,16 +5340,22 @@ static int ata_port_poweroff(struct device *dev)
 	return ata_port_suspend_common(dev, PMSG_HIBERNATE);
 }
 
-static int ata_port_resume_common(struct device *dev)
+static int __ata_port_resume_common(struct ata_port *ap, int *async)
 {
-	struct ata_port *ap = to_ata_port(dev);
 	int rc;
 
 	rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
-		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
 	return rc;
 }
 
+static int ata_port_resume_common(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+
+	return __ata_port_resume_common(ap, NULL);
+}
+
 static int ata_port_resume(struct device *dev)
 {
 	int rc;
@@ -5372,6 +5388,24 @@ static const struct dev_pm_ops ata_port_pm_ops = {
 	.runtime_idle = ata_port_runtime_idle,
 };
 
+/* sas ports don't participate in pm runtime management of ata_ports,
+ * and need to resume ata devices at the domain level, not the per-port
+ * level. sas suspend/resume is async to allow parallel port recovery
+ * since sas has multiple ata_port instances per Scsi_Host.
+ */
+int ata_sas_port_async_suspend(struct ata_port *ap, int *async)
+{
+	return __ata_port_suspend_common(ap, PMSG_SUSPEND, async);
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_async_suspend);
+
+int ata_sas_port_async_resume(struct ata_port *ap, int *async)
+{
+	return __ata_port_resume_common(ap, async);
+}
+EXPORT_SYMBOL_GPL(ata_sas_port_async_resume);
+
+
 /**
  *	ata_host_suspend - suspend host
  *	@host: host to suspend
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 83ff256..15e1123 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -998,6 +998,8 @@ extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
+extern int ata_sas_port_async_suspend(struct ata_port *ap, int *async);
+extern int ata_sas_port_async_resume(struct ata_port *ap, int *async);
 extern int ata_sas_async_port_init(struct ata_port *);
 extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_port_start(struct ata_port *ap);

