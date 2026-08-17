Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D2D135A53
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999869; cv=none; b=Pt1sQ4wpEx+GquYQH1uAeV/7K1MvmO6AmXBj0MFUTnChQfENhPRIkGe5kjpC+swUl9q48YZnOjuQBadGND+FUCyzVZL759GKzjVHzKsUrncuqaaMyQ+y4Jla2m1itpM7kk6Hi2QuoEsED5CHNDIDsaktb0ZcE4IMDR0p/FnsaMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999869; c=relaxed/simple;
	bh=GldpdhKu83tbx8h3SO44f22Ci0wUR53DRHox4sg4zN4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HBQrBAx+M4s0phy4Ic0k90xy1F8pVVACJKYOvSq/WQ30wldmgGKtxEIsWk2O/lORScRjlxbgvesJtCneU01rrSNBI7MJhrJOXjaw6O6G0HKSP2X4lNcqXchKFPC4VhrLGRbAztit6CLTPVW1acL6h0S07gdEwijx+BL2ZlSo+b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/ZlHmX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/ZlHmX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89501F000E9;
	Mon, 17 Aug 2026 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999868;
	bh=BNP+Z61eT9z0VqLJcmnJbewzpNrVCE/jejIb56LpLdE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y/ZlHmX7AgFqcLmK7M2cxy3by7fpIu4AsGCIwDUCie8aJGR2LfgyOr/7iD7/btLn/
	 YY0vAQ65t9tSP5p6iH5mc+7KZz8Yx/K9nODshdmEcVLJdlPk241PgNJqL6+qPK89AT
	 itzAFsc5/TwgERthxmcWZh2mD9AV/P/sIsqyT51aWuiW084w2NfJUIEGlA6fWyDer4
	 lmzcSedhkK8HVa7PzwYrIZ33nbgrMRymJsma9mgz/typCPGZDpmoh891hB9d4Jhiik
	 SUB04cv3R4Jhr9rVRfis6mSDWe4f8eWLxZooPAnCho052C58gnz8iD3MmSScqHbro+
	 AiyZFHyJLZkTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 5/8] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-5-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-5-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:51:07 +0000
Message-Id: <20260817205107.D89501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Double clearing of the CRQ valid byte creates a race condition cau=
sing silently dropped hardware events.
- [High] The fpin_workq is destroyed before unregistering the CRQ/Sub-CRQ I=
RQ handlers, leading to a NULL pointer dereference.
- [Medium] Nested acquisition of queue locks sharing the same lockdep class=
 triggers a recursive locking warning.
- [Low] The newly added interrupt handler `ibmvfc_interrupt_async_subq` is =
never registered.
- [Low] ibmvfc_handle_async() attempts to dereference a void pointer, break=
ing compilation.

Pre-existing issues:
- [High] Uninitialized variable 'shwqs' causes out-of-bounds access and ker=
nel panic in ibmvfc_purge_requests.
--

--- Patch [5]: [PATCH v6 5/8] scsi: ibmvfc: add interrupt routine for async=
hronous sub CRQ ---
commit 0805a2f1bf2f7cec43403295f1715fe78c1224dd
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ

This commit adds an interrupt handler for asynchronous sub-CRQ events,
which drains pending entries and re-enables interrupts.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 4d1630d2ab1b5..3b5732f2fb6ec 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4372,6 +4372,52 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct =
ibmvfc_queue *scrq)
>  	return crq;
>  }
> =20
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_host *vhost =3D scrq->vhost;
> +	struct ibmvfc_crq *crq;
> +	unsigned long flags;
> +	int done =3D 0;
> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	spin_lock(scrq->q_lock);

[Severity: Medium]
Does acquiring this lock trigger a recursive locking warning?

Both async_sub_crq.q_lock and scsi_q[i].q_lock appear to be initialized
from the same spin_lock_init(&queue->_lock) in ibmvfc_alloc_queue(),
meaning they share the same lockdep class.

If an event handled here triggers a host reset, the call chain could be:
ibmvfc_drain_async_subq() -> ibmvfc_handle_async() ->
ibmvfc_hard_reset_host() -> ibmvfc_purge_requests()

ibmvfc_purge_requests() then acquires scsi_q[i].q_lock for all active
channels, potentially causing lockdep to flag a false-positive recursive
locking splat.

> +	while (!done) {
> +		while ((crq =3D ibmvfc_next_scrq(scrq)) !=3D NULL) {
> +			ibmvfc_handle_async(crq, scrq->vhost, true);

[Severity: Low]
Does changing ibmvfc_handle_async() to accept a void *crq cause
a compilation error?

It looks like the NVMe target iteration loop in ibmvfc_handle_async()
still attempts to dereference the pointer directly:

if (!crq->scsi_id && !crq->wwpn && !crq->node_name)

Dereferencing a void pointer will break the build.

[Severity: High]
This is a pre-existing issue, but does ibmvfc_purge_requests() use an
uninitialized variable when called from this path?

If a host reset occurs, the chain ibmvfc_handle_async() ->
ibmvfc_hard_reset_host() -> ibmvfc_purge_requests() is triggered.

In ibmvfc_purge_requests(), shwqs is declared but not initialized:
int shwqs, nhwqs =3D 0;

If vhost->using_channels is false, shwqs remains uninitialized.
The loop then uses it as a bound:
for (i =3D 0; i < shwqs; i++) {

Could this cause an out-of-bounds access on the scsi_q array?

> +			crq->valid =3D 0;
> +			wmb();	/* complete write */

[Severity: High]
Does clearing the valid byte here create a race condition?

When processing an event, ibmvfc_handle_async() already hands ownership
back to the adapter by clearing the valid byte and issuing a write
memory barrier.

If the adapter writes a new event into this CRQ slot exactly between
the clear in ibmvfc_handle_async() and the clear here, will the newly
arrived event be permanently overwritten and lost?

> +		}
> +
> +		ibmvfc_toggle_scrq_irq(scrq, 1);
> +		crq =3D ibmvfc_next_scrq(scrq);
> +		if (crq !=3D NULL) {
> +			ibmvfc_toggle_scrq_irq(scrq, 0);
> +			ibmvfc_handle_async(crq, scrq->vhost, true);
> +			crq->valid =3D 0;
> +			wmb();	/* complete write */
> +		} else
> +			done =3D 1;
> +	}
> +	spin_unlock(scrq->q_lock);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +}
> +
> +/**
> + * ibmvfc_interrupt_async_subq - Handle an async event from the adapter
> + * @irq:           interrupt request
> + * @scrq_instance: async subq
> + *
> + **/
> +static irqreturn_t ibmvfc_interrupt_async_subq(int irq, void *scrq_insta=
nce)

[Severity: Low]
Is this interrupt handler ever registered?

It appears ibmvfc_interrupt_async_subq is defined to handle asynchronous
sub-CRQ events, but it is never passed to request_irq() during queue
initialization, leaving this function as dead code.

[Severity: High]
Can an async event arriving during driver teardown cause a NULL pointer
dereference?

During ibmvfc_remove(), vhost->fpin_workq is destroyed and set to NULL
before device interrupts are disabled via ibmvfc_release_crq_queue().

If an async FPIN event arrives from the adapter in this window, this
interrupt handler will run and eventually call ibmvfc_handle_async(),
which executes:
queue_work(vhost->fpin_workq, &aw->async_work_s);

Could this trigger a panic by queuing work to a NULL workqueue?

> +{
> +	struct ibmvfc_queue *scrq =3D (struct ibmvfc_queue *)scrq_instance;
> +
> +	ibmvfc_toggle_scrq_irq(scrq, 0);
> +	ibmvfc_drain_async_subq(scrq);
> +
> +	return IRQ_HANDLED;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D5
