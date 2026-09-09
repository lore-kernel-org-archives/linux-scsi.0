Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67D9563FC1
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 19:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788982001; cv=none; b=oHDUDDnsq3n5T8hjg5YLr6Xw4+MFtsx9JicMmG7GChiPmXdvKJ/iN9c3W6pPvqOfFyX7xSo4d5H0eHpO0qYZBoNk/8GMjuMYBVuVJah++IjX1GXGXoZTDZ/bg9GYtNQefs5ZkEDab2kZWqqO+qYdihkmH6yaALDOxo2QoUt0kik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788982001; c=relaxed/simple;
	bh=tZTR2F2GfqKiN6cd5EwF3vsNYn2DgUCgPjMD+o8MOl8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W8Y23CIsra2gMY8WAeq49HE7fnH7TCB0vzJut4azuN6dSa+kZnpOirJ74hVi6r1tHnmcM0nXKw7zIXnP9zZGwc90jfNwQaI6bgnDC9nwA06vYRJc37bAwQ4sjwoqQRS/iz8DnERyZxWtNPE7DaCv9SbQiJi2E376pQU1luV0npI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsQR86Z+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsQR86Z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219E41F000FF;
	Wed,  9 Sep 2026 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788981993;
	bh=7Tqglft6U84BOU4aDi9ueIJ3t1FVTtVNsSuT9kW42dk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UsQR86Z+V8hr8aPl1/Jc4DX2/OoICdxhWbEl8N3c0KJNhGB9TDM8ecZt226/7xN85
	 ALFZCrh7AeGaYdNmjl8AMNsPCNsz2tjmBeOV7flWzvK9T543lJ2+o8LNY9qNaBprUg
	 uWFwv349diDZ1URyEA3uUG8Y2AExQeuByp+CMu55o6FRO4PvzjllO2A6VNzOtBV5O3
	 HlgXROdxjGPMn2Ot0iF8+AddkzPNYaVzL54ezBybsIsvhIa/2TBbzR/HTz/PHK1jKV
	 vWelePhj0QEp8qFhuBoFZ+dktjpBefY5VrqTEGM9FeZG/mT9Pl/HcOlCVmh4ZS36zj
	 Y+/lRRvbd/iUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister
 on channel reg failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-7-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-7-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 19:26:32 +0000
Message-Id: <20260909192633.219E41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Asynchronous timer deletion during teardown allows the timer c=
allback to execute after the event pool memory has been freed.
- [High] Unknown channel protocol error path skips IRQ mapping disposal and=
 falsely reports success, causing an IRQ leak and a subsequent kernel warni=
ng on teardown.
- [High] Sub-CRQ cookies are not zeroed after being freed via H_FREE_SUB_CR=
Q, leading to double-freeing the cookies during adapter resets or teardowns.
- [High] The adapter initialization state machine stalls indefinitely if ch=
annel registration fails.
- [Medium] ibmvfc_deregister_channel() unconditionally executes H_FREE_SUB_=
CRQ for unmapped or unregistered queues, causing spurious hypervisor errors=
 and kernel log spam.
- [Medium] Event pool memory is permanently leaked if queue allocation fail=
s midway in ibmvfc_alloc_queue().
--

commit 9f8024026aa5c4ef26997be7255cb4acbd34dd0f
Author: Dave Marquardt <davemarq@linux.ibm.com>

    scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
   =20
    If request_irq() fails during ibmvfc_register_channel(), the error path
    disposes of the IRQ mapping via irq_dispose_mapping() but leaves scrq->=
irq
    populated with the stale virq number. A subsequent call to
    ibmvfc_deregister_channel() during teardown or reset cleanup then
    unconditionally invokes free_irq() and irq_dispose_mapping() on the sta=
le
    IRQ descriptor, triggering kernel warnings.
   =20
    Fix this by:
    1. Explicitly setting scrq->irq to 0 after irq_dispose_mapping() in the
       ibmvfc_register_channel() error path.
    2. Guarding free_irq() and irq_dispose_mapping() with a check for scrq-=
>irq
       in ibmvfc_deregister_channel() so unmapped or unregistered queues are
       safely skipped.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 1c660edcf608a..f88262ffad134 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6888,6 +6888,7 @@ static int ibmvfc_register_channel(struct ibmvfc_ho=
st *vhost,
>  		else
>  			dev_err(dev, "Couldn't register async sub-crq irq\n");
>  		irq_dispose_mapping(scrq->irq);
> +		scrq->irq =3D 0;
>  		goto irq_failed;
>  	}
> =20
> @@ -6930,9 +6931,11 @@ static void ibmvfc_deregister_channel(struct ibmvf=
c_host *vhost,
> =20
>  	ENTER;
> =20
> -	free_irq(scrq->irq, scrq);
> -	irq_dispose_mapping(scrq->irq);
> -	scrq->irq =3D 0;
> +	if (scrq->irq) {
> +		free_irq(scrq->irq, scrq);
> +		irq_dispose_mapping(scrq->irq);
> +		scrq->irq =3D 0;
> +	}
> =20
>  	do {
>  		rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,

[Severity: Medium]
This is a pre-existing issue, but does this unconditional hypercall cause
spurious hypervisor errors and kernel log spam?

During adapter teardown or reset, ibmvfc_dereg_sub_crqs() iteratively calls
ibmvfc_deregister_channel() on all allocated sub-CRQs up to max_queues,
regardless of whether they were successfully registered.

This results in H_FREE_SUB_CRQ being invoked on uninitialized queues where
scrq->cookie is 0.

[Severity: High]
This is a pre-existing issue, but is it possible for sub-CRQ cookies to be
double-freed during adapter resets or teardowns?

After calling H_FREE_SUB_CRQ above, scrq->cookie is not zeroed. If iterative
teardown functions call this again, could the double-free destroy an active
channel on the VIOS side if the hypervisor has reallocated that cookie?

This same issue occurs in the error path of ibmvfc_register_channel():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_register_channel() {
...
irq_failed:
	do {
		hcall_rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq-=
>cookie);
	} while (hcall_rc =3D=3D H_BUSY || H_IS_LONG_BUSY(hcall_rc));
...
}

Where the cookie is similarly freed but not zeroed.

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_register_channel() {
...
		default:
			dev_err(dev, "Unknown channel protocol (%d)\n",
				channels->protocol);
			goto irq_failed;
		}
...
}

[Severity: High]
This is a pre-existing issue, but does the unknown channel protocol error p=
ath
skip IRQ mapping disposal and falsely report success?

If channels->protocol hits the default case, it jumps to irq_failed. Because
rc was initialized to -ENOMEM but overwritten to 0 by a successful
h_reg_sub_crq(), the function falsely returns 0.

This leaves scrq->irq non-zero and causes an IRQ leak and a subsequent kern=
el
warning on teardown when free_irq() is called on an unrequested IRQ.

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_queue() {
...
	if (dma_mapping_error(dev, queue->msg_token)) {
		free_page((unsigned long)queue->msgs.handle);
		queue->msgs.handle =3D NULL;
		return -ENOMEM;
	}
...
}

[Severity: Medium]
This is a pre-existing issue, but does this error path leak the event pool
memory?

If get_zeroed_page() or dma_map_single() fail, the function returns -ENOMEM
without calling ibmvfc_free_event_pool() to clean up the event pool allocat=
ed
at the beginning of the function.

When handling the failure in ibmvfc_alloc_channels():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_channels() {
...
		if (rc) {
			for (j =3D i; j > 0; j--) {
				scrq =3D &channels->scrqs[j - 1];
				ibmvfc_free_queue(vhost, scrq);
			}
			kfree(channels->scrqs);
...
}

The array is freed, losing the reference to the partially-allocated queue i
and permanently leaking its event pool.

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_fail_request() {
...
	timer_delete(&evt->timer);
...
}

[Severity: Critical]
This is a pre-existing issue, but does asynchronous timer deletion during
teardown allow the timer callback to execute after the event pool memory has
been freed?

During adapter removal, ibmvfc_purge_requests() calls ibmvfc_fail_request()
which executes timer_delete() instead of timer_delete_sync(). Teardown then
quickly progresses to ibmvfc_free_event_pool().

If a command timeout occurs concurrently:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_timeout() {
...
	struct ibmvfc_event *evt =3D timer_container_of(evt, t, timer);
	struct ibmvfc_host *vhost =3D evt->vhost;
...
}

Can the timer callback access fields on an event structure that has already
been freed, leading to a use-after-free and potential kernel crash?

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_npiv_login_done() {
...
	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS)) {
		if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_SCSI))
			vhost->do_scsi_login =3D 1;
		if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF))
			vhost->do_nvme_login =3D 1;
		if (vhost->do_enquiry)
			ibmvfc_channel_enquiry(vhost);
	} else {
		vhost->do_enquiry =3D 0;
		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
		wake_up(&vhost->work_wait_q);
	}
...
}

[Severity: High]
This is a pre-existing issue, but can the adapter initialization state mach=
ine
stall indefinitely if channel registration fails?

If ibmvfc_alloc_queue() or ibmvfc_register_channel() fail,
vhost->do_enquiry is set to 0.=20

Later, in ibmvfc_npiv_login_done(), if the adapter supports channels but
vhost->do_enquiry is 0, the code skips ibmvfc_channel_enquiry() but doesn't
fall into the else branch.

Because it does not advance vhost->action or wake up the work queue, does t=
he
state machine remain stuck in IBMVFC_HOST_ACTION_INIT_WAIT, rendering the
storage adapter unusable?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D7
