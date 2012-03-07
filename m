From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH v2] [SCSI] sd: set BIO_MAPPED_INTEGRITY bit correctly in sd_dif_prepare()
Date: Wed,  7 Mar 2012 22:30:52 +0530
Message-ID: <1331139652-25870-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54151 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab2CGRB7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2012 12:01:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Value of BIO_MAPPED_INTEGRITY is 11. Intention was to set the 11th bit.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/sd_dif.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index e981d97..8fdaf42 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -408,7 +408,7 @@ int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_s
 			kunmap_atomic(sdt);
 		}
 
-		bio->bi_flags |= BIO_MAPPED_INTEGRITY;
+		__set_bit(BIO_MAPPED_INTEGRITY, &bio->bi_flags);
 	}
 
 	return 0;
-- 
1.7.4.4

