Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002563ACEF2
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 19:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788982021; cv=none; b=qsn1fpIswTHtqUe6z6uRplzzhwFppPv/kl64ZuCgmx0BJwXQMQsbvA8BDpN+UV+H7+6lpy8UVgyhdvIuAJCOhL7Um2eWjNzWg7lgqB0kYiFwyWwn3jFSOcrzAcGcdqgfEMrj9Kd8wM0oOOsjJ+x/g40VIn9bwuW/NsDn/JxB1w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788982021; c=relaxed/simple;
	bh=jisHkcrnn3epPaVacJzAwqQd/s868tjurxGCKWRtfZM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gyRcSnXhP4Hp/vnlODWnUUV7Xv5mJRHQ0+RWKVTR2k/Bj+ySBNE0zCEUP4X96eJVCg0ggNE3zVHlMWSwm+8AbEznn3r5M3XCB58V1HDK2XfTRnKf0g5AZ45c76sEDEfD9PyQqPmXDeTVAFQZFIuFzwIRZKYzwrk5Q5QGK4ZUxDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4/Ud6Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4/Ud6Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5631F00893;
	Wed,  9 Sep 2026 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788982019;
	bh=lBlakWPUhXZ6w+9kbAO1JfY8cQfVByAQBtvWnrVvrAg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T4/Ud6HiKqp1k3shpuhnjcailVUlJJ5SIV4vCguYHextzblltGvMOTUvMYAWynvVH
	 d+fLFnTDlMluz+gGSd+992+7trb6T9CUp17euwinyvXNaLUjwnXkYw6fiWZy9E6WQH
	 oCGf4UScbON1BHaxZz9R+TxAUPI2wt/4aqnVtaiUfdzO3uDXF3rdgPyuDNCfFmVn6D
	 /oaG2ukEU7H5H/mrF1UvXeFrhl8QPcqacEaWXnaioxwqjIN9pQpsZIWh5PTnU9VgBv
	 Vn+5WK8ABmk7DeK+a9YjAWqKulTI/rCWlef6lQcedkP4App+g3eX4tFiDzvDbU69YB
	 24cK0+UjxDqRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 8/9] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-8-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-8-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 19:26:59 +0000
Message-Id: <20260909192659.6D5631F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Unconditional register and deregister operations on `async_sub_crq=
` ignore `mq_enabled`, leading to invalid hypercalls, potential DMA memory =
corruption, and NULL pointer dereferences.
- [Medium] The return value of async sub-CRQ registration is silently ignor=
ed during CRQ reset and re-enablement, causing state inconsistency and adve=
rtising false capabilities.
--

commit de8500cd39535bfa37dc0890330c18e9bda3828f
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This patch wires the async sub-CRQ into the sub-CRQ lifecycle, so it is
allocated, registered, and freed alongside the SCSI channel queues.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -986,6 +989,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_ho=
st *vhost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> =20
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);

[Severity: Medium]
The return value of ibmvfc_register_channel() is ignored here.

If registration fails (e.g., due to resource exhaustion or IRQ mapping
failure), does the driver proceed to ibmvfc_set_login_info() and falsely
advertise IBMVFC_USE_ASYNC_SUBQ capabilities?

>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
[ ... ]
> @@ -1006,6 +1010,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vho=
st)
>  	struct vio_dev *vdev =3D to_vio_dev(vhost->dev);
>  	struct ibmvfc_queue *crq =3D &vhost->crq;
> =20
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);

[Severity: High]
If the driver is loaded with mq_enabled=3D0, the async_sub_crq is never
allocated. Does this unconditionally call ibmvfc_deregister_channel(),
executing an invalid H_FREE_SUB_CRQ hypercall with cookie 0?

>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
[ ... ]
> @@ -1042,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vho=
st)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> =20
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);

[Severity: High]
Similarly, does this unconditionally pass an uninitialized DMA token (0) to
the hypervisor via H_REG_SUB_CRQ if MQ is disabled?

If accepted by the hypervisor, could this lead to memory corruption at
physical address 0, or cause a NULL pointer dereference in
ibmvfc_drain_async_subq() if an interrupt triggers?

[Severity: Medium]
Also, like in ibmvfc_reenable_crq_queue(), the return value is ignored here.
If the registration fails, we might still advertise support for async sub-C=
RQs
to the hypervisor.

>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
[ ... ]
> @@ -7067,6 +7101,9 @@ static void ibmvfc_release_channels(struct ibmvfc_h=
ost *vhost,
>  static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>  {
>  	ENTER;
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +

[Severity: High]
Does this unconditionally deregister and free the queue on release without
checking if MQ is enabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D8
