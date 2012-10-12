From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v3 2/5] Revert "[SCSI] scsi_pm: set device runtime state before parent suspended"
Date: Fri, 12 Oct 2012 14:59:35 +0800
Message-ID: <1350025178-2976-3-git-send-email-aaron.lu@intel.com>
References: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2JLG76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 02:59:58 -0400
In-Reply-To: <1350025178-2976-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

This reverts commit 33a2285d96b5e7b9500612ec623bf4313397bb53.

With commit 88d26136a256576e444db312179e17af6dd0ea87 (PM: Prevent
runtime suspend during system resume), this patch is no longer needed.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/scsi_pm.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index dc0ad85..d4201de 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -76,24 +76,23 @@ static int scsi_bus_resume_common(struct device *dev)
 {
 	int err = 0;
 
-	/*
-	 * Parent device may have runtime suspended as soon as
-	 * it is woken up during the system resume.
-	 *
-	 * Resume it on behalf of child.
-	 */
-	pm_runtime_get_sync(dev->parent);
-
-	if (scsi_is_sdev_device(dev))
+	if (scsi_is_sdev_device(dev)) {
+		/*
+		 * Parent device may have runtime suspended as soon as
+		 * it is woken up during the system resume.
+		 *
+		 * Resume it on behalf of child.
+		 */
+		pm_runtime_get_sync(dev->parent);
 		err = scsi_dev_type_resume(dev);
+		pm_runtime_put_sync(dev->parent);
+	}
+
 	if (err == 0) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
 	}
-
-	pm_runtime_put_sync(dev->parent);
-
 	return err;
 }
 
-- 
1.7.12.21.g871e293

