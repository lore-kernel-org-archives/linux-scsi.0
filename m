Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE732E7BD9
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264323; cv=none; b=btRy8/NEkP8tdbC0xTM7IlOkXPtfq3+exvcU4QeYS2K4Ktyt7Y4+A5Vnee6mQGFdVvD8UUTIsFkJltZSzIQePICUowbsvEgeO903ZpXwa8Pfi+t+z31snAPzHvA+u3VdXWOhv//gQm3BNHnO3Qmg4RcM/6P5VimxKzPjgRnZE1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264323; c=relaxed/simple;
	bh=cyn4wU0iolz4PJUPG/d5qe2tAJaItFg9dxUGfUOIG8E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uIzHElYH5BAXTTMN0iesV0Ii6rlmIZa4FZ8m/dUqEOc4F5P6RJ9swXS4XpjnoGu6oKk6aPk08AqbEO8J42kU/4/a6zPSf2y4AN63l0miziMb+Ky/3ApviUFwuUadup0KAYNptZen0RIhIgbc4nWqmlXAySFLR2xyfaPuRbHeiHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVQnY81m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVQnY81m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C151F000E9;
	Fri, 12 Jun 2026 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781264322;
	bh=GBrERva/2ryvQe/oxS5ijoEX/UyjuLYUbcaKamncIC8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lVQnY81m63Ey1YT63mk6BaaO0N+SBMGd8jS4k0DwxXMSEfhGuTZtOkSHKVbo1e9S1
	 kjIE9NY7b+0oAloFY/lZrjOFDPUTf0/oTkvtPmFSTum4rBrY3mcIjRmXUSLUcdzBb8
	 a6Ye4siHrBV5ZGiTjwJMS4zUFHYNpSQJ2ibCh84HEESvQdisxdaHF2SyP3oY7VoHgk
	 MpxQ2ULDjBdKRMgTKlTEYbetsnW4BKnBdtClcTzp0aKkyl5u1NBl8vMxqaLCtPICu4
	 mNnyVpahALykAwz2v14ZvSvZYCOSVHBM8V0cmLBFhh23XDgRnxEb4gKpUI2jiC1+Ic
	 q8kDFS5S+g9hQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 55/60] scsi: qla2xxx: Hold vport reference in
 qla24xx_report_id_acquisition()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-56-njavali@marvell.com>
References: <20260612095333.1666592-56-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:38:41 +0000
Message-Id: <20260612113841.D9C151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [High] The decrement of `vp->vref_count` lacks a release memory barrier a=
nd breaks the driver's locking idiom, potentially leading to a use-after-fr=
ee write on weakly ordered architectures.

Pre-existing issues:
- [High] The exact same use-after-free vulnerability fixed by this patch in=
 `qla24xx_report_id_acquisition` is present in the NVMe FC path via `qla2xx=
x_get_vha_from_vp_idx`.
- [High] Target mode processing uses `qla_find_host_by_vp_idx` which return=
s an unreferenced `vha` pointer, opening a race condition for UAF during vp=
ort teardown.
- [High] btree operations on `ha->host_map` via `qla_update_host_map()` are=
 performed without holding `vport_slock`.
- [High] Missing `sess_lock` during `vp_fcports` list traversal in Format 2=
 branch.
- [High] Invalid use of list_for_each_entry_safe across dropped spinlocks i=
n DPC and alert handlers.
- [High] `qla24xx_report_id_acquisition` ignores `VPORT_DELETE` and can res=
urrect a deleted vport.
--

commit 95ed94124983f94c25ebc87bace3b12cf63aa94f
Author: Nilesh Javali <njavali@marvell.com>
scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()

This commit fixes a use-after-free by taking a vport reference
(vref_count) while holding vport_slock when finding a virtual port,
and dropping it after use. This ensures the vport isn't freed by a
concurrent qla24xx_deallocate_vp_id().

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 8a001b489fc0e..bfb931eb14f61 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4275,6 +4275,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			list_for_each_entry(vp, &ha->vp_list, list) {
>  				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
> +					atomic_inc(&vp->vref_count);

[Severity: High]
This is a pre-existing issue, but does this loop need to check if the vport
is actively being deleted?

If qla24xx_vport_delete() is concurrently removing the vport and has already
taken it out of the host_map, would we resurrect it here?

We take a reference and later re-register it without checking for
VPORT_DELETE on vp->dpc_flags, which might lead to a use-after-free when the
system later queries the map.

>  					break;
>  				}
>  			}
> @@ -4292,6 +4293,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
>  			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
> +
> +			atomic_dec(&vp->vref_count);

[Severity: High]
Could the weakly ordered nature of atomic_dec() allow the preceding set_bit=
()
operations to be reordered after the decrement?

In the kernel, set_bit() and atomic_dec() do not imply memory barriers.
On weakly ordered architectures, the atomic_dec() could become visible
before the stores to vp->vp_flags and vp->dpc_flags.

If qla24xx_deallocate_vp_id() polls vref_count concurrently, could it
observe vref_count =3D=3D 0 early, proceeding to unlink the vport before the
flags are fully updated?

Would it be safer to enclose the atomic_dec() within vport_slock, matching
how the reference is acquired?

>  		}
>  		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);

[Severity: High]
This is a pre-existing issue, but are we modifying the host_map without
holding the required lock in this same function?

Just before the snippet above, qla_update_host_map() evaluates to
qla_update_vp_map() which inserts the vp into the ha->host_map btree. The
documentation for qla_update_vp_map() states it requires vport_slock:

drivers/scsi/qla2xxx/qla_mid.c:qla_update_vp_map() {
    /* vport_slock to be held by the caller */
    ...
    btree_insert32(&ha->host_map, ...);
}

Since we dropped ha->vport_slock before this call, could concurrent
modifications corrupt the btree?


[Severity: High]
This isn't a bug introduced by this patch, but should we be holding
sess_lock while iterating vp_fcports in the Format 2 path of
qla24xx_report_id_acquisition()?

In the Format 1 path, the list is traversed with sess_lock held.
However, in the Format 2 path, we traverse the list and call
qla2x00_find_fcport_by_wwpn() without holding vha->hw->tgt.sess_lock:

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_report_id_acquisition() {
    ...
    list_for_each_entry(fcport, &vha->vp_fcports, list) {
        fcport->scan_state =3D QLA_FCPORT_SCAN;
        fcport->n2n_flag =3D 0;
    }

    fcport =3D qla2x00_find_fcport_by_wwpn(vha,
        rptid_entry->u.f2.port_name, 1);
    ...
}

Could this lack of locking lead to list corruption or use-after-free if
vp_fcports is modified concurrently?


[Severity: High]
This is a pre-existing issue, but does the NVMe FC path suffer from a simil=
ar
use-after-free vulnerability as the one fixed in this patch?

When calling qla2xxx_get_vha_from_vp_idx() in qla_nvme.c, the lock is dropp=
ed
and the vha pointer is returned without incrementing vref_count:

drivers/scsi/qla2xxx/qla_nvme.c:qla2xxx_get_vha_from_vp_idx() {
    if (vha->vp_idx =3D=3D vp_index) {
        spin_unlock_irqrestore(&ha->vport_slock, flags);
        return vha;
    }
}

The caller, qla2xxx_process_purls_iocb(), then heavily uses this unreferenc=
ed
pointer. Could a concurrent qla24xx_deallocate_vp_id() tear down the vport
and free it, causing a use-after-free in the NVMe response path?


[Severity: High]
This is a pre-existing issue, but does qla_find_host_by_vp_idx() also leak
unreferenced pointers in target mode?

drivers/scsi/qla2xxx/qla_mid.c:qla_find_host_by_vp_idx() {
    if (likely(test_bit(vp_idx, ha->vp_idx_map)))
        return ha->vp_map[vp_idx].vha;
}

Various target mode functions route commands to the vport returned by this
lookup. Since no reference is taken, couldn't qla24xx_deallocate_vp_id()
free the vha concurrently?


[Severity: High]
This is a pre-existing issue, but is it safe to use list_for_each_entry_saf=
e()
when dropping the spinlock in DPC and alert handlers?

In qla2x00_do_dpc_all_vps(), the lock is dropped inside the safe iteration
loop:

drivers/scsi/qla2xxx/qla_mid.c:qla2x00_do_dpc_all_vps() {
    spin_lock_irqsave(&ha->vport_slock, flags);
    list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
        if (vp->vp_idx) {
            atomic_inc(&vp->vref_count);
            spin_unlock_irqrestore(&ha->vport_slock, flags);
            ...
            spin_lock_irqsave(&ha->vport_slock, flags);
}

Since list_for_each_entry_safe() caches the next element (tvp), if a
concurrent deletion removes tvp from the list and frees it while the lock
is dropped, won't resuming the loop result in a use-after-free?
A similar pattern exists in qla2x00_alert_all_vps().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D55
