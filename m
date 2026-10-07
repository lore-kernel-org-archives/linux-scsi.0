Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267CA4E06E1
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 19:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402171; cv=none; b=eqrNqO0fQvdJtTjZ1wJc5jP8144kRgGJ8FrWS1kC1Maug/vdj6+CLBSuHeV1t4adUv9Lc7fPo755H8F03XzfOag8VA7V7B2fYW0j4tez9I1vHkRRaJo46jg8aJxW0+YRzCCj7EESB+aBaqe337M/FDcvEH/lcg7mH71Q/P7wfBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402171; c=relaxed/simple;
	bh=e8k8s+rgWYeuLTqpRy87+3Kcqi5NFGrzdg2Q8cxn7zc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tXBAXLTnsBg+U9bsj8rHzpR3yX5h3mhwysXWYu7G9dCobeUQ9qQx2+ZF4m82JwNh1Ys/AT+o7Kwjf9FVT5wWWRfWBKd4oGTsgIuRVNvFZA7ng0+X4sH2fAirqGRCNGkHhJxfRUtZodWbK0Hq5xkCgTFQcbRYODMxj3Ky1oy5his=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBuczKYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBuczKYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518C21F000FF;
	Wed,  7 Oct 2026 19:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791402166;
	bh=10b0t3DOJQSu1NboXC+PsLp7wju4WUNPx0lJoefKe84=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mBuczKYDgdEsDzovQ3TkL/1/8QODo2eH1gm5Ig/pNQJ7u74iB/aTa0j8wFm+7sy8Z
	 8TATe28JHZ3I27fNtFn+GcgX8uOMfYafWBAc0ietNfU+qQydyDMh6yl6pkIHBIOYj0
	 M+drN5nfUX1N01uzHctoLxIfP6ZyzoUAGEDZEPugu86DZs/hMAzD81jqfTO8iCBbEX
	 TqFA5uLPt8gBlST/gZDKgMkuzVTZ0ytY2IVzZRC1ppY0MtB4ZdIzyyN6DpDS3ZFPLe
	 1VIjMnH5MwhVvb/oe+7W2suINFR3U08k6EM7f2gMP0XS6tGTD8y5CLQm6Je2/WKEwY
	 S/ZF4wAw0RP8A==
Message-ID: <sashiko-outbox-163319@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-10-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
 <20261007-ibmvfc-fpin-support-v13-10-b816abfa4fcc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 19:42:45 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: host state machine stall if ibmvfc_reg_sub_crqs() fa=
ils
- [High] scsi: ibmvfc: NULL pointer deref in channel setup when mq_enabled=
=3D0
--

commit 3dd02df8d62690f440ff03238afa2613397c578a
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events
   =20
Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues. Updates
ibmvfc_set_login_info() to advertise related capabilities.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 76246002ac724..acc11f3a237e1 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -5821,6 +5828,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  		for (i =3D 0; i < nvme->active_queues; i++)
>  			nvme->scrqs[i].vios_cookie =3D
>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);
> +		async->scrqs[0].vios_cookie =3D be64_to_cpu(setup->async_sub_crq_handl=
e);

[Severity: High]
Can this cause a NULL pointer dereference when the module parameter mq_enab=
led
is 0?

If mq_enabled is 0, ibmvfc_init_sub_crqs() returns early and skips allocati=
on,
leaving async->scrqs as NULL but vhost->do_enquiry as 1.

If the VIOS later advertises IBMVFC_CAN_SUPPORT_CHANNELS during NPIV login,
ibmvfc_npiv_login_done() sees do_enquiry is true and issues a channel enqui=
ry.
When that completes, we reach this code and unconditionally dereference the
unallocated async->scrqs array.

[ ... ]
> @@ -5880,6 +5889,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host=
 *vhost)
>  		for (i =3D 0; i < nvme_channels; i++)
>  			setup_buf->channel_handles[scsi_channels + i] =3D
>  				cpu_to_be64(nvme->scrqs[i].cookie);
> +		setup_buf->async_sub_crq_handle =3D cpu_to_be64(async->scrqs[0].cookie=
);
>  	}

[Severity: High]
Similarly, can this unconditional access to async->scrqs[0].cookie trigger a
NULL pointer dereference when mq_enabled is 0?

[ ... ]
> @@ -7023,17 +7039,38 @@ static int ibmvfc_alloc_channels(struct ibmvfc_ho=
st *vhost,
[ ... ]
>  static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>  {
>  	ENTER;
>  	if (!vhost->mq_enabled)
>  		return;
> =20
> -	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
> -		vhost->do_enquiry =3D 0;
> -		vhost->mq_enabled =3D 0;
> -		return;
> -	}
> +	/* register async_sub_crq channel */
> +	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
> +		goto out;
> +
> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);

[Severity: High]
Does this cause a host state machine stall if ibmvfc_reg_sub_crqs() fails?

If ibmvfc_reg_sub_crqs() fails internally, it clears vhost->do_enquiry but
leaves vhost->mq_enabled set to 1. Because mq_enabled remains true,
ibmvfc_set_login_info() continues to advertise IBMVFC_CAN_USE_CHANNELS to
the VIOS.

When the VIOS responds with IBMVFC_CAN_SUPPORT_CHANNELS,
ibmvfc_npiv_login_done() enters the multi-queue branch, but because
do_enquiry is now 0, it skips calling ibmvfc_channel_enquiry().

It also bypasses the fallback block that would normally set
IBMVFC_HOST_ACTION_QUERY and wake up vhost->work_wait_q:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_npiv_login_done() {
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
}

Will this cause the initialization process to stall indefinitely in
IBMVFC_HOST_ACTION_INIT_WAIT?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ibmvfc-fpi=
n-support-v13-0-b816abfa4fcc@linux.ibm.com?part=3D10
