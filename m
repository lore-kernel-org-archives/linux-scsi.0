Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141B3C33C9E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB5EA2087F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgAGTZn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 14:25:43 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44206 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTZn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 14:25:43 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so318235pgl.11
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2020 11:25:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gW3m5tTdQj9zJwgo4vo7pUuxKViLM0UkWa2sIurIyBY=;
        b=U0Cefcki62ItT1aSn9zC9LoR3+XlV1YRBhNZIbYbuLhzivs76Po5MQcIE/vBqfzkj7
         jPqAma9TR1Ojb2Xh5RW1BpNQOxTa2rA4f1w3MmUzdHiAiNh5eWoe7hOgR1sjRYuv+qUl
         fbCeKt+l1k4NNCNPttbBkNFQuDxBO61j7GHiGUCg3NK7ZC/01mrnDhat9JqwZbxke4Iq
         hFFTm5a32NM7how3ruk8hqY974he+xwkzNrTZzRF6gA02tDoFYGMzh49y8tI9aMye4ED
         WhpNjp/xLwQDn4n/Y/qPI26mRPE6/6QNjk/E9142YnEbDPBb+2ShI+0Jn+Ct3G1d8V46
         rDDw==
X-Gm-Message-State: APjAAAVqQawtNTOw9uvvQgxEzV779428LvXZg6Qh3mIzfXHiCkHoU/dQ
        YXyPWYBPAGVyIhW3UZT1sXo=
X-Google-Smtp-Source: APXvYqxlyGVgdG54RlTxdIXUI3xmUQCQzuVVZPa24+/K39DrZ6egRjdvSZJCYKeDdwtIQ4yGdVonzA==
X-Received: by 2002:a63:5809:: with SMTP id m9mr1102704pgb.26.1578425142571;
        Tue, 07 Jan 2020 11:25:42 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c2sm329051pjq.27.2020.01.07.11.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 11:25:41 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 2/4] ufs: Introduce ufshcd_init_lrb()
Date:   Tue,  7 Jan 2020 11:25:29 -0800
Message-Id: <20200107192531.73802-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20200107192531.73802-1-bvanassche@acm.org>
References: <20200107192531.73802-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes the next patch in
this series easier to read.

Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1b97f2dc0b63..6f55d72e7fdd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2364,6 +2364,27 @@ static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
 	return (upiu_wlun_id & ~UFS_UPIU_WLUN_ID) | SCSI_W_LUN_BASE;
 }
 
+static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
+{
+	struct utp_transfer_cmd_desc *cmd_descp = hba->ucdl_base_addr;
+	struct utp_transfer_req_desc *utrdlp = hba->utrdl_base_addr;
+	dma_addr_t cmd_desc_element_addr = hba->ucdl_dma_addr +
+		i * sizeof(struct utp_transfer_cmd_desc);
+	u16 response_offset = offsetof(struct utp_transfer_cmd_desc,
+				       response_upiu);
+	u16 prdt_offset = offsetof(struct utp_transfer_cmd_desc, prd_table);
+
+	lrb->utr_descriptor_ptr = utrdlp + i;
+	lrb->utrd_dma_addr = hba->utrdl_dma_addr +
+		i * sizeof(struct utp_transfer_req_desc);
+	lrb->ucd_req_ptr = (struct utp_upiu_req *)(cmd_descp + i);
+	lrb->ucd_req_dma_addr = cmd_desc_element_addr;
+	lrb->ucd_rsp_ptr = (struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
+	lrb->ucd_rsp_dma_addr = cmd_desc_element_addr + response_offset;
+	lrb->ucd_prdt_ptr = (struct ufshcd_sg_entry *)cmd_descp[i].prd_table;
+	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
+}
+
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @host: SCSI host pointer
@@ -3385,7 +3406,6 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
  */
 static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 {
-	struct utp_transfer_cmd_desc *cmd_descp;
 	struct utp_transfer_req_desc *utrdlp;
 	dma_addr_t cmd_desc_dma_addr;
 	dma_addr_t cmd_desc_element_addr;
@@ -3395,7 +3415,6 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	int i;
 
 	utrdlp = hba->utrdl_base_addr;
-	cmd_descp = hba->ucdl_base_addr;
 
 	response_offset =
 		offsetof(struct utp_transfer_cmd_desc, response_upiu);
@@ -3431,20 +3450,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 		}
 
-		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
-		hba->lrb[i].utrd_dma_addr = hba->utrdl_dma_addr +
-				(i * sizeof(struct utp_transfer_req_desc));
-		hba->lrb[i].ucd_req_ptr =
-			(struct utp_upiu_req *)(cmd_descp + i);
-		hba->lrb[i].ucd_req_dma_addr = cmd_desc_element_addr;
-		hba->lrb[i].ucd_rsp_ptr =
-			(struct utp_upiu_rsp *)cmd_descp[i].response_upiu;
-		hba->lrb[i].ucd_rsp_dma_addr = cmd_desc_element_addr +
-				response_offset;
-		hba->lrb[i].ucd_prdt_ptr =
-			(struct ufshcd_sg_entry *)cmd_descp[i].prd_table;
-		hba->lrb[i].ucd_prdt_dma_addr = cmd_desc_element_addr +
-				prdt_offset;
+		ufshcd_init_lrb(hba, &hba->lrb[i], i);
 	}
 }
 
