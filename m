Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E0F1F1534
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 06:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106532; cv=none; b=QAbSf8LWNiuXxx8bHGVZ5sp8V9nmuO8+SJY8OvBOwvRFqxLllY+rXkWL8dTTyGyqrsf6Vc5mA+68HQosvR6xdRPtEmEFoWfM7twcrIRuGd5UPYfhcpScbKvR1wcXBRj6bb7qMnMds4pRKhho37v1akAhUnTCVCJYANP0Xl53C2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106532; c=relaxed/simple;
	bh=Pq4irEVvmzUvBazZAz+lw8xif58Yuc6APa+SZLSwJjo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C8RpuymgOiaJVHbLuEFWwv0wjlb4FUoEun331CzMOCF0331pluAPHK34P8dpun7ls7PeJZX6GW3WY14iee+G/UBxYjT9N2GbUxwnDO/ZZNoA9sWDWWc15KPBd85GDh7txg15n1JteF3YBcnbnUto4vDMGF4Szw5LEIV9lc4UEeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkCcN7Ih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkCcN7Ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECA91F000FF;
	Fri, 11 Sep 2026 06:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106531;
	bh=f/9sf84G/gPlBRSooH1GXiFc7rb7EZCckTckdiZM3rs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gkCcN7IhsoeunCUjhyvk1sXQAyH00+hyxItrVSbLvSD+ohK3ZIjWxr/0T/NHCHGcB
	 P1cUIQnYYX89TUziaSPoJce8XxBXYRFJVzobq8rBeLhcPyT9zMSJNDapKx7y9sqMiv
	 1ixhYfu0KMTg2ScZD4vYprRMPMlvtfnQKRs2SYXgvkkTYUAOkAvUgbQEVKygJrpOzf
	 kTkIvlsSWUAdmJcxlTSTprnDwkMhNM0O7nbBChpCnimlCeez/PoSlfh/eK/1DG2fif
	 SSMoK25dQmf6kpHuYfK5z6XnFojsQVykglU/IEjiU2khnIqSXcRl7huIZHwHPlJHd7
	 8FLzC3jTJfsag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 8/9] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911054832.1311668-9-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-9-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 06:02:10 +0000
Message-Id: <20260911060211.0ECA91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Unconditional register, deregister, and free operations on `as=
ync_sub_crq` without checking allocation status lead to double-frees, DMA A=
PI violations, and invalid hypercalls.
--

commit d886488c1c2c33ee5e78bda51eefcf9391abe904
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index c78e221f182a2..70a3046135c7b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -964,6 +966,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_ho=
st *vhost)
>  	struct vio_dev *vdev =3D to_vio_dev(vhost->dev);
>  	unsigned long flags;
> =20
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);

[Severity: Critical]
If multi-queue is disabled or failed to initialize, vhost->async_sub_crq
won't be allocated.  Will this unconditionally deregister an unallocated qu=
eue?

[ ... ]
> @@ -1042,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vho=
st)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> +	ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);

[Severity: Critical]
Will unconditionally registering the async queue here pass an uninitialized
msg_token to the hypervisor if the queue was never allocated?

[ ... ]
> @@ -6953,8 +6964,10 @@ static void ibmvfc_deregister_channel(struct ibmvf=
c_host *vhost,
>  	}
> =20
>  	/* Clean out the queue */
> -	memset(scrq->msgs.crq, 0, PAGE_SIZE);
> -	scrq->cur =3D 0;
> +	if (scrq->msgs.handle) {
> +		memset(scrq->msgs.crq, 0, PAGE_SIZE);
> +		scrq->cur =3D 0;
> +	}

[Severity: Critical]
The commit message notes this memset is guarded to prevent a NULL dereferen=
ce
when the queue was never allocated.  However, earlier in this function
plpar_hcall_norets(H_FREE_SUB_CRQ, ...) is called using scrq->cookie.

Does this hcall also need to be guarded to avoid passing an uninitialized
cookie?

[ ... ]
> @@ -7046,6 +7071,15 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_hos=
t *vhost)
>  	}
> =20
>  	LEAVE;
> +	return;
> +
> + deregister_async_sub_crq:
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +free_async_sub_crq:
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);

[Severity: Critical]
If ibmvfc_alloc_channels() fails, we deregister and free async_sub_crq
here.  Later, won't ibmvfc_release_sub_crqs() attempt to unconditionally
free it again?

> +	vhost->do_enquiry =3D 0;
> +	vhost->mq_enabled =3D 0;
> +	return;
>  }
> =20
>  static void ibmvfc_release_channels(struct ibmvfc_host *vhost,
> @@ -7069,6 +7103,9 @@ static void ibmvfc_release_channels(struct ibmvfc_h=
ost *vhost,
>  static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
>  {
>  	ENTER;
> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +

[Severity: Critical]
Since async_sub_crq might not have been allocated (e.g., if mq_enabled
is false) or might have been freed during a prior initialization failure,
could this result in a double-free or freeing of uninitialized memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911054832.1311=
668-1-tyreld@linux.ibm.com?part=3D8
