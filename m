From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in sd_dif_prepare().
Date: Wed,  7 Mar 2012 20:11:35 +0530
Message-ID: <1331131295-3707-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Value of BIO_MAPPED_INTEGRITY is 11. Intention was to set the 11th bit.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/sd_dif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index e981d97..8ccaf53 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -408,7 +408,7 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 			kunmap_atomic(sdt);
 		}
 
-		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
+		set_bit(BIO_MAPPED_INTEGRITY, &bio->bi_flags);
 	}
 
 	return 0;
-- 
1.7.4.4
