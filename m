Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81433090C6
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 05:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786945015; cv=none; b=uoBNs4Pk3IAZPfr47zoT72OUUyeOUAUNZ7eKjHBfPV4BvWjqWtW2wYIt3mjtLryWIR3SoOih+rTUUdprIrkZKTeh3n35nMyu+tjODEVxiULqWm2jxiPi0kfALUIbyKeF6zgxFKeCBQE1U2xbdeEFwKhnKQy4sdTj8gls40wJRqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786945015; c=relaxed/simple;
	bh=HapnrUzqscvtzg8Q4QZKioLYpHuoQf8jr0kcPPczf9c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pJZGYo+guY7+3Ch8c8Qk2YNtTMGl7SeKTqCZlUwxburysjoowocDaxF5V2/raH0ZeWAengg+WUQ0j4xEGsWKhZHOwT8GxbEAh8LUANdClW/f4IOhENhVo8uvLj3R9KF4HaGT+L9ivVwTaHhEJ5oX1Sn10uO/yla8uBoxynAS26U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhSTjbfm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhSTjbfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7CB1F00A3A;
	Mon, 17 Aug 2026 05:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786945013;
	bh=iWch3XzSBhpWAORys8bSNHcxeJ3908/ZwhHCcYkv9QQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZhSTjbfmwn1NU5QI459o6mZYXa+AQGGKUlkcHMGcV9f09C9rlEdITCC1W1whjeA/Z
	 49glgfGQqAeMCNX5Aq0/5EbT+0OZ3YQvGvqxIDYWg1VkcuCgDD2B+QRCojZ56Cw5ss
	 XcbgA8D8KFUx/hWJgGlMYkyoFW3kcG+dGlVVTKLdPHPl5pWRv8b8VN7E45GpRyuWDN
	 g9aS2876W3d8p/CY7N+4hIinm2+VO3XtZWvdm4hVgllDLn3JaZlAX1eFSwwKO1jyjG
	 kNy7v9Lf3sc8yHB+01CJzUIpuBxSDc3IW3ESHIo27qq+9SwB8hzDOKGwIpfIgnwkSS
	 7FZm8ExM27y6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: Handle SAS port and rphy allocation
 failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Triet Hoang" <triet.hoang.dev@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817052619.810762-1-triet.hoang.dev@gmail.com>
References: <20260817052619.810762-1-triet.hoang.dev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 05:36:52 +0000
Message-Id: <20260817053653.2B7CB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Target device reference and state leak on newly added error paths.
- [High] Corruption of SAS PHY state on rphy allocation failure.
--

--- Patch [1]: [PATCH] scsi: mpi3mr: Handle SAS port and rphy allocation fa=
ilures ---
commit df830714a909590a741f4ae3350492bababc3051
Author: Triet Hoang <triet.hoang.dev@gmail.com>

scsi: mpi3mr: Handle SAS port and rphy allocation failures
   =20
This commit adds checks for the return values of sas_port_alloc_num(),
sas_port_add(), sas_end_device_alloc(), and sas_expander_alloc(), adding
cleanup and failure paths to prevent NULL pointer dereferences.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..2fbfd178c5398 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1428,9 +1428,17 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add=
(struct mpi3mr_ioc *mrioc,
>  	}
> =20
>  	port =3D sas_port_alloc_num(mr_sas_node->parent_dev);
> +	if (!port) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;

[Severity: High]
Does this error path leak the tgtdev reference and leave its state corrupte=
d?

Earlier in the function, if the device type is SAS_END_DEVICE, tgtdev is
acquired via mpi3mr_get_tgtdev_by_addr() and its pend_sas_rphy_add flag
is set to 1:

	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
		tgtdev =3D mpi3mr_get_tgtdev_by_addr(mrioc, ...);
        ...
		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add =3D 1;
	}

The success path correctly resets this state and drops the reference via
mpi3mr_tgtdev_put(tgtdev). However, the newly added error paths jumping
to out_fail bypass this cleanup, which leaves the reference leaked and the
pend_sas_rphy_add state inconsistent.

> +	}
> +
>  	if ((sas_port_add(port))) {
>  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
>  		    __FILE__, __LINE__, __func__);
> +		sas_port_free(port);
> +		port =3D NULL;
>  		goto out_fail;
>  	}
> =20

[ ... ]

> @@ -1455,6 +1463,19 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add=
(struct mpi3mr_ioc *mrioc,
>  		rphy =3D sas_expander_alloc(port,
>  		    mr_sas_port->remote_identify.device_type);
>  	}
> +
> +	if (!rphy) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		list_for_each_entry(mr_sas_phy, &mr_sas_port->phy_list, port_siblings)=
 {
> +			mr_sas_phy->phy_belongs_to_port =3D 0;
> +			mr_sas_phy->hba_port =3D NULL;

[Severity: High]
Does clearing hba_port here corrupt the SAS PHY topological state?

The hba_port field appears to be persistently assigned to underlying PHYs
during discovery. It is required and used earlier in this function to match
phys to ports:

	for (i =3D 0; i < mr_sas_node->num_phys; i++) {
		if ((mr_sas_node->phy[i].remote_identify.sas_address !=3D
		    mr_sas_port->remote_identify.sas_address) ||
		    (mr_sas_node->phy[i].hba_port !=3D hba_port))
			continue;

If this error cleanup loop unconditionally sets hba_port to NULL, won't it
permanently prevent these PHYs from being matched or added to an HBA port in
future discovery cycles?

> +			sas_port_delete_phy(port, mr_sas_phy->phy);
> +		}
> +		sas_port_delete(port);
> +		goto out_fail;

[Severity: High]
Similar to the sas_port_alloc_num() failure above, jumping to out_fail here
also bypasses the cleanup of the tgtdev reference and pend_sas_rphy_add.

> +	}
> +
>  	rphy->identify =3D mr_sas_port->remote_identify;
> =20
>  	if (mrioc->current_event)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817052619.8107=
62-1-triet.hoang.dev@gmail.com?part=3D1
