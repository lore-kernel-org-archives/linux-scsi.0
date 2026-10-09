Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BE6DF76
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 00:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504430; cv=none; b=WUZybS8e+8vqXUjOrVAggx7JlS2Yjd9nMYesQ1gcswFFgfgvysONSL5KiuHnTSFyRFS37fKTap7j9AYgnaYxiUVZO/hGoZM4jFppcW3SWHwttLXIbnIFCk6eBJOrDP5ZYQStvOE99OS8IiqWOL3gKY5NnhCxqGEwAjjHSXHaqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504430; c=relaxed/simple;
	bh=duakiZVhesDn2kgoOKVlmkGbn6J3FXMmXsVWX+oRqJI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=GTcSN/7ga87TdwpQbdsE+7niTDvfK5p4jXwA8XbS+HYSpALcXlhc8aPGP3YMMUvKc1AlbnYQsGkqslxjK9g/CedOGhqhvEQE43GxKpYmEDfl1JoJZGHrZLEq5jUTWv8W0Z8giFjgvrTHjXfonJfJMBYTnlOV1Oahy7YGZUVlEQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C3+TYIev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C3+TYIev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2809F1F000FF;
	Fri,  9 Oct 2026 00:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791504429;
	bh=xpGnZtqR2MZF/Gto8tKhUBqw62JpXGDRoRoWgLt/2kk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C3+TYIeveURKic5Fu4qii2hk8mitYOR7Ae/3fRG6wILLPyuRaUe7XRIMXAG/VVJ71
	 rqKHl1XSZUdcar5ZYqcpzO37giRL1cIGH6dHclS0U9TbKxuOJW934T5MiFdB9p3LSZ
	 xvvsSnhPaDvd8m3hdG78R1VX56hikvJypm3fPXKIZkMED6Y8j+Hrq3zqlxoO/AFxVp
	 W34UBGDwOXvcK+sTuMeBoZMTN9MzH12oAwGQCylm3b4HTmTWaUF+YN8AsvxtSGMILg
	 K31V4FQk/l3GGRbBzrfJcm+B4+pI+Y3U54tiDcOkBfMZBpeHrCLQPAWFiWdo1L4MF4
	 DlA5TNfQ3B35Q==
Message-ID: <sashiko-outbox-164669@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] scsi: target: rd: Release protection space on
 allocation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sanan Hasanov" <sanan.hasanou@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008235411.56641-3-sanan.hasanou@gmail.com>
References: <20261008235411.56641-1-sanan.hasanou@gmail.com>
 <20261008235411.56641-3-sanan.hasanou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 00:07:08 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] target: UAF in rd_build_prot_space() error path during concurrent =
configfs writes
--

commit d01a55deaeecc1f16dadcdc415bd1b576984c0da
Author: Sanan Hasanov <sanan.hasanov@ucf.edu>

scsi: target: rd: Release protection space on allocation failure

When rd_allocate_sgl_table() fails, rd_build_prot_space() returns the error
but leaves the partially populated sg_prot_array in place. This commit adds
a call to rd_release_prot_space() before returning the error to prevent
leaking the previous allocation.

> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core=
_rd.c
> index 97c63b12266fb..b73bdd733928e 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -263,8 +263,10 @@ static int rd_build_prot_space(struct rd_dev *rd_dev=
, int prot_length, int block
>  	rd_dev->sg_prot_count =3D sg_tables;
> =20
>  	rc =3D rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);
> -	if (rc)
> +	if (rc) {
> +		rd_release_prot_space(rd_dev);

[Severity: High]
Could this introduce a use-after-free if triggered by concurrent configfs
writes?

Looking at pi_prot_type_store() in drivers/target/target_core_configfs.c,
there appears to be no locking before checking old_prot and calling
dev->transport->init_prot(dev):

	int old_prot =3D da->pi_prot_type, ret;
	struct se_device *dev =3D da->da_dev;
	...
	da->pi_prot_type =3D flag;

	if (flag && !old_prot) {
		ret =3D dev->transport->init_prot(dev);

If multiple threads write to pi_prot_type concurrently, they can both enter
rd_build_prot_space() and concurrently overwrite the global
rd_dev->sg_prot_array pointer:

	rd_dev->sg_prot_array =3D sg_table;
	rd_dev->sg_prot_count =3D sg_tables;

	rc =3D rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);

If one thread's allocation fails, it executes this new error path which
reads rd_dev->sg_prot_array and frees it. This could free the active
scatterlist array that is currently being populated by the other racing
thread, causing a use-after-free of the scatterlist table and pages.

>  		return rc;
> +	}
> =20
>  	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
>  		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008235411.5664=
1-1-sanan.hasanou@gmail.com?part=3D2
