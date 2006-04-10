From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 03/10] scsi tgt: use the original bio_map_user interface
Date: Mon, 10 Apr 2006 10:49:14 +0900 (JST)
Message-ID: <20060410104550U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:18685 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750866AbWDJBtc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Apr 2006 21:49:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Return to the original bio_map_user interface.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 drivers/scsi/scsi_tgt_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

2c78c6353dc183a16ef3e12b9c5618dd5b89679c
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 8746236..941dd64 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -315,7 +315,7 @@ static int scsi_map_user_pages(struct sc
 
 	while (len > 0) {
 		dprintk("%lx %u\n", (unsigned long) uaddr, len);
-		bio = bio_map_user(q, NULL, (unsigned long) uaddr, len, rw, 1);
+		bio = bio_map_user(q, NULL, (unsigned long) uaddr, len, rw);
 		if (IS_ERR(bio)) {
 			err = PTR_ERR(bio);
 			dprintk("fail to map %lx %u %d %x\n",
-- 
1.1.5
