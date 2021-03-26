Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7773C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAEC061A38
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCZF7P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 01:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhCZF6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 01:58:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A28C0613B0;
        Thu, 25 Mar 2021 22:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=X0mTB17u4X56qha0KVy3ncQBqzZpXhHbkl0cffm7+as=; b=fdiJ5zaTJA9mLVGMnhciZypwsM
        +WH8S+85w1jE/cAmwzqSGIgaZFojHM5HWpiqCzAZXokRkvaQpWOg6GYtmYUAWe+EB6gcwJt+ITNna
        klVkdgQsBd9VlDF5om24eSRjyYnC7t+aEyn9tCMwirxfWIzLhjARHC8N5XctBCKhOrGgFsia3E0sN
        cgb7vNL9yhJSJiCR0/00kHrDgMIaLjK/zNdoFLq6zjXP4R7XDWhxJEXmo2Fr00urcY+npRWhrRFxH
        kGQJObK6xAUdwPzydSnbmOy88kEjc60NyJlczoDR4xMSKGMabkqREbiT6oBSjhQMfTtukyaWJaGqF
        Kb3CgkzQ==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfUI-005AOH-Vm; Fri, 26 Mar 2021 05:58:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/8] aha1542: use a local bounce buffer
Date:   Fri, 26 Mar 2021 06:58:15 +0100
Message-Id: <20210326055822.1437471-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210326055822.1437471-1-hch@lst.de>
References: <20210326055822.1437471-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To remove the last user of the unchecked_isa_dma flag and thus the block
layer ISA bounce buffering switch this driver to use its own local bounce
buffer.  This has the effect of not needing the chain indirection and
supporting and unlimited number of segments.  It does however limit the
transfer size for each command to something that can be reasonable
allocated by dma_alloc_coherent like 8K.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aha1542.c | 105 ++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 21aab9f5b1172a..1210e61afb1838 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -65,9 +65,12 @@ struct aha1542_hostdata {
 	dma_addr_t ccb_handle;
 };
 
+#define AHA1542_MAX_SECTORS       16
+
 struct aha1542_cmd {
-	struct chain *chain;
-	dma_addr_t chain_handle;
+	/* bounce buffer */
+	void *data_buffer;
+	dma_addr_t data_buffer_handle;
 };
 
 static inline void aha1542_intr_reset(u16 base)
@@ -257,15 +260,19 @@ static int aha1542_test_port(struct Scsi_Host *sh)
 static void aha1542_free_cmd(struct scsi_cmnd *cmd)
 {
 	struct aha1542_cmd *acmd = scsi_cmd_priv(cmd);
-	struct device *dev = cmd->device->host->dma_dev;
-	size_t len = scsi_sg_count(cmd) * sizeof(struct chain);
 
-	if (acmd->chain) {
-		dma_unmap_single(dev, acmd->chain_handle, len, DMA_TO_DEVICE);
-		kfree(acmd->chain);
+	if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		void *buf = acmd->data_buffer;
+		struct req_iterator iter;
+		struct bio_vec bv;
+
+		rq_for_each_segment(bv, cmd->request, iter) {
+			memcpy_to_page(bv.bv_page, bv.bv_offset, buf,
+				       bv.bv_len);
+			buf += bv.bv_len;
+		}
 	}
 
-	acmd->chain = NULL;
 	scsi_dma_unmap(cmd);
 }
 
@@ -416,7 +423,7 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	u8 lun = cmd->device->lun;
 	unsigned long flags;
 	int bufflen = scsi_bufflen(cmd);
-	int mbo, sg_count;
+	int mbo;
 	struct mailbox *mb = aha1542->mb;
 	struct ccb *ccb = aha1542->ccb;
 
@@ -438,17 +445,17 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		print_hex_dump_bytes("command: ", DUMP_PREFIX_NONE, cmd->cmnd, cmd->cmd_len);
 	}
 #endif
-	sg_count = scsi_dma_map(cmd);
-	if (sg_count) {
-		size_t len = sg_count * sizeof(struct chain);
-
-		acmd->chain = kmalloc(len, GFP_DMA);
-		if (!acmd->chain)
-			goto out_unmap;
-		acmd->chain_handle = dma_map_single(sh->dma_dev, acmd->chain,
-				len, DMA_TO_DEVICE);
-		if (dma_mapping_error(sh->dma_dev, acmd->chain_handle))
-			goto out_free_chain;
+
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		void *buf = acmd->data_buffer;
+		struct req_iterator iter;
+		struct bio_vec bv;
+
+		rq_for_each_segment(bv, cmd->request, iter) {
+			memcpy_from_page(buf, bv.bv_page, bv.bv_offset,
+					 bv.bv_len);
+			buf += bv.bv_len;
+		}
 	}
 
 	/*
@@ -496,27 +503,12 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 		direction = 16;
 
 	memcpy(ccb[mbo].cdb, cmd->cmnd, ccb[mbo].cdblen);
-
-	if (bufflen) {
-		struct scatterlist *sg;
-		int i;
-
-		ccb[mbo].op = 2;	/* SCSI Initiator Command  w/scatter-gather */
-		scsi_for_each_sg(cmd, sg, sg_count, i) {
-			any2scsi(acmd->chain[i].dataptr, sg_dma_address(sg));
-			any2scsi(acmd->chain[i].datalen, sg_dma_len(sg));
-		};
-		any2scsi(ccb[mbo].datalen, sg_count * sizeof(struct chain));
-		any2scsi(ccb[mbo].dataptr, acmd->chain_handle);
-#ifdef DEBUG
-		shost_printk(KERN_DEBUG, sh, "cptr %p: ", acmd->chain);
-		print_hex_dump_bytes("cptr: ", DUMP_PREFIX_NONE, acmd->chain, 18);
-#endif
-	} else {
-		ccb[mbo].op = 0;	/* SCSI Initiator Command */
-		any2scsi(ccb[mbo].datalen, 0);
+	ccb[mbo].op = 0;	/* SCSI Initiator Command */
+	any2scsi(ccb[mbo].datalen, bufflen);
+	if (bufflen)
+		any2scsi(ccb[mbo].dataptr, acmd->data_buffer_handle);
+	else
 		any2scsi(ccb[mbo].dataptr, 0);
-	};
 	ccb[mbo].idlun = (target & 7) << 5 | direction | (lun & 7);	/*SCSI Target Id */
 	ccb[mbo].rsalen = 16;
 	ccb[mbo].linkptr[0] = ccb[mbo].linkptr[1] = ccb[mbo].linkptr[2] = 0;
@@ -531,12 +523,6 @@ static int aha1542_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	spin_unlock_irqrestore(sh->host_lock, flags);
 
 	return 0;
-out_free_chain:
-	kfree(acmd->chain);
-	acmd->chain = NULL;
-out_unmap:
-	scsi_dma_unmap(cmd);
-	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
 /* Initialize mailboxes */
@@ -1027,6 +1013,27 @@ static int aha1542_biosparam(struct scsi_device *sdev,
 }
 MODULE_LICENSE("GPL");
 
+static int aha1542_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	struct aha1542_cmd *acmd = scsi_cmd_priv(cmd);
+
+	acmd->data_buffer = dma_alloc_coherent(shost->dma_dev,
+			SECTOR_SIZE * AHA1542_MAX_SECTORS,
+			&acmd->data_buffer_handle, GFP_KERNEL);
+	if (!acmd->data_buffer)
+		return -ENOMEM;
+	return 0;
+}
+
+static int aha1542_exit_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	struct aha1542_cmd *acmd = scsi_cmd_priv(cmd);
+
+	dma_free_coherent(shost->dma_dev, SECTOR_SIZE * AHA1542_MAX_SECTORS,
+			acmd->data_buffer, acmd->data_buffer_handle);
+	return 0;
+}
+
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "aha1542",
@@ -1037,10 +1044,12 @@ static struct scsi_host_template driver_template = {
 	.eh_bus_reset_handler	= aha1542_bus_reset,
 	.eh_host_reset_handler	= aha1542_host_reset,
 	.bios_param		= aha1542_biosparam,
+	.init_cmd_priv		= aha1542_init_cmd_priv,
+	.exit_cmd_priv		= aha1542_exit_cmd_priv,
 	.can_queue		= AHA1542_MAILBOXES,
 	.this_id		= 7,
-	.sg_tablesize		= 16,
-	.unchecked_isa_dma	= 1,
+	.max_sectors		= AHA1542_MAX_SECTORS,
+	.sg_tablesize		= SG_ALL,
 };
 
 static int aha1542_isa_match(struct device *pdev, unsigned int ndev)
-- 
2.30.1

