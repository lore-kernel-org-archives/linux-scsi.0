Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF43C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73E8460F02
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 00:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhKCAIW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 20:08:22 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:45910 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhKCAIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 20:08:21 -0400
Received: by mail-pj1-f52.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so76840pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 02 Nov 2021 17:05:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4E7aiZ2Jw5N5uNx2a/jD4xOI/fWN48VTWY0iJWm8D9A=;
        b=4ThTJPHD5pfl4vbPWKYaioYkQyYruk+3yK8T01vpNKzJKb6v9kRmz5jaMGqYJ3djdE
         xdaSZduDGqIAqsBTB7C00sjY4HSibCwBZEU5GdtlnZbPmP45ZKtXrQSTjdjzFuw890AV
         RGCigu+HuZ/tTj3J5GC31TFgAP2SLYF7AK1Fun0J03GXn/mwfJfmZ8LN+3oNag46AC0g
         PNOSY95B2IaR5RRF29kFxlG2vL8TI8st1Bpu4JPO75fK7hEpfVyvDLVowF7zy5QwWvRA
         bQOQGdXaPeys2CdLjFOrtPaFmW5g2haMLMCtz1fqxEutVpARDbndQ5/tnHXEbsa8YacG
         E2ww==
X-Gm-Message-State: AOAM532tOtelroMNUK2Ku7hKS2bqbF5ycL8tftW92GWSvm4Jc5uS6sZo
        1W8HbJfYfIHzeQ1mcM/9p/Q=
X-Google-Smtp-Source: ABdhPJxaaV/eRqVWNP8VtUeNOcbJsTQT5G7lwLZhJbZ1Q+sOAWw5uNJZ5tsPcWX6PB6/Bw96JHZNZw==
X-Received: by 2002:a17:902:db07:b0:141:ea12:218b with SMTP id m7-20020a170902db0700b00141ea12218bmr15929078plx.46.1635897945821;
        Tue, 02 Nov 2021 17:05:45 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id u2sm279282pfk.142.2021.11.02.17.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 17:05:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Date:   Tue,  2 Nov 2021 17:05:29 -0700
Message-Id: <20211103000529.1549411-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
In-Reply-To: <20211103000529.1549411-1-bvanassche@acm.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following deadlock has been observed on a test setup:
* All tags allocated.
* The SCSI error handler calls ufshcd_eh_host_reset_handler()
* ufshcd_eh_host_reset_handler() queues work that calls ufshcd_err_handler()
* ufshcd_err_handler() locks up as follows:

Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt
Call trace:
 __switch_to+0x298/0x5d8
 __schedule+0x6cc/0xa94
 schedule+0x12c/0x298
 blk_mq_get_tag+0x210/0x480
 __blk_mq_alloc_request+0x1c8/0x284
 blk_get_request+0x74/0x134
 ufshcd_exec_dev_cmd+0x68/0x640
 ufshcd_verify_dev_init+0x68/0x35c
 ufshcd_probe_hba+0x12c/0x1cb8
 ufshcd_host_reset_and_restore+0x88/0x254
 ufshcd_reset_and_restore+0xd0/0x354
 ufshcd_err_handler+0x408/0xc58
 process_one_work+0x24c/0x66c
 worker_thread+0x3e8/0xa4c
 kthread+0x150/0x1b4
 ret_from_fork+0x10/0x30

Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved
request.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9d964b979aa2..6b0101169974 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2904,12 +2904,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	down_read(&hba->clk_scaling_lock);
 
-	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by SCSI request timeout.
-	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_unlock;
@@ -4919,11 +4914,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
  */
 static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	struct ufs_hba *hba = shost_priv(sdev->host);
-
-	if (depth > hba->nutrs)
-		depth = hba->nutrs;
-	return scsi_change_queue_depth(sdev, depth);
+	return scsi_change_queue_depth(sdev, min(depth, sdev->host->can_queue));
 }
 
 static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *sdev)
@@ -8124,7 +8115,8 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
-	.can_queue		= UFSHCD_CAN_QUEUE,
+	.can_queue		= UFSHCD_CAN_QUEUE - 1,
+	.reserved_tags		= 1,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
@@ -9485,8 +9477,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
-	host->cmd_per_lun = hba->nutrs;
+	host->can_queue = hba->nutrs - 1;
+	host->cmd_per_lun = hba->nutrs - 1;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFS_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
