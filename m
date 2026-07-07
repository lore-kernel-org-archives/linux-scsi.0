Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D439A1D432D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409597; cv=none; b=f11evPmCGH069KMXZX2KMgcIA/EkrFjP32ZbC75QEEyqExFtiRLCxvhZlnDennAgMM/d5FciU3ofyVljVQgTPi224spelBqoLWWZMpIoAWq4rLAyjjHDlJB86QDR/oVwcZLGGSFYpEt+KLh9EDWwK4knlOEHpcOpZV8Ha989sRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409597; c=relaxed/simple;
	bh=2tlO+Bxa4TMcpSyCKsBQjIoO/Caykv06XchbZRrqvEA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JO/e9/0kMPiaMBGG+Cf4SWC9c9ZHv0z1CZ1M3vEoN9e4LKTOTGafDQU/qYXvvF0Vmfr++PNNlc5w2jMo9i1ahREyLuSnCdco/4uh8POkK+TZcJTOy1mYXmj3UemvIJr5Uz7d4yQVsbG3pKc47qXMNkJN7mdinY1tYhrL+oLVyTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nlMRUhpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nlMRUhpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8AE1F000E9;
	Tue,  7 Jul 2026 07:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409595;
	bh=v6N/NzwObs43ui4JMfOl7+F6bj1YQo0k6il53V3CWXk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nlMRUhpvtMBXem9J7rqrOvvcL2/Kb6EXcXBL5+MQ/Bkxy4QfR/T2YKW3hk3Az9WOh
	 FA4rXF1WFbmZl4E+NzvZQNs9HWMmap3QOBT4T9vNw2oLQbtLnnoIBzACHMoH2JbYNP
	 LjwUEKhtlfTGaYYGE7egWqAl7boAvB/ECtgendTpeQ73ClxamUHHRghtbma7y0C108
	 mKiXhTyLN6RPby1tGyrsLHotUJH4EUQSoaSj4c2/p4e7tsRqVZQ9A+8KxmbH4Pn8Fk
	 WzFwl23IXEoTSb88y66hZ9b6FKe51pjqmLYrhz+EkDp3Brh+aPJ5LZscxbxCFYLS5T
	 00W4BGV3nInTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 77/88] scsi: qla2xxx: Drop vport reference under lock
 in report ID acquisition
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-78-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-78-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:33:14 +0000
Message-Id: <20260707073315.4E8AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The `QLA_VHA_MARK_NOT_BUSY()` and `qla_vha_mark_busy()` macros=
 drop the vport reference count without synchronization, risking a use-afte=
r-free.
- [High] Unprotected btree modifications in `qla_update_host_map` due to mi=
ssing `vport_slock`.
- [High] Missing `sess_lock` when traversing `vp_fcports` and calling `qla2=
x00_find_fcport_by_wwpn` in format 2 handling.
--

--- Patch [77]: [PATCH v3 77/88] scsi: qla2xxx: Drop vport reference under =
lock in report ID acquisition ---
commit 5bf158aa54ed892e70c7c619b33f75270e50d57a
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Drop vport reference under lock in report ID acquisition

qla24xx_report_id_acquisition() format-1 handling takes the vport
reference under vport_slock but drops it outside the lock, after setting
flags. This patch drops the reference under vport_slock to ensure the
flag stores are ordered before the decrement becomes visible.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index affcd87893cda..e88c3a989a51b 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4290,7 +4290,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
> =20
> +			spin_lock_irqsave(&ha->vport_slock, flags);
>  			atomic_dec(&vp->vref_count);

[Severity: Critical]
This is a pre-existing issue, but while we're fixing the vref_count decreme=
nt
here, I noticed a similar pattern in drivers/scsi/qla2xxx/qla_def.h.

In QLA_VHA_MARK_NOT_BUSY() and qla_vha_mark_busy(), the vport reference cou=
nt
is dropped without synchronization:

drivers/scsi/qla2xxx/qla_def.h:QLA_VHA_MARK_NOT_BUSY() {
    ...
    atomic_dec(&__vha->vref_count);
    wake_up(&__vha->vref_waitq);
    ...
}

If the count reaches 0, the concurrent polling thread in
qla24xx_deallocate_vp_id() might observe it, delete the vport, and free it.
Will the subsequent wake_up(&__vha->vref_waitq) then result in a
use-after-free by dereferencing the freed __vha?


> +			spin_unlock_irqrestore(&ha->vport_slock, flags);
>  		}
>  		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
>  		qla2xxx_wake_dpc(vha);

[Severity: High]
This isn't a bug introduced by this patch, but I noticed another unprotected
operation earlier in this same function.

When handling the physical port (vp_idx =3D=3D 0) in
qla24xx_report_id_acquisition(), qla_update_host_map() is called without
any lock:

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_report_id_acquisition() {
    ...
    if (vp_idx =3D=3D 0) {
        if (vp_status =3D=3D VP_STAT_COMPL) {
            ...
            qla_update_host_map(vha, id);
        }
    ...
}

Since other paths modify the shared ha->host_map b-tree under ha->vport_slo=
ck
or ha->hardware_lock, will modifying it here without vport_slock lead to
b-tree corruption?


[Severity: High]
This is a pre-existing issue, but looking further down in the format 2
handling of qla24xx_report_id_acquisition(), the vp_fcports list is travers=
ed
without holding a lock:

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_report_id_acquisition() {
    ...
    } else if (rptid_entry->format =3D=3D 2) {
        ...
        list_for_each_entry(fcport, &vha->vp_fcports, list) {
            fcport->scan_state =3D QLA_FCPORT_SCAN;
            fcport->n2n_flag =3D 0;
        }

        fcport =3D qla2x00_find_fcport_by_wwpn(vha,
            rptid_entry->u.f2.port_name, 1);
    ...
}

The sess_lock is typically acquired when traversing vp_fcports. If the list
is concurrently modified by session addition or deletion, can this
unprotected traversal race and cause list corruption or a use-after-free?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D77
