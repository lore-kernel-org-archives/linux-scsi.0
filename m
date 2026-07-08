Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E241343933C
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 19:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783538306; cv=none; b=ceF7fPZZ5CKO19F8wqvtCVboTsN1Vg9952dXYOfbU8kfafJsI6y4xvxW7Y4MoyUzMs5WcEv1Ck6QQfA0uUr9lxrZEiFt6XSdVTGrZIniJ5HmD3DJh9SYqt1cO1rakuZRUSfzP4/KeSA75clYM7Rvzf9D0lkddZUEyvsiW1rAKAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783538306; c=relaxed/simple;
	bh=EgHYVyzl2pOBaKjiW9vaLdgz6EdEhpMBNFqEtXbdUOU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Fyg/cDqdOvf1kGXKC3BGSVv73O1ksy5uFYgQlgqK4CTBKkMmMtkvt2i6qnx2N2ffRqKvTqm3yAXb8YsAhu7f5/TgyeO7nx9PquwwOgDWAYyiO6mFGBzlHz9Z60cpc1HLVwqMp5n5wvPw1DH+1QDDMoAaDAhj45J3qL3S5LqGZDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iGl09Zsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iGl09Zsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5AC1F00A3A;
	Wed,  8 Jul 2026 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783538304;
	bh=YbhhdVLfuUVxCEE1+MBGTZnJIbK4C2gt8odeacmzEew=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iGl09ZspDKNJuDRSASWrqNSihVH/d1Ce6E8aUKp67o80SCFvuHPCf8/lKIE8pnocZ
	 2GTSDoku6N2PQZg5UVEwgkk5LXfr5viYQF5wHbY+SKc9DjWq3/ogSQBw3IFfcGyjGA
	 nhcL6v5cZi9fa2RcKjJgnysJJrN4gouLyqGh6b9yFZhc9HMwuL5b1qTjc5pOCQqTw9
	 9Ikncw3ITkW1Sl8R24GiYFh3g7p2K0PbXlSl/c8lvsDZIc/8aOgM39iaQxzNynupQD
	 N8KEvRLqWhGj8sYTEPgOu48c2eVox+kYSUk9tpYUSokMjZA1V8/JGrvrcbcrxt2HM9
	 HWo4v2McAFadw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/10] mpi3mr: Fix NVMe page size caching for
 non-operational devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260708183305.244485-5-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
 <20260708183305.244485-5-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 19:18:23 +0000
Message-Id: <20260708191824.5C5AC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `reset_to` and `abort_to` fields are left uninitialized for PC=
Ie devices in error states, causing task management commands to time out in=
stantly and trigger unintended full controller resets.
--

--- Patch [4]: [PATCH v2 04/10] mpi3mr: Fix NVMe page size caching for non-=
operational devices ---
commit a648ff0d4d5627aa485822e3033940c480028902
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix NVMe page size caching for non-operational devices

This patch populates the PCIe page size attribute for NVMe devices regardle=
ss
of their access status, ensuring management IOCTLs can reach the firmware.
It also adds bounds checking for the firmware-provided page size to prevent
undefined shift behavior, falling back to a default size if invalid.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D4

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index d2a20f2721dbf..df7365d19b44a 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1354,12 +1354,14 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_io=
c *mrioc,
>  		tgtdev->dev_spec.pcie_inf.capb =3D
>  		    le32_to_cpu(pcieinf->capabilities);
>  		tgtdev->dev_spec.pcie_inf.mdts =3D MPI3MR_DEFAULT_MDTS;
> -		/* 2^12 =3D 4096 */
> -		tgtdev->dev_spec.pcie_inf.pgsz =3D 12;
> +		/* Validate firmware page size to prevent undefined shift behavior */
> +		if (pcieinf->page_size > 0 && pcieinf->page_size < 31)
> +			tgtdev->dev_spec.pcie_inf.pgsz =3D pcieinf->page_size;
> +		else
> +			tgtdev->dev_spec.pcie_inf.pgsz =3D 12; /* Default to 4096 (2^12) */
>  		if (dev_pg0->access_status =3D=3D MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
>  			tgtdev->dev_spec.pcie_inf.mdts =3D
>  			    le32_to_cpu(pcieinf->maximum_data_transfer_size);
> -			tgtdev->dev_spec.pcie_inf.pgsz =3D pcieinf->page_size;
>  			tgtdev->dev_spec.pcie_inf.reset_to =3D
>  			    max_t(u8, pcieinf->controller_reset_to,
>  			     MPI3MR_INTADMCMD_TIMEOUT);

[Severity: High]
This is a pre-existing issue, but does exposing the device to IOCTLs by
setting the page size here unintentionally turn a device error into a full
controller reset?

When an NVMe device is in an error state (e.g., NEEDS_INITIALIZATION),
access_status !=3D NO_ERRORS, so reset_to and abort_to are left uninitializ=
ed (0).

With this patch populating pgsz for these devices, management IOCTLs can pa=
ss
the driver's PRP validation and reach the firmware. If the IOCTL times out
because the device is in an error state, the driver attempts recovery:

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_issue_tm() {
    ...
	if (tgtdev) {
		if (tgtdev->dev_type =3D=3D MPI3_DEVICE_DEVFORM_PCIE)
			timeout =3D cmd_priv ? tgtdev->dev_spec.pcie_inf.abort_to
					   : tgtdev->dev_spec.pcie_inf.reset_to;
    ...
}

Since reset_to and abort_to are 0, wait_for_completion_timeout() fails
instantly, causing the driver to falsely detect a TM timeout and
unconditionally execute mpi3mr_soft_reset_handler(), resetting the entire
controller.

Should reset_to and abort_to also be initialized with defaults even when the
device is in an error state to prevent routine monitoring tools from trigge=
ring
an HBA reset?

>  			tgtdev->dev_spec.pcie_inf.abort_to =3D
>  			    max_t(u8, pcieinf->nvme_abort_to,
>  			    MPI3MR_INTADMCMD_TIMEOUT);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708183305.2444=
85-1-ranjan.kumar@broadcom.com?part=3D4
