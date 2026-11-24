Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795538582;
	b=tSmBMHcrmSv//p4s4fRrUsXw7HdtB5+iAtCnIb9WDX2Q2MknSb88wfb/ZE0Uj/it6JzU
	 T7RX2d5TXuuleqL+nKLhpu3U92pHVeFLYeofVxGVrp3JAqlcJP7piQNfKIQIcuwxC7Bvv
	 w9CQOe8dMyDpJU4SDvB6qj1rcleIDw0dVgoW/72ctPgoA0YQ6lfgdhTviXk0ExwYWrJJi
	 8vA7KOSrV9np1XCsYNES55neILg6onvVgf1X2uWHxHzEEvxRpjc6hleUT101FwECkeZcl
	 ykBgBn19tG5SWUMGn5mZl6Tt+bW4iTgoZ79CybfFXqKS13vgVvCOL2gL/3fue5WV+yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795538582;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZSKX1l3jG4+IBc51d9cHmAgxv4sKBfL1g+U99b2pwxY=;
	b=vblOiRqLZIs/tfoLLS8e0X67dqqXJpRF0sBofEOI1443zSFhBXvblt/YGjOs/hqKRSsB
	 9F2GRUO97WU8nRhJjUqsH6Oag4THaIT2zYrMDP6DSVOIYy7M1pc4fil+1EpOYPYiTG4Ep
	 nzafC6cPJuFT+++tIo9fG3IPTRIGZDD95yXpDMLjtmuwblWDiozEpngZpQWdEPCrP4yK2
	 yzCBhn1tWV8NIxw5Ag4YJxZMIULJBPqt3KVGPRJz+sFI+9tAH+iaV4ErSYmc53Nq7Yg8e
	 UQxEWaXzZQtocuRnVPSzR9jnsN5HLc8sVnTIdwx2mXAnRa3NvXrF2vhReqOG1pFLh+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+U2m8Pm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6487A606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+U2m8Pm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C9C1F000C0;
	Tue, 24 Nov 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795538582;
	bh=ZSKX1l3jG4+IBc51d9cHmAgxv4sKBfL1g+U99b2pwxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S+U2m8PmKtPtbTpNuRKc3SO8iI5oQNXZmQTz6iwNyLhItgMOwzg7KJPmn8fZwjsGT
	 paG0Z4N4qFUJYj643v0iZmcZwrQ2WvOxA60uZcW3Wv8Ek1zFwJG2RaTTYfm31yDfLS
	 V+Gv3M+w/vh0Z3nNBComNDRQjleFDVH4WBq/VzzUoLv7GO1bEpuTg4iT7jekcefKER
	 RoRKldO5sVAnd0FN9ed4k7/k0nO5V+Iub3lEeiXDvyNcxGCL/hqEgUkfKBGdSJrMfx
	 6GsOEzY110+5XIYhlb1iEaB+GQPAYxQiYqcxb2PhqCbBNW1hwOrCld9u/MJQ1uiGke
	 sJpytM/rSqEAg==
Message-ID: <sashiko-outbox-231582@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 12/13] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261124-ibmvfc-fpin-support-v19-12-2aaffe5fe7d2@linux.ibm.com>
References: <20261124-ibmvfc-fpin-support-v19-0-2aaffe5fe7d2@linux.ibm.com>
 <20261124-ibmvfc-fpin-support-v19-12-2aaffe5fe7d2@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 16:43:01 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: ibmvfc: skipped async vios_cookie setup in
  ibmvfc_channel_setup_done()
--

commit 3e247869161ac30df00b0fd2f408f7ef73973ecb
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This commit wires the asynchronous sub-CRQ into the ibmvfc channel allocati=
on,
registration, setup, and teardown lifecycle, and advertises async sub-CRQ
support during NPIV login when multi-queue channels are enabled.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 5e8b25673ff5d..f478f10f93ffc 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -5912,6 +5940,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  {
>  	struct ibmvfc_host *vhost =3D evt->vhost;
>  	struct ibmvfc_channel_setup *setup =3D vhost->channel_setup_buf;
> +	struct ibmvfc_channels *async =3D &vhost->async_scrqs;
>  	struct ibmvfc_channels *scsi =3D &vhost->scsi_scrqs;
>  	struct ibmvfc_channels *nvme =3D &vhost->nvme_scrqs;
>  	u32 mad_status =3D be16_to_cpu(evt->xfer_iu->channel_setup.common.statu=
s);
> @@ -5925,8 +5954,12 @@ static void ibmvfc_channel_setup_done(struct ibmvf=
c_event *evt)
>  		ibmvfc_dbg(vhost, "Channel Setup succeeded\n");
>  		flags =3D be32_to_cpu(setup->flags);
>  		vhost->do_enquiry =3D 0;
> -		scsi->active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
> -		nvme->active_queues =3D be32_to_cpu(setup->num_nvme_subq_channels);
> +		scsi->active_queues =3D min(be32_to_cpu(setup->num_scsi_subq_channels),
> +					  scsi->max_queues);
> +		nvme->active_queues =3D nvme->scrqs ?
> +			min(be32_to_cpu(setup->num_nvme_subq_channels),
> +			    nvme->max_queues) : 0;
> +		async->active_queues =3D (async->scrqs && setup->async_sub_crq_handle)=
 ? 1 : 0;
> =20
>  		if (flags & IBMVFC_CHANNELS_CANCELED) {
>  			ibmvfc_dbg(vhost, "Channels Canceled\n");
> @@ -5942,6 +5975,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  		for (i =3D 0; i < nvme->active_queues; i++)
>  			nvme->scrqs[i].vios_cookie =3D
>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
> +		for (i =3D 0; i < async->active_queues; i++)
> +			async->scrqs[i].vios_cookie =3D be64_to_cpu(setup->async_sub_crq_hand=
le);

[Severity: Medium]
Does breaking out on IBMVFC_CHANNELS_CANCELED skip setting
async->scrqs[0].vios_cookie while leaving async->active_queues set to 1?

When scsi_channels and nvme_channels are both 0, ibmvfc_channel_setup()
sets IBMVFC_CANCEL_CHANNELS and still populates
setup_buf->async_sub_crq_handle so the async sub-CRQ can be used.
However, when the response returns with IBMVFC_CHANNELS_CANCELED set, the
break in ibmvfc_channel_setup_done() jumps over the loop that stores
setup->async_sub_crq_handle in async->scrqs[0].vios_cookie, leaving
vios_cookie uninitialized or stale.  It also leaves scsi->active_queues
and nvme->active_queues unzeroed if the response contains non-zero counts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-ibmvfc-fpi=
n-support-v19-0-2aaffe5fe7d2@linux.ibm.com?part=3D12
