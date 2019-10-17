Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 484F4ECE58E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2081620650
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440211AbfJQTkB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:40:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45070 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437782AbfJQTjp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 15:39:45 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLBce-0006fd-7Z; Thu, 17 Oct 2019 19:39:44 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     linux-scsi@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 7/8] sg_write(): get rid of access_ok()/__copy_from_user()/__get_user()
Date:   Thu, 17 Oct 2019 20:39:24 +0100
Message-Id: <20191017193925.25539-7-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191017193925.25539-1-viro@ZenIV.linux.org.uk>
References: <20191017193659.GA18702@ZenIV.linux.org.uk>
 <20191017193925.25539-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Just use plain copy_from_user() and get_user().  Note that while
a buf-derived pointer gets stored into ->dxferp, all places that
actually use the resulting value feed it either to import_iovec()
or to import_single_range(), and both will do validation.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/sg.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9f6534a025cd..f3d090b93cdf 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -612,11 +612,9 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	      scsi_block_when_processing_errors(sdp->device)))
 		return -ENXIO;
 
-	if (!access_ok(buf, count))
-		return -EFAULT;	/* protects following copy_from_user()s + get_user()s */
 	if (count < SZ_SG_HEADER)
 		return -EIO;
-	if (__copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
+	if (copy_from_user(&old_hdr, buf, SZ_SG_HEADER))
 		return -EFAULT;
 	blocking = !(filp->f_flags & O_NONBLOCK);
 	if (old_hdr.reply_len < 0)
@@ -626,7 +624,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
 	buf += SZ_SG_HEADER;
-	if (__get_user(opcode, buf))
+	if (get_user(opcode, buf))
 		return -EFAULT;
 
 	if (!(srp = sg_add_request(sfp))) {
@@ -676,7 +674,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	hp->flags = input_size;	/* structure abuse ... */
 	hp->pack_id = old_hdr.pack_id;
 	hp->usr_ptr = NULL;
-	if (__copy_from_user(cmnd, buf, cmd_size))
+	if (copy_from_user(cmnd, buf, cmd_size))
 		return -EFAULT;
 	/*
 	 * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
-- 
2.11.0

