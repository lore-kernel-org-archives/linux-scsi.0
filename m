Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8842AC11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FAD361406
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhGAVQU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:16:20 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46847 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbhGAVQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:16:20 -0400
Received: by mail-pl1-f176.google.com with SMTP id c15so4388903pls.13
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5gxaktirlzpH8KBULMzt0ysZVe1zdPmJjZ584Id3FDY=;
        b=FsjPxwXuvVmPXA7OW7Wh80ZWGpST2dQZUBoUIiezi61Ud2K4DUQTV9QkwGVVrFRrQS
         dNVADiUmlFx7Ceo+T8ro9wPzHFRRvdzxmBS1mWlbg2KoIWBevT1KYHexr5OnshNDrWCD
         cecPL/gYe4UjmgJ0OrDQVmbf1NoqYNAgBF7k5HS5qtyEj4z2bhPUxa/HI3SVDAlY6CEy
         mXS6KEJqdVgxn2wd9/A1iQ/NJTOCBN40zoMT7OYHnOeCCYE4xIo4t9TrdYm1Wi/rpThz
         0BVsAg7RLrpqbDEHRyiwoqauUiZ58vK7X3ecqjfhFyRgKxN1Wdp5iqkU9CzHCfjcEWxA
         tC3w==
X-Gm-Message-State: AOAM531AiMC0wknYn9Z4exeRUsij9/p4/PgsrfTvvAuPHxYD0t4vq2V2
        ULdpiz9wfn/nndssEzXg2rg=
X-Google-Smtp-Source: ABdhPJxxaHGeZyZiQ6/AwkUYmYQg2JbmpCMQ1i7s9mtknQCkjaFxi5eLvERQTO0J3iFnfLzrTUOJJw==
X-Received: by 2002:a17:90a:e98f:: with SMTP id v15mr1536079pjy.144.1625174028637;
        Thu, 01 Jul 2021 14:13:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:47 -0700 (PDT)
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
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH 18/21] ufs: Use the doorbell register instead of the UTRLCNR register
Date:   Thu,  1 Jul 2021 14:12:21 -0700
Message-Id: <20210701211224.17070-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the UTRLCNR register implies performing two MMIO accesses in the hot
path while reading the doorbell register only involves a single MMIO
operation. Hence do not use the UTRLNCR register.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 drivers/scsi/ufs/ufshcd.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 71db56c72af6..250d46ab3584 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6370,7 +6370,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_trc_handler(hba, ufshcd_has_utrlcnr(hba));
+		retval |= ufshcd_trc_handler(hba, ufshcd_use_utrlcnr(hba));
 
 	return retval;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f8766e8f3cac..b3d9b487846f 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1184,9 +1184,9 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
 	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
-static inline bool ufshcd_has_utrlcnr(struct ufs_hba *hba)
+static inline bool ufshcd_use_utrlcnr(struct ufs_hba *hba)
 {
-	return (hba->ufs_version >= ufshci_version(3, 0));
+	return false;
 }
 
 static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
