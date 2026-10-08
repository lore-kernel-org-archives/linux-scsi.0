Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558333CA487
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499640; cv=none; b=XGLhqtCViNH4TtVOBoy3IudjD8RKF6FvNovCtuP3Wme0W1n2Qt3hfYvmQfwmz1UAEcT8KWOqiCizCMf2gxZiyXfAZMiVo6pK/IJP3U3+DcBD6ITg3sapBnSMuqSFj0KIEAgpYzymfgaIrWwyyhzzFjP4q8UCpjmcRbTiN+aXXxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499640; c=relaxed/simple;
	bh=CsbC/kaxTLWiiTDP8e8E6nlohwEfpVp98WEaLI37meY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=NSc1u5RSfFpCVht5MO+F1PFmKv55L9j6rmmk60RSoAQ/bynr8jFfOKhP8WDcmawayh9nBKLyky9myo4sKrqPvlAV781oOBQLrXN507ydtSE1y4LOaVYyuLD8BYe6rz/FaYrF2+yFtMBxC9614zeiOXNM5bzhZgUGj9wsBlo+jpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iyIkgFc+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iyIkgFc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8F91F000FF;
	Thu,  8 Oct 2026 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791499639;
	bh=bYfjfprAdI2gKn1CXQ01k7tl2uzxqVu9Uf/PobuHyyc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iyIkgFc+Mk5QfZBuYJCxwuuPsF25GHpF/Wc8yXoamGCKp4tFPBjDHgl9tBMFX2bkU
	 GkeobaBPLep3frGNSXZWj915U/x9aDCSRfV6XMk0/H7ipeOhcMKZ1THjXy5KezgyK8
	 OtGuG+8yoyCfoDojcFUoYd5CgDqlRYxEtwIAfEdLN32hFVZz5P+PUa234p6XZR7LXI
	 /JIUsnIqtLcQ7GrTBGUc/eCryD0uXe069TNjNJN30tH+lh0LeTIsqjb42MOEpD4AMZ
	 U6oWX96YLWpc5jYt1q2wxdzBtELpAu6EfDI4L0ckPw/GVYOkN9sWHXX7zRki/V3Dtp
	 qT7WvBTLOEJBw==
Message-ID: <sashiko-outbox-164639@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: target: rd: Don't invoke the OOM killer
 for ramdisk pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sanan Hasanov" <sanan.hasanou@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008223712.49827-3-sanan.hasanou@gmail.com>
References: <20261008223712.49827-1-sanan.hasanou@gmail.com>
 <20261008223712.49827-3-sanan.hasanou@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 22:47:18 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] target: rd: memory leak in rd_build_prot_space() on allocation f=
ailure
--

commit 08e2848928f98cb3a6b575947cf8d271014c318f
Author: Sanan Hasanov <sanan.hasanov@ucf.edu>
Subject: scsi: target: rd: Don't invoke the OOM killer for ramdisk pages

This commit replaces the default memory allocation flags for ramdisk backing
pages with GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN to avoid invoking
the OOM killer. The pages are requested via alloc_pages() in
rd_allocate_sgl_table().

> diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core=
_rd.c
> index 97c63b12266fb..46698300e2063 100644
> --- a/drivers/target/target_core_rd.c
> +++ b/drivers/target/target_core_rd.c
> @@ -150,7 +150,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_de=
v, struct rd_dev_sg_table *
>  						- 1;
> =20
>  		for (j =3D 0; j < sg_per_table; j++) {
> -			pg =3D alloc_pages(GFP_KERNEL, 0);
> +			pg =3D alloc_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL |
> +					 __GFP_NOWARN, 0);
>  			if (!pg) {

[Severity: Medium]
Can this new failure path cause a regression by leaking memory in
rd_build_prot_space()?

Since this allocation uses __GFP_RETRY_MAYFAIL, it can now fail and return
-ENOMEM. When this occurs, rd_build_prot_space() propagates the error
without cleaning up the partially populated array:

drivers/target/target_core_rd.c:rd_build_prot_space() {
    ...
	rd_dev->sg_prot_array =3D sg_table;
	rd_dev->sg_prot_count =3D sg_tables;

	rc =3D rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);
	if (rc)
		return rc;
    ...
}

This propagates the error up to the configfs handler:

drivers/target/target_core_configfs.c:pi_prot_type_store() {
    ...
		ret =3D dev->transport->init_prot(dev);
		if (ret) {
			da->pi_prot_type =3D old_prot;
			da->pi_prot_verify =3D (bool) da->pi_prot_type;
			return ret;
		}
    ...
}

The configfs handler restores state and returns without explicitly calling
dev->transport->free_prot(dev) to clean up the backend.

This leaves the partially populated scatterlists and pages permanently
dangling in rd_dev->sg_prot_array. If the user retries enabling the
protection type, rd_build_prot_space() unconditionally overwrites the
rd_dev->sg_prot_array pointer with a new allocation, permanently leaking
the previously allocated memory resources.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008223712.4982=
7-1-sanan.hasanou@gmail.com?part=3D2
