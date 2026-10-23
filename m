Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759299;
	b=31e2hFgf+BrkIeW7BJC/ab1MIEFAAnDaFKYi5IRN7ROXJor/a8MV1DUQykqo15uo++bT
	 30wV6fCuy7xyoGgN7ruTCbxjRoiPHhgZ01+VXl1NXWrtNpJzRvO8aWIDu5HahGSpEx4Iw
	 r/7tK7eeaYvJh24mH3kPkgQUsUdP/N2pjdOwjIWQIx+Fywpwvf9bj7hIh16/S1glvTsvG
	 0/nsvFApVCKobUBh9iLGxl1lxO2BKcxlU2Nf5gQDsiLW2KRdDc7Ma9FoWOeqQDVBvLzIf
	 eux12BQAbf9hqBhXFEcqESGy0AA770h/6tcUfZsgh1c8hP3A4opZ/LffTJP1JEs6zxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759299;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7GY5Id4SFAjXd4tO3ZLt+Ebu0Dx/V4xzzBPIZpAfv4M=;
	b=BpmG/ZzxX2hMB/kb95sbPUjdM3pBHKxnALVl/lNI1hsxAap/ANmXdZeRcPeP8T3xwZ2t
	 0qH91B0RzY09mdkrxatCvs1Fi8GTbaUGv4iFc+z56hOnaX+vnjnOVocszeZ9LFxYTfbYO
	 iP/4rABsd9sGvMDF6roY+S1D09ZXd5GTfEHgg8pZBbivy+PU9OHLdsiUIcvHaBmaUbWSw
	 6tZJeY3DeP9Cc3nu54cVuVQ5HshA5MtrLQJsI3dtCohF3pfHxAYwljLpWVVHqkXShNVYq
	 +iQnQQs1f4LM8u5DD38xYxgLXPYsHjo0qnPsYAfBesdzqqeZ9UBXOAmca0sjP64wJ3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bogUyCPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E6E606A31B;
	Fri, 23 Oct 2026 12:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bogUyCPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE241F01825;
	Fri, 23 Oct 2026 12:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759298;
	bh=7GY5Id4SFAjXd4tO3ZLt+Ebu0Dx/V4xzzBPIZpAfv4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bogUyCPWIYLpw5LMmPS/RVVnQaR/a0X81cTPeqPUlxEwJx2K+EQWMPCrGZOESW23p
	 Y1P8nOPUaEmC9Jm5F60l88Tm4W5lKU56t3Gld4x2Xsat3CAZruT40PuD6MRpI6gbuh
	 jpKR2EWHiGc1HpJibX3ebQuH2KxS1Y5dfbxkvB3wxbrrhhEnD1Rs4pbVG1e8SZSGpy
	 CPxV+T3YuwEKORaRiIf1R9IXmy90KHW4QUaJI8GHCMaMS8W2Ti/DT+3rEv45eu7E9l
	 WBKjSMYnUInGdSWBSsO3yoGg9Q4/7BNk9DXLGFVOPQMvC5ABD/tVJjezG19mgMhft+
	 6TCueshx0fcCA==
Message-ID: <sashiko-outbox-182788@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 2/2] zfcp: Use DMA streaming API to map I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "M Nikhil" <nikh1092@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261023114046.4137557-3-nikh1092@linux.ibm.com>
References: <20261023114046.4137557-1-nikh1092@linux.ibm.com>
 <20261023114046.4137557-3-nikh1092@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 12:41:37 +0000
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
- [Critical] scsi: zfcp: scsi_cmnd UAF on abort failure in zfcp_scsi_eh_abo=
rt_handler()
- [High] scsi: zfcp: DMA mapping leak in zfcp_scsi_eh_abort_handler()
- [Medium] zfcp: 31-bit coherent_dma_mask overwritten in zfcp_set_dma_mask_=
for_adapter()
--

commit ee42d1a728b67714b2c6be28df7f409c25bc9e1f
Author: M Nikhil <nikh1092@linux.ibm.com>

zfcp: Use DMA streaming API to map I/O

This commit converts zFCP I/O buffer mappings (QTCB, SRB, CT/ELS, and SCSI
I/O) from direct physical address translations to the DMA streaming API usi=
ng
dma_map_sgtable() and dma_unmap_sgtable().

> diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
> index fea573e00f9df..20c905c68e1e6 100644
> --- a/drivers/s390/scsi/zfcp_aux.c
> +++ b/drivers/s390/scsi/zfcp_aux.c
> @@ -329,6 +329,19 @@ static void zfcp_destroy_adapter_work_queue(struct z=
fcp_adapter *adapter)
> =20
>  }
> =20
> +static int zfcp_set_dma_mask_for_adapter(struct zfcp_adapter *adapter)
> +{
> +	int ret;
> +
> +	ret =3D dma_set_mask_and_coherent(&adapter->ccw_device->dev,
> +					DMA_BIT_MASK(64));
> +	if (ret)
> +		dev_err(&adapter->ccw_device->dev,
> +			"Setting the DMA mask failed for the FCP device.\n");
> +
> +	return ret;
> +}

[Severity: Medium]
Should zfcp_set_dma_mask_for_adapter() call dma_set_mask() instead of
dma_set_mask_and_coherent()?

In drivers/s390/cio/css.c:css_alloc_subchannel() and
drivers/s390/cio/device.c:io_subchannel_allocate_dev(), the s390 CIO core
initializes cdev->dev.dma_mask to DMA_BIT_MASK(64) for streaming DMA while
explicitly keeping cdev->dev.coherent_dma_mask at DMA_BIT_MASK(31):

drivers/s390/cio/css.c:css_alloc_subchannel() {
	/*
	 * The physical addresses for some of the dma structures that can
	 * belong to a subchannel need to fit 31 bit width (e.g. ccw).
	 */
	ret =3D dma_set_coherent_mask(&sch->dev, DMA_BIT_MASK(31));
	if (ret)
		goto err;
	/*
	 * But we don't have such restrictions imposed on the stuff that
	 * is handled by the streaming API.
	 */
	ret =3D dma_set_mask(&sch->dev, DMA_BIT_MASK(64));
}

Calling dma_set_mask_and_coherent() overwrites cdev->dev.coherent_dma_mask
with a 64-bit mask even though zFCP only uses streaming DMA. If an online
zFCP device is detached under z/VM or KVM, zfcp_ccw_notify() returns
NOTIFY_OK on CIO_GONE and io_subchannel_sch_event() moves the struct
ccw_device to the pseudo-subchannel orphanage via ccw_device_move_to_orph().
When another CCW device (such as virtio-ccw) is later attached at the same
device number and rebound via ccw_device_recog_done() ->
ccw_device_do_unbind_bind(), coherent allocations via
ccw_device_dma_zalloc() -> __cio_gp_dma_zalloc() will use the clobbered
64-bit coherent_dma_mask, allowing dma_alloc_coherent() to return memory
above 2 GiB and truncate dma_addr to 31-bit dma32_t.

[ ... ]

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index ea4b968352f4d..32bfb7e4891ee 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -179,11 +179,20 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_c=
mnd *scpnt)
>  	write_lock_irqsave(&adapter->abort_lock, flags);
> =20
>  	old_req =3D zfcp_reqlist_find(adapter->req_list, old_reqid);
> -	if (!old_req) {
> +	if (!old_req || !old_req->data) {
>  		write_unlock_irqrestore(&adapter->abort_lock, flags);
>  		zfcp_dbf_scsi_abort("abrt_or", scpnt, NULL);
>  		return FAILED; /* completion could be in progress */
>  	}
> +
> +	/*
> +	 * Suppress the normal completion handler's unmap by clearing
> +	 * req->data now, under the abort_lock write-side.  The actual
> +	 * DMA unmap is deferred until the hardware has stopped using
> +	 * the buffers (after wait_for_completion or after ERP has
> +	 * quiesced the adapter), so that we never call dma_unmap_sgtable
> +	 * while the FCP channel may still be writing into the pages.
> +	 */
>  	old_req->data =3D NULL;
> =20
>  	/* don't access old fsf_req after releasing the abort_lock */
> @@ -198,18 +207,34 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_c=
mnd *scpnt)
>  		zfcp_erp_wait(adapter);
>  		ret =3D fc_block_scsi_eh(scpnt);
>  		if (ret) {
> +			/*
> +			 * fc_block_scsi_eh returned FAST_IO_FAIL: the
> +			 * fast_io_fail_tmo fired.  ERP has already called
> +			 * zfcp_fsf_req_dismiss_all() (which requires QDIO
> +			 * to be down first), so the hardware is no longer
> +			 * using the buffers.  Pass FAST_IO_FAIL back to
> +			 * scsi_eh, but unmap first.
> +			 */
>  			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
> -			return ret;
> +			retval =3D ret;
> +			goto out_unmap;
>  		}
>  		if (!(atomic_read(&adapter->status) &
>  		      ZFCP_STATUS_COMMON_RUNNING)) {
> +			/*
> +			 * Adapter is gone; ERP shut down QDIO and dismissed
> +			 * all requests before clearing RUNNING.  Safe to
> +			 * unmap now.
> +			 */
>  			zfcp_dbf_scsi_abort("abrt_ru", scpnt, NULL);
> -			return SUCCESS;
> +			retval =3D SUCCESS;
> +			goto out_unmap;
>  		}
>  	}
>  	if (!abrt_req) {
>  		zfcp_dbf_scsi_abort("abrt_ar", scpnt, NULL);
> -		return FAILED;
> +		retval =3D FAILED;
> +		goto out_unmap;
>  	}
> =20
>  	wait_for_completion(&abrt_req->completion);
> @@ -224,6 +249,39 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cm=
nd *scpnt)
>  	}
>  	zfcp_dbf_scsi_abort(dbf_tag, scpnt, abrt_req);
>  	zfcp_fsf_req_free(abrt_req);
> +
> +out_unmap:
> +	if (retval =3D=3D SUCCESS) {
> +		/*
> +		 * The hardware has stopped using the SCSI command's DMA buffers
> +		 * either the adapter confirmed the abort (abrt_ok / abrt_nn), or
> +		 * ERP has shutdown QDIO and cleared RUNNING (abrt_ru).
> +		 */
> +		if ((scsi_get_prot_op(scpnt) !=3D SCSI_PROT_NORMAL) &&
> +		    scsi_prot_sg_count(scpnt))
> +			zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
> +					      &scpnt->prot_sdb->table,
> +					      scpnt->sc_data_direction);
> +
> +		zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
> +				      &scpnt->sdb.table,
> +				      scpnt->sc_data_direction);
> +	} else {
> +		/*
> +		 * Abort failed and adapter was not quiesced (abrt_ar, abrt_fa,
> +		 * or abrt_bl). Do not unmap DMA buffers while hardware may still
> +		 * be accessing them. Restore old_req->data so that subsequent
> +		 * SCSI EH reset escalation (zfcp_scsi_forget_cmnd) or ERP
> +		 * dismissal (zfcp_fsf_req_dismiss_all) unmaps the buffers
> +		 * once the hardware has actually stopped.
> +		 */
> +		write_lock_irqsave(&adapter->abort_lock, flags);
> +		old_req =3D zfcp_reqlist_find(adapter->req_list, old_reqid);
> +		if (old_req)
> +			old_req->data =3D scpnt;
> +		write_unlock_irqrestore(&adapter->abort_lock, flags);
> +	}
> +
>  	return retval;
>  }

[Severity: High]
Does out_unmap in zfcp_scsi_eh_abort_handler() leak the DMA mappings for
scpnt->sdb.table and scpnt->prot_sdb->table when retval !=3D SUCCESS and
old_req was already removed from adapter->req_list?

After zfcp_scsi_eh_abort_handler() sets old_req->data =3D NULL and drops
adapter->abort_lock, old_req can complete or be dismissed by ERP via
zfcp_qdio_close() -> zfcp_fsf_req_dismiss_all() -> zfcp_fsf_req_complete()
while the abort handler is in its retry loop or waiting on
abrt_req->completion. Because req->data is NULL, zfcp_fsf_fcp_cmnd_handler()
returns early without unmapping scpnt's scatterlists, and old_req is removed
from adapter->req_list and freed:

drivers/s390/scsi/zfcp_fsf.c:zfcp_fsf_fcp_cmnd_handler() {
	scpnt =3D req->data;
	if (unlikely(!scpnt)) {
		read_unlock_irqrestore(&req->adapter->abort_lock, flags);
		return;
	}
}

If zfcp_scsi_eh_abort_handler() then reaches out_unmap with retval !=3D SUC=
CESS
-- for example, when fc_block_scsi_eh() returns FAST_IO_FAIL ("abrt_bl",
where the comment notes it should unmap first, but retval is FAST_IO_FAIL so
the retval =3D=3D SUCCESS branch is skipped), when all retries of
zfcp_fsf_abort_fcp_cmnd() return NULL ("abrt_ar"), or when abrt_req itself =
is
dismissed by ERP ("abrt_fa") -- execution enters the else branch. There,
zfcp_reqlist_find(adapter->req_list, old_reqid) returns NULL because old_req
is already gone, so neither out_unmap nor any later zfcp_scsi_forget_cmnd()
or zfcp_fsf_req_dismiss_all() will ever unmap scpnt->sdb.table or
scpnt->prot_sdb->table.

[Severity: Critical]
In the case where old_req is still in adapter->req_list when out_unmap ente=
rs
the else branch, can restoring old_req->data =3D scpnt cause a use-after-fr=
ee
on scpnt in zfcp_fsf_fcp_cmnd_handler()?

Prior to this change, zfcp_scsi_eh_abort_handler() permanently cleared
old_req->data =3D NULL under adapter->abort_lock so that
zfcp_fsf_fcp_cmnd_handler() could never touch scpnt or call scsi_done(scpnt)
once abort handling started.

With old_req->data =3D scpnt restored on retval !=3D SUCCESS:

1. If FAST_IO_FAIL is returned while old_req is still in adapter->req_list =
--
   either from fc_block_scsi_eh(scpnt) in zfcp_scsi_eh_abort_handler() (for
   example, when a single remote port's fast_io_fail_tmo fires via
   fc_timeout_fail_rport_io() -> zfcp_scsi_terminate_rport_io() ->
   zfcp_erp_port_forced_reopen(), which closes the port asynchronously
   without shutting down QDIO or calling zfcp_fsf_req_dismiss_all()), or
   during subsequent EH escalation in zfcp_scsi_task_mgmt_function() when
   fc_block_rport(rport) returns FAST_IO_FAIL before
   zfcp_scsi_forget_cmnds() is reached:

   drivers/s390/scsi/zfcp_scsi.c:zfcp_scsi_task_mgmt_function() {
		ret =3D fc_block_rport(rport);
		if (ret) {
			zfcp_dbf_scsi_devreset("fiof", sdev, tm_flags, NULL);
			return ret;
		}
   }

   -- SCSI EH immediately finishes scpnt via scsi_eh_finish_cmd() ->
   scsi_finish_command() -> scsi_free_sgtables(). That frees scpnt's
   scatter-gather tables while they are still DMA-mapped and releases scpnt
   for reuse while old_req->data still points to scpnt. When old_req later
   completes or is dismissed, zfcp_fsf_fcp_cmnd_handler() will dereference
   the freed or reused scpnt, unmap its freed sdb.table and prot_sdb->table,
   and call scsi_done(scpnt).

2. Even when FAST_IO_FAIL is not returned, restoring old_req->data =3D scpnt
   allows any late completion or ERP dismissal of old_req during SCSI EH
   escalation to execute zfcp_fsf_fcp_cmnd_handler(), modifying scpnt and
   calling scsi_done(scpnt) concurrently with SCSI EH.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023114046.4137=
557-1-nikh1092@linux.ibm.com?part=3D2
