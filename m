Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0249EE49AE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjHVTUI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjHVTUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:20:07 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80FBE4D;
        Tue, 22 Aug 2023 12:19:49 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-26ef24b8e5aso2333870a91.0;
        Tue, 22 Aug 2023 12:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731989; x=1693336789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IKOyE0ZGfmDNciokzBC/zSgBfKj2aIlN4m3IlTmArZ8=;
        b=hWf3JB06XMuR0L5guZ8nbFM/edBq0vAcmhJLRI2SRdS5tsjxVZZCVc09DqwJXd157S
         h/wFOtfSrzp4jFYe4pQIWUBkBQ9r8EhnX0rlo9sUvbnMfYObdMuc5At3TGiiOlhYJWVq
         MdJBCFijfSICff+ffXzpR0+ubDnZLr1TINioacTcOHTqj1gfw+03/9gdHgqICQ+sni33
         g8Fc0OmM+wRnpmtiMwAN+uGwvUpQno3uh00FxpeO3/735IdAjN3RyKnDARRPcwy9nUVV
         HczONUWqFlVLyEK1eg/GfeYLvydL8e435aPy3eSTbaWN1XZfvJJYyAnd0YA3yhI8rGjA
         xhGA==
X-Gm-Message-State: AOJu0YzPeHItWivZwZO5UpLjYHDWzNHa+sey3wIPOICjiIyC3g+9QG3r
        6MSvp1oNKW12zrbBYKAyvN4=
X-Google-Smtp-Source: AGHT+IGa7xOUzo11ogbMlU1jbAGyDWCqhs0dCnCLOOikw7upkIvf0Lnyom7hfKgB+o3FMqZ0xKxIWg==
X-Received: by 2002:a17:90a:e006:b0:25f:20f:2f7d with SMTP id u6-20020a17090ae00600b0025f020f2f7dmr9770655pjy.2.1692731989218;
        Tue, 22 Aug 2023 12:19:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:19:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Daniil Lunev <dlunev@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v11 13/16] scsi: ufs: Change the return type of ufshcd_auto_hibern8_update()
Date:   Tue, 22 Aug 2023 12:17:08 -0700
Message-ID: <20230822191822.337080-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A later patch will introduce an error path in ufshcd_auto_hibern8_update().
Change the return type of that function before introducing calls to that
function in the host drivers such that the host drivers only have to be
modified once.

Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-sysfs.c   | 2 +-
 drivers/ufs/core/ufshcd-priv.h | 1 -
 drivers/ufs/core/ufshcd.c      | 6 ++++--
 include/ufs/ufshcd.h           | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 6c72075750dd..a693dea1bd18 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -203,7 +203,7 @@ static ssize_t auto_hibern8_store(struct device *dev,
 		goto out;
 	}
 
-	ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
+	ret = ufshcd_auto_hibern8_update(hba, ufshcd_us_to_ahit(timer));
 
 out:
 	up(&hba->host_sem);
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 0f3bd943b58b..a2b74fbc2056 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -60,7 +60,6 @@ int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
 int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 	enum flag_idn idn, u8 index, bool *flag_res);
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			  struct cq_entry *cqe);
 int ufshcd_mcq_init(struct ufs_hba *hba);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f1bba459b46f..a08924972b20 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4345,13 +4345,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
 }
 
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
+int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	unsigned long flags;
 	bool update = false;
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
-		return;
+		return 0;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ahit != ahit) {
@@ -4368,6 +4368,8 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 040d66d99912..7ae071a6811c 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1363,7 +1363,7 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 }
 
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
+int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
 #define SD_ASCII_STD true
