From: Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH v3 2/7] scsi: pm: use autosuspend if device supports it
Date: Thu, 26 Jul 2012 18:05:24 +0800
Message-ID: <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@amd.com>
List-Id: linux-scsi@vger.kernel.org

If the device is using autosuspend, when scsi_autopm_put_device is
called for it, use autosuspend runtime pm calls instead of the sync
call.

Signed-off-by: Aaron Lu <aaron.lu@amd.com>
---
 drivers/scsi/scsi_pm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index dc0ad85..7c93723 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -197,7 +197,13 @@ EXPORT_SYMBOL_GPL(scsi_autopm_get_device);
 
 void scsi_autopm_put_device(struct scsi_device *sdev)
 {
-	pm_runtime_put_sync(&sdev->sdev_gendev);
+	if (sdev->sdev_gendev.power.use_autosuspend) {
+		pm_runtime_mark_last_busy(&sdev->sdev_gendev);
+		pm_runtime_put_autosuspend(&sdev->sdev_gendev);
+	} else {
+		pm_runtime_put_sync(&sdev->sdev_gendev);
+	}
+
 }
 EXPORT_SYMBOL_GPL(scsi_autopm_put_device);
 
-- 
1.7.11.3


