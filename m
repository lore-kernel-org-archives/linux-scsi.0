Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC330E784BF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbjJBP7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238338AbjJBP7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:59:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2722CF2
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:59:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A981B21870;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696262357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7qHk9Hd+A/JqBm/8PUI1Zm43pcjQYRodQHyuC+7i50=;
        b=tQ+VKhw4EXajVyCCeWEllZ1hQNav0rlhhP7r3gLLYseyKLlIjRzi+W6Bd4/hPloztfjJ0G
        3WaIA5sbXt0NlZ6PvaoHcVNmEaiLbNZb3r5rqgnrKlWNu8IneqmEQPACZpXCcZNJTwjsiM
        S9TBAOKLRt4BKOa8Y1fApenET8HV4YI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696262357;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7qHk9Hd+A/JqBm/8PUI1Zm43pcjQYRodQHyuC+7i50=;
        b=87XzNyK1P/2RAy1FCODQ5zCMPjV/vLSTbsRNDZape2Rq0leUVoyoqd7nIsTgOKOFeBcXX2
        3iLPVWSB8XWGS4Cw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 84A6A2C14E;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 82ED451E7588; Mon,  2 Oct 2023 17:59:17 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] scsi: Do not allocate scsi command in scsi_ioctl_reset()
Date:   Mon,  2 Oct 2023 17:59:13 +0200
Message-Id: <20231002155915.109359-6-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002155915.109359-1-hare@suse.de>
References: <20231002155915.109359-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As we now have moved the error handler functions to not rely on
a scsi command we can drop the out-of-band scsi command allocation
from scsi_ioctl_reset().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 95 ++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3e312601cf22..21d84940c9cb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -866,13 +866,12 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
 
 /**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send host reset.
+ * @host:	SCSI host to be reset.
  */
-static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_host_reset(struct Scsi_Host *host)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
-	struct Scsi_Host *host = scmd->device->host;
 	const struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3,
@@ -887,7 +886,7 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 		if (!hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
+		scsi_report_bus_reset(host, -1);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
@@ -896,28 +895,29 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 
 /**
  * scsi_try_bus_reset - ask host to perform a bus reset
- * @scmd:	SCSI cmd to send bus reset.
+ * @host:	SCSI host to send bus reset.
+ * @channel:	Number of the bus to be reset
  */
-static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_bus_reset(struct Scsi_Host *host,
+						int channel)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
-	struct Scsi_Host *host = scmd->device->host;
 	const struct scsi_host_template *hostt = host->hostt;
 
-	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-		"%s: Snd Bus RST\n", __func__));
+	SCSI_LOG_ERROR_RECOVERY(3, shost_printk(KERN_INFO, host,
+		"%s: Snd Bus RST to bus %d\n", __func__, channel));
 
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_bus_reset_handler(host, scmd_channel(scmd));
+	rtn = hostt->eh_bus_reset_handler(host, channel);
 
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
 		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
+		scsi_report_bus_reset(host, channel);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
@@ -932,7 +932,8 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
 
 /**
  * scsi_try_target_reset - Ask host to perform a target reset
- * @scmd:	SCSI cmd used to send a target reset
+ * @host:	SCSI Host
+ * @starget:	SCSI target to be reset
  *
  * Notes:
  *    There is no timeout for this operation.  if this operation is
@@ -940,13 +941,12 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_target_reset(struct Scsi_Host *host,
+						   struct scsi_target *starget)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
-	struct Scsi_Host *host = scmd->device->host;
 	const struct scsi_host_template *hostt = host->hostt;
-	struct scsi_target *starget = scsi_target(scmd->device);
 
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
@@ -964,7 +964,7 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 
 /**
  * scsi_try_bus_device_reset - Ask host to perform a BDR on a dev
- * @scmd:	SCSI cmd used to send BDR
+ * @sdev:	SCSI device to perform the BDR on
  *
  * Notes:
  *    There is no timeout for this operation.  if this operation is
@@ -972,17 +972,17 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_device *sdev)
 {
 	enum scsi_disposition rtn;
-	const struct scsi_host_template *hostt = scmd->device->host->hostt;
+	const struct scsi_host_template *hostt = sdev->host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd->device);
+	rtn = hostt->eh_device_reset_handler(sdev);
 	if (rtn == SUCCESS)
-		__scsi_report_device_reset(scmd->device, NULL);
+		__scsi_report_device_reset(sdev, NULL);
 	return rtn;
 }
 
@@ -1014,11 +1014,15 @@ scsi_try_to_abort_cmd(const struct scsi_host_template *hostt, struct scsi_cmnd *
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 {
-	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
-		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
-			if (scsi_try_target_reset(scmd) != SUCCESS)
-				if (scsi_try_bus_reset(scmd) != SUCCESS)
-					scsi_try_host_reset(scmd);
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_target *starget = scsi_target(scmd->device);
+	int channel = scmd->device->channel;
+
+	if (scsi_try_to_abort_cmd(host->hostt, scmd) != SUCCESS)
+		if (scsi_try_bus_device_reset(scmd->device) != SUCCESS)
+			if (scsi_try_target_reset(host, starget) != SUCCESS)
+				if (scsi_try_bus_reset(host, channel) != SUCCESS)
+					scsi_try_host_reset(host);
 }
 
 /**
@@ -1601,7 +1605,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		SCSI_LOG_ERROR_RECOVERY(3,
 			sdev_printk(KERN_INFO, sdev,
 				     "%s: Sending BDR\n", current->comm));
-		rtn = scsi_try_bus_device_reset(bdr_scmd);
+		rtn = scsi_try_bus_device_reset(sdev);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
 			    rtn == FAST_IO_FAIL ||
@@ -1666,7 +1670,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending target reset to target %d\n",
 				     current->comm, id));
-		rtn = scsi_try_target_reset(scmd);
+		rtn = scsi_try_target_reset(shost, scsi_target(scmd->device));
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1741,7 +1745,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending BRST chan: %d\n",
 				     current->comm, channel));
-		rtn = scsi_try_bus_reset(chan_scmd);
+		rtn = scsi_try_bus_reset(shost, channel);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd)) {
@@ -1787,7 +1791,7 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 				     "%s: Sending HRST\n",
 				     current->comm));
 
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost);
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
 		} else if (rtn == FAST_IO_FAIL) {
@@ -2397,7 +2401,7 @@ void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev_channel(sdev))
+		if (channel == -1 || channel == sdev_channel(sdev))
 			__scsi_report_device_reset(sdev, NULL);
 	}
 }
@@ -2445,9 +2449,8 @@ EXPORT_SYMBOL(scsi_report_device_reset);
 int
 scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 {
-	struct scsi_cmnd *scmd;
 	struct Scsi_Host *shost = dev->host;
-	struct request *rq;
+	struct scsi_target *starget = scsi_target(dev);
 	unsigned long flags;
 	int error = 0, val;
 	enum scsi_disposition rtn;
@@ -2462,23 +2465,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	if (scsi_autopm_get_host(shost) < 0)
 		return -EIO;
 
-	error = -EIO;
-	rq = kzalloc(sizeof(struct request) + sizeof(struct scsi_cmnd) +
-			shost->hostt->cmd_size, GFP_KERNEL);
-	if (!rq)
-		goto out_put_autopm_host;
-	blk_rq_init(NULL, rq);
-
-	scmd = (struct scsi_cmnd *)(rq + 1);
-	scsi_init_command(dev, scmd);
-
-	scmd->submitter = SUBMITTED_BY_SCSI_RESET_IOCTL;
-	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
-
-	scmd->cmd_len			= 0;
-
-	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2488,22 +2474,22 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 		rtn = SUCCESS;
 		break;
 	case SG_SCSI_RESET_DEVICE:
-		rtn = scsi_try_bus_device_reset(scmd);
+		rtn = scsi_try_bus_device_reset(dev);
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_TARGET:
-		rtn = scsi_try_target_reset(scmd);
+		rtn = scsi_try_target_reset(shost, starget);
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_BUS:
-		rtn = scsi_try_bus_reset(scmd);
+		rtn = scsi_try_bus_reset(shost, dev->channel);
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_HOST:
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost);
 		if (rtn == SUCCESS)
 			break;
 		fallthrough;
@@ -2529,9 +2515,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	wake_up(&shost->host_wait);
 	scsi_run_host_queues(shost);
 
-	kfree(rq);
-
-out_put_autopm_host:
 	scsi_autopm_put_host(shost);
 	return error;
 }
-- 
2.35.3

