Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAC332C94A
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787674014; cv=none; b=EqKrb3iuX/qhmbBf0hV0BGzHdxkjQntzpGBL2OA4SL1OMUHdE5xD8lI98DiAaU9gkKMTtsUzoAkcqVGZwJ2PhoS+kcf4Gaj6PgOWnApNX1VLPd5RLVo6YmranxZZA8xrbqTYlMSI46GxyEeRP7SF898z+yOtWKftLJ20ob1dJo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787674014; c=relaxed/simple;
	bh=a27BC+Sxj3WJvFGi9vGrdb6aXrSUq1PFm+t22p+bIj0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hAoKdUkUTDVIILeZUHaFDDfpoKKY+fpXTTHpVyB9I8WvTsgWTqOzwAzzhfNyqjh9B1q8gJCgZH7hWhG2KyoL99Qi7G7vVTjYfA9JQjkI6dxR0qIkvUZybJumxSbR+OfxLEhorw43zlDXLr9eRP7ZW8JwQGxJzaLI/yQzBfmWkyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KXUk02dV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KXUk02dV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E480B1F000E9;
	Tue, 25 Aug 2026 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787674013;
	bh=spteCoQCMch3ZOsvG8DRMSv4fi+kHLXA9hn6iReV9MY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KXUk02dVEmVTgsLFU8RdzYMEb1PYh7CPToPhmFj/GxsiOpFZvekCaugLH5shn1y4O
	 RRbetSEAm7jFHJayxwvg3S3e4mwMVtWqxprfUDhgb60umvhGOd9bSewo6N0qk0zW0h
	 4DumevXqiWmZat0ez2hqBMuj6mAfUy1qatNh36o0bOkedXWC8gJn4GLe0cGRCemlCZ
	 A7qTGwA3b1MTSKJJscGnDLiSKuMi92jRp+eE+pW/+TP42upRnFPEA7E2X8rRwar0n3
	 6/Ax+tiMaaacaA2T6hjXu0b7QziuYzSu+2mpOZEUC1XsxVtBSX2Ue4dhBmakbSE+9D
	 ECpQ4YTNfYnpA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/17] mpi3mr: Fix I/O block counter leak on admin
 request post failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260825210411.301535-4-chandrakanth.patil@broadcom.com>
References: <20260825210411.301535-1-chandrakanth.patil@broadcom.com>
 <20260825210411.301535-4-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 16:06:52 +0000
Message-Id: <20260825160652.E480B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free of `stgt_priv` during BSG command completion and th=
e error path, due to a lack of reference counting on the SCSI target.
- [High] Out-of-bounds read when processing BSG buffer entries due to missi=
ng bounds check on `num_of_entries` against `job->request_len`.
--

commit cf44d8f7dd728a84e0a426ff369621891f88ea4e
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix I/O block counter leak on admin request post failure

The per device I/O block counter is raised before a task management
request is posted and only lowered once the request completes. If the
post itself fails the counter stays raised, so this commit lowers it
on the failure path as well.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index 1cd1c38dcd565..a4fe10a05cb3a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -2782,6 +2782,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job)
>  		dprint_bsg_err(mrioc,
>  		    "%s: posting bsg request is failed\n", __func__);
>  		rval =3D -EAGAIN;
> +		if (block_io && stgt_priv)
> +			atomic_dec(&stgt_priv->block_io);

[Severity: High]
This isn't a bug introduced by this patch, but does dropping the target
device reference earlier leave stgt_priv unprotected?

Earlier in this function, the tgtdev reference is dropped without pinning
the SCSI target:

	if (tgtdev->starget && tgtdev->starget->hostdata) {
		stgt_priv =3D (struct mpi3mr_stgt_priv_data *)
		    tgtdev->starget->hostdata;
		atomic_inc(&stgt_priv->block_io);
	}
	mpi3mr_tgtdev_put(tgtdev);

If a concurrent device removal occurs, the SCSI midlayer could destroy the
target and free its hostdata via mpi3mr_target_destroy() while the driver
is processing the request or sleeping in wait_for_completion_timeout().

Could this lead to a use-after-free when atomic_dec(&stgt_priv->block_io)
is called on this error path and on the completion path?

>  		goto out_unlock;
>  	}

[Severity: High]
This is also a pre-existing issue, but does this function properly validate
the number of buffer entries against the allocated request payload size?

Earlier in mpi3mr_bsg_process_mpt_cmds():

	bufcnt =3D karg->buf_entry_list.num_of_entries;
	...
	for (count =3D 0; count < bufcnt; count++, buf_entries++, drv_buf_iter++) {
		switch (buf_entries->buf_type) {

If a userspace application supplies a small request_len but a large
num_of_entries, could the loop read past the end of the job->request payloa=
d?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825210411.3015=
35-1-chandrakanth.patil@broadcom.com?part=3D3
