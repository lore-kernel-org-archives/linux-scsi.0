Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7587DC07E9B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA57610CB
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhGLF6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhGLF6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:58:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F4DC0613DD;
        Sun, 11 Jul 2021 22:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8AfnmbpUDdkLdltELGG87m4a8NMpkulaxYq3rJ/t8x8=; b=B6XqSu+hm7k3+fZTWGYDq6RlnS
        6ahS9uZyX4aXvdbY3gnKlBmz5P5TcoBRiGTZyALr7zxYM9Z3acZmIT3vOt6jrWyfm3tasrvasq7wN
        SdfhARUbsFkPDueIkka+26nug4crcRcAvHpsAoPhh5AL0qWD8f9INzjOGvA3YP8Vx8OVsCMIjHJXr
        zG69oHc5r6l/PBwZe6GixehfjnmJOSos3FL7OCW7F+zEtrO2k8eL3d8lV/gK95dRIJusha5T6MadA
        DKjhQfNiF7Gjhw7TXaIgh77m3cyBPhFwpXo/AixK+ruZS4gmmNxSuOFq5H93WjP+fIquFdJIk6Oor
        O6Or5f3Q==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ouD-00GvPa-3Y; Mon, 12 Jul 2021 05:55:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 16/24] scsi_ioctl: move scsi_command_size_tbl to scsi_common.c
Date:   Mon, 12 Jul 2021 07:48:08 +0200
Message-Id: <20210712054816.4147559-17-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
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
index 76fbe5287876..ccc06b8e88c6 100644
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

