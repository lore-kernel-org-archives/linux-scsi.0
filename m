From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v3 3/5] Revert "[SCSI] runtime resume parent for child's system-resume"
Date: Fri, 12 Oct 2012 14:59:36 +0800
Message-ID: <1350025178-2976-4-git-send-email-aaron.lu@intel.com>
References: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab2JLHAA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 03:00:00 -0400
In-Reply-To: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

This reverts commit 28fd00d42cca178638f51c08efa986a777c24a4b.

With commit 88d26136a256576e444db312179e17af6dd0ea87 (PM: Prevent
runtime suspend during system resume), this patch is no longer needed.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_pm.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d4201de..9923b26 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -76,17 +76,8 @@ static int scsi_bus_resume_common(struct device *dev)
 {
 	int err = 0;
 
-	if (scsi_is_sdev_device(dev)) {
-		/*
-		 * Parent device may have runtime suspended as soon as
-		 * it is woken up during the system resume.
-		 *
-		 * Resume it on behalf of child.
-		 */
-		pm_runtime_get_sync(dev->parent);
+	if (scsi_is_sdev_device(dev))
 		err = scsi_dev_type_resume(dev);
-		pm_runtime_put_sync(dev->parent);
-	}
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
-- 
1.7.12.21.g871e293

