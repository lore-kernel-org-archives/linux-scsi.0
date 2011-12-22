From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v3 2/3] ata: update ata port's runtime status during system resume
Date: Thu, 22 Dec 2011 14:50:48 +0800
Message-ID: <1324536649-5796-3-git-send-email-ming.m.lin@intel.com>
References: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:37668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1LVGvI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2011 01:51:08 -0500
In-Reply-To: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

The ata port is brought back to full power state during system resume.
So its runtime PM status will have to be updated to reflect
the actual post-system sleep status.

This also fixes below warning during system suspend/resume.

WARNING: at /work/linux/drivers/ata/libata-eh.c:4034
ata_scsi_port_error_handler+0x89/0x557()

4034         WARN_ON(!(ap->pflags & ATA_PFLAG_SUSPENDED));

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d55b51e..84aa741 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5298,7 +5298,7 @@ static int ata_port_suspend(struct device *dev)
 	return ata_port_suspend_common(dev);
 }
 
-static int ata_port_resume(struct device *dev)
+static int ata_port_resume_common(struct device *dev)
 {
 	struct ata_port *ap = to_ata_port(dev);
 	int rc;
@@ -5308,6 +5308,20 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+static int ata_port_resume(struct device *dev)
+{
+	int rc;
+
+	rc = ata_port_resume_common(dev);
+	if (!rc) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return rc;
+}
+
 static int ata_port_runtime_idle(struct device *dev)
 {
 	return pm_runtime_suspend(dev);
@@ -5318,7 +5332,7 @@ static const struct dev_pm_ops ata_port_pm_ops = {
 	.resume = ata_port_resume,
 
 	.runtime_suspend = ata_port_suspend_common,
-	.runtime_resume = ata_port_resume,
+	.runtime_resume = ata_port_resume_common,
 	.runtime_idle = ata_port_runtime_idle,
 };
 
-- 
1.7.2.5

