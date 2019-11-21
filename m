Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5692C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 12:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C21520855
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 12:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=shipmail.org header.i=@shipmail.org header.b="DhQtwEVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKUMBs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 07:01:48 -0500
Received: from ste-pvt-msa2.bahnhof.se ([213.80.101.71]:61503 "EHLO
        ste-pvt-msa2.bahnhof.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUMBr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 07:01:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 173E53F5A2;
        Thu, 21 Nov 2019 12:52:43 +0100 (CET)
Authentication-Results: ste-pvt-msa2.bahnhof.se;
        dkim=pass (1024-bit key; unprotected) header.d=shipmail.org header.i=@shipmail.org header.b=DhQtwEVk;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Authentication-Results: ste-ftg-msa2.bahnhof.se (amavisd-new);
        dkim=pass (1024-bit key) header.d=shipmail.org
Received: from ste-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (ste-ftg-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5QL1eylg0w_I; Thu, 21 Nov 2019 12:52:42 +0100 (CET)
Received: from mail1.shipmail.org (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        (Authenticated sender: mb878879)
        by ste-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id 6611E3F59D;
        Thu, 21 Nov 2019 12:52:41 +0100 (CET)
Received: from localhost.localdomain.localdomain (h-205-35.A357.priv.bahnhof.se [155.4.205.35])
        by mail1.shipmail.org (Postfix) with ESMTPSA id DFFD13601A3;
        Thu, 21 Nov 2019 12:52:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=shipmail.org; s=mail;
        t=1574337160; bh=GgpXsnJVZPKyPe+h+0gIt+VQkmGTuW5nmRdMrtnMCT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhQtwEVknumPNenH6P8RzVcvRF39BpRQFFa59wO9swleFk3W+XhR0GqFSLUA7zvvP
         GGTeCmX3cbDSVDGuZd11NrWNJLaNpuOAtUFKqydn2H4bEEiHpxF4j8zvsA04ORBiYt
         qHAElm5tKUqVNMazxruCP8mFnCmf1RFSLXHybl5o=
From:   =?UTF-8?q?Thomas=20Hellstr=C3=B6m=20=28VMware=29?= 
        <thomas_os@shipmail.org>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Cc:     Thomas Hellstrom <thellstrom@vmware.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jim Gill <jgill@vmware.com>
Subject: [PATCH 2/2] scsi: vmw_pvscsi: Silence dma mapping errors
Date:   Thu, 21 Nov 2019 12:52:04 +0100
Message-Id: <20191121115204.53060-2-thomas_os@shipmail.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191121115204.53060-1-thomas_os@shipmail.org>
References: <20191121115204.53060-1-thomas_os@shipmail.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

These errors typically occur with swiotlb when the swiotlb buffer is full.
But they are transient and would typically unnecessarily worry a user.
Instead of errors, print debug messages.

Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Acked-by: Jim Gill <jgill@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 8a09d184a320..c3f010df641e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -365,7 +365,7 @@ static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
 		int segs = scsi_dma_map(cmd);
 
 		if (segs == -ENOMEM) {
-			scmd_printk(KERN_ERR, cmd,
+			scmd_printk(KERN_DEBUG, cmd,
 				    "vmw_pvscsi: Failed to map cmd sglist for DMA.\n");
 			return -ENOMEM;
 		} else if (segs > 1) {
@@ -392,7 +392,7 @@ static int pvscsi_map_buffers(struct pvscsi_adapter *adapter,
 		ctx->dataPA = dma_map_single(&adapter->dev->dev, sg, bufflen,
 					     cmd->sc_data_direction);
 		if (dma_mapping_error(&adapter->dev->dev, ctx->dataPA)) {
-			scmd_printk(KERN_ERR, cmd,
+			scmd_printk(KERN_DEBUG, cmd,
 				    "vmw_pvscsi: Failed to map direct data buffer for DMA.\n");
 			return -ENOMEM;
 		}
@@ -725,7 +725,7 @@ static int pvscsi_queue_ring(struct pvscsi_adapter *adapter,
 				cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				DMA_FROM_DEVICE);
 		if (dma_mapping_error(&adapter->dev->dev, ctx->sensePA)) {
-			scmd_printk(KERN_ERR, cmd,
+			scmd_printk(KERN_DEBUG, cmd,
 				    "vmw_pvscsi: Failed to map sense buffer for DMA.\n");
 			ctx->sensePA = 0;
 			return -ENOMEM;
-- 
2.21.0

