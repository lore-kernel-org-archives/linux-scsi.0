Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579059;
	b=E97f79WFdyVhA4xOTEPziTGx0WFTSgoENuLxN5ccwrsjqWOE8qSl5uSWkkTR3sQmRzmo
	 qsPIIA+oTV/4ycQkOWUliQXFPfxPASlBMzvbxOECl4Ic3Rr3rF+vkC9wSi0dsUGuhmSUP
	 4D+H3Cil9KzUkdA2kfwCjY1I1qUT/tgqfKaC4pLrjeAQDk/cRMzJSb33Di6kzkJrakiVJ
	 n0wLEYMq998ZKyDi27vtWXAEr1BWRTqeKKuieKZ6ixUMP5J5zGcQDoAKXOfg+AfeBsrni
	 40kFbcF9SG47WteLDajKObTjiVaEzg0GypcAAOuNMa9fw6w6Jp4XiLHAmFkrnBLNlgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579059;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+miq/7YoU/WJ1P7kIq5mOVwXcpwS8c3F8YVo5eptDhA=;
	b=p79bZ4lojc/ZH4BYzQVcmthD0U8RyuKBxOA4BG3M1I0n2TaU6R8fh1lS7NQJFSqVf9r9
	 Adttus5SbDGErXy7d4+W9T/O4OiEGg8XmIWkcV9NFH4xGKRo14CQAtrIKCglMo+RnVfAU
	 EKRzLxmgiSz9HbhkV8t8OsXQ+Ut7psfgLnO+aGCZwwJrNSIWwZkR+d+H6SfyMJ896A2Ym
	 P5+yAFYtIK9eQNF+OmS3d9hA1VI8jEJUbDERNn/5Fx+iN2FEvqT+n1/tAeKTEjAuvcb7S
	 zKMZ5zXLQkSbQ/JPxEGU4XzOU0A5Z8yL/8VqLm0k4JWbGiRU9DZEIZNOetTa/4eXTBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DYm/pGPB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BB9606A31D
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYm/pGPB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDFB1F000CA;
	Wed, 21 Oct 2026 10:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579058;
	bh=+miq/7YoU/WJ1P7kIq5mOVwXcpwS8c3F8YVo5eptDhA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DYm/pGPBLfKtLyDsbZ5gyWVhE9w2FpbxSoDUDJeBOS2DhzCM9CJKj/9Y9D7U8D4We
	 haUScRKyjVBUaZSfQsb7d7PtboaM4hQCqJga4NOg1Lu9SgoRfttCncWBDhpACrvr6n
	 pnfwt41z8TvudromuiuIIt/fAtYuyTs60GTR6eXlGXQXzkpyraoU6RtpSCLDZuSc06
	 jxBXFQY+dq0CtmnbEFTbmMgQdaQpDkFOVC/eKraPedCHLVnvrcARSQ0s8QjkphivkC
	 AAKTEUKRSZJXO153HehAQ//27C1Ul0yMt44GGankzgX16yYTIxL4/8CLtai6qOqcSd
	 pJXZTzzU/S5pw==
Message-ID: <sashiko-outbox-180108@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/14] scsi: qla2xxx: Yield work_lock in fabric scan
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-13-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-13-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:37:38 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: qla2xxx: wrong lock targeted with trylock loop in qla_fab_sc=
an_finish()
--

commit 97d6a044424099a02acc895f356a103166186107
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Yield work_lock in fabric scan path

This commit replaces spin_lock_irqsave(&vha->work_lock, flags) in
qla_fab_scan_finish() with a spin_trylock_irqsave() and cond_resched() loop
to avoid a hard lockup observed during vport deletion.

> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index efe98609c149d..31308a6148585 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3386,7 +3386,9 @@ void qla_fab_scan_finish(scsi_qla_host_t *vha, srb_=
t *sp)
>  	recheck =3D 1;
>  out:
>  	qla24xx_sp_unmap(vha, sp);
> -	spin_lock_irqsave(&vha->work_lock, flags);
> +	/* Avoid hard lockup: yield if work_lock is held instead of spinning */
> +	while (!spin_trylock_irqsave(&vha->work_lock, flags))
> +		cond_resched();
>  	vha->scan.scan_flags &=3D ~SF_SCANNING;
>  	spin_unlock_irqrestore(&vha->work_lock, flags);
> =20

[Severity: High]
Is this targeting the right spinlock for the hard lockup shown in the commit
message, and is a trylock loop safe here?

In the qla2x00_iocb_work_fn() -> qla2x00_do_work() -> qla_fab_scan_finish()
path, the static helper qla2x00_is_a_vp() is inlined into the
max_fibre_devices scan loop in qla_fab_scan_finish():

drivers/scsi/qla2xxx/qla_gs.c:qla2x00_is_a_vp() {
	...
	spin_lock_irqsave(&ha->vport_slock, flags);
	list_for_each_entry(vp, &ha->vp_list, list) {
		twwn =3D wwn_to_u64(vp->port_name);
		if (wwn =3D=3D twwn) {
			rc =3D 1;
			break;
		}
	}
	spin_unlock_irqrestore(&ha->vport_slock, flags);
	...
}

drivers/scsi/qla2xxx/qla_gs.c:qla_fab_scan_finish() {
	...
	for (i =3D 0; i < vha->hw->max_fibre_devices; i++) {
		...
		/* Bypass virtual ports of the same host. */
		if (qla2x00_is_a_vp(vha, wwn))
			continue;
		...
	}
}

Looking at the registers in the backtrace:
- rbp is 0xffff98b803e60a58, which is vha (at the shost_priv offset 0xa58),
  where &vha->work_lock at offset 0x30 would be 0xffff98b803e60a88.
- rdi (the lock pointer passed to _raw_spin_lock_irqsave) is
  0xffff98b149ff6488, which is at offset 0x488 of struct qla_hw_data *ha
  (0xffff98b149ff6000), matching &ha->vport_slock (as also seen in commits
  79b305e1e477, 0334585318b2, and 200e63c70fc1).
- r10 and r15 hold 0x2100000eddd08241 (the 64-bit port name wwn passed to
  qla2x00_is_a_vp(vha, wwn)), r13 holds 0xffffb9a8a4555000 (vha->scan.l),
  rcx holds 0x800 (vha->hw->max_fibre_devices), and r12 holds 0xc000
  (2048 * sizeof(struct fab_scan_rp)).

This indicates the worker was spinning on &ha->vport_slock inside
qla2x00_is_a_vp() rather than on &vha->work_lock at the out label.

In addition, vha->work_lock is not taken in the vport delete path
(qla24xx_vport_delete() -> qla24xx_disable_vp() ->
qla24xx_deallocate_vp_id()) and is only held across short, non-blocking flag
and list updates with interrupts disabled. By contrast, ha->vport_slock
protects ha->vp_list during vport deletion, where several
list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) loops (such as in
qla2x00_abort_isp_cleanup(), qla2x00_abort_isp(), qla2x00_quiesce_io(),
qla82xx_restart_isp(), and qla_pci_error_cleanup()) drop and re-acquire
ha->vport_slock without refreshing tvp if qla24xx_deallocate_vp_id() removes
an entry via list_del_init(&vha->list).

Could replacing spin_lock_irqsave(&vha->work_lock, flags) with a
spin_trylock_irqsave() + cond_resched() loop also introduce regressions by
bypassing queued spinlock fairness and realtime priority inheritance,
busy-looping without cpu_relax() while toggling interrupts when
need_resched() is false, or livelocking the qla2xxx_wq worker if the lock is
ever stuck (leaving scan_flags with SF_SCANNING set and hanging
flush_workqueue(vha->hw->wq) in qla2x00_wait_for_sess_deletion())?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D12
