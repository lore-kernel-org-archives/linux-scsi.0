Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35903C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5AB2064C
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 08:41:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UVJYui/8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgJEIlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 04:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgJEIlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 04:41:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38495C0613CE
        for <linux-scsi@vger.kernel.org>; Mon,  5 Oct 2020 01:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=THGc7HoQjObLGNgGriqHXUqM7fccgIra80Lxyex2gd8=; b=UVJYui/8GU6q13mQ0hk2Mh7f9h
        N46azw8tYgNLzaEVozCyrA43GZbwNs/mpHuY7HbANr9R7ZB2uL6tGvAzgAq8w5fTKmBusliepWXFV
        pEsCB1PcE4LVp3gARcQuvUp8wIaWpq637K8y2X6D1vw7ME4TNZK1URWWdB7CVxBSjuQy0FiUL/Gl8
        WBuy8xR5XRV65VvN66IF11LNvRS0qQVwv4/9ugyUgOLKNHF1wi07XNjPbukqryNkUQThjhRzWLHsK
        SHs5YrlJoijOEj9l0h2Bgver0NfBwYJLcn9EtoeRFkdTNqAX2PeZnFOU0iGG902r8QBVk+xVmIoaB
        9Bl0Ql/g==;
Received: from [2001:4bb8:184:92a2:b8a4:f4a0:f053:4f06] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPM3u-0000m6-Jc; Mon, 05 Oct 2020 08:41:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH 05/10] scsi: use rq_dma_dir in scsi_setup_cmnd
Date:   Mon,  5 Oct 2020 10:41:25 +0200
Message-Id: <20201005084130.143273-6-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005084130.143273-1-hch@lst.de>
References: <20201005084130.143273-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3c551f06ebe9be..670ad06812b419 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1200,12 +1200,7 @@ static blk_status_t scsi_setup_cmnd(struct scsi_device *sdev,
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	blk_status_t ret;
 
-	if (!blk_rq_bytes(req))
-		cmd->sc_data_direction = DMA_NONE;
-	else if (rq_data_dir(req) == WRITE)
-		cmd->sc_data_direction = DMA_TO_DEVICE;
-	else
-		cmd->sc_data_direction = DMA_FROM_DEVICE;
+	cmd->sc_data_direction = rq_dma_dir(req);
 
 	if (blk_rq_is_scsi(req))
 		ret = scsi_setup_scsi_cmnd(sdev, req);
-- 
2.28.0

