Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD64470EA2
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 01:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768735; cv=none; b=ePBaHsLWadtqI3VMGT45xWG3gwBIQlDjsbVqyyTU0pFuByBsZQtM2/xajl1uM+pgPJB3L3+xNfJXTqJmzT/aS3SJeu6DRfqSAbp7h9Fp0At4Z/NCH5ptc5/DltbrLuqI8hfS6OqSz+nfjkMIaQJqh/ADM/9vTtwjA7T3d19rK7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768735; c=relaxed/simple;
	bh=4/hw/XCkPp6Xt4JjIdY8jDlBkppd0bI6vSyTRcvZKfs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=s9l8k/ymRi9QgkdNRPakCCMSLKZFy3txcV2Yc+uYVobIuLeMbtwLH6kUxz6VHKMjKXXNB77eZDQkCBveVuSkvHQn0/+83xnb6/kud8ZPOKxhYYUnu7ZN4RjF10WUk+uBZIEnVfY1bo2qhvaNmmhz/z3wlaFQKQBoEGINyXLVSfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2F5D/+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2F5D/+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7621F000E9;
	Thu, 23 Jul 2026 01:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784768734;
	bh=s0+LRRsPP35uMrzq0jxNk0jDTL5vhx87QuoZep3OZcE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G2F5D/+70CH647HnbNleNKNlLhnVXiFFdxyCsMfQ6dqt7UIxGmJbMDFMVhUr0SraS
	 JKcNCqmW63AaCw3Jb+9iEqUlwSxwRJ12gmx9fnWAGO6ZAOlcuwbOETheWCoWGGYfZ4
	 fSIO+7afpQhHOuBr6GIa53TVhsZpN16nTbjPPWX5wiIpPLa6IC5tSJfC55E77Oh7UA
	 wcPs7O0Rk7dK9pvyDVZXw3gpchzsNxgNQlHVqUMfEWK8w4zmQA/b65zNsJw/66hHdE
	 cJSPja3WW3KqJLhhhRl350xBnTP6xE5C4AyDwEesECHB6DvysLpBqYP6TFyRURS0Ws
	 +aOEEAq52GDoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 31/33] ibmvfc: implement nvme-fc LS abort handling
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-32-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-32-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 01:05:33 +0000
Message-Id: <20260723010534.2D7621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Concurrent completion of an NVMe FC-LS request causes a Use-After-=
Free of the event structure and incorrect cancellation of an unrelated comm=
and.
- [High] Inverted capability check sets the IBMVFC_TMF_SUPPRESS_ABTS flag o=
nly when the adapter lacks the capability.
- [High] The CRQ event structure is leaked from its fixed-size pool if the =
host is not logged in when an abort is issued.
- [Low] The local variable `status` is used uninitialized if `ibmvfc_send_e=
vent()` fails, leading to uninitialized stack memory being logged.
--

--- Patch [31]: [PATCH v2 31/33] ibmvfc: implement nvme-fc LS abort handlin=
g callback ---
commit 508e0371279894532111408d7a22f80e0afd86a5
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement nvme-fc LS abort handling callback

Implement the NVMe FC-LS abort callback by issuing an ibmvfc cancel MAD
to the VIOS for the outstanding link-service request.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index d31e7e9ea7a9e..390410e44f0d8 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c

[ ... ]

> @@ -159,10 +161,72 @@ static int ibmvfc_nvme_ls_req(struct nvme_fc_local_=
port *lport,
>  	return 0;
>  }
> =20
> +static void ibmvfc_sync_nvme_completion(struct ibmvfc_event *evt)
> +{
> +	/* copy the response back */
> +	if (evt->sync_iu)
> +		*evt->sync_iu =3D *evt->xfer_iu;
> +
> +	complete(&evt->comp);
> +}
> +
> +static void ibmvfc_init_ls_abort(struct ibmvfc_event *evt, struct nvmefc=
_ls_req *ls_abort)
> +{
> +	struct ibmvfc_tmf *tmf;
> +	struct ibmvfc_event *abt_evt =3D ls_abort->private;
> +	struct ibmvfc_target *tgt =3D abt_evt->tgt;

[Severity: High]
Can abt_evt be freed concurrently if the original LS request receives a
hardware completion?

If a natural completion races with the abort timeout, ibmvfc_ls_req_done()
could free the event structure back to the active pool via
ibmvfc_free_event(). Does this blind dereference risk a use-after-free or
corrupting a newly allocated command?

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

[Severity: High]
Is this capability check logically inverted?

It appears to set the IBMVFC_TMF_SUPPRESS_ABTS flag only when the adapter
lacks support for it, which might cause the firmware to reject the abort
TMF MAD.

> +	tmf->cancel_key =3D cpu_to_be32((u64)abt_evt);
> +	tmf->my_cancel_key =3D cpu_to_be32((u64)evt);
> +	tmf->assoc_id =3D cpu_to_be64(tgt->assoc_id);
> +
> +	init_completion(&evt->comp);
> +}
> +
> +static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
> +				struct nvme_fc_remote_port *rport,
> +				struct nvmefc_ls_req *ls_abort)
> +{
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
Does this code leak the allocated event structure if the host is not
logged in?

If evt is successfully allocated from the fixed-size pool but
vhost->logged_in is false, returning here without calling
ibmvfc_free_event() would permanently lose the event. Repeated
occurrences could exhaust the pool.

> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	kref_get(&tgt->kref);
> +	ibmvfc_init_event(evt, ibmvfc_sync_nvme_completion, IBMVFC_MAD_FORMAT);
> +	ibmvfc_init_ls_abort(evt, ls_abort);
> +	evt->sync_iu =3D &rsp;
> +
> +	if (ibmvfc_send_event(evt, vhost, default_timeout))
> +		goto out;
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
Is the local variable status used uninitialized here?

If ibmvfc_send_event() fails, the code jumps to out, skipping the
assignment to status. The uninitialized stack value would then be
printed to the debug log.

> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D31
