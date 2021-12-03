Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647F6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383340AbhLCXYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:14 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:55060 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376419AbhLCXYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:14 -0500
Received: by mail-pj1-f45.google.com with SMTP id np3so3426473pjb.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0/WF1cKS8jhYGebwL6h+RPxXoGzjOvzbqSF8ETpM3SU=;
        b=v1OpmG2UQbc3tQAizoXwuUlwLiPmI8GEzJn5zT5TmU3ANVLVLcl5S9fdjCuNuifTTm
         dPUKSE4VnHrkQDM0r4FRu4tR2QOisme1M3a2FzYKrpaFTk8qBBjcPSMQ9ogbmTJgNziP
         ArIjbpKrXVCcGffVAQJmKerjl9fLeSmjByT5hP1GKJNdKm8dwOSRMbNGKJuyG4x1h90p
         Q5jVMqAykPxyvYm8zBeB7i4IwMCLU2mjQ6SnqyYZlQHNjZ/T4xbgPTSvJBRrLdgFAC+W
         +KlY4EUJdjnEaFSgMk0QQ6n+Uq5amRKlaVpqGQ+zIhi49ZR2fhE+M0/fixfiBTwhL6NF
         HGJQ==
X-Gm-Message-State: AOAM530XM0jc+SSqwpagot48MrdWgkN+zc/CnqjaSsJld+xxCQruN+L/
        Kav2RZPmKKJXvdZzb2osDAo=
X-Google-Smtp-Source: ABdhPJwkw+vdayduepI3bT9gYPJj+40R76maxYNKBIy4yo0r3K4H1eJcqmO1nosYaGX12LuAQ2fJjQ==
X-Received: by 2002:a17:90a:1b45:: with SMTP id q63mr17934696pjq.135.1638573649766;
        Fri, 03 Dec 2021 15:20:49 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v4 07/17] scsi: ufs: Remove ufshcd_any_tag_in_use()
Date:   Fri,  3 Dec 2021 15:19:40 -0800
Message-Id: <20211203231950.193369-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use hba->outstanding_reqs instead of ufshcd_any_tag_in_use(). This patch
prepares for removal of the blk_mq_start_request() call from
ufshcd_wait_for_dev_cmd(). blk_mq_tagset_busy_iter() only iterates over
started requests.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 04a19b826837..974bf47e733c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1352,25 +1352,6 @@ static int ufshcd_devfreq_target(struct device *dev,
 	return ret;
 }
 
-static bool ufshcd_is_busy(struct request *req, void *priv, bool reserved)
-{
-	int *busy = priv;
-
-	WARN_ON_ONCE(reserved);
-	(*busy)++;
-	return false;
-}
-
-/* Whether or not any tag is in use by a request that is in progress. */
-static bool ufshcd_any_tag_in_use(struct ufs_hba *hba)
-{
-	struct request_queue *q = hba->cmd_queue;
-	int busy = 0;
-
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_busy, &busy);
-	return busy;
-}
-
 static int ufshcd_devfreq_get_dev_status(struct device *dev,
 		struct devfreq_dev_status *stat)
 {
@@ -1769,7 +1750,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 
 	if (hba->clk_gating.active_reqs
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
+		|| hba->outstanding_reqs || hba->outstanding_tasks
 		|| hba->active_uic_cmd || hba->uic_async_done)
 		goto rel_lock;
 
