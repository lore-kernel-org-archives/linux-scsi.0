Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44B6C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC6CB60F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbhHQJRu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33304 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239462AbhHQJRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EB5A121DC5;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nwWOoPD3q3a6wbCxL50wINPxoZ7bocR/ZA60WGd954=;
        b=QW9kgopPpQ124+8ksXuiHNsgbmQzjHsPKAAZ2K/SXzwuA062uq0uzdYpxxmWthyMPRGI7k
        SVqnb3epkUk90LGOXoNnIPjzVq8eprTXBjZ+vwEmKwkCT6m7YWCDsE0kETKWNf+ak21UM4
        lVXa2sj8XLuhxNe5bXflPwmYleNhdv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nwWOoPD3q3a6wbCxL50wINPxoZ7bocR/ZA60WGd954=;
        b=P/mfG4nfR66z1Zgv1y3yu7RMIEsNcjOIGMLQvRhD/FG4iyMaoRm7JBFNdB6H9njFwskJQy
        FPs9BUo6+zzgP3Bw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E4DF4A3BC0;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E1E9D518CEC3; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 50/51] scsi: Do not allocate scsi command in scsi_ioctl_reset()
Date:   Tue, 17 Aug 2021 11:14:55 +0200
Message-Id: <20210817091456.73342-51-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As we now have moved the error handler functions to not rely on
a scsi command we can drop the out-of-band scsi command allocation
from scsi_ioctl_reset().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 104 +++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 44e29558b068..5cfff3fa306c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -796,14 +796,14 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 
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
 	struct scsi_host_template *hostt = host->hostt;
+	struct scsi_device *sdev;
 
 	SCSI_LOG_ERROR_RECOVERY(3,
 		shost_printk(KERN_INFO, host, "Snd Host RST\n"));
@@ -817,7 +817,8 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 		if (!hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
+		__shost_for_each_device(sdev, host)
+			__scsi_report_device_reset(sdev);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
@@ -826,28 +827,29 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 
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
 	struct scsi_host_template *hostt = host->hostt;
 
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
 
@@ -862,7 +864,8 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
 
 /**
  * scsi_try_target_reset - Ask host to perform a target reset
- * @scmd:	SCSI cmd used to send a target reset
+ * @host:	SCSI Host
+ * @starget:	SCSI target to be reset
  *
  * Notes:
  *    There is no timeout for this operation.  if this operation is
@@ -870,13 +873,13 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
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
+	struct scsi_device *sdev;
 	struct scsi_host_template *hostt = host->hostt;
-	struct scsi_target *starget = scsi_target(scmd->device);
 
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
@@ -884,8 +887,11 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 	rtn = hostt->eh_target_reset_handler(starget);
 	if (rtn == SUCCESS) {
 		spin_lock_irqsave(host->host_lock, flags);
-		__starget_for_each_device(starget, NULL,
-					  __scsi_report_device_reset);
+		__shost_for_each_device(sdev, host) {
+			if ((sdev->channel == starget->channel) &&
+			    (sdev->id == starget->id))
+				__scsi_report_device_reset(sdev);
+		}
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
@@ -894,7 +900,7 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 
 /**
  * scsi_try_bus_device_reset - Ask host to perform a BDR on a dev
- * @scmd:	SCSI cmd used to send BDR
+ * @sdev:	SCSI device to perform the BDR on
  *
  * Notes:
  *    There is no timeout for this operation.  if this operation is
@@ -902,17 +908,17 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_device *sdev)
 {
 	enum scsi_disposition rtn;
-	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	struct scsi_host_template *hostt = sdev->host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd->device);
+	rtn = hostt->eh_device_reset_handler(sdev);
 	if (rtn == SUCCESS)
-		__scsi_report_device_reset(scmd->device, NULL);
+		__scsi_report_device_reset(sdev, NULL);
 	return rtn;
 }
 
@@ -944,11 +950,15 @@ scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 
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
@@ -1530,7 +1540,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		SCSI_LOG_ERROR_RECOVERY(3,
 			sdev_printk(KERN_INFO, sdev,
 				     "%s: Sending BDR\n", current->comm));
-		rtn = scsi_try_bus_device_reset(bdr_scmd);
+		rtn = scsi_try_bus_device_reset(sdev);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
 			    rtn == FAST_IO_FAIL ||
@@ -1595,7 +1605,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending target reset to target %d\n",
 				     current->comm, id));
-		rtn = scsi_try_target_reset(scmd);
+		rtn = scsi_try_target_reset(shost, scsi_target(scmd->device));
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1670,7 +1680,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending BRST chan: %d\n",
 				     current->comm, channel));
-		rtn = scsi_try_bus_reset(chan_scmd);
+		rtn = scsi_try_bus_reset(shost, channel);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd)) {
@@ -1716,7 +1726,7 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 				     "%s: Sending HRST\n",
 				     current->comm));
 
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost);
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
 		} else if (rtn == FAST_IO_FAIL) {
@@ -2364,9 +2374,8 @@ scsi_reset_provider_done_command(struct scsi_cmnd *scmd)
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
@@ -2381,25 +2390,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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
-	scmd->request = rq;
-	scmd->cmnd = scsi_req(rq)->cmd;
-
-	scmd->scsi_done		= scsi_reset_provider_done_command;
-	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
-
-	scmd->cmd_len			= 0;
-
-	scmd->sc_data_direction		= DMA_BIDIRECTIONAL;
-
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2409,22 +2399,22 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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
@@ -2450,8 +2440,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	wake_up(&shost->host_wait);
 	scsi_run_host_queues(shost);
 
-	kfree(rq);
-
 out_put_autopm_host:
 	scsi_autopm_put_host(shost);
 	return error;
-- 
2.29.2

