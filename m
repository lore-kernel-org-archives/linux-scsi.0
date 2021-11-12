Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF24C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 13:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10CD61078
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 13:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhKLNFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 08:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhKLNFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2021 08:05:19 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F920C0613F5;
        Fri, 12 Nov 2021 05:02:27 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id n8so8350706plf.4;
        Fri, 12 Nov 2021 05:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5DDh4jKNY942Gl/i8dUbs2Mkijh1sNJCdeUegqogFsE=;
        b=Z8vBO/pyAz/7yfuKfpeCMeHOJ4L6xdiskutvoNm8WPJDgUwbkRs0MS0ZcLJ64KOsPF
         QQckZ2PTSjadOr3TV0vDHmJbywE6jtZHFdeqDOxW1YT8NgVThXbNo3sCRBjtaFIe3uoD
         IFq2IyHux9Op/sb93+3c9n85m24IeKRFQIYUxT8ahQDUYkl8Yw5GT4hxQycvTO+ByEkM
         GYBjZi7fvomL6x0DNp+6TmQ3S2we7YiKWvyTz4LWbQfdJXA6NFI1rylioeAf+8EIw3xI
         umxWVvQcLGCdg7twPIBx0kr/8/pTT+0978oeOEtzbrOEXPC91VaH4oJWrxgxiO0GaO5n
         iM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5DDh4jKNY942Gl/i8dUbs2Mkijh1sNJCdeUegqogFsE=;
        b=GDmj6YQRRRX236aoxLQGtEx/Gbb2c8TJl8S3McRQ2ZrJbxzNc64duE/B8XEhYHj5LK
         Y+x2yie+qTvrz5EBPYHRrIZykswguvPLGlFDRWEEfYQgCrkR+75T/OWzf8JLiC549Ht6
         5m43aVr9QWTyoADIf5JunV/KGKQ71uhPG/vy7AFzKlTl2Uz3GmE/QYbPdMx3ljTVdoLC
         /+mQ2qJj4FWsDMHtsB7igRFQcCm3VR2w4yZpW5bS33ju1YAeYekGNwCemy/gq+lJHVa1
         rV0Bn3/+sjm8KdEsH0v7V7osgPqijq+IdrP6k03J+1WIQoijaVYM+HA1La9wUFBQGEag
         cYig==
X-Gm-Message-State: AOAM532lWWtfhNRFuN9z4HUCVnk/bQ2lpOi/+ZuprGSvLkrzAJCnHbSu
        grFbI3qNfPoz1xC3BKmkQ/0=
X-Google-Smtp-Source: ABdhPJy6tZtAnigJMcLzG99Dwhc4diNcfzyLltbIEChePSsJosJRZDjox+cnwSfVKYVuW4L/MQA98g==
X-Received: by 2002:a17:903:248f:b0:143:8e81:4d7c with SMTP id p15-20020a170903248f00b001438e814d7cmr7827668plw.1.1636722147064;
        Fri, 12 Nov 2021 05:02:27 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d15sm7331493pfu.12.2021.11.12.05.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 05:02:26 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     james.smart@broadcom.com
Cc:     dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: lpfc: remove unneeded variable
Date:   Fri, 12 Nov 2021 13:02:20 +0000
Message-Id: <20211112130220.10741-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck review:
./drivers/scsi/lpfc/lpfc_sli.c: 3655: 5-7: Unneeded variable

Remove unneeded variable used to store return value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 53f154a301b5..93596cdd66a7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3652,7 +3652,6 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			  struct lpfc_iocbq *saveq)
 {
 	struct lpfc_iocbq *cmdiocbp;
-	int rc = 1;
 	unsigned long iflag;
 
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
@@ -3777,7 +3776,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		}
 	}
 
-	return rc;
+	return 1;
 }
 
 /**
-- 
2.25.1

