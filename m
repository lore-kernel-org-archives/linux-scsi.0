Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869B83E5A0B
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453111; cv=none; b=eSixa9Q8MQpQGifNXK7OYP2qY0db7yopxNVItVvumQFkzbpf2SbuXuZePZtcBMKyrqeEpExl9zaVA0rRuoASccFsOQxULf/o2zc1Mk5WEAHYOovANawsi5yAhJTaDKb+m3ZbJAIN0kk6z31t5O1+ViReMl/W7nqHDQtkRfFTRxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453111; c=relaxed/simple;
	bh=bCcpDqgBqZUEClDpYVpBD7vBrOCkBTvZshWl9Q5Bzmk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JVOIHohY8SjrgyRI+nhOj+jr0Mgi6X77i6G0VDagjoqRMolObYWJq4P0JnWviXKoC1ndmysLsQr4D+3QyjtPz3/LpSryF1tDaCSMQIUDSqa24F3DchFuCSLNoIRXWWPuGKOxYlfcZ+8+NPttdMmeQ5JD5SSEWsTz31Vtrhm76g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsNRJV/j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsNRJV/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078F01F000E9;
	Thu, 30 Jul 2026 23:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453109;
	bh=+6e7+3xpEEBIlsUwtvwj3x2bkdRr5fPGuI9FRQRsKfc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XsNRJV/jw0WN7x8Qk+kc/DERYGIKaIdt6echQVwxAJ8q5k+dIaDMBYYNuCF/AFCi2
	 2bpydeYFyRArwJwvswkF1vXY8il4IJ76E6QnuE3cZNToGYhkWmFrusKSAhSgv2VytJ
	 UIj30OuS/HrvxWnLt0+JHqocXnkTXLMQRNUlE0YXwvTReHHAECNr+GWEHNcx84o0Qh
	 NlNNrIM3z1mjAaVLiglauw3iAEZEOu96kiQXxNwDj4EGB2ycUxYtm65zLv86rWX3PT
	 ygHGB/o+9NInSLdopiFx1QQmOG4GRRVvvXQXDLk32Rm32G9CsItE0HGI7p13op2/6Z
	 Qo6dYKK+SIXJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 26/57] scsi: fnic: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <d10f7eaef0e297d1b78d1ba484b05686e185d8c7.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <d10f7eaef0e297d1b78d1ba484b05686e185d8c7.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:11:48 +0000
Message-Id: <20260730231149.078F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] IRQ state corruption due to mixed use of shared and local variable=
s for spinlock IRQ flags.
- [High] Use-After-Free when iterating over tport lists with list_for_each_=
entry_safe() and dropping the lock.
--

--- Patch [26]: [PATCH v3 26/57] scsi: fnic: Enable lock context analysis -=
--
commit b5089a03ad2ecce02a0412b046877b7375670d2d
Author: Bart Van Assche <bvanassche@acm.org>

scsi: fnic: Enable lock context analysis

This commit documents locking requirements across the fnic driver by adding
__must_hold(), __acquire(), and __release() annotations. This allows static
analysis tools to verify that spinlocks and mutexes are held in the required
contexts, suppressing false positives.

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -425,8 +426,8 @@ void fnic_del_fabric_timer_sync(struct fnic *fnic)
>  	fnic->iport.fabric.del_timer_inprogress =3D 0;
>  }
> =20
> -void fnic_del_tport_timer_sync(struct fnic *fnic,
> -						struct fnic_tport_s *tport)
> +void fnic_del_tport_timer_sync(struct fnic *fnic, struct fnic_tport_s *t=
port)
> +	__must_hold(&fnic->fnic_lock)
>  {
>  	tport->del_timer_inprogress =3D 1;
>  	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);

[Severity: High]
This is a pre-existing issue, but does this pattern risk corrupting the IRQ
state?

Functions like fdls_tport_timer_callback() and fnic_tport_event_handler()
acquire the lock using a local stack variable:

    spin_lock_irqsave(&fnic->fnic_lock, flags);

If they subsequently call down into fnic_del_tport_timer_sync() (which drops
the lock using the shared fnic->lock_flags), it restores a stale IRQ state
belonging to a completely different thread, since the local acquisition nev=
er
updated the shared fnic->lock_flags. Could this erroneously enable or
disable IRQs prematurely?

[ ... ]

> @@ -1322,6 +1334,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, str=
uct fnic_tport_s *tport)
>  }
> =20
>  bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *=
tport)
> +	__must_hold(&iport->fnic->fnic_lock)
>  {
>  	struct fnic_tport_event_s *tport_del_evt;
>  	struct fnic *fnic =3D iport->fnic;

[Severity: High]
This isn't a bug introduced by this patch, but does dropping the lock in th=
is
function expose the driver to a Use-After-Free during list iteration?

Functions such as fdls_process_gpn_ft_tgt_list() iterate over the
iport->tport_list using list_for_each_entry_safe(tport, next, ...):

    list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
        ...
        fdls_delete_tport(iport, tport);
    }

Inside fdls_delete_tport(), the fnic_lock is temporarily dropped to call
functions like fnic_rport_exch_reset(). While the lock is dropped, a
concurrent thread (like an incoming ELS frame reject or a workqueue event)
can acquire the lock and free the exact tport pointed to by the cached
next pointer. When the original loop reacquires the lock and proceeds to
the next iteration, wouldn't it dereference the freed next pointer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D26
