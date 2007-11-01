From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/4] block layer varlen-cdb
Date: Thu, 01 Nov 2007 20:05:06 +0200
Message-ID: <472A1552.6030700@panasas.com>
References: <472A12D6.805@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9493 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753621AbXKASGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 14:06:22 -0400
In-Reply-To: <472A12D6.805@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi
Cc: Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>


  - add varlen_cdb and varlen_cdb_len to hold a large user cdb
    if needed. They start as empty. Allocation of buffer must
    be done by user and held until request execution is done.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/ll_rw_blk.c      |    2 ++
 include/linux/blkdev.h |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index b01dee3..df478f2 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -261,6 +261,8 @@ static void rq_init(struct request_queue *q, struct request *rq)
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
 	rq->next_rq = NULL;
+	rq->varlen_cdb_len = 0;
+	rq->varlen_cdb = NULL;
 }
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bbf906a..990643d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -287,8 +287,13 @@ struct request {
 	/*
 	 * when request is used as a packet command carrier
 	 */
-	unsigned int cmd_len;
+	unsigned short cmd_len;
+	unsigned short varlen_cdb_len;  /* length of varlen_cdb buffer */
 	unsigned char cmd[BLK_MAX_CDB];
+	unsigned char *varlen_cdb;      /* an optional variable-length cdb.
+	                                 * points to a user buffer that must be
+	                                 * valid until end of request
+	                                 */
 
 	unsigned int data_len;
 	unsigned int sense_len;
-- 
1.5.3.1


