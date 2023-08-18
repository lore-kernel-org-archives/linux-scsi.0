Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86792EE499D
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379819AbjHRTqO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379901AbjHRTqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:46:00 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5320C421C;
        Fri, 18 Aug 2023 12:45:37 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1bdbf10333bso10697445ad.1;
        Fri, 18 Aug 2023 12:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387876; x=1692992676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hgOAgWZfyUnXg0UmZ/VcOkHNMzTjWrEOvdI22N5O+Zo=;
        b=GVKYv5mi9BVsUwrOIgoKmWBx+tBo2N3r4IjXwOjcMgHcbfr3pr2WCmFwTvlvTLoBSY
         QoyEg6yWP8VVjXP7C+qUpApTQT+kHeT6d6eqoQ85PPTxMG/2j72LCOm0pJL95OV8XlFE
         VFKyid7syMdqJwLYsiDbQGqi/2qS+NRPd4ojhPlynMEf7WJdz+cxpPj0GXMqEapetcS7
         Y2Ygk9JLuz1oqY0wsxLiHSnbULD33UD6lvD+a/Bgq5RzEMz8soMzxlpzgi7Z0tlw2xEH
         neDkfXZjeLvmhx+WNHDWqVJkKFbKVqhDeoiJ78p1jOzBorzIjBnTzcp64fsUG+sTREeu
         vLKg==
X-Gm-Message-State: AOJu0Yzu/5kkdB4+oC4ul4M7+mAXEio5TNcsPANdjSTsKslVXs+pDmCM
        GqI+4yeUfgBLei96i+14QpY=
X-Google-Smtp-Source: AGHT+IEWcLSnhP38RPZJZ48kalt2cffBfI8OjqEUDdBnjJV1qJK07mUdEfXxLFzJtmm5p+Jd9Ud8pA==
X-Received: by 2002:a17:902:e80e:b0:1bf:423:957b with SMTP id u14-20020a170902e80e00b001bf0423957bmr258608plg.26.1692387875707;
        Fri, 18 Aug 2023 12:44:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:44:35 -0700 (PDT)
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
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
Subject: [PATCH v10 15/18] scsi: ufs: Rename ufshcd_auto_hibern8_enable() and make it static
Date:   Fri, 18 Aug 2023 12:34:18 -0700
Message-ID: <20230818193546.2014874-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
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
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 24 +++++++++++-------------
 include/ufs/ufshcd.h      |  1 -
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 053b82eac80f..a08924972b20 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4337,6 +4337,14 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
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
 int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
 	unsigned long flags;
@@ -4356,7 +4364,7 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
-		ufshcd_auto_hibern8_enable(hba);
+		ufshcd_configure_auto_hibern8(hba);
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
@@ -4365,14 +4373,6 @@ int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
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
@@ -8817,8 +8817,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 
 	if (hba->ee_usr_mask)
 		ufshcd_write_ee_control(hba);
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
+	ufshcd_configure_auto_hibern8(hba);
 
 	ufshpb_toggle_state(hba, HPB_RESET, HPB_PRESENT);
 out:
@@ -9811,8 +9810,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
 
-	/* Enable Auto-Hibernate if configured */
-	ufshcd_auto_hibern8_enable(hba);
+	ufshcd_configure_auto_hibern8(hba);
 
 	ufshpb_resume(hba);
 	goto out;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index ffc6ffe45fe1..7ae071a6811c 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1363,7 +1363,6 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
 }
 
-void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
 int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
 			     const struct ufs_dev_quirk *fixups);
