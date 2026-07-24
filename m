Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B81A3F1AB4
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889890; cv=none; b=urEaurO/L0cMIHpZ10oKHMpuSNUawozwnQ7H4yuNKzVW+rEjPi9o9/qxhlvrO+lq75SxWaU2HIAoTjtmzQrPXhhk3aEwcv6kLAGPJFj5pSI9bvokLWnMhqZ7ojzYB42gPiRDgcyFVNwA/znMyXPQVQZe15JNtvRLAsHOBqB7ymM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889890; c=relaxed/simple;
	bh=/Zx6GiRpy4gJDMmE20/lmoYuXOdl5jRLuetavSW9bo0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NLJghJliTavNlBbGfNAiphpOt95veL5r7vdEmTATFwtNbeK4HP7KcqanAEm1lv5Sw+EzXZGpDBVsSsbJm7vYQ1QjLSNJmTplmDIwO6K/wOBNZIPUmdcsOCXEaXgO1sZfe/6XiIY6lC31bbb6BIs4SP93QXPWVC/TozU6WUqp1dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OeQUPXSd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OeQUPXSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D646D1F000E9;
	Fri, 24 Jul 2026 10:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784889889;
	bh=06Gip00aXbjqTa/Eh3KoKrhYdb8uGrJ+3XrQnZjGx9I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OeQUPXSd1UZjimqfb1CZUEteGkgpSh3rvY3a2RHKEvZtPx8fcyZk2RRtA0Y9PW6Y6
	 jQ13Bq6FU8pmhOm3dTlHg9IIJmzcftX2YBOKDs3P81kbw0A0dxwOk6Y3tuHuc6rhzr
	 1gq64EdKR6If0POKG7b0i7el+b7ggnOtEi+GHgImRSKQF4vf1saLzhWpfqqaU50Fpk
	 CmMaPGfeOY05tPxRyqYj9O1NOuoJaaFuvPeO23PsZGSdBTjA3y879iINW2aIHlvZrA
	 x2MujjK8sj/ffvk6Or6gTJLPPzFJpShTnAf2qVx8hs6IJWQXuEm16aGnYsGOE1FV0W
	 T0KLfCR5GZ5RA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/10] mpi3mr: Fix NVMe page size caching for
 non-operational devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724102505.115136-5-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
 <20260724102505.115136-5-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 10:44:48 +0000
Message-Id: <20260724104448.D646D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Double-write of `reset_to` and `abort_to` timeouts introduces a =
race condition where concurrent readers may observe a reduced default timeo=
ut.
- [Medium] The bounds check for `page_size` accepts invalid NVMe page size =
shifts (1 to 11), which causes management IOCTL validation to fail before r=
eaching the firmware.
--

--- Patch [4]: [PATCH v3 04/10] mpi3mr: Fix NVMe page size caching for non-=
operational devices ---
commit b27f8d86d47076feb2c7ac1adf8a15a3291cf854
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix NVMe page size caching for non-operational devices

This commit populates the NVMe page size attribute for devices in an error
state so management IOCTLs can reach the firmware. It adds bounds checking
for page_size and initializes reset_to and abort_to with default values.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D4
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar=
@broadcom.com?part=3D4

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index d2a20f2721dbf..7b86152922bad 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1354,12 +1354,16 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_io=
c *mrioc,
>  		tgtdev->dev_spec.pcie_inf.capb =3D
>  		    le32_to_cpu(pcieinf->capabilities);
>  		tgtdev->dev_spec.pcie_inf.mdts =3D MPI3MR_DEFAULT_MDTS;
> -		/* 2^12 =3D 4096 */
> -		tgtdev->dev_spec.pcie_inf.pgsz =3D 12;
> +		tgtdev->dev_spec.pcie_inf.reset_to =3D MPI3MR_INTADMCMD_TIMEOUT;
> +		tgtdev->dev_spec.pcie_inf.abort_to =3D MPI3MR_INTADMCMD_TIMEOUT;

[Severity: Medium]
Can a concurrent reader observe the intermediate default timeout values her=
e?

If a Task Management Request (via mpi3mr_issue_tm()) executes concurrently
with a DevStatusChange event processed by mpi3mr_devinfochg_evt_bh(), it mi=
ght
read these prematurely shortened 60-second timeouts.

Since mpi3mr_update_tgtdev() modifies tgtdev without holding tgtdev_lock, t=
he
reader can observe this intermediate value before it is overwritten with the
final firmware-provided timeout a few lines further down. This could cause
the command to time out early and trigger an unintended full controller res=
et.

> +		/* Validate firmware page size to prevent undefined shift behavior */
> +		if (pcieinf->page_size > 0 && pcieinf->page_size < 31)
> +			tgtdev->dev_spec.pcie_inf.pgsz =3D pcieinf->page_size;

[Severity: Medium]
Does this bounds check accept values that are logically invalid for NVMe
memory page sizes?

If the firmware provides corrupted device page0 data with a page_size betwe=
en
1 and 11, this condition incorrectly accepts it.

Later, when an application issues an IOCTL, the PRP builder in mpi3mr_app.c
evaluates dev_pgsz =3D 1 << pgsz to a small value (e.g., 2 to 2048 bytes). =
This
fails size constraints and rejects the IOCTL before it reaches the firmware,
returning incorrect errors to userspace.

> +		else
> +			tgtdev->dev_spec.pcie_inf.pgsz =3D 12; /* Default to 4096 (2^12) */
>  		if (dev_pg0->access_status =3D=3D MPI3_DEVICE0_ASTATUS_NO_ERRORS) {
>  			tgtdev->dev_spec.pcie_inf.mdts =3D
>  			    le32_to_cpu(pcieinf->maximum_data_transfer_size);
> -			tgtdev->dev_spec.pcie_inf.pgsz =3D pcieinf->page_size;
>  			tgtdev->dev_spec.pcie_inf.reset_to =3D
>  			    max_t(u8, pcieinf->controller_reset_to,
>  			     MPI3MR_INTADMCMD_TIMEOUT);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724102505.1151=
36-1-ranjan.kumar@broadcom.com?part=3D4
