Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDEC30DD1B
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783712226; cv=none; b=J3Uu887CLqVbJiLR/+fxWuyGS4irlsK5xcAumEEqVi2x++cq0ZODHaoI6f7VZpeaSdrmzK4FXSfLsiTVFihg3CX/F75zjgzb6jaWDl9C11AdEAkG5MCF0Lry72szR2JcywMIT3DnkTg0/UqDO5DS5DktRHcBAd8Slgc1vo7zYik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783712226; c=relaxed/simple;
	bh=A1a6SC4GK9b4c0IPFaWeBP9FEP6ShsIS/rTKNDeUZiU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cmedj4y0mO/MQGoioYT4hQZwRYK43WuZwknPV5qY+mp0YIOq+GFDuOpmnHJM4/56nCiyRduwu7zO6c/cyqB6Chccxic6ntj4BJ3flI9GVetkb3d7u8GKttTFLvXLlXpQe2NQ/hD2wl4qkX1C0RW0CVk+twP2buDZ44W5xt0slXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fS1KeBUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fS1KeBUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADCE1F000E9;
	Fri, 10 Jul 2026 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783712225;
	bh=AqgpxYH2Z0l+e3epqgddnz4FHb5hx4UDdjd5X5NKG58=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fS1KeBUQxNj0CnhWupQnY30GbUw5JVLiq6J5zJYgzuHqgSqVKs7i1yEFHgt0gjp09
	 g/P5YnAqBdasjNxpVxkL0oGZArmQajcVjqKEby1niSBmsN1YjMFQv6K30xYbSs2qOU
	 c9E/dO5wI/sxPZZT4R6/TuOEIaJGiW7FxYYhFfUGUPpBnAuUg3Iz6hj5jYaiqWTTVw
	 HKeK4FXu67oU8mc5NOsJaGD5nsne0HD5dz77/maAJp0llMvoUeIV5wBep+4EiLlT0M
	 VlpDtE5NlWTzOgPKkJhlVQEaZQ4yg6PBz5I18lyRtwVfiyJv3P/O6auF8P0ynCN23V
	 Df0ZDMjK10Etw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/8] ibmvfc: extend async event handlers to handle
 async sub queue events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710-ibmvfc-fpin-support-v4-6-ef031ac19520@linux.ibm.com>
References: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
 <20260710-ibmvfc-fpin-support-v4-6-ef031ac19520@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 19:37:04 +0000
Message-Id: <20260710193704.DADCE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The driver ignores the `IBMVFC_ASYNC_ID_IS_ASSOC_ID` flag when pro=
cessing sub-queue events, incorrectly interpreting association IDs as node =
names.
- [High] Hardcoded event type in `ibmvfc_full_fpin_to_desc()` drops FPIN co=
ngestion event classification.

Pre-existing issues:
- [High] Double-free and use-after-free of the FPIN workqueue due to incorr=
ect mixing of `devm_alloc_workqueue()` and manual lifecycle management.
--

--- Patch [6]: [PATCH v4 6/8] ibmvfc: extend async event handlers to handle=
 async sub queue events ---
commit f425472451b9ed0df3bb74b15fd60bb31167f05e
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: extend async event handlers to handle async sub queue events

Refactor async event handling to support both traditional async CRQs and
new asynchronous sub-queue CRQs.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 586847ff3336d..ee56f13f1a979 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -3349,6 +3349,27 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq =
*crq, u64 wwpn)
>  					  cpu_to_be32(1));
>  }
> =20
> +/**
> + * ibmvfc_full_fpin_to_desc(): allocate and populate a struct fc_els_fpi=
n struct
> + * containing a descriptor.
> + * @ibmvfc_fpin: Pointer to async subq FPIN data
> + *
> + * Allocate a struct fc_els_fpin containing a descriptor and populate
> + * based on data from *ibmvfc_fpin.
> + *
> + * Return:
> + * NULL     - unable to allocate structure
> + * non-NULL - pointer to populated struct fc_els_fpin
> + */
> +static struct fc_els_fpin *
> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
> +{
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin=
->wwpn,
> +					  cpu_to_be16(0), cpu_to_be16(0),
> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}

[Severity: High]
Is it intentional to hardcode the event type to cpu_to_be16(0) here?

Unlike ibmvfc_basic_fpin_to_desc() which maps the fpin_status to specific
types like FPIN_CONGN_DEVICE_SPEC, this appears to drop the FPIN congestion
event classification.

Could this prevent the FC transport layer from updating the storage
congestion statistics correctly?

[ ... ]

> @@ -3356,73 +3377,131 @@ static void ibmvfc_process_async_work(struct wor=
k_struct *work)

[ ... ]

> +	if (crq) {
> +		wwpn =3D crq->wwpn;
> +		node_name =3D crq->node_name;
> +		scsi_id =3D crq->scsi_id;
> +	} else {
> +		wwpn =3D subq->wwpn;
> +		node_name =3D subq->id.node_name;
> +		scsi_id =3D 0;
> +	}

[Severity: High]
Does this code need to check the IBMVFC_ASYNC_ID_IS_ASSOC_ID flag before
reading subq->id.node_name?

If the VIOS provides an association ID instead of a node name and sets the
flag in subq->flags, it seems the union would contain an assoc_id.

Could reading this unconditionally as a node_name cause target lookups to f=
ail
and silently drop events?

> =20
> -	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> -		goto end;
> +	if (!scsi_id && !wwpn && !node_name)
> +		goto free;
> =20
>  	spin_lock_irqsave(vhost->host->host_lock, flags);

[Severity: High]
This is a pre-existing issue, but is it safe to use this lock here during
driver removal?

If the vhost->fpin_workq was allocated with devm_alloc_workqueue(), it won't
be destroyed until devres runs after ibmvfc_remove() completes.

Since ibmvfc_remove() calls scsi_host_put(vhost->host), could an async FPIN
event executing concurrently access the freed host lock? Also, on probe
error paths, if destroy_workqueue() is called manually on a devm-managed
workqueue, could this lead to a double-free when devres cleans it up?

[ ... ]

> @@ -3460,18 +3539,18 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *c=
rq,

[ ... ]

> +	if (is_subq) {
> +		subq =3D crq;
> +		event =3D be16_to_cpu(subq->event);
> +		link_state =3D subq->link_state;
> +		scsi_id =3D 0;
> +		wwpn =3D subq->wwpn;
> +		node_name =3D subq->id.node_name;

[Severity: High]
Similarly, does ibmvfc_handle_async() need to verify the
IBMVFC_ASYNC_ID_IS_ASSOC_ID flag before extracting the node_name?

If the subq->id union contains an association ID instead of a WWNN, could
this result in failed target lookups for ELS_LOGO, PRLO, and PLOGI events?

> +	} else {
> +		async_crq =3D crq;
> +		event =3D be64_to_cpu(async_crq->event);
> +		link_state =3D async_crq->link_state;
> +		scsi_id =3D async_crq->scsi_id;
> +		wwpn =3D async_crq->wwpn;
> +		node_name =3D async_crq->node_name;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-ibmvfc-fpi=
n-support-v4-0-ef031ac19520@linux.ibm.com?part=3D6
