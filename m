Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFE187346
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786095043; cv=none; b=BgzvZtBc/Nn8/dDmKFhHiMorF7qw6CtMIL1UVf9/0h9dBiv57RKIgTGVBLCZWZaR0r39ffM2rEBlds2XBuco2LseXI+fpiu2wvgEpGGnUaPxRXsCDPmSReMhIsRmUS3hgCDbBj2SCoPSmDpGds6KQNKpgo/FVKvIN0UA/7cE/50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786095043; c=relaxed/simple;
	bh=5z5Al+aFkqVIVi5uiNZ1ab7odS3vW4DyNXDMyVI/poc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=poOp+8+9y32XMPBY9vY/PbfsW6ByCwUGD5OG/9nCV6uSgUjvYhDn1Sp2QTQeB71eqWBBf79x45rMJhh3AJTtJWixNJv/Cfgjk4Vx8GV8CQfcsP4ZP/CQ06e8TnWnT03heBXDN6gYA06dxzPl+g49g+Tg/TBnFZDLvbpDdZcGeYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NH3Oi2qk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NH3Oi2qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAC01F000E9;
	Fri,  7 Aug 2026 09:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786095042;
	bh=SdtCz6OCcIYN5iUAu2MATzjZx955Px6DFVTM/9rZuk4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NH3Oi2qkFWfk5jLr1purk8PWMdoH1RHA7NpN/gmFi7HrJQoQzz5J8bG+oqd5sC+ko
	 +2hq5KFZaROzL3OYoTjcQCSON3KmfqOk/DfPqhaLGd7cz6sq5w7YewCXn5T6Wzyfq3
	 k1I2UXNx2GCpplccew2nCXkI0yihBzJknlYcC744BuG8ds4FjhulUhBvCqziWkNXKK
	 M9ssNC4YGSXXhliQj5MzA46zTZthLIozewc+GSHd66puocP1Yd1rJyzWFY3bx11AKF
	 SACwdziv7Uz275nejQd5mXPuS5qJJ1Ab1SWldmybjFZ4sWX7hupit2zI3erWA56DKa
	 AuxhWa87QHXzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: fnic: Fix invalid comparison for error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Roman Demidov" <roman.demidov.nn@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260807091852.13151-1-roman.demidov.nn@gmail.com>
References: <20260807091852.13151-1-roman.demidov.nn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 09:30:39 +0000
Message-Id: <20260807093040.DCAC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] vnic_dev_cmd1 accesses the dev_cmd_err array without bounds checki=
ng when the firmware returns an error code >=3D 5.
- [High] In vnic_dev_cmd2, raw firmware error codes are directly negated an=
d returned instead of being mapped to standard POSIX error codes.
- [High] In the snic driver, snic_probe can return a positive error code on=
 initialization failure, which the PCI core incorrectly treats as success.
- [High] Missing read memory barrier before reading result->error from the =
DMA completion ring.
--

--- Patch [1]: [PATCH] scsi: fnic: Fix invalid comparison for error ---
commit 4766be03a478e92b3d109e47a930854c49255b49
Author: Roman Demidov <roman.demidov.nn@gmail.com>

scsi: fnic: Fix invalid comparison for error

This patch fixes a logical flaw where an error comparison against a positive
constant always evaluated to true. It corrects the check to use the negated
error constant instead.

> diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
> index 991c86eb5aff7..0e5ae0540d85f 100644
> --- a/drivers/scsi/fnic/vnic_dev.c
> +++ b/drivers/scsi/fnic/vnic_dev.c
> @@ -381,7 +381,7 @@ static int vnic_dev_cmd2(struct vnic_dev *vdev, enum =
vnic_devcmd_cmd cmd,
>  		if (result->color =3D=3D color) {

[Severity: High]
This is a pre-existing issue, but is a read memory barrier needed before
accessing result->error?

When the CPU polls DMA memory for completion by checking the color flag, it
immediately reads the error field.

Without an rmb() between these two reads, could weakly ordered CPUs
speculatively read the error field before the color check is verified in
memory, potentially processing a stale error code from a previous command
completion?

>  			if (result->error) {
>  				err =3D -(int) result->error;

[Severity: High]
This isn't a bug introduced by this patch, but does this correctly map to
standard Linux error codes?

Unlike vnic_dev_cmd1() which translates firmware errors using the dev_cmd_e=
rr
array, vnic_dev_cmd2() negates the raw firmware error code.

For example, returning a negated ERR_EBUSY (4) results in -4 (-EINTR)
instead of -16 (-EBUSY).

Could this cause callers that check for standard POSIX errors, such as
checking for -EBUSY in fnic_nvme.c, to bypass necessary retry logic because
the error value does not match?

> -				if (err !=3D ERR_ECMDUNKNOWN ||
> +				if (err !=3D -ERR_ECMDUNKNOWN ||
>  						cmd !=3D CMD_CAPABILITY)
>  					pr_err("%s:Error %d devcmd %d\n",
>  						pci_name(vdev->pdev),

[ ... ]

[Severity: High]
This is a pre-existing issue, but I noticed a potential out-of-bounds read
elsewhere in this file in vnic_dev_cmd1():

drivers/scsi/fnic/vnic_dev.c:vnic_dev_cmd1() {
        ...
        if (status & STAT_ERROR) {
                err =3D dev_cmd_err[(int)readq(&devcmd->args[0])];
        ...
}

If the hardware returns an unexpectedly large error code, the raw value is
cast to an integer and used as an index into the 5-element dev_cmd_err array
without any bounds validation.

Can this arbitrary hardware input cause an out-of-bounds read into unmapped
kernel memory, resulting in a panic?


[Severity: High]
This is a pre-existing issue, but I noticed similar firmware error handling
in the snic driver that may cause problems during initialization.

In _svnic_dev_cmd2(), raw firmware error codes are returned as positive
integers:

drivers/scsi/snic/vnic_dev.c:_svnic_dev_cmd2() {
        ...
        if (result->error) {
                err =3D (int) result->error;
                ...
                return err;
        }
        ...
}

If device initialization fails, this positive error propagates up and is
returned by snic_probe().

Since the PCI subsystem treats return values greater than zero as success,
does this cause the core device model to incorrectly bind the device even
though snic_probe() executed its error teardown path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807091852.1315=
1-1-roman.demidov.nn@gmail.com?part=3D1
