Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07C73911AB
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786031232; cv=none; b=bKgp276bSbge89kcLFQLZLmtMZlqXehr0Wf6zrz6cFRABwHwMIIH7op0TQVMuRCSdzALT0yGBhNcNGIgvZMLnSbjg10R9nPYFJC+S3CVeySlEnlw4l3IfQ3osicNv5n+GukuoLg/TjXNMwqldb2HlxnKF4BIGhRNgqilordAJDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786031232; c=relaxed/simple;
	bh=iMJWX1QL2ZI1OTvdZX8y+wIEo8IDCII+8l632265daU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I0sJTwN61MZ+geWC/tBo3LjZRsMEfMYXur9Pj7AcqNZ6g+6PSltPXit+RKI91Cpq5WfCuYWU2jwrElGhZ7l3ucqxHr8r7crn90k2k9FM7gLU+dpj6tHJp9HfbiUjiSkIWMagarFgmhN1yJBZECjY8cxbvPVy7cGrbCk/4K3GHiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/qqYndd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/qqYndd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5391F000E9;
	Thu,  6 Aug 2026 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786031230;
	bh=t0ouXkPNIIq5ONmtNTWmXWV/Pw+VKeHicRW/tZGnB64=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P/qqYnddSpQ3uiRVG2FPzS7wheWAilxAlrtIaZOGNWaN9PhLNSNUefqYFJUHdLrAu
	 FS47JNKWF5AzrOc7O2vaWF2y07b6fyIKWHlz8z2lyTL3/KoXHKSQDBQtEi3g+y8/6V
	 ReBzI2bJjNN1s6UahrI6/4/V6/ONawsScdMdkdKTFKNCOgSHosX+ZRtvy9eQIu+Iej
	 a12Vz4X63+DxKH5ZRBx8petLGCiQ4cB7ByPCgXH2vJLjj1BtvuIcJtjXZ44we78qgk
	 uW5cRsrNeoGrcsx7v97IGFAWLyPSZ7FfkdPTSr7aDRmAVeWEcfAOJxFMGjwtW/9fSz
	 ImDfAdHYgVftQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 6/7] scsi: ibmvfc: register and use asynchronous
 sub-queue for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-6-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
 <20260806-ibmvfc-fpin-support-v5-6-13fd6f8a8f8b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:47:09 +0000
Message-Id: <20260806154710.5E5391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] The driver enables IBMVFC_USE_ASYNC_SUBQ but fails to pass the asy=
nc sub-queue handle to the VIOS during channel setup, rendering the feature=
 non-functional.
- [High] The driver incorrectly allocates multiple asynchronous sub-queues =
(one for SCSI, one for NVMe) instead of a single host-wide queue.
- [High] Manual destruction of a devm-managed workqueue in the probe error =
path leads to a double-free when devres unwinds.
- [High] Pending FPIN asynchronous works can execute after the host struct =
is freed during device removal, resulting in a use-after-free.
- [Low] The ibmvfc_handle_async function attempts to dereference a void * p=
arameter, resulting in a severe compiler error.
--

--- Patch [6]: [PATCH v5 6/7] scsi: ibmvfc: register and use asynchronous s=
ub-queue for events ---
commit 75a27ff4a34478f19a67ddd8e7759ecc0644a5e2
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub-queue for events

Complete async sub-queue integration by setting up interrupt handling,
registering the queue as a channel, and enabling its use during NPIV
login.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 97856a609bde4..b6ac87c2042b5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -1583,9 +1583,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_ho=
st *vhost)
> =20
>  	if (vhost->mq_enabled || vhost->using_channels) {
>  		login_info->capabilities |=3D cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> +		login_info->capabilities |=3D cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);

[Severity: High]
Does enabling IBMVFC_USE_ASYNC_SUBQ here work as intended? Looking at
ibmvfc_channel_setup(), setup_buf->async_sub_crq_handle is never assigned a=
fter
memset(setup_buf, 0, sizeof(*setup_buf)), meaning the hypervisor never
learns the async sub-queue cookie.

Also, does allocating channels->async_scrq per channel collection (both SCSI
and NVMe separately) in ibmvfc_alloc_channels() cause issues, given the MAD
protocol only supports a single host-wide async sub-queue handle?

> +		login_info->capabilities |=3D cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);

[Severity: High]
Since this patch enables FPIN handling, could there be a use-after-free dur=
ing
device removal? Pending FPIN asynchronous works (ibmvfc_process_async_work)=
 can
execute after the host struct is freed during ibmvfc_remove() via
scsi_host_put(vhost->host).

Additionally, could the error path in ibmvfc_probe() cause a double-free? It
calls destroy_workqueue(vhost->fpin_workq) manually, but if the workqueue w=
as
allocated with devm_alloc_workqueue, devres will attempt to destroy it again
during error unwinding.

> +		login_info->capabilities |=3D cpu_to_be64(IBMVFC_YES_SCSI);
>  		if (vhost->nvme_enabled) {
>  			login_info->capabilities |=3D cpu_to_be64(IBMVFC_YES_NVMEOF);
> -			login_info->capabilities |=3D cpu_to_be64(IBMVFC_YES_SCSI);
>  			login_info->capabilities |=3D cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
>  		}
>  	}

[ ... ]

> @@ -4356,6 +4358,52 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct =
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
> +	while (!done) {
> +		while ((crq =3D ibmvfc_next_scrq(scrq)) !=3D NULL) {
> +			ibmvfc_handle_async(crq, scrq->vhost, true);

[Severity: Low]
Does this code compile successfully? ibmvfc_handle_async() takes a void poi=
nter
parameter, but looking at its implementation, it attempts direct member acc=
ess
like crq->scsi_id, which violates C syntax for void pointers.

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
> +	spin_unlock(scrq->q_lock);
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-ibmvfc-fpi=
n-support-v5-0-13fd6f8a8f8b@linux.ibm.com?part=3D6
