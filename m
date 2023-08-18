Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46435EE4999
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Aug 2023 19:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379835AbjHRTrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Aug 2023 15:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379862AbjHRTr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Aug 2023 15:47:27 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C515D46A0;
        Fri, 18 Aug 2023 12:46:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bf3a2f44f0so7514845ad.2;
        Fri, 18 Aug 2023 12:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692387885; x=1692992685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uz9IhUw0fhLa+d31AmvvxEIaG6umYa3gXf+jIQrc2ys=;
        b=PhRffwHiAyj6u6YTl0ReefmOAkIBluNmMZwCgHnLHOuykbGBxja3DYnUXDr0xRhEJH
         Cq+Fof+W3RHa5nrjM8POjIPB3MKgR9CSOCIKVsNvLtq33Z7xYP2m8pB0PWH3JvYQUhtM
         JcSp+yHs6PGPFwDRl2pZzvr6iTtXEJ/JpgHXn4FjuwUBy+jB5aHRyRlpWNt5SEvWc9qc
         oxcbDByyNohfV4v0NDqBl9z4uTtQOhgCMbZ1pzxtJQHRPVpkR0t4XRMgij5sEPHTNKTr
         f/ePVWBy+R2DsOnt6QiUS+G96udMSbZMtOjF8Yhzu7J7oP8EQ7tdr03KHwPCq1HOBfDl
         QFXw==
X-Gm-Message-State: AOJu0Yzo49EX5HEpMqL6Z7KXGD1sFvFQ5HD6awXv5GwW628XUCaI510p
        o7yaCw9QPaivHmtZL/AxXGs=
X-Google-Smtp-Source: AGHT+IHlu8hqOTbdqsplVPmXn7e7E+Hc5Whx5dtj8RVMixWwtLZu6cu1FccsMZoLOVVJr8Khijpabw==
X-Received: by 2002:a17:902:ee89:b0:1bd:e877:a7bc with SMTP id a9-20020a170902ee8900b001bde877a7bcmr226318pld.7.1692387884731;
        Fri, 18 Aug 2023 12:44:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5012:5192:47aa:c304])
        by smtp.gmail.com with ESMTPSA id u16-20020a170903125000b001bb8be10a84sm2115801plh.304.2023.08.18.12.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 12:44:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Can Guo <quic_cang@quicinc.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v10 16/18] scsi: ufs: Simplify ufshcd_auto_hibern8_update()
Date:   Fri, 18 Aug 2023 12:34:19 -0700
Message-ID: <20230818193546.2014874-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230818193546.2014874-1-bvanassche@acm.org>
References: <20230818193546.2014874-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calls to ufshcd_auto_hibern8_update() are already serialized: this
function is either called if user space software is not running
(preparing to suspend) or from a single sysfs store callback function.
Kernfs serializes sysfs .store() callbacks.

No functionality is changed. This patch makes the next patch in this
series easier to read.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Can Guo <quic_cang@quicinc.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a08924972b20..68bf8e94eee6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4347,21 +4347,13 @@ static void ufshcd_configure_auto_hibern8(struct ufs_hba *hba)
 
 int ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 {
-	unsigned long flags;
-	bool update = false;
+	const u32 cur_ahit = READ_ONCE(hba->ahit);
 
-	if (!ufshcd_is_auto_hibern8_supported(hba))
+	if (!ufshcd_is_auto_hibern8_supported(hba) || cur_ahit == ahit)
 		return 0;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ahit != ahit) {
-		hba->ahit = ahit;
-		update = true;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (update &&
-	    !pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
+	WRITE_ONCE(hba->ahit, ahit);
+	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
 		ufshcd_configure_auto_hibern8(hba);
