Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5042C21FF
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180599; cv=none; b=o1GLTeMQkcpdVwEvFjZgEJuqq0U7fuzdxIkBtR7VWTPYSds9QnA1ppptxQdT++mfijhfQyMrX/ZEX1iHKK0xD7Z0mPjvGMw0xPxUd6/I3ht+HZOJbEvZfxOztKOaGXRrjU6O7ZFpAeaIawz7FqfUHFu+gJX4sGmO/NRr9cMeO6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180599; c=relaxed/simple;
	bh=c99THpIc0k4iOZli3exFBOV8ciAcS2BVqW7NmXBG5zw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eJqdSf2iYMs09gArtRss21Qc8U+4odY9RA/249nAAK/sFVKS1uCb/Rcwm13V/BbhGjVm9hE1wSElGaCpKIsbfwPxGJkrFJ9bLVrCpUAzpJ2QlWEtiwBpmXQ2QtfqMLKRsRbbXpUZw1vVTbVQc7GFZUfq3uiFae7RgXjTD6cFpF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHoF5aC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHoF5aC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10391F000E9;
	Tue, 23 Jun 2026 02:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180598;
	bh=bN2LH9sYPpGzKvBsTPbn1MLIFL+GTUYhsalgo0cSizM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BHoF5aC7WQTaJIOsAZrPajQR8WPx8jLKNsKUng0fidCWgSArZA1H8ZkIZrXaf3RA7
	 gV2M8uOOAZKekG9W7EpPGYYI7AcF38DrMN55KQSrjB/acX0Ry/S/F1/bCnAqWgOP04
	 f4Xa5jYeLsmN3ZwA4UtSTFPzSPMcIm32ie3sSWKUm9pKVw7THZ9Plgfm/mAnbROB0E
	 NqzyUQdi1DBm3FuSERzUnx7QY2Uz5iAtZX+csLbeBpYYcRn0W3RVYbpxH1pVMDPsUs
	 IRfLmiycMzoEBfrQxck0+/9atD6HK5ydl6DQ/5LwFboBfZbOVMqcqwN98jV/kTuBeP
	 X/Mjk2765PEWg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 27/29] ibmvfc: implement nvme-fc LS abort handling
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-28-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-28-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:09:57 +0000
Message-Id: <20260623020957.D10391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] The allocated ibmvfc_event structure is leaked on early return if =
the virtual host is not logged in.
- [High] Recursive spinlock self-deadlock or Use-After-Free on `ibmvfc_send=
_event()` failure.
- [High] Unsynchronized access to a potentially freed event structure (`abt=
_evt`) via `ls_abort->private` leads to a Use-After-Free.
- [High] Event leak when `ibmvfc_send_event()` fails, bypassing the freeing=
 logic.
- [Medium] Logic inversion defeats the `IBMVFC_CAN_SUPPRESS_ABTS` capabilit=
y check.
- [Low] Uninitialized stack variable `status` is read and printed on the er=
ror path.
- [Low] Returning a SCSI midlayer error code (`SCSI_MLQUEUE_HOST_BUSY`) to =
the NVMe FC transport causes unintended API violations.
--

commit e8f5bb9c65a6243c394bbc91b4a31f61c71ee322
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement nvme-fc LS abort handling callback

Implement the NVMe FC-LS abort callback by issuing an ibmvfc cancel MAD
to the VIOS for the outstanding link-service request.

Use the saved event pointer from the original FC-LS request to identify
the command to cancel, submit the cancel operation, and complete the
abort request based on the returned status.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index bff469d0b47df..18e8657abc444 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c

[ ... ]

> @@ -159,10 +161,72 @@ static int ibmvfc_nvme_ls_req(struct nvme_fc_local_=
port *lport,

[ ... ]

> +static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc=
_ls_req *ls_abort)
> +{
> +	struct ibmvfc_tmf *tmf;
> +	struct ibmvfc_event *abt_evt =3D ls_abort->private;
> +	struct ibmvfc_target *tgt =3D abt_evt->tgt;

[Severity: High]
Can this sequence actually occur? If the NVMe FC transport invokes the abort
callback concurrently with the normal completion of the LS request, could
ibmvfc_ls_req_done() complete the request and free abt_evt to the pool befo=
re
we access abt_evt->tgt here?

> +	struct ibmvfc_host *vhost =3D evt->vhost;
> +
> +	tmf =3D &evt->iu.tmf;
> +	memset(tmf, 0, sizeof(*tmf));
> +	tmf->common.version =3D cpu_to_be32(2);
> +	tmf->target_wwpn =3D cpu_to_be64(tgt->wwpn);
> +	tmf->common.opcode =3D cpu_to_be32(IBMVFC_NVMF_TMF_MAD);
> +	tmf->common.length =3D cpu_to_be16(sizeof(*tmf));
> +	if (vhost->state !=3D IBMVFC_ACTIVE)
> +		if (!ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPRESS_ABTS))
> +			tmf->flags =3D cpu_to_be32(IBMVFC_TMF_SUPPRESS_ABTS);

[Severity: Medium]
Does this logic correctly evaluate the capability? The check evaluates to t=
rue
only when the adapter does not support suppressing ABTS, which appears to
set IBMVFC_TMF_SUPPRESS_ABTS on adapters that do not support it, and omits
it on adapters that do.

> +	tmf->cancel_key =3D cpu_to_be32((u64)abt_evt);
> +	tmf->my_cancel_key =3D cpu_to_be32((u64)evt);
> +	tmf->assoc_id =3D cpu_to_be64(tgt->assoc_id);
> +
> +	init_completion(&evt->comp);
> +}
> +
>  static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
>  				struct nvme_fc_remote_port *rport,
>  				struct nvmefc_ls_req *ls_abort)
>  {
> +	struct ibmvfc_host *vhost =3D lport->private;
> +	struct ibmvfc_target *tgt =3D rport->private;
> +	struct ibmvfc_event *evt;
> +	union ibmvfc_iu rsp;
> +	unsigned long flags;
> +	u16 status;
> +
> +	evt =3D ibmvfc_get_event(&vhost->crq);
> +	if (!vhost->logged_in || !evt)
> +		return;

[Severity: High]
Does this code leak the event structure? If vhost->logged_in is false,
ibmvfc_get_event() might successfully allocate an event from the vhost->crq
pool, but returning immediately here leaves the allocated event unreleased.
Repeated abort attempts could permanently exhaust the event pool.

> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	kref_get(&tgt->kref);
> +	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
> +	ibmvfc_init_ls_abort(evt, ls_abort);
> +	evt->sync_iu =3D &rsp;
> +
> +	if (ibmvfc_send_event(evt, vhost, default_timeout))

[Severity: High]
Can this lead to a recursive self-deadlock or a use-after-free?

If ibmvfc_send_event() fails, it invokes evt->done(evt) synchronously:

ibmvfc_send_event()
    if (rc)
        evt->done(evt);

If the event is fresh, evt->done remains ibmvfc_locked_done(), which attemp=
ts
to acquire vhost->host->host_lock. Since this lock is already held here bef=
ore
calling ibmvfc_send_event(), will this self-deadlock?

Additionally, because ibmvfc_init_event() doesn't zero evt->ls_req or
evt->fcp_req, could recycled events contain stale pointers that cause a
use-after-free when ibmvfc_send_event() evaluates those fields and replaces
evt->done with ibmvfc_vfc_eh_done() on failure?

[Severity: Low]
On a related note regarding ibmvfc_send_event(), when the receive queue is
closed it returns SCSI_MLQUEUE_HOST_BUSY. In places like ibmvfc_nvme_fcp_io=
()
that directly return the output of ibmvfc_send_event(), does returning a
positive SCSI midlayer error code to the NVMe FC transport cause unintended
API violations? The NVMe FC transport typically expects 0 for success or
standard negative error codes.

> +		goto out;

[Severity: High]
Does this goto skip the event cleanup? Although ibmvfc_send_event()'s error
path executes evt->done, ibmvfc_sync_nvme_completion() only calls complete()
on the event wait structure, meaning the event is never explicitly freed and
could be permanently leaked.

> +
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +
> +	wait_for_completion(&evt->comp);
> +	status =3D be16_to_cpu(rsp.mad_common.status);
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	ibmvfc_free_event(evt);
> +out:
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +	ibmvfc_dbg(vhost, "ls_abort: cancel failed with rc=3D%x\n", status);

[Severity: Low]
Is status uninitialized when we reach the out label? If ibmvfc_send_event()
fails and triggers the goto, status is never assigned and might leak
uninitialized stack memory into the logs.

> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D27
