Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F3F473C67
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030371; cv=none; b=sHk5/n/ThExf/GzgUjO/a5xfy9tTMt9nv0S7s+bNR0KTtrZnSJeAjQCo0UTsSiO5NOjK8GhbSIo3oJuzjlNktPCCrk3ARk7ZFxJZOM18Axtg8Zvnw93IvrTAylf6vWDMov4iRUfnsEEeLIncS75AISqoulDDiYiXJ8VgwadZNxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030371; c=relaxed/simple;
	bh=40hYE78lcMYS7x+azSYVzoWpJ6I4RXeLj+9eS29sjF4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ph7rLCUTMDr5hYe5uYehNdnTcK6jc8CoqlH6O+8vaAoVvom9GUTzXu9c8na1XT3AWPSJm0+fg5uUMstLFFWMo+GJfFniW7CL1I5tc2QguScn+2F8Q40fCwpEcJvXyaOniW7VzphHPMgbdlUmFDVFxD7wgUdoTyN3NiVZYJS29HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWUG0Gpw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWUG0Gpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758641F000E9;
	Thu,  6 Aug 2026 15:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786030369;
	bh=+zbCpS6xiMIUjPu5GX/zfwSC8H9gAGfToqPl12rXxkk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FWUG0GpwXx1Q1mkgd03EALWJCa0xVXm4XnofiCi/TME3k16NHYhOc+pSbblCOFOC1
	 3Ey712p9RppjpKVFGRWosD4BIzIdiAKmSWvr6bp5iE5NSb60QtI3x8LCWUjufbvO69
	 fXAilGCvQ82sIM0CyhQNvNpE19BghDgKEzVIbODFG04/Bp0ooaf8fgrIysGmeDeXVU
	 BR/DkWCCDPwMB1coYRLBgYjoz86NVQjt/yUaZ1fwEeMY46ZTZJrwWadVtCvJOgH1FQ
	 v9d/gLRwiXFRKNJWyY52mKJspywOSn37jrQX7Li575tUq1rt42lAzrT7e+MCX8Pqef
	 w1sGKtmN36r0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/7] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-1-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
 <20260806-ibmvfc-fpin-support-v5-1-13fd6f8a8f8b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:32:49 +0000
Message-Id: <20260806153249.758641F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Out-of-bounds read and `kref` corruption when evaluating `!tgt=
->rport` on the list head.
- [High] Double-free on devm-managed workqueue during probe error path.
- [High] Use-after-free of `vhost` on device removal due to delayed devres =
workqueue flush.
- [Medium] KUnit test relies on `msleep(1U)` for workqueue synchronization,=
 leading to flaky test failures.
--

--- Patch [1]: [PATCH v5 1/7] scsi: ibmvfc: add basic FPIN support ---
commit 4d09e7f6a4d0d71dfbc3b5f16409ed908239bf5d
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index dfa231b6cc478..2829f4e4b5636 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3261,16 +3265,249 @@ static const char *ibmvfc_get_link_state(enum ib=
mvfc_ae_link_state state)
> +static void ibmvfc_process_async_work(struct work_struct *work)
> +{
> +	struct ibmvfc_async_work *aw;
> +	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_els_fpin *fpin;
> +	unsigned long flags;
> +
> +	aw =3D container_of_const(work, struct ibmvfc_async_work, async_work_s);
> +	vhost =3D aw->vhost;
> +	crq =3D &aw->crq;
> +
> +	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +		goto free;
> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
> +		if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) !=3D crq->scsi_id)
> +			continue;
> +		if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) !=3D crq->wwpn)
> +			continue;
> +		if (crq->node_name && cpu_to_be64(tgt->ids.node_name) !=3D crq->node_n=
ame)
> +			continue;
> +		if (!tgt->rport)
> +			continue;
> +		break;
> +	}
> +
> +	if (!list_entry_is_head(tgt, &vhost->scsi_scrqs.targets, queue) ||
> +	    !tgt->rport) {
> +		kref_get(&tgt->kref);

[Severity: Critical]
Does this logic perform an out-of-bounds read if the target isn't found?

If the loop finishes without finding a match, tgt will point to the list
head. The check evaluates !list_entry_is_head(tgt, ...), which is false,
so it falls through to the OR condition and evaluates !tgt->rport.

Since tgt is the list head, this reads past the bounds of the list_head
structure. If that garbage memory evaluates to NULL, it could proceed to
corrupt memory via kref_get(&tgt->kref). Should this use && instead of ||
to ensure it only checks tgt->rport on valid entries?

[ ... ]
> @@ -6874,9 +7123,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
t struct vio_device_id *id)
>  	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
>  	mutex_init(&vhost->passthru_mutex);
> =20
> -	if ((rc =3D ibmvfc_alloc_mem(vhost)))
> +	vhost->fpin_workq =3D devm_alloc_workqueue(vhost->dev, "%s-fpin-workq-%=
u", 0, 0,
> +						 IBMVFC_NAME, shost->host_no);

[Severity: High]
Can this devm-managed workqueue cause a use-after-free on module removal?

During device removal, if the driver tears down and calls
scsi_host_put(vhost->host), the vhost structure is freed. Since the devres
cleanup runs after the device remove function returns, the workqueue is
flushed and destroyed after vhost is already gone.

If there is pending work in the queue, ibmvfc_process_async_work() might
execute and dereference the freed vhost.

[ ... ]
>  	vhost->work_thread =3D kthread_run(ibmvfc_work, vhost, "%s_%d", IBMVFC_=
NAME,
>  					 shost->host_no);
> =20
> @@ -6922,6 +7177,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  	kthread_stop(vhost->work_thread);
>  free_host_mem:
>  	ibmvfc_free_mem(vhost);
> +free_workq:
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;
>  free_scsi_host:

[Severity: High]
Does this cause a double-free of the workqueue on the error path?

Since fpin_workq was allocated with devm_alloc_workqueue(), the driver
core's devres cleanup will automatically call destroy_workqueue() when
unwinding resources. Manually calling it here in the error path could lead
to a double free.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..64a517a74af8e
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
[ ... ]
> +	for (fs =3D IBMVFC_AE_FPIN_LINK_CONGESTED; fs <=3D IBMVFC_AE_FPIN_CONGE=
STION_CLEARED; fs++) {
> +		crq[fs].valid =3D 0x80;
> +		crq[fs].link_state =3D IBMVFC_AE_LS_LINK_UP;
> +		crq[fs].fpin_status =3D fs;
> +		crq[fs].event =3D cpu_to_be64(IBMVFC_AE_FPIN);
> +		crq[fs].scsi_id =3D cpu_to_be64(tgt->scsi_id);
> +		crq[fs].wwpn =3D cpu_to_be64(tgt->wwpn);
> +		crq[fs].node_name =3D cpu_to_be64(tgt->ids.node_name);
> +		ibmvfc_handle_async(&crq[fs], vhost);
> +		msleep(1U);
> +	}

[Severity: Medium]
Is a 1 millisecond sleep sufficient to guarantee the background work has
completed?

Workqueue execution latency depends on system load and scheduler behavior.
Using msleep(1U) as a synchronization primitive could lead to intermittent
KUnit test failures if the assertions check statistics before the work
has run. Would flush_workqueue() be a safer way to wait?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-ibmvfc-fpi=
n-support-v5-0-13fd6f8a8f8b@linux.ibm.com?part=3D1
