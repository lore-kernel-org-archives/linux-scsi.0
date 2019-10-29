Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78739CA9EC4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 553422086A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfJ2XHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:07:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35352 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfJ2XHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 19:07:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id d13so176742pfq.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 16:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qI0vB1ht784SEbdQ8xMLIrR45Ab8C5O3nNjvAnIo0gE=;
        b=rdTSg+7a7P5iZCfEXyLrtHaqX1cWbxQ+I4UPlBV24r6OpUrWu4qdSZdogF/I8QPRit
         t3eEg4Z/BlTbJkOkT6cKTbok5cAp2mC49gd8FMIbvvQ2/LmUjY6sgV+QBVjz/4PI5nQz
         7qoQXkeAxGA0/0elaSskBv4WmEsiI/5N6/+XWm9NISbW/swv4N+c26PFm63FwB42ntXW
         OFKAuqoTx9Cu8Ebm6tmQoCVuKDzZX9Cjqu5eyWU8feNWQ3rAE4dmyTdQ2/gwW0q3RopN
         h1C3MYQzYI2xMTw/3aAsn5yvWKJ9dnZkWM1M3bhAwzHvUkfyMPIdT4vAGNoR2wQ2U10g
         S+Cw==
X-Gm-Message-State: APjAAAVz5EJwEpWap2t4lpNivAf2bBVWMqXjmzqwSL8gi4Yn0d4hRO3g
        ME/CfBiPGthcL4lQdTmKtMU=
X-Google-Smtp-Source: APXvYqwm3tmEbKSYGTR3Fdwmm56u3qbA3a1PAXUmyamMHdxNYUEpCSvpg7UEc2hAnz2KejCxTE8KDw==
X-Received: by 2002:a17:90a:d3c7:: with SMTP id d7mr9666525pjw.22.1572390440798;
        Tue, 29 Oct 2019 16:07:20 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z21sm170500pfa.119.2019.10.29.16.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 16:07:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/3] ufs: Remove .setup_xfer_req()
Date:   Tue, 29 Oct 2019 16:07:10 -0700
Message-Id: <20191029230710.211926-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191029230710.211926-1-bvanassche@acm.org>
References: <20191029230710.211926-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the function ufshcd_vops_setup_xfer_req() is the only user of the
setup_xfer_req function pointer and since that function pointer is always
zero, remove both this function and the function pointer. This patch
does not change any functionality.

Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c |  2 --
 drivers/scsi/ufs/ufshcd.h | 10 ----------
 2 files changed, 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 180033b4b515..9fc05a535624 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2487,7 +2487,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -2704,7 +2703,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247c719e..e3593cce23c1 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -288,8 +288,6 @@ struct ufs_pwr_mode_info {
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
  *			to be set.
- * @setup_xfer_req: called before any transfer request is issued
- *                  to set some things
  * @setup_task_mgmt: called before any task management request is issued
  *                  to set some things
  * @hibern8_notify: called around hibern8 enter/exit
@@ -318,7 +316,6 @@ struct ufs_hba_variant_ops {
 					enum ufs_notify_change_status status,
 					struct ufs_pa_layer_attr *,
 					struct ufs_pa_layer_attr *);
-	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
 					enum ufs_notify_change_status);
@@ -1031,13 +1028,6 @@ static inline int ufshcd_vops_pwr_change_notify(struct ufs_hba *hba,
 	return -ENOTSUPP;
 }
 
-static inline void ufshcd_vops_setup_xfer_req(struct ufs_hba *hba, int tag,
-					bool is_scsi_cmd)
-{
-	if (hba->vops && hba->vops->setup_xfer_req)
-		return hba->vops->setup_xfer_req(hba, tag, is_scsi_cmd);
-}
-
 static inline void ufshcd_vops_setup_task_mgmt(struct ufs_hba *hba,
 					int tag, u8 tm_function)
 {
-- 
2.24.0.rc0.303.g954a862665-goog

