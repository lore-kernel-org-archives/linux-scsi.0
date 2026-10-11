Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982023630AC
	for <linux-scsi@vger.kernel.org>; Sun, 11 Oct 2026 06:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791700659; cv=none; b=bAGDgMarwQ8x7cvJ2ALI4YCW3Hs9VZQ8uCtZQTeiwpk+J5ipd2zcs7wVNEHIO9fUFHBEeT6+2ObjKCYbpnotlJxC8w+PumEn3Ne2stgM1A9mYiGm1jgdFGzC1GWCbcKhQSX3GYEHUbNkfWFXgxotip2gh8bUHrMamDSDXjCGJ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791700659; c=relaxed/simple;
	bh=18nuR5gk73nRZodTgVV6iv0SmOMXs/8f3SMP5iM4Cus=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=MhJR6EcTnGwt3VqgTzJTgJ4IVWPgwOPqoHWsmfzaZzz61obK1ELaFQweXUxJYgFmXjpHZzBLr6mMPGlGvydpuc+z8yF4/KPoR8hZHXWynCCfnrX75WLiswN84fY7osn5JFF2tatP7Dje1nqGJeqUAID3kihkjyiIpVZ1aAa/BH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+x8lwMy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+x8lwMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B3D1F0089B;
	Sun, 11 Oct 2026 06:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791700658;
	bh=I/D+mJr1HXi2iXsc/dmQwAzxwmiVNZ1MzqGI0hUGKok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J+x8lwMyGrPf2Su93ej9QNUBq5scHHjZl7aVdIYlmj/C6fzkjY6WbbU8lPZjDgmhO
	 gsxJthrFGBdP4zsnFu4wCihqXikW4V+TB6iE2LuOzupVRhbq555ixVm/SLRG/WFY+N
	 kf33NQieIqGBu7IY1MCYpEcolszQgbef6OjVjjXabLdLTqTqsPlU36YUUZ/H8BHa0U
	 IQwz5PLycVQP1XiO5277wd/8STUKinRg4qz3N+6RSUGd0u0u+sxPbPfoBW4YHfCyX8
	 lONuK4GrFfb4W+iLvqOLT3mIT1lcaeas3+xW403A9wgtgEIyalPjZqCWy/JIODxWqe
	 VGDK4+5cez/UQ==
Message-ID: <sashiko-outbox-167068@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc6+
Reply-To: sashiko-reviews@lists.linux.dev
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <eab58e05da0087c70f5473874a549572a9ab0230.camel@HansenPartnership.com>
References: <eab58e05da0087c70f5473874a549572a9ab0230.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 06:37:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ufs: Use-After-Free of hba in ufshcd_async_scan()
- [Medium] ufs: core: Memory and PM runtime usage counter leaks on ufshcd_i=
nit() error paths
--

commit bd2cdc88010119e8efabde65d87de3311f493dc1
Author: James Bottomley <James.Bottomley@HansenPartnership.com>

    SCSI fixes for 7.3-rc6+
   =20
    Driver (and tape media changer) only fixes. Three of the fixes are about
    the same size, (ch, ufs decouble CQ and ufs avoid unsafe MMIO) but the
    unsafe MMIO is the least obvious logic change.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 54f4e7d7de02e..ca8329052cbc5 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
[ ... ]
> @@ -9556,6 +9549,7 @@ static void ufshcd_async_scan(void *data, async_coo=
kie_t cookie)
>  	ret =3D ufshcd_add_lus(hba);
> =20
>  out:
> +	ufshcd_release(hba);
>  	pm_runtime_put_sync(hba->dev);
> =20
>  	if (ret)

[Severity: High]
Can this code cause a use-after-free of the hba structure?

If a user unbinds the UFS driver or the module is unloaded immediately after
initialization (before the ufshcd_async_scan background work completes),
ufshcd_remove() executes and tears down the SCSI host without waiting for t=
he
async domain. Devres subsequently drops the final reference to the Scsi_Hos=
t,
freeing the hba structure.

When the pending ufshcd_async_scan() then executes, it dereferences the fre=
ed
hba pointer to call the newly added ufshcd_release(hba).

[ ... ]
> @@ -11392,6 +11389,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
>  	ufshcd_pm_qos_init(hba);
>  	return 0;
> =20
> +out_release:
> +	ufshcd_release(hba);
>  out_disable:
>  	hba->is_irq_enabled =3D false;
>  	ufshcd_hba_exit(hba);

[Severity: Medium]
Does this error handling path leak the SCSI host memory, block layer queues,
and the PM runtime usage counter?

Earlier in ufshcd_init(), ufshcd_add_scsi_host() allocates a SCSI host and
its associated non-devm tmf_queue and tmf_tag_set. Shortly after,
pm_runtime_get_sync(dev) increments the PM usage counter to prevent
auto-suspend.

When the initialization error paths (like ufshcd_link_startup or
ufshcd_verify_dev_init failing) jump to the newly added out_release label,
the cleanup bypasses calling scsi_remove_host(), blk_mq_destroy_queue(),
blk_mq_free_tag_set(), and pm_runtime_put_sync().

(While these omissions also existed in the old out_disable path, this patch
actively redirects execution through this defective cleanup path.)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/eab58e05da0087c70f5=
473874a549572a9ab0230.camel@HansenPartnership.com?part=3D1
