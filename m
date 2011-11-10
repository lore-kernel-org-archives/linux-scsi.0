From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v2 3/4] ata: add ata port system PM callbacks
Date: Thu, 10 Nov 2011 14:22:45 +0800
Message-ID: <1320906166-15459-4-git-send-email-ming.m.lin@intel.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30670 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab1KJGXH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2011 01:23:07 -0500
In-Reply-To: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>

Change ata_host_request_pm to ata_port_request_pm which performs
port suspend/resume.

Add ata port type driver which implements port PM callbacks.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c      |  139 ++++++++++++++++++++--------------------
 drivers/ata/libata-transport.c |    2 +
 drivers/ata/libata.h           |    1 +
 3 files changed, 72 insertions(+), 70 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c04ad68..b77c40c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5234,112 +5234,111 @@ bool ata_link_offline(struct ata_link *link)
 }
 
 #ifdef CONFIG_PM
-static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
+static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
 			       int wait)
 {
+	struct ata_link *link;
 	unsigned long flags;
-	int i, rc;
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		struct ata_link *link;
+	int rc;
 
-		/* Previous resume operation might still be in
-		 * progress.  Wait for PM_PENDING to clear.
-		 */
-		if (ap->pflags & ATA_PFLAG_PM_PENDING) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-		}
+	/* Previous resume operation might still be in
+	 * progress.  Wait for PM_PENDING to clear.
+	 */
+	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+	}
 
-		/* request PM ops to EH */
-		spin_lock_irqsave(ap->lock, flags);
+	/* request PM ops to EH */
+	spin_lock_irqsave(ap->lock, flags);
 
-		ap->pm_mesg = mesg;
-		if (wait) {
-			rc = 0;
-			ap->pm_result = &rc;
-		}
+	ap->pm_mesg = mesg;
+	if (wait) {
+		rc = 0;
+		ap->pm_result = &rc;
+	}
 
-		ap->pflags |= ATA_PFLAG_PM_PENDING;
-		ata_for_each_link(link, ap, HOST_FIRST) {
-			link->eh_info.action |= action;
-			link->eh_info.flags |= ehi_flags;
-		}
+	ap->pflags |= ATA_PFLAG_PM_PENDING;
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		link->eh_info.action |= action;
+		link->eh_info.flags |= ehi_flags;
+	}
 
-		ata_port_schedule_eh(ap);
+	ata_port_schedule_eh(ap);
 
-		spin_unlock_irqrestore(ap->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
-		/* wait and check result */
-		if (wait) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-			if (rc)
-				return rc;
-		}
+	/* wait and check result */
+	if (wait) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
 
-	return 0;
+	return rc;
+}
+
+#define to_ata_port(d) container_of(d, struct ata_port, tdev)
+
+static int ata_port_suspend(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+	int rc;
+
+	if (ap->pflags & ATA_PFLAG_SUSPENDED)
+		return 0;
+
+	rc = ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
+	return rc;
+}
+
+static int ata_port_resume(struct device *dev)
+{
+	struct ata_port *ap = to_ata_port(dev);
+	int rc;
+
+	rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
+	return rc;
 }
 
+static const struct dev_pm_ops ata_port_pm_ops = {
+	.suspend = ata_port_suspend,
+	.resume = ata_port_resume,
+};
+
 /**
  *	ata_host_suspend - suspend host
  *	@host: host to suspend
  *	@mesg: PM message
  *
- *	Suspend @host.  Actual operation is performed by EH.  This
- *	function requests EH to perform PM operations and waits for EH
- *	to finish.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno on failure.
+ *	Suspend @host.  Actual operation is performed by port suspend.
  */
 int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
-	unsigned int ehi_flags = ATA_EHI_QUIET;
-	int rc;
-
-	/*
-	 * On some hardware, device fails to respond after spun down
-	 * for suspend.  As the device won't be used before being
-	 * resumed, we don't need to touch the device.  Ask EH to skip
-	 * the usual stuff and proceed directly to suspend.
-	 *
-	 * http://thread.gmane.org/gmane.linux.ide/46764
-	 */
-	if (mesg.event == PM_EVENT_SUSPEND)
-		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
-
-	rc = ata_host_request_pm(host, mesg, 0, ehi_flags, 1);
-	if (rc == 0)
-		host->dev->power.power_state = mesg;
-	return rc;
+	host->dev->power.power_state = mesg;
+	return 0;
 }
 
 /**
  *	ata_host_resume - resume host
  *	@host: host to resume
  *
- *	Resume @host.  Actual operation is performed by EH.  This
- *	function requests EH to perform PM operations and returns.
- *	Note that all resume operations are performed parallelly.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
+ *	Resume @host.  Actual operation is performed by port resume.
  */
 void ata_host_resume(struct ata_host *host)
 {
-	ata_host_request_pm(host, PMSG_ON, ATA_EH_RESET,
-			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
 }
 #endif
 
+struct device_type ata_port_type = {
+	.name = "ata_port",
+#ifdef CONFIG_PM
+	.pm = &ata_port_pm_ops,
+#endif
+};
+
 /**
  *	ata_dev_init - Initialize an ata_device structure
  *	@dev: Device structure to initialize
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index ce9dc62..a979bd76 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -32,6 +32,7 @@
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -279,6 +280,7 @@ int ata_tport_add(struct device *parent,
 	struct device *dev = &ap->tdev;
 
 	device_initialize(dev);
+	dev->type = &ata_port_type;
 
 	dev->parent = get_device(parent);
 	dev->release = ata_tport_release;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 773de97..814486d 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -58,6 +58,7 @@ extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
 extern int libata_allow_tpm;
+extern struct device_type ata_port_type;
 extern struct ata_link *ata_dev_phys_link(struct ata_device *dev);
 extern void ata_force_cbl(struct ata_port *ap);
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
-- 
1.7.2.5

