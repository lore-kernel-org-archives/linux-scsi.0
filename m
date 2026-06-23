Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F12C386571
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782183580; cv=none; b=c/vwSky5efnPA5EGiZ30TbQgIv3dVvdySVauhGgSn9cHnma5l0dopW5E6zpDDXZc17hEd5RRNPSJpmrpCxmBCqPXU4EJB/Y1IJyrj4MpNAL058t0owY8psO92U/nMqf8I8rGqbu1446KPNgy1YOV/ia8mBng6xpLFXksHKQfJ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782183580; c=relaxed/simple;
	bh=iLnjX+reGFrG3F5YkcH76FGNk+ysWPUmFvseaV3Vt8U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BQNIXxFs8D2IYBUZjSHmkF/ILvBd4mjiI1g/nQlrSWyDwH76SklaNf/csZ0fdWDlHHO3cy/SI1G4n0BehWz5029V2hRo7kNuP8i+h84a4XwUCtZVcMZupYolmdoKinViYaIjBAHBVXOa7zgoliVoeZjGcqYUOlFKd7+QJbAV4IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZKOWqw01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZKOWqw01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0509F1F000E9;
	Tue, 23 Jun 2026 02:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782183579;
	bh=Cy4iTQfmLSj98lKLUGmOLWgFxhb1YoBSJznmiul9pSw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZKOWqw01Uhm7puZGcrOc6VNy0fhTbTX4n1lyDnbOC6Fc8eGyLgHiLl+gsavqIUIri
	 m6qH8VGldasccdfbKQhj52rSumtYdS2yrB7HUnPECQhL6trZtN0hDuT4HgXCTM2wvD
	 +U5uzqLFAcF8urTKQkQRSL7qi6+nVLGofaSCysew1ZRocSC6YS/Vc5E2ZAbmdhjtku
	 OCfg4kQ/wr4JvXAGjjTtrz+/5le47YsBj+yb/eMqiU+qfF5/qCozWMWD/IcQ43pVmx
	 vcc8/ci+fR3quB7+2ym3WHYkvHmW4PVuLVBySL0IuPpsNwJsUuHbSdDI7LODCikThn
	 ERkavJWdltnOA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/2] scsi: libsas: refactor sas_ex_to_ata() using new
 helper sas_ex_to_dev()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623024304.714582-2-yangxingui@huawei.com>
References: <20260623024304.714582-1-yangxingui@huawei.com>
 <20260623024304.714582-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:59:38 +0000
Message-Id: <20260623025939.0509F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The patch adds a defensive NULL check for `ex_dev` to prevent a cr=
ash when callers pass a NULL device, but this merely shifts the crash to th=
e fallback path in its main caller `transport_sas_phy_reset`.

Pre-existing issues:
- [High] `sas_find_dev_by_rphy()` returns an un-refcounted `domain_device` =
pointer, leading to a Use-After-Free if the device is concurrently removed.
- [High] Lockless and unprotected access to `ex_phy->port` causes a TOCTOU =
race, leading to NULL pointer dereference.
--

commit 7daa35d1e6df78b76bca7d9ad2296ce81f71c4d9
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: refactor sas_ex_to_ata() using new helper sas_ex_to_dev()

Introduce sas_ex_to_dev() to return any device type attached to an
expander phy. The new helper is then used by sas_ex_to_ata() to reduce
code duplication.

Also add a defensive NULL check for ex_dev to guard against callers
passing a NULL device.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f471ab464a78b..cb9d3b7482225 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -345,13 +345,15 @@ static void sas_set_ex_phy(struct domain_device *de=
v, int phy_id,
>  		 SAS_ADDR(phy->attached_sas_addr), type);
>  }
> =20
> -/* check if we have an existing attached ata device on this expander phy=
 */
> -struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int ph=
y_id)
> +struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int ph=
y_id)
>  {
> -	struct ex_phy *ex_phy =3D &ex_dev->ex_dev.ex_phy[phy_id];
> -	struct domain_device *dev;
> +	struct ex_phy *ex_phy;
>  	struct sas_rphy *rphy;
> =20
> +	if (!ex_dev)
> +		return NULL;
> +

[Severity: High]
Does this new check shift a crash into the fallback path of callers instead
of preventing it?

If a concurrent removal causes ex_dev to be NULL, this check allows
transport_sas_phy_reset() to receive NULL instead of crashing here. However,
transport_sas_phy_reset() then falls back to calling sas_smp_phy_control():

drivers/scsi/libsas/sas_init.c:transport_sas_phy_reset() {
    ...
    if (ata_dev && !hard_reset) {
        ...
    } else {
        return sas_smp_phy_control(ddev, phy->number, reset_type, NULL);
    }
    ...
}

Because ddev is still NULL, it is passed into sas_smp_phy_control(), which
calls smp_execute_task_sg(), eventually causing a crash when dereferencing
dev->port:

drivers/scsi/libsas/sas_expander.c:smp_execute_task_sg() {
    ...
    to_sas_internal(dev->port->ha->shost->transportt);
    ...
}

Is it safe to return NULL here without ensuring callers like
transport_sas_phy_reset() can handle it properly?

> +	ex_phy =3D &ex_dev->ex_dev.ex_phy[phy_id];
>  	if (!ex_phy->port)
>  		return NULL;

[Severity: High]
This is a pre-existing issue, but does this sequence have a time-of-check
to time-of-use race condition?

The code checks if ex_phy->port is NULL and then dereferences it on the
next line (rphy =3D ex_phy->port->rphy). If a concurrent thread like
sas_port_delete_phy() sets phy->port to NULL between these two lines, could
this cause a NULL pointer dereference?

> @@ -359,7 +361,13 @@ struct domain_device *sas_ex_to_ata(struct domain_de=
vice *ex_dev, int phy_id)
>  	if (!rphy)
>  		return NULL;
> =20
> -	dev =3D sas_find_dev_by_rphy(rphy);
> +	return sas_find_dev_by_rphy(rphy);

[Severity: High]
This isn't a bug introduced by this patch, but does sas_find_dev_by_rphy()
return an un-refcounted pointer that could be freed while in use?

Looking at sas_find_dev_by_rphy(), it locates the device under a lock but
returns it without taking a reference:

drivers/scsi/libsas/sas_scsi_host.c:sas_find_dev_by_rphy() {
    ...
    spin_lock(&port->dev_list_lock);
    list_for_each_entry(dev, &port->dev_list, dev_list_node) {
        if (rphy =3D=3D dev->rphy) {
            found_dev =3D dev;
            spin_unlock(&port->dev_list_lock);
            goto found;
        }
    ...
    return found_dev;
}

If the device is concurrently unregistered and freed (e.g., via
sas_free_device()), does this pointer become dangling before the caller can
safely use it?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623024304.7145=
82-1-yangxingui@huawei.com?part=3D1
