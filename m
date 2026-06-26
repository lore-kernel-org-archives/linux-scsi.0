Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E6A3F44D9
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 12:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475606; cv=none; b=NHC6mNrGzb63358B8uneLou/LF8eVVRQaC9pLWqVhTgl2H2niLMx2thv22LAv7K7L+8Ssqfyshs0TW4muEmCam8DMpJVrxjhM//3sztgvUt0Nyq8SmoBvzJfl460y9+pdVz9NIJ6G58n8eEC2vqOcDx5UahMno5QyaR1n0Dlxeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475606; c=relaxed/simple;
	bh=iEDlDi8VQlaNT7MCKws944Vbm857PVlmOHDSaBXd9ko=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ifXSrcRSFUDJj6XSlsvHTcFaJrbx181eejgr7OG2owukX/fbZPsX+1+sc4Y2fRTBnYCH7u+8D6f1jay6KJGeKa7Ne2UylAnsL58u1KhKgdWZgPfLWAbz0AkmCglUjD8IGLUAyYQ1s058ZsQi5DESX9DyvN+/fDJ3LTk3NSqoPrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lN0QvFLV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lN0QvFLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027D61F000E9;
	Fri, 26 Jun 2026 12:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475605;
	bh=VcfJt2aWOMDIBxRUaIvE6WJH/kCctxpZ+j1kKXGnmdc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lN0QvFLVNyCioFP936oA/nKjpr4kxS3AHXLpykQi7EPKpTEjDdsQLATuE2Dpnc6z1
	 e0LXBzEZhOkQ5to7VmETPvWyqsAWhhqPGn7/MrM8gADb/qxOBLRpNn+iAn8b++41Mp
	 ef09WWHTO8W5C4jjk3Ld6NsmOCn+7EOV1f3usJqq5EMttzG75xF+bT3KumP0AFlg9V
	 Zp0S3InWdVM1H5ZztexyEI/dNWnPxamAVJ4FSTfOA66fbPDSr0jUnlEFxqdSVrMJhC
	 NSblz/Q6d0q05zgFn0MhLH8wsxEyka37Vp96yJonsSUYmlGC7AG/5pG15oShx1viW0
	 CCDwB5IEVeJ+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 08/10] mpi3mr: Fix SAS port allocation and
 registration error handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626114109.43685-9-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
 <20260626114109.43685-9-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 12:06:44 +0000
Message-Id: <20260626120645.027D61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The reference to the target device (`tgtdev`) is leaked and the `p=
end_sas_rphy_add` state remains inconsistent on error paths.
- [High] Missing NULL pointer check after `rphy` allocation leads to a guar=
anteed NULL pointer dereference on allocation failure.
- [High] Failure of `sas_rphy_add()` is ignored, leaving the driver and dev=
ice model in an invalid state.
--

commit 2228b7db89a5c405d93e9a1b01afe8d02a73da5c
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix SAS port allocation and registration error handling

During SAS port creation, the driver does not verify successful port
allocation before attempting registration, which can lead to a NULL
pointer dereference. Additionally, if registration fails, the allocated
port is not freed, resulting in a memory leak.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..1b793d86f7589 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add=
(struct mpi3mr_ioc *mrioc,
>  	}
> =20
>  	port =3D sas_port_alloc_num(mr_sas_node->parent_dev);
> +	if (!port) {
> +		ioc_err(mrioc, "failure at %s:%d/%s() (sas_port_alloc)!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;

[Severity: High]
This is a pre-existing issue, but does jumping to out_fail here leak the
tgtdev reference?

If mpi3mr_sas_port_add() is called for a SAS_END_DEVICE, it acquires a
reference to tgtdev earlier in the function:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
    if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
        tgtdev =3D mpi3mr_get_tgtdev_by_addr(mrioc,
            mr_sas_port->remote_identify.sas_address,
            mr_sas_port->hba_port);
    ...
}

When sas_port_alloc_num() fails and the code jumps to out_fail, it frees
mr_sas_port but misses the necessary mpi3mr_tgtdev_put(tgtdev) cleanup:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
 out_fail:
    list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
        port_siblings)
        list_del(&mr_sas_phy->port_siblings);
    kfree(mr_sas_port);
    return NULL;
}

Will this lead to a resource leak of the tgtdev structure that prevents
device removal?

> +	}
>  	if ((sas_port_add(port))) {
>  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
>  		    __FILE__, __LINE__, __func__);
> +		sas_port_free(port);
>  		goto out_fail;

[Severity: High]
This is a pre-existing issue, but this path also appears to leak the tgtdev
reference in the same way as described above when sas_port_add() fails.

>  	}

[Severity: High]
This is a pre-existing issue, but can this function unconditionally
dereference rphy if the allocation fails?

Further down in mpi3mr_sas_port_add(), rphy is allocated but immediately
dereferenced without a check:

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

If sas_end_device_alloc() or sas_expander_alloc() return NULL under memory
pressure, wouldn't the assignment to rphy->identify cause a kernel panic?

[Severity: High]
This is a pre-existing issue, but is the driver left in an invalid state if
sas_rphy_add() fails?

Later in the same function, the return value of sas_rphy_add() is caught
but ignored:

drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add() {
    ...
    if ((sas_rphy_add(rphy))) {
        ioc_err(mrioc, "failure at %s:%d/%s()!\n",
            __FILE__, __LINE__, __func__);
    }
    ...
}

If sas_rphy_add() fails, does the driver leak the rphy memory since
sas_port_delete() won't free it if it wasn't successfully added?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626114109.4368=
5-1-ranjan.kumar@broadcom.com?part=3D8
