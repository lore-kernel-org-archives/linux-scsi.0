Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5872035B653
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016043; cv=none; b=K52wnmjp2ZNqplSgKAaAGL+mwXryWocHJONkeAb6t3gC6Zb9oRB5sHhS9oVxP5LuuifQnIKM6GDSEmLD9gxNVPP5uLkDm/H8wzpzsV/VHjE0aGeDNQWU5SQfVGktHGPt21Rnc8wDzLME2CLj6d+07gbQUVqRmqLo95lZviem6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016043; c=relaxed/simple;
	bh=pvLCpz+dDomQwOPQO2i2wt+idJSzmtia2VEC1TbrXbc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nQIDoFKwQvwzRLtE1EME78Czq7wdhVei7m99MLxtoNLGC5TsS4ZIdP/CBGHNbUWOvAHPuhZySQvDCiYvFTL1LDce44z2qBx7N8ASoD+9lqwS4DSiLSjnOAicMLLacFXofdcMyZEwjTmHUM4rvMbyJKkmAaHNybVOEcRVGC+PAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBeFoubD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBeFoubD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D874A1F000E9;
	Thu,  2 Jul 2026 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783016041;
	bh=8wO9OelhFRWIV7tGPYv/eNnOygzYlnSFT5PYNb+j3A8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WBeFoubDIphFn5/3sUF6TdTGy+L377di/rqOFGll1cNf1P4Jj8Se2uRDXpA2kj9wO
	 eYAo57GwlZELXfjZ6+umD6BI+3CFF26Q42sPsqZz1GB/MSIRyuFflTuMPK5QAckph9
	 LezGJwo8CPQEiK3KUMPxGdLZzAqLUC5vXJJ9m4x0VCozia+IslGEXRIyKTvLvvk6Q6
	 ThpPe4fdMSiPIeDFKLIfjkUyfn7vzLKXStmXzWfrZLirZlLzVD49UjsT2TRur+VOXa
	 HQghc1XCbF0nNZyLvUDKeI8ksx8dGvWE9K2Nk34QSMkH2YXdMhMKKBD7jfcJRISHWZ
	 5GEItQd7mywtQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6/8] ibmvfc: extend async event handlers to handle
 async sub queue events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-6-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
 <20260702-ibmvfc-fpin-support-v3-6-d95b9547cf88@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:14:00 +0000
Message-Id: <20260702181400.D874A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] Out-of-bounds Read and Type Confusion due to missing loop exit=
 check.
- [High] Use-after-free race condition due to unlocked access without refer=
ence counting.
- [Medium] Unconditional read of `subq->id.node_name` without validating th=
e `IBMVFC_ASYNC_ID_IS_ASSOC_ID` flag.
- [Low] Dead code due to impossible null check `(!crq && !subq)`.

Pre-existing issues:
- [High] Missing read-before-write memory barrier when yielding asynchronou=
s queue descriptors.
--

commit a60f2aaa0542637dd0e4a584dadf2c01fa2e0409
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: extend async event handlers to handle async sub queue events

This patch extends the ibmvfc driver to process asynchronous sub-queue CRQs=
=20
alongside the existing async CRQs. It modifies ibmvfc_handle_async and=20
ibmvfc_process_async_work to handle the new sub-queue event structures.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 804887fb56357..4678d76c84fe2 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
[ ... ]
> @@ -3356,26 +3377,51 @@ static void ibmvfc_process_async_work(struct work=
_struct *work)
>  {
[ ... ]
>  	aw =3D container_of(work, struct ibmvfc_async_work, async_work_s);
>  	vhost =3D aw->vhost;
> +	is_subq =3D aw->is_subq;
> +	if (is_subq)
> +		subq =3D &aw->crq.subq;
> +	else
> +		crq =3D &aw->crq.async_crq;
> =20
> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +	if (!crq && !subq) {

[Severity: Low]
Is this null check reachable? Since crq and subq are assigned the addresses
of fields inside the aw struct, it appears they can never evaluate to NULL,
making this check and the following error branch dead code.

> +		dev_err_ratelimited(vhost->dev,
> +				    "FPIN event received, unable to process\n");
> +		goto end;
> +	}
> +
> +	if (crq) {
> +		wwpn =3D crq->wwpn;
> +		node_name =3D crq->node_name;
> +		scsi_id =3D crq->scsi_id;
> +	} else {
> +		wwpn =3D subq->wwpn;
> +		node_name =3D subq->id.node_name;

[Severity: Medium]
Does this code safely read the node_name field?=20

The id field is a union of node_name and assoc_id. If the firmware sets the=
=20
IBMVFC_ASYNC_ID_IS_ASSOC_ID flag on this sub-queue event, wouldn't this=20
unconditional read of node_name result in comparing an association ID again=
st=20
tgt->ids.node_name later on, potentially causing valid events to be discard=
ed?

> +		scsi_id =3D 0;
> +	}
> +
> +	if (!scsi_id && !wwpn && !node_name)
>  		goto end;
> =20
>  	spin_lock_irqsave(vhost->host->host_lock, flags);
>  	list_for_each_entry_safe(tgt, next, &vhost->targets, queue) {
> -		if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) !=3D crq->scsi_id)
> +		if (scsi_id && cpu_to_be64(tgt->scsi_id) !=3D scsi_id)
>  			continue;
> -		if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) !=3D crq->wwpn)
> +		if (wwpn && cpu_to_be64(tgt->ids.port_name) !=3D wwpn)
>  			continue;
> -		if (crq->node_name && cpu_to_be64(tgt->ids.node_name) !=3D crq->node_n=
ame)
> +		if (node_name && cpu_to_be64(tgt->ids.node_name) !=3D node_name)
>  			continue;
>  		if (!tgt->rport)
>  			continue;
> @@ -3388,41 +3434,71 @@ static void ibmvfc_process_async_work(struct work=
_struct *work)
>  		goto end;
>  	}

[Severity: Critical]
If the list iteration finishes without finding a match, doesn't tgt end up
pointing to the list head (&vhost->targets) rather than a valid target?=20

If so, the subsequent check if (!tgt || !tgt->rport) operates on this
invalid pointer. Since rport happens to be at an offset that might overlap
with valid data in the host struct, could this bypass the safety check
and lead to memory corruption when accessing tgt->wwpn or tgt->vhost->host=
=20
when creating the FPIN descriptor?

> -	fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);

[Severity: High]
Is it safe to drop the vhost->host->host_lock here without first acquiring
a reference to tgt via kref_get(&tgt->kref)?=20

Could a concurrent thread processing a logout execute ibmvfc_del_tgt and fr=
ee=20
the target memory before this async work thread finishes accessing tgt->wwp=
n=20
and tgt->vhost->host?

[ ... ]
> @@ -3388,41 +3434,71 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *c=
rq,
> +	if (is_subq) {
> +		subq =3D crq;
> +		event =3D be16_to_cpu(subq->event);
> +		link_state =3D subq->link_state;
> +		scsi_id =3D 0;
> +		wwpn =3D subq->wwpn;
> +		node_name =3D subq->id.node_name;

[Severity: Medium]
Similar to the question above in ibmvfc_process_async_work, is it safe to=20
read node_name here without first verifying the IBMVFC_ASYNC_ID_IS_ASSOC_ID=
=20
flag in subq->flags?

[ ... ]
> @@ -3492,16 +3568,26 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *c=
rq,
>  	default:
> -		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event=
);
> +		dev_err(vhost->dev, "Unknown async event received: %llu\n", event);
>  		break;
>  	}
> +
> +	if (is_subq)
> +		subq->valid =3D 0;
> +	else
> +		async_crq->valid =3D 0;
> +	wmb();

[Severity: High]
This is a pre-existing issue, but does this code need a full memory barrier
before clearing the valid bit?=20

The driver reads the DMA-mapped payload earlier in ibmvfc_handle_async, and=
=20
setting valid =3D 0 yields the slot back to the hardware. On architectures =
like=20
PowerPC, without a read-before-write mb() before the valid assignment, coul=
d=20
the CPU reorder the write before the payload reads, allowing hardware to=20
overwrite the event data while the driver is still processing it?

>  }
>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-ibmvfc-fpi=
n-support-v3-0-d95b9547cf88@linux.ibm.com?part=3D6
