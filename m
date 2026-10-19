Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6E948F845
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 07:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792396316; cv=none; b=oSDAW9wR8sjGQy+vnEgCZzipTd2P1A9mLIiuO1axJSV3txlvqegvWm4yNwDNFN/cmySjZwNgFCsZEZvVY2KTAmLrDPs7uI4BDrTK2Vow9z8bU15E94zFB8AiedOF6Q2lhnnjWplF+KJ0LFO9l9RCTFFR4NreqkHGtxt4SNThQmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792396316; c=relaxed/simple;
	bh=ydVwLPa3iiKJyDGsdcq/2jHPfQXbgUfWCoGxJSRN6Js=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=N/YbYBBMUkS0RRIQDEG9sQyv35F7St6T0iAdTkDrBuaVtZkSp5v+gbdpLofdTqFFyA0kPrWjDT6mum5UMXKyHIjOxtFjLBr6w0rTSFAsDizYlT4HAq0b3xspIHCX1Wyys4p10TPbwvvpq+wsPWHELfOzRMj+K3L2way4JdMxPZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E9zPy97z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E9zPy97z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2FF1F000C4;
	Mon, 19 Oct 2026 07:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792396313;
	bh=ndqrh8sL6vhrnmqIvOSx1r4QxkQQP98pHToGYVWfJzg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E9zPy97zxSwVS0s7xzqSgTz6BlzHfsLhKyxlaNhQ+P44raRCv5fQYbroWwLSfGaD0
	 /0PGTbtrVxpRpfQbqmF2lhtQ7bwnDmhAa2eWN/le8CkE3UIAKUbUynCHDneWnaY+7h
	 dI/bTLnXd7YVizXA3o7jiScRT3eRxbKOLqQYjvc0KNnbd+B+RnmwZi2rsnIW8GdpkI
	 KWczQca8pITHbCdq4UO8Nj5PJ6ka51nUYGikgv8syUoppkuGNkXzhtHor4HhArOU67
	 6Ez8wmTzSZ1lAjq0+eyy4C17IoMAolvWCB6RKE8JLPMDbkMrFbbyOnn+djWkCTGKxV
	 rt0PzCdSUi6mA==
Message-ID: <sashiko-outbox-176762@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC] scsi: handling negative CDROM_SEND_PACKET timeouts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wang Yingjie" <x-professor@outlook.com>
Cc: =?utf-8?b?bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc=?= <linux-scsi@vger.kernel.org>
In-Reply-To: <20261019.cdrom-timeout.13a6f4a2f552@outlook.com>
References: <20261019.cdrom-timeout.13a6f4a2f552@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 07:51:53 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: scsi_cdrom_send_packet() rejects negative timeouts with -EIN=
VAL
- [Medium] scsi: signed int overflow of cgc.timeout in scsi_cdrom_send_pack=
et()
--

commit aceed06c50fb78815344c356d7d655b72431529e
Author: Wang Yingjie <x-professor@outlook.com>

scsi: handling negative CDROM_SEND_PACKET timeouts

This commit rejects negative cgc.timeout values in scsi_cdrom_send_packet()
with -EINVAL before passing the timeout to clock_t_to_jiffies().

> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index 122403ec3ab8d..c615bb1e39614 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -806,6 +806,8 @@ static int scsi_cdrom_send_packet(struct scsi_device =
*sdev, bool open_for_write,
>  	err =3D scsi_get_cdrom_generic_arg(&cgc, arg);
>  	if (err)
>  		return err;
> +	if (cgc.timeout < 0)
> +		return -EINVAL;

[Severity: High]
Could returning -EINVAL for negative cgc.timeout values cause a userspace
regression for callers (such as libcdio via mmc_run_cmd() and
run_mmc_cmd_linux()) that pass -1 to select the default command timeout?

When userspace invokes ioctl(fd, CDROM_SEND_PACKET, &cgc), sr_block_ioctl()
calls cdrom_ioctl() (which returns -ENOSYS) and then falls back to
scsi_ioctl() -> scsi_cdrom_send_packet(). Previously, negative cgc.timeout
values were not rejected and commands completed normally.

In drivers/scsi/scsi_ioctl.c, scsi_fill_sghdr_rq() already maps a zero
hdr->timeout to the device's default timeout:

drivers/scsi/scsi_ioctl.c:scsi_fill_sghdr_rq() {
	...
	rq->timeout =3D msecs_to_jiffies(hdr->timeout);
	if (!rq->timeout)
		rq->timeout =3D sdev->sg_timeout;
	if (!rq->timeout)
		rq->timeout =3D BLK_DEFAULT_SG_TIMEOUT;
	...
}

Similarly, sr_packet() in drivers/scsi/sr.c maps non-positive timeouts to a
default timeout rather than failing:

drivers/scsi/sr.c:sr_packet() {
	...
	if (cgc->timeout <=3D 0)
		cgc->timeout =3D IOCTL_TIMEOUT;
	...
}

Would clamping negative cgc.timeout values to 0 (or only converting positive
cgc.timeout values with clock_t_to_jiffies()) avoid the unsigned conversion
into a 49.7-day timeout while preserving compatibility with callers passing
-1?

> =20
>  	cgc.timeout =3D clock_t_to_jiffies(cgc.timeout);
>  	memset(&hdr, 0, sizeof(hdr));

[Severity: Medium]
What happens here when a positive cgc.timeout is large enough that
clock_t_to_jiffies(cgc.timeout) exceeds INT_MAX on configurations where
HZ > USER_HZ (for example, cgc.timeout >=3D 214748365 when HZ=3D1000 and
USER_HZ=3D100)?

Because cgc.timeout is a 32-bit signed int, storing the unsigned long return
value of clock_t_to_jiffies() back into cgc.timeout overflows and truncates
the value.

Later in scsi_cdrom_send_packet():

	hdr.timeout =3D jiffies_to_msecs(cgc.timeout);
	...
	if (scsi_put_cdrom_generic_arg(&cgc, arg))
		return -EFAULT;

Depending on bit 31 of the truncated 32-bit value, cgc.timeout can wrap to a
negative int (which sign-extends to unsigned long in jiffies_to_msecs(),
hits the (int)m < 0 check in __msecs_to_jiffies() to produce the same
4294967294-jiffy rq->timeout, and gets copied back to userspace as a negati=
ve
timeout by scsi_put_cdrom_generic_arg()), or wrap modulo 2^32 to a tiny
positive timeout (for example, cgc.timeout =3D 429496730 truncates to 4
jiffies).

Should the jiffies value be held in an unsigned long or clamped before
converting to milliseconds instead of being stored back into the signed int
cgc.timeout?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019.cdrom-time=
out.13a6f4a2f552@outlook.com?part=3D1
