Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D6C2D97B9
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 01:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785117344; cv=none; b=VDRflaufso+XBPPLe+8J2HdquYfY91TaEsJPISkqHICRQqcBK6hK0T+8GrkpGAPES4qlmxcynobWSKTH4BQCB8ZjACBP6aYu19iEIwQjCAUZKVtGg7zjqEYs7ba1dVOLr73w0QeaRrKopWhYvpb6JVywqElU7soHbQy+cjp7U+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785117344; c=relaxed/simple;
	bh=K/3Vb3ootYZZM9BQdqs4jb59YJYN4GDy8G63GjHT/MU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mkap/J+Z2lLTeVyTvC/UQBb0pOks/Rb0m06bLFOOPTqfdOMrgatzZIamj7HQVKo9PFCGoIsbUS9RZittpbJ/IkdX5r53Bdct3F7DP531+U9paiC3q5coOVTS06ExiBoJKZEjE6OtOb3/gCoJYCa2bSaFM5aJv0MRhFRz6PpxtK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NYiepzs5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NYiepzs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D929B1F000E9;
	Mon, 27 Jul 2026 01:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785117343;
	bh=q8WR5+ONWFEwmYwdFcewvUb3LkPQ6CvY9lCkLij576M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NYiepzs52n8xl9yP1ZgtjPlNRXaBuQ6M6t0yyolOfvxzP8P0rNFHLBcuENVTsE79v
	 Au6hrXWqwKEhdgIsCWATdfJsNr1xwuatjHdB83Nw3f9sgzUdddlw/tmGFA7J3pjCLe
	 SxRUMNIbfB28xAj1njzitanzBUgNth58eq3jA1HH95DWDamwA3vDkpuyZ5BmfP4o/W
	 xLvD8LQjEJN/XN5Cf/XzgOM+z4sBNqY6UGjX740G8MUex2vZ0ZTHEeD/N4MPlfBtsi
	 5jMKL9zADmur3iVBuh9eJLeaGYhgIG2R+WIKrNyVQaDx27MN1K8OFKZIdOdrpmYAeU
	 XdCdsW1JG9l1g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: bsg: map io_uring user buffers with
 GFP_KERNEL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727014117.1742202-3-yangxiuwei@kylinos.cn>
References: <20260727014117.1742202-1-yangxiuwei@kylinos.cn>
 <20260727014117.1742202-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 01:55:42 +0000
Message-Id: <20260727015542.D929B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Using GFP_KERNEL in the non-blocking io_uring issue path introduce=
s a permanent task_work deadlock under memory pressure.

Pre-existing issues:
- [High] Allocating memory with GFP_KERNEL while holding a block layer requ=
est tag causes a tag exhaustion deadlock if memory reclaim needs to write t=
o the same device.
--

--- Patch [2]: [PATCH v2 2/2] scsi: bsg: map io_uring user buffers with GFP=
_KERNEL ---
commit 9c93dc072bebb5f4c7db406ce91a1fb2ffa4a9e7
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

[Severity: High]
This is a pre-existing issue, but does using GFP_KERNEL here cause a tag
exhaustion deadlock?

Prior to this call, scsi_alloc_request() consumes a hardware tag. If
GFP_KERNEL enters direct reclaim and needs to write dirty pages back to the
same block device, the filesystem will attempt to allocate another tag.

If all tags are currently held by blocked BSG tasks, won't the system deadl=
ock?

>  	} else {
>  		ret =3D blk_rq_map_user(req->q, req, NULL, uptr64(buf_addr),
> -				      buf_len, gfp_mask);
> +				      buf_len, GFP_KERNEL);
>  	}
> =20
>  	return ret;

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
Does removing the GFP_NOWAIT fallback for the non-blocking io_uring issue
path introduce a permanent task_work deadlock?

If a user submits more than 256 IORING_OP_URING_CMD operations in a single
batch, the bio allocations will exhaust the fs_bio_set mempool. By passing
GFP_KERNEL to blk_rq_map_user_iov(), mempool_alloc() will put the submitter
thread to sleep waiting for a bio to be freed.

Since these bios are freed when their completions run via task_work
(scsi_bsg_uring_task_cb), which must be executed by the very submitter thre=
ad
now permanently blocked in mempool_alloc(), does this create an unresolvable
circular dependency?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727014117.1742=
202-1-yangxiuwei@kylinos.cn?part=3D2
