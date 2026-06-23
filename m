Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E25B22256F
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179457; cv=none; b=OPCfHNdSYTZ9NZLF1TDwlByZ94hvN0LG0jKfGKSRKxvn2c2BJ81i1qquZ4E0osYPa0P56zEDwtzMkppvkaE+iIYToZ+DmMBcgIWlel0+E+5DdUFoZDXu32GlA8qSjsyZju+lBVee7PPrca3Q5cbE1E8Z22SXuI31DsmdclQhgo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179457; c=relaxed/simple;
	bh=YGinLQhQlNmEX/xKd1kYkvYp96FvRVnMxvBPAXWHC1g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PMKx+ANrV8ivc+2jPqof9XZ6wLbfv31xLh5YfOWf0Qlr65CW0pYDV618Tz8+KKswGfAGKzM+bfNW7wZCyJn8Z04fES7/xErEO3ro58eMI0z/4sEjVlHPvu+qwaCMgQ29BOVuVB2+ch6RzaL2N1Jg1wL2feHPAYatpbxxE3Eh4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DRXMwWw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DRXMwWw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC3D1F000E9;
	Tue, 23 Jun 2026 01:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179456;
	bh=edg0EhcqNvkUP8/HsgfKO+akZIl1ymPFfhhqhCzh+ak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DRXMwWw8jGE4lu18lYQ5Y6qXCdecMlyoRVnBJc55YA6WUm0x8/D7nMe84lBFx+7xL
	 YYMAghTAMd9uQhliwJQJqNlDld+yAK+1uNtj4g8dDcvVHI+2BpUW4Bf665Q9AsS094
	 QDose0IAXZGohkNVjc8UesdCPMr8aW+WNbhYLCO6tzEFfjmEyNRyn7ZRJWljGeB5v+
	 ZZ4PzWdzipOwOGh/H4eHIEV0nL75oISZQVjXEbv7IdHsEynvqs9GF29iOxTThm4sS2
	 xlURzpcgQJgRiKqQVtAWcFTdf7gTKSb0nFWxyb4CsnydAOcysAjLOYJeooQJz3zBOr
	 j00edX7IKzkUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/29] ibmvfc: add logic for protocol specific fabric
 logins
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-7-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-7-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:50:55 +0000
Message-Id: <20260623015056.4FC3D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Host initialization stalls indefinitely if `do_enquiry` is false d=
uring NPIV login completion.
- [High] NVMe fabric login is entirely skipped if SCSI fabric login is not =
required.
- [High] Concurrent target discovery MADs cause a data race and state machi=
ne failure, dropping targets.
- [High] Stale `do_scsi_login` and `do_nvme_login` flags persist across NPI=
V logins, causing unsupported MAD requests.

Pre-existing issues:
- [High] Missing bounds check on VIOS-provided queue counts causes arbitrar=
y out-of-bounds heap write.
- [High] Integer overflow in `max_cmds` leads to SCSI command queue depth u=
nder-allocation and negative `can_queue` bounds.
--

commit d57e35c4c58c31909c3240ab400f9b9c8c0b9a8b
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add logic for protocol specific fabric logins
   =20
This commit adds support for the protocol-specific fabric login flow introd=
uced
by the updated client/VIOS interface. It tracks whether SCSI and NVMe/FC fa=
bric
logins are needed and negotiates queue counts for both protocols. The driver
now issues appropriate fabric login MADs before target discovery begins.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 6f5e8b3cbfc82..93c32fa162f83 100644
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
> =20
>  	memset(login_info, 0, sizeof(*login_info));

[Severity: High]
This is a pre-existing issue, but does max_cmds overflow here?

The max_cmds variable is a u16. When mq_enabled is true, adding the nvme
desired queues effectively doubles the multiplier. On systems with high core
counts, this calculation could silently overflow the 65,535 limit of the u1=
6.

If the wrapped value is smaller than IBMVFC_NUM_INTERNAL_REQ, can_queue
becomes negative, which could induce failures during SCSI command allocatio=
ns.

[ ... ]
> @@ -5058,22 +5201,28 @@ static void ibmvfc_channel_setup_done(struct ibmv=
fc_event *evt)
[ ... ]
> -		active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
> -		scrqs->active_queues =3D active_queues;
> +		scsi->active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
> +		nvme->active_queues =3D be32_to_cpu(setup->num_nvme_subq_channels);
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

[Severity: High]
This isn't a bug introduced by this patch, but do these loops need bounds
checking on the VIOS-provided queue counts?

The driver assigns the untrusted num_scsi_subq_channels and
num_nvme_subq_channels values directly to active_queues. The code then uses
these values as boundary limits in the for loops to write into the scrqs
arrays.

Could a buggy or compromised VIOS returning a massive queue count cause an
out-of-bounds array write into the kernel heap?

[ ... ]
> @@ -5088,8 +5237,12 @@ static void ibmvfc_channel_setup_done(struct ibmvf=
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
Does this bypass NVMe fabric login entirely if SCSI fabric login is not
required?

If a VIOS advertises IBMVFC_SUPPORT_NVMEOF but not IBMVFC_SUPPORT_SCSI,
vhost->do_scsi_login will be false while vhost->do_nvme_login is true.
Because vhost->do_scsi_login is false, execution falls into the else block
and advances the state to QUERY.

Since NVMe fabric login is only chained sequentially from the SCSI login
completion handler, does this prevent NVMe target discovery entirely on
NVMe-only setups?

[ ... ]
> @@ -5280,8 +5442,14 @@ static void ibmvfc_npiv_login_done(struct ibmvfc_e=
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

[Severity: High]
Can stale do_scsi_login and do_nvme_login flags persist across NPIV logins
here?

The flags are conditionally set based on NPIV login capabilities, but they =
are
never cleared before checking. If a VIOS drops these capabilities in a
subsequent NPIV login (for example, following a partition migration to a VI=
OS
with different support), the flags might erroneously remain set to 1.

Could this cause the driver to issue unsupported IBMVFC_FABRIC_LOGIN MADs to
the new VIOS?

> +		if (vhost->do_enquiry)
> +			ibmvfc_channel_enquiry(vhost);
>  	} else {
>  		vhost->do_enquiry =3D 0;
>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);

[Severity: High]
If vhost->do_enquiry is false, does the host initialization stall indefinit=
ely?

The structural change placed the do_enquiry check inside the capabilities
check block. If IBMVFC_CAN_SUPPORT_CHANNELS is true but vhost->do_enquiry is
false (e.g. following a link flap), the driver sets the login flags and
completes execution of the if block.

Because it bypasses the else block, it skips setting IBMVFC_HOST_ACTION_QUE=
RY
and waking the work queue. Does this leave the host state machine permanent=
ly
stalled in IBMVFC_HOST_ACTION_INIT_WAIT with no outstanding events to advan=
ce
it?

[Severity: High]
Since both protocols are now supported, do concurrent target discovery MADs
cause a data race?

Looking at ibmvfc_discover_targets(), it appears to issue both SCSI and NVMe
target discovery MADs to the VIOS concurrently:

ibmvfc_discover_targets()
    evt =3D ibmvfc_get_disc_event(&vhost->scsi_scrqs);
    ibmvfc_send_event(evt, vhost, default_timeout);
   =20
    evt =3D ibmvfc_get_disc_event(&vhost->nvme_scrqs);
    ibmvfc_send_event(evt, vhost, default_timeout);

When the first MAD completes, ibmvfc_discover_targets_done() immediately
advances the host action to ALLOC_TGTS and wakes the allocation worker
thread.

Does the worker thread iterate over both discovery buffers while the second
MAD is still in flight? Additionally, when the slower MAD completes, its
request to set the host action is ignored because the state is no longer
INIT_WAIT, potentially dropping the targets from the slower discovery
operation.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D6
