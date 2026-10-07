Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567714AD4AF
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 14:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383353; cv=none; b=No0WwXANA0kcBiKx4jZd96EfcIqfxECEQEM5bv3Ob6862GvNJ4Q9o4oZdJc/L8NCGzPLLM6E7CP0tgf0VPXFf58i4NWEWVp2eQ7Q5FGrXqfsbLNeSGZNpgP81hZC02mzsNyWBdejv677FWBnuSGWIcsQhQJ1PMwykKIdqqSPHlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383353; c=relaxed/simple;
	bh=3ocP6B/OTKPihddXM6SKJjQ42ZIsz5wpD3XfWvNGzXQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ce6ExStrUIIu+p2TM72WxEO1NQutJywL52a4LW5D1ScgrHOjJIu+fZc1G+7qpwtYuWZp240Zw1Kf5HZwzsSiTlc9748wao5nTjSB43sYR6XypJEJ1y/7S+ifHIc5bOPFbKUDk6ANnHWN3BwrM3YkWOPs3g4f8rUjjg2UN86RZo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0WthQ8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0WthQ8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926FA1F0089B;
	Wed,  7 Oct 2026 14:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791383347;
	bh=Ws5BwYpZJU6CU1xAtwGXnELyIzgtz4kRJkYi1x7KoYo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F0WthQ8uoKHiQO5AAokLdbfRzawg6h5Sv+vg5Xg/gEtMYxqaa8f5+JV80AStYP9bA
	 EkY82b9iNDMSYmyR5cdWJigMoJ2IQViCbTqQDYlbtBpyvkk6ZLXZtc1iJ6qiLAl2Ei
	 zXa/5ycz1pbMeRUD6RB+msnKtRFACsW34FsSZ4CtpeBUs/YGWGdoGBEnfgqu2O6JDF
	 c1rXjD2gxjCPNfSGkahT4IYvfb7di5r41v2i6TeuO65Gse48XQFiuSbeDya52JGgkR
	 Wg0qUieDj9+nN2WP5j/U95ucqC/TzuN3sOg2jYr/+zWip7RWkmz7GxsGaZ5VjmLV8o
	 4JUPO7DIEiMGA==
Message-ID: <sashiko-outbox-163100@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix debugfs setup error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lei Chen" <lei.chen@smartx.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007141951.417155-1-lei.chen@smartx.com>
References: <20261007141951.417155-1-lei.chen@smartx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 14:29:07 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: mpt3sas: anti-pattern of checking debugfs return values
--

commit eaeb8348b8dd28fc3959554ee1eef029613c7292
Author: Lei Chen <lei.chen@smartx.com>
scsi: mpt3sas: Fix debugfs setup error handling

This commit modifies mpt3sas_setup_debugfs() to check for error pointers
using IS_ERR_OR_NULL() instead of just checking for NULL when creating
debugfs entries, and ensures the parent directory is cleared if file
creation fails.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sa=
s/mpt3sas_debugfs.c
> index 183391f6b8d19..edaeccf538f40 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
[ ... ]
> @@ -120,11 +120,14 @@ mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc)
>  {
>  	char name[64];
> =20
> +	if (IS_ERR_OR_NULL(mpt3sas_debugfs_root))
> +		return;
> +
>  	snprintf(name, sizeof(name), "scsi_host%d", ioc->shost->host_no);
>  	if (!ioc->debugfs_root) {
>  		ioc->debugfs_root =3D
>  		    debugfs_create_dir(name, mpt3sas_debugfs_root);
> -		if (!ioc->debugfs_root) {
> +		if (IS_ERR_OR_NULL(ioc->debugfs_root)) {

[Severity: Low]
Is it necessary to check the return value of debugfs_create_dir() in
mpt3sas_setup_debugfs() here?=20

The kernel's established policy is that drivers should never check the
return values of debugfs creation functions. Since debugfs safely handles
its own failures and downstream calls accept error pointers seamlessly,
would it be better to remove these checks entirely instead of updating them?

>  			dev_err(&ioc->pdev->dev,
>  			    "Cannot create per adapter debugfs directory\n");
>  			return;
>  		}
>  	}
> =20
>  	snprintf(name, sizeof(name), "ioc_dump");
>  	ioc->ioc_dump =3D	debugfs_create_file(name, 0444,
>  	    ioc->debugfs_root, ioc, &mpt3sas_debugfs_iocdump_fops);
> -	if (!ioc->ioc_dump) {
> +	if (IS_ERR_OR_NULL(ioc->ioc_dump)) {

[Severity: Low]
Does mpt3sas_setup_debugfs() need to manually handle the error and roll
back the parent directory when debugfs_create_file() fails?

Expanding this manual error path appears to conflict with the intended
fire-and-forget design of debugfs. The appropriate fix for flawed pointer
checks in debugfs setup is usually to remove them entirely, rather than
updating them to use IS_ERR_OR_NULL() and adding manual cleanup.

>  		dev_err(&ioc->pdev->dev,
>  		    "Cannot create ioc_dump debugfs file\n");
>  		debugfs_remove(ioc->debugfs_root);
> +		ioc->debugfs_root =3D NULL;
>  		return;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007141951.4171=
55-1-lei.chen@smartx.com?part=3D1
