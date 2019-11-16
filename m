Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568DFC43141
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 15:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C9520815
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573919953;
	bh=zVi3l48Dj1pEq/lXVT7CWip3HEIXhUTRhaX6jVURMJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=13W8OFiQ9PSwIrUH7ozY4OOECIuNsn6DV5tfTzZrTgA5yGg8qnarV/fDKSCO7y+tM
	 36wraopY9Fo01gyXCx8Cy86m1sJcCpI0l+wM07mZq7A/C6m+M2lUOPjbbN/7+GNu8e
	 Evw3pMPmCuRlIw7mMuOLbDL3M1912EnmS4HTOU08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731377AbfKPPyC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:54:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbfKPPyB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:54:01 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB5621887;
        Sat, 16 Nov 2019 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919641;
        bh=zVi3l48Dj1pEq/lXVT7CWip3HEIXhUTRhaX6jVURMJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kioNrNgOVRD2g7/dc5dmPBGmEwFRECRaRvhm+AdzAMgDFv0TVeFUkMHl2dx+8Y5Gs
         euKZ6W07smyfsVQcTn8ObLNZc2AxjtxUR3IzzFPtKy3zsZCyOkRQc1krtYX5yLlDKj
         7rC3DmmrXvnTExbadSJZXJgB5BI/JPsPGBBydApI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, dc395x@twibble.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 20/77] scsi: dc395x: fix dma API usage in srb_done
Date:   Sat, 16 Nov 2019 10:52:42 -0500
Message-Id: <20191116155339.11909-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155339.11909-1-sashal@kernel.org>
References: <20191116155339.11909-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3a5bd7021184dec2946f2a4d7a8943f8a5713e52 ]

We can't just transfer ownership to the CPU and then unmap, as this will
break with swiotlb.

Instead unmap the command and sense buffer a little earlier in the I/O
completion handler and get rid of the pci_dma_sync_sg_for_cpu call
entirely.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/dc395x.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 5ee7f44cf869b..9da0ac360848f 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3450,14 +3450,12 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 		}
 	}
 
-	if (dir != PCI_DMA_NONE && scsi_sg_count(cmd))
-		pci_dma_sync_sg_for_cpu(acb->dev, scsi_sglist(cmd),
-					scsi_sg_count(cmd), dir);
-
 	ckc_only = 0;
 /* Check Error Conditions */
       ckc_e:
 
+	pci_unmap_srb(acb, srb);
+
 	if (cmd->cmnd[0] == INQUIRY) {
 		unsigned char *base = NULL;
 		struct ScsiInqData *ptr;
@@ -3511,7 +3509,6 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 			cmd, cmd->result);
 		srb_free_insert(acb, srb);
 	}
-	pci_unmap_srb(acb, srb);
 
 	cmd->scsi_done(cmd);
 	waiting_process_next(acb);
-- 
2.20.1

