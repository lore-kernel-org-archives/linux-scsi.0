Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D45C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 10:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D60C061261
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 10:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhEWKLW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 06:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhEWKLV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 May 2021 06:11:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAF0461104;
        Sun, 23 May 2021 10:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621764595;
        bh=5PDHav9zp2dY9e6einy81yp68RKbKU1/fmlcuV3tfBg=;
        h=Subject:To:From:Date:From;
        b=roGFW6J41J12O3K5s7lbu5qqQN9rQxjgn4g7P+8QFkbe9TxkDV/CxoYZHsWpOlVce
         sybBEbDwqMvHTZ0QS22H9BkCLY2CCnvPIQcVoYjJPeWOemT/Ebv8x6XahHHhBRK0Ou
         t8mSJXCjQsJq0MMFfb6/BPObVnnWSmbnQwGxpwv0=
Subject: patch "scsi: snic: debugfs: remove local storage of debugfs files" added to driver-core-next
To:     gregkh@linuxfoundation.org, jejb@linux.ibm.com, kartilak@cisco.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sebaddel@cisco.com
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 May 2021 12:09:43 +0200
Message-ID: <162176458322128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    scsi: snic: debugfs: remove local storage of debugfs files

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 1be4ec2456a7d110092ad8cc918eef75b878ec4e Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 18 May 2021 18:16:25 +0200
Subject: scsi: snic: debugfs: remove local storage of debugfs files

There is no need to keep the dentry around for the debugfs trace files,
as we can just look it up when we want to remove it later on.  Simplify
the structure by removing the dentries and relying on debugfs to find
the dentry to remove when we want to.

By doing this change, we remove the last in-kernel user that was storing
the result of debugfs_create_bool(), so that api can be cleaned up.

Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
Link: https://lore.kernel.org/r/20210518161625.3696996-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/snic/snic_debugfs.c | 23 +++++++++--------------
 drivers/scsi/snic/snic_trc.h     |  3 ---
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 3aeee856d5c7..5e0faeba516e 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -430,21 +430,19 @@ static const struct seq_operations snic_trc_sops = {
 
 DEFINE_SEQ_ATTRIBUTE(snic_trc);
 
+#define TRC_ENABLE_FILE	"tracing_enable"
+#define TRC_FILE	"trace"
 /*
  * snic_trc_debugfs_init : creates trace/tracing_enable files for trace
  * under debugfs
  */
 void snic_trc_debugfs_init(void)
 {
-	snic_glob->trc.trc_enable = debugfs_create_bool("tracing_enable",
-							S_IFREG | S_IRUGO | S_IWUSR,
-							snic_glob->trc_root,
-							&snic_glob->trc.enable);
-
-	snic_glob->trc.trc_file = debugfs_create_file("trace",
-						      S_IFREG | S_IRUGO | S_IWUSR,
-						      snic_glob->trc_root, NULL,
-						      &snic_trc_fops);
+	debugfs_create_bool(TRC_ENABLE_FILE, S_IFREG | S_IRUGO | S_IWUSR,
+			    snic_glob->trc_root, &snic_glob->trc.enable);
+
+	debugfs_create_file(TRC_FILE, S_IFREG | S_IRUGO | S_IWUSR,
+			    snic_glob->trc_root, NULL, &snic_trc_fops);
 }
 
 /*
@@ -453,9 +451,6 @@ void snic_trc_debugfs_init(void)
 void
 snic_trc_debugfs_term(void)
 {
-	debugfs_remove(snic_glob->trc.trc_file);
-	snic_glob->trc.trc_file = NULL;
-
-	debugfs_remove(snic_glob->trc.trc_enable);
-	snic_glob->trc.trc_enable = NULL;
+	debugfs_remove(debugfs_lookup(TRC_FILE, snic_glob->trc_root));
+	debugfs_remove(debugfs_lookup(TRC_ENABLE_FILE, snic_glob->trc_root));
 }
diff --git a/drivers/scsi/snic/snic_trc.h b/drivers/scsi/snic/snic_trc.h
index 87dcc7457d15..ce305b4b8fa2 100644
--- a/drivers/scsi/snic/snic_trc.h
+++ b/drivers/scsi/snic/snic_trc.h
@@ -46,9 +46,6 @@ struct snic_trc {
 	u32	rd_idx;
 	u32	wr_idx;
 	bool	enable;			/* Control Variable for Tracing */
-
-	struct dentry *trc_enable;	/* debugfs file object */
-	struct dentry *trc_file;
 };
 
 int snic_trc_init(void);
-- 
2.31.1


