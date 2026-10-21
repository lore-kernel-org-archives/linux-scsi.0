Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579399;
	b=xAirfXYIp/9JcKTdSEEvdcEQLxLZ1ABo+ZiU5RI36vV8MvtJ1ShuxyKIWwrEuNybLk4C
	 W+0gHUhC/ZS65OMFAboQiktcZSrnhuUBVgiCp1LDS17gFv3Ljt8tpUQXw1V8Kj1c/n07u
	 pFEPdOBQUKuaKJ1M1eK+KmLLmsg9BtfW3Y65D+LOXkMExmmhx5NPEf+ZO3AUE9Rvyl7SX
	 RijBDub7oDqZ8hsy2DcWeaT01iALTBYoiy+3NunWU1kr0y2h7nDu+ruKN57nGFaGPmCqT
	 jMK1in+nvgrkQHhGNeJRRbh0YEA3phNBpbyUGk/vm+hMsRC7qJ4SxWKQz3kjSsPZ+Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579399;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p/MtpvwMDtqH9MIN2yMg00Cjo/rU6crLSa5zr8fLTEE=;
	b=3gaW3D8KWvq650QYTta5rOFKaJqYx/5l7UBKWVYcUIVcKL3/qPHYuwW7wCEnWKjF99g6
	 zs/0SyV0JrPXafmQKHAlEti2iUwBkdf5zadtRtGra3S6hG8vOBEdXxCu9/59YqulDQTkF
	 jBEuivRB7J6B72oal0nkLrynt57467Axd1g9f3SMVKlv/2ot2+ov20DzwJBcRrY2L3vS8
	 eUyHmCMUuS5Jftr+RAkJYR1RAX6nPMo346iTUCU/nac1PZUjGMpbkCVcM8Ty4dgzTzqr9
	 aY0FoNBNhSixWef3hjXFyx5s9FicILTj9CSzZ7NB3pmwiVGljXJH0v/CkmPHazpqA5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="V/PJIMud";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373E1606A31B
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V/PJIMud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD51F000C9;
	Wed, 21 Oct 2026 10:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579398;
	bh=p/MtpvwMDtqH9MIN2yMg00Cjo/rU6crLSa5zr8fLTEE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V/PJIMudkrrWA4T20SXSWHks9yJh++cZg8zy2ykZHc63JK7LSb9ZhjNuYwuilZmhL
	 tR+sVHPIaSc+OfyD65xNBYL1LQNuL6ja0eEjCcycWRjr54RdyHbs4HP770aWMGtQoh
	 0gOnmpF6ZJUKsI3V4sMJwKEPa+ehdij4IdKOTV3SHTlBAEhAVfN6ARx7eJ+mkJQxCI
	 9QE8PPZ4v1+i94hS/03UvyOfKZs3quwwuklTtWFcsfGPD9e8OpFswdJQlRpWMBkzXZ
	 CLAfnMA8j1LAkZ581srDy6PtE5H2rMemPbuu/1xLO4At+whGdBlDeYD0gB/7pV8zO4
	 bjNfHcrro0pzw==
Message-ID: <sashiko-outbox-180112@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/14] scsi: qla2xxx: Re-acquire vport_slock and refresh
 tvp during vport DPC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-12-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-12-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:43:18 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] scsi: qla2xxx: use-after-free on vp after qla24xx_deallocate_v=
p_id() timeout
- [High] scsi: qla2xxx: unrefreshed tvp in vp_list loops causes UAF and har=
d lockup
- [Medium] scsi: qla2xxx: qla2x00_do_dpc_all_vps() ignores VPORT_DELETE flag
--

commit 79b305e1e477e502cc6c7c1eafc4b56d4645915e
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC

This commit changes qla2x00_do_dpc_all_vps() to re-acquire vport_slock
using a spin_trylock_irqsave() and cond_resched() loop, and refreshes the
next list entry pointer tvp in qla2x00_do_dpc_all_vps() and
qla2x00_alert_all_vps() after re-locking. It also adds a cond_resched() call
before qla2x00_loop_resync() in qla2x00_do_dpc_vp().

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 40b8cbdece7dd..a2d76c8e81e5f 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -315,6 +315,10 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t =
*mb)
>  			/* Reference held under vport_slock keeps vha valid. */
>  			atomic_dec(&vha->vref_count);
>  			wake_up(&vha->vref_waitq);
> +			/* refresh tvp from the current list state */
> +			if (list_empty(&vha->list))
> +				break;
> +			tvp =3D list_next_entry(vha, list);
>  		}
>  		i++;
>  	}
> @@ -409,6 +413,7 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
>  		if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))) {
>  			ql_dbg(ql_dbg_dpc, vha, 0x401a,
>  			    "Loop resync scheduled.\n");
> +			cond_resched();
>  			qla2x00_loop_resync(vha);
>  			clear_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags);
>  			ql_dbg(ql_dbg_dpc, vha, 0x401b,
> @@ -445,11 +450,28 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
>  			spin_unlock_irqrestore(&ha->vport_slock, flags);
> =20
>  			qla2x00_do_dpc_vp(vp);

[Severity: Medium]
In drivers/scsi/qla2xxx/qla_mid.c, qla2x00_do_dpc_all_vps() checks
!vp->flags.delete_progress before dropping ha->vport_slock and calling
qla2x00_do_dpc_vp(vp), but unlike qla2x00_alert_all_vps() it does not check
test_bit(VPORT_DELETE, &vp->dpc_flags).

In drivers/scsi/qla2xxx/qla_attr.c, qla24xx_vport_delete() sets VPORT_DELETE
and waits for LOOP_RESYNC_ACTIVE to clear, then performs several blocking
teardown calls before setting vha->flags.delete_progress =3D 1:

drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete() {
	...
	set_bit(VPORT_DELETE, &vha->dpc_flags);

	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))
		msleep(1000);


	qla24xx_disable_vp(vha);
	qla2x00_wait_for_sess_deletion(vha);

	qla_nvme_delete(vha);
	qla_enode_stop(vha);
	qla_edb_stop(vha);

	vha->flags.delete_progress =3D 1;
	...
}

Should qla2x00_do_dpc_all_vps() (or qla2x00_do_dpc_vp()) also check
test_bit(VPORT_DELETE, &vp->dpc_flags) so that it cannot start a new
qla2x00_loop_resync(), qla24xx_configure_vp(), or qla24xx_post_relogin_work=
()
after qla24xx_vport_delete() has already passed the LOOP_RESYNC_ACTIVE wait?

> -
> -			spin_lock_irqsave(&ha->vport_slock, flags);
> -			/* Check if vp is still valid before accessing it */
> -			if (vp->vp_idx && !vp->flags.delete_progress)
> -				atomic_dec(&vp->vref_count);
> +			cond_resched();
> +
> +			/* Re-acquire lock with yield to avoid hard lockup if holder is delay=
ed */
> +			while (!spin_trylock_irqsave(&ha->vport_slock, flags))
> +				cond_resched();
> +			/* Reference held under vport_slock keeps vp valid. */
> +			atomic_dec(&vp->vref_count);
> +			wake_up(&vp->vref_waitq);
> +			/*
> +			 * While the lock was dropped, the next entry (tvp) may
> +			 * have been removed via list_del_init(), making its
> +			 * list.next point to itself. list_for_each_entry_safe
> +			 * would then loop infinitely since the self-referencing
> +			 * pointer never matches the list head.
> +			 *
> +			 * If vp itself was removed (deallocate timeout), we
> +			 * cannot continue iterating from it, break out.
> +			 * Otherwise refresh tvp from the current list state.
> +			 */
> +			if (list_empty(&vp->list))
> +				break;

[Severity: Critical]
Can this trigger a use-after-free on vp in qla2x00_do_dpc_all_vps() (and on
vha in qla2x00_alert_all_vps() above) when the deallocate timeout occurs?

When qla2x00_do_dpc_all_vps() or qla2x00_alert_all_vps() drops
ha->vport_slock, it only increments vref_count without taking a reference on
the underlying Scsi_Host via scsi_host_get().

If qla2x00_do_dpc_vp(vp) (which performs synchronous mailbox commands,
firmware readiness waits, loop resync, and cond_resched()) or
qla2x00_async_event() plus the spin_trylock_irqsave() loop takes longer than
the 10 second wait in qla24xx_deallocate_vp_id(), the timeout path unlinks
vha->list under ha->vport_slock while vref_count is still non-zero:

drivers/scsi/qla2xxx/qla_mid.c:qla24xx_deallocate_vp_id() {
	...
	if (!bailout) {
		ql_log(ql_log_info, vha, 0xfffa,
			"vha->vref_count=3D%u timeout\n", vha->vref_count.counter);
		spin_lock_irqsave(&ha->vport_slock, flags);
		list_del_init(&vha->list);
		qla_update_vp_map(vha, RESET_VP_IDX);
		spin_unlock_irqrestore(&ha->vport_slock, flags);
	}
	...
}

Immediately after qla24xx_deallocate_vp_id(vha) returns,
qla24xx_vport_delete() in drivers/scsi/qla2xxx/qla_attr.c proceeds to tear
down vha and free the Scsi_Host containing vha:

drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete() {
	...
	/* Allow timer to run to drain queued items, when removing vp */
	qla24xx_deallocate_vp_id(vha);
	...
	scsi_host_put(vha->host);
	return 0;
}

By the time qla2x00_do_dpc_all_vps() or qla2x00_alert_all_vps() re-acquires
ha->vport_slock in this timeout case, wouldn't vp (or vha) already be freed
when atomic_dec(&vp->vref_count), wake_up(&vp->vref_waitq), and
list_empty(&vp->list) access it?

> +			tvp =3D list_next_entry(vp, list);

[Severity: High]
Are the other list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) loops in
the driver that drop ha->vport_slock susceptible to the same stale tvp
infinite loop and use-after-free?

In drivers/scsi/qla2xxx/qla_init.c, qla2x00_quiesce_io(), both loops in
qla2x00_abort_isp_cleanup(), qla2x00_abort_isp(), and qla82xx_restart_isp()
all drop ha->vport_slock while holding only vp->vref_count, leaving
tvp->vref_count at zero without refreshing tvp after re-locking:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp_cleanup() {
	...
		spin_lock_irqsave(&ha->vport_slock, flags);
		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
			if (vp->vp_idx && !vp->flags.delete_progress) {
				atomic_inc(&vp->vref_count);
				spin_unlock_irqrestore(&ha->vport_slock, flags);

				qla2x00_mark_all_devices_lost(vp);

				spin_lock_irqsave(&ha->vport_slock, flags);
				/* Reference held under vport_slock keeps vp valid. */
				atomic_dec(&vp->vref_count);
				wake_up(&vp->vref_waitq);
			}
		}
		spin_unlock_irqrestore(&ha->vport_slock, flags);
	...
}

The same pattern also appears in both vp_list loops in
qla_pci_error_cleanup() in drivers/scsi/qla2xxx/qla_os.c.

If a concurrent qla24xx_vport_delete() -> qla24xx_deallocate_vp_id() removes
and frees tvp via list_del_init(&tvp->list) and scsi_host_put(tvp->host)
while ha->vport_slock is dropped in those functions, won't the next loop
iteration dereference the freed tvp and spin forever on the self-referencing
list node with interrupts disabled?

>  		}
>  	}
>  	spin_unlock_irqrestore(&ha->vport_slock, flags);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D11
