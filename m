Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4855DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383450AbhLCXZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:25:16 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:52179 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383447AbhLCXZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:25:15 -0500
Received: by mail-pj1-f43.google.com with SMTP id gt5so3453632pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1jEne7oix7Q/9/XlwRRas5CBY+bXhWVO6Uz2cxXRbg=;
        b=WUPciCN+IXD6GJfODsL5xXRJ/wXP2TRDpKEmImaFxXwx+2VP/776sj7kPCq439ph6a
         BVIoWAjucJco1BO5oW7UK59IhXHtjOVEHzggY3TWzDpGw8az+u8z8U6m44yjN1L07cuu
         Kq3DIkRpGtCTFJp14di753M0OoIPS2rNGq4fFPQjfKbcOY8rHnDNdIppRNulzmrIRTEE
         9KsEWtauyP7huQjKHttDJkvhhdbLNe7E/lkreASMikY4axXuGiuE/d/4Ptan8TAbh2hN
         GGRLHxPKLc8uGuukg8wsTOXNnDPaM7Z87rIv8NpzYHf4ajhR+Xb//txytvgj9z40mkFw
         HXFA==
X-Gm-Message-State: AOAM532jwH819FNyYPEEfiDfQWajrZyb0T/XYfZogBlLm/aBGljKJjRA
        TRLkF79OCYwnfX0FnA1goL4=
X-Google-Smtp-Source: ABdhPJx+5ehgS5uFxrUGnGS9iGSeBiaUBiaDn4qgSFKMaROZSzwq9Ut45PPwsOte5euVZexmIJdd0Q==
X-Received: by 2002:a17:90a:7e86:: with SMTP id j6mr18069675pjl.25.1638573710741;
        Fri, 03 Dec 2021 15:21:50 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:50 -0800 (PST)
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
Subject: [PATCH v4 17/17] scsi: ufs: Implement polling support
Date:   Fri,  3 Dec 2021 15:19:50 -0800
Message-Id: <20211203231950.193369-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
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

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 85 ++++++++++++++++++++++++++++++---------
 1 file changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 650dddf960c2..6dd517267f1b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2662,6 +2662,36 @@ static inline bool is_device_wlun(struct scsi_device *sdev)
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
@@ -2697,7 +2727,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
 
 	/*
 	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
@@ -5288,6 +5318,31 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
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
@@ -5298,9 +5353,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
  */
 static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	unsigned long completed_reqs, flags;
-	u32 tr_doorbell;
-
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
 	 * In order to prevent other interrupts starvation the DB is read once
@@ -5315,21 +5367,13 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
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
@@ -6581,6 +6625,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_lock_irqsave(host->host_lock, flags);
 
 	task_tag = req->tag;
+	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
+		  task_tag);
 	hba->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
 
@@ -8144,7 +8190,9 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
 	.proc_name		= UFSHCD,
+	.map_queues		= ufshcd_map_queues,
 	.queuecommand		= ufshcd_queuecommand,
+	.mq_poll		= ufshcd_poll,
 	.slave_alloc		= ufshcd_slave_alloc,
 	.slave_configure	= ufshcd_slave_configure,
 	.slave_destroy		= ufshcd_slave_destroy,
@@ -9432,6 +9480,7 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
+	host->nr_maps = HCTX_TYPE_POLL + 1;
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
