Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C8B27F010
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2025 18:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759343186; cv=none; b=KoDxqhXSW6WZp+uv36C0CUEKkgbF3URUpSSyp43rpFnt5TEfvpN1ij8Hp35hghr7bNlvQOVFVTETPjUZDxhE3nfX8gYQ1s3+0GpGlc0kCgQgEL7DZ+p7rJoyqe/sn4L565Qm5m+Lr6MqPq0ST3v2qOMh//f17cqPIF714gpCVhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759343186; c=relaxed/simple;
	bh=gP7tnBY3et54D1/qMckmfe6d2P3kTunEEagxKf4QqsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dJNarzWwLlLA4QhNTZLuRLyKLbZP9JZ68nL/edV5Qpv1kWW0hRcgN2WTzQ9GjuLYzHGemK9ABAvkd/IRhOzxJFFhzo1RToxCAkjZYdzkaLElbGLo/a7qyxOfnaA+RgozJv8YeHAFyAYfUR0544c7tjr66ALdGWu7l/TUgn6YmMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eaOGqKgc; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eaOGqKgc"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ccNfd6Tgkzm16lc;
	Wed,  1 Oct 2025 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759343176; x=1761935177; bh=vgoihnCjIYQwd3VJu5cYYmWh
	/UpvxNdycbmfyrLkiR4=; b=eaOGqKgcvCgW9axfBzW5UPw1VzlFBn6W9sF+DT52
	rH9Gwrm+dKcv+2OI+d+R+82EfsVKeDmnaD1H+1kwCFrIyyzxSS4rAycRb6SuJRx4
	PZKH9DWxLUsSMspqqbscCSH2vs8B0RYA85WfWsB2+Zk7PHmtvosupbqG3R0XFwHj
	WeqYFMYPPIZ5vOKxN+IuViISokUWMdbzALqkxDZaJRP3igCiq7gjKZaD9PJdbkap
	GtX6DMEjYWs12CSdP5mKFP/tWOU5qfwWjlOgy3Ka6T0F5OAFWFyN1/nsjPvWq70e
	iI/Oi8J/OMkNzIBDEGPHw0eiKKEAdU6KyKrZpQtE7tSm6A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iEHYTfepactU; Wed,  1 Oct 2025 18:26:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ccNfZ0tPSzm1C3P;
	Wed,  1 Oct 2025 18:26:12 +0000 (UTC)
Message-ID: <3e48d566-5033-49af-80e1-aa823bb9e667@acm.org>
Date: Wed, 1 Oct 2025 11:26:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] scsi_debug: Abort SCSI commands via
 .queue_reserved_command()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-8-bvanassche@acm.org>
 <aea7f72a-7d65-4ab6-98c3-34abf112f6e1@oracle.com>
 <550f7c16-036c-409d-9f5e-0fb2a5b3baa9@acm.org>
 <b0bf30d3-d682-4a13-b157-b30b304ecf56@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b0bf30d3-d682-4a13-b157-b30b304ecf56@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/30/25 12:03 AM, John Garry wrote:
> On 26/09/2025 21:44, Bart Van Assche wrote:
>> =C2=A0=C2=A0static atomic_t sdebug_cmnd_count;=C2=A0=C2=A0 /* number o=
f incoming commands */
>> @@ -9518,7 +9516,8 @@ static const struct scsi_host_template=20
>> sdebug_driver_template =3D {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .module =3D=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 THIS_MODULE,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .skip_settle_delay =3D=C2=A0=C2=A0=C2=A0=
 1,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .track_queue_depth =3D=C2=A0=C2=A0=C2=A0=
 1,
>> -=C2=A0=C2=A0=C2=A0 .cmd_size =3D sizeof(struct sdebug_scsi_cmd),
>> +=C2=A0=C2=A0=C2=A0 .cmd_size =3D sizeof(union { struct sdebug_scsi_cm=
d c;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct scsi_debug_internal_cmd ic=
; }),
>=20
> ok, but you could also introduce a new structure which defines this=20
> union. That's looks a little bit better.
>=20
>>>> +=C2=A0=C2=A0=C2=A0 abort_cmd =3D scsi_get_internal_cmd(shost->pseud=
o_sdev,=20
>>>> DMA_TO_DEVICE,
>>>
>>> DMA_NONE?
>>
>> DMA_TO_DEVICE is converted into REQ_OP_DRV_OUT by=20
>> scsi_get_internal_cmd(). Isn't that more appropriate for an operation
>> that has side effects (aborting a SCSI command) rather than
>> REQ_OP_DRV_IN?
>=20
> but it it make a difference if we use REQ_OP_DRV_OUT or REQ_OP_DRV_IN?=20
> If not, then I think DMA_NONE makes more sense.

The above feedback has been integrated in the patch below. The following
additional changes have been integrated in this patch:
- Use scsi_host_find_tag() to make the implementation more compact.
- Pass a 32-bit tag from scsi_debug_abort_cmnd() to the code that
   implements the abort instead of splitting this 32-bit tag into a
   16-bit hwq index and a 16-bit tag.

This new version passes the blktests test that I wrote to trigger the
new code.

Thanks,

Bart.


Subject: [PATCH] scsi_debug: Abort SCSI commands via an internal command

Add a .queue_reserved_command() implementation and call it from the code
path that aborts SCSI commands. This ensures that the code for
allocating a pseudo SCSI device and also the code for allocating and
processing reserved commands gets triggered while running blktests.

Most of the code in this patch is a modified version of code from John
Garry. See also
https://lore.kernel.org/linux-scsi/75018e17-4dea-4e1b-8c92-7a224a1e13b9@o=
racle.com/

Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/scsi_debug.c | 113 ++++++++++++++++++++++++++++++++++----
  1 file changed, 102 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2a8638937d23..6e68ed131726 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6729,20 +6729,59 @@ static bool scsi_debug_stop_cmnd(struct=20
scsi_cmnd *cmnd)
  	return false;
  }

+struct sdebug_abort_cmd {
+	u32 unique_tag;
+};
+
+enum sdebug_internal_cmd_type {
+	SCSI_DEBUG_ABORT_CMD,
+};
+
+struct sdebug_internal_cmd {
+	enum sdebug_internal_cmd_type type;
+
+	union {
+		struct sdebug_abort_cmd abort_cmd;
+	};
+};
+
+union sdebug_priv {
+	struct sdebug_scsi_cmd c;
+	struct sdebug_internal_cmd ic;
+};
+
  /*
- * Called from scsi_debug_abort() only, which is for timed-out cmd.
+ * Abort a pending SCSI command. Only called from scsi_debug_abort().=20
Although
+ * it would be possible to call scsi_debug_stop_cmnd() directly, an=20
internal
+ * command is allocated and submitted to trigger the reserved command
+ * infrastructure.
   */
  static bool scsi_debug_abort_cmnd(struct scsi_cmnd *cmnd)
  {
-	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmnd);
-	unsigned long flags;
-	bool res;
-
-	spin_lock_irqsave(&sdsc->lock, flags);
-	res =3D scsi_debug_stop_cmnd(cmnd);
-	spin_unlock_irqrestore(&sdsc->lock, flags);
-
-	return res;
+	struct Scsi_Host *shost =3D cmnd->device->host;
+	struct request *rq =3D scsi_cmd_to_rq(cmnd);
+	u32 unique_tag =3D blk_mq_unique_tag(rq);
+	struct sdebug_internal_cmd *sdic;
+	struct scsi_cmnd *abort_cmd;
+	struct request *abort_rq;
+	blk_status_t res;
+
+	abort_cmd =3D scsi_get_internal_cmd(shost->pseudo_sdev, DMA_NONE,
+					  BLK_MQ_REQ_RESERVED);
+	if (!abort_cmd)
+		return false;
+	sdic =3D scsi_cmd_priv(abort_cmd);
+	*sdic =3D (struct sdebug_internal_cmd) {
+		.type =3D SCSI_DEBUG_ABORT_CMD,
+		.abort_cmd =3D {
+			.unique_tag =3D unique_tag,
+		},
+	};
+	abort_rq =3D scsi_cmd_to_rq(abort_cmd);
+	abort_rq->timeout =3D secs_to_jiffies(3);
+	res =3D blk_execute_rq(abort_rq, true);
+	scsi_put_internal_cmd(abort_cmd);
+	return res =3D=3D BLK_STS_OK;
  }

  /*
@@ -9197,6 +9236,53 @@ static int sdebug_fail_cmd(struct scsi_cmnd=20
*cmnd, int *retval,
  	return ret;
  }

+static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct=20
scsi_cmnd *scp)
+{
+	struct sdebug_internal_cmd *sdic =3D scsi_cmd_priv(scp);
+	struct sdebug_abort_cmd *abort_cmd =3D &sdic->abort_cmd;
+	const u32 unique_tag =3D abort_cmd->unique_tag;
+	struct scsi_cmnd *to_be_aborted_scmd =3D
+		scsi_host_find_tag(shost, unique_tag);
+	struct sdebug_scsi_cmd *to_be_aborted_sdsc =3D
+		scsi_cmd_priv(to_be_aborted_scmd);
+	bool res =3D false;
+
+	if (to_be_aborted_scmd) {
+		scoped_guard(spinlock_irqsave, &to_be_aborted_sdsc->lock)
+			res =3D scsi_debug_stop_cmnd(to_be_aborted_scmd);
+		if (res)
+			pr_info("%s: aborted command with tag %#x\n",
+				__func__, unique_tag);
+		else
+			pr_err("%s: failed to abort command with tag %#x\n",
+			       __func__, unique_tag);
+	} else {
+		pr_err("%s: command with tag %#x not found\n", __func__,
+		       unique_tag);
+	}
+
+	set_host_byte(scp, res ? DID_OK : DID_ERROR);
+}
+
+static int scsi_debug_process_reserved_command(struct Scsi_Host *shost,
+					       struct scsi_cmnd *scp)
+{
+	struct sdebug_internal_cmd *sdic =3D scsi_cmd_priv(scp);
+
+	switch (sdic->type) {
+	case SCSI_DEBUG_ABORT_CMD:
+		scsi_debug_abort_cmd(shost, scp);
+		break;
+	default:
+		WARN_ON_ONCE(true);
+		set_host_byte(scp, DID_ERROR);
+		break;
+	}
+
+	scsi_done(scp);
+	return 0;
+}
+
  static int scsi_debug_queuecommand(struct Scsi_Host *shost,
  				   struct scsi_cmnd *scp)
  {
@@ -9397,6 +9483,9 @@ static int sdebug_init_cmd_priv(struct Scsi_Host=20
*shost, struct scsi_cmnd *cmd)
  	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmd);
  	struct sdebug_defer *sd_dp =3D &sdsc->sd_dp;

+	if (blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))
+		return 0;
+
  	spin_lock_init(&sdsc->lock);
  	hrtimer_setup(&sd_dp->hrt, sdebug_q_cmd_hrt_complete, CLOCK_MONOTONIC,
  		      HRTIMER_MODE_REL_PINNED);
@@ -9416,6 +9505,7 @@ static const struct scsi_host_template=20
sdebug_driver_template =3D {
  	.sdev_destroy =3D		scsi_debug_sdev_destroy,
  	.ioctl =3D		scsi_debug_ioctl,
  	.queuecommand =3D		scsi_debug_queuecommand,
+	.queue_reserved_command =3D scsi_debug_process_reserved_command,
  	.change_queue_depth =3D	sdebug_change_qdepth,
  	.map_queues =3D		sdebug_map_queues,
  	.mq_poll =3D		sdebug_blk_mq_poll,
@@ -9425,6 +9515,7 @@ static const struct scsi_host_template=20
sdebug_driver_template =3D {
  	.eh_bus_reset_handler =3D scsi_debug_bus_reset,
  	.eh_host_reset_handler =3D scsi_debug_host_reset,
  	.can_queue =3D		SDEBUG_CANQUEUE,
+	.nr_reserved_cmds =3D	1,
  	.this_id =3D		7,
  	.sg_tablesize =3D		SG_MAX_SEGMENTS,
  	.cmd_per_lun =3D		DEF_CMD_PER_LUN,
@@ -9433,7 +9524,7 @@ static const struct scsi_host_template=20
sdebug_driver_template =3D {
  	.module =3D		THIS_MODULE,
  	.skip_settle_delay =3D	1,
  	.track_queue_depth =3D	1,
-	.cmd_size =3D sizeof(struct sdebug_scsi_cmd),
+	.cmd_size =3D sizeof(union sdebug_priv),
  	.init_cmd_priv =3D sdebug_init_cmd_priv,
  	.target_alloc =3D		sdebug_target_alloc,
  	.target_destroy =3D	sdebug_target_destroy,

