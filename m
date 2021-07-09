Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE74C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08A21613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhGIUaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:16 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:34376 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:15 -0400
Received: by mail-pf1-f174.google.com with SMTP id o201so4724118pfd.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aFFnPhD4xne40vQ5XGBvPkSKKLB0qYKiY2N77tI6SvM=;
        b=kdSzOG9WE9Y2HUgdiRIubydKB12eC9Uy3bt1SS+aqPKty2yzgxPKZHWN6Vab/WnHca
         6kABBGojVewbhD3pJ2E5ubfc1g+bDvX8BJyv7fl5UBuGSghbZYQRpFfeB/Gf22Ic0idW
         ++1giTG9GcqjwcplXGC74uvFCWS0JDtIrfCd9TbvUYyJg6iFxb7bjPSB8SRG02BBPm3A
         eAxU0JQ8lrs+PoJaupkElvwW5uSbQxedDGRcLXLnHenK2W+rvsCK1DZ6eviEUlM4giZn
         VdkV8nO4qH/XUvpwfFDYJ0KOxxPGk9ZnFfHEUowuvmZb9fA4gL/FYWXfegb7+I3LYz3q
         cErw==
X-Gm-Message-State: AOAM531393q4rc+qMsrY8i5B6waOnBx0L4GLZxJblTqG34Dl3SVicaT0
        JhUKbcMkwV0KCg9gwpcAPSM=
X-Google-Smtp-Source: ABdhPJyPFwnXJ5mOtRehpQIC93tqM9WcsykADPtJAo9nfylNadbb3U1LfzuJeLTAauXNAtmsfw6WYw==
X-Received: by 2002:a62:19c6:0:b029:319:4a01:407d with SMTP id 189-20020a6219c60000b02903194a01407dmr38186402pfz.1.1625862450630;
        Fri, 09 Jul 2021 13:27:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 10/19] scsi: ufs: Inline ufshcd_outstanding_req_clear()
Date:   Fri,  9 Jul 2021 13:26:29 -0700
Message-Id: <20210709202638.9480-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Inline ufshcd_outstanding_req_clear() since it only has one caller and
since its body is only one line long.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4bed4791720a..81a27104308d 100644
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
@@ -2900,7 +2890,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * we also need to clear the outstanding_request
 		 * field in hba
 		 */
-		ufshcd_outstanding_req_clear(hba, lrbp->task_tag);
+		clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
 	}
 
 	return err;
