Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF0341D65E
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782960; cv=none; b=FgPIhD1rZj/yZy2zojkX99K0BZcP6FiCTTl/WWoA5wBKuyfQcri6loeCfH1aZbMKW71mnwZWg+82iXEf9AG8KNLajoIt+wo7NFxUBQGXekKzACfrsQ8ViLruD4mtYugrIq8zsBxeHbivCI+b6CPjtRK/BLumELZxtN595OiJR8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782960; c=relaxed/simple;
	bh=KQF0h1ZqHjAw8GBy9xE9tPVBypSVsjdjF5g25o1zOGg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QGEzT1eyT8qNPJznEMwnwH4PLF6qFxIcf4RIRiHLoP5NE7i+kGj25/tnEQVTspK+Qp6PFxWZdGs7r/GzIGrpXRdZ88leNCMOBN2/8yibekljd0m/EOolfsvglKyMSxhAygeQiY6550UfZVQddsJdogJpRfmbcKsgwIb2lGaedDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRyCtvvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRyCtvvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4D41F00A3A;
	Mon,  7 Sep 2026 12:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788782959;
	bh=8JsKYsk22rEA0YfVHDKxUbMNmbAYhvgha8eaATNeJLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GRyCtvvQWDsYlRAUsfKAZm5dwj0oj1IlKjCdBArv8NNvhJoOAdE1mhQEjpgGHcKpf
	 PRQ7+VFKxPHWvQnAedk3BZgZFhaZJeuYCPTu2zDx6laGGgIbZCsOsXQko8nevhgn4Q
	 bPzCkONg7MVQYCTBpFiLz0W+3l5Zoxpod837bhpH+C6rwnqEsQ3qZlybK5B/TNkfUC
	 9fLfuj4GXRL2XsLmwzQzh9mvM6A4Lj+cU9dqaV3xoHQAzjbH6RqDo0UVB0SXbohwVq
	 RlYAFtFxirbIIbvW8SoIzdLQ2Ot3kxEPTb2gZ5gK/sf6JyQ9ex7tWDhKmdJavcuLcI
	 BqQ1UowIe2L8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-21-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-21-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 12:09:18 +0000
Message-Id: <20260907120918.DC4D41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Leaked multipath active counter (`mpath_nr_active`) and corrupted =
IO stats when `scsi_queue_rq` returns a hard error or `blk_mq` cancels a re=
queued request.
--

commit 2b78aa9717f460c8d3814043976386ee7f6864c3
Author: John Garry <john.garry@linux.dev>

scsi-multipath: add scsi_mpath_{start,end}_request()

This patch adds scsi_mpath_start_request() and scsi_mpath_end_request() to
manage multipath request data. It also introduces mpath_nr_active to track
the number of active requests per SCSI host.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 1a6f5e1fd80cb..193e7e9a2d30b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -1918,6 +1921,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
>  	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>  	cmd->submitter =3D SUBMITTED_BY_BLOCK_LAYER;
> =20
> +	if (sdev->scsi_mpath_dev && is_mpath_request(req))
> +		scsi_mpath_start_request(req);
> +
>  	blk_mq_start_request(req);
>  	if (blk_mq_is_reserved_rq(req)) {

[Severity: High]
Can this leak the mpath_nr_active counter and corrupt IO stats if a request
encounters a hard error after being requeued?

For example, if a request is dispatched and scsi_mpath_start_request()
increments the counter and sets SCMD_MPATH_CNT_ACTIVE:

If the dispatch returns a non-fatal error (like BLK_STS_RESOURCE), the
block layer requeues the request. The SCMD_MPATH_CNT_ACTIVE flag is
preserved across the requeue via SCMD_PRESERVED_FLAGS.

On the next dispatch attempt, if the device goes offline,
scsi_device_state_check() fails early, jumping to the error path in
scsi_queue_rq():

	out_put_budget:
	...
	default:
		if (unlikely(!scsi_device_online(sdev)))
			cmd->result =3D DID_NO_CONNECT << 16;
		...
		if (req->rq_flags & RQF_DONTPREP)
			scsi_mq_uninit_cmd(cmd);

scsi_queue_rq() then returns the hard error to the block layer, which
completes the request directly, bypassing scsi_end_request() and
scsi_mpath_end_request().

Since the counter and stats are never decremented, will this permanently
skew the in-flight IO stats and eventually stall I/O when MPATH_IOPOLICY_QD
is used?

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 8ecfb94049db5..52227e2cd9749 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -58,8 +58,11 @@ struct scsi_pointer {
>   */
>  #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
>  #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
> +#define SCMD_MPATH_IO_STATS	(1 << 5)
> +#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
>  /* flags preserved across unprep / reprep */
> -#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
> +#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING=
 | \
> +				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)

[Severity: High]
Does adding these flags to SCMD_PRESERVED_FLAGS cause the issue mentioned
above by masking the fact that the request already holds the mpath active
counter when it comes back through scsi_queue_rq()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D20
