Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429DB386440
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783078942; cv=none; b=iH27F/K3bcKSoY4slOOL/At3wPzYeQSPbnJyzNOqmM+dX1uyGt/teRS99wOzvIZ6IYPVWWsG12MdH3/bkjvU+j5iNis76j+n1Blc1idLe/a1YLaOtyiNnwhy3RbV9dFzGgOa6zOWOFeWS7UGMzSupU+GAHsTPukgT+ljDPyTyrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783078942; c=relaxed/simple;
	bh=LfQKv78NwcWyhK5Yurw19RGdv9SG0JjB8mTtw8hGCk0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tzngEH/TCuNt5LakgZn9rGNhCfBRrGH56UeO4qCyvvhKH/wYsfrulXqqu2oqON9od0lWUV+1wx1niVusHqgEZ3gkgsu/V7hGrLxQ/LFWNy5mUQhCCuBUDTrDmEEuNChnRAnRjPgH2suQPWkGws/+jq5hOl/Xt0Ii4DOVohgw16A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ubeae/8c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ubeae/8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56E01F000E9;
	Fri,  3 Jul 2026 11:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783078940;
	bh=soVM2wfBLWuubQIVT5vB0V8D/vu51HzOoQ5Ol2Lvlkg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ubeae/8c9T91vx5RHdQJIjXgM4P4gPwUGjVHw+iF7wZaq2u/Tg4Nk60IVXpOVGw7g
	 g8iYHE704DY/Gygwh3KoC9wY8AJWdnndLfTPrLRj73vRfJBlFy76kFNV/XSF3gRiVh
	 GuBVBGjdVQm6hrAtO/laMnbSVlMjbtohPCMBTHADlyk6PBxODJsrV8Fd0XsTG0T/n3
	 CWyZ1105zXzL0pxEdHJdL+PvcR9JMhlO3Spjea1J+iIxUlKYRdMUz9fhw3TtJI8Vvi
	 BT61ZKJUNJ/8pulhm3HA2Od57menmI0xoEE3mE6W6qxNp6usK5nUhNQEW3GfmOObaC
	 Xc/6D9esLasFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/10] nvme-multipath: add uring_cmd support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-7-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:42:20 +0000
Message-Id: <20260703114220.B56E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Polling thread accesses a freed request if it completes asynchrono=
usly via a timeout or abortion.
--

commit 26f589fad741b01889fb3c28f4f60f8b1eb60783
Author: John Garry <john.g.garry@oracle.com>

nvme-multipath: add uring_cmd support

This commit adds uring_cmd support to NVMe multipath devices by introducing
the nvme_mpath_chr_uring_cmd callback. It also wires up the existing
nvme_ns_chr_uring_cmd_iopoll for io_uring polling.

> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 9a1703f01ef60..b27b45c59c883 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
[ ... ]
> @@ -1554,4 +1554,6 @@ static const struct mpath_head_template mpdt =3D {
>  	.cdev_ioctl =3D nvme_mpath_cdev_ioctl,
>  	.ioctl_begin =3D nvme_mpath_ioctl_begin,
>  	.ioctl_finish =3D nvme_mpath_ioctl_finish,
> +	.chr_uring_cmd =3D nvme_mpath_chr_uring_cmd,
> +	.chr_uring_cmd_iopoll =3D nvme_ns_chr_uring_cmd_iopoll,

[Severity: High]
This is a pre-existing issue, but does assigning nvme_ns_chr_uring_cmd_iopo=
ll()
here expose a use-after-free for multipath devices if a command times out?

Looking at nvme_uring_cmd_end_io(), if a command completes asynchronously
or times out, the handler frees the request by returning RQ_END_IO_FREE,
but it appears to leave pdu->req set:

nvme_uring_cmd_end_io() {
    ...
    } else {
        io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
    }
    return RQ_END_IO_FREE;
}

Since pdu->req isn't cleared, if the polling thread continues to spin in
nvme_ns_chr_uring_cmd_iopoll(), won't it dereference the freed request?

nvme_ns_chr_uring_cmd_iopoll() {
    ...
    struct request *req =3D pdu->req;

    if (req && blk_rq_is_poll(req))
        return blk_rq_poll(req, iob, poll_flags);
    ...
}

>  };

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D6
