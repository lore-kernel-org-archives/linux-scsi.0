Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A807279DAF
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 10:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786531358; cv=none; b=UMp59lUaspEoTTkcU4y6DxUKJW9qVNuo5l3lQ4BmtdeBvFaAMUYSC4ZWbSUJLg1v8AwDSFW3J8XnVQdENtx6Sx9d0syMhBgzlVBaLvAc4o0QVSNmTBJhBi5tjSa1m9fbfa4CB62WQ9SUpqs7bS2zAdQ8ykRiaQortTduNedcrCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786531358; c=relaxed/simple;
	bh=/jKTHQVrEMsiYrWhyJ7HIl0SnzLfBarW/4A29e0tELM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o5gsSvaHvb8hL6++1DlbZXI3Ta2TuG8zeKSHtMSSNFhvmgPHRnpGWzn47j5H+Ivv+0PP6Oo+LO8xktaPaNTf32NnyvFgjmviq3ob7BUTHX3gJ1jgoOAdzn0CDaVwsJakAIGIzo454UKycn+/bVGOlNzILJ04vkh36nCnebDMCbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKcECKnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKcECKnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C561F000E9;
	Wed, 12 Aug 2026 10:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786531357;
	bh=BzMitb3rUYIAJDtjHuUFvuQF6hKej0Cn6f2RkS41yCI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PKcECKnVRdbKhsKA1LlN+/AW0GXehrm5155CAk6qDphCEvltrTRqaAApKRx10VNDQ
	 /5ieH/QE7HMsKcGCLuIzmWkor3VTAvT2HADAJL3QXVH1SKVGrmIZSU6ZI6x1SlT+bW
	 CTw4BKsGX4xXCihCzisV4V7kACtAs1mzNA2lPE7uMSVq4naIKPJ1TpJogXZpayd7eX
	 3sJNOlthpFkN4PpP6DsiYsv53t230G00ZuCa2ptV5KqaMBIl1MXK6DVTuUBFWRv3vn
	 IYaSvMKfKc62B/IS0j9vZmugAaOVdnv29YCrArnAicwwzoeHyczm26RaWHsWmtnlaO
	 V9t3T7G6rODJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: mpi3mr: Fix target device refcount leak in
 mpi3mr_sas_port_add()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812103344.174247-3-mgandhi@redhat.com>
References: <20260812103344.174247-1-mgandhi@redhat.com>
 <20260812103344.174247-3-mgandhi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 10:42:36 +0000
Message-Id: <20260812104237.04C561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing NULL check for the return value of sas_end_device_alloc() =
and sas_expander_alloc() leads to an immediate NULL pointer dereference.
- [High] Failure of sas_rphy_add() is ignored and does not abort the operat=
ion, leaving the driver state inconsistent and leaking rphy and port struct=
ures.
--

--- Patch [2]: [PATCH 2/2] scsi: mpi3mr: Fix target device refcount leak in=
 mpi3mr_sas_port_add() ---
commit 6d1c7833feb76d25951cbe5a46e2637e0f883658
Author: Milan P. Gandhi <mgandhi@redhat.com>

scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()

This commit fixes a reference count leak for target devices in
mpi3mr_sas_port_add() when an error triggers the out_fail path. It adds
a NULL-checked mpi3mr_tgtdev_put() call to ensure the device reference
is properly released during cleanup.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index ea2c04384a0e1..232af978d7372 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1507,6 +1507,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(=
struct mpi3mr_ioc *mrioc,
>  	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
>  	    port_siblings)
>  		list_del(&mr_sas_phy->port_siblings);
> +	if (tgtdev)
> +		mpi3mr_tgtdev_put(tgtdev);
>  	kfree(mr_sas_port);
>  	return NULL;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing the error
handling in this function, I noticed there is no check for the return value
of sas_end_device_alloc() or sas_expander_alloc() before dereferencing it:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
    if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
        rphy =3D sas_end_device_alloc(port);
        tgtdev->dev_spec.sas_sata_inf.rphy =3D rphy;
    } else {
        rphy =3D sas_expander_alloc(port,
            mr_sas_port->remote_identify.device_type);
    }
    rphy->identify =3D mr_sas_port->remote_identify;
    ...
}

If sas_end_device_alloc() or sas_expander_alloc() returns NULL due to
memory constraints, will the assignment to rphy->identify cause a NULL
pointer dereference? Could we add a check and jump to the out_fail path
here?

[Severity: High]
This is also a pre-existing issue, but I noticed the failure of
sas_rphy_add() does not abort the operation:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
    if ((sas_rphy_add(rphy))) {
        ioc_err(mrioc, "failure at %s:%d/%s()!\n",
            __FILE__, __LINE__, __func__);
    }
    if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
        tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add =3D 0;
        tgtdev->dev_spec.sas_sata_inf.sas_transport_attached =3D 1;
        mpi3mr_tgtdev_put(tgtdev);
    }
    ...
}

If sas_rphy_add() fails, the code merely logs an error but proceeds to mark
the transport as attached (sas_transport_attached =3D 1). Does this leave t=
he
driver state inconsistent and leak the rphy and port structures, since
teardown might attempt to remove a device that was never fully added?
Should this failure jump to an appropriate error handling label to unwind
the state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812103344.1742=
47-1-mgandhi@redhat.com?part=3D2
