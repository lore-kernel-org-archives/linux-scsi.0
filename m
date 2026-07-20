Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0540399360
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 03:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784518751; cv=none; b=VcCZcqRvntNTN6pRMdhG11RCcTAWz62f0X4mDt3Zk/H764iPi8eqFtUNUL/PH6aoXvgwBNYnQslCFO74VfiXoGkgXCrvdm8c14NH55HKuwILNhfpKqPpV8U2qBgjff6mM1W6SC3DA+wepqbYX4kX4sv5BzxQm7HuopAK4kB2xeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784518751; c=relaxed/simple;
	bh=PUS/MmzbCWbwCmQwMfsA+R/aMxrjVa0fIPZZUGye8d8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k2dV5VK5aT40NfOe1fy9fjcBe0uuuAzNqoh+ZVVlVxQk5i0AjyiC17FM0ma4vgfeGHm6dOgCtuJpvhL123c04p3G6+JzMF0UTlNMaRhZZqQWM6AutTZGhP3zTgrJy2fEHutcuoSJNTGy2D0IG7QVVSz12j6cJ32bkVe13Y2PlKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ivHJtHo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ivHJtHo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D501F000E9;
	Mon, 20 Jul 2026 03:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784518746;
	bh=Ip6FAAsUljmP3bugeOap/unXVigRHqJgIifCzY6hnOw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ivHJtHo0NjZ2d5Asqc5I8P0PBw5C3gyAu/hKAy5ZDp7LGeSwRBwHBHnzRKibPmVIy
	 mTUXHjBec9eqOdAPJsyDxW0GjQPiFIP+XtbiO8heK3EJ3uHzIwCtGFWu+Jkpb9Hutv
	 zr+pGHOi2SwLFWWBq4armrhDXDQp9Xso2WEZzzYv8f84aCXDqh7X0+5BLwhZmPE67e
	 jvZi9Pc7Hx+5fnwU2eT58mcBonVFFyojSADHAqohMp5s6JSD332Y+j0BEvMnAYuOiR
	 BvEtwbt8OURnPNoQ+y/xhNhmwAzh+8xx/YE17Y8L1Ej9JzI1KmMexekBDqH7ELxn3O
	 rJ777cVwBJ6lA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: bsg: map io_uring user buffers with
 GFP_KERNEL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260720032338.461681-3-yangxiuwei@kylinos.cn>
References: <20260720032338.461681-1-yangxiuwei@kylinos.cn>
 <20260720032338.461681-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 03:39:05 +0000
Message-Id: <20260720033906.61D501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Unconditionally using GFP_KERNEL forces the io_uring submitter thr=
ead to sleep, breaking non-blocking semantics.

Pre-existing issues:
- [High] Using GFP_KERNEL while holding a block layer request tag introduce=
s a tag exhaustion deadlock during memory reclaim.
--

--- Patch [2]: [PATCH 2/2] scsi: bsg: map io_uring user buffers with GFP_KE=
RNEL ---
commit e89699f2c58014fd3728ce2e8bed2b71fc1c0abf
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>

scsi: bsg: map io_uring user buffers with GFP_KERNEL

IO_URING_F_NONBLOCK only needs BLK_MQ_REQ_NOWAIT for request
allocation. Mapping the user buffer may sleep, so use GFP_KERNEL
instead of GFP_NOWAIT.

> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> index c57ce01379de5..f90d19fdbd8ea 100644
> --- a/drivers/scsi/scsi_bsg.c
> +++ b/drivers/scsi/scsi_bsg.c
> @@ -76,9 +76,8 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struc=
t request *req,
> =20
>  static int scsi_bsg_map_user_buffer(struct request *req,
>  				    struct io_uring_cmd *ioucmd,
> -				    unsigned int issue_flags, gfp_t gfp_mask,
> -				    bool is_write, u64 buf_addr,
> -				    unsigned long buf_len)
> +				    unsigned int issue_flags, bool is_write,
> +				    u64 buf_addr, unsigned long buf_len)
>  {
>  	struct iov_iter iter;
>  	int ret;
> @@ -89,10 +88,10 @@ static int scsi_bsg_map_user_buffer(struct request *r=
eq,
>  						&iter, ioucmd, issue_flags);
>  		if (ret < 0)
>  			return ret;
> -		ret =3D blk_rq_map_user_iov(req->q, req, NULL, &iter, gfp_mask);
> +		ret =3D blk_rq_map_user_iov(req->q, req, NULL, &iter, GFP_KERNEL);

[Severity: High]
This is a pre-existing issue, but does using GFP_KERNEL here while holding a
block request tag risk a tag exhaustion deadlock?

The request tag is allocated in scsi_alloc_request() prior to this mapping
step. If blk_rq_map_user_iov() triggers direct memory reclaim, and reclaim
attempts to write dirty pages to this same block device, it will need a tag.
If all tags are currently held by concurrent tasks stuck in this mapping
phase, won't the writeback block indefinitely?

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

[ ... ]

> @@ -170,8 +166,7 @@ static int scsi_bsg_uring_cmd(struct request_queue *q=
, struct io_uring_cmd *iouc
>  		unsigned long buf_len =3D is_write ? dout_xfer_len : din_xfer_len;
> =20
>  		ret =3D scsi_bsg_map_user_buffer(req, ioucmd, issue_flags,
> -					       gfp_mask, is_write, buf_addr,
> -					       buf_len);
> +					       is_write, buf_addr, buf_len);

[Severity: High]
Since this changes the allocation to GFP_KERNEL unconditionally, won't this
illegally block the io_uring submission context when IO_URING_F_NONBLOCK is
set?

If a non-blocking context like SQPOLL is forced to block for memory
allocation or page faults during scsi_bsg_map_user_buffer(), doesn't it sta=
ll
all other rings sharing the thread?

Should this path attempt mapping with GFP_NOWAIT first, and return -EAGAIN =
on
-ENOMEM so the operation can be safely punted to an async io-wq worker?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720032338.4616=
81-1-yangxiuwei@kylinos.cn?part=3D2
