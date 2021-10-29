Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73241C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C6D560FC1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhJ2ToC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ2ToA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:44:00 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A57C061570;
        Fri, 29 Oct 2021 12:41:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b12so13699572wrh.4;
        Fri, 29 Oct 2021 12:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xK0OgKCgasorIcncaA/RIPd54WafWAPhaFoI+LfDjAI=;
        b=mmHNQqQ2LQSNWnsYqYo6En/pRs/FokvgdEuoWByVKYDFFJdIiygRnJa/mXbHqRLg6S
         E0PZXADo09vyC4DuNuyCpVkFzzRj2XtTUDd4j6X2IYX9obh7G7NZs+my6LPQbmwp/KrG
         FDzFrA2OXVeplz3DWQ5us+lEuk/1XSf5LTw84QkF1Tejlzp4T7YY3ihlkzeGzeAiPiiQ
         NGj+bNWoZwbUrki1Io6hN/HS8K7I1IYhTN6Dpu72HvL9uRlMYcEfqrSVyznZ0DZngcCK
         k16AqCQ3Jk519omzOB6zmHXAVQTonP9fMA18pL9AHxiM+C6414xHg8p32v3a3Wu2a2OO
         I3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xK0OgKCgasorIcncaA/RIPd54WafWAPhaFoI+LfDjAI=;
        b=jbkd5YKf96UK1v1YalHBCBYy2WkEdliY8Qopd/LKK2Uk9JgDr/JhfHpvjN+n2/InUn
         YKqVRr0kSn2btFNbnM/v3yKMvIFwu6urBJwl+XXztaLEOSbglKB7w0VZy/HpyOx4x4Gd
         7pgMplyU3Mrues+HAL5934vgcqdoYMisBz29QFXFIis8DTkDXtcUvfUq9SPMCDQqzNZ6
         VZx+JKeZvBbaJjISaYe2WbgSTZc+2UagiDi/0UEYINWAXK/J6vIMIprTORoscCAegAST
         6GwRUwfjlbPi5sJ/YklbhhfLIfkCf9gJXuESG6nhGflV8ZL2gaTJvprdBgbm14mW9NQ6
         xO5w==
X-Gm-Message-State: AOAM533vNNiR7JpQF/k/VuIWnHvye/NO+btxzKbgwUPbnOJboKR31e/t
        blpyF3tJ0Jto6SeZR6MZ/HI=
X-Google-Smtp-Source: ABdhPJyNtFiVWV+IgxM/sc9d96nBDIp/0i78jlFTUZDSUsl46WuPPAGrApvlDGKCCnkDnYo2DT5OEQ==
X-Received: by 2002:adf:9bdb:: with SMTP id e27mr14277199wrc.417.1635536489831;
        Fri, 29 Oct 2021 12:41:29 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.gmail.com with ESMTPSA id i6sm8890225wry.71.2021.10.29.12.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:41:29 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] scsi: ufshpb: Delete ufshpb_set_write_buf_cmd()
Date:   Fri, 29 Oct 2021 21:41:13 +0200
Message-Id: <20211029194113.293031-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029194113.293031-1-huobean@gmail.com>
References: <20211029194113.293031-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Since commit "facdc632bb5f ('scsi: ufs: ufshpb: Remove HPB2.0 flows')",
no body uses it, so delete it.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshpb.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 95ce20ff2194..106d8e0e50c7 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -342,20 +342,6 @@ ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshpb_lu *hpb,
 	lrbp->cmd->cmd_len = UFS_CDB_SIZE;
 }
 
-static inline void ufshpb_set_write_buf_cmd(unsigned char *cdb,
-					    unsigned long lpn, unsigned int len,
-					    int read_id)
-{
-	cdb[0] = UFSHPB_WRITE_BUFFER;
-	cdb[1] = UFSHPB_WRITE_BUFFER_PREFETCH_ID;
-
-	put_unaligned_be32(lpn, &cdb[2]);
-	cdb[6] = read_id;
-	put_unaligned_be16(len * HPB_ENTRY_SIZE, &cdb[7]);
-
-	cdb[9] = 0x00;	/* Control = 0x00 */
-}
-
 static inline int ufshpb_get_read_id(struct ufshpb_lu *hpb)
 {
 	if (++hpb->cur_read_id >= MAX_HPB_READ_ID)
-- 
2.25.1

