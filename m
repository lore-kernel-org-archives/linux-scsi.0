From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 3/3] ata: add ata port hibernate callbacks
Date: Thu, 22 Dec 2011 14:50:49 +0800
Message-ID: <1324536649-5796-4-git-send-email-ming.m.lin@intel.com>
References: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 84aa741..8fbcad2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5281,12 +5281,24 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 #define to_ata_port(d) container_of(d, struct ata_port, tdev)
 
-static int ata_port_suspend_common(struct device *dev)
+static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 {
 	struct ata_port *ap = to_ata_port(dev);
+	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;
 
-	rc = ata_port_request_pm(ap, PMSG_SUSPEND, 0, ATA_EHI_QUIET, 1);
+	/*
+	 * On some hardware, device fails to respond after spun down
+	 * for suspend.  As the device won't be used before being
+	 * resumed, we don't need to touch the device.  Ask EH to skip
+	 * the usual stuff and proceed directly to suspend.
+	 *
+	 * http://thread.gmane.org/gmane.linux.ide/46764
+	 */
+	if (mesg.event == PM_EVENT_SUSPEND)
+		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
+
+	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, 1);
 	return rc;
 }
 
@@ -5295,7 +5307,23 @@ static int ata_port_suspend(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		return 0;
 
-	return ata_port_suspend_common(dev);
+	return ata_port_suspend_common(dev, PMSG_SUSPEND);
+}
+
+static int ata_port_do_freeze(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		pm_runtime_resume(dev);
+
+	return ata_port_suspend_common(dev, PMSG_FREEZE);
+}
+
+static int ata_port_poweroff(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+
+	return ata_port_suspend_common(dev, PMSG_HIBERNATE);
 }
 
 static int ata_port_resume_common(struct device *dev)
@@ -5330,8 +5358,12 @@ static int ata_port_runtime_idle(struct device *dev)
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
 	.resume = ata_port_resume,
+	.freeze = ata_port_do_freeze,
+	.thaw = ata_port_resume,
+	.poweroff = ata_port_poweroff,
+	.restore = ata_port_resume,
 
-	.runtime_suspend = ata_port_suspend_common,
+	.runtime_suspend = ata_port_suspend,
 	.runtime_resume = ata_port_resume_common,
 	.runtime_idle = ata_port_runtime_idle,
 };
-- 
1.7.2.5

