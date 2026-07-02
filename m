Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCDC3090C6
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 18:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783017029; cv=none; b=ryUqQcGZtmeR6DkpLBPA4kRfj+5UH2Z9DY2RrorVZLCBBi8KVJsxwHqsJSOOQQgVMzM8t/YiMSf7ExNXx0S/7l4HVRrNceTG4873ZNshkSKQzO83CJed45H0/v/5hLCxr6vEzEpRIMuraQ1JZGOINgUhrqpkQ6CCg5ShbT56iAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783017029; c=relaxed/simple;
	bh=jtq1nIc+agWDGZqUAzffKdUjVnbSRw5s1IdfnzZuTvU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y6SsmS7Rm6ekGj4meUSCgUFLv3G1d3qiiRIAaj9keHanUfzReEsIgIk2bOTwls76ymd7xBQUW3tt0AH42czwoMXDCNJNmQdy2PM7ZxoA+e3SQT7Xz9vcQvQDFJHkDZzh4+SnW+jscIVtA39vBBSIi42MedbsAEVbuHEuF7h3xwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RL7DbwAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RL7DbwAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912101F000E9;
	Thu,  2 Jul 2026 18:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783017027;
	bh=PN5JZu7T+enaiJdSv+OzfYvrHeG+SNvdsXn2jr79i5Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RL7DbwAd3j/H8X2mzfM2U2KGOq7Hj+fPQ8tmFpAlVXcbZt+HwG75NsW74QD06zFow
	 V0gIJAVf27Z8wNO+rEEqdHEb3x0Quc4PddNx63pnC98k+9K3s0OXQFVYAoG0VgHYFJ
	 EIuDXymrVfvwTEc1JxcdtaBkzgQPdd4llseiv0TjWLPAJjC5zo57RGfrgMqja1IFXG
	 M8Gfm4XmP788pxahj3j96vlKakCJoyE8ykT0/ijWOzvwU/u1YDk4J/aYVGMW+vAQ2+
	 F4jkppM2CrYOBa7vdK1cZG5bs3NWS4qsl9oab/kj/xSbi6jvp9FfBpLJTcIWTGa6GD
	 TrOJfKGzfYrhw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 7/8] ibmvfc: register and use asynchronous sub-queue
 for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-7-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
 <20260702-ibmvfc-fpin-support-v3-7-d95b9547cf88@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:30:26 +0000
Message-Id: <20260702183027.912101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Missing `host_lock` acquisition in `ibmvfc_drain_async_subq` leads=
 to data races and kernel panics.
- [High] Invalid pointer dereference due to `list_for_each_entry_safe` curs=
or leak in `ibmvfc_process_async_work` triggers a kernel panic.
- [Medium] Protocol violation: `IBMVFC_USE_ASYNC_SUBQ` capability is uncond=
itionally advertised to the VIOS.
- [Medium] Memory leak of `channels->async_scrq` in `ibmvfc_release_channel=
s`.
- [Low] Incorrect queue naming in `ibmvfc_channel_index` due to `active_que=
ues` being 0 during registration.
- [Low] The `async_scrq` is not assigned an `hwq_id`, leaving it at 0 and c=
ausing misleading debug logs.
--

commit 1426674b04407a5087c581ceae1dd979f487b41b
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: register and use asynchronous sub-queue for events

Set up interrupt handling for asynchronous sub-queue, register the
asynchronous sub-queue as a channel, and enable its use by NPIV login.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 4678d76c84fe2..36abca0bbd34d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1514,7 +1514,8 @@ static void ibmvfc_set_login_info(struct ibmvfc_hos=
t *vhost)
>  	login_info->max_cmds =3D cpu_to_be32(max_cmds);
>  	login_info->capabilities =3D
>  		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
> -			    IBMVFC_CAN_USE_NOOP_CMD);
> +			    IBMVFC_CAN_USE_NOOP_CMD | IBMVFC_YES_SCSI |
> +			    IBMVFC_USE_ASYNC_SUBQ | IBMVFC_CAN_HANDLE_FPIN);

[Severity: Medium]
Should IBMVFC_USE_ASYNC_SUBQ only be advertised when vhost->mq_enabled is
true?

If the user disables MQ, the async sub-queue is never registered, but the
VIOS might still attempt to send async sub-queue formatted events, falling
back to the legacy async_crq. The driver processes legacy CRQ events with
is_subq=3Dfalse expecting the legacy layout, which could lead to incorrect
event processing.

> =20
>  	if (vhost->mq_enabled || vhost->using_channels)
>  		login_info->capabilities |=3D cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);

[ ... ]

> @@ -4235,6 +4236,49 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct =
ibmvfc_queue *scrq)
>  	return crq;
>  }
> =20
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_crq *crq;
> +	unsigned long flags;
> +	int done =3D 0;
> +
> +	spin_lock_irqsave(scrq->q_lock, flags);
> +	while (!done) {
> +		while ((crq =3D ibmvfc_next_scrq(scrq)) !=3D NULL) {
> +			ibmvfc_handle_async(crq, scrq->vhost, true);

[Severity: High]
Does this code call ibmvfc_handle_async() without holding the host_lock?

ibmvfc_handle_async() can modify host state and invoke functions like
__ibmvfc_reset_host(), which traverses vhost->targets. The global
vhost->host->host_lock is required to protect these lists. Executing them
concurrently without it could result in list corruption and kernel panics.

> +			crq->valid =3D 0;
> +			wmb();	/* complete write */
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
> +	spin_unlock_irqrestore(scrq->q_lock, flags);
> +}
> +

[ ... ]

> @@ -6331,14 +6375,27 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vh=
ost)
>  	return retrc;
>  }
> =20
> -static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
> -				   struct ibmvfc_channels *channels,
> -				   int index)
> +static inline char *ibmvfc_channel_index(struct ibmvfc_channels *channel=
s,
> +					 struct ibmvfc_queue *scrq,
> +					 char *buf, size_t bufsize)
> +{
> +	if (scrq < channels->scrqs || scrq >=3D channels->scrqs + channels->act=
ive_queues)

[Severity: Low]
When ibmvfc_reg_sub_crqs() is executed during probe, is
channels->active_queues still 0 here?

If so, the condition will evaluate to true for all SCSI hardware queues,
incorrectly naming all sub-queues as "ibmvfc-<unit>-scsiasync" instead of
assigning their numeric index. This could break /proc/interrupts
identification.

> +		strscpy(buf, "async", 6);
> +	else
> +		snprintf(buf, bufsize, "%ld", scrq - channels->scrqs);
> +	return buf;
> +}
> +
> +static int ibmvfc_register_channel_handler(struct ibmvfc_host *vhost,

[ ... ]

> @@ -6381,32 +6441,43 @@ static int ibmvfc_register_channel(struct ibmvfc_=
host *vhost,
>  	rc =3D request_irq(scrq->irq, scrq->handler, 0, scrq->name, scrq);
> =20
>  	if (rc) {
> -		dev_err(dev, "Couldn't register sub-crq[%d] irq\n", index);
> +		dev_err(dev, "Couldn't register sub-crq[%s] irq\n",
> +			ibmvfc_channel_index(channels, scrq, buf, sizeof(buf)));
>  		irq_dispose_mapping(scrq->irq);
> +		scrq->irq =3D 0;
>  		goto irq_failed;
>  	}
> =20
> -	scrq->hwq_id =3D index;
> +	if (scrq >=3D channels->scrqs && scrq < channels->scrqs + channels->max=
_queues)
> +		scrq->hwq_id =3D scrq - channels->scrqs;

[Severity: Low]
Does this exclude channels->async_scrq from receiving an hwq_id?

Since it is allocated as a standalone struct outside the scrqs array, its
hwq_id would remain 0. Subsequent errors on the async queue would log
against sub-crq[0], which could mislead debugging efforts toward the first
SCSI queue.

> =20
>  	LEAVE;
>  	return 0;

[ ... ]

> @@ -6461,7 +6544,8 @@ static void ibmvfc_dereg_sub_crqs(struct ibmvfc_hos=
t *vhost,
>  		return;
> =20
>  	for (i =3D 0; i < channels->max_queues; i++)
> -		ibmvfc_deregister_channel(vhost, channels, i);
> +		ibmvfc_deregister_channel(vhost, channels, &channels->scrqs[i]);
> +	ibmvfc_deregister_channel(vhost, channels, channels->async_scrq);
> =20
>  	LEAVE;
>  }

[Severity: Medium]
Since channels->async_scrq is dynamically allocated, does
ibmvfc_release_channels() leak this memory?

When the driver tears down the channels in ibmvfc_release_channels(), it
calls ibmvfc_free_queue(vhost, channels->async_scrq) and then sets
channels->async_scrq =3D NULL without ever calling kfree(), which permanent=
ly
leaks the struct memory.

[Severity: High]
This is a pre-existing issue, but I have a question about cursor leaks in
ibmvfc_process_async_work().

ibmvfc_process_async_work() searches the vhost->targets list using
list_for_each_entry_safe(). If no target is found, the 'tgt' cursor exits
the loop pointing to the list head, not NULL. Does the subsequent check:

    if (!tgt || !tgt->rport) {

evaluate this leaked cursor? Because tgt->rport evaluates to an
out-of-bounds offset that aliases vhost->sg_pool, the check might
incorrectly succeed. The function would then access out-of-bounds
properties to process an event, feeding a corrupted pointer into
fc_host_fpin_rcv() and causing a kernel panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-ibmvfc-fpi=
n-support-v3-0-d95b9547cf88@linux.ibm.com?part=3D7
