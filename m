Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E011F1513
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783404929; cv=none; b=CjFHSW+TDAGbl+fiy+3IT5ePS8OBmJlIztqTad6YZPyNletTluIPrFRI7WmYq4bOuXeiLkC5Q61beq00trlkGDMwn50NipYABf0YLn6zPQOIKRvNzhPxlnaT6HxK5Q5Lr7Fa91AJtGnSsNXoFIQoHEvlS1Sd7+g55uNd1/C7uJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783404929; c=relaxed/simple;
	bh=d0EGFf3/hItkxU++1IzsnJfHX0gNMX5IqVSO7KA0xMY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RmLHl4RB7CdPw3UxIPNmf3Xbu5kbH/bl7Ggm0b/KFJ0mCWWbI5Zxh/qTyHwGV17y0GhqpnOyMosajF8Dwj6BBGDvf2QWI1T4wsXsGL1A4JrKFrcBqbhiIb1XoolOFqGS901PvVxVJQ35lUSA6cvbxFgnvIoAMiRki8k0yiASNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n2GpyO+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n2GpyO+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847BA1F000E9;
	Tue,  7 Jul 2026 06:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783404927;
	bh=QnwMrR6etf0h3M9HiBU0ZrPRxqilwzQSCezdPRFyOpo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n2GpyO+7PEC1FBdVHbauzxlIThfKUQnmPvDmuhnXhR+GMbxDvjq/50Jntt5V2d+v8
	 JJnssU0a5KoIb0e2AwgP5TyaXJWe4ZuvhCRqhO+U3K8/eHw1jQKeDRfiyb3hTFd0Ng
	 Ld30+U2hVncB0FDo7vMPS1qblrGiEVGa3WqqsnO7k+NyQ6YroKV0AW16UVDsjivOmL
	 A2+5MWzGf+ixT3+ilfNcWCEm8lWLBnFMqOVrsdoNUDn0PqIVe2UXSi6mesq+bRtuBh
	 1W7JPUjlLXKDD2tYNcOao3EerDfQdumguAZHrjiECqP649zlUblvM/wk6eyLVRfyhR
	 PlQwdFsoxJtjg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 18/88] scsi: qla2xxx: Enable get_firmware_state for
 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-19-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-19-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:15:27 +0000
Message-Id: <20260707061527.847BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Retry block in qla2x00_fw_state_show() defeats chip_is_down protec=
tions, issuing mailbox commands to unstable hardware without a lock.
--

--- Patch [18]: [PATCH v3 18/88] scsi: qla2xxx: Enable get_firmware_state f=
or 29xx ---
commit ebf2e3d4435e44a4b6998187bcd7eea09d19c1be
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable get_firmware_state for 29xx

Enable get_firmware_state mailbox command for 29xx adapters by adding
IS_QLA29XX() checks alongside existing IS_QLA27XX/IS_QLA28XX checks.
This ensures MBX_12 (MPI state) is properly set up and reported for
29xx adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 7b7722de28444..5a934f40323e6 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2436,7 +2436,7 @@ qla2x00_mpi_fw_state_show(struct device *dev, struc=
t device_attribute *attr,
>  	u16 mpi_state;
>  	struct qla_hw_data *ha =3D vha->hw;
> =20
> -	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha)))
> +	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)))
>  		return scnprintf(buf, PAGE_SIZE,
>  				"MPI state reporting is not supported for this HBA.\n");
> =20

[Severity: High]
This isn't a bug introduced by this patch, but while reviewing the use of
qla2x00_get_firmware_state() in this file, I noticed a potential problem in
qla2x00_fw_state_show() when an ISP reset is active.

In qla2x00_fw_state_show(), rval is initialized to QLA_FUNCTION_FAILED.
If the chip is down or eeh is busy, the code jumps to out:

drivers/scsi/qla2xxx/qla_attr.c:qla2x00_fw_state_show()
	int rval =3D QLA_FUNCTION_FAILED;
	...
	mutex_lock(&vha->hw->optrom_mutex);
	if (qla2x00_chip_is_down(vha)) {
		mutex_unlock(&vha->hw->optrom_mutex);
		ql_log(ql_log_warn, vha, 0x707c,
		    "ISP reset active.\n");
		goto out;
	} else if (vha->hw->flags.eeh_busy) {
		mutex_unlock(&vha->hw->optrom_mutex);
		goto out;
	}

	rval =3D qla2x00_get_firmware_state(vha, state);
	mutex_unlock(&vha->hw->optrom_mutex);
out:
	if (rval !=3D QLA_SUCCESS) {
		memset(state, -1, sizeof(state));
		rval =3D qla2x00_get_firmware_state(vha, state);
	}

Because rval is still QLA_FUNCTION_FAILED when the goto is taken, the check
at out: evaluates to true.

Does this unintentionally force a mailbox command to be issued to the
resetting device anyway, without holding the optrom_mutex lock?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D18
