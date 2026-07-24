Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E238427FA8
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784890737; cv=none; b=c6Xe5p7tlY+Jb2Ypl/tj8QWHeb563NOIHDnYrYhbn5kOBKnWJCzqJIRwzfWcAKxad1iyHwrZHqZWt8BWmTLSOodfovNFcNVjzhf84jr3xmhcOgGIMuuYUtnfLEF7e28HsTFqUYsG9gUQ9dPYkJ/ldcqaXeOiLC99QCj6mCIbSxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784890737; c=relaxed/simple;
	bh=w1aRs7AlKRdx4MrNZlw/FfpiHy0rnHcDs3C8SMPC8eI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dWUiFPyU1iTE4XZZeJ6UbFZxGBy9yumwtUpLHdXfJnbF4S7wWWNg4Wz8ggUIH9mIZQGUhL0yUZmfmKUbBr2zu7sLHIEi9pMOdGpN42AFiOYu+iWLkNHaVFVYfTTiBjsaMCSg/5PkS9l5T5N5OdLjx9PhPfIHKqf/z2E+bTFLAmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxdTbF/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxdTbF/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5051F01570;
	Fri, 24 Jul 2026 10:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784890736;
	bh=ecGok2bXeftmAEPbj6vvT9ZwvOOjUIHvoRTE0/6WwmI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nxdTbF/z1iycmFKqf1QRT1sYbqCWHdGq3y2TeWEVNWPuP/6pZu6+1zTS/p50c4G/j
	 Ph7pRQrkyA+CB32uUeP37nAJ7U7I8NvJGlLSC3xljirVoT2RbNj93LCGP/tnvtOv1c
	 ngWHLqBUZleOcejk19s2d+Y9yTzDx8hxQ2xdhWMWfzUEoOJkQFnN43UXGlUgBJ/vlk
	 g2ufZXrYAxBmsVOWyN8rwsiPGfvoZ72AmHdSnHe2kNp40W1V//+Jid31ZNOpcGxgld
	 fOzoHgRcVvI1VTEyclMt6dV4c1nkfdsZsaooCo5Vtr0gjogZlLgZacFIBHrTrRB9/Z
	 Z/0g0XiWfMN6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/10] mpi3mr: Fix SAS port allocation and
 registration error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724102505.115136-9-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
 <20260724102505.115136-9-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 10:58:55 +0000
Message-Id: <20260724105856.0F5051F01570@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Calling `sas_port_delete()` when `sas_rphy_add()` fails causes=
 a fatal `device_del()` on an un-added device.
- [High] The target device structure retains a dangling pointer to a freed =
`rphy` and a stale `pend_sas_rphy_add` flag if `sas_rphy_add()` fails.
- [High] Failure to clear `mr_sas_phy->phy_belongs_to_port` on error paths =
causes phys to be permanently orphaned.
--

--- Patch [8]: [PATCH v3 08/10] mpi3mr: Fix SAS port allocation and registr=
ation error handling ---
commit 196b5015246a90c5d75f6d4437141992643236da
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix SAS port allocation and registration error handling
   =20
During SAS port creation, the driver does not verify successful port
allocation before attempting registration, which can lead to a NULL
pointer dereference. Additionally, if registration fails, the allocated
port is not freed, resulting in a memory leak.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D8
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D8

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
[ ... ]
> @@ -1450,10 +1456,22 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_ad=
d(struct mpi3mr_ioc *mrioc,
>  	mr_sas_port->port =3D port;
>  	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
>  		rphy =3D sas_end_device_alloc(port);
> +		if (!rphy) {
> +			ioc_err(mrioc, "failure at %s:%d/%s() (sas_end_device_alloc)!\n",
> +			    __FILE__, __LINE__, __func__);
> +			sas_port_delete(port);
> +			goto out_fail;
> +		}
>  		tgtdev->dev_spec.sas_sata_inf.rphy =3D rphy;
>  	} else {
>  		rphy =3D sas_expander_alloc(port,
>  		    mr_sas_port->remote_identify.device_type);
> +		if (!rphy) {
> +			ioc_err(mrioc, "failure at %s:%d/%s() (sas_expander_alloc)!\n",
> +			    __FILE__, __LINE__, __func__);
> +			sas_port_delete(port);
> +			goto out_fail;
> +		}
>  	}
>  	rphy->identify =3D mr_sas_port->remote_identify;
> =20
> @@ -1463,6 +1481,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(=
struct mpi3mr_ioc *mrioc,
>  	if ((sas_rphy_add(rphy))) {
>  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
>  		    __FILE__, __LINE__, __func__);
> +		sas_port_delete(port);
> +		goto out_fail;

[Severity: Critical]
This is a pre-existing issue, but does calling sas_port_delete() here cause=
 a
fatal device_del() on an un-added device?

When sas_rphy_add() fails, it will have already internally set port->rphy =
=3D rphy
before failing during device_add(). Because port->rphy is set,
sas_port_delete() invokes sas_rphy_delete(), which explicitly calls
sas_rphy_remove() and device_del(dev) on the rphy.

Calling device_del() on a device that was never successfully added via
device_add() violates the kobject API and can trigger a panic. Should we
call sas_rphy_unlink(rphy) and sas_rphy_free(rphy) before
sas_port_delete(port) instead?

[Severity: High]
This isn't a bug introduced by this patch, but could this error path leave
dangling pointers in the tgtdev structure?

Before calling sas_rphy_add(), the rphy pointer is cached in the target
device structure:

mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
    if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
        ...
        tgtdev->dev_spec.sas_sata_inf.rphy =3D rphy;
    }
    ...
}

If we jump to out_fail when sas_rphy_add() fails, we clean up the rphy
indirectly via sas_port_delete(), but tgtdev->dev_spec.sas_sata_inf.rphy
still points to the freed memory, and pend_sas_rphy_add remains set to 1.

Could a future allocation reuse this memory and cause functions like
__mpi3mr_get_tgtdev_by_addr_and_rphy() to incorrectly match the corrupted
state?

>  	}
>  	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
>  		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add =3D 0;
> @@ -1498,6 +1518,9 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(=
struct mpi3mr_ioc *mrioc,
>  	return mr_sas_port;
> =20
>   out_fail:
> +	if (tgtdev)
> +		mpi3mr_tgtdev_put(tgtdev);
> +
>  	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
>  	    port_siblings)
>  		list_del(&mr_sas_phy->port_siblings);

[Severity: High]
This is a pre-existing issue, but might this error path fail to clear the
phy_belongs_to_port flag, causing phys to be permanently orphaned?

During port addition, mr_sas_phy->phy_belongs_to_port is set to 1 for all
elements in mr_sas_port->phy_list. When we reach out_fail, we remove the
PHYs from the sibling list:

mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
 out_fail:
    ...
    list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
        port_siblings)
        list_del(&mr_sas_phy->port_siblings);
    ...
}

Because the underlying mr_sas_phy structures persist in mr_sas_node->phy[],
failing to reset the flag means they will permanently claim to belong to a
port. Will future attempts to add these PHYs fail as a result?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724102505.1151=
36-1-ranjan.kumar@broadcom.com?part=3D8
