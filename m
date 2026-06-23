Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D015313C9C4
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180281; cv=none; b=ZiQSHzqFvHLnsOWjnGRCCGn7f0Gu5Q0QN4KwcjT9EwDgqKAIVXLsp4bxsSsGVH381UoxcHnBsLX/X2vYLOyb/0gBjHz3BoVysLzkCAY++QqkbXMhowkVNvwJ8eNPwftc+wQoRdQsu3kGYUI0ai9X/ajnBwL74m5EM7N1QUPrvz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180281; c=relaxed/simple;
	bh=yMVBCIChQgFP06uPrcWg35V6HPAb1vKHQkqdeHGZ1vg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hZpRy5GPdEb7KJRBUECYk6gMp6/i6vI/ik4zy0rx9O/QcD2hCcDM3ZuImtqM9TfulNur0EaKA2cR9AL4n8vhPz8e3tOU5NCCA+5kZI9kBtlNs9enfV82f3p5JLZg7KKG2X8UgFl7dX7+yxNI10xbJOzktXLqppvGQrjyFygC2U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPRz/+IR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPRz/+IR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF251F000E9;
	Tue, 23 Jun 2026 02:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180279;
	bh=C0USVOOIsCK4t8IBEbU5zMl8c9GgJHn0mTuK5oMKJag=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YPRz/+IRQOqo/o2J1LAA2m6WnpE++6bcvXQOYuV48wMOHqNq+s5iN3x1WAcbEle/j
	 eotYK8uKGLyxGoz9qIHs59FJpie4EJl1da4Ii3ne16DqhE6b0op8GKr4SxNJHf4TeV
	 SrSThbCxM+fB1+HhwVfKXOrLencyy/hWfq+I9fosJwdVRtLzwtfe8Afbzhs6gNYiIm
	 hLCfdFZObOvv7jbAV6orrWHleMRkzTyNUDbcRBpT9iQknsNSh4fOJHZ35Uxq9zlAMT
	 72BxJXtmygIv7FKqA1/EvJB+vD9Aw60SR+sPPHmo3ewPWydW9V7pL5WzIe4nGPH3vc
	 8ZJBMF5y+gZNQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 29/29] ibmvfc: fail nvme-fc fcp-io and ls requests
 during transport reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-30-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-30-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:04:39 +0000
Message-Id: <20260623020439.5AF251F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] Pooled event structures retain stale NVMe request pointers, le=
ading to exploitable Use-After-Free and double completions when non-NVMe co=
mmands fail.
- [High] Target kref is permanently leaked when an NVMe LS request fails or=
 is purged.

Pre-existing issues:
- [High] Returning SCSI_MLQUEUE_HOST_BUSY for NVMe requests on transport cl=
osure causes permanent IO failures instead of requeuing.
- [Medium] NVMe FCP requests are not purged during a transport reset, rende=
ring the patch's FCP functionality dead code.
--

commit 88ce7ce7f11c11cfca700c6919820cf4d9865c8a
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

    ibmvfc: fail nvme-fc fcp-io and ls requests during transport reset
   =20
    The current purge code for flushing outstanding commands during a
    transport reset only deals with SCSI commands. Rename the
    ibmvfc_scsi_eh_done completion handler to ibmvfc_vfc_eh_done and wire it
    to correctly complete nvme fcp and ls commands when flushing the
    inflight command list during a reset.

> The current purge code for flushing outstanding commands during a
> transport reset only deals with SCSI commands. Rename the
> ibmvfc_scsi_eh_done completion handler to ibmvfc_vfc_eh_done and wire it
> to correctly complete nvme fcp and ls commands when flushing the
> inflight command list during a reset.

[Severity: Medium]
This isn't a bug introduced by this patch, but does the purge code actually
evaluate inflight NVMe FCP commands?

Looking at ibmvfc_purge_requests(), the loop iterates over vhost->crq and
vhost->scsi_scrqs.scrqs:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_purge_requests() {
    ...
    for (i =3D 0; i < hwqs; i++) {
        spin_lock_irqsave(queues[i].q_lock, flags);
    ...
}

It seems to entirely miss vhost->nvme_scrqs.scrqs where FCP requests are
queued. If so, inflight NVMe FCP commands might be orphaned during a reset,
making the new FCP completion handling unreachable.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index a7183493cf965..aeb5b8902aa55 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -1092,20 +1092,28 @@ void ibmvfc_free_event(struct ibmvfc_event *evt)
>  }
> =20
>  /**
> - * ibmvfc_scsi_eh_done - EH done function for queuecommand commands
> + * ibmvfc_vfc_eh_done - EH done function for queued IO
>   * @evt:	ibmvfc event struct
>   *
> - * This function does not setup any error status, that must be done
> - * before this function gets called.
> + * This function does not setup any error status for scsi commands, that=
 must be
> + * done before this function gets called.
>   **/
> -static void ibmvfc_scsi_eh_done(struct ibmvfc_event *evt)
> +static void ibmvfc_vfc_eh_done(struct ibmvfc_event *evt)
>  {
>  	struct scsi_cmnd *cmnd =3D evt->cmnd;
> +	struct nvmefc_ls_req *ls_req =3D evt->ls_req;
> +	struct nvmefc_fcp_req *fcp_req =3D evt->fcp_req;
> =20
>  	if (cmnd) {
>  		scsi_dma_unmap(cmnd);
>  		scsi_done(cmnd);
> -	}
> +	} else if (fcp_req) {
> +		fcp_req->rcv_rsplen =3D 0;
> +		fcp_req->transferred_length =3D 0;
> +		fcp_req->status =3D NVME_SC_INTERNAL;
> +		fcp_req->done(fcp_req);
> +	} else if (ls_req)
> +		ls_req->done(ls_req, -EIO);

[Severity: High]
Does this error handler leak the target kref for LS requests?

In ibmvfc_nvme_ls_req(), a reference is taken via kref_get(&tgt->kref) which
is typically dropped in the success path by ibmvfc_ls_req_done().

Since this patch replaces the completion handler with ibmvfc_vfc_eh_done(),
the transport request is completed here but kref_put(&evt->tgt->kref, ...)
is never called, potentially leaving the target structure leaked.

> =20
>  	ibmvfc_free_event(evt);
>  }
> @@ -1146,8 +1154,10 @@ static void ibmvfc_fail_request(struct ibmvfc_even=
t *evt, int error_code)
>  	BUG_ON(!atomic_dec_and_test(&evt->active));
>  	if (evt->cmnd) {
>  		evt->cmnd->result =3D (error_code << 16);
> -		evt->done =3D ibmvfc_scsi_eh_done;
> -	} else
> +		evt->done =3D ibmvfc_vfc_eh_done;
> +	} else if (evt->fcp_req || evt->ls_req)
> +		evt->done =3D ibmvfc_vfc_eh_done;
> +	else

[Severity: Critical]
Can these checks be triggered by stale NVMe pointers on non-NVMe commands?

When ibmvfc_get_event() reallocates an event structure from the pool,
ibmvfc_init_event() doesn't clear evt->fcp_req or evt->ls_req to NULL:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_init_event() {
    ...
    evt->cmnd =3D NULL;
    evt->sync_iu =3D NULL;
    evt->eh_comp =3D NULL;
    ...
}

If a non-NVMe command (e.g., a MAD command) is allocated an event with stale
NVMe pointers and fails here, will it incorrectly replace the completion
handler with ibmvfc_vfc_eh_done() and later use-after-free the stale NVMe
pointers?

>  		evt->xfer_iu->mad_common.status =3D cpu_to_be16(IBMVFC_MAD_DRIVER_FAIL=
ED);
> =20
>  	timer_delete(&evt->timer);

[ ... ]

> @@ -1816,8 +1826,10 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,

[Severity: High]
This isn't a bug introduced by this patch, but earlier in ibmvfc_send_event=
(),
it hardcodes a return of SCSI_MLQUEUE_HOST_BUSY on H_CLOSED without
distinguishing between SCSI and NVMe commands:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_send_event() {
    ...
    if (rc =3D=3D H_CLOSED) {
        ...
        return SCSI_MLQUEUE_HOST_BUSY;
    }
    ...
}

This value (0x1055) is propagated back up through ibmvfc_nvme_fcp_io()
directly to the NVMe FC transport layer. Since 0x1055 is neither 0 nor
-EBUSY, will the NVMe FC core treat it as a hard failure and abort the
request with BLK_STS_IOERR instead of handling the queue pressure
appropriately?

>  		dev_err(vhost->dev, "Send error (rc=3D%d)\n", rc);
>  		if (evt->cmnd) {
>  			evt->cmnd->result =3D DID_ERROR << 16;
> -			evt->done =3D ibmvfc_scsi_eh_done;
> -		} else
> +			evt->done =3D ibmvfc_vfc_eh_done;
> +		} else if (evt->fcp_req || evt->ls_req)
> +			evt->done =3D ibmvfc_vfc_eh_done;
> +		else
>  			evt->xfer_iu->mad_common.status =3D cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
> =20
>  		evt->done(evt);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D29
