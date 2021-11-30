Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115F0C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345280AbhK3Xif (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:38:35 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:43617 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240977AbhK3Xi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:38:28 -0500
Received: by mail-pl1-f179.google.com with SMTP id m24so16195915pls.10
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:35:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LOwNxUGaXRXYkzQoj4hoWe0WWsfF8s4evhhcNvlzf3k=;
        b=ibnEuFmYScAumJ4MwSBcRUua8AFf1k0bmlW+HHWxKFmr1Knh5n4xgJXVhvUc79oHzK
         joOGYWpjuPA5kUKLASxouw7dRLclFz/nDx50szRZHSyN3dxGUlexei+9Oyajw2RADwdP
         X7w8gqBLxr3Fz1hmTJnvQRDM8rAGbDkuDHLo9FkYyWRCb6o3Mvv9pVLwBPgDU2jptbNa
         KKar/36rWZccGr9KLo70d3lvSsAkz6C7PgaUHXRci7DWwYNYC4BEClmWKsbhogM3zd4x
         ICJxX4O/nTBkn06OfMJJY0eWyFRbMigxK2/pTKG7Q0dDAmM0SjU7YfjwMuYwmDzYYb9+
         CvLQ==
X-Gm-Message-State: AOAM530pWMshC5c4dC1kQQaq1rkpQMlA/hu1v2Ka9FxJgpr8PL7vnJ/t
        qosnqOtExoWasrCK/Lzc9Ug=
X-Google-Smtp-Source: ABdhPJzKG+xNHSa3QCLsZMXcJMGeufhO2YRZOOVsOMzabhaYAoITGQa3BjRmmqGPnuwXm/fFijBvow==
X-Received: by 2002:a17:902:d50e:b0:142:1b2a:144 with SMTP id b14-20020a170902d50e00b001421b2a0144mr2651712plg.51.1638315308587;
        Tue, 30 Nov 2021 15:35:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:35:07 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 17/17] scsi: ufs: Implement polling support
Date:   Tue, 30 Nov 2021 15:33:24 -0800
Message-Id: <20211130233324.1402448-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
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
 1 file changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3e4c62c6f9d2..5b3efc880246 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2651,6 +2651,36 @@ static inline bool is_device_wlun(struct scsi_device *sdev)
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
@@ -2686,7 +2716,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
 
 	/*
 	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
@@ -5277,6 +5307,31 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
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
@@ -5287,9 +5342,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
  */
 static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	unsigned long completed_reqs, flags;
-	u32 tr_doorbell;
-
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
 	 * In order to prevent other interrupts starvation the DB is read once
@@ -5304,21 +5356,13 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
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
+	/*
+	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
+	 * do not want polling to trigger spurious interrupt complaints.
+	 */
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
@@ -6570,6 +6614,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_lock_irqsave(host->host_lock, flags);
 
 	task_tag = req->tag;
+	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
+		  task_tag);
 	hba->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
 
@@ -8133,7 +8179,9 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
+	.map_queues		= ufshcd_map_queues,
 	.queuecommand		= ufshcd_queuecommand,
+	.mq_poll		= ufshcd_poll,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
 	.slave_destroy		= ufshcd_slave_destroy,
@@ -9422,6 +9470,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+	host->nr_maps = HCTX_TYPE_POLL + 1;
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
