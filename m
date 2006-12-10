From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] fix SG_IO bio leak
Date: Mon, 11 Dec 2006 01:33:46 +0900
Message-ID: <200612101633.kBAGXl6L001306@r-dd.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo01.iij4u.or.jp ([210.130.0.20]:49605 "EHLO mo01.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762247AbWLJQd6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Dec 2006 11:33:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

This patch fixes bio leaks in SG_IO.

http://marc.theaimsgroup.com/?l=linux-kernel&m=116570666807983&w=2

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/scsi_ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index b3e2107..045cabd 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -228,6 +228,7 @@ static int sg_io(struct file *file, requ
 	struct request *rq;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	unsigned char cmd[BLK_MAX_CDB];
+	struct bio *bio;
 
 	if (hdr->interface_id != 'S')
 		return -EINVAL;
@@ -308,6 +309,7 @@ static int sg_io(struct file *file, requ
 	if (ret)
 		goto out;
 
+	bio = rq->bio;
 	rq->retries = 0;
 
 	start_time = jiffies;
@@ -338,6 +340,7 @@ static int sg_io(struct file *file, requ
 			hdr->sb_len_wr = len;
 	}
 
+	rq->bio = bio;
 	if (blk_rq_unmap_user(rq))
 		ret = -EFAULT;
 
-- 
1.4.3.2

