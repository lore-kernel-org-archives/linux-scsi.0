Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321B026982C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785452514; cv=none; b=o00AZTJAmoAsH01zBEKGFICBCSdxzjVld1zXR9mZ719WBNU9qlSmbZnl11HvWChjlywXZyiaAO9AJt6VLA8rUifz2/1z9juGZiWa0fg+7HmQdzUgisT5BOoy07KQtvQmtmT+01w2vAVd7UU4mekPutSjCwfGGVqCUFi32F3SKrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785452514; c=relaxed/simple;
	bh=IZ3nYiD7gN/fxUlZpX/12smWXD1zQSVOT5pne1iD144=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EKBxcJZCJxvbIb+7MxPIH3Msn6Z0CZ+lN1Mjb2gwI2SsYHloE8BZiQXpVzUnm/hPSw0FIvL5Jdi/XNaQdRMxXVInR/P4AmEvvSWQBp8PXenH/L837dJvhAHvdwNmoT7T5O57EOE+qvnE+hno5mCkThQ+NaGA3oOJ25v2Wg1a454=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iT5AjmG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iT5AjmG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A97A1F00A3A;
	Thu, 30 Jul 2026 23:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785452511;
	bh=lEy48qWpbQuaKCkbDLdTCQU0augB4HQgXsTMWfQ7vHg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iT5AjmG57d0s0Tc+TGqryBT34SsCyKRVnvB5Xr1QZzY2+cbqfTTPZhQxagJbY4B72
	 Yr6fvfSY+tXLBk+dE8u59JwDAFHOIo0cYJQTFdjZ60/mOMVU61SzuarbJXYfdRrXTK
	 HV9/HJGI6RH4rIUVTZbTZrUrIQ/5bvNwiXkZSlXSS2Q6SooDZGOch7ugXjloLoODLs
	 qYpMChyJbrG6v0IxFW42CY0xwuywrwzC6255XUg+B88k7rk/bJEFwDRtf+CjlGI9fE
	 yjF3EVEzoYX+RDqCATZL3lysGAj2TqfVyrxF8wO1Yf0lTaKxEVtRIFNzdd9jt3V37m
	 sLTzk/zv2vEcQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/57] scsi: scsi_debug: Prepare for enabling lock
 context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <02c833ea2e87c7fd3f2a8490f302cfa7383647a4.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <02c833ea2e87c7fd3f2a8490f302cfa7383647a4.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:01:51 +0000
Message-Id: <20260730230151.9A97A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] The `__context_unsafe(conditional locking)` annotation was appli=
ed to `resp_write_same` but missed on `resp_read_dt0` and `resp_write_dt0`,=
 which use identical conditional locking logic.

Pre-existing issues:
- [High] The function `resp_write_same()` leaks a write lock on the data lo=
ck (`sip->macc_data_lck`) when `fetch_to_dev_buffer()` fails.
- [High] AB-BA deadlock between `sip->macc_meta_lck` and `sip->macc_data_lc=
k` due to inconsistent lock acquisition order.
--

--- Patch [2]: [PATCH v3 02/57] scsi: scsi_debug: Prepare for enabling lock=
 context analysis ---
commit ad9c0fb7632790d874892a1d6261443b39766d7d
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Prepare for enabling lock context analysis

Suppress lock context analysis for the functions that perform conditional
locking to prevent that the Clang thread-safety analyzer complains about
these functions. Remove incorrect __acquire() and __release() annotations.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4a08f0cfae08d..cb6663e24c225 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -5193,6 +5185,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
> =20
>  static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>  			   u32 ei_lba, bool unmap, bool ndob)
> +	__context_unsafe(conditional locking)
>  {
>  	struct scsi_device *sdp =3D scp->device;
>  	struct sdebug_dev_info *devip =3D (struct sdebug_dev_info *)sdp->hostda=
ta;

[Severity: Medium]
Should drivers/scsi/scsi_debug.c:resp_read_dt0() and resp_write_dt0() also
get this annotation?

They appear to use the same conditional locking pattern with
meta_data_locked, conditionally acquiring sip->macc_meta_lck.

[Severity: High]
This is a pre-existing issue, but does drivers/scsi/scsi_debug.c:resp_write=
_same()
leak the sip->macc_data_lck write lock when fetch_to_dev_buffer() fails?

If fetch_to_dev_buffer() returns -1, the code jumps to the out label:

	sdeb_data_write_lock(sip);
	if (ndob) {
		memset(fs1p, 0, lb_size);
		ret =3D 0;
	} else
		ret =3D fetch_to_dev_buffer(scp, fs1p, lb_size);

	if (-1 =3D=3D ret) {
		ret =3D DID_ERROR << 16;
		goto out;
	}

But the out label only unlocks sip->macc_meta_lck and skips
sdeb_data_write_unlock():

out:
	if (meta_data_locked)
		sdeb_meta_write_unlock(sip);
	return ret;

[Severity: High]
This is also a pre-existing issue, but could drivers/scsi/scsi_debug.c:resp=
_write_same()
cause a lock ordering deadlock with resp_comp_write()?

In resp_write_same(), the meta lock is acquired first, followed by the
data lock:

	if (sdebug_dev_is_zoned(devip) || scsi_debug_lbp()) {
		sdeb_meta_write_lock(sip);
		meta_data_locked =3D true;
	}
...
	sdeb_data_write_lock(sip);

However, in resp_comp_write(), the acquisition order is reversed:

	sdeb_data_write_lock(sip);
	sdeb_meta_write_lock(sip);

Could this lead to a deadlock if a compare and write command and a write sa=
me
command are processed concurrently on the same store?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D2
