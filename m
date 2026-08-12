Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9E7347FEC
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 20:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565143; cv=none; b=jiMEeSuSH6dlGLEIaA+pWKRKXPYfOylv2Gd3m9Dpf1DJNmX2/WzZeMPJ3oYFBwvTMS2DH048dC7Ltv3qgr1BYeo+WL4U0TGCdQWsa+F9+L4cYbU4ST4SjTcCKxqXKa934B4vro5bhqWOMU669nupMyeJIGc8h/oDeBpq84iMwpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565143; c=relaxed/simple;
	bh=lQz0pBDDO4J+WegjwERpqFEpKxeep6HcXxHfVu3q5VY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FRSoscMzYq9ieITnlzRGeruHxUfkHjlCl0qq67kmyh+fE8NTwcY2eFev66Qz/W79S9dcmI2QjDrSvk4UIM3OSsHcBCHVkNX7QlBTngXDA9jTCcgbsC2cHbmMUkuvsum9yUqQiSGfNGtO1CMs5YdhC2Hi2FjlYB+KhwZeY3lpdhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KvhbANDt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KvhbANDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F5F1F00A3D;
	Wed, 12 Aug 2026 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786565141;
	bh=LvI6JVXuvu4UPWLcLNwCVg5gt+MoXWU6tqNXf/l5JqU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KvhbANDt6FjccuFd4xUjgNc6O0TkszeZ6pSCQlrp2O+sO/WfLtmHlG6nrqZedCEtZ
	 p0xr+HTCHw4gOfE+SX3wQhHnyxiInh9HJR/mPuHyMTtMGwLCvnzkPh4yLmHfNSAbjQ
	 XKFFP8Mo8QAXIIkEKrsNlCVJUDkWPIkKk6oMTqLhE9qYeiDBZoKD6kdFt2qvlisuiK
	 2fA7kEPqt/E2mjQgfZ6wvx4sjvoleUuUB7J6gmr2xvfOw+Lzb4ezkFM8SjspdLwTGy
	 OHGkf4WYkwzDnalLJDwljlD6LrwspqEEf1ah8CMuc8TLDqzI1qIYVekmifpR6CUs1u
	 2GKufWyCbaWKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] scsi: libsas: Handle errors in sas_set_ex_phy()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eshaan Deshmukh" <eshaan2031@icloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812194808.576586-3-eshaan2031@icloud.com>
References: <20260812194808.576586-1-eshaan2031@icloud.com>
 <20260812194808.576586-3-eshaan2031@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 20:05:40 +0000
Message-Id: <20260812200541.72F5F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Returning -EBUSY when SAS_HA_ATA_EH_ACTIVE is set aborts the entir=
e expander discovery.

Pre-existing issues:
- [High] Setting phy->phy =3D NULL on sas_phy_add failure without cleaning =
up phy_state leads to a NULL pointer dereference in sas_ex_get_linkrate.
--

--- Patch [2]: [PATCH v3 2/3] scsi: libsas: Handle errors in sas_set_ex_phy=
() ---
commit bb6067e9bf28e3d0ad6e9081b09eb33b9747146c
Author: Eshaan Deshmukh <eshaan2031@icloud.com>

scsi: libsas: Handle errors in sas_set_ex_phy()

The function sas_set_ex_phy() uses BUG_ON() if sas_phy_alloc() fails.
Change it to return -ENOMEM error code if that happens. Change all the
other returns in sas_set_ex_phy() to return 0 to preserve current
functionality, or to return an error. Change all uses of sas_set_ex_phy
to handle the returned error codes.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f1a1417b09819..ab6afbad37feb 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
[ ... ]
> @@ -220,14 +220,15 @@ static void sas_set_ex_phy(struct domain_device *de=
v, int phy_id,
>  	struct sas_rphy *rphy =3D dev->rphy;
>  	bool new_phy =3D !phy->phy;
>  	char *type;
> +	int error;
> =20
>  	if (new_phy) {
>  		if (WARN_ON_ONCE(test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)))
> -			return;
> +			return -EBUSY;

[Severity: High]
Will returning -EBUSY here abort the entire expander discovery?

Previously, this returned void, allowing the discovery loop to continue.
If a transient ATA error coincides with an expander hotplug event, this
-EBUSY error propagates up through sas_ex_phy_discover_helper() to
sas_discover_domain(), where it causes the newly discovered expander device
to be destroyed via sas_rphy_free().

Since sas_discover_domain() does not defer on ATA EH, could a transient
ATA error permanently fail the discovery of a SAS expander?

>  		phy->phy =3D sas_phy_alloc(&rphy->dev, phy_id);
> =20
> -		/* FIXME: error_handling */
> -		BUG_ON(!phy->phy);
> +		if (!phy->phy)
> +			return -ENOMEM;
>  	}
> =20
[ ... ]
> @@ -296,11 +297,14 @@ static void sas_set_ex_phy(struct domain_device *de=
v, int phy_id,
>  	phy->phy->enabled =3D (phy->linkrate !=3D SAS_PHY_DISABLED);
> =20
>   skip:
> -	if (new_phy)
> -		if (sas_phy_add(phy->phy)) {
> +	if (new_phy) {
> +		error =3D sas_phy_add(phy->phy);
> +		if (error) {
>  			sas_phy_free(phy->phy);
> -			return;
> +			phy->phy =3D NULL;
> +			return error;
>  		}
> +	}

[Severity: High]
This is a pre-existing issue, but does setting phy->phy to NULL here on
sas_phy_add() failure lead to a NULL pointer dereference later?

If device registration fails, phy->phy is freed and set to NULL, but
phy->phy_state remains PHY_EMPTY and attached_sas_addr is still populated.

If this error is ignored during revalidation, later operations like
sas_ex_get_linkrate() might iterate over the phys, match the address, and
pass the NULL phy->phy to sas_port_add_phy():

sas_ex_get_linkrate()
   if (sas_phy_match_dev_addr(child, phy)) {
      ...
      sas_port_add_phy(port, phy->phy);

sas_port_add_phy() will then unconditionally dereference the NULL phy point=
er
when checking the port_siblings list.

Should the ex_phy array be scrubbed (e.g., reverting phy_state to
PHY_VACANT) when registration fails to prevent this?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812194808.5765=
86-1-eshaan2031@icloud.com?part=3D2
