Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2613642AF84
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820521; cv=none; b=tu56UvGc9uSsTik/b3e6CJlSg1RwfO/JYz0laKmSq/Q4CcUNy8PJf7iZvZ/1vJ6izTjVkJ47OP+B+f3XZH/YubatCSAoaacrX7w9l5D53VjAjMstGtDF42jMo2OzuwXHYe/OAOoOzRIkZZOWLpMINKPU8H+pB09ddjhuv331U10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820521; c=relaxed/simple;
	bh=9I7xWu1j0VhdxiT5C23LY+04RsBVE1QEMbpwmrimLBw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Gppg/IiywBXVkwMb6M4oC0aGsnmEdH4SYLHcJGfjQcIdkQSWOirtrAQAJ4drJIydSyTKLi2DqSDqy1KgLhNf993QWis7qR+ScpnSPLBcUXbZH4s2U+yMWty9F/mpGnwDPmHPsD0Oj7peaHcpIeKEzllvJbRTeKW2Ty5gAm5JJgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvqtFyIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvqtFyIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899861F00A3A;
	Thu, 23 Jul 2026 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784820519;
	bh=+nqnRBL2jFlkAxkfY85rjWwWE58mUfEFw9biofPiHlw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lvqtFyILdPDaLcgC//e+I8apGZ31pjsBE325Z9fxtK++Tz1FHISUni//ExOXtVzG5
	 jYHgqTXouc/zN8F9tXuVXOn53W0bh0gCxQOSYXVcM09IF3izlfUgGPocCOMMCBwR0s
	 H9+MZs8zILCJGPHv6nyXoiUP8Qv8Kf1hzbLqyjDT1QnNIUZZQhoQbLg3qCyCnwTDgq
	 +hIP/IIm0xGLxD95mm2Bjb60Bq3UDvC5wplHCuyxkflDcbrCqsDoLdZfs0knvnA/aC
	 wq5CWjh1tZDRTY3Cf4WzlhSV6tnuSy8VcXW5tMGLbT5f3GyWBbrPPzHV+VT7xcp85g
	 6r2U6KKwsmE4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 33/56] scsi: qla2xxx: Add abort command handling for
 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-34-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-34-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 15:28:39 +0000
Message-Id: <20260723152839.899861F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Potential use-after-free of the original SRB (`orig_sp`) during as=
ynchronous abort completion if the original command completes concurrently.
--

--- Patch [33]: [PATCH v6 33/56] scsi: qla2xxx: Add abort command handling =
for 29xx series ---
commit 7e8bef4c0a160dfafa23b4b48905c50cc258d592
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add abort command handling for 29xx series

Extend the abort-IOCB code path to support the 29xx extended
abort_entry_24xx_ext structure alongside the existing abort_entry_24xx.

> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3973,7 +3973,14 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, str=
uct req_que *req,
>  		return;
> =20
>  	abt =3D &sp->u.iocb_cmd;
> -	abt->u.abt.comp_status =3D pkt->comp_status;
> +	/*
> +	 * abort_entry_24xx_ext overlays abort_entry_24xx through the
> +	 * nport_handle/comp_status union at offset 8, so reading
> +	 * comp_status is stride-agnostic and goes through the 24xx view.
> +	 */
> +	abt->u.abt.comp_status =3D
> +	    ((struct abort_entry_24xx *)pkt)->comp_status;
> +
>  	orig_sp =3D sp->cmd_sp;
>  	/* Need to pass original sp */
>  	if (orig_sp)

[Severity: High]
This isn't a bug introduced by this patch, but can orig_sp be accessed after
it has been freed here?

If an asynchronous command (e.g., SRB_LOGIN_CMD) times out, the timeout han=
dler
qla2x00_async_iocb_timeout() creates an abort SRB holding a pointer to the
original SRB (abt_sp->cmd_sp =3D sp) without incrementing its kref. It then
drops its timer reference on the original SRB.

If the firmware completes the original command concurrently, the ISR will
process the completion and drop the initial reference. This can drop the
refcount to 0, freeing the original SRB.

Later, when the abort IOCB completes, qla24xx_abort_iocb_entry() reads
orig_sp =3D sp->cmd_sp (which now points to freed memory) and passes it to
qla_nvme_abort_process_comp_status(), where dereferencing orig_sp->fcport or
orig_sp->type would cause a use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D33
