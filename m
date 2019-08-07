Return-Path: <SRS0=ayNI=WD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7D5C32751
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 11:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0382221BF6
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Aug 2019 11:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbfHGLm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 07:42:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:45220 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729632AbfHGLm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Aug 2019 07:42:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 6B225204164;
        Wed,  7 Aug 2019 13:42:53 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id n5cBvbEHhzD4; Wed,  7 Aug 2019 13:42:53 +0200 (CEST)
Received: from xtwo70.infotech.no (unknown [82.134.31.183])
        by smtp.infotech.no (Postfix) with ESMTPA id 2F700204255;
        Wed,  7 Aug 2019 13:42:53 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v3 04/20] sg: rework sg_poll(), minor changes
Date:   Wed,  7 Aug 2019 13:42:36 +0200
Message-Id: <20190807114252.2565-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807114252.2565-1-dgilbert@interlog.com>
References: <20190807114252.2565-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Re-arrange code in sg_poll(). Rename sg_read_oxfer() to
sg_rd_append(). In sg_start_req() rename rw to r0w.
Plus associated changes demanded by checkpatch.pl

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 65 ++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d14ba4a5441c..9aa1b1030033 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -177,13 +177,13 @@ static int sg_finish_rem_req(struct sg_request *srp);
 static int sg_build_indirect(struct sg_scatter_hold *schp, struct sg_fd *sfp,
 			     int buff_size);
 static ssize_t sg_new_write(struct sg_fd *sfp, struct file *file,
-			const char __user *buf, size_t count, int blocking,
-			int read_only, int sg_io_owned,
-			struct sg_request **o_srp);
+			    const char __user *buf, size_t count, int blocking,
+			    int read_only, int sg_io_owned,
+			    struct sg_request **o_srp);
 static int sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 			   u8 *cmnd, int timeout, int blocking);
-static int sg_read_oxfer(struct sg_request *srp, char __user *outp,
-			 int num_xfer);
+static int sg_rd_append(struct sg_request *srp, char __user *outp,
+			int num_xfer);
 static void sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
 static void sg_build_reserve(struct sg_fd *sfp, int req_size);
 static void sg_link_reserve(struct sg_fd *sfp, struct sg_request *srp,
@@ -918,7 +918,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t *ppos)
 		if (count > old_hdr->reply_len)
 			count = old_hdr->reply_len;
 		if (count > SZ_SG_HEADER) {
-			if (sg_read_oxfer(srp, buf, count - SZ_SG_HEADER)) {
+			if (sg_rd_append(srp, buf, count - SZ_SG_HEADER)) {
 				retval = -EFAULT;
 				goto free_old_hdr;
 			}
@@ -1253,38 +1253,34 @@ sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 static __poll_t
 sg_poll(struct file *filp, poll_table * wait)
 {
-	__poll_t res = 0;
-	struct sg_device *sdp;
-	struct sg_fd *sfp;
+	__poll_t p_res = 0;
+	struct sg_fd *sfp = filp->private_data;
 	struct sg_request *srp;
 	int count = 0;
 	unsigned long iflags;
 
-	sfp = filp->private_data;
 	if (!sfp)
 		return EPOLLERR;
-	sdp = sfp->parentdp;
-	if (!sdp)
-		return EPOLLERR;
 	poll_wait(filp, &sfp->read_wait, wait);
 	read_lock_irqsave(&sfp->rq_list_lock, iflags);
 	list_for_each_entry(srp, &sfp->rq_list, entry) {
 		/* if any read waiting, flag it */
-		if ((0 == res) && (1 == srp->done) && (!srp->sg_io_owned))
-			res = EPOLLIN | EPOLLRDNORM;
+		if (p_res == 0 && srp->done == 1 && !srp->sg_io_owned)
+			p_res = EPOLLIN | EPOLLRDNORM;
 		++count;
 	}
 	read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
 
-	if (atomic_read(&sdp->detaching))
-		res |= EPOLLHUP;
-	else if (!sfp->cmd_q) {
-		if (0 == count)
-			res |= EPOLLOUT | EPOLLWRNORM;
-	} else if (count < SG_MAX_QUEUE)
-		res |= EPOLLOUT | EPOLLWRNORM;
-	SG_LOG(3, sfp, "%s: res=0x%x\n", __func__, (__force u32)res);
-	return res;
+	if (sfp->parentdp && atomic_read(&sfp->parentdp->detaching)) {
+		p_res |= EPOLLHUP;
+	} else if (!sfp->cmd_q) {
+		if (count == 0)
+			p_res |= EPOLLOUT | EPOLLWRNORM;
+	} else if (count < SG_MAX_QUEUE) {
+		p_res |= EPOLLOUT | EPOLLWRNORM;
+	}
+	SG_LOG(3, sfp, "%s: p_res=0x%x\n", __func__, (__force u32)p_res);
+	return p_res;
 }
 
 static int
@@ -1801,7 +1797,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 	struct sg_scatter_hold *rsv_schp = &sfp->reserve;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 	struct rq_map_data *md, map_data;
-	int rw = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
+	int r0w = hp->dxfer_direction == SG_DXFER_TO_DEV ? WRITE : READ;
 	u8 *long_cmdp = NULL;
 
 	if (hp->cmd_len > BLK_MAX_CDB) {
@@ -1811,7 +1807,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 		SG_LOG(5, sfp, "%s: long_cmdp=0x%p ++\n", __func__, long_cmdp);
 	}
 	SG_LOG(4, sfp, "%s: dxfer_len=%d, data-%s\n", __func__, dxfer_len,
-	       (rw ? "OUT" : "IN"));
+	       (r0w ? "OUT" : "IN"));
 
 	/*
 	 * NOTE
@@ -1888,7 +1884,7 @@ sg_start_req(struct sg_request *srp, u8 *cmd)
 		struct iovec *iov = NULL;
 		struct iov_iter i;
 
-		res = import_iovec(rw, hp->dxferp, iov_count, 0, &iov, &i);
+		res = import_iovec(r0w, hp->dxferp, iov_count, 0, &iov, &i);
 		if (res < 0)
 			return res;
 
@@ -2057,33 +2053,32 @@ sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp)
  * appended to given struct sg_header object.
  */
 static int
-sg_read_oxfer(struct sg_request *srp, char __user *outp, int num_read_xfer)
+sg_rd_append(struct sg_request *srp, char __user *outp, int num_xfer)
 {
 	struct sg_scatter_hold *schp = &srp->data;
 	int k, num;
 
-	SG_LOG(4, srp->parentfp, "%s: num_xfer=%d\n", __func__, num_read_xfer);
-	if ((!outp) || (num_read_xfer <= 0))
+	SG_LOG(4, srp->parentfp, "%s: num_xfer=%d\n", __func__, num_xfer);
+	if (!outp || num_xfer <= 0)
 		return 0;
 
 	num = 1 << (PAGE_SHIFT + schp->page_order);
 	for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
-		if (num > num_read_xfer) {
+		if (num > num_xfer) {
 			if (__copy_to_user(outp, page_address(schp->pages[k]),
-					   num_read_xfer))
+					   num_xfer))
 				return -EFAULT;
 			break;
 		} else {
 			if (__copy_to_user(outp, page_address(schp->pages[k]),
 					   num))
 				return -EFAULT;
-			num_read_xfer -= num;
-			if (num_read_xfer <= 0)
+			num_xfer -= num;
+			if (num_xfer <= 0)
 				break;
 			outp += num;
 		}
 	}
-
 	return 0;
 }
 
-- 
2.22.0

