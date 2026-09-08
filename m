Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973583B6352;
	Tue,  8 Sep 2026 20:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900160; cv=none; b=ky6HGvdHHrg/mD4w3JfvqAggL0o4Xj1ruM0J+ilKeAVAW0BSHB14AE2Pmtzr7MEuU60WlMDSW7dY1ggvEQdzCkv+gIs5EimC/8w4qobuck0tTXBoCDagIt1wNvZd+Ocf1ycWCUEwmr7Lg1sj5mrcscjHJ2XBwX0YBSBrrCfERaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900160; c=relaxed/simple;
	bh=LsyKPiMUDHq1U73pA5tQXUXslbPrTQrKiHltsHUod3I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=i1oatmLm/Azy1azzvZxknfKFOUAkaJZ23w/ksgAb5MQVGAbg05jiCJmxpJsN9HKioNkk+ITT/J7z2agR4cNvRLoHh7Z2jL9WECwLVS1wHmaxxyxgQHxDfS5MShEz4r1f49zCjPTWfSWHpZGxPY9UexGF4iRrIt9uFvkRkLLz6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxRd+Fdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxRd+Fdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BEF1F00A3A;
	Tue,  8 Sep 2026 20:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900159;
	bh=ETJ4Djg5bofgWaCi5hHewz86P/RVyCsx8I4gSoD+EXU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LxRd+Fdyp7XWo0cNipI2m7tQL/tsgUWNkHmrbcWwaflpirjph08CT6gqLi2d+BR83
	 ulxO3fbv1OJOiY6tdYltq66I52Hx9jcKRTgIitXjBNphvHa59/5K2SdS1HTA3NZImo
	 wqG7PVTjCseSemjpe4Rswx+l2V+oYSAIdTmEBJJ1tnO+dyNzambPYt4Ri+7FUNYdYR
	 8O0A4smTVIKJu2TsV/PpxkAq4MvAdyDfLqVLL4khvdNAQ8L0ECeyLc0gH+6bXQvT/y
	 AzagAIk75XbBcIdS/bmWHsYuC81g2l94EiSpG4qyXUMefR8RK5Qvy/P8qjdRsUMlBd
	 WZjeGAhXZIaRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/39] mm/vma: predicate setting mmap_prepare VMA fields
 on new vma alloc
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-1-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-1-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:42:38 +0000
Message-Id: <20260908204238.E2BEF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] File reference leak when a file is swapped during mmap_prepare and=
 the mapping is subsequently merged.
- [High] File reference leak in call_mmap_prepare() error paths when valida=
tion fails after file replacement.
--

commit 8df6960e843adc0f8e640f756781ceaed05911b5
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc

This commit ensures that VMA fields are only manipulated if a new VMA is
allocated, rather than merged, as VMA merging preserves existing fields.
It also constifies have_mmap_prepare.

> diff --git a/mm/vma.c b/mm/vma.c
> index 97567fb7ef33d..2a90c509bb312 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
[ ... ]
> @@ -2909,7 +2909,7 @@ static unsigned long __mmap_region(struct file *fil=
e, unsigned long addr,
>  		allocated_new =3D true;
>  	}
> =20
> -	if (have_mmap_prepare && !map_is_anon(&map))
> +	if (have_mmap_prepare && allocated_new && !map_is_anon(&map))

[Severity: High]
This is a pre-existing issue, but does __mmap_region() leak a file reference
if the mapping is successfully merged after the file is swapped?

If the VMA is successfully merged with an adjacent mapping:

mm/vma.c:__mmap_region() {
    ...
    if (map.prev || map.next) {
        VMG_MMAP_STATE(vmg, &map, /* vma =3D */ NULL);
        vma =3D vma_merge_new_range(&vmg);
    }
    ...
}

allocated_new remains false, bypassing __mmap_new_vma() and the normal
consumption of the swapped file reference.

The function then returns on success without executing an fput(map.file) to
clean up the unconsumed extra reference when map.file_doesnt_need_get is
true and allocated_new is false.

[Severity: High]
This is also a pre-existing issue, but does call_mmap_prepare() leak a file
reference in its error paths when validation fails after a file replacement?

If vfs_mmap_prepare() successfully replaces desc->vm_file, but a subsequent
validation check fails:

mm/vma.c:call_mmap_prepare() {
    ...
    err =3D vfs_mmap_prepare(map->file, desc);
    if (err)
        return err;

    if (!desc->vm_ops)
        return -EINVAL;

    err =3D call_action_prepare(map, desc);
    if (err)
        return err;
    ...
}

The function returns early without updating map->file_doesnt_need_get. This
leaves the newly acquired desc->vm_file unreferenced by the error teardown
logic in __mmap_region(), leading to a leak.

>  		set_vma_user_defined_fields(vma, &map);
> =20
>  	__mmap_complete(&map, vma);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D1
