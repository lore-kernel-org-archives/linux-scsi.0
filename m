From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 3/6] sg: protect accesses to 'reserved' page array
Date: Fri,  7 Apr 2017 09:34:14 +0200
Message-ID: <1491550457-78302-4-git-send-email-hare@suse.de>
References: <1491550457-78302-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54213 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752023AbdDGHeX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Apr 2017 03:34:23 -0400
In-Reply-To: <1491550457-78302-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <"james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, DougGilberdgilbert"@interlog.com>, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The 'reserved' page array is used as a short-cut for mapping
data, saving us to allocate pages per request.
However, the 'reserved' array is only capable of holding one
request, so this patch introduces a mutex for protect
'sg_fd' against concurrent accesses.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sg.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 92cc658..ddc1808 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -142,6 +142,7 @@
 	struct sg_device *parentdp;	/* owning device */
 	wait_queue_head_t read_wait;	/* queue read until command done */
 	rwlock_t rq_list_lock;	/* protect access to list in req_arr */
+	struct mutex f_mutex;	/* protect against changes in this fd */
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
@@ -153,6 +154,7 @@
 	unsigned char next_cmd_len; /* 0: automatic, >0: use on next write() */
 	char keep_orphan;	/* 0 -> drop orphan (def), 1 -> keep for read() */
 	char mmap_called;	/* 0 -> mmap() never called on this fd */
+	char res_in_use;	/* 1 -> 'reserve' array in use */
 	struct kref f_ref;
 	struct execute_work ew;
 } Sg_fd;
@@ -196,7 +198,6 @@ static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
 static Sg_request *sg_add_request(Sg_fd * sfp);
 static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
-static int sg_res_in_use(Sg_fd * sfp);
 static Sg_device *sg_get_dev(int dev);
 static void sg_device_destroy(struct kref *kref);
 
@@ -612,6 +613,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 	}
 	buf += SZ_SG_HEADER;
 	__get_user(opcode, buf);
+	mutex_lock(&sfp->f_mutex);
 	if (sfp->next_cmd_len > 0) {
 		cmd_size = sfp->next_cmd_len;
 		sfp->next_cmd_len = 0;	/* reset so only this write() effected */
@@ -620,6 +622,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 		if ((opcode >= 0xc0) && old_hdr.twelve_byte)
 			cmd_size = 12;
 	}
+	mutex_unlock(&sfp->f_mutex);
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
 		"sg_write:   scsi opcode=0x%02x, cmd_size=%d\n", (int) opcode, cmd_size));
 /* Determine buffer size.  */
@@ -719,7 +722,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 			sg_remove_request(sfp, srp);
 			return -EINVAL;	/* either MMAP_IO or DIRECT_IO (not both) */
 		}
-		if (sg_res_in_use(sfp)) {
+		if (sfp->res_in_use) {
 			sg_remove_request(sfp, srp);
 			return -EBUSY;	/* reserve buffer already being used */
 		}
@@ -953,12 +956,18 @@ static int max_sectors_bytes(struct request_queue *q)
                         return -EINVAL;
 		val = min_t(int, val,
 			    max_sectors_bytes(sdp->device->request_queue));
+		mutex_lock(&sfp->f_mutex);
 		if (val != sfp->reserve.bufflen) {
-			if (sg_res_in_use(sfp) || sfp->mmap_called)
+			if (sfp->mmap_called ||
+			    sfp->res_in_use) {
+				mutex_unlock(&sfp->f_mutex);
 				return -EBUSY;
+			}
+
 			sg_remove_scat(sfp, &sfp->reserve);
 			sg_build_reserve(sfp, val);
 		}
+		mutex_unlock(&sfp->f_mutex);
 		return 0;
 	case SG_GET_RESERVED_SIZE:
 		val = min_t(int, sfp->reserve.bufflen,
@@ -1718,13 +1727,22 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 		md = &map_data;
 
 	if (md) {
-		if (!sg_res_in_use(sfp) && dxfer_len <= rsv_schp->bufflen)
+		mutex_lock(&sfp->f_mutex);
+		if (dxfer_len <= rsv_schp->bufflen &&
+		    !sfp->res_in_use) {
+			sfp->res_in_use = 1;
 			sg_link_reserve(sfp, srp, dxfer_len);
-		else {
+		} else if ((hp->flags & SG_FLAG_MMAP_IO) && sfp->res_in_use) {
+			mutex_unlock(&sfp->f_mutex);
+			return -EBUSY;
+		} else {
 			res = sg_build_indirect(req_schp, sfp, dxfer_len);
-			if (res)
+			if (res) {
+				mutex_unlock(&sfp->f_mutex);
 				return res;
+			}
 		}
+		mutex_unlock(&sfp->f_mutex);
 
 		md->pages = req_schp->pages;
 		md->page_order = req_schp->page_order;
@@ -2125,6 +2143,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	rwlock_init(&sfp->rq_list_lock);
 
 	kref_init(&sfp->f_ref);
+	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
 	sfp->timeout_user = SG_DEFAULT_TIMEOUT_USER;
 	sfp->force_packid = SG_DEF_FORCE_PACK_ID;
@@ -2198,20 +2217,6 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
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
