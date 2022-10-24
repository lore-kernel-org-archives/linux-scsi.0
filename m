Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08582C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiJXDZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiJXDW6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:22:58 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C992C5C95A
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:21:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9E4782041CF;
        Mon, 24 Oct 2022 05:21:20 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZD6-FFhYs6zI; Mon, 24 Oct 2022 05:21:20 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 78AA72041AF;
        Mon, 24 Oct 2022 05:21:19 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v25 12/44] sg: split sg_read
Date:   Sun, 23 Oct 2022 23:20:26 -0400
Message-Id: <20221024032058.14077-13-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As sg_read() is getting quite long, split out the v1 and v2
processing into sg_read_v1v2(). Rename sg_new_read() to
sg_receive_v3() as the v3 interface is now older than the v4
interface which is being added in a later patch.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 194 ++++++++++++++++++++++++----------------------
 1 file changed, 100 insertions(+), 94 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7ae7f8d60bca..da40dd00d5a3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -193,8 +193,8 @@ static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
 			 struct sg_request **o_srp);
 static int sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 			   u8 *cmnd, int timeout, int blocking);
-static int sg_rd_append(struct sg_request *srp, void __user *outp,
-			int num_xfer);
+static int sg_read_append(struct sg_request *srp, void __user *outp,
+			  int num_xfer);
 static void sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
 static void sg_build_reserve(struct sg_fd *sfp, int req_size);
 static void sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp,
@@ -768,8 +768,8 @@ get_sg_io_pack_id(int *pack_id, void __user *buf, size_t count)
 }
 
 static ssize_t
-sg_new_read(struct sg_fd *sfp, char __user *buf, size_t count,
-	    struct sg_request *srp)
+sg_receive_v3(struct sg_fd *sfp, char __user *buf, size_t count,
+	      struct sg_request *srp)
 {
 	struct sg_io_hdr *hp = &srp->header;
 	int err = 0, err2;
@@ -810,28 +810,90 @@ sg_new_read(struct sg_fd *sfp, char __user *buf, size_t count,
 }
 
 static int
-srp_done(struct sg_fd *sfp, struct sg_request *srp)
+sg_read_v1v2(void __user *buf, int count, struct sg_fd *sfp,
+	     struct sg_request *srp)
 {
-	unsigned long flags;
-	int ret;
+	int res = 0;
+	struct sg_io_hdr *sh3p = &srp->header;
+	struct sg_header *h2p;
+	struct sg_header a_v2hdr;
+
+	h2p = &a_v2hdr;
+	memset(h2p, 0, SZ_SG_HEADER);
+	h2p->reply_len = (int)sh3p->timeout;
+	h2p->pack_len = h2p->reply_len; /* old, strange behaviour */
+	h2p->pack_id = sh3p->pack_id;
+	h2p->twelve_byte = (srp->data.cmd_opcode >= 0xc0 &&
+			    sh3p->cmd_len == 12);
+	h2p->target_status = sh3p->masked_status;
+	h2p->host_status = sh3p->host_status;
+	h2p->driver_status = sh3p->driver_status;
+	if ((CHECK_CONDITION & h2p->target_status) ||
+	    (srp->sense_b[0] & 0x70) == 0x70) {
+		h2p->driver_status = DRIVER_SENSE;
+		memcpy(h2p->sense_buffer, srp->sense_b,
+		       sizeof(h2p->sense_buffer));
+	}
+	switch (h2p->host_status) {
+	/*
+	 * This following setting of 'result' is for backward compatibility
+	 * and is best ignored by the user who should use target, host and
+	 * driver status.
+	 */
+	case DID_OK:
+	case DID_PASSTHROUGH:
+	case DID_SOFT_ERROR:
+		h2p->result = 0;
+		break;
+	case DID_NO_CONNECT:
+	case DID_BUS_BUSY:
+	case DID_TIME_OUT:
+		h2p->result = EBUSY;
+		break;
+	case DID_BAD_TARGET:
+	case DID_ABORT:
+	case DID_PARITY:
+	case DID_RESET:
+	case DID_BAD_INTR:
+		h2p->result = EIO;
+		break;
+	case DID_ERROR:
+		h2p->result = (h2p->target_status == GOOD) ? 0 : EIO;
+		break;
+	default:
+		h2p->result = EIO;
+		break;
+	}
 
-	spin_lock_irqsave(&sfp->rq_list_lock, flags);
-	ret = srp->done;
-	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
-	return ret;
+	/* Now copy the result back to the user buffer.  */
+	if (count >= SZ_SG_HEADER) {
+		if (copy_to_user(buf, h2p, SZ_SG_HEADER))
+			return -EFAULT;
+		buf += SZ_SG_HEADER;
+		if (count > h2p->reply_len)
+			count = h2p->reply_len;
+		if (count > SZ_SG_HEADER) {
+			if (sg_read_append(srp, buf, count - SZ_SG_HEADER))
+				return -EFAULT;
+		}
+	} else {
+		res = (h2p->result == 0) ? 0 : -EIO;
+	}
+	sg_finish_scsi_blk_rq(srp);
+	sg_remove_request(sfp, srp);
+	return res;
 }
 
 static ssize_t
-sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
+sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 {
+	bool non_block = !!(filp->f_flags & O_NONBLOCK);
+	bool busy;
+	int ret;
+	int req_pack_id = -1;
 	struct sg_device *sdp;
 	struct sg_fd *sfp;
 	struct sg_request *srp;
-	int req_pack_id = -1;
-	int ret;
-	bool busy;
-	struct sg_io_hdr *hp;
-	struct sg_header *old_hdr;
 
 	/*
 	 * This could cause a response to be stranded. Close the associated
@@ -841,9 +903,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	if (ret)
 		return ret;
 
-	if ((!(sfp = (struct sg_fd *)filp->private_data)) ||
-	    (!(sdp = sfp->parentdp)))
-		return -ENXIO;
+	sfp = filp->private_data;
+	sdp = sfp->parentdp;
 	SG_LOG(3, sfp, "%s: read() count=%d\n", __func__, (int)count);
 
 	if (sfp->force_packid)
@@ -853,7 +914,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 
 	srp = sg_get_rq_mark(sfp, req_pack_id, &busy);
 	if (!srp) {		/* now wait on packet to arrive */
-		if (filp->f_flags & O_NONBLOCK)
+		if (non_block)
 			return -EAGAIN;
 		ret = wait_event_interruptible(sfp->read_wait,
 			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
@@ -862,79 +923,24 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 			/* signal or detaching */
 			return ret ? ret : -ENODEV;
 	}
-	if (srp->header.interface_id != '\0')
-		return sg_new_read(sfp, buf, count, srp);
-
-	hp = &srp->header;
-	old_hdr = kzalloc(SZ_SG_HEADER, GFP_KERNEL);
-	if (!old_hdr)
-		return -ENOMEM;
+	if (srp->header.interface_id == '\0')
+		ret = sg_read_v1v2(buf, (int)count, sfp, srp);
+	else
+		ret = sg_receive_v3(sfp, buf, count, srp);
+	if (ret < 0)
+		SG_LOG(1, sfp, "%s: negated errno: %d\n", __func__, ret);
+	return ret < 0 ? ret : (int)count;
+}
 
-	old_hdr->reply_len = (int) hp->timeout;
-	old_hdr->pack_len = old_hdr->reply_len; /* old, strange behaviour */
-	old_hdr->pack_id = hp->pack_id;
-	old_hdr->twelve_byte =
-	    ((srp->data.cmd_opcode >= 0xc0) && (12 == hp->cmd_len)) ? 1 : 0;
-	old_hdr->target_status = hp->masked_status;
-	old_hdr->host_status = hp->host_status;
-	old_hdr->driver_status = hp->driver_status;
-	if ((CHECK_CONDITION & hp->masked_status) ||
-	    (srp->sense_b[0] & 0x70) == 0x70) {
-		old_hdr->driver_status = DRIVER_SENSE;
-		memcpy(old_hdr->sense_buffer, srp->sense_b,
-		       sizeof (old_hdr->sense_buffer));
-	}
-	switch (hp->host_status) {
-	/* This setup of 'result' is for backward compatibility and is best
-	   ignored by the user who should use target, host + driver status */
-	case DID_OK:
-	case DID_PASSTHROUGH:
-	case DID_SOFT_ERROR:
-		old_hdr->result = 0;
-		break;
-	case DID_NO_CONNECT:
-	case DID_BUS_BUSY:
-	case DID_TIME_OUT:
-		old_hdr->result = EBUSY;
-		break;
-	case DID_BAD_TARGET:
-	case DID_ABORT:
-	case DID_PARITY:
-	case DID_RESET:
-	case DID_BAD_INTR:
-		old_hdr->result = EIO;
-		break;
-	case DID_ERROR:
-		old_hdr->result = (srp->sense_b[0] == 0 &&
-				  hp->masked_status == GOOD) ? 0 : EIO;
-		break;
-	default:
-		old_hdr->result = EIO;
-		break;
-	}
+static int
+srp_done(struct sg_fd *sfp, struct sg_request *srp)
+{
+	unsigned long flags;
+	int ret;
 
-	/* Now copy the result back to the user buffer.  */
-	if (count >= SZ_SG_HEADER) {
-		if (copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
-			ret = -EFAULT;
-			goto free_old_hdr;
-		}
-		buf += SZ_SG_HEADER;
-		if (count > old_hdr->reply_len)
-			count = old_hdr->reply_len;
-		if (count > SZ_SG_HEADER) {
-			if (sg_rd_append(srp, buf, count - SZ_SG_HEADER)) {
-				ret = -EFAULT;
-				goto free_old_hdr;
-			}
-		}
-	} else
-		count = (old_hdr->result == 0) ? 0 : -EIO;
-	sg_finish_scsi_blk_rq(srp);
-	sg_remove_request(sfp, srp);
-	ret = count;
-free_old_hdr:
-	kfree(old_hdr);
+	spin_lock_irqsave(&sfp->rq_list_lock, flags);
+	ret = srp->done;
+	spin_unlock_irqrestore(&sfp->rq_list_lock, flags);
 	return ret;
 }
 
@@ -1006,7 +1012,7 @@ sg_ctl_sg_io(struct file *filp, struct sg_device *sdp, struct sg_fd *sfp,
 	if (srp->done) {
 		srp->done = 2;
 		spin_unlock_irq(&sfp->rq_list_lock);
-		res = sg_new_read(sfp, p, SZ_SG_IO_HDR, srp);
+		res = sg_receive_v3(sfp, p, SZ_SG_IO_HDR, srp);
 		return (res < 0) ? res : 0;
 	}
 	srp->orphan = 1;
@@ -2099,7 +2105,7 @@ sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
  * appended to given struct sg_header object.
  */
 static int
-sg_rd_append(struct sg_request *srp, void __user *outp, int num_xfer)
+sg_read_append(struct sg_request *srp, void __user *outp, int num_xfer)
 {
 	struct sg_scatter_hold *schp = &srp->data;
 	int k, num;
-- 
2.37.3

