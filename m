Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B8D48E0D3
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383300; cv=none; b=m3a8476TooLcTbH+GVP8HPw3XzXJD0fiDTjHVDbWJFBK/bbNYR8/03y0DCZe791L/tPqv2JmhKdOnsoWINlbIHknvjFuwX2sMdifRt2PJMhbGGz1jg2dOIz60apx1Klspyb7eVUVo6LfwRDs4MXFawC1gJ00iTWtZR129bqzvvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383300; c=relaxed/simple;
	bh=Ip8b3uc+3E/zrlsxAlKaXFd6n4IWBSVmZBOoxbzix4Q=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=kwhjgqr+0YMm4QIhcSQyIg7u53oJkihf/OcEhhgwKpaJUC8YDjafTBXH4UpTKpYtxZU1r+xCIq+oQezKsY4L3akJCx4TE22ATPGvo5jkfYTB0RKX8ULmfTghyNjo4kQQrrCMiY5ltmdVJhpkEBY867sjooees+X/aYJLcxxzBeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jANdlHm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jANdlHm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47911F0089B;
	Wed,  7 Oct 2026 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791383297;
	bh=dcFhi5e5+fSwvlJQnqMenlvutDUmh0njUVTIgKyl2yQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jANdlHm6elYjCGsPAU/y7pda9FuohDifoBsYiW2YeDH1LTy6D7uy3KvZXg1B+LUQ+
	 gL8ovsZyjFFGznJfAv1JrmtDDYWY4OKITW9dgcHexK515qOKp+nqynLGJuWiVYbAyd
	 Nr4070WWvEq7xZ+0EoLVslWGCbRwUxRo0y0vKxQbYUoikPHNc1Jj9RWsxOeMYpnSKL
	 l8+uPTnulz6350sB53NiIbTQ2oHPwy3Sw+NAEaHRAEJQ0AbNpbokLlVeE+IL8PLp2Y
	 yyqOW+HXp9HvvdHlhUXsUxEpqHiN2OL/01B4VrLRRvpE/5JSpZiPPvrLPXDlZXNPOE
	 GVCvaQa+DSlHw==
Message-ID: <sashiko-outbox-163098@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: Fix debugfs setup error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lei Chen" <lei.chen@smartx.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007141753.416672-1-lei.chen@smartx.com>
References: <20261007141753.416672-1-lei.chen@smartx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 14:28:16 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: megaraid_sas: debugfs API violation by checking return values=
 and logging errors
--

commit 3a04787b7089e752e49721091a64cf2824d3811c
Author: Lei Chen <lei.chen@smartx.com>

scsi: megaraid_sas: Fix debugfs setup error handling

This commit updates the debugfs setup in megaraid_sas to handle error
pointers by adding IS_ERR_OR_NULL checks. It also ensures that the
per-adapter directory is cleaned up and its pointer cleared if the raidmap
file creation fails.

> diff --git a/drivers/scsi/megaraid/megaraid_sas_debugfs.c b/drivers/scsi/=
megaraid/megaraid_sas_debugfs.c
> index 81698cd83f5ae..556e01fc25e8e 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_debugfs.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
> @@ -126,13 +126,16 @@ megasas_setup_debugfs(struct megasas_instance *inst=
ance)

[ ... ]

>  		if (!instance->debugfs_root) {
>  			instance->debugfs_root =3D
>  				debugfs_create_dir(name, megasas_debugfs_root);
> -			if (!instance->debugfs_root) {
> +			if (IS_ERR_OR_NULL(instance->debugfs_root)) {
>  				dev_err(&instance->pdev->dev,
>  					"Cannot create per adapter debugfs directory\n");

[Severity: Low]
Does this violate the debugfs API guidelines?

The debugfs guidelines recommend that drivers should not check the return
values of debugfs_create_*() functions.

If debugfs fails, such as due to memory constraints or runtime parameters,
these IS_ERR_OR_NULL() checks in megasas_setup_debugfs() will evaluate to
true and print a dev_err to the kernel log, creating spurious error logs
and adding unnecessary error-handling complexity.

>  				return;
> @@ -144,10 +147,11 @@ megasas_setup_debugfs(struct megasas_instance *inst=
ance)
>  			debugfs_create_file(name, S_IRUGO,
>  					    instance->debugfs_root, instance,
>  					    &megasas_debugfs_raidmap_fops);
> -		if (!instance->raidmap_dump) {
> +		if (IS_ERR_OR_NULL(instance->raidmap_dump)) {
>  			dev_err(&instance->pdev->dev,
>  				"Cannot create raidmap debugfs file\n");

[Severity: Low]
Could this be simplified by removing the error check entirely?

Similar to the directory creation above, checking the return value of
debugfs_create_file() here in megasas_setup_debugfs() is generally
discouraged. Removing these checks completely might align better with the
subsystem guidelines.

>  			debugfs_remove(instance->debugfs_root);
> +			instance->debugfs_root =3D NULL;
>  			return;
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007141753.4166=
72-1-lei.chen@smartx.com?part=3D1
