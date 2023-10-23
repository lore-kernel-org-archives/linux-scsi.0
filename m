Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6851C25B42
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbjJWV55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjJWV5p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:45 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6600D10C7;
        Mon, 23 Oct 2023 14:57:41 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-27d104fa285so3271984a91.2;
        Mon, 23 Oct 2023 14:57:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098260; x=1698703060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/rTfHgytuRXp+ZwQl4c9m7yojfusAtRvmfOp3Vdh2A=;
        b=s/CZi8rJMDqmy7kRxIeydUsGyoc9fBvPwnCOW8BrtPKu3Ufq9urgjNcdvUFhogB84Q
         s+thmrFlGFNqFrDst1RXg0Bv42OMbTYkk7iAlbwOKWSbVoWrhJBn6kmPhbWhXoAlXlpy
         u34Uh9alzBCaKvPa+7C0DSaYsF5ryd8GS05QwWm9oRJrCnGRYmNnk/647MmaksvceFSL
         x8aTFxFWaU/ZZ1vXrlOBfV8gGuJosSmhANXcObQI9czrikXHyEpEiRO7YrhE8ogM01a1
         4TO+R9k4N4r50UMWx8wBPnn80qh1z03bfTwJwnfS6ZUXUepMK6dxUb4zGOQQMifS4Ep+
         GaXw==
X-Gm-Message-State: AOJu0YxHFh3P4tcnYLdpr0gcpTV+z9vWAQLJot0FCdjVmDijCBIiOO71
        dGX+lrZN70MuNoKV2EglfsOajVaqG50=
X-Google-Smtp-Source: AGHT+IGF0iJVAOVzzctpRgkGvOhgNZ639u9wvySQziNJqVj3qVn+HQLNn9Drfsvv2trpTSO2URte6Q==
X-Received: by 2002:a17:90a:355:b0:273:cb91:c74f with SMTP id 21-20020a17090a035500b00273cb91c74fmr9822927pjf.8.1698098260472;
        Mon, 23 Oct 2023 14:57:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:57:40 -0700 (PDT)
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
Subject: [PATCH v14 15/19] scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
Date:   Mon, 23 Oct 2023 14:54:06 -0700
Message-ID: <20231023215638.3405959-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
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
