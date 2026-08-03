Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554A375F88
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 10:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751711; cv=none; b=ryE/XsHYelontXtkpQx0qTw76RA/YOP6s9tk9gvZ6yzulxidrVYzgBlawvjhNAywuxYkpfVtYCv6SPWYfmHqIytY13krSHuX0gDVkPr6H297Z8/jKiN7VyxwCnwRyGr3AOmJdy44QcbA+CfnpNcjjekO29hZlhsnpQmNsJ6AkLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751711; c=relaxed/simple;
	bh=kAfmD7SSAjYxLgO+QFcLmTEDDUo/JgCz1HNGptznmSo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hpdY4MBvOtzwdpeMHv6hCxGYZbE4BzW6WiB1n1Bz6Vx+rzb6zSAVgSzcR/5FtAQ8KIhVZ885us0LMH4brTCstRU70aKQCT2VK4HFyeGrFESQ2+pdE8naloe5WNMp4CLOd01OsLBIUl9Fdo/ZjRsWfcCLTjVmqoJLekNFDP6ztyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWnQi35A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWnQi35A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDB41F000E9;
	Mon,  3 Aug 2026 10:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785751709;
	bh=IW/gJCPAhqxQgfIQqhMrj8vfVk5NxIdo5I3bP/dfW58=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IWnQi35AhFBROIFIMAyTNYK53HeQAPLhPrXJ6APZLXnAeG+4hRxRIYdkspnhWTruM
	 bcihukG0OMfFqHRBYWEhGg9fp1Ks7+wAw9VwscH2OF6hq3ICNTNrn6xxoFrYdRHw6a
	 Aw079wgqCqDCkbdGSQoZZprng/zVgqxaH8IyytPjKrS9Gjk7fA5QCpmNH7yEpP9gfJ
	 hidjvJMGsUtax4efuVSyJb+wQRl3Mz3CLe9EijmfL9GkwvFCahqQDw4qYZcdRuZ1ss
	 GL0NMIhZkQAFHY8A+SlIyClyvFAWSPVsak9xcmqzbN1IbDdxzeJB142m4Oz3pMug6r
	 HuSU/Gyz2ccPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: scsi_debug: negate wrapped memcmp() result
Reply-To: sashiko-reviews@lists.linux.dev
To: raoxu <raoxu@uniontech.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <E5AD42E9C0E18633+20260803095328.3445311-1-raoxu@uniontech.com>
References: <E5AD42E9C0E18633+20260803095328.3445311-1-raoxu@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:08:28 +0000
Message-Id: <20260803100829.5EDB41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] VERIFY command with BYTCHK=3D3 bypasses vnum boundary checks, lead=
ing to an out-of-bounds read in comp_write_worker().
--

--- Patch [1]: [PATCH] scsi: scsi_debug: negate wrapped memcmp() result ---
commit d60dbbd2f90d919b4ace8e2a0080c2edd89e096f
Author: Xu Rao <raoxu@uniontech.com>

scsi: scsi_debug: negate wrapped memcmp() result
   =20
This commit fixes a logic error in comp_write_worker() where the result of
the wrapped segment memcmp() was not being negated. It ensures that equal
data correctly results in a true value, matching the behavior of the first
segment comparison.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4264,8 +4264,8 @@ static bool comp_write_worker(struct sdeb_store_inf=
o *sip, u64 lba, u32 num,
>  	if (!res)
>  		return res;
>  	if (rest)
> -		res =3D memcmp(fsp, arr + ((num - rest) * lb_size),
> -			     rest * lb_size);
> +		res =3D !memcmp(fsp, arr + ((num - rest) * lb_size),
> +			      rest * lb_size);

[Severity: High]
This isn't a bug introduced by this patch, but can this second memcmp()
perform an out-of-bounds read into unmapped vmalloc memory when triggered
from resp_verify()?

Looking at resp_verify(), when a verify command is issued and is_bytchk3
is true, a_num is hardcoded to 1 before checking the device access
boundaries:

drivers/scsi/scsi_debug.c:resp_verify() {
    ...
    a_num =3D is_bytchk3 ? 1 : vnum;
    /* Treat following check like one for read (i.e. no write) access */
    ret =3D check_device_access_params(scp, lba, a_num, false);
    ...
}

Because check_device_access_params() validates a_num rather than vnum, a
large vnum can completely bypass the sdebug_store_sectors limit. If
scsi_debug is loaded with a small dev_size_mb (e.g. 1), a vnum up to 8192
can still pass the kcalloc() allocation.

When comp_write_worker() later calculates the remainder:

    if (block + num > store_blks)
        rest =3D block + num - store_blks;

If num (which comes from vnum) exceeds store_blks, rest will also exceed
store_blks. This would cause the memcmp() operation here to read
rest * lb_size bytes from fsp, crossing into unmapped vmalloc guard pages
and potentially causing an oops.

>  	if (!res)
>  		return res;
>  	if (compare_only)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/E5AD42E9C0E18633+20=
260803095328.3445311-1-raoxu@uniontech.com?part=3D1
