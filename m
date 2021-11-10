Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A958C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2B361181
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhKJAsU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:20 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:36848 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhKJAsT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:19 -0500
Received: by mail-pf1-f169.google.com with SMTP id m26so1050761pff.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFIfS0QH8F29Gihs4bJQA8uWnffYK0FxBrRaCfEbcdc=;
        b=fSeToTlLCU96scgWxirS6El8GaNTEcah5hG1BRZjXllj0Mk5ACS0BL3BE3iyY+OsR4
         JFxTTk9tf7EmkZA+SRFD/tbyerMdhAcSeXkMag/mdA1JFMrSIyN0McZbai4KpsxOyoea
         3/oe2vg+WWDkbfZyAKKi6aJnnbT8qFtk7tW9yZKwh/f0Zz7TFNgcop4bSyUO01FOPBhx
         8NGiW+4LxWcaOiTxHXTv/gPhElvFAekZSy7h2nCKaAh2fUOoLlNe4DUFHOjG7Sijqz+3
         CqsZt6ZO/MWD8ZAJue9Zc4OgjhArIoEz0Q7s/sSF0ceWD8Nncla8BGvy68tsdj2DCjV1
         RB7A==
X-Gm-Message-State: AOAM531EJA5rmvqJMbqLkUxJi6fqJKzstuIbixnYU+5gW4+ans0jTb70
        ql4kjKJ0kYwbXB4LgLjqXh4=
X-Google-Smtp-Source: ABdhPJy83AJSCnFJ4gP40DT+6BokCsClKjeSj6olB8tQIZM18PyQw0PKRGEo6c8lbP+DMWJ0dt0YZw==
X-Received: by 2002:a63:950f:: with SMTP id p15mr9098808pgd.265.1636505132543;
        Tue, 09 Nov 2021 16:45:32 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:32 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 07/11] scsi: ufs: Fix a deadlock in the error handler
Date:   Tue,  9 Nov 2021 16:44:36 -0800
Message-Id: <20211110004440.3389311-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
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
 drivers/scsi/ufs/ufshcd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8400d8e9a6f7..8f5640647054 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2940,12 +2940,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
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
@@ -8152,7 +8147,8 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
-	.can_queue		= UFSHCD_CAN_QUEUE,
+	.can_queue		= UFSHCD_CAN_QUEUE - 1,
+	.reserved_tags		= 1,
 	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
 	.max_host_blocked	= 1,
 	.track_queue_depth	= 1,
@@ -9513,8 +9509,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
-	host->cmd_per_lun = hba->nutrs;
+	host->can_queue = hba->nutrs - 1;
+	host->cmd_per_lun = hba->nutrs - 1;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFS_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
