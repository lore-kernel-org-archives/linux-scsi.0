Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430F23A453A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 15:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784043607; cv=none; b=c1SWIRrxrVzfXZcMH+jQAeEyjtsVchOTkxDk0l3J8RWUE/Wxct4aLJ00nRs3c5N1fkSVq8IHk4rxumYF3zK7u+JoEHxs4JFZCqGFKsVjz/3t0Eh8cAkecw+wo+n0CevG4IuoMtXj8BqmpVQO0vpFrCTNxUMuiwcROlavypWm/lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784043607; c=relaxed/simple;
	bh=fThkJNW2mEImPvLy1j7aMtabUYLvtLPEuybPehtCD7s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iu9DgC1nOtCpXxTrRi/5yYTHUOYtwOvAWZ/eEiTkF6bcqDn+WaDIsWJejDwCPP/Xo6c0hxOH/QDMKq+EuYYHO3YZk2qp4OGTIyJ/rh328mA5n5EgxhW0Tisf9sM7Iad/TGV/wypU6jDWGNyvvndBjyZ+gs+Jlb8IofZGdJVaKEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iU//SpJB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iU//SpJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFBC1F000E9;
	Tue, 14 Jul 2026 15:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784043605;
	bh=CRB5Ep1zPDTr/x0JzXyv9UuIsL6yRgJ6NB+DDN/VekY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iU//SpJBchemWgbBzA6drZQKW1WPUMGx4lItH83SRx6WSXJPo78u9Bqs4/C/aDeNP
	 CHfQVu5MYroAyyv5u5cr0Tz/9Y8bEYVd//DfKPSx5CjKXS8gg8Teeqef3MQRe7lH9Y
	 eBNBdYJJIvgMrMFpt8dpmuRm53b1OtD/AR3Fj3ewy71LWidy2vThJUG+OeXSY4N7fF
	 C5ldLwxw1rBMPA1YFtL/qBbwgIH2kNbKWP8zglCW4U9ANocw+bwMjogmm48aj3RtnH
	 JSgy4xqPfcMPBx2hXtV6O/GWixnSqRHtW0CnfyHJ2Ts7nFP8fnFYMwz6Kk/asiut1r
	 WFfnLHeLu8pWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 37/56] scsi: qla2xxx: Add size check for extended VP
 report ID entry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-38-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-38-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 15:40:05 +0000
Message-Id: <20260714154005.BAFBC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] The hardware-defined structure `vp_rpt_id_entry_24xx_ext` uses C b=
itfields (`vp_idx : 9` and `vp_status : 7`) to map to Little-Endian firmwar=
e IOCB data, causing endianness and ABI layout corruption on Big-Endian arc=
hitectures.

Pre-existing issues:
- [Critical] The virtual port (`vp`) pointer is accessed and modified after=
 releasing `ha->vport_slock` without acquiring a reference.
- [Critical] The `fcport` pointer is dereferenced and modified after the `s=
ess_lock` is released, without acquiring a reference.
- [Critical] In the format 2 branch of `qla24xx_report_id_acquisition`, the=
 driver iterates over the `vha->vp_fcports` list to modify `fcport->scan_st=
ate` without acquiring `vha->hw->tgt.sess_lock`.
- [High] Missing endianness conversion when reading the little-endian `bbcr=
` hardware field.
--

--- Patch [37]: [PATCH v4 37/56] scsi: qla2xxx: Add size check for extended=
 VP report ID entry ---
commit 0a18f95655fa2d187c369d0dd1d03c6b0b2a0d73
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Add size check for extended VP report ID entry

This commit adds padding to the extended VP report ID entry to match
the hardware IOCB stride. It also updates qla24xx_report_id_acquisition()
to accept a void pointer and extract the virtual port index and status
from the extended structure on 29xx series adapters.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 3ebda35dd584f..cec308811d9eb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4102,6 +4105,14 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>  	if (rptid_entry->entry_status !=3D 0)
>  		return;
> =20
> +	if (IS_QLA29XX(ha)) {
> +		vp_idx =3D rptid_entry_ext->vp_idx;
> +		vp_status =3D rptid_entry_ext->vp_status;

[Severity: High]
Do C bitfields map correctly on Big-Endian architectures here?

The hardware-defined structure vp_rpt_id_entry_24xx_ext maps to
Little-Endian firmware IOCB data. If vp_idx and vp_status are defined
as bitfields, this can cause endianness and ABI layout corruption on
Big-Endian hosts, leading to mapping to the wrong virtual ports.

[ ... ]

> @@ -4223,8 +4233,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
>  		/* buffer to buffer credit flag */
>  		vha->flags.bbcr_enable =3D (rptid_entry->u.f1.bbcr & 0xf) !=3D 0;

[Severity: High]
This is a pre-existing issue, but is an endianness conversion missing when
reading the bbcr field here?

The hardware bbcr field is little-endian (defined as __le16), but it is
read natively without byte-swapping. On a big-endian system, the bitwise
AND will mask the wrong byte, resulting in invalid credit behavior.

[ ... ]

> @@ -4241,18 +4251,18 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vh=
a,
>  			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
>  		} else {
> -			if (rptid_entry->vp_status !=3D VP_STAT_COMPL &&
> -				rptid_entry->vp_status !=3D VP_STAT_ID_CHG) {
> +			if (vp_status !=3D VP_STAT_COMPL &&
> +				vp_status !=3D VP_STAT_ID_CHG) {
>  				ql_dbg(ql_dbg_mbx, vha, 0x10ba,
>  				    "Could not acquire ID for VP[%d].\n",
> -				    rptid_entry->vp_idx);
> +				    vp_idx);
>  				return;
>  			}
> =20
>  			found =3D 0;
>  			spin_lock_irqsave(&ha->vport_slock, flags);
>  			list_for_each_entry(vp, &ha->vp_list, list) {
> -				if (rptid_entry->vp_idx =3D=3D vp->vp_idx) {
> +				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
>  					break;
>  				}

[Severity: Critical]
This is a pre-existing issue, but is the vp pointer safe to access here?

The vp pointer is extracted from ha->vp_list, but the vport_slock is
dropped before qla_update_host_map(vp, id) is called, and no reference is
taken on the port:

qla24xx_report_id_acquisition() {
    spin_lock_irqsave(&ha->vport_slock, flags);
    list_for_each_entry(vp, &ha->vp_list, list) {
        if (vp_idx =3D=3D vp->vp_idx) {
            found =3D 1;
            break;
        }
    }
    spin_unlock_irqrestore(&ha->vport_slock, flags);

    if (!found)
        return;

    qla_update_host_map(vp, id);
}

If another thread concurrently deletes the virtual port via
qla24xx_vport_delete(), the memory could be freed while it's still being
accessed, causing a use-after-free.

[Severity: Critical]
This is a pre-existing issue, but is the fcport pointer safe from a
use-after-free in the format 1 branch of qla24xx_report_id_acquisition()?

The fcport pointer is acquired under a spinlock, but the lock is released
before the pointer is safely used or reference counted:

qla24xx_report_id_acquisition() {
    ...
    fcport =3D qla2x00_find_fcport_by_wwpn(vha, rptid_entry->u.f1.port_name=
, 1);
    spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);

    if (fcport) {
        fcport->plogi_nack_done_deadline =3D jiffies + HZ;
        fcport->dm_login_expire =3D jiffies + QLA_N2N_WAIT_TIME * HZ;
        fcport->scan_state =3D QLA_FCPORT_FOUND;
    ...
}

A concurrent session teardown can free the fcport before these updates
complete.

[Severity: Critical]
This is a pre-existing issue, but does iterating over vha->vp_fcports
in the format 2 branch require the sess_lock?

In the format 2 branch (RIDA format 2 / N2N direct connect) of
qla24xx_report_id_acquisition(), the code calls list_for_each_entry
without acquiring the sess_lock that protects vp_fcports:

qla24xx_report_id_acquisition() {
    ...
    list_for_each_entry(fcport, &vha->vp_fcports, list) {
        fcport->scan_state =3D QLA_FCPORT_SCAN;
        fcport->n2n_flag =3D 0;
    }
    ...
}

Other threads (e.g., session deletion) might concurrently add or remove
nodes from this list. Iterating a mutating linked list concurrently without
locks could lead to structural corruption or infinite loops.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D37
