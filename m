Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B430ECE58E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DABEA20650
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439958AbfJQTjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:39:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45066 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437753AbfJQTjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 15:39:46 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLBce-0006fW-06; Thu, 17 Oct 2019 19:39:44 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     linux-scsi@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 6/8] sg_read(): get rid of access_ok()/__copy_..._user()
Date:   Thu, 17 Oct 2019 20:39:23 +0100
Message-Id: <20191017193925.25539-6-viro@ZenIV.linux.org.uk>
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

Use copy_..._user() instead, both in sg_read() and in sg_read_oxfer().
And don't open-code memdup_user()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/sg.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3702f66493f7..9f6534a025cd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -429,16 +429,10 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				      "sg_read: count=%d\n", (int) count));
 
-	if (!access_ok(buf, count))
-		return -EFAULT;
 	if (sfp->force_packid && (count >= SZ_SG_HEADER)) {
-		old_hdr = kmalloc(SZ_SG_HEADER, GFP_KERNEL);
-		if (!old_hdr)
-			return -ENOMEM;
-		if (__copy_from_user(old_hdr, buf, SZ_SG_HEADER)) {
-			retval = -EFAULT;
-			goto free_old_hdr;
-		}
+		old_hdr = memdup_user(buf, SZ_SG_HEADER);
+		if (IS_ERR(old_hdr))
+			return PTR_ERR(old_hdr);
 		if (old_hdr->reply_len < 0) {
 			if (count >= SZ_SG_IO_HDR) {
 				sg_io_hdr_t __user *p = (void __user *)buf;
@@ -529,7 +523,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 
 	/* Now copy the result back to the user buffer.  */
 	if (count >= SZ_SG_HEADER) {
-		if (__copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
+		if (copy_to_user(buf, old_hdr, SZ_SG_HEADER)) {
 			retval = -EFAULT;
 			goto free_old_hdr;
 		}
@@ -1960,12 +1954,12 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	num = 1 << (PAGE_SHIFT + schp->page_order);
 	for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
 		if (num > num_read_xfer) {
-			if (__copy_to_user(outp, page_address(schp->pages[k]),
+			if (copy_to_user(outp, page_address(schp->pages[k]),
 					   num_read_xfer))
 				return -EFAULT;
 			break;
 		} else {
-			if (__copy_to_user(outp, page_address(schp->pages[k]),
+			if (copy_to_user(outp, page_address(schp->pages[k]),
 					   num))
 				return -EFAULT;
 			num_read_xfer -= num;
-- 
2.11.0

