Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C7B389E1A
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 06:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283669; cv=none; b=Pa8NKEVxO9CzDYhQkcdKzokFVJVQsPn/6L9udElin0KqmEfEy3Egv5+QZoojuidoU7zIzewYxGNpEA80VKyeL3VQwBK8HT4oOaH8ptYUzmhzhzm7cR4olrbB2nS/r68XERKSWFKoI7KCSUsMNSQTx5kLreXvnR2O9ITLvLPfeiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283669; c=relaxed/simple;
	bh=KYTWC7R3hA+Kdon3hGT8BBE2kjtHpbpvGscGCYe4Gmc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rGkcODhxGA8Soo4jmkIeCJRr9JMrRqUUQF95p09mwCkT/HnGfCctRajpceMA5sLBdyjqGWfMZBnUtJI/RVINQDNsDKJPUX6kvWwml9s83fhZgFz3aYCDIVm1TpdLm0OMtscf9qOqlepjFJGo5PRYsCtOOw8nOkpHVuFMNmu5cVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P90g+CK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P90g+CK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F61F1F00A3A;
	Wed, 24 Jun 2026 06:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283667;
	bh=Rt/9w4kcDfotjzxe5gxZUWhGEjL54BytKJDYQTW7Co4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P90g+CK60KJelQM30zz51KW7lQ0UYD/BbUNjH9iHXMY4Z9jwFeCEvec0kF7pbbfmI
	 VwfLYFC5g+4rTsYya/GAPsU70UTIrkA6qaZd9ss6k6Q9d/cW49Q8xQTG13n3Zm7/Kx
	 6CadqKPw6WMZ1t3dCjf4tvu2qImShqNbZM70J9sJkgq5A+rPbCOtcmxoFRUISMlObN
	 nhI39Bep6fQCqp2P736CK32/zWn8tA01IGqyaJ7MP8ehp5kFOQzJp29Z6+pesx8tLq
	 olTt+ls6ixiWfNBnnVPIz0y8Pm8KhVOQnuqVQbV1LwNYtoSFXQ9gl00t3Pxl+/Oigo
	 yKPWAioPtk+RQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 1/2] scsi: libsas: refactor sas_ex_to_ata() using new
 helper sas_ex_to_dev()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624063230.3264029-2-yangxingui@huawei.com>
References: <20260624063230.3264029-1-yangxingui@huawei.com>
 <20260624063230.3264029-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 06:47:47 +0000
Message-Id: <20260624064747.8F61F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete defensive NULL check in `sas_ex_to_dev()` defers a kern=
el panic to `transport_sas_phy_reset()`.
- [High] Race condition in `sas_ex_to_dev()` due to unlocked access to `ex_=
phy->port`.
- [High] Returning an un-refcounted `domain_device` pointer exposes callers=
 to a Use-After-Free.
--

commit cd70af1a5d33d82f2c6199f5fc26b59a70b7d45c
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: refactor sas_ex_to_ata() using new helper sas_ex_to_dev()

Introduce sas_ex_to_dev() to return any device type attached to an
expander phy. The new helper is then used by sas_ex_to_ata() to reduce
code duplication.

Also add a defensive NULL check for ex_dev to guard against callers
passing a NULL device.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f471ab464a78b..fc6d8f3c9dcae 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -345,13 +345,16 @@ static void sas_set_ex_phy(struct domain_device *de=
v, int phy_id,
>  		 SAS_ADDR(phy->attached_sas_addr), type);
>  }
> =20
> -/* check if we have an existing attached ata device on this expander phy=
 */
> -struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int ph=
y_id)
> +/* return the domain device attached to an expander phy */
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

[Severity: High]
This is a pre-existing issue, but does adding this defensive NULL check here
fail to protect the caller from the same NULL pointer?

When sas_ex_to_ata() safely returns NULL because ex_dev is NULL, could the
caller logic fall through and crash by deferring the NULL pointer dereferen=
ce?

For example, in drivers/scsi/libsas/sas_init.c:transport_sas_phy_reset():

    ddev =3D sas_ex_to_ata(ex_dev, phy->number);
    if (ddev) {
        ...
    } else {
        return sas_smp_phy_control(ddev, phy->number, reset_type, NULL);
    }

Would this result in a kernel panic inside sas_smp_phy_control() if ddev
is NULL (e.g., due to concurrent device removal)?

> +
> +	ex_phy =3D &ex_dev->ex_dev.ex_phy[phy_id];
>  	if (!ex_phy->port)
>  		return NULL;
> =20
>  	rphy =3D ex_phy->port->rphy;

[Severity: High]
This is a pre-existing issue, but is there a race condition here due to
unlocked access to ex_phy->port?

Device teardown paths can call sas_port_delete(phy->port) and set
phy->port to NULL concurrently. Since we access ex_phy->port locklessly
and without READ_ONCE(), could the port be freed between the check and
the dereference of ex_phy->port->rphy, leading to a panic or use-after-free?

>  	if (!rphy)
>  		return NULL;
> =20
> -	dev =3D sas_find_dev_by_rphy(rphy);
> +	return sas_find_dev_by_rphy(rphy);

[Severity: High]
This is a pre-existing issue, but does returning the domain_device pointer
without incrementing its reference count expose callers to a use-after-free?

Looking at drivers/scsi/libsas/sas_scsi_host.c:sas_find_dev_by_rphy():

    spin_lock_irqsave(&ha->phy_port_lock, flags);
    ...
                found_dev =3D dev;
    ...
    spin_unlock_irqrestore(&ha->phy_port_lock, flags);
    return found_dev;

If a device is concurrently unregistered, sas_put_device() can drop its
kref to 0 and call kfree(dev). When sas_ex_to_dev() passes this un-refcount=
ed
pointer up to callers, won't they read freed memory when attempting to
interact with the device?

> +}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624063230.3264=
029-1-yangxingui@huawei.com?part=3D1
