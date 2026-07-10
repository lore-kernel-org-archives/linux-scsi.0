Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17E71F4C8E
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 19:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783711866; cv=none; b=Ggfhj2IiFlj0ARGLqtMAIwC7590anmu675GqhjEuZ78gz73kfFg8PRSdV+jMQx8V4mwc8BwqK/dkCvLknfyXqeWH8yPkR+4OoFS+cZ6Y8qnNhfYciWubmo+vWyNx9KWG7AHDMpH63icFpPVEuVUgEOtaCpUxChGZOLK0eYcEBfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783711866; c=relaxed/simple;
	bh=F5g4+uaNLYQp9NoUKhEcPElsiVfn/SsjGGwnX1pY5eQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l4o7KM5bUug3KsPYgFPGn39REso6wL5xSXfMsVBxGpoCMIhxJrjKmGww62qd/yBqkPBNWSUkPqslBbU2yU568S3+fkPEaGEAIQIe8kAnR2/QFGPePN003XfGtE8LKATlkYVIvxt8Ji5NBdV8fqi6xYm0qQo5n3l+kCj+zv9fVyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kaKJ1NU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kaKJ1NU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDBF1F000E9;
	Fri, 10 Jul 2026 19:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783711864;
	bh=pLFwX/yGsK6EmFuKLwkcKNGbMKkAGCVwGDEx7etOvl4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kaKJ1NU/WkMwhiD7mzaKpaYAfPg0FpYTxl7afzHd5PjJO2Zpo1NOW5Lw6gV2Se2SP
	 3pey3mUPUYJejqu+hAl/N9r1HnmIO3pELPzKejvu0CvQSEQqs2Tor5pzDyfpekMwW4
	 dSO55nGOlw4VHdweMJnvMSvoD7GztFFRKyRVJ6hTLMhUDcWR8Vg31tfMIvGdefakqn
	 PxReKS6YQ6eSqNsmVPFAsb8uIKCayCDskf3GghfPQifg9XCWIpVrJA43AdiO39SRJn
	 +trry0JvfLcH/t1Ug5Uz7Y38zKTSGTWRcbv/GYJFbNdBWNjvMVEg5MHGqDwd3rpaCr
	 6nFHNUSmy6UYw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/8] ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710-ibmvfc-fpin-support-v4-1-ef031ac19520@linux.ibm.com>
References: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
 <20260710-ibmvfc-fpin-support-v4-1-ef031ac19520@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 19:31:04 +0000
Message-Id: <20260710193104.7DDBF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Removal of `async->valid =3D 0;` leads to an infinite loop and=
 stale message processing in the async CRQ tasklet.
- [High] Missing reference count acquisition on `tgt` in `ibmvfc_process_as=
ync_work` leads to Use-After-Free.
- [High] Improper devres lifecycle management of `fpin_workq` causes a doub=
le-free on probe failure and a Use-After-Free during device removal.
- [Medium] Data races and potential use-after-free in the new KUnit test mo=
dule due to lockless access of global and host device lists.
--

--- Patch [1]: [PATCH v4 1/8] ibmvfc: add basic FPIN support ---
commit d8410cbccc8b5f74d804dc594b4dd758bd093c6e
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: add basic FPIN support

This patch implements basic Fabric Performance Impact Notifications (FPIN)=
=20
support to enable monitoring of fabric congestion and link integrity events.
It adds async event handling that offloads FPIN processing to a workqueue
and introduces a KUnit test module for validation.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -3185,16 +3189,228 @@ static const char *ibmvfc_get_link_state(enum ib=
mvfc_ae_link_state state)
> +static void ibmvfc_process_async_work(struct work_struct *work)
> +{

[ ... ]

> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	list_for_each_entry_safe(tgt, next, &vhost->targets, queue) {
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
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +
> +	if (list_entry_is_head(tgt, &vhost->targets, queue) || !tgt->rport) {
> +		dev_err_ratelimited(vhost->dev, "Invalid target for FPIN\n");
> +		goto end;
> +	}
> +
> +	fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);

[Severity: High]
Does this leave the target pointer vulnerable to a use-after-free?

The lock protecting the vhost->targets list is dropped before we access=20
tgt->wwpn and tgt->rport, without acquiring a reference via kref_get().

If another thread handles a target logout or hotplug concurrently, it could=
=20
remove and free the target structure, causing memory corruption when we=20
attempt to access it here.

[ ... ]

> @@ -3803,8 +4031,6 @@ static void ibmvfc_tasklet(void *data)
>  		/* Pull all the valid messages off the async CRQ */
>  		while ((async =3D ibmvfc_next_async_crq(vhost)) !=3D NULL) {
>  			ibmvfc_handle_async(async, vhost);
> -			async->valid =3D 0;
> -			wmb();
>  		}

[Severity: Critical]
Could removing this clearing operation lead to an infinite loop?

The hardware signals a valid entry by setting the valid field to 0x80. By=20
removing the clearing of async->valid, the driver's ring-buffer polling log=
ic=20
will mistakenly see the old, uncleared entries as new valid entries once th=
e=20
circular queue index wraps around.

This would trap the system in an infinite loop within softirq context when=
=20
processing any valid async event.

[ ... ]

> @@ -6364,9 +6588,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
t struct vio_device_id *id)

[ ... ]

> -	if ((rc =3D ibmvfc_alloc_mem(vhost)))
> +	vhost->fpin_workq =3D devm_alloc_workqueue(vhost->dev, "%s-fpin-workq-%=
u", 0, 0,
> +						 IBMVFC_NAME, shost->host_no);
> +	if (vhost->fpin_workq =3D=3D NULL)
>  		goto free_scsi_host;

[ ... ]

> @@ -6412,6 +6642,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  	kthread_stop(vhost->work_thread);
>  free_host_mem:
>  	ibmvfc_free_mem(vhost);
> +free_workq:
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;

[Severity: High]
Can this result in a double-free on probe failure, and a use-after-free=20
during device removal?

The workqueue is allocated using devm_alloc_workqueue(). On probe failure,=
=20
destroy_workqueue() is called explicitly, and then devres will automaticall=
y=20
call it again during cleanup, causing a double-free.

Additionally, during device removal in ibmvfc_remove(), the host is manuall=
y=20
freed before devres automatically cleans up the workqueue. If there are=20
pending work items like ibmvfc_process_async_work(), they will execute and=
=20
attempt to dereference host pointers that have already been freed.

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{

[ ... ]

> +	headp =3D ibmvfc_get_headp();
> +	if (list_empty(headp))
> +		kunit_skip(test, "No ibmvfc devices available");
> +	queue =3D headp->next;
> +	vhost =3D container_of(queue, struct ibmvfc_host, queue);
> +
> +	KUNIT_ASSERT_GE_MSG(test, vhost->num_targets, 1, "No targets");
> +	tgt =3D list_first_entry(&vhost->targets, struct ibmvfc_target, queue);

[Severity: Medium]
Is it safe to access the global ibmvfc_head list and vhost->targets list=20
without holding the appropriate locks?

The test traverses the global ibmvfc_head without acquiring the=20
ibmvfc_driver_lock, and then iterates over vhost->targets without acquiring=
=20
the vhost->host->host_lock.

Since KUnit tests can run dynamically while other processes or the hypervis=
or=20
interact with the driver, concurrently adding or removing devices could mod=
ify=20
these lists and free structures, resulting in a use-after-free.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-ibmvfc-fpi=
n-support-v4-0-ef031ac19520@linux.ibm.com?part=3D1
