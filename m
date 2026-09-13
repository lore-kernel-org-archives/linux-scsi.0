Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2F392C28
	for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2026 13:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789304894; cv=none; b=MTADXwnl5lYt/i+go4w+C9/+Ks7llyKrge40ynBOhfnMy12VmpR0XxbCvPovAnyonLF2w5wTC2cAnbdys3MQF+JGg8Ao4iFhz3HoTusl3g4U/mYPqlRieqJFk3qCkZ2dSgXjA8zk1rvokyVR9/mqIOzZBOr9I4chgTUgv4nWNGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789304894; c=relaxed/simple;
	bh=emkFcM7WkcV5GGnRwenaU1IAhb5WyZUMqWTiY2f89bg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B0nUo1oGegz5sb98HEaFv63Si4blQBNxZ336O7x4fQo9miE6YKgW0ktJ+ChIhNlfbpmpHlZKEguk1rRHUSBSpj7lpF9IISIzA9k24q9venu2dFQuxm7Fr+yOWaEuzHT8QVoEmNOM6IPk23rpNuzoTKp+OrkAic+L9fjnBtmW31c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6xJqNou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6xJqNou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A381F000FF;
	Sun, 13 Sep 2026 13:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789304893;
	bh=j/eC9c37TBHNENiYT1RIQsgyfrd+JWBDTXKgBpCO+6g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i6xJqNou+OyKi47qYsGc5lRdrjohvRaxnq4IiJ/tZCbAU0MWUWj1V5A2rv8gg/oVn
	 nsoFkwxNmwxztBf459UWRwJzBGpU1GooWzoNC4RAL97pvad+Ubrsh9QTcGwlhptnnK
	 3pI4KaBI+huOLyNU8iRJbyqv8vMLkDqTfKJnjr7toCNrh0R370NeqSNzXHbyFibgeA
	 3lBNbQN0Q7O7lgpnXniGwlrI1C8oHHE635F2wNOd2e70AKXIUnuXAR8BPOh1rS6bAL
	 BYsVSUZwbvs53zr0wogHvKRoenu7R8w5hchfmUwmzGP83CMtyOcEaiEAV+6EiDe5EJ
	 w3NK6IDGcSmPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: unwind failed remote-PHY allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Slavin Liu" <bolin.liu@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260913125217.110026-1-bolin.liu@seu.edu.cn>
References: <20260913125217.110026-1-bolin.liu@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 13:08:12 +0000
Message-Id: <20260913130812.C1A381F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing error handling for `sas_rphy_add()` failure causes invalid=
 driver state and a kernel crash during device teardown.
--

commit 5ef24e402f3bccdd53263da60efdaa50aeca068d
Author: Slavin Liu <bolin.liu@seu.edu.cn>

scsi: mpi3mr: unwind failed remote-PHY allocations

Remote-PHY allocation can fail after the SAS port and its PHY links
were registered. Remove those links, delete the port and clear the
pending flag before entering the existing private-port cleanup.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 29013d0fea547..2ce2c6c07f284 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1468,6 +1468,17 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add=
(struct mpi3mr_ioc *mrioc,
>  		rphy =3D sas_expander_alloc(port,
>  		    mr_sas_port->remote_identify.device_type);
>  	}
> +	if (!rphy) {
> +		list_for_each_entry(mr_sas_phy, &mr_sas_port->phy_list,
> +				    port_siblings) {
> +			sas_port_delete_phy(port, mr_sas_phy->phy);
> +			mr_sas_phy->phy_belongs_to_port =3D 0;
> +		}
> +		sas_port_delete(port);
> +		if (tgtdev)
> +			tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add =3D 0;
> +		goto out_fail;
> +	}
>  	rphy->identify =3D mr_sas_port->remote_identify;
> =20
>  	if (mrioc->current_event)
>  		mrioc->current_event->pending_at_sml =3D 1;
> =20
>  	if ((sas_rphy_add(rphy))) {
>  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
>  		    __FILE__, __LINE__, __func__);
>  	}
>  	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
>  		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add =3D 0;
>  		tgtdev->dev_spec.sas_sata_inf.sas_transport_attached =3D 1;
>  		mpi3mr_tgtdev_put(tgtdev);
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but is it safe to proceed
after sas_rphy_add() fails in mpi3mr_sas_port_add()?

If sas_rphy_add(rphy) fails here, it logs an error but execution continues
normally, marking the transport as attached.

However, when sas_rphy_add() internally attempts device_add(&rphy->dev) and
fails, it returns an error but leaves port->rphy pointing to the failed rph=
y.

Later during device teardown, sas_port_delete() will do:

	if (port->rphy) {
		sas_rphy_delete(port->rphy);
		...
	}

sas_rphy_delete() then calls device_del(). Calling device_del() on a device
that failed device_add() results in a kernel crash, because device_del()
dereferences dev->p which was cleaned up and set to NULL.

Could this error path be updated to unwind the failed rphy allocation and
goto out_fail similarly to the new !rphy check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913125217.1100=
26-1-bolin.liu@seu.edu.cn?part=3D1
