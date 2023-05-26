Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A97C7EE23
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 17:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbjEZRaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 13:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjEZRaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 13:30:18 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFCB189
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:18 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ae8ecb4f9aso7057045ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122217; x=1687714217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seKvDn9sLNArsLJX9wv5WuMF/RaC8mbvSnigHxsRcA4=;
        b=DeximVw9pRt6+l+TH8ybUB7QSovFwR1V547s9jnPQX3wtJKp53l4BtHyaOkmPGRWi+
         +KFNJR0uFD8Fe/uxqS94UlFbPhZF9eWg6vdbuqfWhtpwJdtlSdQoZhB82tB7A+YA2Ic7
         imLZPmqtALnFw/31fh+KnMEjmJjaAfzQgDKl9cEDqYLwXL5wADnPHLq3CsgOVzIJhyLz
         mqx8kpD9p+zh+x6bAIhdPSSfH8Dh9mdCKsiqyrsxfjqKqY3BFRzWWbubVsX0Z3mNWon4
         vRQfxp4Cai9rD9RPkSYEaDaxXRxgaQUYeCngIL7yIW5MHmh5cQh2AADx+ADinNPkcNTY
         paoA==
X-Gm-Message-State: AC+VfDwjIs7oOpLR1IFD75/KeLiFou46MuZ2DJXR6Q5o4JycLCbvpQeQ
        FxkAJ03QohoaYT+yu2QcsXQ=
X-Google-Smtp-Source: ACHHUZ4NJaX6VHrsG+TkEjVX8bYkvWkmFskRK/YTTNybS1h7KZ1SYNWHbHq9rAPmab2BkE7k99A0wQ==
X-Received: by 2002:a17:903:41d0:b0:1b0:e0a:b7ab with SMTP id u16-20020a17090341d000b001b00e0ab7abmr3584771ple.31.1685122217373;
        Fri, 26 May 2023 10:30:17 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b001ac7c725c1asm3519156plf.6.2023.05.26.10.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:30:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: [PATCH v3 3/4] scsi: ufs: Conditionally enable the BLK_MQ_F_BLOCKING flag
Date:   Fri, 26 May 2023 10:29:48 -0700
Message-ID: <20230526173007.1627017-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
In-Reply-To: <20230526173007.1627017-1-bvanassche@acm.org>
References: <20230526173007.1627017-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for adding code in ufshcd_queuecommand() that may sleep.

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
 
