Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11395ECE58D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E177A20650
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436975AbfJQTkN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:40:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45062 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437743AbfJQTjp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 15:39:45 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLBcd-0006fP-Rw; Thu, 17 Oct 2019 19:39:43 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     linux-scsi@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 5/8] sg_new_write(): don't bother with access_ok
Date:   Thu, 17 Oct 2019 20:39:22 +0100
Message-Id: <20191017193925.25539-5-viro@ZenIV.linux.org.uk>
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

... just use copy_from_user().  We copy only SZ_SG_IO_HDR bytes,
so that would, strictly speaking, loosen the check.  However,
for call chains via ->write() the caller has actually checked
the entire range and SG_IO passes exactly SZ_SG_IO_HDR for count.
So no visible behaviour changes happen if we check only what
we really need for copyin.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/sg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2d30e89075e9..3702f66493f7 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -717,8 +717,6 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 
 	if (count < SZ_SG_IO_HDR)
 		return -EINVAL;
-	if (!access_ok(buf, count))
-		return -EFAULT; /* protects following copy_from_user()s + get_user()s */
 
 	sfp->cmd_q = 1;	/* when sg_io_hdr seen, set command queuing on */
 	if (!(srp = sg_add_request(sfp))) {
@@ -728,7 +726,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	}
 	srp->sg_io_owned = sg_io_owned;
 	hp = &srp->header;
-	if (__copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
+	if (copy_from_user(hp, buf, SZ_SG_IO_HDR)) {
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
-- 
2.11.0

