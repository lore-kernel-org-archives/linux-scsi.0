From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 5/6] sg: use standard lists for sg_requests
Date: Fri,  3 Feb 2017 13:18:24 +0100
Message-ID: <1486124305-104141-6-git-send-email-hare@suse.de>
References: <1486124305-104141-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39216 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752514AbdBCMSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 07:18:30 -0500
In-Reply-To: <1486124305-104141-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

'Sg_request' is using a private list implementation; convert it
to standard lists.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sg.c | 149 +++++++++++++++++++++++-------------------------------
 1 file changed, 62 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3045370..4b7e140 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -122,7 +122,7 @@
 struct sg_fd;
 
 typedef struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
-	struct sg_request *nextrp;	/* NULL -> tail request (slist) */
+	struct list_head entry;	/* list entry */
 	struct sg_fd *parentfp;	/* NULL -> not in use */
 	Sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
 	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
@@ -146,7 +146,7 @@
 	int timeout;		/* defaults to SG_DEFAULT_TIMEOUT      */
 	int timeout_user;	/* defaults to SG_DEFAULT_TIMEOUT_USER */
 	Sg_scatter_hold reserve;	/* buffer held for this file descriptor */
-	Sg_request *headrp;	/* head of request slist, NULL->empty */
+	struct list_head rq_list; /* head of request list */
 	struct fasync_struct *async_qp;	/* used by asynchronous notification */
 	Sg_request req_arr[SG_MAX_QUEUE];	/* used as singly-linked list */
 	char force_packid;	/* 1 -> pack_id input to read(), 0 -> ignored */
@@ -754,7 +754,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 
 static bool sg_is_valid_dxfer(sg_io_hdr_t *hp)
 {
-	switch (dxfer_direction) {
+	switch (hp->dxfer_direction) {
 	case SG_DXFER_NONE:
 		if (hp->dxferp || hp->dxfer_len > 0)
 			return false;
@@ -954,7 +954,7 @@ static int max_sectors_bytes(struct request_queue *q)
 		if (!access_ok(VERIFY_WRITE, ip, sizeof (int)))
 			return -EFAULT;
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
-		for (srp = sfp->headrp; srp; srp = srp->nextrp) {
+		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 == srp->done) && (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
@@ -967,7 +967,8 @@ static int max_sectors_bytes(struct request_queue *q)
 		return 0;
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
-		for (val = 0, srp = sfp->headrp; srp; srp = srp->nextrp) {
+		val = 0;
+		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 == srp->done) && (!srp->sg_io_owned))
 				++val;
 		}
@@ -1042,35 +1043,33 @@ static int max_sectors_bytes(struct request_queue *q)
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
-			for (srp = sfp->headrp, val = 0; val < SG_MAX_QUEUE;
-			     ++val, srp = srp ? srp->nextrp : srp) {
+			val = 0;
+			list_for_each_entry(srp, &sfp->rq_list, entry) {
+				if (val > SG_MAX_QUEUE)
+					break;
 				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
-				if (srp) {
-					rinfo[val].req_state = srp->done + 1;
-					rinfo[val].problem =
-					    srp->header.masked_status & 
-					    srp->header.host_status & 
-					    srp->header.driver_status;
-					if (srp->done)
-						rinfo[val].duration =
-							srp->header.duration;
-					else {
-						ms = jiffies_to_msecs(jiffies);
-						rinfo[val].duration =
-						    (ms > srp->header.duration) ?
-						    (ms - srp->header.duration) : 0;
-					}
-					rinfo[val].orphan = srp->orphan;
-					rinfo[val].sg_io_owned =
-							srp->sg_io_owned;
-					rinfo[val].pack_id =
-							srp->header.pack_id;
-					rinfo[val].usr_ptr =
-							srp->header.usr_ptr;
+				rinfo[val].req_state = srp->done + 1;
+				rinfo[val].problem =
+					srp->header.masked_status &
+					srp->header.host_status &
+					srp->header.driver_status;
+				if (srp->done)
+					rinfo[val].duration =
+						srp->header.duration;
+				else {
+					ms = jiffies_to_msecs(jiffies);
+					rinfo[val].duration =
+						(ms > srp->header.duration) ?
+						(ms - srp->header.duration) : 0;
 				}
+				rinfo[val].orphan = srp->orphan;
+				rinfo[val].sg_io_owned = srp->sg_io_owned;
+				rinfo[val].pack_id = srp->header.pack_id;
+				rinfo[val].usr_ptr = srp->header.usr_ptr;
+				val++;
 			}
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			result = __copy_to_user(p, rinfo, 
+			result = __copy_to_user(p, rinfo,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result = result ? -EFAULT : 0;
 			kfree(rinfo);
@@ -1176,7 +1175,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 		return POLLERR;
 	poll_wait(filp, &sfp->read_wait, wait);
 	read_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (srp = sfp->headrp; srp; srp = srp->nextrp) {
+	list_for_each_entry(srp, &sfp->rq_list, entry) {
 		/* if any read waiting, flag it */
 		if ((0 == res) && (1 == srp->done) && (!srp->sg_io_owned))
 			res = POLLIN | POLLRDNORM;
@@ -2057,7 +2056,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	unsigned long iflags;
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	for (resp = sfp->headrp; resp; resp = resp->nextrp) {
+	list_for_each_entry(resp, &sfp->rq_list, entry) {
 		/* look for requests that are ready + not SG_IO owned */
 		if ((1 == resp->done) && (!resp->sg_io_owned) &&
 		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
@@ -2075,70 +2074,45 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 {
 	int k;
 	unsigned long iflags;
-	Sg_request *resp;
 	Sg_request *rp = sfp->req_arr;
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	resp = sfp->headrp;
-	if (!resp) {
-		memset(rp, 0, sizeof (Sg_request));
-		rp->parentfp = sfp;
-		resp = rp;
-		sfp->headrp = resp;
-	} else {
-		if (0 == sfp->cmd_q)
-			resp = NULL;	/* command queuing disallowed */
-		else {
-			for (k = 0; k < SG_MAX_QUEUE; ++k, ++rp) {
-				if (!rp->parentfp)
-					break;
-			}
-			if (k < SG_MAX_QUEUE) {
-				memset(rp, 0, sizeof (Sg_request));
-				rp->parentfp = sfp;
-				while (resp->nextrp)
-					resp = resp->nextrp;
-				resp->nextrp = rp;
-				resp = rp;
-			} else
-				resp = NULL;
+	if (!list_empty(&sfp->rq_list)) {
+		if (!sfp->cmd_q)
+			goto out_unlock;
+
+		for (k = 0; k < SG_MAX_QUEUE; ++k, ++rp) {
+			if (!rp->parentfp)
+				break;
 		}
+		if (k >= SG_MAX_QUEUE)
+			goto out_unlock;
 	}
-	if (resp) {
-		resp->nextrp = NULL;
-		resp->header.duration = jiffies_to_msecs(jiffies);
-	}
+	memset(rp, 0, sizeof (Sg_request));
+	rp->parentfp = sfp;
+	rp->header.duration = jiffies_to_msecs(jiffies);
+	list_add_tail(&rp->entry, &sfp->rq_list);
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-	return resp;
+	return rp;
+out_unlock:
+	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+	return NULL;
 }
 
 /* Return of 1 for found; 0 for not found */
 static int
 sg_remove_request(Sg_fd * sfp, Sg_request * srp)
 {
-	Sg_request *prev_rp;
-	Sg_request *rp;
 	unsigned long iflags;
 	int res = 0;
 
-	if ((!sfp) || (!srp) || (!sfp->headrp))
+	if (!sfp || !srp || list_empty(&sfp->rq_list))
 		return res;
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
-	prev_rp = sfp->headrp;
-	if (srp == prev_rp) {
-		sfp->headrp = prev_rp->nextrp;
-		prev_rp->parentfp = NULL;
+	if (!list_empty(&srp->entry)) {
+		list_del(&srp->entry);
+		srp->parentfp = NULL;
 		res = 1;
-	} else {
-		while ((rp = prev_rp->nextrp)) {
-			if (srp == rp) {
-				prev_rp->nextrp = rp->nextrp;
-				rp->parentfp = NULL;
-				res = 1;
-				break;
-			}
-			prev_rp = rp;
-		}
 	}
 	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 	return res;
@@ -2157,7 +2131,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 
 	init_waitqueue_head(&sfp->read_wait);
 	rwlock_init(&sfp->rq_list_lock);
-
+	INIT_LIST_HEAD(&sfp->rq_list);
 	kref_init(&sfp->f_ref);
 	mutex_init(&sfp->f_mutex);
 	sfp->timeout = SG_DEFAULT_TIMEOUT;
@@ -2196,10 +2170,13 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
+	Sg_request *srp;
 
 	/* Cleanup any responses which were never read(). */
-	while (sfp->headrp)
-		sg_finish_rem_req(sfp->headrp);
+	while (!list_empty(&sfp->rq_list)) {
+		srp = list_first_entry(&sfp->rq_list, Sg_request, entry);
+		sg_finish_rem_req(srp);
+	}
 
 	if (sfp->reserve.bufflen > 0) {
 		SCSI_LOG_TIMEOUT(6, sg_printk(KERN_INFO, sdp,
@@ -2602,7 +2579,7 @@ static int sg_proc_seq_show_devstrs(struct seq_file *s, void *v)
 /* must be called while holding sg_index_lock */
 static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 {
-	int k, m, new_interface, blen, usg;
+	int k, new_interface, blen, usg;
 	Sg_request *srp;
 	Sg_fd *fp;
 	const sg_io_hdr_t *hp;
@@ -2622,13 +2599,11 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 		seq_printf(s, "   cmd_q=%d f_packid=%d k_orphan=%d closed=0\n",
 			   (int) fp->cmd_q, (int) fp->force_packid,
 			   (int) fp->keep_orphan);
-		for (m = 0, srp = fp->headrp;
-				srp != NULL;
-				++m, srp = srp->nextrp) {
+		list_for_each_entry(srp, &fp->rq_list, entry) {
 			hp = &srp->header;
 			new_interface = (hp->interface_id == '\0') ? 0 : 1;
 			if (srp->res_used) {
-				if (new_interface && 
+				if (new_interface &&
 				    (SG_FLAG_MMAP_IO & hp->flags))
 					cp = "     mmap>> ";
 				else
@@ -2659,7 +2634,7 @@ static void sg_proc_debug_helper(struct seq_file *s, Sg_device * sdp)
 			seq_printf(s, "ms sgat=%d op=0x%02x\n", usg,
 				   (int) srp->data.cmd_opcode);
 		}
-		if (0 == m)
+		if (list_empty(&fp->rq_list))
 			seq_puts(s, "     No requests active\n");
 		read_unlock(&fp->rq_list_lock);
 	}
-- 
1.8.5.6
