Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C99C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9078E6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 21:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbhJLV5F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:57:05 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:43591 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbhJLV5E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 17:57:04 -0400
Received: by mail-pg1-f179.google.com with SMTP id r2so354301pgl.10
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 14:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0IjfT/biCiy46/mUQFAvfA8gz4Dz7xYpL1dCj8PNzp0=;
        b=ICdw01zl1S6k/uRbJ/INkPkyhWBR9dLCQcLHADDZAMrTBOuc2KBm4HW4Q1glH0/fC7
         p7qZdAIsi3XtE+iaO59kM2DpRw03lbBr5dx3vnppTVyth0m5/Mw/Sy96bh43hpFCZWJy
         CneOZ1N4fqkowZzMkh3fUohcFzzTvpR0b86XKOOGX1Q0hmZod7CCe/chGn3DY1Pj/lw+
         kzi0b00EVapUTi4DI9hpgcFHp4rWnwqyY4GlmZGN1AgrHDSxsvUwY3vFd1SI2d/Euk2r
         erl74Cr1f8Uy7YwX447f62cDzMTBC1K91e6IxfRyg/zd1JXwJqxpncLFAvPyVxvKGekI
         wgdQ==
X-Gm-Message-State: AOAM531Rsf1UbVDs2+l/GzE7ixZS1BDDLDdG+HF4nwpb9f9sbzK7juIG
        6E+E5MDWcd5B0QAvUt+9gms=
X-Google-Smtp-Source: ABdhPJwXFkikNhoZyvI1DMczsaoHymmwMqgrotBjej5GumoDxlw3K5YN/LXiQ8P0zOTE0uZJE/+ucQ==
X-Received: by 2002:a63:454e:: with SMTP id u14mr24525619pgk.314.1634075702182;
        Tue, 12 Oct 2021 14:55:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id m73sm12038730pfd.152.2021.10.12.14.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 14:55:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 3/5] scsi: ufs: Improve static type checking
Date:   Tue, 12 Oct 2021 14:54:31 -0700
Message-Id: <20211012215433.3725777-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211012215433.3725777-1-bvanassche@acm.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce an enumeration type for the overall command status to allow the
compiler to perform more static type checking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++----
 drivers/scsi/ufs/ufshci.h | 5 ++++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a89fe61cb8cf..cb55ba3cb3e6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -713,7 +713,7 @@ static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
  * This function is used to get the OCS field from UTRD
  * Returns the OCS field in the UTRD
  */
-static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
+static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 {
 	return le32_to_cpu(lrbp->utr_descriptor_ptr->header.dword_2) & MASK_OCS;
 }
@@ -5108,7 +5108,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int result = 0;
 	int scsi_status;
-	int ocs;
+	enum utp_ocs ocs;
 
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
@@ -6645,7 +6645,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 		u8 tm_function, u8 *tm_response)
 {
 	struct utp_task_req_desc treq = { { 0 }, };
-	int ocs_value, err;
+	enum utp_ocs ocs_value;
+	int err;
 
 	/* Configure task request descriptor */
 	treq.header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
@@ -6823,7 +6824,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 	int err;
 	enum dev_cmd_type cmd_type = DEV_CMD_TYPE_QUERY;
 	struct utp_task_req_desc treq = { { 0 }, };
-	int ocs_value;
+	enum utp_ocs ocs_value;
 	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
 
 	switch (msgcode) {
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 9a754fab8908..f66cf9e477cb 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -389,7 +389,7 @@ enum {
 };
 
 /* Overall command status values */
-enum {
+enum utp_ocs {
 	OCS_SUCCESS			= 0x0,
 	OCS_INVALID_CMD_TABLE_ATTR	= 0x1,
 	OCS_INVALID_PRDT_ATTR		= 0x2,
@@ -402,6 +402,9 @@ enum {
 	OCS_INVALID_CRYPTO_CONFIG	= 0x9,
 	OCS_GENERAL_CRYPTO_ERROR	= 0xA,
 	OCS_INVALID_COMMAND_STATUS	= 0x0F,
+};
+
+enum {
 	MASK_OCS			= 0x0F,
 };
 
