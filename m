Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2CAC07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C71161260
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhGVCzN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:55:13 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:36603 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhGVCzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:55:09 -0400
Received: by mail-pl1-f176.google.com with SMTP id x16so2958567plg.3
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TwF8z2HSIUF4c23iSPJrCKS4JKSaOsfU0gDVwQyhm94=;
        b=YGZgBjBKabX3Ix+VTJzTHrCA0VUWkCxH0WdjyYnNL42+gHqVlJzYw3I/dtSg9oM6QT
         1dQtZR0gn/9U2YY2Y/GnYfl1SlG6TXHwnkRjW03ROPleb6BR8pAk3HHxf9sNg9xAl8ne
         zDkgiN177W6Zeyymmk7PDPsmEK6Zl3b1lyLDcIw4cSSL9leGhM6Og34Cr34mzV3Fl2mD
         XKwYujdfdG+Ue5meYMoorbcXKf8EPg/I8OmZoQbYay8B0VyXqjrsG6EMTJOee5Tw3ads
         4efOdTHq/r79AJhu83sRAHvQEBDkVWonPxHpCC1luO+wVQCmJaYEmHTvO/iyxvsXFqgK
         llBg==
X-Gm-Message-State: AOAM5321BNIFY36VtTb5fCaKE6i8RclEE4Y8gH0YZuAnAY4bovnGr2OT
        t7gGoYkDQfnkNBGzE6VoZtA=
X-Google-Smtp-Source: ABdhPJyAX15FRVUI04FAp+KMHceng3vARBsroFIUn5D+AtULGGv/0lmuv7dTtqNAGLc1sGawLUFOUA==
X-Received: by 2002:aa7:83d9:0:b029:2eb:b0ef:2a67 with SMTP id j25-20020aa783d90000b02902ebb0ef2a67mr39723107pfn.1.1626924943798;
        Wed, 21 Jul 2021 20:35:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v3 12/18] scsi: ufs: Optimize serialization of setup_xfer_req() calls
Date:   Wed, 21 Jul 2021 20:34:33 -0700
Message-Id: <20210722033439.26550-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reduce the number of times the host lock is taken in the hot path.
Additionally, inline ufshcd_vops_setup_xfer_req() because that function is
too short to keep it.

Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Fixes: a45f937110fa ("scsi: ufs: Optimize host lock on transfer requests send/compl paths")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c |  3 ++-
 drivers/scsi/ufs/ufshcd.h | 12 ------------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cb588b705fbb..436d814f4c1e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2091,12 +2091,13 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 
 	lrbp->issue_time_stamp = ktime_get();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
-	ufshcd_vops_setup_xfer_req(hba, task_tag, (lrbp->cmd ? true : false));
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->vops && hba->vops->setup_xfer_req)
+		hba->vops->setup_xfer_req(hba, task_tag, !!lrbp->cmd);
 	set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a44baec43dd5..6df847facd1d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1237,18 +1237,6 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
 	return -ENOTSUPP;
 }
 
-static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
-					bool is_scsi_cmd)
-{
-	if (hba->vops && hba->vops->setup_xfer_req) {
-		unsigned long flags;
-
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
-}
-
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
