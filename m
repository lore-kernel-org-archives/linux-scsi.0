From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH 3/3] ata: implement ata port runtime pm hooks
Date: Wed,  2 Nov 2011 14:21:40 +0800
Message-ID: <1320214900-2112-4-git-send-email-ming.m.lin@intel.com>
References: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39863 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1KBGWL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Nov 2011 02:22:11 -0400
In-Reply-To: <1320214900-2112-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@Parallels.com>, Tejun Heo <tj@kernel.org>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>

Split a new function ata_port_request_pm from ata_host_request_pm.
Implement runtime suspend and resume hooks for scsi layer.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |   96 +++++++++++++++++++++++++++++---------------
 include/linux/libata.h    |    7 +++
 2 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4a3a5ae..2e191e7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -66,6 +66,7 @@
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -5234,51 +5235,62 @@ bool ata_link_offline(struct ata_link *link)
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
+	int rc;
 
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-		struct ata_link *link;
+	/* Previous resume operation might still be in
+	 * progress.  Wait for PM_PENDING to clear.
+	 */
+	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+	}
 
-		/* Previous resume operation might still be in
-		 * progress.  Wait for PM_PENDING to clear.
-		 */
-		if (ap->pflags & ATA_PFLAG_PM_PENDING) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-		}
+	/* request PM ops to EH */
+	spin_lock_irqsave(ap->lock, flags);
 
-		/* request PM ops to EH */
-		spin_lock_irqsave(ap->lock, flags);
+	ap->pm_mesg = mesg;
+	if (wait) {
+		rc = 0;
+		ap->pm_result = &rc;
+	}
 
-		ap->pm_mesg = mesg;
-		if (wait) {
-			rc = 0;
-			ap->pm_result = &rc;
-		}
+	ap->pflags |= ATA_PFLAG_PM_PENDING;
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		link->eh_info.action |= action;
+		link->eh_info.flags |= ehi_flags;
+	}
 
-		ap->pflags |= ATA_PFLAG_PM_PENDING;
-		ata_for_each_link(link, ap, HOST_FIRST) {
-			link->eh_info.action |= action;
-			link->eh_info.flags |= ehi_flags;
-		}
+	ata_port_schedule_eh(ap);
 
-		ata_port_schedule_eh(ap);
+	spin_unlock_irqrestore(ap->lock, flags);
 
-		spin_unlock_irqrestore(ap->lock, flags);
+	/* wait and check result */
+	if (wait) {
+		ata_port_wait_eh(ap);
+		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
+	}
 
-		/* wait and check result */
-		if (wait) {
-			ata_port_wait_eh(ap);
-			WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
-			if (rc)
-				return rc;
-		}
+	return rc;
+}
+
+static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
+			       unsigned int action, unsigned int ehi_flags,
+			       int wait)
+{
+	int i, rc;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		rc = ata_port_request_pm(ap, mesg, action, ehi_flags, wait);
+		if (rc)
+			return rc;
 	}
 
 	return 0;
@@ -5338,6 +5350,24 @@ void ata_host_resume(struct ata_host *host)
 			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
 	host->dev->power.power_state = PMSG_ON;
 }
+
+#define to_ata_port(shost) (*(struct ata_port **)&shost->hostdata[0])
+
+int ata_scsi_host_suspend(struct Scsi_Host *shost)
+{
+	struct ata_port *ap = to_ata_port(shost);
+
+	return ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
+}
+
+int ata_scsi_host_resume(struct Scsi_Host *shost)
+{
+	struct ata_port *ap = to_ata_port(shost);
+
+	return ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 1);
+}
+
 #endif
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index efd6f98..2fb9720 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1010,6 +1010,11 @@ extern bool ata_link_offline(struct ata_link *link);
 #ifdef CONFIG_PM
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
+extern int ata_scsi_host_suspend(struct Scsi_Host *shost);
+extern int ata_scsi_host_resume(struct Scsi_Host *shost);
+#else
+static inline int ata_scsi_host_suspend(struct Scsi_Host *shost) { return 0; }
+static inline int ata_scsi_host_resume(struct Scsi_Host *shost) { return 0; };
 #endif
 extern int ata_ratelimit(void);
 extern void ata_msleep(struct ata_port *ap, unsigned int msecs);
@@ -1193,6 +1198,8 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.name			= drv_name,			\
 	.ioctl			= ata_scsi_ioctl,		\
 	.queuecommand		= ata_scsi_queuecmd,		\
+	.suspend		= ata_scsi_host_suspend,	\
+	.resume			= ata_scsi_host_resume,		\
 	.can_queue		= ATA_DEF_QUEUE,		\
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,		\
-- 
1.7.2.5

