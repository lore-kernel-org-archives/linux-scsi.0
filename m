Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2C7175A79
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766539; cv=none; b=u0tvr8/CyTfWSjZ2uAxENJy/r7D+dmAs2xseqqhrLFHSlzgXhUdjJxzYBwUAGb4cCw4DjB7JRl3cXvlFcNn7NZboFUXkzNVaK4pP5Tiq93V7UbAEB3+lKvg+UhF2Zuras0TPd4HyPZK/IjfXg1sG86oxu2JlcgdFQY1Oxz90Qfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766539; c=relaxed/simple;
	bh=WqTc1UX1atI9BjCrntywFTzASFW1JpudpODthcRwQLs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=b5FWMdoOarlkVZ5PvcIFUm1h3/FpCvn1GDB9yUglwe1eKdTi+p1qXSSgIqs+0iTH+dhXjNIJB7kkL0qYUaSMBS0aa2r0+Q2lauBrn3eSPTB38EUA29fvYvgucz0uOkuIEsXKs9WUNcH1TLZLvwdyDEm1ka2m+CMXp8fZyjGxRUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzcQRZ6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzcQRZ6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7FA1F000E9;
	Thu, 23 Jul 2026 00:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766537;
	bh=1KJR/3tODjKS0HTT5LiH1W9SsmrgZCD6VQLfmxF+D8E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kzcQRZ6D/PiR95NiFnr9c++d75MVZa5MHxFHBwre7YSufzUcnENSHVu0dE2NGMXqQ
	 GFtUKHYA6akmL1lWSKpHSMaNEMCkdUsmgd3VcKRhe7nFr/MEyDTBW7xwO0x4YbdGQI
	 TSu9g+KfoUzqjDMtEwfw0CExxOPUQvc6j14wUKVWMRwu4n9vNXCREO/lX8XMymL5qo
	 vbWUXwniOQrGeioDITw1ciA/nLKVp2DnO6mEmlbfsratkiox+JEAjEqX87OvZ4vMMM
	 ol5fZP7xK94vrQi7DSXSThwImwYeVxFNAnsbrzMGsPcXG7fyH2bAe71JyKIHNeEbbH
	 dsvEl3sHNgw0g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/33] ibmvfc: add logic for protocol specific fabric
 logins
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-11-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-11-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:28:57 +0000
Message-Id: <20260723002857.BB7FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:

New issues:
- [High] The host initialization state machine permanently stalls if NPIV l=
ogin completes while `vhost->do_enquiry` is false.
- [High] NVMe fabric login is entirely skipped if the VIOS advertises NVMe =
support but not SCSI support, or if SCSI fabric login is disabled.
- [High] Concurrent transmission of SCSI and NVMe discovery MADs causes sta=
te machine transitions to be lost, resulting in dropped targets.
- [High] If NVMe is disabled by the guest but supported by the VIOS, `ibmvf=
c_channel_setup()` unconditionally dereferences a NULL `nvme->scrqs` pointe=
r.
- [Medium] Unintended switch fallthrough in `ibmvfc_fabric_login_scsi_done`=
 default case sends NVMe MAD on a dead link.

Pre-existing issues:
- [High] Missing validation of hypervisor-provided `active_queues` in `ibmv=
fc_channel_setup_done` leads to out-of-bounds heap writes.
- [High] Integer overflow of `max_cmds` when calculating queue depths for N=
PIV login.
--

--- Patch [10]: [PATCH v2 10/33] ibmvfc: add logic for protocol specific fa=
bric logins ---
commit bffd16f5906104e27c687d661ecee756b7747318
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

    ibmvfc: add logic for protocol specific fabric logins

    Add support for the protocol-specific fabric login flow introduced by
    the updated client/VIOS interface. Track whether SCSI and NVMe/FC fabric
    login are needed, extend channel enquiry/setup handling to negotiate bo=
th
    SCSI and NVMe queue counts, and issue the appropriate fabric login MADs
    before target discovery begins.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index d8c2b56258eeb..e0edd71e9fd4b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -1512,7 +1520,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_hos=
t *vhost)
>  	max_cmds =3D scsi_qdepth + IBMVFC_NUM_INTERNAL_REQ;
>  	if (mq_enabled)
>  		max_cmds +=3D (scsi_qdepth + IBMVFC_NUM_INTERNAL_SUBQ_REQ) *
> -			vhost->scsi_scrqs.desired_queues;
> +			(vhost->scsi_scrqs.desired_queues + vhost->nvme_scrqs.desired_queues);

[Severity: High]
This isn't a bug introduced by this patch, but does calculating the queue
depth this way risk an integer overflow?

In ibmvfc_set_login_info(), max_cmds is declared as a 16-bit unsigned integ=
er
(u16). If large values are configured for module parameters like scsi_qdept=
h,
this calculation could silently exceed 65,535 and wrap around.

Could this overflow submit a corrupted max_cmds limit to the VIOS?

[ ... ]

> +static void ibmvfc_fabric_login_scsi_done(struct ibmvfc_event *evt)
> +{
> +	struct ibmvfc_host *vhost =3D evt->vhost;
> +	struct ibmvfc_fabric_login_mad *rsp =3D &evt->xfer_iu->fabric_login;
> +	u32 mad_status =3D be16_to_cpu(rsp->common.status);
> +	int level =3D IBMVFC_DEFAULT_LOG_LEVEL;
> +
> +	switch (mad_status) {
> +	case IBMVFC_MAD_SUCCESS:
> +		ibmvfc_dbg(vhost, "SCSI fabric login succeeded\n");
> +		break;
> +	case IBMVFC_MAD_FAILED:

[ ... ]

> +	case IBMVFC_MAD_DRIVER_FAILED:
> +		ibmvfc_free_event(evt);
> +		return;
> +	default:
> +		dev_err(vhost->dev, "Invalid SCSI fabric login response: 0x%x\n", mad_=
status);
> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +		break;
> +	}
> +
> +	ibmvfc_free_event(evt);
> +
> +	if (vhost->do_nvme_login) {
> +		ibmvfc_fabric_login_nvme(vhost);

[Severity: Medium]
Does the break statement in the default case above cause an unintended swit=
ch
fallthrough?

If SCSI fabric login fails with an unrecognized status, the default case ca=
lls
ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD). However, unlike the other error
cases which return, it breaks out of the switch.

Will this cause execution to fall through and improperly invoke
ibmvfc_fabric_login_nvme() on a dead link?

> +	} else {
> +		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> +		wake_up(&vhost->work_wait_q);
> +	}
> +}

[ ... ]

> @@ -5068,22 +5211,28 @@ static void ibmvfc_channel_setup_done(struct ibmv=
fc_event *evt)
>  		ibmvfc_dbg(vhost, "Channel Setup succeeded\n");
>  		flags =3D be32_to_cpu(setup->flags);
>  		vhost->do_enquiry =3D 0;
> -		active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
> -		scrqs->active_queues =3D active_queues;
> +		scsi->active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
> +		nvme->active_queues =3D be32_to_cpu(setup->num_nvme_subq_channels);

[Severity: High]
This is a pre-existing issue, but are these hypervisor-provided counts
validated against the array bounds?

The counts are taken directly from the untrusted 32-bit values returned by
the VIOS.

If the VIOS returns values larger than the dynamically allocated array sizes
(max_queues), will the subsequent loops that initialize vios_cookie corrupt
the guest kernel heap by writing out-of-bounds?

> =20
>  		if (flags & IBMVFC_CHANNELS_CANCELED) {
>  			ibmvfc_dbg(vhost, "Channels Canceled\n");
>  			vhost->using_channels =3D 0;
> -		} else {
> -			if (active_queues)
> -				vhost->using_channels =3D 1;
> -			for (i =3D 0; i < active_queues; i++)
> -				scrqs->scrqs[i].vios_cookie =3D
> -					be64_to_cpu(setup->channel_handles[i]);
> -
> -			ibmvfc_dbg(vhost, "Using %u channels\n",
> -				   vhost->scsi_scrqs.active_queues);
> +			break;
>  		}
> +
> +		if (scsi->active_queues || nvme->active_queues)
> +			vhost->using_channels =3D 1;
> +		for (i =3D 0; i < scsi->active_queues; i++)
> +			scsi->scrqs[i].vios_cookie =3D
> +				be64_to_cpu(setup->channel_handles[i]);
> +		for (i =3D 0; i < nvme->active_queues; i++)
> +			nvme->scrqs[i].vios_cookie =3D
> +				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);

[ ... ]

> @@ -5098,8 +5247,12 @@ static void ibmvfc_channel_setup_done(struct ibmvf=
c_event *evt)
>  		return;
>  	}
> =20
> -	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> -	wake_up(&vhost->work_wait_q);
> +	if (vhost->do_scsi_login) {
> +		ibmvfc_fabric_login_scsi(vhost);
> +	} else {
> +		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
> +		wake_up(&vhost->work_wait_q);
> +	}
>  }

[Severity: High]
Does this bypass NVMe fabric login if SCSI fabric login is disabled?

If vhost->do_scsi_login is false, the code immediately transitions the host
state to IBMVFC_HOST_ACTION_QUERY.

Since NVMe login is sequentially chained from the SCSI login completion
callback (ibmvfc_fabric_login_scsi_done), if the VIOS advertises NVMe suppo=
rt
but not SCSI support, will NVMe initialization fail because it is entirely
skipped?

> =20
>  static void ibmvfc_channel_setup(struct ibmvfc_host *vhost)
> @@ -5120,12 +5276,17 @@ static void ibmvfc_channel_setup(struct ibmvfc_ho=
st *vhost)
>  	}
> =20
>  	memset(setup_buf, 0, sizeof(*setup_buf));
> -	if (num_channels =3D=3D 0)
> +	if (!scsi_channels && !nvme_channels)
>  		setup_buf->flags =3D cpu_to_be32(IBMVFC_CANCEL_CHANNELS);
>  	else {
> -		setup_buf->num_scsi_subq_channels =3D cpu_to_be32(num_channels);
> -		for (i =3D 0; i < num_channels; i++)
> -			setup_buf->channel_handles[i] =3D cpu_to_be64(scrqs->scrqs[i].cookie);
> +		setup_buf->num_scsi_subq_channels =3D cpu_to_be32(scsi_channels);
> +		setup_buf->num_nvme_subq_channels =3D cpu_to_be32(nvme_channels);
> +		for (i =3D 0; i < scsi_channels; i++)
> +			setup_buf->channel_handles[i] =3D
> +				cpu_to_be64(scsi->scrqs[i].cookie);
> +		for (i =3D 0; i < nvme_channels; i++)
> +			setup_buf->channel_handles[scsi_channels + i] =3D
> +				cpu_to_be64(nvme->scrqs[i].cookie);

[Severity: High]
Can nvme->scrqs be a NULL pointer here?

If the guest disables NVMe (e.g., via module parameter),
ibmvfc_alloc_channels() for NVMe is skipped, leaving nvme->scrqs as NULL.

When ibmvfc_channel_enquiry_done() executes, if the VIOS reports
num_nvme_subq_channels > 0, nvme_channels calculates to > 0.

Will the loop above then unconditionally dereference the NULL nvme->scrqs
pointer?

>  	}
> =20
>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);

[ ... ]

> @@ -5290,8 +5452,14 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_e=
vent *evt)
>  	vhost->host->can_queue =3D be32_to_cpu(rsp->max_cmds) - IBMVFC_NUM_INTE=
RNAL_REQ;
>  	vhost->host->max_sectors =3D npiv_max_sectors;
> =20
> -	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS) && vhost->do_=
enquiry) {
> -		ibmvfc_channel_enquiry(vhost);
> +
> +	if (ibmvfc_check_caps(vhost, IBMVFC_CAN_SUPPORT_CHANNELS)) {
> +		if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_SCSI))
> +			vhost->do_scsi_login =3D 1;
> +		if (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF))
> +			vhost->do_nvme_login =3D 1;
> +		if (vhost->do_enquiry)
> +			ibmvfc_channel_enquiry(vhost);
>  	} else {
>  		vhost->do_enquiry =3D 0;
>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);

[Severity: High]
Does removing the else block here cause the host initialization state machi=
ne
to stall if vhost->do_enquiry is false?

If sub-CRQ channel allocation fails, do_enquiry is set to 0. When NPIV login
subsequently completes, this block skips ibmvfc_channel_enquiry().

Since there is no fallback to transition the state to IBMVFC_HOST_ACTION_QU=
ERY
when do_enquiry is false, does this cause the state machine to permanently
stall?

[Severity: High]
One additional question about target discovery behavior in
ibmvfc_discover_targets():

When both SCSI and NVMe target discovery are active, both discovery MADs
are sent concurrently:

	if (!ibmvfc_send_event(evt, vhost, default_timeout))
		ibmvfc_dbg(vhost, "Sent discover SCSI targets\n");
    ...
	if (!ibmvfc_send_event(evt, vhost, default_timeout))
		ibmvfc_dbg(vhost, "Sent discover NVMe targets\n");

However, when each completes, they both call ibmvfc_discover_targets_done(),
which attempts to advance the shared state machine:

	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);

Will the second completion be ignored because the host action is no longer
IBMVFC_HOST_ACTION_INIT_WAIT, causing one protocol's discovered targets to =
be
silently dropped and never allocated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D10
