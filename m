Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF6F5478D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782278321; cv=none; b=A6AB9RNmYrthaWYkEFX2ZlKo8sHqzYihpboPXiFVhZTwHx0xaroo/6q+FBQxXfOPcHIsjat8FSzv1dXFZw1jOqGG8JI/Q21DO+jR2gUZpDlBo3TxNRx4BGxHCVaCZF/0FDKev/3sO1cUECh6u6b6pWdF3uMvKIuaZc0xVdeBPBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782278321; c=relaxed/simple;
	bh=Bjk8ZINCjVBPwQ4ozrH5/s/ZeEilrQChyk+sf3KNV5s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PBra/T8voXlkfUtxCB3cOt6ABxrEvhSi9ru/6X6Ja1O1D7HTL9jAXZHT2hX8Jks1JD7MGumot8w06cQ6+lWP+Owh7LQIps8zZpNH7mSLAO96PEwp+5RNcIVSX3k33tLIdTzJpg70FdcBEqk7mM6Os52pIIpEBqBHly4RgEnMmJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NK0OsaB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NK0OsaB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BA31F000E9;
	Wed, 24 Jun 2026 05:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782278319;
	bh=O5UPikNuB52ULoSKUrP/IHz5ACOPMMwGGMu6Gb5IXkc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NK0OsaB1cUAvq/0V4TzI/35dUtXnKvcXvgzwKbM64M8EwuCcWyWPmgzOhKZ1x+tSq
	 5g3DboHyR7l1P5QRTFmDp4chx6kLDngoi5SE0P0Lo+ye9snXa/2GbdMJfWxJQknFBp
	 kYlpyR/2X6KvyMne6Bgv2j14/+lNfp1afhCf9TZ0T07sk6Sg6LYN5LU0J3GpF/Gtt5
	 hXJCURgBgtbXxHaaeqaDnPX7PDcKdOVl4fUV8a6LerOuHXAnxrCxGVnueiKOLWQQ4Y
	 cfgH2Q70NLNO/+4KPnSJRli6NRF6Y7zplWIiRINj4wVnVbOv+U9bf9/zivTZdDG5pD
	 E5KygMNaeMN9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/13] scsi: fnic: Add FDLS role handling for NVMe
 initiators
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-6-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-6-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:18:38 +0000
Message-Id: <20260624051839.51BA31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:

New issues:
- [High] The NVMe PRLI payload is truncated because `frame_size` is calcula=
ted using the smaller FCP payload structure.
- [High] NVMe initiators incorrectly validate the FCP Target Function bit i=
nstead of the NVMe Target Function bit.

Pre-existing issues:
- [Critical] `fnic_cleanup_io` calls `schedule_timeout(100)` while executin=
g in a hardirq context, causing a kernel panic.
- [Critical] The `notify_timer` unconditionally re-arms itself, bypassing `=
timer_delete_sync` during module teardown and causing a Use-After-Free.
- [High] Dropping the lock inside a `list_for_each_entry_safe` loop creates=
 a Use-After-Free condition.
- [High] The `fnic` structure is freed without being removed from the globa=
l `reset_fnic_list`, resulting in a Use-After-Free in the worker thread.
- [High] The `fabric.retry_timer` is never cancelled before freeing the `fn=
ic` structure, leading to a Use-After-Free.
- [High] The code restores a stale IRQ state by using the `fnic->lock_flags=
` struct member instead of the caller's saved flags.
--

commit 5d6ee3fb48072d18a71bfad0fac88f211a7027ca
Author: Karan Tilak Kumar <kartilak@cisco.com>
scsi: fnic: Add FDLS role handling for NVMe initiators

Modify FDLS registration and discovery flows to use NVMe FC-4 type,
features, PRLI service parameters, and FDMI attributes when the adapter
runs as an NVMe initiator. Limit SCSI host setup, teardown, rport reset,
and FC host notifications to FCP initiators.

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

[Severity: High]
This is a pre-existing issue, but is it safe to use the struct member
fnic->lock_flags to restore the lock state here?

In fnic_tport_event_handler(), the fnic_lock is acquired using a local flags
variable, so fnic->lock_flags is never updated. When fdls_delete_tport()
subsequently drops the lock here using fnic->lock_flags, it restores a
potentially stale IRQ state. This can corrupt the CPU's interrupt state and
lead to deadlocks.

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

[Severity: High]
Does this result in a truncated NVMe payload?

The NVMe PRLI length is correctly set to 24 bytes here (0x18), but the
frame_size allocated for the transmission at the beginning of
fdls_send_tgt_prli() is calculated using sizeof(struct fc_std_els_prli).
Because that struct only accommodates the smaller 16-byte FCP payload, the
NVMe request is sent with an incomplete payload, which violates the FC-NVMe
standard.

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

[Severity: High]
Are we checking the correct bit for NVMe targets?

The condition explicitly checks the FCP_PRLI_FUNC_TARGET bit (bit 4) for bo=
th
FCP and NVMe initiators. NVMe targets use a different bit mask
(FNIC_NVME_FEAT_TARG, which is bit 0) to indicate target support. This caus=
es
the driver to incorrectly evaluate target support when connecting to NVMe
endpoints.

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
This is a pre-existing issue, but does dropping the lock inside
list_for_each_entry_safe() defeat the safety of the loop iteration?

When fdls_delete_tport() is called inside the loop body, it explicitly drops
fnic->fnic_lock. While unlocked, another thread or workqueue can delete and
free the pre-fetched next element. This can lead to a use-after-free crash
when the loop iterates.

[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
> index ca592bc3f6182..a67d1085d720b 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
[ ... ]
> @@ -1110,12 +1111,15 @@ void fnic_reset_work_handler(struct work_struct *=
work)
>  		spin_unlock_irqrestore(&reset_fnic_list_lock,
>  							   reset_fnic_list_lock_flags);
> =20
> -		dev_err(&cur_fnic->pdev->dev, "fnic: <%d>: issuing a host reset\n",
> -			   cur_fnic->fnic_num);
> -		host_reset_ret_code =3D fnic_host_reset(cur_fnic->host);
> -		dev_err(&cur_fnic->pdev->dev,
> -		   "fnic: <%d>: returned from host reset with status: %d\n",
> -		   cur_fnic->fnic_num, host_reset_ret_code);
> +		if (IS_FNIC_FCP_INITIATOR(cur_fnic)) {
> +			dev_err(&cur_fnic->pdev->dev,
> +				"fnic: <%d>: issuing a host reset\n",
> +				cur_fnic->fnic_num);
> +			host_reset_ret_code =3D fnic_host_reset(cur_fnic->host);
> +			dev_err(&cur_fnic->pdev->dev,
> +				"fnic: <%d>: returned from host reset with status: %d\n",
> +				cur_fnic->fnic_num, host_reset_ret_code);
> +		}

[Severity: High]
This is a pre-existing issue, but does this leak the fnic structure onto a
global list when the device is removed?

When fdls_process_rscn() is called, it adds the fnic instance to the global
reset_fnic_list. If the device is subsequently removed, fnic_remove() frees
the fnic memory without deleting it from reset_fnic_list or flushing the
reset_fnic_work_queue. The background worker iterates over reset_fnic_list
here and will access the freed cur_fnic object, resulting in a
use-after-free.

[ ... ]
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

[Severity: Critical]
This is a pre-existing issue, but can this lead to a use-after-free due to
a self-rearming timer?

The timer callback fnic_notify_timer() unconditionally re-arms itself with
mod_timer(). Calling timer_delete_sync() here will wait for the currently
executing callback to finish, but the callback will queue itself again. This
leaves a pending timer firing after the fnic structure is freed below.

[Severity: High]
This is a pre-existing issue, but is the fabric.retry_timer left active?

The discovery process arms iport->fabric.retry_timer, but it is not
cancelled in fnic_remove() alongside the other timers like fip_timer and
notify_timer. This can cause the timer callback to execute after the fnic
memory is freed.

[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index b92260583c67b..37d1e136b7b91 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -732,7 +732,8 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fn=
ic *fnic,
>  	atomic64_inc(&reset_stats->fw_reset_completions);
> =20
>  	/* Clean up all outstanding io requests */
> -	fnic_cleanup_io(fnic, SCSI_NO_TAG);
> +	if (IS_FNIC_FCP_INITIATOR(fnic))
> +		fnic_cleanup_io(fnic, SCSI_NO_TAG);

[Severity: Critical]
This is a pre-existing issue, but does this lead to sleeping in atomic
context?

The fnic_fcpio_fw_reset_cmpl_handler() function executes in a hardirq conte=
xt
(via an MSI-X interrupt). It calls fnic_cleanup_io() which contains a while
loop that unconditionally calls schedule_timeout(msecs_to_jiffies(100)).
Calling a sleeping function in a hardirq context causes a kernel panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D5
