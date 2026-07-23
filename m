Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C34908CC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784833970; cv=none; b=A0/AI2mRwmZGcxOaMGPck/xOUJU7av0TTjGMDq7hIIi/0W1efBORjgccPBAf7V53ckl6qiwQ2hwB62OKEKsDecQ3uJXMpHQk1JsJuyXfxsyYRo7nPh0hjV4X4CZJAv6Ou4muah6H7LLNGk1JdvblhtXH0UaDTXxMdBsdmFIdQTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784833970; c=relaxed/simple;
	bh=kbPzCSkvJ8bVNgwYmb9rkRP9nMHrvpQzHI+pPKoT/8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UlkinxLEdGYg9RG9o5YzaKK9gCrTEwEu4rwjTAUe4ba8un2l2zW/wh37o26exbuzXKYVMFoiR+anrKdE2mI+Tk7SSwoEQh74TavOy5pe9XkQm79KcE0jbTmr+rWEBDmsO/DXaeIfN5GmlMBG9ZK7e1/VoZTu7LLRdOJSDEkLJAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A57A1F000E9;
	Thu, 23 Jul 2026 19:12:48 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 50/56] scsi: qla2xxx: Hold vport reference in
 qla24xx_report_id_acquisition()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-51-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-51-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 19:12:18 +0000
Message-Id: <20260723191248.9A57A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Missing memory barrier before `atomic_dec(&vp->vref_count)` allows=
 compiler/CPU reordering, reopening the use-after-free window.

Pre-existing issues:
- [High] Missing lock serialization on `host_map` btree in `qla_update_host=
_map()`.
- [High] Unchecked VPORT_DELETE state in `qla24xx_report_id_acquisition()` =
allows a dying vport to be re-inserted into the host map btree.
- [High] Unprotected list traversal and access of `vp_fcports` in `qla24xx_=
report_id_acquisition` (Format 2 path) can lead to Use-After-Free.
- [High] Pre-existing `list_for_each_entry_safe` iteration across lock drop=
s allows the cached next element to be freed.
--

--- Patch [50]: [PATCH v6 50/56] scsi: qla2xxx: Hold vport reference in qla=
24xx_report_id_acquisition() ---
commit 63a71c77c454d2559780ee0faf9f716b8a83c5f1
Author: Nilesh Javali <njavali@marvell.com>
Subject: scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisiti=
on()

This commit fixes a use-after-free window in the format 1 path by
taking a vport reference under the vport_slock during id acquisition.
The lock is held while searching the list, and the reference ensures
the vport remains valid during subsequent lockless setup.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 59023492c5a98..ba4a4764de1fb 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4267,6 +4267,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			list_for_each_entry(vp, &ha->vp_list, list) {
>  				if (vp_idx =3D=3D vp->vp_idx) {
>  					found =3D 1;
> +					atomic_inc(&vp->vref_count);

[Severity: High]
This is a pre-existing issue, but does this loop need to check whether
the vport is actively being deleted?

If a concurrent thread removes the vport from the host map and sets the
deletion state, could this loop erroneously take a reference on the dying
vport and re-insert it into the host map below, creating a dangling pointer
once the reference is dropped?

>  					break;
>  				}
>  			}
> @@ -4284,6 +4285,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,=
 void *pkt)
>  			spin_unlock_irqrestore(&ha->vport_slock, flags);
> =20
>  			if (!found)
>  				return;
> =20
>  			qla_update_host_map(vp, id);

[Severity: High]
This isn't a bug introduced by this patch, but does dropping the vport_slock
leave qla_update_host_map() unprotected?

The btree functions are used locklessly in this operation. If another thread
modifies the host map concurrently, can this result in data races and btree
corruption?

> =20
>  			/*
>  			 * Cannot configure here as we are still sitting on the
>  			 * response queue. Handle it in dpc context.
>  			 */
>  			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
>  			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
>  			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
> +
> +			atomic_dec(&vp->vref_count);

[Severity: High]
Can this regression allow the compiler or CPU to reorder the set_bit()
operations?

Since void-returning atomic operations like atomic_dec() and set_bit()
do not imply memory barriers, could the CPU reorder the memory stores to
become visible after the reference count is decremented?=20

If a concurrent thread polls the reference count, observes it drop to zero,
unlinks, and frees the vport, would the delayed set_bit() stores corrupt the
freed memory?

>  		}
>  		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);

[ ... ]


[Severity: High]
This is a pre-existing issue, but is the vp_fcports list traversed safely
in the Format 2 path of qla24xx_report_id_acquisition()?

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_report_id_acquisition() {
    ...
	} else if (rptid_entry->format =3D=3D 2) {
        ...
		list_for_each_entry(fcport, &vha->vp_fcports, list) {
			fcport->scan_state =3D QLA_FCPORT_SCAN;
			fcport->n2n_flag =3D 0;
		}
    ...
}

Unlike the Format 1 path, this traversal appears to happen without holding
the session lock. If a concurrent session deletion unlinks and frees the
fcport elements during this loop, could this lead to list corruption and a
use-after-free?


[Severity: High]
This is also a pre-existing issue, but does list_for_each_entry_safe()
across a lock drop open a window for the cached next element to be freed?

drivers/scsi/qla2xxx/qla_mid.c:qla2x00_do_dpc_all_vps() {
    ...
	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
		if (vp->vp_idx) {
			atomic_inc(&vp->vref_count);
			spin_unlock_irqrestore(&ha->vport_slock, flags);

			qla2x00_do_dpc_vp(vp);

			spin_lock_irqsave(&ha->vport_slock, flags);
			atomic_dec(&vp->vref_count);
		}
	}
    ...
}

Because the macro caches the next element (tvp) before dropping the lock,
could a concurrent removal free tvp while the lock is dropped, causing a
use-after-free when the loop advances?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D50
