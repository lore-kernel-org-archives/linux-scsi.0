Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75211C33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532C221835
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 03:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgAWD4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 22:56:47 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50187 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgAWD4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 22:56:47 -0500
Received: by mail-pj1-f68.google.com with SMTP id r67so567339pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 19:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EMKk6ZbBKEZcZWoFkToF8ihx5wNLD14mQqxlOlJV0DY=;
        b=OYrpbcj6cPE80hwOAp1mT9Dt5ru5Rjv7hUCeWDskSBBFTFp/tQ/OynmsoimnGNoQI/
         oLszdqiXDtI7mWBZc41FpqGBgb2PDRcb7y/q8SC84gwi72+zLZFR3/UveHos+Cuvgt0X
         G6zSyT2NJHfXSte+SczXs3QNVSvJ4YRRAN4Bk2CEU70nzao7cOBnudMVxxbBMQhK1iYj
         19QEzQNvp1EOOgzMZGiKUslv/pRIW+XZ4f27nx8oXRwWh2RtspTFOfguWXeij4EylNSv
         Pi1EJJ4o+vnzyQ7ljv5Z1XncVuLi40coKiGmZJ8wOUTIG287O4AwoRFrPF0aI+KjCRKZ
         DU5w==
X-Gm-Message-State: APjAAAXKRpy+v1xdb4j+zVMbSzaWTpl2wiHYO+agbep+7xWSZ61NfzRx
        qTWeff3AfHi7F1pS6sMHe60=
X-Google-Smtp-Source: APXvYqwdDcchjjsAwkH8qZ0nCWLCDpQO+uBVoluKIU317B7Db0Fx+d7BGWO05CmRoU3qWiJU35flfg==
X-Received: by 2002:a17:902:ab82:: with SMTP id f2mr5916956plr.36.1579751806988;
        Wed, 22 Jan 2020 19:56:46 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id x197sm435287pfc.1.2020.01.22.19.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 19:56:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v2 2/4] ufs: Introduce ufshcd_init_lrb()
Date:   Wed, 22 Jan 2020 19:56:35 -0800
Message-Id: <20200123035637.21848-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123035637.21848-1-bvanassche@acm.org>
References: <20200123035637.21848-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes the next patch in
this series easier to read.

Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index abd0e6b05f79..4cb610df76d6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2363,6 +2363,27 @@ static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
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
@@ -3373,7 +3394,6 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
  */
 static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 {
-	struct utp_transfer_cmd_desc *cmd_descp;
 	struct utp_transfer_req_desc *utrdlp;
 	dma_addr_t cmd_desc_dma_addr;
 	dma_addr_t cmd_desc_element_addr;
@@ -3383,7 +3403,6 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 	int i;
 
 	utrdlp = hba->utrdl_base_addr;
-	cmd_descp = hba->ucdl_base_addr;
 
 	response_offset =
 		offsetof(struct utp_transfer_cmd_desc, response_upiu);
@@ -3419,20 +3438,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
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
 
