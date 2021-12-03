Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B955EC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383428AbhLCXYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:36 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:40889 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383421AbhLCXYg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:36 -0500
Received: by mail-pl1-f174.google.com with SMTP id v19so3118213plo.7
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QO87TjjZHhEnTm5wG2q7sGnYRMn1FImZKprz4Ef5To4=;
        b=O/6i9Ao38ZzyqSaBQbBnYVZLCeCxWirJdi2VZyrVf+zMn4FW7OBZhkwrm8KNpdAQtJ
         CSxsNwa26yGxVsGBv2UddS357LHzg74UYCkiHd6iCnXfCuIHhiuurVJbtzc+iUa5x14R
         Z3v/cBurTGLVfuCtjBgp0A5BFgdy0Z4lWPfM9nGOgPjsAYqKFYU0Jcxb0jidQBfv7yiN
         MwvuFVAeD508PTrKO4hIYr+JVosjIcOL+kiGO3WgMEh1irZ9hTS7AQFT8gSM5PHkYILG
         Glcw3uL302lK5j8WYcnJzucFyugfVKM6VDG3DqiZx9x+73lcL7GXr25cZlWxJJR3qSRH
         h8zQ==
X-Gm-Message-State: AOAM531tbVvQyvyT6bsJF00mHEJkUZHJAk7aFnQw+Dw9kRGJGMXdIt1W
        QyuwVuUllFnydD0oEV5Jx5Y=
X-Google-Smtp-Source: ABdhPJzAHNmWybilw3Sj6/muUWyXfeI5I/Zb5w10pzvK6xN7Z+3BP6alPJl6OoD5xvPExtv342UcyQ==
X-Received: by 2002:a17:90a:fe0b:: with SMTP id ck11mr17432009pjb.15.1638573671472;
        Fri, 03 Dec 2021 15:21:11 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:10 -0800 (PST)
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
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v4 10/17] scsi: ufs: Remove hba->cmd_queue
Date:   Fri,  3 Dec 2021 15:19:43 -0800
Message-Id: <20211203231950.193369-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The previous patch removed all code that uses hba->cmd_queue. Hence also
remove hba->cmd_queue itself.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 11 +----------
 drivers/scsi/ufs/ufshcd.h |  2 --
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index da4714aaa850..2cd777d92c7b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9331,7 +9331,6 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
@@ -9551,12 +9550,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_disable;
 	}
 
-	hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
-	if (IS_ERR(hba->cmd_queue)) {
-		err = PTR_ERR(hba->cmd_queue);
-		goto out_remove_scsi_host;
-	}
-
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
 		.nr_hw_queues	= 1,
 		.queue_depth	= hba->nutmrs,
@@ -9565,7 +9558,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	};
 	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
 	if (err < 0)
-		goto free_cmd_queue;
+		goto out_remove_scsi_host;
 	hba->tmf_queue = blk_mq_init_queue(&hba->tmf_tag_set);
 	if (IS_ERR(hba->tmf_queue)) {
 		err = PTR_ERR(hba->tmf_queue);
@@ -9634,8 +9627,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	blk_cleanup_queue(hba->tmf_queue);
 free_tmf_tag_set:
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-free_cmd_queue:
-	blk_cleanup_queue(hba->cmd_queue);
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 out_disable:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c3c2792f309f..8e942762e668 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -738,7 +738,6 @@ struct ufs_hba_monitor {
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
  * @lrb: local reference block
- * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_lock: Protects @outstanding_reqs.
  * @outstanding_reqs: Bits representing outstanding transfer requests
@@ -804,7 +803,6 @@ struct ufs_hba {
 
 	struct Scsi_Host *host;
 	struct device *dev;
-	struct request_queue *cmd_queue;
 	/*
 	 * This field is to keep a reference to "scsi_device" corresponding to
 	 * "UFS device" W-LU.
