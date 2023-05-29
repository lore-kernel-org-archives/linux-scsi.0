Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8365EC7EE23
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 20:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjE2UWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 May 2023 16:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjE2UWO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 May 2023 16:22:14 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE56DB;
        Mon, 29 May 2023 13:22:14 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-64d426e63baso4168847b3a.0;
        Mon, 29 May 2023 13:22:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685391733; x=1687983733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQKRuWWQJWJEZwl2UnrxCG4HCHgO25yPqjuLBA5DMrk=;
        b=Sx7vWB41ErQ9DFay7Ws1s/nBYi8bTkRvOLGCVKKdYzi+Tju6ZmJmujUXzsvqQQECqN
         DKZFVdqK5EfLoYN864Z70vgg3ASoW5zCBnh66pY+KXY91Uj4Zqn7tZYnbBB4bMpnbm2X
         1Hmb9ZZLEEwGvYit0uQFeKI0yxhueJgbx/JsQa5dhXdNMc0wrPkipnwwEwZG1UxrGD1F
         O28NBqkEDtNMU9eAdiceo/vSt61QumePGtz9SsddsDAzawFV4sHV4Q3BSfda6x9Wa9L/
         oWabRMnNMAmeDjpYWmcIyLAh2vgfSz+WDtfYBzMnUwvYPtnJSTNCEDEECkiSblRZL/Uu
         gPTw==
X-Gm-Message-State: AC+VfDyOyEiyhgI3yBWN5jIH+LjGbPt6d1ZiMmfeBJ9qEyQUWf3TiFom
        fNEr6gyCb72PaeDZwtOhYjs=
X-Google-Smtp-Source: ACHHUZ59drKE79ScAZGyAaSOqNhSetaM0Qh2rhEXI+kB3EQNMxhjuoGQ3Z7Gt4vbk2IHJ4PlqlJ0ow==
X-Received: by 2002:a05:6a00:24d1:b0:643:9cc0:a3be with SMTP id d17-20020a056a0024d100b006439cc0a3bemr918858pfv.5.1685391733442;
        Mon, 29 May 2023 13:22:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id b19-20020a639313000000b0051b0e564963sm7439342pge.49.2023.05.29.13.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 13:22:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: [PATCH v4 3/5] scsi: ufs: Conditionally enable the BLK_MQ_F_BLOCKING flag
Date:   Mon, 29 May 2023 13:21:55 -0700
Message-Id: <20230529202157.11361-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529202157.11361-1-bvanassche@acm.org>
References: <20230529202157.11361-1-bvanassche@acm.org>
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
 
