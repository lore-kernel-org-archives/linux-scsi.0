Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1217C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383440AbhLCXZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:25:02 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:46771 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383434AbhLCXZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:25:02 -0500
Received: by mail-pg1-f171.google.com with SMTP id r138so4481204pgr.13
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0VNtnzz9TknhCoqF8tEmp0xmaoEWRugruPGfbtRFwJc=;
        b=oZWuU4nmbsYEmKCyaKppowRsPt6eFZpKPDOTiUNJ/6VdOGdDENFfwYp8QKxL55s8jc
         TqY5O6oG2Dz57cLILqxrhzv3CTLv/mXOATopMoC5LaDmsJ6VxcFk5zXCr7Iz9Td0By0S
         RIX2hgAmzFl8ktEtV4Vka9M3iATuhE7iEsXpE7D03JiaBo0ha1FNxE33x0QuSjz8r+Uu
         zFjJfODuLOBPJbtQ1ON2CljzNJGVQkQC7BDpmBl7fIChTw2+BNRUBpwvWA6oqhGmT7eP
         VkWhYRRzlTGip5bY23JeigxhN70XkcJeGJVMP3d0xPenJAa8zi+gyUlBQfg/BbyjWz0R
         QKXg==
X-Gm-Message-State: AOAM533/g2W0IApHm5HjkZRbrYiY2rbljvnI/NjxKLhF83nFOx9fDXM+
        vjIl4hpkG3mh0ifZgeHwTpA=
X-Google-Smtp-Source: ABdhPJz8Iwiy3p5qGkWLqHVaTrZiB+Rqe9elcngdJNQLwKvZr2/aALDMHgDo9LcsZKnMJXy5cVnz4g==
X-Received: by 2002:a63:1b4b:: with SMTP id b11mr6886972pgm.322.1638573697417;
        Fri, 03 Dec 2021 15:21:37 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:36 -0800 (PST)
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
Subject: [PATCH v4 15/17] scsi: ufs: Stop using the clock scaling lock in the error handler
Date:   Fri,  3 Dec 2021 15:19:48 -0800
Message-Id: <20211203231950.193369-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of locking and unlocking the clock scaling lock, surround the
command queueing code with an RCU reader lock and call synchronize_rcu().
This patch prepares for removal of the clock scaling lock.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d434d76aa657..9f0a1f637030 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2684,6 +2684,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	/*
+	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
+	 * calls.
+	 */
+	rcu_read_lock();
+
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
@@ -2762,7 +2768,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	ufshcd_send_command(hba, tag);
+
 out:
+	rcu_read_unlock();
+
 	up_read(&hba->clk_scaling_lock);
 
 	if (ufs_trigger_eh()) {
@@ -5951,8 +5960,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	synchronize_rcu();
 	cancel_work_sync(&hba->eeh_work);
 }
 
