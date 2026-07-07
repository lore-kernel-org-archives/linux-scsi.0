Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AA535E922
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 03:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783394766; cv=none; b=u2n+1N3eKLeXclkhDcCG3so/o3MSeql77s4gzcgzBu/gwJ6j6lIf9HBSgnWRVPYTQKU7DX6dlZ3MdYuiIlRl2+4nXnmqWHxcy/Y/oCOF5P+OBQnOwu7GIhsMegnVKuUAdiWcm/yJYt4DbxHp8kpzSbuMqNemclWd9oRgsCctn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783394766; c=relaxed/simple;
	bh=2EnhCEJUljRle4WEFfxr684BfApUAtZulyY6WUcZAQQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YM4l72+CRh9ovCUq6TTdPg9ZC0ys+SgCGXUQtaHS91pfmHMWZlT10p4Iso4nErozJTIoCi9/ypn8QO9VLWgxervH0sEccCYSyhpofgi6fHyWjk0oPW3+OvckMdZZB6aZaaCg1iozzaU7nORFX3ELfqnAYP7I3pQOTclLDsIdxqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AE0u+Aoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AE0u+Aoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E021F000E9;
	Tue,  7 Jul 2026 03:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783394764;
	bh=XliL94f02dnmoGNIa/MqVhTiTeepc/96BM5t7o9hIZs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AE0u+AoqpXj1THY5tRI8GdMehIHsyJC1MNoH3JPoDYq3t79899oRIBgBuNjtfPi0V
	 O0XAyxMMNFkr0jzbW2hgangs/KuOCO+HCH/9qfoqPynP4YuEpECHcTMfTJCFZG3iIT
	 LsaBnrAtouj3Upxd/1skyKFP3mKeNfPKbw6qx3IpdzIHRG0RcIgvyvmo4e63jwYSNl
	 cV7kTdR42a/tBsfybPWFGRUZ960JMkfJR4wPmE2HVmX6jDZNAOXbF0pxjHZpdQoGk/
	 5zsN85bzqGBSKgyx9P2u9TZEuBTN/nQonSdIb67SRke2KEsP0OLh9IQKUpmMEX3Bs7
	 jqPC8SRnueGug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: sd: fix special_vec mempool leak when
 scsi_alloc_sgtables() fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707030333.22245-3-yangxiuwei@kylinos.cn>
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
 <20260707030333.22245-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 03:26:03 +0000
Message-Id: <20260707032604.40E021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The special payload page can be freed into the wrong mempool if th=
e device sector size changes while the command is in flight.
--

--- Patch [2]: [PATCH v2 2/3] scsi: sd: fix special_vec mempool leak when s=
csi_alloc_sgtables() fails ---
commit 39421d4b78837e533a8958996d1edabedfa78d22
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>

scsi: sd: fix special_vec mempool leak when scsi_alloc_sgtables() fails

This commit fixes a mempool leak when scsi_alloc_sgtables() fails in
sd_setup_unmap_cmnd() or sd_setup_write_same{10,16}_cmnd(). It ensures
sd_uninit_command() is called on error, clearing RQF_SPECIAL_PAYLOAD
and freeing the payload page.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d18693d390b2f..8fed1cda9ac8c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -958,6 +958,21 @@ static unsigned char sd_setup_protect_cmnd(struct sc=
si_cmnd *scmd,
>  	return protect;
>  }
> =20
> +static void sd_uninit_command(struct scsi_cmnd *cmd)
> +{
> +	struct request *rq =3D scsi_cmd_to_rq(cmd);
> +	struct scsi_device *sdp =3D cmd->device;
> +
> +	if (!(rq->rq_flags & RQF_SPECIAL_PAYLOAD))
> +		return;
> +
> +	if (sdp->sector_size > PAGE_SIZE)
> +		mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
> +	else
> +		mempool_free(rq->special_vec.bv_page, sd_page_pool);

[Severity: High]
This isn't a bug introduced by this patch, but can this free the page to the
wrong mempool if the device sector size changes while the command is in fli=
ght?

sd_set_special_bvec() allocates the page based on the sector size at the ti=
me
of submission:

    if (sector_size > PAGE_SIZE)
        page =3D mempool_alloc(sd_large_page_pool, GFP_ATOMIC);
    else
        page =3D mempool_alloc(sd_page_pool, GFP_ATOMIC);

If sd_read_capacity() updates sdp->sector_size dynamically during a concurr=
ent
rescan before the request queue is frozen, this cleanup path might read the
updated sector size. This could result in freeing an order-0 page into the
large page pool or vice versa, causing memory corruption upon subsequent
allocations from the pool.

> +	rq->rq_flags &=3D ~RQF_SPECIAL_PAYLOAD;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707030333.2224=
5-1-yangxiuwei@kylinos.cn?part=3D2
