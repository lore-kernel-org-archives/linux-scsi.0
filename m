Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4AF3594A
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 06:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781159131; cv=none; b=mNiVQIVDhNZHmOdUWDBfHMOUZP+ULAFcRQ/xNa0+ZmZn01Fpwq1c+tRoUSdpslfRPxzKmOk5g5Podjx+ls8PkRN/w045lfncuVIrSje6cZxuglgvdMmBL2EoFAcZddyatdPsGvVT2oTEXqdSrj+L7LTdiiGWyDKDubOpgI3FOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781159131; c=relaxed/simple;
	bh=z5WMY/jINUIUq/uwDw0yCFvZ0XbpR41fPS/BF3VNmJo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vb11mpyNJVjCRMFUUEDHtBYdQ8/BHUyF7kSaWi1hab4kFMQteqxnRP4HpFSFurB+QDPGi/TH8yVOKnQfQ/DLFSXHq8froRkh7qNI1vOKhFtiG0BD6vn/4PsdiAF+tCXu+6loG/qgvDd3sjqtX1iPLlhIuQwQC7GYwWcc6sDrjwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DmoAlg0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DmoAlg0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6651F00898;
	Thu, 11 Jun 2026 06:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781159130;
	bh=BaROudemX9p5VnyVCSAC5sBqN1HsqQxzb3flz/fA01c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DmoAlg0yd0op69R9wHsCTWTyAxjT4VwRdWgeUsB+uPfhNiS2AIRJtu4YQtapmewrV
	 yfSQoET2xw5AHXbozzrm5+3knCsoApRfIDzG5mle0VEkGHPG7qq5k1RR92b4Kj6hZ1
	 I5foYgomYb1/Cvtv7oEpw4Q/ROTBkWgtg8jPkNzkz1JLDPzHebUuRR//Wj76rI7sKW
	 hMEXfhNyLEYF+mEL040MY9qtJicXzTi+XjawFFdZiRym+HjnjOrjJPHLQzECraRc77
	 aQ15heKW0HFTAi1b/7+KDF67l70f5AuNwGezj00gJrMOokXhzASNfqKgkDDl+Hx9PA
	 KVPX2B6+HPPTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/2] scsi: libsas: refactor sas_ex_to_ata() using new
 helper sas_ex_to_dev()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611061551.1171058-2-yangxingui@huawei.com>
References: <20260611061551.1171058-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 06:25:29 +0000
Message-Id: <20260611062530.3B6651F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] NULL pointer dereference when reading pointer field from potential=
ly NULL ex_dev.
- [High] Use-After-Free due to sas_find_dev_by_rphy() returning an unrefere=
nced pointer.
- [High] Lockless double-read (TOCTOU) of ex_phy->port leading to a NULL po=
inter dereference.
--

commit f86aa191eb49f8200f6534cbd6610c0ee2c51011
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: refactor sas_ex_to_ata() using new helper sas_ex_to_dev()

This commit refactors the sas_ex_to_ata() function by introducing a new
sas_ex_to_dev() helper to return any device type attached to an expander
phy. The new helper is then used by sas_ex_to_ata() to reduce code
duplication.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f471ab464a78b..f55ae9a979cd4 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c

[ ... ]

> -/* check if we have an existing attached ata device on this expander phy=
 */
> -struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int ph=
y_id)
> +struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int ph=
y_id)
>  {
>  	struct ex_phy *ex_phy =3D &ex_dev->ex_dev.ex_phy[phy_id];

[Severity: High]
This isn't a bug introduced by this patch, but could this expression result
in a NULL pointer dereference?

If callers like transport_sas_phy_reset() pass a ddev returned from
sas_find_dev_by_rphy() that is NULL, evaluating this expression implicitly
dereferences ex_dev to read the ex_phy pointer field before calculating
the array offset. Does this cause an immediate crash?

> -	struct domain_device *dev;
>  	struct sas_rphy *rphy;
> =20
>  	if (!ex_phy->port)
>  		return NULL;
> =20
>  	rphy =3D ex_phy->port->rphy;

[Severity: High]
This is a pre-existing issue, but does this lockless double-read risk a
NULL pointer dereference?

If a concurrent thread (such as the discovery workqueue calling
sas_unregister_devs_sas_addr()) clears ex_phy->port after the check
but before the dereference:

CPU1
sas_unregister_devs_sas_addr()
    ex_phy->port =3D NULL;

CPU2 sees this in sas_ex_to_dev():
    if (!ex_phy->port)
        return NULL;
    // CPU1 clears port here
    rphy =3D ex_phy->port->rphy;

Could this cause a crash when accessing ->rphy? Would it be safer to use
READ_ONCE() to fetch ex_phy->port into a local variable first?

>  	if (!rphy)
>  		return NULL;
> =20
> -	dev =3D sas_find_dev_by_rphy(rphy);
> +	return sas_find_dev_by_rphy(rphy);
> +}

[Severity: High]
This is also a pre-existing issue, but does sas_find_dev_by_rphy() return
an unreferenced pointer?

Looking at sas_find_dev_by_rphy() in sas_scsi_host.c, it locates the
device, assigns it to found_dev, and drops the dev_list_lock without
acquiring a reference via kref_get():

drivers/scsi/libsas/sas_scsi_host.c:sas_find_dev_by_rphy() {
    ...
    if (rphy =3D=3D dev->rphy) {
        found_dev =3D dev;
        spin_unlock(&port->dev_list_lock);
        goto found;
    }
    ...
}

If a concurrent device removal operation drops the last reference via
sas_put_device(), does returning this unreferenced pointer back up the
call chain to sas_ex_to_dev() result in a use-after-free when the caller
dereferences it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611061551.1171=
058-1-yangxingui@huawei.com?part=3D1
