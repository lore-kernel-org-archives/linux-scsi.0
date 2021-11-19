Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F210C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BEC061B1E
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhKSUBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:46 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:43717 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbhKSUB3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:29 -0500
Received: by mail-pg1-f178.google.com with SMTP id b4so9485169pgh.10
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JEfGaERSd8ev5avfUXESx4NC6L+Goz/+gFSlRtuLz4A=;
        b=3/JI6Tlx56KWlZ3cdGDVicfJWcfymuZ23MYikjPsO4HV2jDQErQV3aiN+r+HrM3ETD
         E6CYZfR3SZDx0ow3DNGasD44nAoV5khBaFFiu35At/wJK6X7SjVRy0SPK6aMYq1U2Dsw
         UYefSwh5EHaGAzNBEiqdFMvZeGETwpJuoJPrdNQkLAT38PqfWG+dVPOqxt/YVMj23jOD
         zMTC1mScHcZ3utXTvyDjlbUifo9lSwrw5GY7QO2lOo8oDDowzXyaVIf3OPR71ieAZuiP
         UDdm9S/bFVS/6tRL0/WAMkm6C1/BpO9ZXHDgAeJ5uNU4aP8BO2kyxkTTDQRuUiNCHLSH
         j20w==
X-Gm-Message-State: AOAM533cperuAl6QbJKeSs/jLkzQljp7HchYeYKi+uB42DGVRhxQvwkj
        j/p6Phd6/1ia1EH2Fus+xpQ=
X-Google-Smtp-Source: ABdhPJzCLTkT+uOi9Zm+KI62SOPNhIpH1OZzZ3KTXatK3RvAd1LYBn7oa0bw0Pf2mDCL3w2i0t7S9Q==
X-Received: by 2002:a05:6a00:248f:b0:4a0:1e25:3155 with SMTP id c15-20020a056a00248f00b004a01e253155mr26024501pfv.21.1637351907186;
        Fri, 19 Nov 2021 11:58:27 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 13/20] scsi: ufs: Fix a deadlock in the error handler
Date:   Fri, 19 Nov 2021 11:57:36 -0800
Message-Id: <20211119195743.2817-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
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
 drivers/scsi/ufs/ufshcd.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a241ef6bbc6f..03f4772fc2e2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -128,8 +128,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
-	UFSHCD_CMD_PER_LUN	= 32,
-	UFSHCD_CAN_QUEUE	= 32,
+	UFSHCD_NUM_RESERVED	= 1,
+	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
+	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
 };
 
 static const char *const ufshcd_state_name[] = {
@@ -2941,12 +2942,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	down_read(&hba->clk_scaling_lock);
 
-	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by SCSI request timeout.
-	 */
-	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, 0);
+	scmd = scsi_get_internal_cmd(q, DMA_TO_DEVICE, BLK_MQ_REQ_RESERVED);
 	if (IS_ERR(scmd)) {
 		err = PTR_ERR(scmd);
 		goto out_unlock;
@@ -8171,6 +8167,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
 	.can_queue		= UFSHCD_CAN_QUEUE,
+	.reserved_tags		= UFSHCD_NUM_RESERVED,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
@@ -9531,8 +9528,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
-	host->cmd_per_lun = hba->nutrs;
+	host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
+	host->cmd_per_lun = hba->nutrs - UFSHCD_NUM_RESERVED;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFS_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
