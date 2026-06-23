Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55A23793CB
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179763; cv=none; b=EF12sUMnI+1mhHuTjXx3bxqffoysK9hSTXZ/LLz7oewgeiwA5WcJb/V2yjKOORAVMUELPmuWl2+b2yO3cIgQJ3t+9/Vzif1OQuq9ZZg+v+9q9Ng7XiuzPtl2zDC2/QcB/mWE9+g9E3MKCmmTCYTonM5OKDj8Sh1TaFJc/1hVkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179763; c=relaxed/simple;
	bh=k44JefXkZZ0YAVrxxJOGuoMAueaiQ40Q+wyH+VGIU70=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IhOBi8hIaQwSXtauR/CS9YCpRGwR2NC5KcFCKgP11jT0vXCUo1iEZW+8hyzSoeuMNOV0c55iA/sk2ZEitiAKvM48OeF/tvIiIBRjpeDBg5Bb4eEyWION/4QL4QsVDoXBWDo6UM/hU6QLCp06aSpNF10dOBcPVcMY8WDFZn2c5TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMfrMNBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMfrMNBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C40E1F000E9;
	Tue, 23 Jun 2026 01:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179762;
	bh=OKhavFxFZgbpOSx/fjpiHBsYBnhXgJrbe4c2MbrCBuk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AMfrMNByoeB/c2iDfcJ5v3y0dnBk/MRTqMCRxTIOrWom0FXUoxX6CwS7laZdLnXp5
	 3OMHsNT31JvMi9q9ZH2GHFToTtNtwbJftEthaSPH7PN5PDZo7FKmGJFWOS4+pTKQ9X
	 KMKr4bTomucf7RKT538f0VS2D0wtiW/ccEa3xc2J8dJfNIFlRVANODu3RWaQ4RCimR
	 gHlW8+krYSgGiYe5mBiw514iTzWn255WLESSEDNOQpBbp2BC43N8fPonFJuDVAZ8Qx
	 BZ9rgsCklnyYVJgEqk4GR+8t4Jo0GEEqgUgc1cs5up1uDKEOnFbI4psCHzFdSbh3uU
	 04mWQCYvj0XRw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 16/29] ibmvfc: allocate targets based on protocol
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-17-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-17-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:56:01 +0000
Message-Id: <20260623015602.5C40E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Target structures allocated from a mempool are incorrectly freed u=
sing kfree() instead of mempool_free(), permanently depleting the mempool r=
eserve.
--

commit 2827414150eab249a5dd4c4a093ced5d74ae8737
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: allocate targets based on protocol

Allocate discovered targets onto the channel-group list that matches
their protocol.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 363bf75d62443..4b95e43449473 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -5004,6 +5011,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *=
vhost,
> =20
>  	tgt =3D mempool_alloc(vhost->tgt_pool, GFP_NOIO);
>  	memset(tgt, 0, sizeof(*tgt));
> +	tgt->protocol =3D protocol;

[Severity: High]
This is a pre-existing issue and was not introduced by the patch under
review, but since we are looking at this allocation path, is the target
structure freed correctly when released?

This function allocates tgt from a mempool, but looking at the reference
count release routine ibmvfc_release_tgt(), the object is freed directly to
the slab allocator:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
    struct ibmvfc_target *tgt =3D container_of(kref, struct ibmvfc_target, =
kref);
    kfree(tgt);
}

Because it is freed via kfree() instead of mempool_free(), the mempool
internal reserve count is never replenished and waiting threads are not wok=
en
up. Under memory pressure, subsequent mempool_alloc() calls with GFP_NOIO
could block indefinitely on the mempool waitqueue once the reserve is
depleted.

>  	tgt->scsi_id =3D scsi_id;
>  	tgt->wwpn =3D wwpn;
>  	tgt->vhost =3D vhost;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D16
