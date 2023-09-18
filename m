Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D14CD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjIRQ6l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjIRQ6W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:58:22 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E1FC;
        Mon, 18 Sep 2023 09:58:12 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-690b7cb71aeso346617b3a.0;
        Mon, 18 Sep 2023 09:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056292; x=1695661092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9DuB17qMl9oy9e417AIV8AKYeS0496ztIEQIihE6qw=;
        b=Bgye6un0ds83TP74ifans1TnH+U86MXT7nABq05yTSkxOJMqLY7smOYWfEVOH0M/ut
         db23xQtbrvLCEXLTbLhI60ElGehuFI6xwKCgksytUtqh6Fa33F06aDSCsHeyuYT/E/Uv
         miyU+lH1qeEdORV5H3pDwG2i/JNBiNRUSHoZHJ4i9Kadt6cjTukgdovFK0atDG0h1jXW
         CsEHQec37gbZMUI9E1wjQtYxr1p8VRmp9PoFSe/1XMiuQ9DxqjnImnobFQv4mDHbA6mc
         /MWvH4nIddjiikEIDAfvcP1kKz4nAiMqPOVRYzzmNgR5qpoDQkO+K9E0jS5QYvqklNZj
         XQdw==
X-Gm-Message-State: AOJu0YzLfVI8OPSmbunXzFlBZPSwHvNKBN1KtUSoBkhIhxokwKGOqr79
        t5KZMWZxikqJIKIA1vgeqzU=
X-Google-Smtp-Source: AGHT+IG5NGSxp3dS5EGbLkPreTHi3JENjtrGCst1Tq3QdOYz9w2vg6ek+mKF8EF2m+hXXHp9rE5xYg==
X-Received: by 2002:a05:6a00:2e03:b0:68f:cdb8:ae33 with SMTP id fc3-20020a056a002e0300b0068fcdb8ae33mr264985pfb.10.1695056291602;
        Mon, 18 Sep 2023 09:58:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id p17-20020a639511000000b005740aa41237sm5658041pgd.74.2023.09.18.09.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:58:11 -0700 (PDT)
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
Subject: [PATCH v12 12/16] scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
Date:   Mon, 18 Sep 2023 09:55:51 -0700
Message-ID: <20230918165713.1598705-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918165713.1598705-1-bvanassche@acm.org>
References: <20230918165713.1598705-1-bvanassche@acm.org>
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
index 93417518c04d..7c196b21d143 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4304,6 +4304,14 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
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
@@ -4323,21 +4331,13 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
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
@@ -8756,8 +8756,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 
 	if (hba->ee_usr_mask)
 		ufshcd_write_ee_control(hba);
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
+	ufshcd_configure_auto_hibern8(hba);
 
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -9743,8 +9742,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
