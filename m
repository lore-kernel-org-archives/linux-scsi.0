Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689C37B00F
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2026 20:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781728956; cv=none; b=H7nVpSnnSWHZYWwn0HRKZX5fnhd67GMiPyW6Scjbq6oPgc1yUbUTn/BvI3lob+2tzz8qoncf1h5miG6Sg0DjCmhhBU+1kPlOn34mw34V1SiumQs2UHLsfiYJec8pNDmtqvouB073V1DEwPSBeqAoOYwgGrqEr3kxYtzHL861mFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781728956; c=relaxed/simple;
	bh=kENAXadv86qFMqWkmBJnb5oLuXGaC3DT2Yt7dBJUZjE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SF8zcsmmNXHcMZ3qKag4n29xh4ML1ct0A5OH3SO8pYDKIgOy1DgvqU8nTJnEBBT4kyvnatG3hXzfSHESRDQ/e3Q7PdXiUxoWpV+DM05o+C2roOa10e3NXhXAE2XUU5cFalxlJYM1JEAJd+QVq3lP4JYw69QDK5xxHtcbILl2H0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEBRXJW0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEBRXJW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1E31F00A3D;
	Wed, 17 Jun 2026 20:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781728954;
	bh=KMdggn6B1n7BYkYBku/htTK7gUDz+vPK+ysWDwpYoek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GEBRXJW0nkRkQBI7c9m+ZWEruTOCSPQAMat/17KSfzl7z+nXiDQviuvXnNkm8PAs1
	 TH7nzxX4/SMp/SnTcYDTFpjwO42/kBULRWMeI930aOoxgwCM3pgO1byGCxKuhF3jXY
	 4QoWIEsnekkhvPy9FQvQglW2MCGIemqu1lvnqIZzHq14FoYwnic4ygfy2X28gOBTYF
	 Px0/9KnvF29gSaP/xEgxoW5ZbfKGSHDISkDYew9PatDbkT2cp7697gYd5WPy8S0kNB
	 BCiHoxHusMO04zN/IFZM2XY0ktInebCHzwse7BGBI2ZGk13dnG9w6/lvFPPc1B4mA8
	 /6Mw6LukFsbqQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: message: fusion: Use more common error handling
 code in mpt_attach()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Markus Elfring" <Markus.Elfring@web.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <645f850d-bd48-4c72-97e4-5771e247de8f@web.de>
References: <645f850d-bd48-4c72-97e4-5771e247de8f@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 20:42:33 +0000
Message-Id: <20260617204234.3E1E31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Data race on global `ioc_list` and static `mpt_ids` variables duri=
ng concurrent device probing.
- [High] DMA memory leak on device initialization failure.
--

commit 4e8cbd0babcc92bd561c86ab647d8b47fc357dc0
Author: Markus Elfring <elfring@users.sourceforge.net>

scsi: message: fusion: Use more common error handling code in mpt_attach()

Use an existing label once more so that a bit of exception handling can be
better reused at the end of this function implementation.

> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mp=
tbase.c
> index 3a431ffd3e2eb..c2c5a25cf5aec 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -2014,9 +2014,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_d=
evice_id *id)
> =20
>  		destroy_workqueue(ioc->reset_work_q);
>  		ioc->reset_work_q =3D NULL;
> -
> -		kfree(ioc);
> -		return r;
> +		goto out_free_ioc;

[Severity: High]
This isn't a bug introduced by this patch, but does this error path
permanently leak DMA memory?

If mpt_do_ioc_recovery() fails, it bails out to this error path that cleans
up some resources before jumping to out_free_ioc to free the ioc struct.

However, mpt_do_ioc_recovery() internally calls PrimeIocFifos(), which
allocates large DMA coherent buffers (saved in ioc->alloc and
ioc->sense_buf_pool). Because mpt_adapter_disable(ioc) or
mpt_adapter_dispose(ioc) is never called on this error path, these DMA
allocations appear to be leaked.

[Severity: High]
This is a pre-existing issue, but is there a data race when modifying global
variables during concurrent device probing?

The mpt_attach() function is called during PCI device probing. The Linux
driver core does not serialize probe routines across different devices; it
only holds a per-device lock. If multiple MPT controllers are bound
concurrently (e.g., via concurrent sysfs bind writes), multiple threads
could modify the static mpt_ids counter and append to the global ioc_list
simultaneously without synchronization:

mpt_attach() {
    ...
    ioc->id =3D mpt_ids++;
    ...
    list_add_tail(&ioc->list, &ioc_list);
    ...
}

Could this lead to list corruption and kernel crashes?

>  	}
> =20
>  	/* call per device driver probe entry point */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/645f850d-bd48-4c72-=
97e4-5771e247de8f@web.de?part=3D1
