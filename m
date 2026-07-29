Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375CB45C70F
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785341565; cv=none; b=ELRWbQKBMb36pmPmAcelIqRm/Qpbp/GSDNSJ8cEIR5Drr8Xc0sZuIJFQtupi4jvP4WMw+F4FIDqV6URW6c+fKZWdRTIwCjfZQ5EQ5n8uzdGjRaQgHx3uOrGlEMybi3AVCMxK/MIyHxntVaAqSoQ/a7nzJnpy1pd/RDfZwjcPaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785341565; c=relaxed/simple;
	bh=OpH4Sq8zPzovpw7yviDnGRKCzvm32+RIJdhcgrVkwd4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BrIjELxzvCigJB/h158Fj2tM2QC1l5OQadQc8iBKAVRp1N3b8W5GT0wpL3hVGfih/8XjhnjFefUHJFIcF+RtEz3wY3x8on3QTT9122DCM6KBIBywIrbgarDrZAurhW840lWSjSHdxw7H/dXRKyH2wHLpd4bBekDnz589DjlDFJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtnGIhMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtnGIhMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C918D1F00A3A;
	Wed, 29 Jul 2026 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785341564;
	bh=PrjQs2yI3wDaigk6IIAi53vfPAXnGDFVmo5CFCmgDwU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CtnGIhMsbOuu3TnUfPCraCrG4971XD+Th7ViS78kZUHrIyoGkjrWvrMK3c1P3QY2C
	 NjKRPDUI2F5WqEpPiOf6WKT4NR7/Q4pNoz3AQQHyPYbF1Gh1uLBlimdZzQTH8vh5XY
	 EwIN2vJHx/uPIusc6JBK17lN4FbiNJNxmwfi/efHqwiYdsMok/nOMsvGkGLlT6sWlT
	 D/Fn0vI8NAkR79+gXVEXZdbMWXpqYW6zfUOb3IL+uVu4VQrdXIfTiyF1bX9kf2leql
	 jKLKUlN4oDOGFo6HFMvA3L+3yq7gvYqQYLKWeTrYUSORAVVWaz6D+/hfW9HExx9Mhf
	 lpt8K4LDt/J1w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-21-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-21-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 16:12:43 +0000
Message-Id: <20260729161243.C918D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Permanent leak of mpath_nr_active counter and master block device =
in-flight IO stats when a requeued multipath request fails with a hard erro=
r.
--

--- Patch [20]: [PATCH v6 20/27] scsi-multipath: add scsi_mpath_{start,end}=
_request() ---
commit 1a27bdf4453d197f11533d04e7997e7873652eb4
Author: John Garry <john.garry@linux.dev>

scsi-multipath: add scsi_mpath_{start,end}_request()

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6a2d7dbfbe8c3..ce9a2c7fbe707 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -1917,6 +1920,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
>  	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>  	cmd->submitter =3D SUBMITTED_BY_BLOCK_LAYER;
> =20
> +	if (sdev->scsi_mpath_dev && is_mpath_request(req))
> +		scsi_mpath_start_request(req);
> +
>  	blk_mq_start_request(req);
>  	if (blk_mq_is_reserved_rq(req)) {
>  		reason =3D shost->hostt->queue_reserved_command(shost, cmd);

[Severity: High]
Can this permanently leak the mpath_nr_active counter and master block devi=
ce
in-flight IO stats when a requeued multipath request fails with a hard erro=
r?

When a multipath request is dispatched, scsi_mpath_start_request() incremen=
ts
mpath_nr_active and sets SCMD_MPATH_CNT_ACTIVE. If the dispatch then fails
with BLK_STS_RESOURCE (e.g. due to a full queue), the request is requeued a=
nd
the multipath flags are preserved by SCMD_PRESERVED_FLAGS.

On a subsequent retry, if the device has transitioned to an offline state
(which is common during path failure), the early state check in
scsi_queue_rq() returns an error before scsi_mpath_start_request() is
reached:

	if (unlikely(sdev->sdev_state !=3D SDEV_RUNNING)) {
		ret =3D scsi_device_state_check(sdev, req);
		if (ret !=3D BLK_STS_OK)
			goto out_put_budget;
	}

Returning an error here causes the block layer to directly complete the
request, bypassing the driver's normal scsi_end_request() completion path.
The block layer will eventually call the scsi_cleanup_rq() hook, which mere=
ly
zeroes cmd->flags:

	cmd->flags =3D 0;

but fails to decrement mpath_nr_active or call bdev_end_io_acct().

Would this leave the queue-depth multipath I/O policy perceiving an
artificially inflated load on the controller, permanently degrading load
balancing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D20
