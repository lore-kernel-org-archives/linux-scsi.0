Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82C9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC72D61139
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhKSUCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:02:08 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:36627 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbhKSUBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:53 -0500
Received: by mail-pl1-f172.google.com with SMTP id u11so8940511plf.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EhA8VyNEK7Q1fZd4lJxs+cld7kimzHkOGQgE//0c/MI=;
        b=a2ZkCcW2FyBLhHz/B+NK1bAAEOKkjR0HEcAdwYXpQA2eO8dD3ftB7rfScm7RV2txGW
         XVUpowpH2hyddT6iQvsfWUaZ2UkePnsCIkG04w5hqlVVXVpa4tHakIC4vHYER9beblvf
         luZoofCEPd46vTQ+R/lHt9CwPHFm9tphUgY74CP2AVgTugXUI2e8N+m7XuLPlXC0mCAW
         wuWTq4gK37HNkxrVLcMcXZdI89bPOGupe5/kqyT4oRr8eMAOPYZgrrdO7jlLMb7+VdOi
         j/c7QCFjzVDKCPp2JdQeiBrrpmTE5uFwiEK4lQ7dOuqiWGL2EckmT9JE08ojL4MEkHVG
         NpVQ==
X-Gm-Message-State: AOAM530/NR9pOfsqPNML2Kccr3Jd5S+D6WzSfll6SvFj2lHl7yrygnsJ
        SOvlJMWM1Y9VyhOBcOJStkc=
X-Google-Smtp-Source: ABdhPJyLyJCX4OEwEfmkE7OpZx4/Eq7xtOQs7GKSJEZjIHxYev0Lulre8I+d5YytuMalx/fE9wnGAQ==
X-Received: by 2002:a17:902:7003:b0:143:c009:89f9 with SMTP id y3-20020a170902700300b00143c00989f9mr62362835plk.11.1637351930922;
        Fri, 19 Nov 2021 11:58:50 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:50 -0800 (PST)
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
Subject: [PATCH v2 19/20] scsi: ufs: Implement polling support
Date:   Fri, 19 Nov 2021 11:57:42 -0800
Message-Id: <20211119195743.2817-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The time spent in io_schedule() and also the interrupt latency are
significant when submitting direct I/O to a UFS device. Hence this patch
that implements polling support. User space software can enable polling by
passing the RWF_HIPRI flag to the preadv2() system call or the
IORING_SETUP_IOPOLL flag to the io_uring interface.

Although the block layer supports to partition the tag space for
interrupt-based completions (HCTX_TYPE_DEFAULT) purposes and polling
(HCTX_TYPE_POLL), the choice has been made to use the same hardware
queue for both hctx types because partitioning the tag space would
negatively affect performance.

On my test setup this patch increases IOPS from 2736 to 22000 (8x) for the
following test:

for hipri in 0 1; do
    fio --ioengine=io_uring --iodepth=1 --rw=randread \
    --runtime=60 --time_based=1 --direct=1 --name=qd1 \
    --filename=/dev/block/sda --ioscheduler=none --gtod_reduce=1 \
    --norandommap --hipri=$hipri
done

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 85 ++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9cf4a22f1950..14043d74389d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2629,6 +2629,36 @@ static inline bool is_device_wlun(struct scsi_device *sdev)
 		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN);
 }
 
+/*
+ * Associate the UFS controller queue with the default and poll HCTX types.
+ * Initialize the mq_map[] arrays.
+ */
+static int ufshcd_map_queues(struct Scsi_Host *shost)
+{
+	int i, ret;
+
+	for (i = 0; i < shost->nr_maps; i++) {
+		struct blk_mq_queue_map *map = &shost->tag_set.map[i];
+
+		switch (i) {
+		case HCTX_TYPE_DEFAULT:
+		case HCTX_TYPE_POLL:
+			map->nr_queues = 1;
+			break;
+		case HCTX_TYPE_READ:
+			map->nr_queues = 0;
+			break;
+		default:
+			WARN_ON_ONCE(true);
+		}
+		map->queue_offset = 0;
+		ret = blk_mq_map_queues(map);
+		WARN_ON_ONCE(ret);
+	}
+
+	return 0;
+}
+
 static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 {
 	struct utp_transfer_cmd_desc *cmd_descp = hba->ucdl_base_addr;
@@ -2664,7 +2694,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
 
 	/*
 	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
@@ -2925,7 +2955,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	}
 	req = scsi_cmd_to_rq(scmd);
 	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
 	/*
 	 * Start the request such that blk_mq_tag_idle() is called when the
 	 * device management request finishes.
@@ -5272,6 +5302,31 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	}
 }
 
+/*
+ * Returns > 0 if one or more commands have been completed or 0 if no
+ * requests have been completed.
+ */
+static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+	struct ufs_hba *hba = shost_priv(shost);
+	unsigned long completed_reqs, flags;
+	u32 tr_doorbell;
+
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
+	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
+		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
+		  hba->outstanding_reqs);
+	hba->outstanding_reqs &= ~completed_reqs;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	if (completed_reqs)
+		__ufshcd_transfer_req_compl(hba, completed_reqs);
+
+	return completed_reqs;
+}
+
 /**
  * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
@@ -5282,9 +5337,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
  */
 static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	unsigned long completed_reqs, flags;
-	u32 tr_doorbell;
-
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
 	 * In order to prevent other interrupts starvation the DB is read once
@@ -5299,21 +5351,9 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	if (ufs_fail_completion())
 		return IRQ_HANDLED;
 
-	spin_lock_irqsave(&hba->outstanding_lock, flags);
-	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
-	hba->outstanding_reqs &= ~completed_reqs;
-	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+	ufshcd_poll(hba->host, 0);
 
-	if (completed_reqs) {
-		__ufshcd_transfer_req_compl(hba, completed_reqs);
-		return IRQ_HANDLED;
-	} else {
-		return IRQ_NONE;
-	}
+	return IRQ_HANDLED;
 }
 
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
@@ -6564,6 +6604,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_lock_irqsave(host->host_lock, flags);
 
 	task_tag = req->tag;
+	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
+		  task_tag);
 	hba->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
 
@@ -6705,7 +6747,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	}
 	req = scsi_cmd_to_rq(scmd);
 	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
 	/*
 	 * Start the request such that blk_mq_tag_idle() is called when the
 	 * device management request finishes.
@@ -8147,7 +8189,9 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
+	.map_queues		= ufshcd_map_queues,
 	.queuecommand		= ufshcd_queuecommand,
+	.mq_poll		= ufshcd_poll,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
 	.slave_destroy		= ufshcd_slave_destroy,
@@ -9437,6 +9481,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+	host->nr_maps = 3;
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
