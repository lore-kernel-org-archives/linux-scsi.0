Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C163E3D9DA0
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785342420; cv=none; b=pepgRezfCoD5iMiFYEjiivrzd5D02C1h6yP9INArrTgmhisEnDxNNbGZEiaJqcB6cX76U4cMry2ItHU3jasA0+7JOz2uETNa9G4LN0FHKAenY5vcT0015WM+SOjTY9n3UXOCKHZet+oS7WH36r3kAk8vZX3697J/2QozIBfKHDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785342420; c=relaxed/simple;
	bh=SIglhkusSJDhQ+EImpY7HwdHChBsaXfSYYKlxK7Si7w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tFf0luIVnwFnnGnJwz6PUuPdVAuI1rNGwzXaxPjcaazgA4LiBqIWyJV4kxeSO6X6SUzjOUF8yFtPd4iYyzDwDdKl+uDZ6/ya/uin4wyutfY4fB/mhTpltYespr83EuEXjk9lCowCgKkHnuC0PREPQObIG3LfSaO0G3f6j4kSnLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eV4WNjjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eV4WNjjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D77F1F000E9;
	Wed, 29 Jul 2026 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785342419;
	bh=MpWnsxujuoiKaLfp9ALjZSEzG6lmCAdWijQ/LavCerQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eV4WNjjR9fzW+faXlYOE2m/qVwJS59Fx1yCs875kZH3L2Ne1lgLSIAFL3OLb97t8F
	 SGDj7My09lFi2B+qYZCRwY2ryoKspVqaoD3NWCdw40U0dDwFpuoH3ByhV0gjiI4CMo
	 y7C7oz7X6obfwC9HLEbK7pb4FzG2pzEsc1cd8N54VapL9kvvSyt7JoSk9UwNeMEcHT
	 0XPVt6MQKCX3NU8te0S7GvJrHPI60Tl79+/vtMGVVazvknYe+WdBkDcrDdgbCcEK/A
	 nSEuFAbNxJ40NUwRKuSc8z5uAH9DBYHlXGnT8BnCEXRz4bfOUIOh5/WjxBCo9V781A
	 zxabahUnKSRmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 21/27] scsi-multipath: add delayed disk removal
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-22-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-22-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 16:26:59 +0000
Message-Id: <20260729162659.7D77F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The unchecked return value of `scsi_mpath_get_head()` in `scsi_mpa=
th_remove_head_work()` can lead to a Use-After-Free (UAF) and double-free.
--

--- Patch [21]: [PATCH v6 21/27] scsi-multipath: add delayed disk removal s=
upport ---
commit 10f5e133107a91a4b4df48e21559fe51a6b82a5e
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: add delayed disk removal support

This commit adds core code support for delayed disk removal, introducing a
worker function that iterates over the scsi_bus_type to invoke a newly
added mpath_remove_head callback. It also attempts to manage reference
counting for scsi_mpath_head during this removal process.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 0adc5adb4b234..a42e20d33e422 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
[ ... ]
> @@ -367,7 +367,34 @@ static bool scsi_mpath_available_path(struct mpath_d=
evice *mpath_device)
> +static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =3D to_scsi_mpath_head(mpath_he=
ad);
> +
> +	/*
> +	 * scsi_mpath_remove_head_drv() could drop the final reference to
> +	 * scsi_mpath_head, meaning that we pass a free'd pointer further
> +	 * drivers - take a reference so that won't happen.
> +	 */
> +	scsi_mpath_get_head(scsi_mpath_head);
> +	bus_for_each_drv(&scsi_bus_type, NULL, scsi_mpath_head,
> +		scsi_mpath_remove_head_drv);
> +	scsi_mpath_put_head(scsi_mpath_head);
> +}

[Severity: High]
Can ignoring the return value of scsi_mpath_get_head() cause a use-after-fr=
ee
regression?

Looking at scsi_mpath_get_head(), it uses kref_get_unless_zero() which can
fail and return -ENXIO. If the reference count drops to zero concurrently
just before scsi_mpath_get_head() is called, the acquisition will fail.

By proceeding unconditionally when it fails, bus_for_each_drv() could
operate on an already freed scsi_mpath_head pointer.

Furthermore, scsi_mpath_put_head() would then invoke kref_put() on an
object that had a zero reference count, causing a double-free regression.

Should this code check the return value of scsi_mpath_get_head() and exit
early if the reference could not be acquired?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D21
