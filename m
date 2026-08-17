Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D80726AC3
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 03:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786938392; cv=none; b=oAwRTQ/ZIgBmVz/FbOg05S4gpjXjqZWcKFdQzG1au3w/kvSfSN4u61GT6APjghF8tHjmeBXRWqOyXtBMo1vECY4lasGZElyhBgIP54G30F8vTNV4J6Q/CUQE+/qvH4dv3YjFEWkvUOdH14IUjKkZbygpwVZFKRAldX0aE1Whe2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786938392; c=relaxed/simple;
	bh=F7kVfeYcxFDtyKnEEixgB1uMZoUYk8IQ5jz2y8Toc6c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OX2AT69EvGpS1FBM1p+WLUSdbOG3yj+BQgYXGYT5PIb4+uYLLqMsXGwJEVSFaRHJA0oy5pSjZ+GxoRLXPYmz/qirxdVaZTdTAn3y3aq+UxJtHqzpNkQsesADJ4frcOjmNhCKFIXlKFO8qMmo7QAqRUM/gkcuOr32cPdixBLdPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WNwyLCy0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WNwyLCy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A5B1F000E9;
	Mon, 17 Aug 2026 03:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786938390;
	bh=MJvmXdyAIg/NoeBeT3KEkgdJCQTw8CB1DI4O+mfoUzw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WNwyLCy0SYJHfG6GSs3HYf6V7o7KSOAZ9DGk0iUiYm1WEhviHi5AqElLxqNjY9sMH
	 BCfeZqbeam8rGYWlRbwm+agZYQp2BEJEo3+6TS8LNqp7vrtJ4cWxZGR/BAvb3WRwuF
	 8/4bis+Tm/PAGObOL+egXK6+nu4BQaMJbNJgaY9nXQHkE+Bd42eld5wqf1cLxNDRaN
	 c2y9p60a8j7Za/itr94GFX8Fo66LOIxKLjdfqY0ooegd+IJUDfn8DI/RcK9VvtWVwI
	 bthXAFRJQSASUTefaOw2O6fV2uyR6P1t6xN1qwWs4Cpp6kRoeOlMwhBe/liFIPKa1G
	 orCklH4s2HQhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: smartpqi: Handle pqi_alloc_io_request() failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Triet Hoang" <triet.hoang.dev@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817033505.736519-1-triet.hoang.dev@gmail.com>
References: <20260817033505.736519-1-triet.hoang.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 03:46:29 +0000
Message-Id: <20260817034630.62A5B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch adds unreachable NULL pointer checks for `pqi_alloc_io=
_request()`. Furthermore, if the code were ever reached, it incorrectly ret=
urns a SCSI midlayer queuecommand status code (`SCSI_MLQUEUE_HOST_BUSY`) fr=
om synchronous internal management functions.
--

--- Patch [1]: [PATCH] scsi: smartpqi: Handle pqi_alloc_io_request() failur=
e ---
commit 1b3d9355dc4c0807df6a24f973784ecb04a972d7
Author: Triet Hoang <triet.hoang.dev@gmail.com>

scsi: smartpqi: Handle pqi_alloc_io_request() failure

Check the return value of pqi_alloc_io_request() before dereferencing
the returned request in pqi_submit_raid_request_synchronous() and
pqi_lun_reset(). Returns SCSI_MLQUEUE_HOST_BUSY when allocation fails.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index 140e8a6addbe3..5c4f9481923a7 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -4673,6 +4673,10 @@ static int pqi_submit_raid_request_synchronous(str=
uct pqi_ctrl_info *ctrl_info,
>  	}
> =20
>  	io_request =3D pqi_alloc_io_request(ctrl_info, NULL);
> +	if (!io_request) {
> +		rc =3D SCSI_MLQUEUE_HOST_BUSY;

[Severity: Medium]
Is this check reachable? Looking at pqi_alloc_io_request(), when the second
argument is NULL, it enters an infinite loop until it successfully claims
an I/O slot:

drivers/scsi/smartpqi/smartpqi_init.c:pqi_alloc_io_request() {
	...
		while (1) {
			io_request =3D &ctrl_info->io_request_pool[ctrl_info->scsi_ml_can_queue =
+ i];
			if (atomic_inc_return(&io_request->refcount) =3D=3D 1)
				break;
			atomic_dec(&io_request->refcount);
			i =3D (i + 1) % PQI_RESERVED_IO_SLOTS;
		}
	...
}

Also, is it appropriate to return SCSI_MLQUEUE_HOST_BUSY here?

This is an internal synchronous routine which normally returns standard neg=
ative
errno values (like -ERESTARTSYS or -ENXIO). Returning a positive midlayer
queuecommand status code could lead to unhandled errors or undefined behavi=
or
in the callers if the code were ever reached.

> +		goto out;
> +	}
> =20
>  	put_unaligned_le16(io_request->index,
>  		&(((struct pqi_raid_path_request *)request)->request_id));

[ ... ]

> @@ -6370,6 +6374,9 @@ static int pqi_lun_reset(struct pqi_ctrl_info *ctrl=
_info, struct pqi_scsi_dev *d
>  	struct pqi_task_management_request *request;
> =20
>  	io_request =3D pqi_alloc_io_request(ctrl_info, NULL);
> +	if (!io_request)
> +		return SCSI_MLQUEUE_HOST_BUSY;

[Severity: Medium]
Similarly, is it possible for pqi_alloc_io_request() to return NULL here?
Does returning SCSI_MLQUEUE_HOST_BUSY from this task management caller viol=
ate
standard error handling expectations?

> +
>  	io_request->io_complete_callback =3D pqi_lun_reset_complete;
>  	io_request->context =3D &wait;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817033505.7365=
19-1-triet.hoang.dev@gmail.com?part=3D1
