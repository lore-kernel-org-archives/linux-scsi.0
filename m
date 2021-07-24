Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 300B4C4320A
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D6660EB1
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbhGXGuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbhGXGuA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:50:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879D2C061575;
        Sat, 24 Jul 2021 00:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=j1RJyD9mm7UlJgeRfUQuWnnlzZrnaGt/MyiM73587jY=; b=GD8km7TjbNXCmeEFd7VE1pp5A2
        v5BKMomWHnlKCa518+G8Euk608BDMIcUJ+PbQOetDc+gA4mugLW6ZrKCejUkDopl0a7P8AeyoN531
        Vo4pUbAsCdJ2G6aGzAWAJzayqb6d2Dcm666gvTnM/Sb4yRXA7bh+J4Zl54oMe7XXSmb1T37Oj9fi7
        oZmY6VvW0MRWEvdBjeBPZMYvax3Y0p1XJIJTbradfkVBf+qko4F3+Py0oiTMaFAeVOLxrIZhiX4LA
        QdUAnzxnHJxRS+gpCt1rIw0Gj259eGCDnqRi7kAu2yVNZxKCHESnbpMHW/6OMy739151nu4u180pt
        kLApYgxQ==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C63-00C5QV-BB; Sat, 24 Jul 2021 07:29:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 16/24] scsi_ioctl: move scsi_command_size_tbl to scsi_common.c
Date:   Sat, 24 Jul 2021 09:20:25 +0200
Message-Id: <20210724072033.1284840-17-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the SCSI command size table towards the rest of the common SCSI
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/scsi_ioctl.c         | 8 --------
 drivers/scsi/scsi_common.c | 6 ++++++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 4d214f9ac8d0..4d023f2f43f0 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -29,14 +29,6 @@ struct blk_cmd_filter {
 
 static struct blk_cmd_filter blk_default_cmd_filter;
 
-/* Command group 3 is reserved and should never be used.  */
-const unsigned char scsi_command_size_tbl[8] =
-{
-	6, 10, 10, 12,
-	16, 12, 10, 10
-};
-EXPORT_SYMBOL(scsi_command_size_tbl);
-
 static int sg_get_version(int __user *p)
 {
 	static const int sg_version_num = 30527;
diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index 90349498f686..8aac4e5e8c4c 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -10,6 +10,12 @@
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 
+/* Command group 3 is reserved and should never be used.  */
+const unsigned char scsi_command_size_tbl[8] = {
+	6, 10, 10, 12, 16, 12, 10, 10
+};
+EXPORT_SYMBOL(scsi_command_size_tbl);
+
 /* NB: These are exposed through /proc/scsi/scsi and form part of the ABI.
  * You may not alter any existing entry (although adding new ones is
  * encouraged once assigned by ANSI/INCITS T10).
-- 
2.30.2

