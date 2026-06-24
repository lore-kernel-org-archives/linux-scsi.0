Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DF4257844
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277739; cv=none; b=ak4WEUeIiVHIYqVbDhqjVLXtHxHPNmYlx4bjO1OQtmsN2QVziv278onzfevxLK9HigwPuMCQ+jBC3mOAm0+DdtCN2rBRFT9q/pfUxrvzTmHt79sazM97b3/jv0tVFoLAuF5NP1/SxLOhCFbPsYIDy0zad7k5vyjy8XKjDgLUOiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277739; c=relaxed/simple;
	bh=1Wy1FnA5SzGh0I09tlL5y/jvHpyFdhWwn8iZKivO9dc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AAb6k6satkZWXkHxfO4WvwHY0cOWVPF6WgJREvAEGRHL9r/R7OgOba1evv8v0nxT+3ZDbsaPvN26/Hj1qlEOjWRrh9AYwYLF6Vz64CCsIntbqT9xjNa2ajuUjDBfW6a4I9fbOVyKqOEGfLZ8DWb/ZPqTGvB3ZhTM6fxbnTg982o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkKQR+r1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkKQR+r1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA3D1F000E9;
	Wed, 24 Jun 2026 05:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277738;
	bh=632NLJ4YA5JoO4wfvcEa79pdp/AVTaS1s5yepRx6cMg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hkKQR+r1135CHHYD2ooNMtegBI72oAjBN2nayda7tUzaKV3JyRsh3tAJFPpcqq26Z
	 1o4TQVhRTqjWWxxMkXFoVr3m+fpdsfNw6Ff0RB2mKE40vO4BoDBuM20jL549aO/jPN
	 tTUDo17gXRAKoNB0vuNi1TJEFxjNCLktSzPFE/bHXKa9ZLXNwwNdUfVueKcxm1vgI/
	 yRq3AQbeIYxPy098sPV4xiHdkmN3azI/XvySOGriU1iIdQSbFj2w2GnFOt/qb65uRl
	 ZCPfKNB8wLQx6NAcsgWQ9Rdv9DUWj9Q+f7u0CKiVOb2CiqW9IouNcF3sPvWS+adOS2
	 3RaxFF52S54tA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/13] scsi: fnic: Make debug logging protocol
 independent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-2-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-2-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:08:57 +0000
Message-Id: <20260624050858.1FA3D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Shared struct member used as the flags argument in spin_lock_irqsa=
ve() causing IRQ state corruption.
- [High] Lockless modification of fnic_priv(sc)->flags after dropping wq_co=
py_lock leads to data races and potential Use-After-Free.
--

commit d6c65edf1de54a8d582352945f8226579f06a57d
Author: Karan Tilak Kumar <kartilak@cisco.com>
Subject: scsi: fnic: Make debug logging protocol independent

Make the fnic debug macros take struct fnic instead of struct Scsi_Host so
FCP and NVMe initiator roles can share the same logging interface. Route FCP
messages through shost_printk() and NVMe messages through printk(). Convert
existing debug call sites to pass the fnic instance directly.

> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index 063eb864a5cd0..ca592bc3f6182 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -1014,7 +1014,7 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
> =20
>  	spin_lock_irqsave(&fnic->fnic_lock, flags);
>  	list_for_each_entry_safe(tport, next, &fnic->iport.tport_list, links) {
> -		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		FNIC_FCS_DBG(KERN_INFO, fnic,
>  					 "removing fcp rport fcid: 0x%x", tport->fcid);
>  		fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
>  		fnic_del_tport_timer_sync(fnic, tport);

[Severity: High]
This is a pre-existing issue, but can the call to fnic_del_tport_timer_sync=
()
corrupt the CPU's IRQ state here?

In fnic_delete_fcp_tports(), the lock is acquired using a local flags
variable:

	spin_lock_irqsave(&fnic->fnic_lock, flags);

However, inside fnic_del_tport_timer_sync(), the lock is released and
reacquired using the shared fnic->lock_flags struct member:

	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
	timer_delete_sync(&tport->retry_timer);
	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);

Would restoring the IRQ state from the uninitialized or stale fnic->lock_fl=
ags
leave interrupts incorrectly enabled or disabled? The same pattern also exi=
sts
in fnic_tport_event_handler() where it acquires the lock using a local flags
variable but later calls fdls_delete_tport().

[ ... ]

> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 6ee3c559e129c..0759540f66753 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -1255,7 +1254,7 @@ static void fnic_fcpio_itmf_cmpl_handler(struct fni=
c *fnic, unsigned int cq_inde
>  		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
>  		spin_unlock_irqrestore(&fnic->wq_copy_lock[hwq], flags);
>  		fnic_priv(sc)->flags |=3D FNIC_IO_ABT_TERM_REQ_NULL;
> -		shost_printk(KERN_ERR, fnic->host,
> +		fnic_printk(KERN_ERR, fnic,
>  			  "itmf_cmpl io_req is null - "

[Severity: High]
This is a pre-existing issue, but could this lockless modification cause a =
data
race or a use-after-free?

In fnic_fcpio_itmf_cmpl_handler(), fnic_priv(sc)->flags is modified
immediately after dropping the wq_copy_lock. If io_req is NULL, it indicates
the IO request has already been cleaned up. Once cleaned up, the block layer
may have already completed the SCSI command via scsi_done() and freed or
recycled the scsi_cmnd structure.

Is it possible that modifying the command's flags locklessly here will resu=
lt
in memory corruption of a newly recycled or freed command? This pattern also
appears to exist in fnic_abort_cmd() and fnic_pending_aborts_iter().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D1
