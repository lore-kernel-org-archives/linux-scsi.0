Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC53C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 274DF61357
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhGIUaT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:19 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:40595 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:19 -0400
Received: by mail-pj1-f44.google.com with SMTP id b14-20020a17090a7aceb029017261c7d206so8878763pjl.5
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M+X/nT63jv6SpvTa/gSvzdarwOAZF5VFG8Gx+9Z4Ud0=;
        b=i0l3ugwbEpL0Of59QPejDeLcVQNnf4jnIibyZcaVFINboEY3WHT7pvD5pyTFPAGEpA
         eCqmnWFVZxhYKy45AJg9H9j0Nno1sHBJcHhLM8Z54S7Wl0xEbPOxzGyrrUAM8pjUVE42
         zqkcUxzMJIrI4ek7e9ZffpbeVpzoG+00QvYssCl6+RTnxblyhzvt8u4CTkLN0UKdOWTq
         0slvXxVug1s9y90LNjNPwTRxCBZxNwILx/6sVudPGkQ+QK9fMauPqsLKyP7BROgcMj5E
         ndOY9HYo80I6aa6esH0EcPKeiQnV4C9PS3oaPCx+npWRA3G7v/CVR/hdavjTTDnhXq1q
         oVhQ==
X-Gm-Message-State: AOAM533kmPuNwW807zL7Ref3dXe6r/T2FKFzYRh9m5reGx4TqhTMznwJ
        EBghjq8Z54r3YZgQapOVN98=
X-Google-Smtp-Source: ABdhPJwP3NWF1M2f8+ZIdGBjLmm5AClgPGMmQdxseZDIRSink7lU542a6gcmVydXXs7Shpa/vI7tog==
X-Received: by 2002:a17:902:7d83:b029:11d:75c2:79a6 with SMTP id a3-20020a1709027d83b029011d75c279a6mr32674857plm.62.1625862454034;
        Fri, 09 Jul 2021 13:27:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 11/19] scsi: ufs: Rename __ufshcd_transfer_req_compl()
Date:   Fri,  9 Jul 2021 13:26:30 -0700
Message-Id: <20210709202638.9480-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before patch "scsi: ufs: Optimize host lock on transfer requests send/compl
paths", the host lock was held around __ufshcd_transfer_req_compl() and the
double underscore prefix indicated this. Since the SCSI host lock is no
longer held around __ufshcd_transfer_req_compl() calls, remove the double
underscore prefix.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 81a27104308d..0cb84a744dad 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5183,12 +5183,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 }
 
 /**
- * __ufshcd_transfer_req_compl - handle SCSI and query command completion
+ * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
  * @completed_reqs: requests to complete
  */
-static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
-					unsigned long completed_reqs)
+static void ufshcd_transfer_req_compl(struct ufs_hba *hba,
+				      unsigned long completed_reqs)
 {
 	struct ufshcd_lrb *lrbp;
 	struct scsi_cmnd *cmd;
@@ -5273,7 +5273,7 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	}
 
 	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
+		ufshcd_transfer_req_compl(hba, completed_reqs);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -6812,7 +6812,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos);
+			ufshcd_transfer_req_compl(hba, pos);
 		}
 	}
 
@@ -6987,7 +6987,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
-		__ufshcd_transfer_req_compl(hba, (1UL << tag));
+		ufshcd_transfer_req_compl(hba, 1UL << tag);
 		set_bit(tag, &hba->outstanding_reqs);
 		spin_lock_irqsave(host->host_lock, flags);
 		hba->force_reset = true;
@@ -7004,7 +7004,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	if (!err) {
 cleanup:
-		__ufshcd_transfer_req_compl(hba, (1UL << tag));
+		ufshcd_transfer_req_compl(hba, 1UL << tag);
 out:
 		err = SUCCESS;
 	} else {
