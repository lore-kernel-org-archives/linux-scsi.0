Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713CBC636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CA1A61260
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhGVCy7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:54:59 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:34366 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhGVCy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:54:59 -0400
Received: by mail-pl1-f169.google.com with SMTP id b2so2964779plx.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iX5KvthYfrgwYibesp9gzRxU0hi+HpCBmooUh6FFA9Q=;
        b=E0ibXy0W8pEFuAlGAM2q70ISIHidojdFBuXvHFU7tMU9hjNn2Iqeb+6xLBpia4s/+R
         lz41uUoZWoXVMq47mJ7z5h3h71K1jtfjjPRV1TOzCNCNAKXjB4vWh+sOskPRRAHSfkGf
         k1Ur16+dZJLS1dTr87+rZ4bZveWC/f0ej7bfEoVRODP92Q8i58x+qJH7jgIDbz9ADgJf
         8A3/K/5yBc5Fym5X+Hw92pHDZK93deK3Pz6eiOTH7rpw7hEvak5wDroRJOjMSW94TfE2
         GdCO042QFa3XrkZEIz6yKhKkoBT99Bx2ezaBVRRZnaK3NrNuHEg1bi3qyxjYBekkXY88
         uB8A==
X-Gm-Message-State: AOAM532RK4pm6CImMhXD7HOZnGreOif1YOuv/fsf2LulV2GoVbyxIYZp
        2jpFyOGnc7ofkXqXn6J/S0A=
X-Google-Smtp-Source: ABdhPJx8F7MBNlVEZX4eNpIFSv3GceKhw9GskKHxZoHV5VF2Nwn9i36G+pyonsytkKWZmLKlDeEhXg==
X-Received: by 2002:a17:90a:d598:: with SMTP id v24mr36692039pju.185.1626924933729;
        Wed, 21 Jul 2021 20:35:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 10/18] scsi: ufs: Inline ufshcd_outstanding_req_clear()
Date:   Wed, 21 Jul 2021 20:34:31 -0700
Message-Id: <20210722033439.26550-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
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
index d1c3a984d803..4c6d832f5e81 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -742,16 +742,6 @@ static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
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
@@ -2899,7 +2889,7 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 		 * we also need to clear the outstanding_request
 		 * field in hba
 		 */
-		ufshcd_outstanding_req_clear(hba, lrbp->task_tag);
+		clear_bit(lrbp->task_tag, &hba->outstanding_reqs);
 	}
 
 	return err;
