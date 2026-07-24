Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A2938F653
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784919245; cv=none; b=Yu/5IAZLb054/kkDd+1zYdvt2ogg8ZkuG6/IyHpvGXeH/qkBliDvAA35Du/ffov+dwXJb2h6kd2URKbIfNHVK4igMQBpg1bNDC4dRveFF/qlTFK6HGyQnyWZAXV3WXP4ag028Q/dMJxhasxUXQWFu+V18VbptuM7ifsX4HHG9gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784919245; c=relaxed/simple;
	bh=lI1OWJw/7EZxZl9nOqSMZGXbHvRINQ9X1A5pbDWvhKc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J2NrKrujz9m6Bn3wEPp/PvytBS8jMjGaAuQSxxRRKtu0aMsnhb3TO0UfXbk9ISG5AC2+XzIrquCyUl1DICC7/uX5NL9Pl+xa9waanP/kWc7b4+t+hlm6DODJY8RkPjy/3iFFGagJ6VC9/WIiHnpgCg92ptZajDrjyYp1n2IcPOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nfNyguOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nfNyguOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBB11F000E9;
	Fri, 24 Jul 2026 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784919243;
	bh=ukyOtLc0dx/XjVPxb+j7vXPJDcxQYJwfpM09p51Qltk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nfNyguOsKCaP/MOdeqAtdS35zvXSAo2YuLIwtiQRQwyr8ZphadDlMS9CSQnSa2xTt
	 /pxzPkCFvLJzki8kNfGC6ZkmdPGjRxPE0Nhp+4inqQuon/Jp90s5oZYLQVx5YMny8z
	 ltYhrXW1PZdR8vQaEap9YgS11t20uIbsbU1F1FUbWixX9TB7ta30snyG7KlyMm0fX1
	 kg1hmhGuVvVPCHE28CTvAmnX75VfgTiaR9p2+BkcgqvCx2pIWDWmUW3jJTKdXQW7sD
	 lJe7iyGudwnyFrem9Af4JTkdGA4PbkeY+YJTttjEoQoOdz3xSKLSG5I0tF6I+Ic52a
	 oFtyrpPvx/rGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/13] scsi: fnic: Add FDLS role handling for NVMe
 initiators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-6-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-6-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:54:03 +0000
Message-Id: <20260724185403.9BBB11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [Critical] Skipping teardown steps for NVMe initiators in `fnic_remove` l=
eaks all target-ports and their retry timers, leading to a Use-After-Free.
- [Critical] Target-port ADD and DEL events are queued for NVMe initiators =
but are silently dropped by the worker thread, preventing target registrati=
on.
- [High] NVMe target capability check incorrectly uses the FCP target mode =
bit, rejecting valid NVMe Discovery Controllers.
- [High] FC-NVMe PRLI request FCoE frames are truncated by 4 bytes, causing=
 a payload length mismatch.

Pre-existing issues:
- [High] Target ports are permanently leaked as zombies if memory allocatio=
n fails in `fdls_delete_tport`.
- [High] Dropping the list lock inside a `list_for_each_entry_safe` loop cr=
eates a Use-After-Free race condition if the next element is removed.
- [High] Missing length validation on untrusted incoming FCoE ELS frames le=
ads to out-of-bounds reads on uninitialized or stale DMA memory.
--

--- Patch [5]: [PATCH v6 05/13] scsi: fnic: Add FDLS role handling for NVMe=
 initiators ---
commit 293db6e248353f1832c4c547c9d5f992bf5f84e6
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Add FDLS role handling for NVMe initiators
   =20
Modify FDLS registration and discovery flows to use NVMe FC-4 type,
features, PRLI service parameters, and FDMI attributes when the adapter
runs as an NVMe initiator. Limit SCSI host setup, teardown, rport reset,
and FC host notifications to FCP initiators while keeping target-port
events available to both FCP and NVMe roles.

> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index f665460ef62c5..e03256183ac63 100644
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
> =20
> -	if (tport->flags & FNIC_FDLS_SCSI_REGISTERED) {
> +	if ((tport->flags & FNIC_FDLS_SCSI_REGISTERED) ||
> +	    (tport->flags & FNIC_FDLS_NVME_REGISTERED)) {
>  		tport_del_evt =3D
>  			kzalloc_obj(struct fnic_tport_event_s, GFP_ATOMIC);
>  		if (!tport_del_evt) {

[Severity: High]
This isn't a bug introduced by this patch, but are target ports permanently
leaked as zombies if this memory allocation fails?

In fdls_delete_tport(), the state is changed to FDLS_TGT_STATE_OFFLINING
prior to this allocation. If kzalloc_obj() returns NULL, the function bails
out early without freeing the structure or unlinking it. Because the state =
is
now offline, will future calls return early and never clean it up?

[ ... ]
> @@ -1508,13 +1535,21 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, st=
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
> +		/* Per FC-NVMe, Establish Image Pair must not be set for NVMe PRLI. */
> +		pprli->els_prli.prli_spp_len =3D 20;
> +		pprli->els_prli.prli_len =3D cpu_to_be16(0x18);
> +	}
> +

[Severity: High]
Will this payload length mismatch cause the target to reject the frame as
malformed?

In fdls_send_tgt_prli(), the FCoE frame_size is calculated statically at the
start of the function using sizeof(struct fc_std_els_prli), which assigns 16
bytes for the Service Parameter Page. For NVMe initiators, prli_spp_len is =
set
to 20 bytes here, making the required payload 24 bytes. Will this result in
the transmitted frame being 4 bytes shorter than the stated payload length?

[ ... ]
> @@ -2852,14 +2893,22 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ip=
ort,
>  	tport->fcp_csp =3D be32_to_cpu(prli_rsp->sp.spp_params);
>  	tport->retry_counter =3D 0;
> =20
> -	if (tport->fcp_csp & FCP_SPPF_RETRY)
> -		tport->tgt_flags |=3D FNIC_FC_RP_FLAGS_RETRY;
> +	if (IS_FNIC_FCP_INITIATOR(fnic)) {
> +		if (tport->fcp_csp & FCP_SPPF_RETRY)
> +			tport->tgt_flags |=3D FNIC_FC_RP_FLAGS_RETRY;
> +	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		if (tport->fcp_csp & FNIC_NVME_SP_SLER)
> +			tport->tgt_flags |=3D FNIC_FC_RP_FLAGS_RETRY;
> +	}
> =20
>  	/* Check if the device plays Target Mode Function */
> -	if (!(tport->fcp_csp & FCP_PRLI_FUNC_TARGET)) {
> +	if ((IS_FNIC_FCP_INITIATOR(fnic) &&
> +	     !(tport->fcp_csp & FCP_PRLI_FUNC_TARGET)) ||
> +	    (IS_FNIC_NVME_INITIATOR(fnic) &&
> +	     !(tport->fcp_csp & FCP_PRLI_FUNC_TARGET))) {
>  		FNIC_FCS_DBG(KERN_INFO, fnic,
> -			 "Remote port(0x%x): no target support. Deleting it\n",
> -			 tgt_fcid);
> +				 "Remote port(0x%x): no target support. Deleting it\n",
> +				 tgt_fcid);
>  		fdls_tgt_logout(iport, tport);
>  		fdls_delete_tport(iport, tport);
>  		return;

[Severity: High]
Does this target capability check inappropriately reject valid NVMe Discove=
ry
Controllers?

In fdls_process_tgt_prli_rsp(), validating target mode support checks
!(tport->fcp_csp & FCP_PRLI_FUNC_TARGET), which masks bit 4. The
NVMe Discovery Service uses bit 3. Will an NVMe Discovery Service
target asserting only bit 3 unconditionally trigger this rejection and
logout?

[ ... ]
> @@ -5087,14 +5143,18 @@ void fnic_fdls_link_down(struct fnic_iport_s *ipo=
rt)
>  	fdls_set_state((&iport->fabric), FDLS_STATE_LINKDOWN);
>  	iport->fabric.flags =3D 0;
> =20
> -	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> -	fnic_fcpio_reset(iport->fnic);
> -	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> -	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
> -		FNIC_FCS_DBG(KERN_INFO, fnic,
> +	if (IS_FNIC_FCP_INITIATOR(fnic) ||
> +	    IS_FNIC_NVME_INITIATOR(fnic)) {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
> +		fnic_fcpio_reset(iport->fnic);
> +		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
> +		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
> +			FNIC_FCS_DBG(KERN_INFO, fnic,
>  					 "removing rport: 0x%x", tport->fcid);
> -		fdls_delete_tport(iport, tport);
> +			fdls_delete_tport(iport, tport);
> +		}
>  	}

[Severity: High]
This is a pre-existing issue, but does dropping the list lock inside a
list_for_each_entry_safe() loop create a use-after-free race condition?

In fnic_fdls_link_down(), we iterate over tport_list using
list_for_each_entry_safe() while holding fnic_lock. Inside the loop,
fdls_delete_tport() is called, which temporarily drops the lock for FCP
initiators. If a concurrent thread processing an ELS frame or RSCN removes
and frees the next element in the list while the lock is dropped, will the
iterator advance into freed memory when the lock is reacquired?

[Severity: High]
This is also a pre-existing issue in this file, but does the lack of length
validation on FCoE ELS frames lead to out-of-bounds reads?

In fdls_process_rscn(), the loop limit num_ports is derived from the packet=
's
internal rscn_payload_len field. The driver doesn't appear to verify if this
claimed length fits within the physical size of the received network buffer.
If a malformed frame claims a large length, could this copy uninitialized
memory into local structures?

> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index ca592bc3f6182..a67d1085d720b 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
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
>  			} else {
>  				FNIC_FCS_DBG(KERN_INFO, fnic,

[Severity: Critical]
Are target-port ADD and DEL events silently dropped by the worker thread for
NVMe initiators?

In fnic_tport_event_handler(), TGT_EV_RPORT_ADD events are only processed if
IS_FNIC_FCP_INITIATOR(fnic) is true. Because there is no logic branch for
NVMe initiators, will these events be discarded without the target ever bei=
ng
registered?

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 5850d51b0e8f6..0d7828be244da 100644
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
> @@ -1228,8 +1233,10 @@ static void fnic_remove(struct pci_dev *pdev)
>  	pci_disable_device(pdev);
>  	pci_set_drvdata(pdev, NULL);
>  	ida_free(&fnic_ida, fnic->fnic_num);
> -	fnic_scsi_unload_cleanup(fnic);
> -	scsi_host_put(fnic->host);
> +	if (IS_FNIC_FCP_INITIATOR(fnic)) {
> +		fnic_scsi_unload_cleanup(fnic);
> +		scsi_host_put(fnic->host);
> +	}
>  	kfree(fnic);
>  }

[Severity: Critical]
Does skipping these teardown steps for NVMe initiators leak target ports and
their timers, leading to a use-after-free?

In fnic_remove(), fnic_scsi_unload() and fnic_scsi_unload_cleanup() are
restricted to FCP initiators. These functions handle cancelling timers and
freeing targets. If an NVMe initiator skips this cleanup, will retry timers
remain active and access the fnic context after it is freed by kfree(fnic)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D5
