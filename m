Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A49C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC06A61372
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhJTVne (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:34 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:42573 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhJTVne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:34 -0400
Received: by mail-pg1-f177.google.com with SMTP id t7so9253726pgl.9
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:41:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WzCmfJ4gaWvXwdtKf3H2v4tsOBuA/3IfJ4G/XKJwOuk=;
        b=ex4rSfgizOWz9lOBge7ZAB2JJpYtGny+W9U3r1gmzG2taSLPiMNY5jdpiBanx/pSlh
         Gi0FSDErZtJMmyNdtQxL9DZHs4pw71kGZP6C1QtxOcKTuLp1HqsStTiXXc/daM4sDgv0
         83c3yb+42KkvuRM7Srv6peHUlfjXDOtnTflh28L8U4oiC/LNmnCKOKBEp/r78OXTMC5d
         oXPMRm4jTcpIlgtbDTkGDmvEE0THFONFonC0PcynFpTrug6HQ6+1+LTI5LFr7kgJ98CH
         eVhNCTW3uOA0Gxp8ADl/u+6iUANW5czuEkTAVB54YY/pxThB+4D9JYiF4X7Nknx7v64K
         ZXtQ==
X-Gm-Message-State: AOAM533hiSZoI8KHg0FqipfYAUACvmKV+iI2TlEdgvIvqb4VxXoHbb/V
        x01/IEpv7tbzam55U46gasw=
X-Google-Smtp-Source: ABdhPJxXzcdKva+yPFKI6aL5ep+PjArlUZgjpxjiK4lgFbNQlIUzEC909EBBUBsnzFnzOiqzickhVA==
X-Received: by 2002:a63:7c53:: with SMTP id l19mr1409534pgn.36.1634766079416;
        Wed, 20 Oct 2021 14:41:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:41:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 08/10] scsi: ufs: Remove three superfluous casts
Date:   Wed, 20 Oct 2021 14:40:22 -0700
Message-Id: <20211020214024.2007615-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Casting an int explicitly to u16 when passed as an argument to a function
is not necessary.

Since prd_table and ucd_prdt_ptr both have type struct ufshcd_sg_entry *,
remove the casts from assignments of these two to each other.

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0739aa566725..7ea0588247b0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2374,9 +2374,9 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 					sizeof(struct ufshcd_sg_entry)));
 		else
 			lrbp->utr_descriptor_ptr->prd_table_length =
-				cpu_to_le16((u16) (sg_segments));
+				cpu_to_le16(sg_segments);
 
-		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
+		prd_table = lrbp->ucd_prdt_ptr;
 
 		scsi_for_each_sg(cmd, sg, sg_segments, i) {
 			prd_table[i].size  =
@@ -2668,7 +2668,7 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 	lrb->ucd_req_dma_addr = cmd_desc_element_addr;
 	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
 	lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
-	lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)cmd_descp[i].prd_table;
+	lrb->ucd_prdt_ptr = cmd_descp[i].prd_table;
 	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
 }
 
