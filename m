Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1017C47255
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 23:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC68921473
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 23:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgEIXqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 May 2020 19:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728918AbgEIXqI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2020 19:46:08 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C155C061A0C;
        Sat,  9 May 2020 16:46:08 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXZAO-004iSV-BF; Sat, 09 May 2020 23:46:00 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 17/20] lpfc_debugfs: get rid of pointless access_ok()
Date:   Sun, 10 May 2020 00:45:54 +0100
Message-Id: <20200509234557.1124086-17-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509234557.1124086-1-viro@ZenIV.linux.org.uk>
References: <20200509234124.GM23230@ZenIV.linux.org.uk>
 <20200509234557.1124086-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

	No, you do NOT need to "protect copy from user" that way.
Incidentally, your userland ABI stinks.  I understand that you
wanted to accept "reset" and "reset\n" as equivalent, but I suspect
that accepting "reset this, you !@^!@!" had been an accident.
Nothing to do about that now - it is a userland ABI...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 8a6e02aa553f..5a754fb5f854 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2166,10 +2166,6 @@ lpfc_debugfs_lockstat_write(struct file *file, const char __user *buf,
 	char *pbuf;
 	int i;
 
-	/* Protect copy from user */
-	if (!access_ok(buf, nbytes))
-		return -EFAULT;
-
 	memset(mybuf, 0, sizeof(mybuf));
 
 	if (copy_from_user(mybuf, buf, nbytes))
@@ -2621,10 +2617,6 @@ lpfc_debugfs_multixripools_write(struct file *file, const char __user *buf,
 	if (nbytes > 64)
 		nbytes = 64;
 
-	/* Protect copy from user */
-	if (!access_ok(buf, nbytes))
-		return -EFAULT;
-
 	memset(mybuf, 0, sizeof(mybuf));
 
 	if (copy_from_user(mybuf, buf, nbytes))
@@ -2787,10 +2779,6 @@ lpfc_debugfs_scsistat_write(struct file *file, const char __user *buf,
 	char mybuf[6] = {0};
 	int i;
 
-	/* Protect copy from user */
-	if (!access_ok(buf, nbytes))
-		return -EFAULT;
-
 	if (copy_from_user(mybuf, buf, (nbytes >= sizeof(mybuf)) ?
 				       (sizeof(mybuf) - 1) : nbytes))
 		return -EFAULT;
-- 
2.11.0

