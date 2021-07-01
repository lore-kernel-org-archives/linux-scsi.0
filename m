Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E73C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A52F961406
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhGAVQD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:16:03 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:41750 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbhGAVQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:16:02 -0400
Received: by mail-pl1-f179.google.com with SMTP id z4so4412935plg.8
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4LheHc3SC4FF3EChZEnCuOOXPXJ1BYmbcTjoKho4cIc=;
        b=hNVyu+7sV2AT0MgjXFm0yYhVhOYDKi4NLyk9An4OBoPqgoIrrXjoI3K6WdSkJC1PGK
         BJ+vQVj53DZxj+0Laqc8V7S6vgJ5ODv9y52Z4MOssD9hAOACnaTwiUtLky84vHZeUtez
         ywvrbONmVA4RTzdBPHCWQvDA1Uim2Pg2fANpleizFLIRg2x3RuvSXD307o8sOjlutV/d
         URw1jabPpfkyYMSEdxZ+77p3uHapAlwfiiZ+vpd/zXXyDrkBhAqIevaNSY5Xx1WEu2/o
         b1glSG+6rc78KSBAF6aeBBIMemcGYn7Moz6StUnuz+HqX6FlXLiT2LtWt17s8b+alEYM
         mD+w==
X-Gm-Message-State: AOAM533WqUim/u79l9ddLKHNl85k6k02i0y4iTt6PmwYN6E6K5saeRWT
        rr/cpjZSIpEpJKCSlLQtqf0=
X-Google-Smtp-Source: ABdhPJy6hP1GN9JMMasnoLevJAODeetD73VM5Lr93biUpv2cg+O+8LR3L1v5CNqJbYKqVWJHS9er/Q==
X-Received: by 2002:a17:902:d213:b029:127:9520:7649 with SMTP id t19-20020a170902d213b029012795207649mr1586856ply.10.1625174010143;
        Thu, 01 Jul 2021 14:13:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:29 -0700 (PDT)
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
Subject: [PATCH 14/21] ufs: Inline ufshcd_outstanding_req_clear()
Date:   Thu,  1 Jul 2021 14:12:17 -0700
Message-Id: <20210701211224.17070-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Inline ufshcd_outstanding_req_clear() since it only has one caller and
since its body is only one line long.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 25ab603acad1..2acf168bc339 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -743,16 +743,6 @@ static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
 		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
-/**
- * ufshcd_outstanding_req_clear - Clear a bit in outstanding request field
- * @hba: per adapter instance
- * @tag: position of the bit to be cleared
- */
-static inline void ufshcd_outstanding_req_clear(struct ufs_hba *hba, int tag)
-{
-	clear_bit(tag, &hba->outstanding_reqs);
-}
-
 /**
  * ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
  * @reg: Register value of host controller status
@@ -2898,7 +2888,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * we also need to clear the outstanding_request
 		 * field in hba
 		 */
-		ufshcd_outstanding_req_clear(hba, lrbp->task_tag);
+		clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
 	}
 
 	return err;
