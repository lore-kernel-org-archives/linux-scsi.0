Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD06C3E559F
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409301; cv=none; b=DDV6hvr/o3149UaAgHTd3S4DAy024CExA/J53uOKZGXAFGxFrCitP/D/M1TH99LFcVqejN24d+A4MK4u2SLO+xd2+1JxyUjolzM5ps6DzCgMn8d6VCByxCYmUasmX3LkLWGUiu32q8cdrFbGw0Gvrcns4lN/RV0pI0MT7nbjEbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409301; c=relaxed/simple;
	bh=dmdtXeauU8u9ZSzgQvaOkIrjOxoR4KxyHI8ae+ocO9Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qkQOFq6BE7wwAL/uXB46sHH85659lE4yw+MMSsecS2gfMiEthzuJuZVkBuF31Dm+QAi34wzfUdMXcEIfEQmobHwHWQbWoGAThfs3XNtMynXKsM7R/VViz2ygu+Co7Jv9H7Ey3Uhbiqqm0uV25ZxXOgVh9PJEwabZSVTRE+KIYDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0FtR0Lg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0FtR0Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669201F000E9;
	Tue,  7 Jul 2026 07:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409292;
	bh=E11Ke27/xlMTJv/52xu+V4NSeMwjSLrlBHppId0JG6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K0FtR0LgNdw2odQ6s/dtvPNPvhRMqgRSi9vlGz2j1mkChYEIvvES7GtvoImOr5ub3
	 XoGQklqasjdRkGpT6c7qpqE5yHL7j7bMDGhfmpQEniTaULz+s1CGzKEO/p+SJImjT2
	 CP7c42L799nUpj6xQIGBCI2hXJZfHVq9Mw9kIytrwKj6wPzE6pukW8F8kf6EIAR2y0
	 t+L5BPm5WcephHNXzoC+skCbx3a7NWJLr+lI50tXe33TEgz+wZ8/4nSmAniPSJnWgz
	 hukMBYdTAHchrODeYuEkCw4nq0bSrSxLGKtHJ48BtC3YNp5GQcHZbjrYefJJFVTaEW
	 5ENjrBxhJJtVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 78/88] scsi: qla2xxx: Hold vport_slock for host map
 update in report ID acquisition
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-79-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-79-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:28:11 +0000
Message-Id: <20260707072812.669201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix leaves physical port `host_map` updates unprotected=
 against concurrent btree corruption.
- [High] Global lock mismatch for `ha->host_map` and `vp_map` structures, a=
llowing concurrent btree corruption.
--

--- Patch [78]: [PATCH v3 78/88] scsi: qla2xxx: Hold vport_slock for host m=
ap update in report ID acquisition ---
commit e3ac99c05ebbead772a6f7fee7f4f320422f988b
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition
   =20
This commit adds a missing vport_slock around qla_update_host_map() in
the format-1 handling path of qla24xx_report_id_acquisition() to prevent
concurrent host_map updates from corrupting the btree.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index e88c3a989a51b..39544deab576a 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4280,7 +4280,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			if (!found)
>  				return;
> =20
> +			spin_lock_irqsave(&ha->vport_slock, flags);
>  			qla_update_host_map(vp, id);
> +			spin_unlock_irqrestore(&ha->vport_slock, flags);

[Severity: High]
This isn't a bug introduced by this patch, but does the physical port also
need to be protected by vport_slock?

Earlier in qla24xx_report_id_acquisition(), when handling format =3D=3D 0 or
when vp_idx =3D=3D 0 for format =3D=3D 1, qla_update_host_map(vha, id) is c=
alled
without locks.

If qla24xx_report_id_acquisition() is called from
qlt_24xx_process_atio_queue(vha, 0) where no locks are held, could these
unprotected physical port updates race and corrupt the btree?

[Severity: High]
This is a pre-existing issue, but does using vport_slock here conflict with
other contexts that update the host_map?

Looking at other updaters, it seems they hold hardware_lock instead of
vport_slock:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_configure_hba() {
    ...
    spin_lock_irqsave(&ha->hardware_lock, flags);
    ...
    qla_update_host_map(vha, id);
    spin_unlock_irqrestore(&ha->hardware_lock, flags);
    ...
}

drivers/scsi/qla2xxx/qla_mid.c:qla24xx_disable_vp() {
    ...
    spin_lock_irqsave(&vha->hw->hardware_lock, flags);
    qla_update_vp_map(vha, RESET_AL_PA);
    spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
    ...
}

Because these contexts use disjoint locks to serialize modifications to the
exact same btree (ha->host_map), could this lead to concurrent btree
corruption?

> =20
>  			/*
>  			 * Cannot configure here as we are still sitting on the

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D78
