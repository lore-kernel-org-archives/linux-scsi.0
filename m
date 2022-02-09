Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CDCC43219
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbiBII2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:28:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbiBII2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:28:39 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D17BC05CBB4;
        Wed,  9 Feb 2022 00:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OEk2XaHb/rIimZjLxXur2nVVRIHACoTITsr2juHinrU=; b=IWwc9YcE+T5I1KZX+iZQFBfo8s
        KqCPMQVK2jizPUXyJzEj5gFfV2vJjVKBTqkaYzxbZ0FmcN8NyTvegdeaeG0kQG5Cmw3jDEcu+iAAN
        Mtdb5PFwL/3TYzxq9Xncw6uNog4v729g/7S19ffEiK6ua785n8bH1lwlEOMw+UznkTm//CaQ3vuNl
        htQXLe8Vmsehp6tMVwAYl6EdfWOlpivdIiP3Un+S3aIHQdK5FAHEKGMWZJtxqtQ/7M6XrXeY3ebk9
        U5DfMStSECKMOWMIwFNYgq23XBgRG0tXdj6m645JXOssrtce9mvxDHVB/pjjweJUDr18JDFzyMhzu
        hi8lCXpA==;
Received: from [2001:4bb8:188:3efc:ea2:7599:7eeb:4b5a] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHiL4-00Gc81-RG; Wed, 09 Feb 2022 08:28:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk, martin.petersen@oracle.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        target-devel@vger.kernel.org, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, manoj@linux.ibm.com, mrochs@linux.ibm.com,
        ukrishn@linux.ibm.com
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        drbd-dev@lists.linbit.com, dm-devel@redhat.com
Subject: [PATCH 1/7] cxlflash: query write_zeroes limit for zeroing
Date:   Wed,  9 Feb 2022 09:28:22 +0100
Message-Id: <20220209082828.2629273-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209082828.2629273-1-hch@lst.de>
References: <20220209082828.2629273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The write_same and write_zeroes limits for SCSI are effectively the
same, so the current code works just fine.  But we plan to remove
REQ_OP_WRITE_SAME support, so switch to quering the write zeroes
limit for a zeroing WRITE SAME operation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/cxlflash/vlun.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 01917b28cdb65..5c74dc7c22889 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -430,8 +430,8 @@ static int write_same16(struct scsi_device *sdev,
 	struct device *dev = &cfg->dev->dev;
 	const u32 s = ilog2(sdev->sector_size) - 9;
 	const u32 to = sdev->request_queue->rq_timeout;
-	const u32 ws_limit = blk_queue_get_max_sectors(sdev->request_queue,
-						       REQ_OP_WRITE_SAME) >> s;
+	const u32 ws_limit =
+		sdev->request_queue->limits.max_write_zeroes_sectors >> s;
 
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
-- 
2.30.2

