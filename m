Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7671ECDB483
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjJRR5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbjJRR5h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:57:37 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66766112;
        Wed, 18 Oct 2023 10:57:32 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6b20577ef7bso4468925b3a.3;
        Wed, 18 Oct 2023 10:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651851; x=1698256651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SlC0BoedbyGdgzOhgrB/N96VnR6DBEr2m3fzKGpr6oQ=;
        b=nkJAvDImWxkFw8cKf/gAE6/nqCYD6FLdNixVJySvsNBTLfP3PJKbyRQhaOqXJJqBNR
         BX2gRTpkXf3YXHTjGxqNWFXsuYIGcamOLUR3kb3MhEu2NR6589WdVSGKYgFlVQwXa4dx
         Eew7IdJRmpVBzNVS6t+n/gs422jwh/7OdXkoIZXJyz3It/ltKvJXv2hV+FIlB66E/W9I
         hY94q5CXQle8cnUJJ+Eh27deODLEwKJlES8RhOqXMDF/PhF4u+LloLs/AE5mkdCD21rD
         yAm9e83LSLYnhKqztwH9NPxU4lh9GqAVoKb8rqYyEp9aeh5qlK5XI2MNaFE+gmhRXmdf
         QvNA==
X-Gm-Message-State: AOJu0YzW2rGjQbcVrULeVyVP71UwDZ2Yx652mjPck4rxhzLzuoETaMzF
        vvXdDfSIXTLpS6DoNj79uvM=
X-Google-Smtp-Source: AGHT+IGjesUfB53pu6vQMcCxZ3Op2MJPL98hOFKojEeVsi6W5cAS+D3Shh022RYWcgilQwSAUsugoQ==
X-Received: by 2002:a05:6a00:1891:b0:68e:43ed:d30b with SMTP id x17-20020a056a00189100b0068e43edd30bmr6578242pfh.21.1697651851342;
        Wed, 18 Oct 2023 10:57:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:57:31 -0700 (PDT)
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
        Arthur Simchaev <arthur.simchaev@wdc.com>,
        Lu Hongfei <luhongfei@vivo.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        zhanghui <zhanghui31@xiaomi.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v13 15/18] scsi: ufs: Change the return type of ufshcd_auto_hibern8_update()
Date:   Wed, 18 Oct 2023 10:54:37 -0700
Message-ID: <20231018175602.2148415-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
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
index c95906443d5f..a1554eac9bbc 100644
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
index f42d99ce5bf1..de8e891da36a 100644
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
index 38e79ce05545..d3718fbe51b9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4313,13 +4313,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
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
@@ -4336,6 +4336,8 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index fceef91d186e..8fd95a5d5538 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1356,7 +1356,7 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 }
 
-void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
+int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
 #define SD_ASCII_STD true
