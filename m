From: David Decotigny <decot@googlers.com>
Subject: [PATCH] scsi: avoid use of reclaimed reference
Date: Tue, 12 Nov 2013 17:10:19 -0800
Message-ID: <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
References: <cover.1384304973.git.decot@googlers.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1384304973.git.decot@googlers.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, David Decotigny <decot@googlers.com>
List-Id: linux-scsi@vger.kernel.org

This patch avoids to use an object after it was potentially reclaimed
by scsi_device_put().

Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/scsi/scsi_scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..16e4a44 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1498,12 +1498,14 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
  out_err:
 	kfree(lun_data);
  out:
-	scsi_device_put(sdev);
-	if (scsi_device_created(sdev))
+	if (scsi_device_created(sdev)) {
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
 		__scsi_remove_device(sdev);
+	}
+
+	scsi_device_put(sdev);
 	return ret;
 }
 
-- 
1.8.4.1
