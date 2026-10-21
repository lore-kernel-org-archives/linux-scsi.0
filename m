Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579237;
	b=3vHJk3A+/fTBZrFDvUwVA+Qks2c5foMWhJn1BRe2eOg1ZmvfHrT2mqzFrUOzzH2s5B91
	 Ztz0qwtIogX3zevghALyrjq1x3r6MauY+VlmwXtZHQm2RtM2g5OlVyBTygL5Kuf86xyR7
	 hpR+WuqUZjivL+n6rIlkx4k/XNtta5+qv1CNjr5EVKLpoJyl86mXn9ol7qVFKeQbtewQ/
	 JV8v/9uvhYVReK918ewJpqvfYByWMpqiGO9M3BMIh0VE1bz17IB2hS8TtuP+gog6nU16q
	 d4fl/pfUa37ivAjVMjH9SsGn4vXE8XrND6B25M5zGrEafENxBriabRFSFzsXWkdDsyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579237;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E+nFeuEsBstigzOwhVdhXVHllGb5frRi05iNbq/kHFU=;
	b=OGV3GbHKzgda27NhjiorGgQ1NK6VurxPllE0b0IqD0DbR9VDZHbAOJwFeQjizmy8VtNw
	 uf3DVwfwsRhZTQIDjomj02SERddYwZ6IN18rSDiFqE7eHMsWf3vOeroCmNkbPorKIxfAN
	 T3VpRUUWUq1kmWLtoTz/N9sIbJRHp3mFtGYVYGyUe90LszCbU/D5nfH/afuD5n4V0v33G
	 +RUaz1bSUYR7fJWFwR7Csm200ywLEEgPUJV5a2WTbS3c12TrnepzIRuJautpvofKl25hz
	 MLZ/DxYGmdgPpX7E86qhYPpi/4xEI4xPrLcSOhd/eiaMMwXO/P9qkoSgIyvgpamxTOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZOND8wZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47D606A339
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZOND8wZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D421F000D0;
	Wed, 21 Oct 2026 10:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579237;
	bh=E+nFeuEsBstigzOwhVdhXVHllGb5frRi05iNbq/kHFU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CZOND8wZMD4YpVRMi2f6h5WryLaPxlw5px6KmPA/Rk2h0P4OjrBIabefnC55NeH0X
	 n5TIeeoQXscrRuR05SG+NaRSognaEWh7PtHIx4mDCjAgy6svB85wz9vUqQNKVxbsXW
	 3BEx310Fd4kOIaOsLYwxVrOMNBvQ8iE8y/hTZw50aK+U0FQNN/ocE6uooPkCuSxw+E
	 1QEhVZE0teNQfdA7cUHAVmlpTAUkdq+ga6bgtBfSA5o9qWqtMj9pUEDpqHg3Nz3lXk
	 2fLzBA5ByVpom5Lj8pWCAG1c9SOqwZour4yKzcU/GSMR5oARo26mH2Flefe/Rk95nm
	 YC+9ir3kFGLtA==
Message-ID: <sashiko-outbox-180111@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/14] scsi: qla2xxx: Fix use-after-free races during
 vport deletion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-11-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-11-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:40:37 +0000
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
- [Critical] scsi: qla2xxx: stale tvp and list_del_init() loop in vp_list t=
raversals
- [Medium] scsi: qla2xxx: missing vport delete_progress check in qla_init.c
--

commit 0334585318b2e223104d7c4feec6a0dddbae9a31
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix use-after-free races during vport deletion

This commit checks vp_idx and delete_progress before referencing vports in
several ha->vp_list traversals and switches qla24xx_deallocate_vp_id() from
list_del() to list_del_init(). A subsequent commit in the series refreshes
tvp after re-locking vport_slock in qla2x00_do_dpc_all_vps() and
qla2x00_alert_all_vps(), but leaves other ha->vp_list traversals unfixed.

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

[ ... ]

> @@ -7786,7 +7792,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
>  		qla2x00_configure_hba(vha);
>  		spin_lock_irqsave(&ha->vport_slock, flags);
>  		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> -			if (vp->vp_idx) {
> +			if (vp->vp_idx && !vp->flags.delete_progress) {
>  				atomic_inc(&vp->vref_count);
>  				spin_unlock_irqrestore(&ha->vport_slock, flags);
> =20
> @@ -7801,7 +7807,9 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
>  				qla2x00_vp_abort_isp(vp);
> =20
>  				spin_lock_irqsave(&ha->vport_slock, flags);
> +				/* Reference held under vport_slock keeps vp valid. */
>  				atomic_dec(&vp->vref_count);
> +				wake_up(&vp->vref_waitq);
>  			}
>  		}
>  		spin_unlock_irqrestore(&ha->vport_slock, flags);

[Severity: Medium]
Should the ha->vp_list traversals in qla2x00_quiesce_io() and
qla82xx_restart_isp() in drivers/scsi/qla2xxx/qla_init.c also check
vp->vp_idx and !vp->flags.delete_progress before taking a reference and
dropping ha->vport_slock?

In drivers/scsi/qla2xxx/qla_init.c, qla2x00_quiesce_io() (called from
qla2x00_do_dpc(), qla82xx_need_qsnt_handler(), and
qla8044_need_qsnt_handler()) drops ha->vport_slock without checking either
vp->vp_idx or !vp->flags.delete_progress:

	spin_lock_irqsave(&ha->vport_slock, flags);
	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
		atomic_inc(&vp->vref_count);
		spin_unlock_irqrestore(&ha->vport_slock, flags);

		qla2x00_mark_all_devices_lost(vp);

		spin_lock_irqsave(&ha->vport_slock, flags);
		atomic_dec(&vp->vref_count);
	}
	spin_unlock_irqrestore(&ha->vport_slock, flags);

Similarly, qla82xx_restart_isp() (called from qla82xx_error_recovery(),
qla82xx_fcoe_ctx_reset(), and qla8044_isp_reset()) checks vp->vp_idx, but
does not check !vp->flags.delete_progress before dropping ha->vport_slock:

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

If fc_vport_terminate() -> qla24xx_vport_delete() runs concurrently on a
vport after setting vha->flags.delete_progress =3D 1 (and after calling
qla24xx_disable_vp(), qlt_remove_target(), fc_remove_host(), and
scsi_remove_host()), couldn't qla2x00_quiesce_io() and
qla82xx_restart_isp() still operate on the deleting vport (including
re-enabling it via qla2x00_vp_abort_isp() -> qla24xx_enable_vp()) or
dereference a freed tvp when ha->vport_slock is dropped on a preceding list
entry?

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 90f09d36705a6..40b8cbdece7dd 100644
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
Can switching to list_del_init(&vha->list) in qla24xx_deallocate_vp_id()
still cause a use-after-free or an infinite loop with ha->vport_slock held
and interrupts disabled when racing with list_for_each_entry_safe(vp, tvp,
&ha->vp_list, list)?

In qla2x00_abort_isp_cleanup() and qla2x00_abort_isp() in
drivers/scsi/qla2xxx/qla_init.c, qla_pci_error_cleanup() in
drivers/scsi/qla2xxx/qla_os.c, and qla2x00_do_dpc_all_vps() and
qla2x00_alert_all_vps() in drivers/scsi/qla2xxx/qla_mid.c,
list_for_each_entry_safe() prefetches tvp =3D list_next_entry(vp, list)
before entering the loop body for vp. Only vp->vref_count is incremented
before spin_unlock_irqrestore(&ha->vport_slock, flags) drops the lock; no
reference is held on tvp.

While ha->vport_slock is dropped while processing vp (for example in
qla2x00_mark_all_devices_lost(vp) or qla2x00_vp_abort_isp(vp)), another
thread running qla24xx_vport_delete() in drivers/scsi/qla2xxx/qla_attr.c on
tvp can set tvp->flags.delete_progress =3D 1 and call
qla24xx_deallocate_vp_id(tvp):

	/* Allow timer to run to drain queued items, when removing vp */
	qla24xx_deallocate_vp_id(vha);
	...
	ql_log(ql_log_info, vha, 0x7088, "VP[%d] deleted.\n", id);
	scsi_host_put(vha->host);

Because atomic_read(&tvp->vref_count) is 0, qla24xx_deallocate_vp_id(tvp)
acquires ha->vport_slock, executes list_del_init(&tvp->list) (setting
tvp->list.next =3D &tvp->list), and returns, allowing qla24xx_vport_delete()
to free tvp via scsi_host_put(tvp->host).

When the traversal thread finishes processing vp, re-acquires
spin_lock_irqsave(&ha->vport_slock, flags), and advances the loop to
vp =3D tvp and tvp =3D list_next_entry(tvp, list):

1. It dereferences tvp (reading tvp->list.next, vp->vp_idx, and
   vp->flags.delete_progress) after tvp has been unlinked and potentially
   freed by scsi_host_put(tvp->host).

2. Because list_del_init(&tvp->list) set tvp->list.next =3D &tvp->list,
   list_next_entry(tvp, list) evaluates to tvp itself,
   !list_entry_is_head(vp, &ha->vp_list, list) remains permanently true,
   and the loop body skips unlocking ha->vport_slock because
   tvp->flags.delete_progress is 1. Doesn't this spin forever on the CPU
   with ha->vport_slock held and local interrupts disabled?

3. In addition, on the timeout path (!bailout) in
   qla24xx_deallocate_vp_id(), list_del_init(&vha->list) unlinks vha and
   qla24xx_vport_delete() proceeds to scsi_host_put(vha->host) even while
   vha->vref_count > 0 and a traversal thread is still actively using vha.

A later commit in the series ("scsi: qla2xxx: Re-acquire vport_slock and
refresh tvp during vport DPC") refreshes tvp =3D list_next_entry(vp, list)
after re-locking ha->vport_slock in qla2x00_do_dpc_all_vps() and
qla2x00_alert_all_vps(), but both loops in qla2x00_abort_isp_cleanup(), the
loop in qla2x00_abort_isp(), and both loops in qla_pci_error_cleanup() do
not refresh tvp after re-acquiring ha->vport_slock.

[ ... ]

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 0047c2bd531b3..5593dff7eb9b7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7941,13 +7941,15 @@ static void qla_pci_error_cleanup(scsi_qla_host_t=
 *vha)
> =20
>  	spin_lock_irqsave(&ha->vport_slock, flags);
>  	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> -		atomic_inc(&vp->vref_count);
> -		spin_unlock_irqrestore(&ha->vport_slock, flags);
> -		qla2x00_mark_all_devices_lost(vp);
> -		spin_lock_irqsave(&ha->vport_slock, flags);
> -		/* Check if vp is still valid before accessing it */
> -		if (vp->vp_idx && !vp->flags.delete_progress)
> +		if (vp->vp_idx && !vp->flags.delete_progress) {
> +			atomic_inc(&vp->vref_count);
> +			spin_unlock_irqrestore(&ha->vport_slock, flags);
> +			qla2x00_mark_all_devices_lost(vp);
> +			spin_lock_irqsave(&ha->vport_slock, flags);
> +			/* Reference held under vport_slock keeps vp valid. */
>  			atomic_dec(&vp->vref_count);
> +			wake_up(&vp->vref_waitq);
> +		}
>  	}
>  	spin_unlock_irqrestore(&ha->vport_slock, flags);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D10
