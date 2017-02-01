From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sg: protect access to to 'reserved' page array
Date: Wed,  1 Feb 2017 12:22:15 +0100
Message-ID: <1485948135-83249-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751222AbdBALW1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 06:22:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>

The 'reserved' page array is used as a short-cut for mapping
data, saving us to allocate pages per request.
However, the 'reserved' array is only capable of holding one
request, so we need to protect it against concurrent accesses.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Link: http://www.spinics.net/lists/linux-scsi/msg104326.html
Signed-off-by: Hannes Reinecke <hare@suse.com>
Tested-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/sg.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 652b934..6a8601c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -155,6 +155,8 @@
 	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	unsigned long flags;
+#define SG_RESERVED_IN_USE 1
 	struct kref f_ref;
 	struct execute_work ew;
 } Sg_fd;
@@ -198,7 +200,6 @@ static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static int sg_res_in_use(Sg_fd * sfp);
 static Sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 
@@ -721,7 +722,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 			sg_remove_request(sfp, srp);
 			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
 		}
-		if (sg_res_in_use(sfp)) {
+		if (test_bit(SG_RESERVED_IN_USE, &sfp->flags)) {
 			sg_remove_request(sfp, srp);
 			return -EBUSY;	/* reserve buffer already being used */
 		}
@@ -963,10 +964,14 @@ static int max_sectors_bytes(struct request_queue *q)
 		val = min_t(int, val,
 			    max_sectors_bytes(sdp->device->request_queue));
 		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
+			if (sfp->mmap_called)
+				return -EBUSY;
+			if (test_and_set_bit(SG_RESERVED_IN_USE, &sfp->flags))
 				return -EBUSY;
+
 			sg_remove_scat(sfp, &sfp->reserve);
 			sg_build_reserve(sfp, val);
+			clear_bit(SG_RESERVED_IN_USE, &sfp->flags);
 		}
 		return 0;
 	case SG_GET_RESERVED_SIZE:
@@ -1720,7 +1725,9 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 		md = &map_data;
 
 	if (md) {
-		if (!sg_res_in_use(sfp) && dxfer_len <= rsv_schp->bufflen)
+		if (dxfer_len <= rsv_schp->bufflen &&
+		    test_and_set_bit(SG_RESERVED_IN_USE,
+				     &sfp->flags) == 0)
 			sg_link_reserve(sfp, srp, dxfer_len);
 		else {
 			res = sg_build_indirect(req_schp, sfp, dxfer_len);
@@ -2013,6 +2020,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	req_schp->sglist_len = 0;
 	sfp->save_scat_len = 0;
 	srp->res_used = 0;
+	clear_bit(SG_RESERVED_IN_USE, &sfp->flags);
 }
 
 static Sg_request *
@@ -2199,20 +2207,6 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	schedule_work(&sfp->ew.work);
 }
 
-static int
-sg_res_in_use(Sg_fd * sfp)
-{
-	const Sg_request *srp;
-	unsigned long iflags;
-
-	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp = sfp->headrp; srp; srp = srp->nextrp)
-		if (srp->res_used)
-			break;
-	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return srp ? 1 : 0;
-}
-
 #ifdef CONFIG_SCSI_PROC_FS
 static int
 sg_idr_max_id(int id, void *p, void *data)
-- 
1.8.5.6
