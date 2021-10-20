Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCD9C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 722596138B
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhJTVnG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:06 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:53203 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhJTVnF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:43:05 -0400
Received: by mail-pj1-f50.google.com with SMTP id oa4so3425452pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:40:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F//N4YxYP3KaoC8JkFppxBSQFXF2ZiS1Jn4qJam6gek=;
        b=lJb0+CQ8bCjLEkujw1WoF+H9K47BUDohbO07Wje0bUOguqMV3zgDDrd0dU3ySWLYwF
         mSWTV3uBnnnVr8QhDgJD35hIfckFrfo5evhAderw3+O9SdfOsqUEJKqVPFF8upepQvLf
         e99L9oYGyKpfB03cCwF0l3/pB1p4kHBU0ipU1UCXfJCIdCp6XKVTnntRa3Vg+3puF8tA
         TYQO+j4AkviAhxxLM4PI4EMuUjfb6HmGx+wShDKnBPL++WbzHz1NsnwlaUyobyRNQEfZ
         cWn3c4y15OoHfIhHzu3KtH72uvzqG24FUtRYC8gX8ek/k1DpZXrOVTCvGd6P5JaOSUAM
         PORA==
X-Gm-Message-State: AOAM532pFza3cGKgiIGLBKKBRbX72zbDSch+ZBs72OMLGEKxdAc0NSUT
        anLfscN/oQIz/Bz0MktQ5cY=
X-Google-Smtp-Source: ABdhPJx1bblygVepR7nYkEDq+dnj2cKA7C6Nu/vv/Sf5QZwBZ6uMoEU+CHZiUbVBNwaLe9cNgMbtNA==
X-Received: by 2002:a17:902:e884:b0:13f:19bf:fc16 with SMTP id w4-20020a170902e88400b0013f19bffc16mr1396666plg.67.1634766050875;
        Wed, 20 Oct 2021 14:40:50 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:200d:62ea:db33:9047])
        by smtp.gmail.com with ESMTPSA id 21sm6707694pjg.57.2021.10.20.14.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:40:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Caleb Connolly <caleb@connolly.tech>,
        Avri Altman <avri.altman@wdc.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 03/10] scsi: ufs: Improve static type checking
Date:   Wed, 20 Oct 2021 14:40:17 -0700
Message-Id: <20211020214024.2007615-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020214024.2007615-1-bvanassche@acm.org>
References: <20211020214024.2007615-1-bvanassche@acm.org>
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
index 53dd42f95eed..610be6746f74 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -711,7 +711,7 @@ static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
  * This function is used to get the OCS field from UTRD
  * Returns the OCS field in the UTRD
  */
-static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
+static enum utp_ocs ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 {
 	return le32_to_cpu(lrbp->utr_descriptor_ptr->header.dword_2) & MASK_OCS;
 }
@@ -5089,7 +5089,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	int result = 0;
 	int scsi_status;
-	int ocs;
+	enum utp_ocs ocs;
 
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
@@ -6631,7 +6631,8 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 		u8 tm_function, u8 *tm_response)
 {
 	struct utp_task_req_desc treq = { { 0 }, };
-	int ocs_value, err;
+	enum utp_ocs ocs_value;
+	int err;
 
 	/* Configure task request descriptor */
 	treq.header.dword_0 = cpu_to_le32(UTP_REQ_DESC_INT_CMD);
@@ -6809,7 +6810,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
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
 
