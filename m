From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 1/9] scsi_dh: add REQ_LB_OP_TRANSITION and errors
Date: Wed, 23 Jan 2008 16:30:26 -0800
Message-ID: <20080124003026.18871.91721.sendpatchset@localhost.localdomain>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48861 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYAXAa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 19:30:29 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0O0USYn019750
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 19:30:28 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0O0USOQ085038
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:30:28 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0O0URVn028783
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:30:28 -0700
In-Reply-To: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com

Subject: scsi_dh: add REQ_LB_OP_TRANSITION and errors

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds REQ_LB_OP_TRANSITION which is a REQ_TYPE_LINUX_BLOCK
type of command. It also adds the error codes which are used by
REQ_LB_OP_TRANSITION to blkdev.h.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

 block/ll_rw_blk.c      |    2 	1 +	1 -	0 !
 include/linux/blkdev.h |   41 	41 +	0 -	0 !
 2 files changed, 42 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc8/block/ll_rw_blk.c
===================================================================
--- linux-2.6.24-rc8.orig/block/ll_rw_blk.c
+++ linux-2.6.24-rc8/block/ll_rw_blk.c
@@ -3456,7 +3456,7 @@ static int __end_that_request_first(stru
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
 	 */
-	if (!blk_pc_request(req))
+	if (!blk_pc_request(req) && !blk_linux_request(req))
 		req->errors = 0;
 
 	if (!uptodate) {
Index: linux-2.6.24-rc8/include/linux/blkdev.h
===================================================================
--- linux-2.6.24-rc8.orig/include/linux/blkdev.h
+++ linux-2.6.24-rc8/include/linux/blkdev.h
@@ -162,8 +162,48 @@ enum {
 	 */
 	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
 	REQ_LB_OP_FLUSH = 0x41,		/* flush device */
+	REQ_LB_OP_TRANSITION = 0x42,	/* failover/failback a device */
 };
 
+enum {
+	BLKERR_OK = 0,
+	/*
+	 * device errors
+	 */
+	BLKERR_DEV_FAILED,	/* generic device error */
+	BLKERR_DEV_TEMP_BUSY,
+	BLKERR_DEVICE_MAX,	/* max device blkerr definition */
+
+	/*
+	 * transport errors
+	 */
+	BLKERR_NOTCONN = BLKERR_DEVICE_MAX + 1,
+	BLKERR_CONN_FAILURE,
+	BLKERR_TRANSPORT_MAX,	/* max transport blkerr definition */
+
+	/*
+	 * driver and generic errors
+	 */
+	BLKERR_IO = BLKERR_TRANSPORT_MAX + 1,	/* generic error */
+	BLKERR_INVALID_IO,
+	BLKERR_RETRY,		/* retry the req, but not immediately */
+	BLKERR_IMM_RETRY,	/* immediately retry the req */
+	BLKERR_TIMED_OUT,
+	BLKERR_RES_TEMP_UNAVAIL,
+	BLKERR_DEV_OFFLINED,
+	BLKERR_NOSYS,
+	BLKERR_DRIVER_MAX,
+};
+
+#define blk_dev_err(_err) \
+	(_err > BLKERR_OK  && _err < BLKERR_DEVICE_MAX)
+
+ #define blkerr_transport_err(_err) \
+	(_err > BLKERR_DEVICE_MAX && _err < BLKERR_TRANSPORT_MAX)
+
+#define blkerr_driver_err(_err) \
+	(_err > BLKERR_TRANSPORT_MAX)
+
 /*
  * request type modified bits. first three bits match BIO_RW* bits, important
  */
@@ -521,6 +561,7 @@ enum {
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
 #define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
 #define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
+#define blk_linux_request(rq)	((rq)->cmd_type == REQ_TYPE_LINUX_BLOCK)
 
 #define blk_noretry_request(rq)	((rq)->cmd_flags & REQ_FAILFAST)
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
