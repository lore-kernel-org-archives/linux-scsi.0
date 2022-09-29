Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA77C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiI2WBi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiI2WBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:01:37 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065D112AEF2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:35 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id iw17so2418054plb.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3ITzk+ZRZ59eMKdf+XTB3AoLD9+LWF5ZWoxbHXTbn5Q=;
        b=aQLRe1Tf5vtUgekJPZo/EcNVuFuOu2xH2XVHrhqStdnBsYMu/meZ2zP785+PKcQzVm
         +CaGMd0oTstQdvyxg+4vhZR4jk3gJ8mfk7EUD1Nh7V5ZuA6lcWKrlfEPEJbeacds4zua
         UXkFm2zIn0EKoIlHdpFqaoG9daT//s3qvMJc9h2VxexotpcUw8jYXG48Rk4e6k89WFJZ
         NQuqNA6i1qmpHN4SL/9dKxy4YHLkcgGsPuX4Q0vuWuTas0XVI2emqVkImnabVxPDUM46
         Z7uLBPC4D/R+gM+Q4deJb7SOsS5vOa9PVWZ9fFyE1VEnJGZjJPmOaAQdisjuK/eKQECA
         txoQ==
X-Gm-Message-State: ACrzQf3t5eviGBBAgd1UBCJwrQKOAr24jU103HXOvt/8uFRNBbqcKFk5
        F6uWnSo2oMPXhiDfaY0KQq8=
X-Google-Smtp-Source: AMsMyM4vAUwLWL3K9lyWE6HnCBfqMQxLwptqnBGT/UJ92XJA1AqIRqaSRTeDo+6j5ecLb3tfEZ9loA==
X-Received: by 2002:a17:903:188:b0:178:3d49:45a0 with SMTP id z8-20020a170903018800b001783d4945a0mr5550945plg.154.1664488894465;
        Thu, 29 Sep 2022 15:01:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:01:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v3 7/8] scsi: ufs: Track system suspend / resume activity
Date:   Thu, 29 Sep 2022 15:00:20 -0700
Message-Id: <20220929220021.247097-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new boolean variable that tracks whether the system is suspending,
suspended or resuming. This information will be used in a later patch to
fix a deadlock between the SCSI error handler and the suspend code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 include/ufs/ufshcd.h      | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e8c0504e9e83..5507d93a4bba 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9253,6 +9253,7 @@ static int ufshcd_wl_suspend(struct device *dev)
 
 	hba = shost_priv(sdev->host);
 	down(&hba->host_sem);
+	hba->system_suspending = true;
 
 	if (pm_runtime_suspended(dev))
 		goto out;
@@ -9294,6 +9295,7 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_sys_suspended = false;
+	hba->system_suspending = false;
 	up(&hba->host_sem);
 	return ret;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9f28349ebcff..96538eb3a6c0 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -802,7 +802,9 @@ struct ufs_hba_monitor {
  * @caps: bitmask with information about UFS controller capabilities
  * @devfreq: frequency scaling information owned by the devfreq core
  * @clk_scaling: frequency scaling information owned by the UFS driver
- * @is_sys_suspended: whether or not the entire system has been suspended
+ * @system_suspending: system suspend has been started and system resume has
+ *	not yet finished.
+ * @is_sys_suspended: UFS device has been suspended because of system suspend
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
@@ -943,6 +945,7 @@ struct ufs_hba {
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
+	bool system_suspending;
 	bool is_sys_suspended;
 
 	enum bkops_status urgent_bkops_lvl;
