Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772493624D7
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 19:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783712408; cv=none; b=PO6rzRTuN5CIKX71yYPykml+/Yj6Pns+376nJ8gdjiLQL4BLGBj02/OdHA1hHuiuRW9bDa96wXjURBBSDx/Nc6SR61COFioCuTRpqVaQb9kBCBzPnBOYlIjVwNaZ9T35MElirXY0GjS019nISCkiznS0wizjIn6PFTexPAQZpC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783712408; c=relaxed/simple;
	bh=iLcc1IUhPbGepHtK64nbPBUpZhNUC/nNBGybKE+94nU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B6rg0X3JaHhWSe10HmDav/VO9gWB+ah2a/ca6YUL7XbbkC+f+8mV0QCbIXMy+FEQpXiLiVElQxeDcJ8uLY6S07WkOdB0HofJbO6dgHgZs8dEsUpnNk7BcNUJBmZQaqt/O9pwtL7aaeURNkZQiYe+LOcLZAPaUxbbuHD9qZW5aKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hReAGgJs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hReAGgJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4D81F000E9;
	Fri, 10 Jul 2026 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783712407;
	bh=34WfdZ1gz+ZgpevwnNaPzGaN/Zj4sS+fPRdI+kIsJPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hReAGgJsA4Sp7PYxscWXOorOr0SS04kZu4Fkj8unPNpzFRObZxtktksnWF/lncf4W
	 jlO7KUUTQ72jjjmoZkY4BeaWk9h7xv6lX9x7T7sies1HD45qgPEplljBoSq3jvZFHe
	 9Vj6AjyJGLnBEzBrIPBSyjBmAlDmjlq7CROgWD8dgk8wvLu8guYqRm/IOhOgPF0Ybk
	 v41hoS1QLw6v70cbU0pFe3iF5dyAMtzf2UB26iiv/yZyQUgGpOozNs5/ehu/bCZsfp
	 h9Qj7Bi+CvNNSwloODkePRBWHNwKWj+kDIgCTDr0GIl/zqRt2HiKJRfGImUgH+uG0M
	 TgFOibojq7rXA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/8] ibmvfc: define asynchronous sub-queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710-ibmvfc-fpin-support-v4-4-ef031ac19520@linux.ibm.com>
References: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
 <20260710-ibmvfc-fpin-support-v4-4-ef031ac19520@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 19:40:06 +0000
Message-Id: <20260710194006.EA4D81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] The driver unloads without explicitly flushing or canceling `fpin_=
workq`, leading to a Use-After-Free.
- [High] The error path in `ibmvfc_probe()` manually destroys a device-mana=
ged workqueue, resulting in a double-free.
- [High] The `ibmvfc_process_async_work()` function accesses a target objec=
t outside of the host lock without holding a reference count, leading to a =
TOCTOU Use-After-Free.
- [High] The driver fails to clear the `valid` byte of asynchronous CRQ ent=
ries after processing them, which will permanently stall asynchronous event=
s.

Pre-existing issues:
- [High] Out-of-bounds array write when parsing channel setup completion fr=
om VIOS.
--

--- Patch [4]: [PATCH v4 4/8] ibmvfc: define asynchronous sub-queue ---
commit 9bd2cdf24ef9c308bf4803492cdf8f30fbef4057
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: define asynchronous sub-queue
   =20
Define data structures for asynchronous sub-queue support required for full=
 and
extended FPIN functionality. Introduce the ibmvfc_async_subq structure for
async events, update channel setup capabilities, and negotiate async support
with VIOS during login.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 3dd2adda195ee..c95e78d729ed7 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -3185,16 +3191,228 @@ static const char *ibmvfc_get_link_state(enum ib=
mvfc_ae_link_state state)
[ ... ]
> +static void ibmvfc_process_async_work(struct work_struct *work)
> +{
> +	struct ibmvfc_target *tgt, *next;
> +	struct ibmvfc_async_work *aw;
> +	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_host *vhost;
> +	struct fc_els_fpin *fpin;
> +	unsigned long flags;
> +
> +	aw =3D container_of(work, struct ibmvfc_async_work, async_work_s);
> +	crq =3D &aw->crq;
> +	vhost =3D aw->vhost;
> +
> +	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +		goto end;
> +
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
What prevents a use-after-free here if a concurrent device deletion or logo=
ut
frees tgt immediately after the lock is dropped?

Since the lock is dropped without acquiring a reference to tgt (via kref_ge=
t),
is it safe to access tgt->wwpn or pass tgt->vhost->host to fc_host_fpin_rcv=
()
outside of the lock?

[ ... ]

> @@ -3803,8 +4041,6 @@ static void ibmvfc_tasklet(void *data)
>  		/* Pull all the valid messages off the async CRQ */
>  		while ((async =3D ibmvfc_next_async_crq(vhost)) !=3D NULL) {
>  			ibmvfc_handle_async(async, vhost);
> -			async->valid =3D 0;
> -			wmb();
>  		}

[Severity: High]
Is it intentional to remove the clearing of the valid byte here?

The VIO CRQ protocol normally requires clearing the valid byte after consum=
ing
an entry. Without this, it seems the consumed entries are never freed, which
could cause the async CRQ ring buffer to permanently fill up and stall
asynchronous events.

> =20
>  		/* Pull all the valid messages off the CRQ */
> @@ -3818,8 +4054,6 @@ static void ibmvfc_tasklet(void *data)
>  		if ((async =3D ibmvfc_next_async_crq(vhost)) !=3D NULL) {
>  			vio_disable_interrupts(vdev);
>  			ibmvfc_handle_async(async, vhost);
> -			async->valid =3D 0;
> -			wmb();
>  		} else if ((crq =3D ibmvfc_next_crq(vhost)) !=3D NULL) {

[ ... ]

> @@ -5069,8 +5393,12 @@ static void ibmvfc_channel_setup_done(struct ibmvf=
c_event *evt)
>  		return;
>  	}
> =20
> -	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> -	wake_up(&vhost->work_wait_q);
> +	if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_SCSI)) {
> +		ibmvfc_fabric_login(vhost);
> +	} else {
> +		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> +		wake_up(&vhost->work_wait_q);
> +	}
>  }

[Severity: High]
This isn't a bug introduced by this patch, but is there a bounds check
missing for active_queues in this function?

Looking earlier in ibmvfc_channel_setup_done(), active_queues is read from
the VIOS hardware response and used as a loop bound:

ibmvfc_channel_setup_done() {
    ...
    active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
    scrqs->active_queues =3D active_queues;
    ...
    for (i =3D 0; i < active_queues; i++)
        scrqs->scrqs[i].vios_cookie =3D be64_to_cpu(setup->channel_handles[=
i]);
    ...
}

Could this loop write past the end of the scrqs->scrqs array if the VIOS
returns a value greater than scrqs->max_queues?

[ ... ]

> @@ -6364,9 +6694,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
t struct vio_device_id *id)
>  	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
>  	mutex_init(&vhost->passthru_mutex);
> =20
> -	if ((rc =3D ibmvfc_alloc_mem(vhost)))
> +	vhost->fpin_workq =3D devm_alloc_workqueue(vhost->dev, "%s-fpin-workq-%=
u", 0, 0,
> +						 IBMVFC_NAME, shost->host_no);
> +	if (vhost->fpin_workq =3D=3D NULL)
>  		goto free_scsi_host;
> =20

[Severity: High]
Could this devm_alloc_workqueue() allocation lead to a use-after-free during
driver unload?

During driver unload, ibmvfc_remove() calls scsi_host_put() which frees the
Scsi_Host and vhost structures. Since devres callbacks run after the remove
function returns, the workqueue will be destroyed after vhost is already
freed. If any pending ibmvfc_process_async_work() items execute, they would
dereference the freed vhost structure.

> +	rc =3D ibmvfc_alloc_mem(vhost);
> +	if (rc)
> +		goto free_workq;
> +
>  	vhost->work_thread =3D kthread_run(ibmvfc_work, vhost, "%s_%d", IBMVFC_=
NAME,
>  					 shost->host_no);
> =20
> @@ -6412,6 +6748,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  	kthread_stop(vhost->work_thread);
>  free_host_mem:
>  	ibmvfc_free_mem(vhost);
> +free_workq:
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;

[Severity: High]
Will manually destroying a devm-managed workqueue here cause a double-free?

Because fpin_workq was allocated with devm_alloc_workqueue(), devres
automatically registers an action to destroy it. If this error path manually
calls destroy_workqueue(), it appears devres will try to destroy it a second
time during automatic cleanup.

>  free_scsi_host:
>  	scsi_host_put(shost);
>  out:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-ibmvfc-fpi=
n-support-v4-0-ef031ac19520@linux.ibm.com?part=3D4
