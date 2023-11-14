Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE6BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjKNVTV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjKNVTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:19:17 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D456F9D;
        Tue, 14 Nov 2023 13:19:14 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1cc329ce84cso54690865ad.2;
        Tue, 14 Nov 2023 13:19:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996754; x=1700601554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LVqfYcvdgpr14aJfDAk0DLCnWHZd5hJ9BIYRPuekypM=;
        b=kib4vt19aDKzsa0+KANCEqVnS1yxjSk6IsWEdFIrPYcOPnmR/XIbIjh06iR7MY3MIU
         a0PZ6v1SSVQ5gqtbbHqETIJq1WR5PhXXXYeGOQDGult7aTx1NRV95F6cUG1U5oMMnSIF
         KbM3JfBpQZg9Ohiiq6LvPpd6OZgfEYtlFQ+rv/YCDag3kxEoXForfyJvczwDSdquaIZX
         8Q88TJo4AAibmMnG73DCYYYwyy2DgJ7m6IvTHMIPKh+CnNqCTTBYYH4NcJCOYt5e14Vm
         +dKU+w3yXnLghErBbnztndxPgkvv/OjS1T9RqlcXWbus6qSVWWrY2Q2pOkqKVim7ULwL
         SPpg==
X-Gm-Message-State: AOJu0YydQe+Vswd3zf67F8C9gvhmjqsj4khyF2BrTjUyC89L2SiVOGKM
        Mz7SVSsBwpQIQd6USZJvsuVeD5hO0ZE=
X-Google-Smtp-Source: AGHT+IFWNIpMHYIm0btFZHTOJ9/LbXu82quF73+bVhO7wz2AsL9zFKlc98HkiDa+3GPVKGAfTFPMNw==
X-Received: by 2002:a17:902:bc84:b0:1cc:431f:55e6 with SMTP id bb4-20020a170902bc8400b001cc431f55e6mr3336699plb.63.1699996754154;
        Tue, 14 Nov 2023 13:19:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:19:13 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v15 15/19] scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
Date:   Tue, 14 Nov 2023 13:16:23 -0800
Message-ID: <20231114211804.1449162-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
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
index 8b1031fb0a44..e80878a5d4e6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4401,6 +4401,14 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
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
@@ -4420,21 +4428,13 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
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
@@ -8864,8 +8864,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 
 	if (hba->ee_usr_mask)
 		ufshcd_write_ee_control(hba);
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
+	ufshcd_configure_auto_hibern8(hba);
 
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -9862,8 +9861,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
 
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
+	ufshcd_configure_auto_hibern8(hba);
 
 	goto out;
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7f0b2c5599cd..4156dc2b389b 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1360,7 +1360,6 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 }
 
-void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
 void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
