Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792752789;
	b=R1T3wPJ7yjXP9KzK/1SvYu+iLBreBYGBvnjos5rEg9tJREWranJo5E6Uy9RQUqBa5nr+
	 3UtYvxRd6I6iHMr5uEcS+4EW0SdKRiOR1Y2qkhaeQffXzKvkC7/DjnnqULOU3jutxwkAG
	 +EU+X8MBWaMbtFcCu0+SHET6PoecdRCMq8ZwbY6i7z7+83qTIK6S2CZ+H3cX6HYvzB8pO
	 LmvfHUvOXklP+XMruIFyGb4Bjt6QlV4LEDrZTgRuqlZarHfAGgQL6Kvu+6wmFsVBoxA2e
	 qhbluU65JCt9rojnse80WlDCd/DWn+r7MdZivsNH/p6q/QVyMSjGj4r8i44rkzUpZpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792752789;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Di1na/ICzYvUykV9nnK8q75Yoh75Ke64Yk2Re2KvO3k=;
	b=l4ubu7hnR9zz56TvSsBt5+QrSnt3nVkKp5+gHSJ8bQHeYijCzCbje2p5xxBiHT6VshAE
	 6AUqpzYzXebCzsIoGH6Z04hdlTG2ThQ/PSfppjAlMqrsVDPg3qOE11yJxRtnDAQF27zxd
	 5IX9iMW2qhixO0TFHdgjyX5k2TBcotAwIV9fmaDG1tKEJ9Mmh9H9nuf6krQG2pUxVIEr4
	 zWYrcSRLjF+MYYxx3fFI+NX16Gzx+rpmS4BKzHYsLY6bR9DAPU+1i/VNZxzn10fvyA3zi
	 SYWGhMj97fSGGUYHLb9xnfE3BT8MwD+qx1YQmYn+IYfGKtuFJ7l2UpO+Q6qKadDxSpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2scgGmC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA689606A31B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2scgGmC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A461F01825;
	Fri, 23 Oct 2026 10:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792752788;
	bh=Di1na/ICzYvUykV9nnK8q75Yoh75Ke64Yk2Re2KvO3k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C2scgGmCuVXVstpOerAVjL/rlM1TEFeAbWxyJLdz+oyV8PfTA4zzZc31vb/HFCQ7e
	 TYvgCIqlWAIXwiAlbf5XdF9L3djTmmHG8ZULssf/gUxrx67n1KSECDtbUsfn0tRf8O
	 kmgmnZCslHn4bCf+kXfQgYLPs1XVwtfSuZKDbB/FKHrMQxGLh9RwnYePPAt+5nuaIC
	 YpVTiTK+NCHl0EMoBAfHmrd9eFEqsP7GEmcZZ70p6sEdG3IFb0y731T3j6hXibXZrf
	 Lci2PBlPNxh9knHDwI+rXVVBi0xNgIHcc5nTlhiOkGcbCm6ucYyjdSjX16rl+rUbgE
	 CpmusduJ3jucw==
Message-ID: <sashiko-outbox-182708@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 11/13] scsi: qla2xxx: Re-acquire vport_slock and
 refresh tvp during vport DPC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-12-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-12-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:53:07 +0000
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
- [Critical] scsi: qla2xxx: use-after-free on vp in qla2x00_do_dpc_all_vps(=
) on timeout
- [Critical] scsi: qla2xxx: unrefreshed tvp in vp_list loops causes hard lo=
ckup and UAF
--

commit a9b1443e24db2e5c7bc6bc02893d52ce93b6f5cf
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC

This commit re-acquires vport_slock using a spin_trylock_irqsave() and
cond_resched() loop in qla2x00_do_dpc_all_vps(), refreshes the next list en=
try
tvp after re-locking in qla2x00_do_dpc_all_vps() and qla2x00_alert_all_vps(=
),
and adds a cond_resched() before qla2x00_loop_resync() in qla2x00_do_dpc_vp=
().

> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 754c806dac807..65dcfc1b04ef9 100644
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

[ ... ]

> @@ -446,11 +451,28 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
>  			spin_unlock_irqrestore(&ha->vport_slock, flags);
> =20
>  			qla2x00_do_dpc_vp(vp);
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
Can accessing vp here (and vha in qla2x00_alert_all_vps() above) trigger a
use-after-free when qla24xx_deallocate_vp_id() times out?

Neither qla2x00_do_dpc_all_vps() nor qla2x00_alert_all_vps() takes a
Scsi_Host reference via scsi_host_get() before dropping ha->vport_slock.
If a concurrent vport deletion in qla24xx_vport_delete() calls
qla24xx_deallocate_vp_id() and the wait for vref_count to reach zero times
out, qla24xx_deallocate_vp_id() forcibly removes vha from ha->vp_list even
while vref_count is still non-zero:

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
}

Immediately after qla24xx_deallocate_vp_id() returns, qla24xx_vport_delete()
frees vha's resources and drops the final host reference:

drivers/scsi/qla2xxx/qla_attr.c:qla24xx_vport_delete() {
	...
	qla24xx_deallocate_vp_id(vha);
	...
	scsi_host_put(vha->host);
}

Because list_empty(&vp->list) only becomes true while vref_count > 0 when t=
hat
deallocate timeout occurs, wouldn't vp (or vha in qla2x00_alert_all_vps())
already be freed or in the middle of being freed by the time this thread
re-acquires ha->vport_slock and accesses vp->vref_count, vp->vref_waitq, and
vp->list?

> +			tvp =3D list_next_entry(vp, list);

[Severity: Critical]
What about the other list_for_each_entry_safe(vp, tvp, &ha->vp_list, list)
loops that drop and re-acquire ha->vport_slock without refreshing tvp?

Since qla24xx_deallocate_vp_id() uses list_del_init(&vha->list) when
vref_count =3D=3D 0, any concurrent deletion of the prefetched next entry t=
vp
while ha->vport_slock is dropped sets tvp->list.next to point to itself and
frees tvp via qla24xx_vport_delete() -> scsi_host_put().

The following functions still iterate over ha->vp_list with
list_for_each_entry_safe(), drop ha->vport_slock inside the loop body, and =
do
not refresh tvp after re-acquiring the lock:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_quiesce_io()
drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp_cleanup() (two loops)
drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp()
drivers/scsi/qla2xxx/qla_init.c:qla82xx_restart_isp()
drivers/scsi/qla2xxx/qla_os.c:qla_pci_error_cleanup() (two loops)

For example, in qla2x00_abort_isp():

drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp() {
	...
	spin_lock_irqsave(&ha->vport_slock, flags);
	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
		if (vp->vp_idx && !vp->flags.delete_progress) {
			atomic_inc(&vp->vref_count);
			spin_unlock_irqrestore(&ha->vport_slock, flags);

			qla2x00_vp_abort_isp(vp);

			spin_lock_irqsave(&ha->vport_slock, flags);
			/* Reference held under vport_slock keeps vp valid. */
			atomic_dec(&vp->vref_count);
			wake_up(&vp->vref_waitq);
		}
	}
	spin_unlock_irqrestore(&ha->vport_slock, flags);
}

If tvp is deleted while ha->vport_slock is dropped in any of those loops,
won't the next iteration dereference the freed tvp and then spin forever wi=
th
interrupts disabled because tvp->list.next points to itself?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D11
