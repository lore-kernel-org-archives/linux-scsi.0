Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229DECDB47E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjJRR50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjJRR5F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:57:05 -0400
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECAC18D;
        Wed, 18 Oct 2023 10:57:03 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-57babef76deso3939892eaf.0;
        Wed, 18 Oct 2023 10:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651823; x=1698256623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/rTfHgytuRXp+ZwQl4c9m7yojfusAtRvmfOp3Vdh2A=;
        b=PKssruaCJYU+sm5hYzbZIIfunT08ud//Y1844Qd/E0zZahrywkd2n+ltWK2DmfAMq/
         Uj6vgpPiqio+wASumMfi/+p1jUq5Wc9gZHU2Rih0NSsyRenwEju9nJ1if90WBS9d99+z
         qFhGF9WgH/EcsRd0VMD6+hmjc3ztgf33VhyGpc9hJV30GgseWqwqLs+IcA7f7RovRwQN
         FyyW5WUQgPjO/8jaES4fxomS4GrnB6f25W6zPQmm/FiQmO2LUn354agUkRy3Kg8QTU6E
         Ry5yupwp/yqe/7qZb2h0v5o8fZgjObFxVkTcYYuNNEVWfigwCULfKhdV2Mar90FDKiPT
         aVgQ==
X-Gm-Message-State: AOJu0Yx4ByIUe3jDHLHqV5j7jfuP6amAQx87oyEnRQ1LBCe+m9ju8nmA
        J5XSOFltfN3slomsj/kyaYM=
X-Google-Smtp-Source: AGHT+IEosmTKJLu0U+WpRb6oNiszu/1t0EL43NLQlnSe1oitt49MhMz6fOX//BLMUX8z+8Re6zf9Cw==
X-Received: by 2002:a05:6359:6b8a:b0:164:8252:260c with SMTP id ta10-20020a0563596b8a00b001648252260cmr5616822rwb.8.1697651822835;
        Wed, 18 Oct 2023 10:57:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:57:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v13 14/18] scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
Date:   Wed, 18 Oct 2023 10:54:36 -0700
Message-ID: <20231018175602.2148415-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename ufshcd_auto_hibern8_enable() into ufshcd_configure_auto_hibern8()
since this function can enable or disable auto-hibernation. Since
ufshcd_auto_hibern8_enable() is only used inside the UFSHCI driver core,
declare it static. Additionally, move the definition of this function to
just before its first caller.

Suggested-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 24 +++++++++++-------------
 include/ufs/ufshcd.h      |  1 -
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2df07545f96..38e79ce05545 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4305,6 +4305,14 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
 
+static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_auto_hibern8_supported(hba))
+		return;
+
+	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
+}
+
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	unsigned long flags;
@@ -4324,21 +4332,13 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
-		ufshcd_auto_hibern8_enable(hba);
+		ufshcd_configure_auto_hibern8(hba);
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
 }
 EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
-void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
-{
-	if (!ufshcd_is_auto_hibern8_supported(hba))
-		return;
-
-	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
-}
-
  /**
  * ufshcd_init_pwr_info - setting the POR (power on reset)
  * values in hba power info
@@ -8757,8 +8757,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 
 	if (hba->ee_usr_mask)
 		ufshcd_write_ee_control(hba);
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
+	ufshcd_configure_auto_hibern8(hba);
 
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -9744,8 +9743,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
 
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
+	ufshcd_configure_auto_hibern8(hba);
 
 	goto out;
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7d07b256e906..fceef91d186e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1356,7 +1356,6 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 }
 
-void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
