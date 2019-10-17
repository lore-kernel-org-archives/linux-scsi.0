Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75195ECE58E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9C020650
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438990AbfJQTjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:39:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45046 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730180AbfJQTjp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 15:39:45 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLBcc-0006ez-Se; Thu, 17 Oct 2019 19:39:43 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     linux-scsi@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 1/8] sg_ioctl(): fix copyout handling
Date:   Thu, 17 Oct 2019 20:39:18 +0100
Message-Id: <20191017193925.25539-1-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017193659.GA18702@ZenIV.linux.org.uk>
References: <20191017193659.GA18702@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

First of all, __put_user() can fail with access_ok() succeeding.
And access_ok() + __copy_to_user() is spelled copy_to_user()...

__put_user() *can* fail with access_ok() succeeding...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/sg.c | 43 ++++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cce757506383..634460421ce4 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -963,26 +963,21 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	case SG_GET_LOW_DMA:
 		return put_user((int) sdp->device->host->unchecked_isa_dma, ip);
 	case SG_GET_SCSI_ID:
-		if (!access_ok(p, sizeof (sg_scsi_id_t)))
-			return -EFAULT;
-		else {
-			sg_scsi_id_t __user *sg_idp = p;
+		{
+			sg_scsi_id_t v;
 
 			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
-			__put_user((int) sdp->device->host->host_no,
-				   &sg_idp->host_no);
-			__put_user((int) sdp->device->channel,
-				   &sg_idp->channel);
-			__put_user((int) sdp->device->id, &sg_idp->scsi_id);
-			__put_user((int) sdp->device->lun, &sg_idp->lun);
-			__put_user((int) sdp->device->type, &sg_idp->scsi_type);
-			__put_user((short) sdp->device->host->cmd_per_lun,
-				   &sg_idp->h_cmd_per_lun);
-			__put_user((short) sdp->device->queue_depth,
-				   &sg_idp->d_queue_depth);
-			__put_user(0, &sg_idp->unused[0]);
-			__put_user(0, &sg_idp->unused[1]);
+			memset(&v, 0, sizeof(v));
+			v.host_no = sdp->device->host->host_no;
+			v.channel = sdp->device->channel;
+			v.scsi_id = sdp->device->id;
+			v.lun = sdp->device->lun;
+			v.scsi_type = sdp->device->type;
+			v.h_cmd_per_lun = sdp->device->host->cmd_per_lun;
+			v.d_queue_depth = sdp->device->queue_depth;
+			if (copy_to_user(p, &v, sizeof(sg_scsi_id_t)))
+				return -EFAULT;
 			return 0;
 		}
 	case SG_SET_FORCE_PACK_ID:
@@ -992,20 +987,16 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		sfp->force_packid = val ? 1 : 0;
 		return 0;
 	case SG_GET_PACK_ID:
-		if (!access_ok(ip, sizeof (int)))
-			return -EFAULT;
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
 		list_for_each_entry(srp, &sfp->rq_list, entry) {
 			if ((1 == srp->done) && (!srp->sg_io_owned)) {
 				read_unlock_irqrestore(&sfp->rq_list_lock,
 						       iflags);
-				__put_user(srp->header.pack_id, ip);
-				return 0;
+				return put_user(srp->header.pack_id, ip);
 			}
 		}
 		read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-		__put_user(-1, ip);
-		return 0;
+		return put_user(-1, ip);
 	case SG_GET_NUM_WAITING:
 		read_lock_irqsave(&sfp->rq_list_lock, iflags);
 		val = 0;
@@ -1073,9 +1064,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 		val = (sdp->device ? 1 : 0);
 		return put_user(val, ip);
 	case SG_GET_REQUEST_TABLE:
-		if (!access_ok(p, SZ_SG_REQ_INFO * SG_MAX_QUEUE))
-			return -EFAULT;
-		else {
+		{
 			sg_req_info_t *rinfo;
 
 			rinfo = kcalloc(SG_MAX_QUEUE, SZ_SG_REQ_INFO,
@@ -1085,7 +1074,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
 			sg_fill_request_table(sfp, rinfo);
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
-			result = __copy_to_user(p, rinfo,
+			result = copy_to_user(p, rinfo,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result = result ? -EFAULT : 0;
 			kfree(rinfo);
-- 
2.11.0

