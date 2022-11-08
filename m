Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26925C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiKHXeg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiKHXef (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:34:35 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA901209BC
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 15:34:34 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id r61-20020a17090a43c300b00212f4e9cccdso263899pjg.5
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 15:34:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3WnLm69ZiaWPg1cVDypd8ULqDeVocn5tf38rTIOkuNk=;
        b=SOxYN5kOpOA3l503mNZj4CT43eszxh0SAVll7c3q1F+UV0whSCs5pIETXO0LPF2a8n
         /1MfX384M28mkntMBtESqiRwzh9RxKlQ4DS8HN9/0nbDMAVCG5EF7uYlCg0rdM0Y7IqV
         7Q08ImTg0Jy/c1Cf9froUp8yffhhrf1IbdNzSbdmxsW7yLR9TdY2HLQxxuYR8GWazyGC
         Lil4q8o4RwfMrXVZRMVkUBvVmwComfmJv4Nu5KD0aEhngc+T4Ub/Hkx7t0lODSNFYlf6
         T35798GE20yxBzLoXbVMfuF1/GHChyZmc3IgVjWSptcqo9ZOXKXGEx5q6E/YuMkBUuXJ
         WC8A==
X-Gm-Message-State: ACrzQf0qVtAhFJPsT+XZfzL7kpejxu9An9UCifTJY01vWevoDKyXscMZ
        txqKB2wx56LWvqRw+a+tvP4=
X-Google-Smtp-Source: AMsMyM62mq+brVsUUVzN5tKSKgtMd+ZCMyqgST6MxKijGjT9hhlHyqEJlwFYdqbHp6TWdd7cRA31bA==
X-Received: by 2002:a17:90a:6909:b0:212:f535:a34b with SMTP id r9-20020a17090a690900b00212f535a34bmr61380826pjj.6.1667950474250;
        Tue, 08 Nov 2022 15:34:34 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:44ad:aec5:7cab:4532])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7982a000000b005618189b0ffsm6918088pfl.104.2022.11.08.15.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:34:33 -0800 (PST)
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
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 4/5] scsi: ufs: Add suspend/resume SCSI command processing support
Date:   Tue,  8 Nov 2022 15:33:38 -0800
Message-Id: <20221108233339.412808-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
In-Reply-To: <20221108233339.412808-1-bvanassche@acm.org>
References: <20221108233339.412808-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This functionality is needed by UFS drivers to e.g. suspend SCSI command
processing while reprogramming encryption keys if the hardware does not
support concurrent I/O and key reprogramming. This patch prepares for
adding support in the upstream kernel for the Pixel 6 and 7 UFS
controllers.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 20 ++++++++++++++++++++
 include/ufs/ufshcd.h      |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7b2948592c4a..fa1c84731b8e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1707,6 +1707,26 @@ static void ufshcd_ungate_work(struct work_struct *work)
 	ufshcd_scsi_unblock_requests(hba);
 }
 
+/*
+ * Block processing of new SCSI commands and wait until pending SCSI
+ * commands and TMFs have finished. ufshcd_exec_dev_cmd() and
+ * ufshcd_issue_devman_upiu_cmd() are not affected by this function.
+ *
+ * Return: 0 upon success; -EBUSY upon timeout.
+ */
+int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us)
+{
+	return ufshcd_clock_scaling_prepare(hba, timeout_us);
+}
+EXPORT_SYMBOL_GPL(ufshcd_freeze_scsi_devs);
+
+/* Resume processing of SCSI commands. */
+void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba)
+{
+	ufshcd_clock_scaling_unprepare(hba, true);
+}
+EXPORT_SYMBOL_GPL(ufshcd_unfreeze_scsi_devs);
+
 /**
  * ufshcd_hold - Enable clocks that were gated earlier due to ufshcd_release.
  * Also, exit from hibern8 mode and set the link as active.
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 5cf81dff60aa..bd45818bf0e8 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1186,6 +1186,9 @@ void ufshcd_release(struct ufs_hba *hba);
 
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value);
 
+int ufshcd_freeze_scsi_devs(struct ufs_hba *hba, u64 timeout_us);
+void ufshcd_unfreeze_scsi_devs(struct ufs_hba *hba);
+
 void ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 				  int *desc_length);
 
