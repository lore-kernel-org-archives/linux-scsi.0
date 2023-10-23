Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11316C25B42
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjJWV6I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjJWV6H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:58:07 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1DFDE;
        Mon, 23 Oct 2023 14:58:05 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-27d3ede72f6so3339068a91.1;
        Mon, 23 Oct 2023 14:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098285; x=1698703085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SlC0BoedbyGdgzOhgrB/N96VnR6DBEr2m3fzKGpr6oQ=;
        b=ZfjvPcFyIJeBkjjNlBzjUdNBcw9aBH5kH0WXJkTWHlbziNwxvylNvOUQbpUJV3fxwa
         FM0PXMR6tEdfZ9wzFJB7G8hIwBDWF+hPxsDFvbpy03OkdjLBQYcxNycE+eL5iDVhX1Lb
         OQwEFgA+/eSNBKrMchmRpx+0bp5fqspJeqva+JXbCeSW75t0FH+NMDbdY39V7DvAm5Cq
         gbFTXK5DsuRI+lOzhH6w6SSrRQb8HPfol3263+v5Zhkr26rSafE5OPf52Geb/BpqauJB
         AiS7iZXFST14Y0gkE9e1pGsWsU2ziXptnOb68tqyDeOnQn7OeE8nudM1A5k3kKF2rV6+
         nMsA==
X-Gm-Message-State: AOJu0Yzv5D25py1vZs1SX1mBHhTaGs/h3k/bH0HHmPZUK3P4x0eV7K9D
        3aITTdG4ntby8rN9XNyVwV4=
X-Google-Smtp-Source: AGHT+IFeP7+z6b6NCRR7zZBnTFItyvS6sBOpHnYBPFpCOQi0QgK95zM94cfDwRPPfCf7q+E6zFatMQ==
X-Received: by 2002:a17:90a:e509:b0:27d:b811:2fe4 with SMTP id t9-20020a17090ae50900b0027db8112fe4mr9674322pjy.26.1698098284773;
        Mon, 23 Oct 2023 14:58:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:58:04 -0700 (PDT)
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
Subject: [PATCH v14 16/19] scsi: ufs: Change the return type of ufshcd_auto_hibern8_update()
Date:   Mon, 23 Oct 2023 14:54:07 -0700
Message-ID: <20231023215638.3405959-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
