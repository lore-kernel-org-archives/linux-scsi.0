Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2A9ECE58E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F67D20650
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 19:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439721AbfJQTjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 15:39:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45054 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437644AbfJQTjp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 15:39:45 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLBcd-0006f9-Ec; Thu, 17 Oct 2019 19:39:43 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     linux-scsi@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC PATCH 3/8] sg_write(): __get_user() can fail...
Date:   Thu, 17 Oct 2019 20:39:20 +0100
Message-Id: <20191017193925.25539-3-viro@ZenIV.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/sg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 026628aa556d..4c62237cdf37 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -640,13 +640,15 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	if (count < (SZ_SG_HEADER + 6))
 		return -EIO;	/* The minimum scsi command length is 6 bytes. */
 
+	buf += SZ_SG_HEADER;
+	if (__get_user(opcode, buf))
+		return -EFAULT;
+
 	if (!(srp = sg_add_request(sfp))) {
 		SCSI_LOG_TIMEOUT(1, sg_printk(KERN_INFO, sdp,
 					      "sg_write: queue full\n"));
 		return -EDOM;
 	}
-	buf += SZ_SG_HEADER;
-	__get_user(opcode, buf);
 	mutex_lock(&sfp->f_mutex);
 	if (sfp->next_cmd_len > 0) {
 		cmd_size = sfp->next_cmd_len;
-- 
2.11.0

