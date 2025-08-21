Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA12343D76
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 18:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800432; cv=none; b=FgeYGQQ7rrf4GnxY8335HmpxrYIXSRV6TqA84qgKx9osC+pHM6GzICkaIC9GrtCaawaC9JTvnUrZb4ajJC7Phyargvvtqd3Ph6Gdz+JSavYl9cR9G5/N8EljvUQbts4AKB+Xt0iDAn+GAeP+zxKFGRoVy6TisZ+FD0JIFb6yl0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800432; c=relaxed/simple;
	bh=zNxEAnYBYyd2jVal04xja+3hPhbUKjMh0QQ4sMuIWjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jnv2sY7YAbuQmJCz+KKp4jrJ5vzSstv57vSdPafrv5VBd9yek66GP9qO5VXydnH7ZLwHHGmqb5MB2ost9m7c9dsOxehWsvhjgjjaXI940wdXLU8e9bieZOJQnQLwU1cNi0ccw+A2vI8NhCVnsyFOSpKfXoUy2w0Fqf3wmxb4qL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Q6wNmJgX; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Q6wNmJgX"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c7BSs27T5zm0yQp;
	Thu, 21 Aug 2025 18:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755800427; x=1758392428; bh=HICNePmOOq1Qvn3MCTUr9IR7
	kmkelfiS6FVWZ60T0Gs=; b=Q6wNmJgXQB/FdCGXbuF/BdSNy1mbmUMtIjAwnQrx
	7pJMTHHdV8k0c/ClJG/ozR0ALRKyB05L99qgVoGBlanMg9iylje+pS5HkIpSfG2V
	rNLrdjlii8C1AngaYH1ZMAAkEd+Kp6PWvUb1RaLhPxsZoWQjJt7ZI4pma2ZENdBV
	mUXQ/GB1w29QhCeBXeHnnzG2bpfAtaxdvNP3F3KSw4K4K20KrpF8ukYWxzQfr/bq
	Ump6qCk0ngjcNG3H4j3jubIYt4gAiLmd7eja0AuoU3f4VErNXY9JyGq98f4+Ypkf
	kJxLNKlUum4CzUbz/YZDsAoWYBDPHVdqSgmNcB4K6E8oDg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KZkUA7b3i_5C; Thu, 21 Aug 2025 18:20:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c7BSl6TGKzm0ySm;
	Thu, 21 Aug 2025 18:20:22 +0000 (UTC)
Message-ID: <368972fc-ce10-48f3-b527-be876092e17a@acm.org>
Date: Thu, 21 Aug 2025 11:20:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.com
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
 <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
 <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
 <e651aa7e-aad2-4e4e-afff-3e89a61f13f9@acm.org>
 <71a41bd0-1243-4fb3-ae83-c2cfae229296@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <71a41bd0-1243-4fb3-ae83-c2cfae229296@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 12:50 AM, John Garry wrote:
> Anyway, here is a reference implementation:
> https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email- 
> john.garry@huawei.com/

How about using the (lightly tested) patch below instead of that patch?
The patch below has the advantage that it doesn't duplicate any SCSI
core code. Additionally, it preserves the logic for initializing driver-
private data for reserved commands.

Thanks,

Bart.

[PATCH] scsi: core: Bypass the queue limit checks for reserved commands

Reserved commands can be TMFs or commands allocated and submitted by the
LLD. These commands can be SCSI commands or non-SCSI commands. For all
these cases, bypass the SCSI host, target and device queue limit checks
for reserved commands. Additionally, do not activate the SCSI error
handler if a reserved command fails.

Signed-off-by: John Garry <john.garry@huawei.com>
[ bvanassche: modified patch title and patch description. Renamed
   .reserved_queuecommand() into .queue_reserved_command(). Changed
   the second argument of __blk_mq_end_request() from 0 into error
   code in the completion path if cmd->result != 0. Rewrote the
   scsi_queue_rq() changes. See also
  
https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email-john.garry@huawei.com/ 
]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/hosts.c     |  6 +++++
  drivers/scsi/scsi_lib.c  | 54 ++++++++++++++++++++++++++++------------
  include/scsi/scsi_host.h |  7 ++++++
  3 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e860ac93499d..75fe624366c3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -231,6 +231,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, 
struct device *dev,
  		goto fail;
  	}

+	if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
+		shost_printk(KERN_ERR, shost,
+			     "nr_reserved_cmds set but no method to queue\n");
+		goto fail;
+	}
+
  	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
  	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
  				   shost->can_queue);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0112ad3859ff..2d81fd837d47 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1539,6 +1539,14 @@ static void scsi_complete(struct request *rq)
  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
  	enum scsi_disposition disposition;

+	if (blk_mq_is_reserved_rq(rq)) {
+		/* Only pass-through requests are supported in this code path. */
+		WARN_ON_ONCE(!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)));
+		scsi_mq_uninit_cmd(cmd);
+		__blk_mq_end_request(rq, scsi_result_to_blk_status(cmd->result));
+		return;
+	}
+
  	INIT_LIST_HEAD(&cmd->eh_entry);

  	atomic_inc(&cmd->device->iodone_cnt);
@@ -1828,25 +1836,31 @@ static blk_status_t scsi_queue_rq(struct 
blk_mq_hw_ctx *hctx,
  	WARN_ON_ONCE(cmd->budget_token < 0);

  	/*
-	 * If the device is not in running state we will reject some or all
-	 * commands.
+	 * Bypass the SCSI device, SCSI target and SCSI host checks for
+	 * reserved commands.
  	 */
-	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
-		ret = scsi_device_state_check(sdev, req);
-		if (ret != BLK_STS_OK)
-			goto out_put_budget;
-	}
+	if (!blk_mq_is_reserved_rq(req)) {
+		/*
+		 * If the device is not in running state we will reject some or
+		 * all commands.
+		 */
+		if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
+			ret = scsi_device_state_check(sdev, req);
+			if (ret != BLK_STS_OK)
+				goto out_put_budget;
+		}

-	ret = BLK_STS_RESOURCE;
-	if (!scsi_target_queue_ready(shost, sdev))
-		goto out_put_budget;
-	if (unlikely(scsi_host_in_recovery(shost))) {
-		if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
-			ret = BLK_STS_OFFLINE;
-		goto out_dec_target_busy;
+		ret = BLK_STS_RESOURCE;
+		if (!scsi_target_queue_ready(shost, sdev))
+			goto out_put_budget;
+		if (unlikely(scsi_host_in_recovery(shost))) {
+			if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
+				ret = BLK_STS_OFFLINE;
+			goto out_dec_target_busy;
+		}
+		if (!scsi_host_queue_ready(q, shost, sdev, cmd))
+			goto out_dec_target_busy;
  	}
-	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
-		goto out_dec_target_busy;

  	/*
  	 * Only clear the driver-private command data if the LLD does not supply
@@ -1875,6 +1889,14 @@ static blk_status_t scsi_queue_rq(struct 
blk_mq_hw_ctx *hctx,
  	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;

  	blk_mq_start_request(req);
+	if (blk_mq_is_reserved_rq(req)) {
+		reason = shost->hostt->queue_reserved_command(shost, cmd);
+		if (reason) {
+			ret = BLK_STS_RESOURCE;
+			goto out_put_budget;
+		}
+		return BLK_STS_OK;
+	}
  	reason = scsi_dispatch_cmd(cmd);
  	if (reason) {
  		scsi_set_blocked(cmd, reason);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b5150759c44..a615dcaa0ae8 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -86,6 +86,13 @@ struct scsi_host_template {
  	 */
  	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);

+	/*
+	 * Queue a reserved command (BLK_MQ_REQ_RESERVED). The .queuecommand()
+	 * documentation also applies to the .queue_reserved_command() callback.
+	 *
+	 */
+	int (*queue_reserved_command)(struct Scsi_Host *, struct scsi_cmnd *);
+
  	/*
  	 * The commit_rqs function is used to trigger a hardware
  	 * doorbell after some requests have been queued with

