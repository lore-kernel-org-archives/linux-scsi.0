From: Colin King <colin.king@canonical.com>
Subject: [PATCH] [SCSI] esas2r: remove redundant NULL check on buffer
Date: Wed, 15 Mar 2017 16:46:24 +0000
Message-ID: <20170315164624.17264-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

buffer is a pointer to the static char array event_buffer and
therefore can never be null, so the check is redundant. Remove it.

Detected by CoverityScan, CID#1077556 ("Logically Dead Code")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/esas2r/esas2r_log.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_log.c b/drivers/scsi/esas2r/esas2r_log.c
index a82030a..65fdf22 100644
--- a/drivers/scsi/esas2r/esas2r_log.c
+++ b/drivers/scsi/esas2r/esas2r_log.c
@@ -130,11 +130,6 @@ static int esas2r_log_master(const long level,
 
 		spin_lock_irqsave(&event_buffer_lock, flags);
 
-		if (buffer == NULL) {
-			spin_unlock_irqrestore(&event_buffer_lock, flags);
-			return -1;
-		}
-
 		memset(buffer, 0, buflen);
 
 		/*
-- 
2.10.2
