Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692943;
	b=Hw0K0WIBZeL/b30cXdzYdpiE83bYjlZzHn5XMtS7F14bVsN7PqYEW4I5nl9169xNbue8
	 AD+aeCVNKCfkieKfU3XvSvtj8Lb7hjxWgpSbnTgATR7DOrGWw/Nd7fY30RTPoiY7erX4Z
	 /4nLboaoUYXJ4HbiXK2Rdp030eF78R5mv0jNZ/0in8Vns2EC1A+yJjVdw1iLSJz1LT5rQ
	 daB7vstpmSbYXeObYN0QAh1FgVVydiGG6ywDYGTZhsjFs1Q4rypQgQoAzFTzhlov8nMKm
	 QtaF9op7JNWNqYTg7GfM6rDsGi2RafywVd8b+5PIePH1z8jv1AiNNpTtFVvB7YhsEcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692943;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tp89RW5qJXm38q21HhpXXHw7A/8pfWxW5Tl9WI1AVZg=;
	b=R0h0vALilG/ixozK8jXI7zEDAFFRVl2WvGl7NrAeoSW0r0eG5hcbGV5H5aX8g87MihAx
	 bjhyNjWmlYRIWPu6ct862lTm2kYwoiSDYg12cU+uxqSUr3SiCYF+1/UpZeQEKb2aDv5EQ
	 9t22yX4fhsPde1t2S+5YTaQVZaJg5B/3gntOmSQfreflI078tlqebGp9GPjYvvhfQ2tT3
	 GZnXpK5CcTysJ8RH8icqXrHCjv6KFThaUR3g0M7wmgksx6Yyt8h1dLfwJ1l63Oh5BiA7P
	 Lbo7FJb380v3FiBkXwMQ/wvx9y724tYwg1uuowghDnb7fDukSIvI30b7lsWfz0Q3uvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hu6ZWzfE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAB6606A31A;
	Thu, 22 Oct 2026 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hu6ZWzfE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B391F01825;
	Thu, 22 Oct 2026 18:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792692942;
	bh=tp89RW5qJXm38q21HhpXXHw7A/8pfWxW5Tl9WI1AVZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hu6ZWzfE/8B5s24IJ6vxQ+Lp0beDzTe/mIV7E5r6tu8HCqG1kYL8ZSl482TWSpsUV
	 55uOhuow2o2Pv9oXS2XOm/frgF8YAmxtpo8hiDhI9YA6Hq1cz5xhTha+nMecgmkUak
	 AGvclLSR3FxUNb0j3oxJqQlWrilMLjolu3gWV814QZ+B07lhTLNofj/oFfRuRW/BUg
	 A2zgEbZkVNt6axnpTX5/2FxZCo6OvTmlLUq3pg2o8RQKZCmhqGuMLI0cKTsjYRYGNO
	 sT7IV0AV0autyDIyOY5fY/yIi95CLkLWYi7ASuREqRgyvx6WhqAlhQdwJINGDe1sYj
	 VvDiZsBrPK9eg==
Message-ID: <sashiko-outbox-181906@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 2/2] zfcp: Use DMA streaming API to map I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "M Nikhil" <nikh1092@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261022170828.4189701-3-nikh1092@linux.ibm.com>
References: <20261022170828.4189701-1-nikh1092@linux.ibm.com>
 <20261022170828.4189701-3-nikh1092@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 18:15:41 +0000
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
- [Critical] scsi: zfcp: premature DMA unmap in zfcp_scsi_eh_abort_handler()
- [High] scsi: zfcp: double DMA unmap of scsi_cmnd in zfcp_scsi_eh_abort_ha=
ndler()
- [High] scsi: zfcp: type confusion on TMF requests in zfcp_scsi_forget_cmn=
d()
--

commit 9c1fb6b4aad79a57f42f4a774fc0a9866fc4009c
Author: M Nikhil <nikh1092@linux.ibm.com>

zfcp: Use DMA streaming API to map I/O

This commit converts zFCP I/O buffer mappings for QTCB, SRB, CT/ELS, and
SCSI I/O requests to use the DMA streaming API via dma_map_sgtable() and
dma_unmap_sgtable(). It also updates the SCSI abort and reset paths to
unmap the scatter-gather lists associated with aborted or forgotten SCSI
commands.

> diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
> index ea4b968352f4d..99baca26c9bf0 100644
> --- a/drivers/s390/scsi/zfcp_scsi.c
> +++ b/drivers/s390/scsi/zfcp_scsi.c
> @@ -184,6 +184,15 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cm=
nd *scpnt)
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

[Severity: High]
Can this unmap scpnt->sdb.table and scpnt->prot_sdb->table a second time if
zfcp_scsi_forget_cmnd() has already run for old_req?

When a LUN or target reset TMF completes in zfcp_scsi_task_mgmt_function(),
for instance via an SG_SCSI_RESET ioctl in scsi_ioctl_reset(), it calls
zfcp_scsi_forget_cmnds() -> zfcp_scsi_forget_cmnd() under
adapter->abort_lock. That function unmaps scpnt->prot_sdb->table and
scpnt->sdb.table and sets old_req->data =3D NULL, while leaving old_req in
adapter->req_list, scpnt->host_scribble set to old_req->req_id, and
sgt->nents non-zero.

Because old_req->data is now NULL, zfcp_fsf_fcp_cmnd_handler() will not
call scsi_done(scpnt). If scpnt subsequently times out and enters
zfcp_scsi_eh_abort_handler(scpnt) while old_req is still in
adapter->req_list, zfcp_reqlist_find() still finds old_req:

drivers/s390/scsi/zfcp_scsi.c:zfcp_scsi_eh_abort_handler()
	write_lock_irqsave(&adapter->abort_lock, flags);

	old_req =3D zfcp_reqlist_find(adapter->req_list, old_reqid);
	if (!old_req) {
		write_unlock_irqrestore(&adapter->abort_lock, flags);
		zfcp_dbf_scsi_abort("abrt_or", scpnt, NULL);
		return FAILED; /* completion could be in progress */
	}
	...
	old_req->data =3D NULL;

Unlike zfcp_fsf_fcp_cmnd_handler() and zfcp_scsi_forget_cmnd(),
zfcp_scsi_eh_abort_handler() does not check whether old_req->data is
already NULL before proceeding to out_unmap:, where zfcp_fsf_req_unmap_sg()
is called on scpnt->prot_sdb->table and scpnt->sdb.table again.

Should zfcp_scsi_eh_abort_handler() check if (!old_req || !old_req->data)
under adapter->abort_lock before taking ownership of the unmap?

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
> @@ -224,6 +249,28 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cm=
nd *scpnt)
>  	}
>  	zfcp_dbf_scsi_abort(dbf_tag, scpnt, abrt_req);
>  	zfcp_fsf_req_free(abrt_req);
> +
> +out_unmap:
> +	/*
> +	 * The hardware has stopped using the SCSI command's DMA buffers:
> +	 * either the adapter confirmed the abort, ERP quiesced the adapter
> +	 * (zfcp_fsf_req_dismiss_all requires QDIO down), or fc_block_scsi_eh
> +	 * signalled link-level quiesce.  Unmap here, directly from scpnt,
> +	 * because old_req must not be touched after the abort_lock was
> +	 * released.  The normal completion handler (zfcp_fsf_fcp_cmnd_handler)
> +	 * skips its own unmap when it sees req->data =3D=3D NULL, so there is =
no
> +	 * double-unmap.
> +	 */
> +	if ((scsi_get_prot_op(scpnt) !=3D SCSI_PROT_NORMAL) &&
> +	    scsi_prot_sg_count(scpnt))
> +		zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
> +				      &scpnt->prot_sdb->table,
> +				      scpnt->sc_data_direction);
> +
> +	zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
> +			      &scpnt->sdb.table,
> +			      scpnt->sc_data_direction);
> +
>  	return retval;
>  }

[Severity: Critical]
Could jumping to out_unmap: on the failure and FAST_IO_FAIL paths in
zfcp_scsi_eh_abort_handler() unmap scpnt->sdb.table and
scpnt->prot_sdb->table while the FCP channel is still accessing those
buffers?

There appear to be three paths reaching out_unmap: where the hardware has
not yet stopped using scpnt's DMA buffers:

1. When all retries of zfcp_fsf_abort_fcp_cmnd(scpnt) return NULL (!abrt_re=
q,
dbf_tag =3D "abrt_ar", retval =3D FAILED) while adapter->status still has
ZFCP_STATUS_COMMON_RUNNING and fc_block_scsi_eh(scpnt) returns 0 (for
example, if zfcp_qdio_sbal_get() or zfcp_fsf_req_create() fails, or if
zfcp_sdev->status lacks ZFCP_STATUS_COMMON_UNBLOCKED during LUN-level ERP
while the rport remains ONLINE). No abort command was sent, QDIO remains
active, and old_req is still in flight on the channel.

2. When abrt_req completes without ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED or
ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED (dbf_tag =3D "abrt_fa", retval =3D FAILED=
),
such as on FSF_ADAPTER_STATUS_AVAILABLE, FSF_LUN_BOXED, FSF_PORT_BOXED,
FSF_LUN_HANDLE_NOT_VALID, FSF_PORT_HANDLE_NOT_VALID, or when abrt_req times
out in zfcp_fsf_request_timeout_handler(). The adapter has not confirmed
that old_req was terminated, and any ERP recovery is only scheduled
asynchronously without waiting before out_unmap: runs.

3. When fc_block_scsi_eh(scpnt) returns FAST_IO_FAIL (dbf_tag =3D "abrt_bl"=
).
fc_block_scsi_eh() waits on the rport's FC_PORTSTATE_BLOCKED state, which
occurs during port-level ERP or link-down handling without shutting down
QDIO or calling zfcp_fsf_req_dismiss_all(). In addition,
fc_timeout_fail_rport_io() sets FC_RPORT_FAST_FAIL_TIMEDOUT before calling
fc_terminate_rport_io():

drivers/scsi/scsi_transport_fc.c:fc_timeout_fail_rport_io()
	if (rport->port_state !=3D FC_PORTSTATE_BLOCKED)
		return;

	rport->flags |=3D FC_RPORT_FAST_FAIL_TIMEDOUT;
	fc_terminate_rport_io(rport);

And zfcp_scsi_terminate_rport_io() only queues zfcp_erp_port_forced_reopen()
asynchronously without waiting for the port reopen to complete.

Furthermore, because old_req->data was already cleared to NULL at the start
of zfcp_scsi_eh_abort_handler(), neither zfcp_scsi_forget_cmnd() (during
subsequent SCSI EH LUN/target reset escalation) nor
zfcp_fsf_fcp_cmnd_handler() (during adapter reopen /
zfcp_fsf_req_dismiss_all()) will unmap the buffers once the hardware
actually quiesces.

Should old_req->data remain set and the DMA unmap be skipped when
zfcp_scsi_eh_abort_handler() does not confirm that old_req was aborted or
that the adapter was quiesced, leaving the unmap to the subsequent reset or
request dismissal path?

> =20
> @@ -237,6 +284,7 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req=
 *old_req, void *data)
>  {
>  	struct zfcp_scsi_req_filter *filter =3D
>  		(struct zfcp_scsi_req_filter *)data;
> +	struct scsi_cmnd *scpnt;
> =20
>  	/* already aborted - prevent side-effects - or not a SCSI command */
>  	if (old_req->data =3D=3D NULL ||
> @@ -244,6 +292,8 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req=
 *old_req, void *data)
>  	    old_req->qtcb->header.fsf_command !=3D FSF_QTCB_FCP_CMND)
>  		return;
> =20
> +	scpnt =3D old_req->data;
> +
>  	/* (tmf_scope =3D=3D FCP_TMF_TGT_RESET || tmf_scope =3D=3D FCP_TMF_LUN_=
RESET) */
>  	if (old_req->qtcb->header.port_handle !=3D filter->port_handle)
>  		return;
> @@ -253,6 +303,17 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_re=
q *old_req, void *data)
>  		return;
> =20
>  	zfcp_dbf_scsi_nullcmnd((struct scsi_cmnd *)old_req->data, old_req);
> +
> +	if ((scsi_get_prot_op(scpnt) !=3D SCSI_PROT_NORMAL) &&
> +	    scsi_prot_sg_count(scpnt))
> +		zfcp_fsf_req_unmap_sg(&old_req->adapter->ccw_device->dev,
> +				      &scpnt->prot_sdb->table,
> +				      scpnt->sc_data_direction);
> +
> +	zfcp_fsf_req_unmap_sg(&old_req->adapter->ccw_device->dev,
> +			      &scpnt->sdb.table,
> +			      scpnt->sc_data_direction);
> +
>  	old_req->data =3D NULL;
>  }

[Severity: High]
What happens in zfcp_scsi_forget_cmnd() if another FCP task management
request is in flight in adapter->req_list for the same port or LUN?

In zfcp_fsf_fcp_task_mgmt(), task management requests are also created with
fsf_command =3D=3D FSF_QTCB_FCP_CMND, but req->data holds a struct scsi_dev=
ice *
rather than a struct scsi_cmnd *:

drivers/s390/scsi/zfcp_fsf.c:zfcp_fsf_fcp_task_mgmt()
	req =3D zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
				  SBAL_SFLAGS0_TYPE_WRITE,
				  qdio->adapter->pool.scsi_req);
	...
	req->data =3D sdev;
	req->handler =3D zfcp_fsf_fcp_task_mgmt_handler;
	req->qtcb->header.lun_handle =3D zfcp_sdev->lun_handle;
	req->qtcb->header.port_handle =3D zfcp_sdev->port->handle;
	req->qtcb->bottom.io.data_direction =3D FSF_DATADIR_CMND;

If two TMF requests are in flight concurrently (for example, an
SG_SCSI_RESET ioctl in scsi_ioctl_reset() racing with scsi_error_handler()
or another SG_SCSI_RESET ioctl), zfcp_scsi_forget_cmnds() will invoke
zfcp_scsi_forget_cmnd() on the other in-flight TMF request, cast its
struct scsi_device * in old_req->data to struct scsi_cmnd *, pass fields of
struct scsi_device to zfcp_fsf_req_unmap_sg(), and clear old_req->data to
NULL (which zfcp_fsf_fcp_task_mgmt_handler() later dereferences).

Should zfcp_scsi_forget_cmnd() also check that old_req is not a TMF request
(for example, by checking old_req->qtcb->bottom.io.data_direction !=3D
FSF_DATADIR_CMND or old_req->status & ZFCP_STATUS_FSFREQ_CLEANUP)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022170828.4189=
701-1-nikh1092@linux.ibm.com?part=3D2
