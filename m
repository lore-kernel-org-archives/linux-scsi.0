Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3108CCDB482
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 12:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjJPMQC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjJPMPy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 08:15:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AE5109
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 05:15:51 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8844421C5A;
        Mon, 16 Oct 2023 12:15:49 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 249252D159;
        Mon, 16 Oct 2023 12:15:49 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 3DBA651EBDFE; Mon, 16 Oct 2023 14:15:49 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 7/9] scsi: Do not allocate scsi command in scsi_ioctl_reset()
Date:   Mon, 16 Oct 2023 14:15:40 +0200
Message-Id: <20231016121542.111501-8-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016121542.111501-1-hare@suse.de>
References: <20231016121542.111501-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [11.49 / 50.00];
         ARC_NA(0.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_SPAM_SHORT(2.00)[1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         RCPT_COUNT_SEVEN(0.00)[7];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: 8844421C5A
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As we now have moved the error handler functions to not rely on
a scsi command we can drop the out-of-band scsi command allocation
from scsi_ioctl_reset().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/scsi_error.c | 93 ++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9f0ee01b319d..9ae9b936e67b 100644
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
@@ -1667,7 +1671,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending target reset to target %d\n",
 				     current->comm, id));
-		rtn = scsi_try_target_reset(scmd);
+		rtn = scsi_try_target_reset(shost, scsi_target(scmd->device));
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1731,7 +1735,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			shost_printk(KERN_INFO, shost,
 				     "%s: Sending BRST chan: %d\n",
 				     current->comm, channel));
-		rtn = scsi_try_bus_reset(scmd);
+		rtn = scsi_try_bus_reset(shost, channel);
 		if (rtn != SUCCESS && rtn != FAST_IO_FAIL) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1777,7 +1781,7 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 				     "%s: Sending HRST\n",
 				     current->comm));
 
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost);
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
 		} else if (rtn == FAST_IO_FAIL) {
@@ -2387,7 +2391,7 @@ void scsi_report_bus_reset(struct Scsi_Host *shost, unsigned int channel)
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev_channel(sdev))
+		if (channel == -1 || channel == sdev_channel(sdev))
 			__scsi_report_device_reset(sdev, NULL);
 	}
 }
@@ -2435,9 +2439,8 @@ EXPORT_SYMBOL(scsi_report_device_reset);
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
@@ -2452,23 +2455,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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
@@ -2478,22 +2464,22 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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
@@ -2519,9 +2505,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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

