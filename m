Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAFE322B6D
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094431; cv=none; b=Vr6t3QluJTjXHRH0F0V/KqL/R+6LyCpNEnq9ZbGpJMwBA9b8G5MldcmeRRhs1lyINTVmxEmSB6WzC+bTlXr3cOCCf4i0eKJWLGE8sNp2DG+8opKqyo8N151zXMxxMTFZ9VEzCVabdzN1lqMxRT4/kmbxYhwoxj9GciJ5M6++7ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094431; c=relaxed/simple;
	bh=32jbBppu2fVU7XmUQkc7Zr6IX3ZeGpQdutHq+x6vKw8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jUmB4mQ+cHFjR3CMwatFxUrUS2m1Y/ChzH7Rdj3C2B10WPyV1ngI270aZt2B9lpSkzoJUmnj1fjcNWofMPM6CgBwvipPc4idUIFq8mO43/+e55z1I6sjMSeJdLlq9vFPchucUr84UVq47ty47znz5Mxs7e+UncwvREFDv8VE5Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvMhYBvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvMhYBvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE271F000FF;
	Fri, 11 Sep 2026 02:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094430;
	bh=ZScrajSt5aneUBgu0HubfKw5MMNpzUTFWvk/Sy3IImk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jvMhYBvEGrup4VFdqxRCxGUe/h8KkbsvsO6UMYTcK55c9t9EJQewnHa1NdTVAYO8x
	 CWUYtcgvWjicLGiBzqLn1cv+SYtt03iy+uFit92GzcGTNSkAJCChyYc7oUl60vvxFl
	 SWh3AdPWx+H/dUHxmToA/21KH0DCzHN32k9HY3oVeuKcvR+pOIWDyown8oqXSFpEtI
	 K918I3sWKJHKWIzMy/D6ZjQ+ahNr4o0K2eHrEeAa8fz9hfMBJLTRcanpcneEl+T6o5
	 oehnDe7r0IVRFDaH6eNk6XZbHyYgvfhv55F7qE0Uof825XtgYsdbKTh0G/TG50STBU
	 1gFpfitr5XsXg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 4/9] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020817.1033789-4-tyreld@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260911020817.1033789-4-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:40:29 +0000
Message-Id: <20260911024030.2AE271F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] ibmvfc_full_fpin_to_desc() incorrectly relies on the CRQ event's=
 WWPN rather than the resolved target's WWPN, risking zero-initialized FPIN=
 descriptors.

Pre-existing issues:
- [High] ibmvfc_find_target() will always return NULL due to a faulty logic=
al OR condition checking for both rport and nvme_remote_port.
--

commit 944a7c8d64284dbbdeb6a30246074960364f88e5
Author: Dave Marquardt <davemarq@linux.ibm.com>
scsi: ibmvfc: extend async event handlers for async sub-CRQ events

This commit refactors async event handling to support both traditional
async CRQs and new asynchronous sub-queue CRQs using a tagged union.
It also adds functionality to convert full FPIN messages from async
sub-queue formats into fc_els_fpin structures.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 6b2eb82ceb98d..daec81f48857d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3426,6 +3426,45 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq =
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
> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin)
> +{
> +	__be16 type;
> +
> +	switch (ibmvfc_fpin->fpin_status) {
> +	case IBMVFC_AE_FPIN_LINK_CONGESTED:
> +	case IBMVFC_AE_FPIN_PORT_CONGESTED:
> +		type =3D cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_CLEARED:
> +	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
> +		type =3D cpu_to_be16(FPIN_CONGN_CLEAR);
> +		break;
> +	case IBMVFC_AE_FPIN_PORT_DEGRADED:
> +		type =3D cpu_to_be16(FPIN_LI_UNKNOWN);
> +		break;
> +	default:
> +		return NULL;
> +	}
> +
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin=
->wwpn,
> +					  type, cpu_to_be16(0),

[Severity: Medium]
Does this code risk generating FPIN descriptors with a zero-initialized
attached_wwpn if the VIOS asynchronous sub-CRQ event lacks a populated WWPN?

The legacy path (ibmvfc_basic_fpin_to_desc) explicitly accepts and uses the
resolved target's WWPN, whereas this new function relies strictly on the CRQ
payload (ibmvfc_fpin->wwpn). If targets are resolved primarily via node_name
and the event payload's WWPN is zeroed, will we substitute an empty WWPN in=
to
the FPIN descriptor instead of using the known target WWPN?

> +					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
> +					  cpu_to_be32(1));
> +}
> +
>  /**
>   * ibmvfc_find_target - Search for a target in a target list
>   * @target_list: list head of targets to search
[ ... ]
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
>  	if (!tgt) {
>  		/* Target not found in scsi_scrqs, search nvme_scrqs */
> -		tgt =3D ibmvfc_find_target(&vhost->nvme_scrqs.targets,
> -					 crq->scsi_id, crq->wwpn,
> -					 crq->node_name);
> +		tgt =3D ibmvfc_find_target(&vhost->nvme_scrqs.targets, scsi_id, wwpn, =
node_name);
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but its presence completely brea=
ks
the FPIN functionality being extended here.

The ibmvfc_find_target() function drops all valid targets because it checks:

    if (!tgt->rport || !tgt->nvme_remote_port)
        continue;

Since FCP and NVMe targets are kept in completely separate lists (scsi_scrqs
vs nvme_scrqs), no target will ever have both an rport and an nvme_remote_p=
ort
simultaneously. Will this unconditionally return NULL for every async event
and fail with "Invalid target for FPIN", dropping the notifications?

> =20
>  	if (tgt) {
> @@ -3496,7 +3546,11 @@ static void ibmvfc_process_async_work(struct work_=
struct *work)
>  		goto free;
>  	}
> =20
> -	fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +	if (crq)
> +		fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +	else
> +		fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +
>  	if (fpin) {
>  		fc_host_fpin_rcv(tgt->vhost->host,
>  				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D4
