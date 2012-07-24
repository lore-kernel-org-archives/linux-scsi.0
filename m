From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v2 2/7] scsi: pm: use autosuspend if device supports it
Date: Tue, 24 Jul 2012 17:37:40 +0800
Message-ID: <1343122665-18711-3-git-send-email-aaron.lu@amd.com>
References: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1343122665-18711-1-git-send-email-aaron.lu@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Lin Ming <minggr@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Wu <jeff.wu@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

If the device is using autosuspend, when scsi_autopm_put_device is
called for it, use autosuspend runtime pm calls instead of the sync
call.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/scsi_pm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index d4201de..a002fbf 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -196,7 +196,12 @@ EXPORT_SYMBOL_GPL(scsi_autopm_get_device);
 
 void scsi_autopm_put_device(struct scsi_device *sdev)
 {
-	pm_runtime_put_sync(&sdev->sdev_gendev);
+	if (sdev->sdev_gendev.power.use_autosuspend) {
+		pm_runtime_mark_last_busy(&sdev->sdev_gendev);
+		pm_runtime_put_autosuspend(&sdev->sdev_gendev);
+	} else {
+		pm_runtime_put_sync(&sdev->sdev_gendev);
+	}
 }
 EXPORT_SYMBOL_GPL(scsi_autopm_put_device);
 
-- 
1.7.11.3
