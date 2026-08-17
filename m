Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195421A3029
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 01:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786931625; cv=none; b=UeKfyoo2roADqzG7gdqRyMY7wgwz09CcdQ3Z2ELkMUGCrwVfuwRZMuPKwUTKr/3xEdUUqWcxX5Z9Bvn080TGLonKJ3Qgfe21uOqzeftDvImnJlOMwLMJoF8o5vEv6ajm4HJ72C713RQr+wmQSXsD0laLZmsOTrkWLQkAwiEGsUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786931625; c=relaxed/simple;
	bh=zMFImuFbeLKySkggIjsyzFZXfhM44i7aORaRKTUN9d8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E/VM8aIkd3wllGniOQBs+UsxtS8nPkySR6AOu7U1znps3qTdKd+/bdTHLAAL9CLPOiBsddP2M3QhVgpq1MbBSHdkWf2yVWIRaVsndte4OTQTXfoobFHvz9hR2HXhj9ZeGYd3jLMkIkMrmd/H0cJ1bZEWbndzfR/Hz/NzHqupvSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmEmdoyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmEmdoyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830BF1F000E9;
	Mon, 17 Aug 2026 01:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786931623;
	bh=Auk8dK9AUL+GOf+AgE62HSoX0SQCStwXdh63Afq2GTo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WmEmdoydRcMOKS+oIHYTLkiSym5bnFD3XsK/6yLzrFyH34qHo7sNRmncwtHRqjBtj
	 Zol3l0zQMJkPN090VWubP2cZDTI2Iu3i1LUhXvditQP9AN3O55f0L0tW4HToFG8l8I
	 G48BhF3sl6xfIZKKXo0jQB0pAXICASDw+yRaatv0h35x2LMOdvMKYg5wQkCY9DaA8H
	 0Fnjf22bbcGhtWITDozlphk0X+QMHblU+xEpXRgcOGr0zpXh0oC9SxRnoMv3tz8sgz
	 19Tm7OGZfDh1tg1yaYiO4HQBXFD2A1jovgYBRw/+fT1d2OfoichFAKBshp/YoZzPdD
	 z9sSthFY+6dYw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: bsg: map io_uring user buffers with
 GFP_KERNEL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817013959.165425-3-yangxiuwei@kylinos.cn>
References: <20260817013959.165425-1-yangxiuwei@kylinos.cn>
 <20260817013959.165425-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 01:53:43 +0000
Message-Id: <20260817015343.830BF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Unconditionally using GFP_KERNEL for memory allocation when IO_URI=
NG_F_NONBLOCK is set allows the io_uring submitter thread to sleep, violati=
ng non-blocking semantics.

Pre-existing issues:
- [High] Allocating memory with GFP_KERNEL while holding a block request ta=
g can trigger a tag exhaustion deadlock in the block layer.
--

--- Patch [2]: [PATCH v3 2/2] scsi: bsg: map io_uring user buffers with GFP=
_KERNEL ---
commit 4107274feb8462924a88001746916a4f70f777fe
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>

scsi: bsg: map io_uring user buffers with GFP_KERNEL

IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation. Mapping the user buffer may sleep, so use GFP_KERNEL
instead of GFP_NOWAIT.

> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> index 7758c5f22a7e9..ddb33ae684837 100644
> --- a/drivers/scsi/scsi_bsg.c
> +++ b/drivers/scsi/scsi_bsg.c
> @@ -89,10 +88,10 @@ static int scsi_bsg_map_user_buffer(struct request *r=
eq,
>  						&iter, ioucmd, issue_flags);
>  		if (ret < 0)
>  			return ret;
> -		ret =3D blk_rq_map_user_iov(req->q, req, NULL, &iter, gfp_mask);
> +		ret =3D blk_rq_map_user_iov(req->q, req, NULL, &iter, GFP_KERNEL);
>  	} else {
>  		ret =3D blk_rq_map_user(req->q, req, NULL, uptr64(buf_addr),
> -				      buf_len, gfp_mask);
> +				      buf_len, GFP_KERNEL);
>  	}

[Severity: High]
This is a pre-existing issue, but does this allocation trigger a tag
exhaustion deadlock?

In scsi_bsg_uring_cmd(), scsi_alloc_request() has already been called, which
consumes a hardware tag from the block device's limited pool.

Calling blk_rq_map_user_iov() with GFP_KERNEL immediately after allows the
allocation to sleep in memory reclaim. If concurrent bsg io_uring commands
allocate all available hardware tags and then enter direct reclaim, and the
reclaim path attempts to write dirty pages back to the same block device, it
will require a hardware tag.

Since all tags would be held by threads waiting for memory, the reclaim
writeback cannot proceed. Shouldn't allocations performed while holding a
block tag use GFP_NOIO or GFP_NOWAIT to prevent block IO recursion?

[ ... ]

> @@ -132,10 +130,8 @@ static int scsi_bsg_uring_cmd(struct request_queue *=
q, struct io_uring_cmd *iouc
>  	if (cmd->dout_iovec_count > 0 || cmd->din_iovec_count > 0)
>  		return -EOPNOTSUPP;
> =20
> -	if (issue_flags & IO_URING_F_NONBLOCK) {
> +	if (issue_flags & IO_URING_F_NONBLOCK)
>  		blk_flags =3D BLK_MQ_REQ_NOWAIT;
> -		gfp_mask =3D GFP_NOWAIT;
> -	}
> =20
>  	req =3D scsi_alloc_request(q, dout_xfer_len ?
>  				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);

[Severity: High]
Does removing the gfp_mask downgrade here violate io_uring non-blocking
semantics?

When IO_URING_F_NONBLOCK is set, the io_uring core expects the issue handler
to be strictly non-blocking. If it cannot allocate memory without sleeping,=
 it
should return -EAGAIN so the request can be deferred to an asynchronous io-=
wq
worker thread.

By removing GFP_NOWAIT and unconditionally using GFP_KERNEL for mapping the
buffer, won't this allow the submission thread (such as the SQPOLL thread)
to block in direct reclaim, stalling other independent operations on the
same ring?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817013959.1654=
25-1-yangxiuwei@kylinos.cn?part=3D2
