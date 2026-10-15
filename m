Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CC934751B
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 15:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792078106; cv=none; b=NvWvgv/xD7IKWCP9gW9SACiiHZTrHEeatkCnpO8+MItYgZf0qwC749nZoRSRVLbbl9WcnDC5Tzbnpava1olZvXWerBo6hcB+CHrfUWwLtjtRwAxw8A9EfsK2Ks7E3ZnNhd2ISMezgcveecPnyagdLWqFriHGX+gJmEt1Gpcv0wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792078106; c=relaxed/simple;
	bh=ForSItdtznIs218P4x3xfgtJ4Y2MykPb2P9/qoolFXI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=B1slONs+jEkxYHpcMxE9TzTVV2LZ6KWYnylH66omgbjw1vTGL+UAZRltXlTXyAXb/FoMaxVbInbmXB0bznwIoPcN8hMnqapVt1Vv18W/zFZzRc5xv2Xcu0p8HhFr6GLUwYIA/NZ3ACcxp9hu4DSTOsgeVWhaIKqQJJwTHQUa3ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLNY5h2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLNY5h2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21591F000C4;
	Thu, 15 Oct 2026 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792078100;
	bh=o7KjHOXZ+VTK5G5y7ljw0CWIU7llEtOwUCcfBPjaQFM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XLNY5h2hRPsT0u/RcoQposCfGB1NzWG0RphRUnmFHRJzf1S/8caDhGQ33jTW77nb8
	 p6XIfNXuX0SxNJuM3uRFKv6f9VQm2pIRls+Y0Kf4hKOhmnTzvLPCckgZsK6W8sPW6N
	 ENX2cVf9QT8vuyAPrzEiGzzkh4Hg/qi0ClXGd4RkpJF+X4EF+lTvoK/lcKwGJb8cQy
	 YvEeJWFqJxH5BcGeGG6oFmpmKaZDBtyo001ozMFHMIMBWIbGnwm6iMNPWrhNcobi/T
	 a/6QFFbS3at7ywAlxPsziFVs7MQKCHEfpCL/d/ts0hVSdBoPF85MJq99agwIhYM+IW
	 E3fD9khBRm4aA==
Message-ID: <sashiko-outbox-173070@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015-ibmvfc-fpin-support-v14-10-a0b063b8d825@linux.ibm.com>
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
 <20261015-ibmvfc-fpin-support-v14-10-a0b063b8d825@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 15:28:19 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] scsi: ibmvfc: DMA Use-After-Free due to skipped sub-CRQ deregi=
stration
- [High] scsi: ibmvfc: data race on host state bitfields due to lockless mq=
_enabled write
- [High] scsi: ibmvfc: missing bounds check on active_queues causes heap ov=
erflow
--

commit 4d5dd0876862baa994058a6b3ad652d84e0497a5
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b12655f028879..594e5f136040a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -5817,6 +5824,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  		vhost->do_enquiry =3D 0;
>  		scsi->active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
>  		nvme->active_queues =3D be32_to_cpu(setup->num_nvme_subq_channels);

[Severity: High]
Does this code overflow scsi->scrqs[] or nvme->scrqs[] if the hypervisor
returns a value for setup->num_scsi_subq_channels or
setup->num_nvme_subq_channels that is larger than the allocated
scsi->max_queues or nvme->max_queues?

The active_queues values are read directly from the hypervisor response
without any bounds checking, and are then used as limits in the
initialization loops below.

If a buggy or malicious hypervisor sends excessively large values, could it
cause an out-of-bounds write into the scrqs array or cause page faults on
the setup buffer?

> +		async->active_queues =3D (async->scrqs && setup->async_sub_crq_handle)=
 ? 1 : 0;
> =20
>  		if (flags & IBMVFC_CHANNELS_CANCELED) {
>  			ibmvfc_dbg(vhost, "Channels Canceled\n");
> @@ -5832,6 +5840,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  		for (i =3D 0; i < nvme->active_queues; i++)
>  			nvme->scrqs[i].vios_cookie =3D
>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
> +		for (i =3D 0; i < async->active_queues; i++)
> +			async->scrqs[i].vios_cookie =3D be64_to_cpu(setup->async_sub_crq_hand=
le);
> =20
>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>  			   scsi->active_queues);
[ ... ]
> @@ -6988,6 +7004,7 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host =
*vhost,
>  			for (j =3D i; j > 0; j--)
>  				ibmvfc_deregister_channel(vhost, channels, j - 1);
>  			vhost->do_enquiry =3D 0;
> +			vhost->mq_enabled =3D 0;

[Severity: High]
Since vhost->do_enquiry and vhost->mq_enabled are bitfields, these
assignments compile into read-modify-write operations on the containing
word.

ibmvfc_reg_sub_crqs() is called by worker threads like
ibmvfc_reenable_crq_queue() outside of the host_lock.

If a tasklet concurrently processes an event and calls a completion handler
like ibmvfc_channel_setup_done() (which executes under host_lock and writes
to another bitfield in the same word, such as vhost->using_channels =3D 1),
could this lockless read-modify-write overwrite the locked modifications
and corrupt the host state machine flags?

[Severity: Critical]
If channel registration fails here, vhost->mq_enabled is cleared to 0.

Since async_scrqs is successfully registered earlier in
ibmvfc_init_sub_crqs(), when teardown happens, ibmvfc_release_sub_crqs()
will call ibmvfc_dereg_sub_crqs() for async_scrqs.

However, ibmvfc_dereg_sub_crqs() returns immediately if
!vhost->mq_enabled:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_dereg_sub_crqs() {
    if (!vhost->mq_enabled || !channels->scrqs)
        return;
    ...
}

Will this cause ibmvfc_dereg_sub_crqs() to bypass deregistering the async
sub-CRQ, leaving the hypervisor DMA mappings and IRQ handlers active while
the memory is subsequently freed by ibmvfc_release_channels()?

>  			return;
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ibmvfc-fpi=
n-support-v14-0-a0b063b8d825@linux.ibm.com?part=3D10
