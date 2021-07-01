Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDDCC11F69
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0650961405
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbhGAVQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:16:05 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:40859 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbhGAVQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:16:05 -0400
Received: by mail-pj1-f41.google.com with SMTP id b14-20020a17090a7aceb029017261c7d206so1712677pjl.5
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zv0EeJtpbHgDBrmYD2BV9+v0Uif/PkJkAd0uZBmSJYo=;
        b=PBzvX0ym8Ox494QIM40DhSoUWaQkhD6ouOseQ6ehoTIXEnR3/gFYO9D5vOD6pIcaTK
         Iz/U5JRLhUHzDiY8rt/WUJ4d2L67syPoWnp6Rk5tDZiM8uL8PVis+tn34ICspHMhApxO
         FD66qGrJaswPOEYNKLflMawl0FCLH6krSS+TH0AVpAS48romq1DbSqbDpoKE+kLRPllw
         bl98Vdg/EDAv78UJ86e6bKEUK/vwltLxYwjnKTpNSDwX133xcohFPjML6sd9fUN1n4pX
         o0/ciPurABBqMmQqo90zC7qU7CfIsJXWP5U6VVnvVLnbCyrHekk1NEPI0qrKr71ov3lS
         4yhA==
X-Gm-Message-State: AOAM533I56A7o4yhNaCf1WYNF3kb+C6DKBjojVAQZpKXydJhU6WOzAoK
        mAO1gG9zWYQP0EUAJ3WScu8=
X-Google-Smtp-Source: ABdhPJwIppYL/UPymbaD5Yc9wo9IS1SNfZ4JK8SAOOF6aZfaclzOnT/WygE5sjNx936BSNpBsqfo7Q==
X-Received: by 2002:a17:902:9a92:b029:127:8aab:6a46 with SMTP id w18-20020a1709029a92b02901278aab6a46mr1323765plp.8.1625174013945;
        Thu, 01 Jul 2021 14:13:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 15/21] ufs: Rename __ufshcd_transfer_req_compl()
Date:   Thu,  1 Jul 2021 14:12:18 -0700
Message-Id: <20210701211224.17070-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
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
index 2acf168bc339..0b7359e0b445 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5180,12 +5180,12 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
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
@@ -5270,7 +5270,7 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	}
 
 	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
+		ufshcd_transfer_req_compl(hba, completed_reqs);
 		return IRQ_HANDLED;
 	} else {
 		return IRQ_NONE;
@@ -6808,7 +6808,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos);
+			ufshcd_transfer_req_compl(hba, pos);
 		}
 	}
 
@@ -6981,7 +6981,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
-		__ufshcd_transfer_req_compl(hba, (1UL << tag));
+		ufshcd_transfer_req_compl(hba, 1UL << tag);
 		set_bit(tag, &hba->outstanding_reqs);
 		spin_lock_irqsave(host->host_lock, flags);
 		hba->force_reset = true;
@@ -6998,7 +6998,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	if (!err) {
 cleanup:
-		__ufshcd_transfer_req_compl(hba, (1UL << tag));
+		ufshcd_transfer_req_compl(hba, 1UL << tag);
 out:
 		err = SUCCESS;
 	} else {
