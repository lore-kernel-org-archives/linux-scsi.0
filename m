Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792752832;
	b=K68x4ju375kUV8tHDdeJG9V2vvpQGI0wYQPIJ/Rq3Vw9om39EGHPNoHdR/eqDsuAtTKh
	 fd1HJUScu9pLfDIdGAVKAaqT2Y/Tz1fJvxKKLWlf0msQ53eOFzrl/cYntOlqVUW87q1Yq
	 ZXvHsaFnEiZsZFyU4DGBV+zlI+G9Aafep0bTaQr7JgwXrrW6zQ+g80hE45slDn1MnqSC2
	 /bO273KMSz8dO0DQ3ypPOnUjh7OnDGeULRotG2Ij8Jdm9zTDC6POM2BXWSQB/deGerUHZ
	 lIlT0KZkk+JwouY/PNeTScn+wtKfRfU3DlVI5ZPTfpZhgKZVHSV1b6RACd2sSm+4RMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792752832;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sOcCqxibFAMzVJjhhfzGqYZusXEdrhXBL2O16bmT0tQ=;
	b=qkNUBM9MTDlj8W/4E3A6q9YzcIq2V+IQJb3X5lRSUGG2jqPiz1yx5Ui+KUj8DBzooXU2
	 ZF+Y9XVCAMgrRFggTS5z4leZ5W/9RtqnGZzRLM0KSWNUbJ5XklR0SiWTt1+5OjxSUWRIH
	 DSc6u8lrCRxGqNzlRS3DHeweoEdF80GCOAJUNP0nmPWyZC9ISwH/BmKNc94YFmBM/RZEc
	 lU+w505Onp3Sa5b/mApb94WIqJjh6WZWpm3bpfIUAwtnmzXv/MEviNXfu1rP6eDzbHbmw
	 TLL5V6SE2jj5JqZL3c+hC8cX7Zh9O8tFQ9s+80+yyZI5UqJ24kb0DTg/ytteEeJKI2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lMC1zNqt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EF8606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lMC1zNqt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D26D1F01825;
	Fri, 23 Oct 2026 10:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792752831;
	bh=sOcCqxibFAMzVJjhhfzGqYZusXEdrhXBL2O16bmT0tQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lMC1zNqtNgSotkOs9iExRMUYU3PlieA6j+PPcQhPe3SFDn56W6oSx/+7zIQysnalr
	 3JnLamwIn5nvjTEie1BameTX76JscMbyHCYv4LgfgLZfYDGw0KTLyGLb6fLb7m1Hpb
	 R/2VMb0P6O8NDHdOZGgG2Gp/pganuh/XaGgorsfjANXPztkMX2yAQDxUvAuiyNTVG7
	 kt6Jl3bfSGGxO/rsRf9iHEq1DbbM8U6f48V+Kkv7onZ1Q+mYvgpO5/YGqJs2PcBAOs
	 ttczdp9tR+NYA2ZkNDQbHHOpZqwX1Dj6quGUxLSD3mdzGXyhsm5pDJnm/nR8X40o/6
	 W+G3MuNjSuFpQ==
Message-ID: <sashiko-outbox-182709@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/13] scsi: qla2xxx: Fix use-after-free races during
 vport deletion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-11-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-11-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:53:50 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] scsi: qla2xxx: infinite loop and UAF in vp_list loops with lis=
t_del_init()
- [High] scsi: qla2xxx: missing vport validation and tvp refresh in vp_list=
 loops
--

commit 24f27bc8c1d9341721d99c592298135dfbc0b9d5
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix use-after-free races during vport deletion

This commit adds vport validation checks (vp_idx, delete_progress, and
VPORT_DELETE) to several ha->vp_list traversals and switches
qla24xx_deallocate_vp_id() from list_del() to list_del_init() to prevent
use-after-free crashes during vport deletion.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 7898521b76d4d..c02571a6f0c71 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -7573,15 +7573,17 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
> =20
>  		spin_lock_irqsave(&ha->vport_slock, flags);
>  		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> -			atomic_inc(&vp->vref_count);
> -			spin_unlock_irqrestore(&ha->vport_slock, flags);
> +			if (vp->vp_idx && !vp->flags.delete_progress) {
> +				atomic_inc(&vp->vref_count);
> +				spin_unlock_irqrestore(&ha->vport_slock, flags);
> =20
> -			qla2x00_mark_all_devices_lost(vp);
> +				qla2x00_mark_all_devices_lost(vp);
> =20
> -			spin_lock_irqsave(&ha->vport_slock, flags);
> -			/* Check if vp is still valid before accessing it */
> -			if (vp->vp_idx && !vp->flags.delete_progress)
> +				spin_lock_irqsave(&ha->vport_slock, flags);
> +				/* Reference held under vport_slock keeps vp valid. */
>  				atomic_dec(&vp->vref_count);
> +				wake_up(&vp->vref_waitq);
> +			}
>  		}
>  		spin_unlock_irqrestore(&ha->vport_slock, flags);

[Severity: High]
The commit message notes that it validates vp_idx and delete_progress across
all remaining vp_list traversals, but what about qla2x00_quiesce_io() and
qla82xx_restart_isp() in drivers/scsi/qla2xxx/qla_init.c?

In qla2x00_quiesce_io(), ha->vp_list is traversed and ha->vport_slock is
dropped without checking vp->vp_idx or !vp->flags.delete_progress, and
without waking vp->vref_waitq:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_quiesce_io() {
    ...
		spin_lock_irqsave(&ha->vport_slock, flags);
		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
			atomic_inc(&vp->vref_count);
			spin_unlock_irqrestore(&ha->vport_slock, flags);

			qla2x00_mark_all_devices_lost(vp);

			spin_lock_irqsave(&ha->vport_slock, flags);
			atomic_dec(&vp->vref_count);
		}
		spin_unlock_irqrestore(&ha->vport_slock, flags);
    ...
}

Similarly, qla82xx_restart_isp() checks vp->vp_idx (which is not cleared by
qla24xx_deallocate_vp_id()), but does not check !vp->flags.delete_progress =
or
call wake_up(&vp->vref_waitq):

drivers/scsi/qla2xxx/qla_init.c:qla82xx_restart_isp() {
    ...
		spin_lock_irqsave(&ha->vport_slock, flags);
		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
			if (vp->vp_idx) {
				atomic_inc(&vp->vref_count);
				spin_unlock_irqrestore(&ha->vport_slock, flags);

				qla2x00_vp_abort_isp(vp);

				spin_lock_irqsave(&ha->vport_slock, flags);
				atomic_dec(&vp->vref_count);
			}
		}
		spin_unlock_irqrestore(&ha->vport_slock, flags);
    ...
}

Since NPIV is supported on QLA8031, QLA82XX, and QLA8044 adapters, if
qla24xx_vport_delete() runs concurrently with qla2x00_quiesce_io() or
qla82xx_restart_isp() and deletes the prefetched next entry tvp while
ha->vport_slock is dropped, won't the next iteration advance vp to the
removed and freed tvp, enter the loop body because !vp->flags.delete_progre=
ss
is not checked, and access freed vp and vp->vp_fcports memory in
qla2x00_mark_all_devices_lost(vp) or qla2x00_vp_abort_isp(vp)?

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 90f09d36705a6..754c806dac807 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -79,7 +79,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
>  	for (i =3D 0; i < 500; i++) {
>  		spin_lock_irqsave(&ha->vport_slock, flags);
>  		if (atomic_read(&vha->vref_count) =3D=3D 0) {
> -			list_del(&vha->list);
> +			list_del_init(&vha->list);
>  			qla_update_vp_map(vha, RESET_VP_IDX);
>  			bailout =3D 1;
>  		}
> @@ -94,7 +94,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
>  		ql_log(ql_log_info, vha, 0xfffa,
>  			"vha->vref_count=3D%u timeout\n", vha->vref_count.counter);
>  		spin_lock_irqsave(&ha->vport_slock, flags);
> -		list_del(&vha->list);
> +		list_del_init(&vha->list);
>  		qla_update_vp_map(vha, RESET_VP_IDX);
>  		spin_unlock_irqrestore(&ha->vport_slock, flags);
>  	}

[Severity: Critical]
Can changing list_del(&vha->list) to list_del_init(&vha->list) in
qla24xx_deallocate_vp_id() still trigger a use-after-free and also cause an
infinite loop with interrupts disabled in the list_for_each_entry_safe()
traversals?

When ha->vp_list is traversed using list_for_each_entry_safe(vp, tvp,
&ha->vp_list, list) in qla2x00_abort_isp_cleanup(), qla2x00_abort_isp(),
qla_pci_error_cleanup(), qla2x00_do_dpc_all_vps(), qla2x00_alert_all_vps(),
qla2x00_quiesce_io(), and qla82xx_restart_isp(), the macro prefetches the
next entry tvp =3D list_next_entry(vp, list) before running the loop body. =
The
loop body only increments vp->vref_count (leaving tvp->vref_count at 0) and
then drops ha->vport_slock.

While ha->vport_slock is dropped during vp processing, a concurrent
qla24xx_vport_delete() -> qla24xx_deallocate_vp_id(tvp) can acquire
ha->vport_slock, observe atomic_read(&tvp->vref_count) =3D=3D 0, unlink tvp=
 with
list_del_init(&tvp->list), and release ha->vport_slock, after which
qla24xx_vport_delete() frees tvp via scsi_host_put(tvp->host).

When the traversal thread finishes processing vp, re-acquires ha->vport_slo=
ck
with spin_lock_irqsave(), and advances the loop (vp =3D tvp, tvp =3D
list_next_entry(tvp, list)):

1. It dereferences tvp after it has been unlinked and potentially freed by
scsi_host_put(tvp->host), causing a use-after-free on tvp->list.next and
subsequently on vp->vp_idx, vp->flags.delete_progress, or vp->dpc_flags.

2. Because list_del_init(&tvp->list) sets tvp->list.next =3D &tvp->list,
list_next_entry(tvp, list) evaluates to tvp itself. Since &tvp->list !=3D
&ha->vp_list, the loop termination condition is never met, and subsequent
iterations skip the body (because delete_progress or VPORT_DELETE is set)
without dropping ha->vport_slock, spinning forever on the self-linked entry
with local interrupts disabled.

A follow-up commit in the series, commit a9b1443e24db ("scsi: qla2xxx:
Re-acquire vport_slock and refresh tvp during vport DPC"), refreshes tvp =3D
list_next_entry(vp, list) after re-acquiring ha->vport_slock in
qla2x00_do_dpc_all_vps() and qla2x00_alert_all_vps(), but leaves the
list_for_each_entry_safe() loops in qla2x00_abort_isp_cleanup(),
qla2x00_abort_isp(), qla_pci_error_cleanup(), qla2x00_quiesce_io(), and
qla82xx_restart_isp() without tvp refreshes. Should tvp be refreshed after
re-acquiring ha->vport_slock in all of those loops as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D10
