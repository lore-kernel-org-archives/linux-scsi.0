Return-Path: <SRS0=w4/B=3B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CFAC33CA9
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4844920724
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jan 2020 23:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387531AbgALX6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jan 2020 18:58:20 -0500
Received: from smtp.infotech.no ([82.134.31.41]:51963 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387522AbgALX6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jan 2020 18:58:19 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id F0B18204255;
        Mon, 13 Jan 2020 00:58:17 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2ptFQq70H4gR; Mon, 13 Jan 2020 00:58:16 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [213.52.86.138])
        by smtp.infotech.no (Postfix) with ESMTPA id C4A54204274;
        Mon, 13 Jan 2020 00:57:58 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v6 14/37] sg: sg_common_write add structure for arguments
Date:   Mon, 13 Jan 2020 00:57:32 +0100
Message-Id: <20200112235755.14197-15-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112235755.14197-1-dgilbert@interlog.com>
References: <20200112235755.14197-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As the number of arguments to sg_common_write() starts to grow
(more in later patches) add a structure to hold most of these
arguments.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9556fc56d9cc..07d203ba7439 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -174,6 +174,13 @@ struct sg_device { /* holds the state of each scsi generic device */
 	struct kref d_ref;
 };
 
+struct sg_comm_wr_t {  /* arguments to sg_common_write() */
+	int timeout;
+	int blocking;
+	struct sg_request *srp;
+	u8 *cmnd;
+};
+
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
@@ -186,8 +193,7 @@ static ssize_t sg_submit(struct sg_fd *sfp, struct file *filp,
 			 const char __user *buf, size_t count, bool blocking,
 			 bool read_only, bool sg_io_owned,
 			 struct sg_request **o_srp);
-static int sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
-			   u8 *cmnd, int timeout, int blocking);
+static int sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwp);
 static int sg_read_append(struct sg_request *srp, void __user *outp,
 			  int num_xfer);
 static void sg_remove_scat(struct sg_fd *sfp, struct sg_scatter_hold *schp);
@@ -493,6 +499,7 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 	struct sg_io_hdr v3hdr;
 	struct sg_header *ohp = &ov2hdr;
 	struct sg_io_hdr *h3p = &v3hdr;
+	struct sg_comm_wr_t cwr;
 	u8 cmnd[SG_MAX_CDB_SIZE];
 
 	res = sg_check_file_access(filp, __func__);
@@ -594,7 +601,11 @@ sg_write(struct file *filp, const char __user *p, size_t count, loff_t *ppos)
 				   input_size, (unsigned int) cmnd[0],
 				   current->comm);
 	}
-	res = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
+	cwr.timeout = sfp->timeout;
+	cwr.blocking = blocking;
+	cwr.srp = srp;
+	cwr.cmnd = cmnd;
+	res = sg_common_write(sfp, &cwr);
 	return (res < 0) ? res : count;
 }
 
@@ -617,6 +628,7 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 	int k;
 	struct sg_request *srp;
 	struct sg_io_hdr *hp;
+	struct sg_comm_wr_t cwr;
 	u8 cmnd[SG_MAX_CDB_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
@@ -667,23 +679,28 @@ sg_submit(struct sg_fd *sfp, struct file *filp, const char __user *buf,
 		sg_remove_request(sfp, srp);
 		return -EPERM;
 	}
-	k = sg_common_write(sfp, srp, cmnd, timeout, blocking);
+	cwr.timeout = timeout;
+	cwr.blocking = blocking;
+	cwr.srp = srp;
+	cwr.cmnd = cmnd;
+	k = sg_common_write(sfp, &cwr);
 	if (k < 0)
 		return k;
 	if (o_srp)
-		*o_srp = srp;
+		*o_srp = cwr.srp;
 	return count;
 }
 
 static int
-sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
-		u8 *cmnd, int timeout, int blocking)
+sg_common_write(struct sg_fd *sfp, struct sg_comm_wr_t *cwrp)
 {
-	int k, at_head;
+	bool at_head;
+	int k;
 	struct sg_device *sdp = sfp->parentdp;
+	struct sg_request *srp = cwrp->srp;
 	struct sg_io_hdr *hp = &srp->header;
 
-	srp->data.cmd_opcode = cmnd[0];	/* hold opcode of command */
+	srp->data.cmd_opcode = cwrp->cmnd[0];	/* hold opcode of command */
 	hp->status = 0;
 	hp->masked_status = 0;
 	hp->msg_status = 0;
@@ -692,12 +709,12 @@ sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 	hp->driver_status = 0;
 	hp->resid = 0;
 	SG_LOG(4, sfp, "%s:  opcode=0x%02x, cmd_sz=%d\n", __func__,
-	       (int)cmnd[0], hp->cmd_len);
+	       (int)cwrp->cmnd[0], hp->cmd_len);
 
 	if (hp->dxfer_len >= SZ_256M)
 		return -EINVAL;
 
-	k = sg_start_req(srp, cmnd);
+	k = sg_start_req(srp, cwrp->cmnd);
 	if (k) {
 		SG_LOG(1, sfp, "%s: start_req err=%d\n", __func__, k);
 		sg_finish_scsi_blk_rq(srp);
@@ -719,13 +736,13 @@ sg_common_write(struct sg_fd *sfp, struct sg_request *srp,
 	hp->duration = jiffies_to_msecs(jiffies);
 	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
 	    (SG_FLAG_Q_AT_TAIL & hp->flags))
-		at_head = 0;
+		at_head = false;
 	else
-		at_head = 1;
+		at_head = true;
 
-	if (!blocking)
+	if (!srp->sg_io_owned)
 		atomic_inc(&sfp->submitted);
-	srp->rq->timeout = timeout;
+	srp->rq->timeout = cwrp->timeout;
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
 	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
 			      srp->rq, at_head, sg_rq_end_io);
-- 
2.24.1

