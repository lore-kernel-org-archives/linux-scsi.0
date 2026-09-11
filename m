Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38A335BDDB
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094346; cv=none; b=gR+2ej7UP9Hi1FFkB6yGjYAb+o9qND6+lvbaAf7uxJURLcjMav7eQaGmUbDsvyO/NbhfWvZDoSu9mCrX+yK1HObhGc7WMs1swkA+N3S/PIZKwai5CWvViAfw7yOcp55ywPJ2TJYYogiZocUipk3jq4wHytjERa2ZejXL8avq/MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094346; c=relaxed/simple;
	bh=ZdUALVFojqTkiiBFs5QZXGBV2OIGWdRPR9miqvOFq2g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q5pcwoagA1i4gsfIPc5BAIUaN8+RCErpG4Ve36VbIav8b1YhJwItl7PEzVQga7Q/mlC1t8YIEL0WCU/kOxt6m0gvb+QK8dDOPsBTB5wSz3fZMyhlGtcnK41ZSCH0tLEW0IHxg1fTPV8l2jopfU/FszNxIgopsxa3KpticNgB45w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gH+wB4/z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gH+wB4/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1FE1F000FF;
	Fri, 11 Sep 2026 02:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094344;
	bh=kjKVx0jbbHwfsItm/Zhda6Y63ZQXucFRuktWM77GhDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gH+wB4/zhV9wc7CsBRu6dQhDeNKV2vJ+DA1fKEJl+pqJZWlQcph3tQHiOXyMkCNLl
	 dJ3qHateGIW42xCZj5aDyKDU/O7J0jEhbbBUkpwwh+kw0nz0o6uSpAKHOEUwsOVmkP
	 TzsAfwoTuZZN3ur/GF92QsGnB6Uq7kUGwuM10Mc+lDEqbpSQ0JdqqBpHlhP2dH6r8q
	 rrVRBC/obZJA1b/nsHgqXL74fBn8aDJfO49/A/jDkFKXebpbRu0P4opVarDq3CA5X5
	 IZ+TdhaWpl2FZezLdo3pY4/hFiMo9xjJUGf16mtKceAvTDvh0xMvQS+85UfgdWAJXo
	 5uoAFJAOPzSZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 4/9] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911021910.1038128-5-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-5-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:39:04 +0000
Message-Id: <20260911023904.6A1FE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] ibmvfc_find_target() incorrectly skips targets unless they support=
 BOTH SCSI and NVMe, causing FPIN events to be dropped.
- [Medium] Missing scsi_id extraction for async sub-CRQ events.
- [Medium] Incorrect WWPN populated in FPIN descriptor for async sub-CRQ ev=
ents when subq->wwpn is 0.
- [Low] Missing address-of operator '&' when passing host_lock to spin_lock=
_irqsave() and spin_unlock_irqrestore(), causing a build failure.
--

commit 997e4bca2edfad65478e2c572b7c236ba500e1bb
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend async event handlers for async sub-CRQ events

This patch refactors async event handling to support both traditional async
CRQs and new asynchronous sub-queue CRQs using a tagged union. It also
updates FPIN processing logic to extract identifiers from the appropriate
event type.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 6b2eb82ceb98d..daec81f48857d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3426,6 +3426,45 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq =
*crq, u64 wwpn)
> +static struct fc_els_fpin *
> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin)
> +{
> +	__be16 type;
[ ... ]
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin=
->wwpn,
> +					  type, cpu_to_be16(0),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}

[Severity: Medium]
If the async sub-CRQ event arrives with a WWPN of 0 but the target is
successfully matched via node_name, will this embed a WWPN of 0 into the
FPIN descriptor?

It looks like fc_host_fpin_rcv() would then fail to find the remote port by
WWPN, silently dropping the FPIN and missing statistics updates. Would it be
safer to pass in the matched tgt->wwpn here, similar to how it's done for
standard CRQs?

>  /**
>   * ibmvfc_find_target - Search for a target in a target list
>   * @target_list: list head of targets to search
> @@ -3463,28 +3502,39 @@ static struct ibmvfc_target *ibmvfc_find_target(s=
truct list_head *target_list,
>   */
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {
> +	struct ibmvfc_async_sub_crq *subq =3D NULL;
>  	struct ibmvfc_async_work *aw;
> -	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_async_crq *crq =3D NULL;
>  	struct ibmvfc_target *tgt;
>  	struct ibmvfc_host *vhost;
> -	struct fc_els_fpin *fpin;
> +	struct fc_els_fpin *fpin =3D NULL;
>  	unsigned long flags;
> +	__be64 node_name;
> +	__be64 scsi_id;
> +	__be64 wwpn;
> =20
>  	aw =3D container_of_const(work, struct ibmvfc_async_work, async_work_s);
>  	vhost =3D aw->vhost;
> -	crq =3D &aw->crq;
> +	if (aw->event.type =3D=3D IBMVFC_ASYNC_CRQ_SUB) {
> +		subq =3D &aw->event.subq;
> +		scsi_id =3D 0;

[Severity: Medium]
The commit message states we "extract WWPN, node_name, and scsi_id from the
appropriate union member based on event type."

However, for async sub-CRQ events here and in ibmvfc_handle_async(), scsi_id
is hardcoded to 0 instead of extracting nport_id from the payload. Could th=
is
cause target lookup failures if WWPN and node_name happen to be 0?

> +		wwpn =3D subq->wwpn;
> +		node_name =3D (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) ? 0 : subq->=
id.node_name;
> +	} else {
> +		crq =3D &aw->event.async_crq;
> +		scsi_id =3D crq->scsi_id;
> +		wwpn =3D crq->wwpn;
> +		node_name =3D crq->node_name;
> +	}
> =20
> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +	if (!scsi_id && !wwpn && !node_name)
>  		goto free;
> =20
>  	spin_lock_irqsave(vhost->host->host_lock, flags);
> -	tgt =3D ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
> -				 crq->wwpn, crq->node_name);
> +	tgt =3D ibmvfc_find_target(&vhost->scsi_scrqs.targets, scsi_id, wwpn, n=
ode_name);

[Severity: High]
Does ibmvfc_find_target() incorrectly skip targets unless they support BOTH
SCSI and NVMe?

Looking at the implementation of ibmvfc_find_target():

    if (!tgt->rport || !tgt->nvme_remote_port)
        continue;

Because a target represents a single endpoint for a specific protocol (SCSI=
 or
NVMe), it will only ever have either tgt->rport or tgt->nvme_remote_port,
never both.

Because of the logical OR, this condition always evaluates to true. Could t=
his
effectively break FPIN event handling by causing every target to be skipped?

[ ... ]
> @@ -3512,25 +3566,51 @@ static void ibmvfc_process_async_work(struct work=
_struct *work)
> =20
>  /**
>   * ibmvfc_handle_async - Handle an async event from the adapter
[ ... ]
>  	if (ae->type =3D=3D IBMVFC_ASYNC_CRQ_SUB) {
> -	switch (be64_to_cpu(crq->event)) {
> +		subq =3D &ae->subq;
> +		event =3D be16_to_cpu(subq->event);
> +		link_state =3D subq->link_state;
> +		scsi_id =3D 0;

[Severity: Medium]
Similarly, this hardcodes scsi_id to 0 for async sub-CRQ events instead of
extracting it from the event payload.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021910.1038=
128-1-tyreld@linux.ibm.com?part=3D4
