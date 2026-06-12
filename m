Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AE633123D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781300580; cv=none; b=F3pMPti1HCnTCZUOxOKeXbxWK2Uj7UeiNtMXf7B5KgeVE0kyHDIVxsJVRNrhuuZej3PDO1XeKHn+CG0kAesJ8NpmJvZ/BqZz0zdDx6tXbZppv5xiQuwdT/I0qLbn01BTqGC3a5PrISvRVPWE5N5TCU5KH9znfK3CoPGf/42QC/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781300580; c=relaxed/simple;
	bh=rV/z4XLIWLbk14YY/4L/E/6KFWe7uLmiHDydrAE40Us=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hKmYpcNLCQXyi0t25EuDuXcBEEvNVX67pGurghbuR08PvokIQ8sIWN5vPcGosm2Utvz4prPWuTFaLO8azTs2So2NZCD2DkkkkJouWyiwJXfYbqE/RgGvux1yz/fn71/eLJ7ZEPf8EkCxqIfHVXqFkhkoSR6EVxhTyeegABe7k/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aThzYMRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aThzYMRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311271F000E9;
	Fri, 12 Jun 2026 21:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781300578;
	bh=lZLr3arQdIdvbIPjZ5GchdytK4B17r9l6SGsFMVRjZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aThzYMRA7UmG6Itn5ZLr1aEQvxCBGTXlEJwlvME1vBOAsIbN5+NAKzTyTxzBPWcO8
	 RNjc3wMlOLmmOVgi4lMhoYDyCpWxV+Swb7wayJBgQxocKSRYEOmGCfi5RWojpqxM/X
	 pHpSG0LbPiUO6OTisVpzWTB2ffhPZpVN7uC1sxLzJqlK4GTVpzfFPrCpD+06YJMtcp
	 jivMrm3jxD0so2PgY87dmqkjvEAbkLzN6NkoeDpanR7supLAr9h8t7s3l6r179f7lN
	 qAP9FfQMCqvBrKx7TLyRyWipS6KOqZZ5td+Bqgc25VgvMLb0r4oVez4d6lMqz3N+OL
	 AmwjyKw+XjPUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/13] scsi: fnic: Add FDLS role handling for NVMe
 initiators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-6-kartilak@cisco.com>
References: <20260612180918.8554-6-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 21:42:57 +0000
Message-Id: <20260612214258.311271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

New issues:
- [High] The 'Establish Image Pair' flag (FC_SPP_EST_IMG_PAIR) is omitted i=
n the NVMe PRLI Service Parameters.
- [High] NVMe PRLI frame payload is truncated by 4 bytes, violating the spe=
cified prli_len and omitting the end of the NVMe SPP.

Pre-existing issues:
- [High] Dereference of freed `tport` pointer in `fnic_tport_event_handler`=
 if a link down occurs before the event is processed.
- [High] Missing cancellation of iport->fabric.retry_timer upon module unlo=
ad causes UAF.
- [High] Dropping the list-protecting lock inside list_for_each_entry_safe =
leads to a Use-After-Free if concurrent threads delete the 'next' element.
- [High] Functions drop and reacquire `fnic_lock` using the shared `fnic->l=
ock_flags` instead of the local `flags` saved by the caller, potentially co=
rrupting IRQ state.
- [High] FCoE frames are permanently leaked when send or queue operations f=
ail, leading to kernel memory exhaustion (OOM).
- [High] Releasing `fnic_lock` during target port addition allows concurren=
t deletion, causing a Use-After-Free.
--

commit 97165276705c88c1da90e05dc10eb567481fddcd
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Add FDLS role handling for NVMe initiators

Modify FDLS registration and discovery flows to use NVMe FC-4 type,
features, PRLI service parameters, and FDMI attributes when the adapter
runs as an NVMe initiator.

Limit SCSI host setup, teardown, rport reset, and FC host notifications
to FCP initiators while keeping target-port events available to both FCP
and NVMe roles.

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c

[ ... ]

> @@ -1264,11 +1284,14 @@ bool fdls_delete_tport(struct fnic_iport_s *iport=
, struct fnic_tport_s *tport)
>  		tport->timer_pending =3D 0;
>  	}
> =20
> -	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> -	fnic_rport_exch_reset(iport->fnic, tport->fcid);
> -	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +	if (IS_FNIC_FCP_INITIATOR(fnic)) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +		fnic_rport_exch_reset(iport->fnic, tport->fcid);
> +		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +	}

[Severity: High]
This is a pre-existing issue, but does dropping and reacquiring the lock
using the shared fnic->lock_flags instead of a local variable corrupt the
IRQ state?

Because spin_lock_irqsave() updates fnic->lock_flags with the local CPU's I=
RQ
state, and fnic_lock is acquired from numerous contexts, this acts as a sha=
red
variable. Restoring it via spin_unlock_irqrestore() can restore an invalid
IRQ state, leading to system instability.

[ ... ]

> @@ -1508,13 +1535,20 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, st=
ruct fnic_tport_s *tport)
>  		.fchdr =3D {.fh_r_ctl =3D FC_RCTL_ELS_REQ, .fh_type =3D FC_TYPE_ELS,
>  			  .fh_f_ctl =3D {FNIC_ELS_REQ_FCTL, 0, 0},
>  			  .fh_rx_id =3D cpu_to_be16(FNIC_UNASSIGNED_RXID)},
> -		.els_prli =3D {.prli_cmd =3D ELS_PRLI,
> -			     .prli_spp_len =3D 16,
> -			     .prli_len =3D cpu_to_be16(0x14)},
> -		.sp =3D {.spp_type =3D 0x08, .spp_flags =3D 0x0020,
> -		       .spp_params =3D cpu_to_be32(0xA2)}
> +		.els_prli =3D {.prli_cmd =3D ELS_PRLI},
> +		.sp =3D {.spp_params =3D cpu_to_be32(iport->service_params)}
>  	};
> =20
> +	fdls_set_frame_type(fnic, &pprli->sp.spp_type);
> +	if (IS_FNIC_FCP_INITIATOR(fnic)) {
> +		pprli->els_prli.prli_spp_len =3D 16;
> +		pprli->els_prli.prli_len =3D cpu_to_be16(0x14);
> +		pprli->sp.spp_flags =3D FC_SPP_EST_IMG_PAIR;
> +	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		pprli->els_prli.prli_spp_len =3D 20;
> +		pprli->els_prli.prli_len =3D cpu_to_be16(0x18);
> +	}

[Severity: High]
For the NVMe initiator branch, is the omission of the FC_SPP_EST_IMG_PAIR
flag an oversight?

The FC-NVMe standard mandates that the Establish Image Pair bit shall be set
to 1 in PRLI requests to establish the connection. By leaving it 0, the NVMe
initiator sends an invalid PRLI, potentially causing compliant targets to
reject the login.

[Severity: High]
Also in fdls_send_tgt_prli(), does this truncate the NVMe PRLI frame payloa=
d?

Earlier in the function, the transmission size is statically allocated as:

uint16_t frame_size =3D FNIC_ETH_FCOE_HDRS_OFFSET +
        sizeof(struct fc_std_els_prli);

The fc_std_els_prli structure is only 44 bytes long. For NVMe, prli_len
is set to 0x18 (24 bytes payload), meaning the frame over the wire needs
to be 48 bytes. Because it is fixed to sizeof(struct fc_std_els_prli), it
truncates the last 4 bytes of the NVMe SPP (containing the First Burst
Size), resulting in a malformed frame.

[Severity: High]
This is a pre-existing issue, but does failing to send the FCoE frame leak
memory here?

If fnic_send_fcoe_frame() fails at the end of fdls_send_tgt_prli() (and
similar discovery routines), it returns an error code, but the allocated
frame is never freed:

	fnic_send_fcoe_frame(iport, frame, frame_size);

err_out:
	timeout =3D max(2 * iport->e_d_tov, iport->plogi_timeout);

The caller just starts a retry timer, permanently leaking the frame and
potentially causing OOM under congestion.

[ ... ]

> @@ -2868,20 +2916,23 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ip=
ort,
>  	fdls_set_tport_state(tport, FDLS_TGT_STATE_READY);
> =20
>  	/* Inform the driver about new target added */
> -	tport_add_evt =3D kzalloc_obj(struct fnic_tport_event_s, GFP_ATOMIC);
> -	if (!tport_add_evt) {
> -		FNIC_FCS_DBG(KERN_INFO, fnic,
> +	if (IS_FNIC_FCP_INITIATOR(fnic) ||
> +	    IS_FNIC_NVME_INITIATOR(fnic)) {
> +		tport_add_evt =3D kzalloc_obj(struct fnic_tport_event_s, GFP_ATOMIC);
> +		if (!tport_add_evt) {
> +			FNIC_FCS_DBG(KERN_INFO, fnic,
>  				     "iport fcid: 0x%x tport event memory allocation failure: 0x%0x\=
n",
>  				     iport->fcid, tport->fcid);
> -		return;
> -	}
> -	tport_add_evt->event =3D TGT_EV_RPORT_ADD;
> -	tport_add_evt->arg1 =3D (void *) tport;
> +			return;
> +		}
> +		tport_add_evt->event =3D TGT_EV_RPORT_ADD;
> +		tport_add_evt->arg1 =3D (void *)tport;
>  		FNIC_FCS_DBG(KERN_INFO, fnic,
>  			     "iport fcid: 0x%x add tport event fcid: 0x%x\n",
>  			     tport->fcid, iport->fcid);
> -	list_add_tail(&tport_add_evt->links, &fnic->tport_event_list);
> -	queue_work(fnic_event_queue, &fnic->tport_work);
> +		list_add_tail(&tport_add_evt->links, &fnic->tport_event_list);
> +		queue_work(fnic_event_queue, &fnic->tport_work);
> +	}

[Severity: High]
This is a pre-existing issue, but does queueing a raw tport pointer here
expose us to a use-after-free in the workqueue handler?

If a link down occurs before the workqueue executes, fdls_delete_tport()
can free the tport because the FNIC_FDLS_SCSI_REGISTERED flag isn't set yet.
When fnic_tport_event_handler() later processes the event, it dereferences
the freed pointer:

	if (tport->state =3D=3D FDLS_TGT_STATE_READY) {
		if (IS_FNIC_FCP_INITIATOR(fnic))
			fnic_fdls_add_tport(&fnic->iport, tport, flags);

> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c

[ ... ]

> @@ -1018,7 +1018,8 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
>  					 "removing fcp rport fcid: 0x%x", tport->fcid);
>  		fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
>  		fnic_del_tport_timer_sync(fnic, tport);
> -		fnic_fdls_remove_tport(&fnic->iport, tport, flags);
> +		if (IS_FNIC_FCP_INITIATOR(fnic))
> +			fnic_fdls_remove_tport(&fnic->iport, tport, flags);
>  	}
>  	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
>  }

[Severity: High]
This is a pre-existing issue, but does fnic_del_tport_timer_sync() temporar=
ily
drop the fnic_lock while iterating with list_for_each_entry_safe()?

Dropping the list-protecting lock inside list_for_each_entry_safe() allows
concurrent threads to delete the "next" element on the list. When the loop
resumes, advancing to the freed "next" element results in a use-after-free.

[ ... ]

> @@ -1044,8 +1045,8 @@ void fnic_tport_event_handler(struct work_struct *w=
ork)
>  			FNIC_FCS_DBG(KERN_INFO, fnic,
>  						 "Add rport event");
>  			if (tport->state =3D=3D FDLS_TGT_STATE_READY) {
> -				fnic_fdls_add_tport(&fnic->iport,
> -					(struct fnic_tport_s *) cur_evt->arg1, flags);
> +				if (IS_FNIC_FCP_INITIATOR(fnic))
> +					fnic_fdls_add_tport(&fnic->iport, tport, flags);

[Severity: High]
This is a pre-existing issue, but does fnic_fdls_add_tport() drop the
fnic_lock internally, leading to another potential use-after-free?

fnic_fdls_add_tport() executes under fnic_lock but drops it to call
fc_remote_port_add(). A concurrent event could acquire the lock and free
the tport. When fnic_fdls_add_tport() reacquires the lock, it writes to
tport->rport and tport->flags, corrupting the freed memory.

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c

[ ... ]

> @@ -1184,7 +1188,8 @@ static void fnic_remove(struct pci_dev *pdev)
>  	 */
>  	flush_workqueue(fnic_event_queue);
> =20
> -	fnic_scsi_unload(fnic);
> +	if (IS_FNIC_FCP_INITIATOR(fnic))
> +		fnic_scsi_unload(fnic);
> =20
>  	if (vnic_dev_get_intr_mode(fnic->vdev) =3D=3D VNIC_DEV_INTR_MODE_MSI)
>  		timer_delete_sync(&fnic->notify_timer);

[Severity: High]
This is a pre-existing issue, but does fnic_remove() omit the teardown of
iport->fabric.retry_timer?

The timer is set up during initialization, but timer_delete_sync() for
the fabric retry timer is missing from the module unload paths. If the timer
fires after the fnic structure is freed, it will cause a use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D5
