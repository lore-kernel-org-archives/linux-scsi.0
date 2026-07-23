Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F11EDA32
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768330; cv=none; b=VGYZWtBnlH4l0ht2aYquyS5DQvktXlPV+cwvB4STQVCfXgBqoorfDa3FD3aV+0d2mPmIb8PY/7MFDpBoZ7hf2nPgiQF+KMgCxW6ePh8lzszC/kmwHG9u9SpXyl2xltmWqBCdNKYlzwCuwpyiRmSsegLfYRF5lu9kgVJFnOCC3Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768330; c=relaxed/simple;
	bh=NNW5RHe+8xkHH6u+F+OUKMh9Wpi3CdRm2Ur1PLKWCLI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F6uI66GL2TB0bmlRIYmPPKZhgQL2UhmE4sa3Brpdy3s+6kDjmC7jvXA+bT7cMAB5FZXpPg492FVJTyNsWamwDbjV6PoajDaKq5oBPiTeYC3jF+IhjR7Q73syXFBtIhGbeUO2fjEZoNcBIdgEnzgsTecKjHXmcaucoBboc1cpya4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ax89ZTNJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ax89ZTNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3201B1F000E9;
	Thu, 23 Jul 2026 00:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784768329;
	bh=eTIBOyBL3VzSV1mbWNlZFlrJfddoaq5ytGsUIzWc4Ms=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ax89ZTNJSkLJEXVg/WZY9XX5KYYZKe4z00lOx0m1v/5M1O63el/tRJeeuQzfSEoCu
	 DdOxU6GrtP41UZP1B4/gTciPT1FIB+hHl8u7GWXVzoOGL6iqGp+lwY034VBzehaN1u
	 JE26m/jButbxit0UhJn2FUHaQ7THrCOnUAns3GbMVJezuna2UOlxiB4gHl21VXTDwA
	 A6ivQhj4zNbqERFfXsAX+HDlaf10zuba4dJgKRNYms1mDsNV0tRoLatxnaK1uspr12
	 0/yYYaZcgXMz2A06+tawCSflVnYhtG6yiMdyoe/WKHmQjwbfUqZeFuq4pd2XQDDJ9D
	 NBM7laqKFIfdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 33/33] ibmvfc: fail nvme-fc fcp-io and ls requests
 during transport reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-34-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-34-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:58:48 +0000
Message-Id: <20260723005849.3201B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] The local variable `shwqs` is used uninitialized in `ibmvfc_pu=
rge_requests` when `vhost->using_channels` is false, leading to undefined b=
ehavior, out-of-bounds array access, and potential kernel crashes.

Pre-existing issues:
- [High] Dereferencing an uninitialized or stale `tgt` pointer during NVMe =
FCP aborts because `evt->tgt` is never initialized for FCP requests.
- [High] NVMe FC IO requests return a SCSI-specific busy code (`SCSI_MLQUEU=
E_HOST_BUSY`) when the CRQ is closed, causing immediate IO failures instead=
 of retries.
--

--- Patch [33]: [PATCH v2 33/33] ibmvfc: fail nvme-fc fcp-io and ls request=
s during transport reset ---
commit ffc022564293825c73fe8e34bd53f9d7f153f0e8
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: fail nvme-fc fcp-io and ls requests during transport reset

The current purge code for flushing outstanding commands during a
transport reset only deals with SCSI commands. Rename the
ibmvfc_scsi_eh_done completion handler to ibmvfc_vfc_eh_done and wire it
to correctly complete nvme fcp and ls commands when flushing the
inflight command list during a reset.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index bc975f632da21..dfa231b6cc478 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> -static void ibmvfc_scsi_eh_done(struct ibmvfc_event *evt)
> +static void ibmvfc_vfc_eh_done(struct ibmvfc_event *evt)
>  {
>  	struct scsi_cmnd *cmnd =3D evt->cmnd;
> +	struct nvmefc_ls_req *ls_req =3D evt->ls_req;
> +	struct nvmefc_fcp_req *fcp_req =3D evt->fcp_req;

[Severity: High]
This is a pre-existing issue, but does evt->tgt remain uninitialized for
FCP requests?

When an NVMe FCP command is submitted via ibmvfc_nvme_fcp_io(), evt->tgt
is not fully initialized.=20

If an abort occurs, ibmvfc_init_fcp_abort() reads the uninitialized
or stale pointer from abt_evt->tgt:

ibmvfc_init_fcp_abort()
    struct ibmvfc_event *abt_evt =3D abort_req->private;
    struct ibmvfc_target *tgt =3D abt_evt->tgt;
    ...
    tmf->target_wwpn =3D cpu_to_be64(tgt->wwpn);

Could this lead to a null pointer dereference or use-after-free crash
when reading tgt->wwpn during standard NVMe timeout and abort handling?

>  	if (cmnd) {
>  		scsi_dma_unmap(cmnd);
>  		scsi_done(cmnd);
> +	} else if (fcp_req) {
> +		fcp_req->rcv_rsplen =3D 0;

[ ... ]

> @@ -1164,13 +1176,16 @@ static void ibmvfc_fail_request(struct ibmvfc_eve=
nt *evt, int error_code)
>  static void ibmvfc_purge_requests(struct ibmvfc_host *vhost, int error_c=
ode)
>  {
>  	struct ibmvfc_event *evt, *pos;
> -	struct ibmvfc_queue *queues =3D vhost->scsi_scrqs.scrqs;
> +	struct ibmvfc_queue *scsi_q =3D vhost->scsi_scrqs.scrqs;
> +	struct ibmvfc_queue *nvme_q =3D vhost->nvme_scrqs.scrqs;
>  	unsigned long flags;
> -	int hwqs =3D 0;
> +	int shwqs, nhwqs =3D 0;
>  	int i;
> =20
> -	if (vhost->using_channels)
> -		hwqs =3D vhost->scsi_scrqs.active_queues;
> +	if (vhost->using_channels) {
> +		shwqs =3D vhost->scsi_scrqs.active_queues;
> +		nhwqs =3D vhost->nvme_scrqs.active_queues;
> +	}

[ ... ]

> -	for (i =3D 0; i < hwqs; i++) {
> -		spin_lock_irqsave(queues[i].q_lock, flags);
> -		spin_lock(&queues[i].l_lock);
> -		list_for_each_entry_safe(evt, pos, &queues[i].sent, queue_list)
> +	for (i =3D 0; i < shwqs; i++) {

[Severity: Critical]
Does this leave shwqs uninitialized when vhost->using_channels is false?

The declaration 'int shwqs, nhwqs =3D 0;' only initializes nhwqs to zero.

If a transport reset occurs on a host without channel support, the loop
condition checking against shwqs might use uninitialized memory. Can this
cause an out-of-bounds access on the scsi_q array and result in a kernel
panic?

> +		spin_lock_irqsave(scsi_q[i].q_lock, flags);
> +		spin_lock(&scsi_q[i].l_lock);
> +		list_for_each_entry_safe(evt, pos, &scsi_q[i].sent, queue_list)
>  			ibmvfc_fail_request(evt, error_code);
> -		list_splice_init(&queues[i].sent, &vhost->purge);
> -		spin_unlock(&queues[i].l_lock);
> -		spin_unlock_irqrestore(queues[i].q_lock, flags);
> +		list_splice_init(&scsi_q[i].sent, &vhost->purge);
> +		spin_unlock(&scsi_q[i].l_lock);
> +		spin_unlock_irqrestore(scsi_q[i].q_lock, flags);
> +	}

[ ... ]

> @@ -1818,7 +1843,9 @@ int ibmvfc_send_event(struct ibmvfc_event *evt,

[Severity: High]
This is a pre-existing issue, but earlier in ibmvfc_send_event() the code
unconditionally returns SCSI_MLQUEUE_HOST_BUSY when the send_crq error
code is H_CLOSED:

ibmvfc_send_event()
    if (rc =3D=3D H_CLOSED) {
        ...
        return SCSI_MLQUEUE_HOST_BUSY;
    }

Will this cause the NVMe FC transport layer to interpret the non-EBUSY
return value as a hard failure?

The NVMe transport might immediately fail the IO instead of gracefully
retrying it during transient transport disruptions like VIOS restarts or
Live Partition Mobility, potentially leading to filesystem corruption.

>  		dev_err(vhost->dev, "Send error (rc=3D%d)\n", rc);
>  		if (evt->cmnd) {
>  			evt->cmnd->result =3D DID_ERROR << 16;
> -			evt->done =3D ibmvfc_scsi_eh_done;
> +			evt->done =3D ibmvfc_vfc_eh_done;
> +		} else if (evt->fcp_req || evt->ls_req) {
> +			evt->done =3D ibmvfc_vfc_eh_done;
>  		} else {
>  			evt->xfer_iu->mad_common.status =3D cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
>  			evt->done =3D evt->_done;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D33
