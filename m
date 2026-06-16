Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41291441035
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625204; cv=none; b=UIsdpGaBNf0GxxQgTF7xkznnQK6QVpXFtuexMfjttfqioVZqxFYIiFyUiqN1Y6flHzPYsthpwt41HUtZvDGds6TtK1GPcGPnzFdbOS0yFGn3ctzMPkXrfVtbEsUxrgURUqxPPXQLeQbM1w6xsh4UejkfE8EXVAmHAtXM8FMDMHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625204; c=relaxed/simple;
	bh=TiLfPhWZn4S0Yvxk4AUP1hSZ8A9odkO2V0+yRR1cao4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hWleWT4l/KKS8b5EAhntGitwdghZY76dZrrtVzcu1U70uZLdGFa/6R3k3d5W69YRJpcxY8P1ix6V/dFUuFTtUH7uwToyONrpFqT8Vew2/WzuyWJO1/spQ/YTVGLmd0Xf2xsSqOq3MRCZjgeMwfK4HLaG/WGzjxk8ZVWxpSzs8/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuhzIAfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuhzIAfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B371F000E9;
	Tue, 16 Jun 2026 15:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781625202;
	bh=ITkXj0ztyyHeIuZgFv0hrZgzG99mZoPpqbHdEFs5Bq8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NuhzIAfFxUjvKnx85eDeJD/CK8DHK8c8oFh2/bdCJz72fE7ddQjxzWiSShY+RES0t
	 ITNsEktdY5MTs4IEghPLkFwNS2Ed6KvINtgyXVIiYTWXYeGuSE5DM0xBSlA+YiegI9
	 XUIeXDfKfidxaqfcuZ9hrg+0mnCp4jEpBvma6ZZzoZ1Vet3a6wdpVRgf4WAeIBSdfv
	 fvD/vdqRe4h9oomIwAwexJ9arZAaBu7Z+d24m2gGFqpO3kdfkyPi9IMggOGwpPtqcv
	 AJ6NBJd1IyUxh8udWdpRIkJkj/pmbCZA+dz9G42dMtXEAfakWhQClX2UddXSu/Ncsc
	 JmMGugKr6z2PA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: mptfusion: Fix array out of bounds error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexey Gladkov" <legion@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260616152908.363621-1-legion@kernel.org>
References: <20260616152908.363621-1-legion@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 15:53:22 +0000
Message-Id: <20260616155322.C4B371F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch attempts to fix an array out-of-bounds error by clamping=
 `ioc->facts.NumberOfPorts` to `ARRAY_SIZE(ioc->pfacts)` inside a newly int=
roduced `mpt_get_adapter()` wrapper. However, this fix is incomplete and ea=
sily bypassed. The underlying hardware facts are dynamically refreshed duri=
ng background hardware fault recovery by `GetIocFacts()`, which directly ov=
erwrites `ioc->facts` with raw firmware data using `memset` and hardware re=
plies. Because `mpt_get_adapter()` is only called during device probing and=
 suspend/resume, background recovery resets `NumberOfPorts` to the unbounde=
d hardware value (e.g., 8). Subsequently, unprivileged users can read the S=
_IRUGO `/proc/mpt/iocX/info` file, triggering `mpt_iocinfo_proc_show()`. Th=
is function loops over the unbounded `NumberOfPorts`, causing out-of-bounds=
 reads on the `pfacts` and `fc_port_page0` arrays (both sized to 2), leakin=
g adjacent `MPT_ADAPTER` memory to user-space.
--

commit 09bc8d96f319385694c9b6744f49e39d39f37f63
Author: Alexey Gladkov <legion@kernel.org>

scsi: mptfusion: Fix array out of bounds error

The driver retrieves the number of ports from the hardware. However, the
driver can handle no more than two such ports and uses a fixed array.
This patch introduces mpt_get_adapter() to clamp the number of ports
to the array size to prevent out-of-bounds errors.

Link: https://gitlab.com/qemu-project/qemu/-/blob/master/hw/scsi/mptsas.h?r=
ef_type=3Dheads#L7
Link: https://gitlab.com/qemu-project/qemu/-/blob/master/hw/scsi/mptsas.c?r=
ef_type=3Dheads#L619

> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mp=
tbase.c
> index 3a431ffd3e2eb..9e738d0bb8e35 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c

[ ... ]

> @@ -1741,6 +1741,21 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>  	return r;
>  }
> =20
> +MPT_ADAPTER *
> +mpt_get_adapter(struct pci_dev *pdev)
> +{
> +	MPT_ADAPTER *ioc =3D pci_get_drvdata(pdev);
> +
> +	if (ioc && ioc->facts.NumberOfPorts >=3D ARRAY_SIZE(ioc->pfacts)) {
> +		ioc->facts.NumberOfPorts =3D ARRAY_SIZE(ioc->pfacts);
> +	}
> +

[Severity: High]
This is a pre-existing issue, but does this fix completely prevent the
out-of-bounds access?

While this wrapper clamps the value during device probing and suspend/resum=
e,
background recovery operations bypass it. Specifically, GetIocFacts() writes
raw firmware data directly into ioc->facts:

GetIocFacts() {
    facts =3D &ioc->facts;
    reply_sz =3D sizeof(*facts);
    memset(facts, 0, reply_sz);
    ...=20
    r =3D mpt_handshake_req_reply_wait(ioc, req_sz, (u32*)&get_facts,
                                     reply_sz, (u16*)facts, ...);
}

If the hardware (or QEMU) provides a NumberOfPorts greater than 2 during
background recovery, the clamp is lost. Later, an unprivileged user reading
the S_IRUGO file /proc/mpt/iocX/info triggers mpt_iocinfo_proc_show(), which
uses the unclamped value:

mpt_iocinfo_proc_show() {
    for (p=3D0; p < ioc->facts.NumberOfPorts; p++) {
        ...
        ioc->fc_port_page0[p].WWNN.High,
}

Could this still lead to an out-of-bounds array read that leaks kernel
memory to user-space? Would it be safer to enforce this clamp directly
inside GetIocFacts() where the hardware data is received?

> +	BUILD_BUG_ON(ARRAY_SIZE(ioc->pfacts) !=3D ARRAY_SIZE(ioc->fc_port_page0=
));
> +	BUILD_BUG_ON(ARRAY_SIZE(ioc->pfacts) !=3D ARRAY_SIZE(ioc->fc_data.fc_po=
rt_page1));
> +
> +	return ioc;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616152908.3636=
21-1-legion@kernel.org?part=3D1
