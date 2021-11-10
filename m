Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C05C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 12:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15DB96124B
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 12:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhKJMT0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 07:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhKJMT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 07:19:26 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6672C061764;
        Wed, 10 Nov 2021 04:16:38 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so1693128pjl.2;
        Wed, 10 Nov 2021 04:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d1kXfwfcDtODWa9uzbuhDs0/KwXOsZ3LY3iX8QnvlxA=;
        b=pHsI2vJSNu8g0GHaN1RV4BQKDHgk3fZtMh3FGHTCYoZElo1D9iSmylhyGxWcjK5otK
         CBHmEHtzOIT90awgZUstknnWs0BOyeF5LpcRCiwBRvKuHUzFIGKU2kmIUDjV7qC2LE6U
         3+Fmf/ZUZF27nB7SQkIEbNzSv/T7ozYCpzSQvamZDPh3o8uxPZ++30LLGK4N9ssFZX8I
         Ai3imO+Zr3ajF9huOii3Rm7EIgmNkA5CdWxAA5aiQoT+id1Ud3TeFmZ6xU230fhqgWeZ
         PSPLDXeNrimaBq+100xsFm83lvwlB3fpHlFCeZqJ7eBeHqbaB+w88lh96j0UOlkyxM7T
         x2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d1kXfwfcDtODWa9uzbuhDs0/KwXOsZ3LY3iX8QnvlxA=;
        b=qBKSS1KxX+YLboN4SIqElxKxsMivr1odsz1MGG0W6EpBH1Nl2YnavihrznQHg1JrE1
         8PMWLnswNBA8GYx85eZQgMz3A0u5/rRvPQg3K8Z0EQ9J8SKkJmFCKXFzvDYXMZrDT6KE
         3M99jTx1lo5UuVHeNN8gIcoNvfGCPyqM7I8/1CwsSiXAwV7q9HZrF3crVI1nrcB/5N+c
         d638HcgezmIyLY1RhiDeGcAoEMHPBvjg2EAIrWUYEPXqhs96c7XSDbj96Uo6NkEuWLF+
         D/9vUxgApOLuo8w45lwGd0+3NZy4rGGsDlqyjrXO9FxuhSifrpCjtj2VKEF4ki3aVe1s
         HOwA==
X-Gm-Message-State: AOAM530L1i3zrzImtWrSbUkdyfxm7y/VTEmmzVMF/G0dbgPFlOEbHPIu
        LqExgNBSsCIAsoBBekRC6Kg=
X-Google-Smtp-Source: ABdhPJw/Y3uEEX/L9s6wkAehsjYngCEUqPJ0ZZe3Y3EVsOf/ObsoKu1tSTLKkYMLV47N+a1AUV2Ocg==
X-Received: by 2002:a17:90a:3d42:: with SMTP id o2mr16805227pjf.150.1636546598267;
        Wed, 10 Nov 2021 04:16:38 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id k7sm19316104pgn.47.2021.11.10.04.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 04:16:38 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     brking@us.ibm.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: ipr: remove unneeded variable
Date:   Wed, 10 Nov 2021 12:16:31 +0000
Message-Id: <20211110121631.151422-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck review:
./drivers/scsi/ipr.c: 9512: 5-7: Unneeded variable

Remove unneeded variable used to store return value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 drivers/scsi/ipr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 104bee9b3a9d..013a43b6a12a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9509,7 +9509,6 @@ static pci_ers_result_t ipr_pci_error_detected(struct pci_dev *pdev,
  **/
 static int ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 {
-	int rc = 0;
 	unsigned long host_lock_flags = 0;
 
 	ENTER;
@@ -9525,7 +9524,7 @@ static int ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 
 	LEAVE;
-	return rc;
+	return 0;
 }
 
 /**
-- 
2.25.1

