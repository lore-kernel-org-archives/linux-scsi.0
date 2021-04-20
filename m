Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85B1C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A07FE61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhDTCPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:03 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:46037 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbhDTCO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:14:59 -0400
Received: by mail-pf1-f170.google.com with SMTP id i190so24479200pfc.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MZMCTmbSIZIUshLCt1pBIvfJPFAJSVXQEPvbH8WqsNI=;
        b=h0PGxjWB89iEOzb30wuPb2nAjBCzSt3C+3EO6mV0MkL4NQcnK87TCdJid2s5sW0ICu
         RFsxiw7Iu5W0m8HJ9zrfiIP6Qys2RLK5LF9lyk7arDXXH8P17kRxH2P8pxQZQygLr1k2
         JHeDqtAd2W7CU9A45t7YHGnmTy7jOweIJDoxfteaTQgInA13epSVe5fOT1wuV1SU2/CO
         RQG4Zt1Bcai+eae4uPVyVdt5iJUYkhMGc+vCe+T5Z+TQC+IL+XFWV6DarfoAW9XmywF4
         MkdRccen5R9b3mEGvehHCm62KG4ff+J9Tx28w1J6ou+aXyQODXP8d+Vh7zKiNEXSXfLj
         V8oQ==
X-Gm-Message-State: AOAM531ycVqsjp1p0NO4N01uIrS4/p/kfs3ezJCHosTetNgAyZx8buwM
        Cmy6lhRrRuLn4hqzqkf+D0A=
X-Google-Smtp-Source: ABdhPJyhyxzssNqt3ZrW/pMRJUUnFZLe+uZ1Iqwv0hO22eqjrT13qFbDAHKreGUaa5vHkfeUyw31lw==
X-Received: by 2002:a63:3757:: with SMTP id g23mr14617542pgn.422.1618884868858;
        Mon, 19 Apr 2021 19:14:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ondrej Zary <linux@zary.sk>
Subject: [PATCH 107/117] wd719x: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 19:13:52 -0700
Message-Id: <20210420021402.27678-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Ondrej Zary <linux@zary.sk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/wd719x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index edc8a139a60d..6861352dddd3 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -199,7 +199,7 @@ static void wd719x_finish_cmd(struct wd719x_scb *scb, int result)
 	dma_unmap_single(&wd->pdev->dev, cmd->SCp.dma_handle,
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
-	cmd->result = result << 16;
+	cmd->status.combined = result << 16;
 	cmd->scsi_done(cmd);
 }
 
@@ -294,7 +294,7 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 	dma_unmap_single(&wd->pdev->dev, scb->phys, sizeof(*scb),
 			 DMA_BIDIRECTIONAL);
 out_error:
-	cmd->result = DID_ERROR << 16;
+	cmd->status.combined = DID_ERROR << 16;
 	cmd->scsi_done(cmd);
 	return 0;
 }
