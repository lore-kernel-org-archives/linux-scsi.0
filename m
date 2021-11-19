Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB7DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76B1561139
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbhKSUBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:51 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:40723 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbhKSUBg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:36 -0500
Received: by mail-pj1-f46.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so11747583pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a5y/pM+72J2v5l3yKPW6l2Alr7eEsDtI3z2EnZT4JkY=;
        b=EAdrG2uI9W0mwmufhzNEq74qRxiM1KZaQTTkbpm0O2RMe4ECUUoqELj2+V0Y6xmd0s
         jWgYAEn5Aix/s/P6139xQaLU+TziYbl9ymuve07KVMH8o7Ju5xtF6017nFmffrLeIXTF
         wVoxoS+th4RuaBGuXs5FCNRsq2CKzsOJfqT8TzR2b99H5yYCODAlJJxJIg2WW5y3uQoQ
         5fotGtwYifeCYK20pRcApz+Kon3qJHVdQSq3OsprVRUy6e3Vn2GxAMjCvo4auX/7a4Z5
         mEmtZb8LmShRp/SIGeB2SyPUZY0F6BAWcwcaNHoMyx8pJ/1ZxA+uepFmwD0YXP9BVXQs
         x3+Q==
X-Gm-Message-State: AOAM532wiVVqpGirbRSFVQlolZFeNJdx7wwge1Ovoc7DSAuFwiI92Ctv
        1Wud78PEaLRqqS5mk4pbDIY=
X-Google-Smtp-Source: ABdhPJyfRed8mryKKoX0GmXsKQa0PrUfYoFgARX7KU3uxOCge+OfHA2LOyFqm5KP0544jXcAJ8MTpg==
X-Received: by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id u14-20020a170902e5ce00b00142078078dbmr78375074plf.12.1637351914548;
        Fri, 19 Nov 2021 11:58:34 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 15/20] scsi: ufs: Improve SCSI abort handling
Date:   Fri, 19 Nov 2021 11:57:38 -0800
Message-Id: <20211119195743.2817-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Release resources when aborting a command. Make sure that aborted commands
are completed once by clearing the corresponding tag bit from
hba->outstanding_reqs.

Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 39dcf997a638..7e27d6436889 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7042,8 +7042,12 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	/* If command is already aborted/completed, return FAILED. */
-	if (!(test_bit(tag, &hba->outstanding_reqs))) {
+	/*
+	 * If the command is already aborted/completed, return FAILED. This
+	 * should never happen since the SCSI core serializes error handling
+	 * and scsi_done() calls.
+	 */
+	if (WARN_ON_ONCE(!(test_bit(tag, &hba->outstanding_reqs)))) {
 		dev_err(hba->dev,
 			"%s: cmd at tag %d already completed, outstanding=0x%lx, doorbell=0x%x\n",
 			__func__, tag, hba->outstanding_reqs, reg);
@@ -7113,6 +7117,16 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
 
+	/*
+	 * Clear the corresponding bit from outstanding_reqs since the command
+	 * has been aborted successfully.
+	 */
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	__clear_bit(tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	ufshcd_release_scsi_cmd(hba, lrbp);
+
 	err = SUCCESS;
 
 release:
