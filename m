Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C94BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbhK3Xhg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:36 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:34540 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhK3Xhg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:36 -0500
Received: by mail-pl1-f179.google.com with SMTP id y8so16209371plg.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eT49CTrfMRMjuYQ3To+zFxQOc/h8/decsQS961Sdj0c=;
        b=F8dy/i4H4IirlvoCALIJK+YjXTMARUX5a9dZ1G8W+WnIwXr5aOwDyFDgJZSxdg7CcI
         zc8SIWEQXHkHGWzhchgx7VJ1T+61t2+oOfk267MhPJM1GnCPXnZedPysBzJG5WSnNNZd
         fJbmlBMGvK7g+HGfxyQFg21ztU/Gw9QJhULFQzO8IWhs/PtN000A5LOtT5/4JI+K3Euu
         VlR4PvPcDcuVuk50/9ycwKjYdlU1rs31rUMa1P1f2+xL4POPdmEnvC+/3W4qEIlbfZh1
         0MSLPtzsEr8ZFEEAAq8bFIDFYmaQom8/NcUTZEWl4+I7vnwQ0Mz1KxCRVzyZ05IAMqMN
         6ubA==
X-Gm-Message-State: AOAM5305S3OjeLJiQl6Imx9YSCg6TXO5III6oMv+Rkh2MUJR0TfgiQm0
        4T0C3HirsjmzxQ3dyL+OOAw=
X-Google-Smtp-Source: ABdhPJwscVy78eqanp+5h2FfaqKCQ9LlH7nwKJ/+ybRj3qyDoHbYvrtmdtKvLKJu86vZMdqWUN4abQ==
X-Received: by 2002:a17:90a:bb03:: with SMTP id u3mr2752707pjr.85.1638315256306;
        Tue, 30 Nov 2021 15:34:16 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 08/17] scsi: ufs: Remove ufshcd_any_tag_in_use()
Date:   Tue, 30 Nov 2021 15:33:15 -0800
Message-Id: <20211130233324.1402448-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use hba->outstanding_reqs instead of ufshcd_any_tag_in_use(). This patch
prepares for removal of the blk_mq_start_request() call from
ufshcd_wait_for_dev_cmd(). blk_mq_tagset_busy_iter() only iterates over
started requests.

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
 
