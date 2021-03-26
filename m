Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AEFC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D321861A48
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 05:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhCZF7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 01:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhCZF6x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 01:58:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C23CC0613AA;
        Thu, 25 Mar 2021 22:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=E5Oz1o3YwApZ0VyKUKJi0hPEuGJ9FeHDCsxBzoLWkVM=; b=MUNoDsPdy1Nvs9Uc0OsMY8z+3a
        +kcHoMRoaKXS44zAzSsgsmvdSBaGDjLtqCsgKgR3f+UoUzuVKvyLTvir7cv8yE1OVFTE/8cV04V3C
        4LwFeAksGODHf8fdExq2bgsupe89R9OgqPkY17Jysnbnc4OK7/FoOmgptdVjW2SxqLZL0iz+L/Dmk
        WOY1DQdYRz0BrAjfzFXhKc95EsZ14fSK6Ms+QKJ3433sj408wqiG8QOKJzZNRSSOmaV1pRSwaJuiR
        cCu0nbOTn3JbAuaXn6BEhxCqhTGYTPq0UM888j3bVhaB0V4tOMN3PPcMMlFTJNTmd3KwFI5gFRIdS
        EcBsB8CA==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfUN-005AOV-Th; Fri, 26 Mar 2021 05:58:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 3/8] BusLogic: reject broken old firmware that requires ISA-style bounce buffering
Date:   Fri, 26 Mar 2021 06:58:17 +0100
Message-Id: <20210326055822.1437471-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210326055822.1437471-1-hch@lst.de>
References: <20210326055822.1437471-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Warn on and don't support adapters that have a DMA bug that forces ISA-style
bounce buffering.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/BusLogic.c | 21 ++++++---------------
 drivers/scsi/BusLogic.h |  1 -
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index c3ed03c4b3f5cb..c8977e4bdba8c2 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -1616,14 +1616,12 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
 	   hardware bug whereby when the BIOS is enabled, transfers to/from
 	   the same address range the BIOS occupies modulo 16MB are handled
 	   incorrectly.  Only properly functioning BT-445S Host Adapters
-	   have firmware version 3.37, so require that ISA Bounce Buffers
-	   be used for the buggy BT-445S models if there is more than 16MB
-	   memory.
+	   have firmware version 3.37.
 	 */
-	if (adapter->bios_addr > 0 && strcmp(adapter->model, "BT-445S") == 0 &&
-			strcmp(adapter->fw_ver, "3.37") < 0 &&
-			(void *) high_memory > (void *) MAX_DMA_ADDRESS)
-		adapter->need_bouncebuf = true;
+	if (adapter->bios_addr > 0 &&
+	    strcmp(adapter->model, "BT-445S") == 0 &&
+	    strcmp(adapter->fw_ver, "3.37") < 0)
+		return blogic_failure(adapter, "Too old firmware");
 	/*
 	   Initialize parameters common to MultiMaster and FlashPoint
 	   Host Adapters.
@@ -1646,14 +1644,9 @@ static bool __init blogic_rdconfig(struct blogic_adapter *adapter)
 		if (adapter->drvr_opts != NULL &&
 				adapter->drvr_opts->qdepth[tgt_id] > 0)
 			qdepth = adapter->drvr_opts->qdepth[tgt_id];
-		else if (adapter->need_bouncebuf)
-			qdepth = BLOGIC_TAG_DEPTH_BB;
 		adapter->qdepth[tgt_id] = qdepth;
 	}
-	if (adapter->need_bouncebuf)
-		adapter->untag_qdepth = BLOGIC_UNTAG_DEPTH_BB;
-	else
-		adapter->untag_qdepth = BLOGIC_UNTAG_DEPTH;
+	adapter->untag_qdepth = BLOGIC_UNTAG_DEPTH;
 	if (adapter->drvr_opts != NULL)
 		adapter->common_qdepth = adapter->drvr_opts->common_qdepth;
 	if (adapter->common_qdepth > 0 &&
@@ -2155,7 +2148,6 @@ static void __init blogic_inithoststruct(struct blogic_adapter *adapter,
 	host->this_id = adapter->scsi_id;
 	host->can_queue = adapter->drvr_qdepth;
 	host->sg_tablesize = adapter->drvr_sglimit;
-	host->unchecked_isa_dma = adapter->need_bouncebuf;
 	host->cmd_per_lun = adapter->untag_qdepth;
 }
 
@@ -3705,7 +3697,6 @@ static struct scsi_host_template blogic_template = {
 #if 0
 	.eh_abort_handler = blogic_abort,
 #endif
-	.unchecked_isa_dma = 1,
 	.max_sectors = 128,
 };
 
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 6eaddc009b5c55..858187af8fd1e8 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1010,7 +1010,6 @@ struct blogic_adapter {
 	bool terminfo_valid:1;
 	bool low_term:1;
 	bool high_term:1;
-	bool need_bouncebuf:1;
 	bool strict_rr:1;
 	bool scam_enabled:1;
 	bool scam_lev2:1;
-- 
2.30.1

