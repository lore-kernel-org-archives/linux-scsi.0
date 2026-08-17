Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32263B585F
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999347; cv=none; b=bpUtC5KIddJKsYG+WLUYZ1D4y1Kd3fsUwwnJNqSgppoxZRbcNcBYUypsiCKSwnNBBYHln1rqAIO2xHyJ5y5+8mUufDFy1BY9mQn9ey39KagmKpGilcSoJis9lvF2g7rDV3ig62aEiYXIVTuxn7ycKTWQBBZzeC+puxXoaeNT0/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999347; c=relaxed/simple;
	bh=gSapsY8XgJ3AuH3EsKYnzmbF0LUksKmGODgNav1Povw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AjA1x1UQAHAbIcc5PmgifInla77/0uacgegK0LOkUM9pq7c0EyL9bk59kF0Ko8O8iXEhQmPFpATl9rS3aWHwGe7cZ+ukcx+n+bAeWmiEeqNNso0QDCw4P9zNiJyB0dmG3L6LBca1VqOYMMdIKEXaFGXu810UqdyWocimhqnzpbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDZPIQ8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDZPIQ8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820DC1F000E9;
	Mon, 17 Aug 2026 20:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999345;
	bh=aKexuA/thO8nqesMOQmT6XgNuiLrLv4ntqWtRIHuIVY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XDZPIQ8C5EEscrR6UFkREHuB2qWo5e2HEpwd5lzayW8U7pwPKjMFZEvfDWQ0KR0AH
	 YUT5W2T2PBQkXjVfr6tf9ffAUBkNHZigg6Xl+aPKaD4RXy3ZBf91SyP2LWJt3lMWiR
	 1He+KJaNyjzec+3w3/cs1dYcacAIaTfehEaqxTMW41FG44aCa0wHbh8uIvvBd1upHe
	 GJnHnxk5SZNZ5esRYCWNQqNkZWbFBSbJ3Dvr3/Z2hQlIpVMYEJCX48jgUMliV5HSSM
	 Ud+X70Fh5WxBDlds/UoyCPbBNgLy6Tdiyl+25C0G5uAkU2NeMME8Zbc7uTBx++4Gsi
	 JJfv4lfft/q2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 4/8] scsi: ibmvfc: extend async event handlers to
 handle async sub queue events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-4-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-4-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:42:25 +0000
Message-Id: <20260817204225.820DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Double clear of `valid` in the CRQ ring buffer introduces a race c=
ondition that can clobber subsequent hardware events.
- [High] Missing check for `IBMVFC_ASYNC_ID_IS_ASSOC_ID` causes `assoc_id` =
to be incorrectly treated as a WWNN, preventing target lookup and dropping =
events.
- [Medium] KUnit tests use `msleep()` to wait for asynchronous workqueue ex=
ecution, leading to flaky test failures.
- [Low] Dereferencing a `void *` pointer in the unmodified `nvme_scrqs` loo=
p inside `ibmvfc_handle_async` causes a compilation error.
--

--- Patch [4]: [PATCH v6 4/8] scsi: ibmvfc: extend async event handlers to =
handle async sub queue events ---
commit d29a42191b6208bc62350b9d0fda8394443adcd4
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend async event handlers to handle async sub queue events

Refactor async event handling to support both traditional async CRQs and
new asynchronous sub-queue CRQs.

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 19a3f12615648..4d1630d2ab1b5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -3462,28 +3501,41 @@ static struct ibmvfc_target *ibmvfc_find_target(s=
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
> +	bool is_subq;
> +	__be64 wwpn;
> =20
>  	aw =3D container_of_const(work, struct ibmvfc_async_work, async_work_s);
>  	vhost =3D aw->vhost;
> -	crq =3D &aw->crq;
> +	is_subq =3D aw->is_subq;
> +	if (is_subq) {
> +		subq =3D &aw->crq.subq;
> +		scsi_id =3D 0;
> +		wwpn =3D subq->wwpn;
> +		node_name =3D subq->id.node_name;

[Severity: High]
Does this incorrectly treat assoc_id as a WWNN? It looks like we should
check the IBMVFC_ASYNC_ID_IS_ASSOC_ID flag before unconditionally reading
node_name, as this could prevent target lookups and cause FPIN events
to be dropped.

[ ... ]

> @@ -3511,25 +3567,52 @@ static void ibmvfc_process_async_work(struct work=
_struct *work)
> =20
>  /**
>   * ibmvfc_handle_async - Handle an async event from the adapter
> - * @crq:	crq to process
> + * @crq:	ibmvfc_async_crq or ibmvfc_async_sub_crq
>   * @vhost:	ibmvfc host struct
> + * @is_sub_crq:	indicates whether the crq points to a struct ibmvfc_asyn=
c_sub_crq
>   *
>   **/
> -VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
> -					  struct ibmvfc_host *vhost)
> +VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *crq,
> +					  struct ibmvfc_host *vhost,
> +					  bool is_sub_crq)
>  {

[Severity: Low]
Will this cause a compilation error? The crq parameter type is changed to a
void pointer here, but there is still an unmodified nvme_scrqs loop later in
ibmvfc_handle_async() that directly dereferences it like crq->scsi_id.

> -	const struct ibmvfc_async_desc *desc =3D ibmvfc_get_ae_desc(be64_to_cpu=
(crq->event));
> +	struct ibmvfc_async_crq *async_crq =3D NULL;
> +	struct ibmvfc_async_sub_crq *subq =3D NULL;
>  	const struct ibmvfc_async_desc *desc;
>  	struct ibmvfc_async_work *aw;
>  	struct ibmvfc_target *tgt;
> -
> -	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, w=
wpn: %llx,"
> -		   " node_name: %llx%s\n", desc->desc, be64_to_cpu(crq->scsi_id),
> -		   be64_to_cpu(crq->wwpn), be64_to_cpu(crq->node_name),
> -		   ibmvfc_get_link_state(crq->link_state));
> -
> -	switch (be64_to_cpu(crq->event)) {
> +	__be64 node_name;
> +	__be64 scsi_id;
> +	u8 link_state;
> +	__be64 wwpn;
> +	u64 event;
> +
> +	if (is_sub_crq) {
> +		subq =3D crq;
> +		event =3D be16_to_cpu(subq->event);
> +		link_state =3D subq->link_state;
> +		scsi_id =3D 0;
> +		wwpn =3D subq->wwpn;
> +		node_name =3D subq->id.node_name;

[Severity: High]
Is it possible to receive an assoc_id here instead of a node_name?
Missing the check for IBMVFC_ASYNC_ID_IS_ASSOC_ID could result in mismatches
during target lookup.

[ ... ]

> @@ -3615,16 +3698,27 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct =
ibmvfc_async_crq *crq,
>  		if (aw) {
>  			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
>  			aw->vhost =3D vhost;
> -			aw->crq =3D *crq;
> +			aw->is_subq =3D is_sub_crq;
> +			if (is_sub_crq)
> +				aw->crq.subq =3D *subq;
> +			else
> +				aw->crq.async_crq =3D *async_crq;
>  			queue_work(vhost->fpin_workq, &aw->async_work_s);
>  		} else
>  			dev_err_ratelimited(vhost->dev,
>  					    "can't offload async CRQ to work queue\n");
>  		break;
>  	default:
> -		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event=
);
> +		dev_err(vhost->dev, "Unknown async event received: %llu\n", event);
>  		break;
>  	}
> +
> +	rmb();
> +	if (is_sub_crq)
> +		subq->valid =3D 0;
> +	else
> +		async_crq->valid =3D 0;
> +	wmb();
>  }

[Severity: High]
Can clearing the valid byte here lead to silently dropped events?

Since ibmvfc_handle_async() clears the valid byte to 0, it tells the hardwa=
re
the slot can be reused.

In the caller ibmvfc_tasklet():

	while ((async =3D ibmvfc_next_async_crq(vhost)) !=3D NULL) {
		ibmvfc_handle_async(async, vhost, false);
		async->valid =3D 0;
		wmb();
	}

If the hardware writes a new event into this slot between the first clear in
ibmvfc_handle_async() and the redundant clear in ibmvfc_tasklet(), wouldn't
the second clear overwrite the new event's valid byte and lose it?

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 64a517a74af8e..0b29c1e6478b5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -58,7 +58,7 @@ static void ibmvfc_async_fpin_test(struct kunit *test)
>  		crq[fs].scsi_id =3D cpu_to_be64(tgt->scsi_id);
>  		crq[fs].wwpn =3D cpu_to_be64(tgt->wwpn);
>  		crq[fs].node_name =3D cpu_to_be64(tgt->ids.node_name);
> -		ibmvfc_handle_async(&crq[fs], vhost);
> +		ibmvfc_handle_async(&crq[fs], vhost, false);
>  		msleep(1U);
>  	}

[Severity: Medium]
Will this lead to flaky tests on heavily loaded systems?

Using msleep(1U) to wait for asynchronous workqueue execution might not give
the workqueue enough time to run. Could we use flush_workqueue() instead?

[ ... ]

> @@ -93,7 +93,110 @@ static void ibmvfc_async_fpin_test(struct kunit *test)
>  	crq[0].scsi_id =3D cpu_to_be64(tgt->scsi_id);
>  	crq[0].wwpn =3D cpu_to_be64(tgt->wwpn);
>  	crq[0].node_name =3D cpu_to_be64(tgt->ids.node_name);
> -	ibmvfc_handle_async(&crq[0], vhost);
> +	ibmvfc_handle_async(&crq[0], vhost, false);
> +	msleep(1U);

[Severity: Medium]
Should we avoid using msleep(1U) here for synchronizing with the workqueue?

If the workqueue doesn't run within 1 millisecond, the assertions that foll=
ow
could fail.

[ ... ]

> +	/* bad path */
> +	crq[0].valid =3D 0x80;
> +	crq[0].link_state =3D IBMVFC_AE_LS_LINK_UP;
> +	crq[0].fpin_status =3D 0; /* bad value */
> +	crq[0].event =3D cpu_to_be16(IBMVFC_AE_FPIN);
> +	crq[0].wwpn =3D cpu_to_be64(tgt->wwpn);
> +	crq[0].id.node_name =3D cpu_to_be64(tgt->ids.node_name);
> +	ibmvfc_handle_async(&crq[0], vhost, true);
>  	msleep(1U);

[Severity: Medium]
Same concern here about using msleep(1U) to wait for the workqueue.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D4
