Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75766C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjE2U06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjE2U0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:26:52 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360F6C7
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:51 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1b02d0942caso13059365ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 May 2023 13:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685392010; x=1687984010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQKRuWWQJWJEZwl2UnrxCG4HCHgO25yPqjuLBA5DMrk=;
        b=FVCAiAlnAwqde0Eu4QWcH3JMMdUqvzBokAPWUxrsqL4SUPcHYGm/jpQ+7TNpJ7Q65R
         +6dmufVSb61iMUA/kSDInEf76O2XGJDrFl9if3s3YXBs2wxLs+T3SPGewrDnUYtWP7KN
         t5hMexX+thG2uesvm9VVs2LZfFRZkV2dWx40oWAmlT6oMuiTOUk/srkdn4GW9sBIfODc
         WBJJ+5/Pmj8hJmAcnu0Gm5WjsWH009t+iGnxsQzaBX0sCEEHNmSNi03iBb121rmrGhh+
         TEXTUiXxtLYg8zrqzjj5P5PLBYL3EoZgMJ2Sc8NJ6B5wvNvJAnz7w3nXztHlm3JuAZum
         lwXA==
X-Gm-Message-State: AC+VfDxyqsZOejQsMnuAOR+vCPNPYxqJ5uef6tfLVSmZRE5KO/jKHtzT
        dsJtVMS9bwDhbn1v61RVogo=
X-Google-Smtp-Source: ACHHUZ6lpCMhBDrgjzwhXnBW+gxs2P3KTrHhLsOmOAOzH2rh/GI9F75KNtUgbwGKU5uVUpZ5uyzD0A==
X-Received: by 2002:a17:903:2310:b0:1ae:2013:4bc8 with SMTP id d16-20020a170903231000b001ae20134bc8mr331586plh.18.1685392010571;
        Mon, 29 May 2023 13:26:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id l18-20020a170903245200b001b027221393sm4957237pls.43.2023.05.29.13.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:26:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: [PATCH v4 3/5] scsi: ufs: Conditionally enable the BLK_MQ_F_BLOCKING flag
Date:   Mon, 29 May 2023 13:26:38 -0700
Message-Id: <20230529202640.11883-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202640.11883-1-bvanassche@acm.org>
References: <20230529202640.11883-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code in ufshcd_queuecommand() that may sleep.

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index abe9a430cc37..c2d9109102f3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10187,6 +10187,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	host->max_channel = UFSHCD_MAX_CHANNEL;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = UFS_CDB_SIZE;
+	host->queuecommand_may_block = !!(hba->caps & UFSHCD_CAP_CLK_GATING);
 
 	hba->max_pwr_info.is_valid = false;
 
