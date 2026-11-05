Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905435;
	b=R2uJuWWChzqdy+YO+i1k1WIDj8Jv+dy3+OOQCSK8O4Wh5uZaFWTfSEERCRlQvfB0VOHb
	 nkx1H3wb2/pWCVdGN/TqSLKbHj4ovtm6IEzBDj3L/9sZI7ZXj22sKI7k1s60Og35rL/IM
	 YzeaGw3zkLl0TQ+qQL05vW+wzT2Md/0CBCaOT43yHz76ZdQDRIHgP8BKbxyzR3QfcLFmv
	 pAz2LAEo5bjmkcf6njTGKgxZv5xP6sxDVGtodVW7pPvShMkdQ+o0TrkFhlnlagnn1qXnI
	 gWbrbgygf5up+HZ1/eBvhtJz2qcxlUWviZ9KH1nROazNmKaj4MoZkO+6uV7TmMs7RtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905435;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5Pg+4ps7GJ45taL+Ps+FphHy3jwSgED4+VaYTTwE0W0=;
	b=uQHc8U6sqF8TNtC5bVV3nXu1Bjf3r8/NU+hHEdBBFIU38MMD00JyIu8O5YKcI5Avn93h
	 3gtHqlHx/6EK7QLS6z7tP0QeQuFomolbxuyVeJOjdC3AyX3uD1giJ+nd9NOcxrPvDiCeH
	 dX+G9WCQHi2zTw0AmcxVU0nlSOHAVamsr/CureLt39y+QhHRbDGbA74M57/659S0oFbWV
	 4rkeXpVe5xF6DSYZ3J70h0sH8pOWZefzVSyg2D7cKAjFrOPTj9UdQrvbxnhu0tRJBLoyK
	 KYse2uducIcGAH9rD3P7b/x5A831unbBdLciWTWp3UTC8TmFKBS7Dy3j784sHhknuxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G8ESRCTc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425B2606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G8ESRCTc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A751F000C1;
	Thu,  5 Nov 2026 19:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793905434;
	bh=5Pg+4ps7GJ45taL+Ps+FphHy3jwSgED4+VaYTTwE0W0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G8ESRCTcrsCT4kxmpHAUGottHsY3Yn/In7DlOpvZ4H1X6bEimHb5/gxLftk6sNymA
	 VbIM9QGDQk8YH6kM3ovEJzk4wrXLsxysW3Bx4XDVQC3Pj+TUAg9yFCApW8rxGmA+pD
	 AcAZBpelX/COa4FgDBKBH3k+HTYh/g9A4MEZyeiXPFWwzPY46Z6kKFINUgpJyzDYmB
	 glezjeN6SzZjRvEDFHf832ztaYhaZpGa2+ZQZTHo/xpeyf0/pwNeorYVQfdTpzhM82
	 wvndVdirzK2rNWwU2Ij6QC4nZBcQDrPuDAum/yOYkzwebUlrBZ6puU//aEF5jIMDE6
	 BY5TbdYXLp9qA==
Message-ID: <sashiko-outbox-199806@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 12/13] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-12-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
 <20261105-ibmvfc-fpin-support-v18-12-d683b74736a3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 19:03:54 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] scsi: ibmvfc: uninitialized tgt deref in ibmvfc_process_async_=
work()
- [High] scsi: ibmvfc: NULL crq deref in ibmvfc_process_async_work()
- [High] scsi: ibmvfc: NULL dereference of nvme->scrqs in channel setup
- [Medium] scsi: ibmvfc: stale active_queues after ibmvfc_dereg_sub_crqs()
--

commit c8e05d927003244a19b25c7ef71f73f56b0341c8
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This commit wires the asynchronous sub-CRQ into the ibmvfc sub-CRQ
lifecycle so it is allocated, registered, configured during channel setup,
and freed alongside the SCSI and NVMe channel queues, while advertising
IBMVFC_USE_ASYNC_SUBQ and IBMVFC_CAN_HANDLE_FPIN capabilities during login.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 7b52401ae4d52..6e1ecf6891c71 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -988,8 +989,17 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_h=
ost *vhost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> -	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
> -	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
> +		spin_lock_irqsave(&vhost->host->host_lock, flags);
> +		vhost->do_enquiry =3D 0;
> +		vhost->mq_enabled =3D 0;
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +	}
> =20
>  	return rc;
>  }

[ ... ]

> @@ -1044,8 +1055,17 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vh=
ost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> -	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
> -	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs) ||
> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs) ||
> +	    ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->async_scrqs);
> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
> +		ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
> +		spin_lock_irqsave(&vhost->host->host_lock, flags);
> +		vhost->do_enquiry =3D 0;
> +		vhost->mq_enabled =3D 0;
> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +	}
> =20
>  	return rc;
>  }

[Severity: Medium]
When ibmvfc_reg_sub_crqs() fails in ibmvfc_reenable_crq_queue() or
ibmvfc_reset_crq(), all three channel sets are deregistered via
ibmvfc_dereg_sub_crqs() and vhost->do_enquiry and vhost->mq_enabled are
cleared to fall back to single-queue mode, but channels->active_queues is
never reset to 0:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_dereg_sub_crqs() {
	if (!channels->scrqs)
		return;

	for (i =3D 0; i < channels->max_queues; i++)
		ibmvfc_deregister_channel(vhost, channels, i);
}

Because clearing vhost->mq_enabled and vhost->do_enquiry causes subsequent
NPIV login to skip ibmvfc_channel_setup_done(), active_queues remains
non-zero on the deregistered channel sets.

In drivers/scsi/ibmvscsi/ibmvfc-nvme.c, ibmvfc_nvme_create_queue() checks
only active_queues:

	if (!vhost->nvme_scrqs.active_queues)
		return -ENODEV;

Won't leaving active_queues non-zero after deregistering the sub-CRQs cause
ibmvfc_nvme_create_queue() to bind NVMe queues to deregistered nvme_scrqs
entries that no longer have hypervisor registrations or IRQ handlers?

> @@ -1586,9 +1606,11 @@ static void ibmvfc_set_login_info(struct ibmvfc_ho=
st *vhost)
> =20
>  	if (vhost->mq_enabled || vhost->using_channels) {
>  		login_info->capabilities |=3D cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
> +		login_info->capabilities |=3D cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
> +		login_info->capabilities |=3D cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
> +		login_info->capabilities |=3D cpu_to_be64(IBMVFC_YES_SCSI);
>  		if (vhost->nvme_enabled) {
>  			login_info->capabilities |=3D cpu_to_be64(IBMVFC_YES_NVMEOF);
> -			login_info->capabilities |=3D cpu_to_be64(IBMVFC_YES_SCSI);
>  			login_info->capabilities |=3D cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
>  		}
>  	}

[Severity: Critical]
Now that ibmvfc_set_login_info() advertises IBMVFC_USE_ASYNC_SUBQ and
IBMVFC_CAN_HANDLE_FPIN, the VIOS can deliver FPIN events that are queued to
ibmvfc_process_async_work() via
ibmvfc_interrupt_async_subq()->ibmvfc_drain_async_subq()->ibmvfc_handle_asy=
nc().

In ibmvfc_process_async_work(), there appear to be two regressions when an
FPIN event arrives with all-zero target identifiers (!scsi_id && !wwpn &&
!node_name && !assoc_id), such as a host-scope IBMVFC_AE_FPIN_LINK_CONGESTED
or IBMVFC_AE_FPIN_CONGESTION_CLEARED event:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_process_async_work() {
	struct ibmvfc_async_sub_crq *subq =3D NULL;
	struct ibmvfc_async_work *aw;
	struct ibmvfc_async_crq *crq =3D NULL;
	struct ibmvfc_target *tgt;
	...
	if (aw->event.type =3D=3D IBMVFC_ASYNC_CRQ_SUB) {
		subq =3D &aw->event.subq;
		...
	} else {
		crq =3D &aw->event.async_crq;
		...
	}

	if (!scsi_id && !wwpn && !node_name && !assoc_id) {
		if (fpin_status =3D=3D IBMVFC_AE_FPIN_LINK_CONGESTED ||
		    fpin_status =3D=3D IBMVFC_AE_FPIN_CONGESTION_CLEARED)
			fpin =3D ibmvfc_basic_fpin_to_desc(crq,
					cpu_to_be64(fc_host_port_name(vhost->host)), 0);
		goto send_fpin;
	}
	...
send_fpin:
	...
	if (tgt)
		kref_put(&tgt->kref, ibmvfc_release_tgt);
}

First, tgt is declared without being initialized to NULL, and the
(!scsi_id && !wwpn && !node_name && !assoc_id) branch jumps directly to
send_fpin before tgt is assigned by ibmvfc_find_target(), so kref_put()
dereferences an uninitialized stack pointer.

Second, when aw->event.type =3D=3D IBMVFC_ASYNC_CRQ_SUB, crq is NULL, but t=
hat
same branch unconditionally calls ibmvfc_basic_fpin_to_desc(crq, ...)
instead of checking crq vs subq and calling ibmvfc_full_fpin_to_desc(subq,
...), which immediately dereferences crq->fpin_status in
ibmvfc_basic_fpin_to_desc().

Can tgt be initialized to NULL and this branch dispatch between
ibmvfc_basic_fpin_to_desc() and ibmvfc_full_fpin_to_desc() like the other
call sites in ibmvfc_process_async_work()?

> @@ -5907,6 +5929,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  {
>  	struct ibmvfc_host *vhost =3D evt->vhost;
>  	struct ibmvfc_channel_setup *setup =3D vhost->channel_setup_buf;
> +	struct ibmvfc_channels *async =3D &vhost->async_scrqs;
>  	struct ibmvfc_channels *scsi =3D &vhost->scsi_scrqs;
>  	struct ibmvfc_channels *nvme =3D &vhost->nvme_scrqs;
>  	u32 mad_status =3D be16_to_cpu(evt->xfer_iu->channel_setup.common.statu=
s);
> @@ -5920,8 +5943,11 @@ static void ibmvfc_channel_setup_done(struct ibmvf=
c_event *evt)
>  		ibmvfc_dbg(vhost, "Channel Setup succeeded\n");
>  		flags =3D be32_to_cpu(setup->flags);
>  		vhost->do_enquiry =3D 0;
> -		scsi->active_queues =3D be32_to_cpu(setup->num_scsi_subq_channels);
> -		nvme->active_queues =3D be32_to_cpu(setup->num_nvme_subq_channels);
> +		scsi->active_queues =3D min(be32_to_cpu(setup->num_scsi_subq_channels),
> +					  scsi->max_queues);
> +		nvme->active_queues =3D min(be32_to_cpu(setup->num_nvme_subq_channels),
> +					  nvme->max_queues);
> +		async->active_queues =3D (async->scrqs && setup->async_sub_crq_handle)=
 ? 1 : 0;
> =20
>  		if (flags & IBMVFC_CHANNELS_CANCELED) {
>  			ibmvfc_dbg(vhost, "Channels Canceled\n");
> @@ -5937,6 +5963,8 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
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
> @@ -5971,6 +5999,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host=
 *vhost)
>  	struct ibmvfc_event *evt =3D ibmvfc_get_reserved_event(&vhost->crq);
>  	struct ibmvfc_channels *scsi =3D &vhost->scsi_scrqs;
>  	struct ibmvfc_channels *nvme =3D &vhost->nvme_scrqs;
> +	struct ibmvfc_channels *async =3D &vhost->async_scrqs;
>  	unsigned int scsi_channels =3D
>  		min(scsi->desired_queues, vhost->max_vios_scsi_channels);
>  	unsigned int nvme_channels =3D
> @@ -5998,6 +6027,9 @@ static void ibmvfc_channel_setup(struct ibmvfc_host=
 *vhost)
>  				cpu_to_be64(nvme->scrqs[i].cookie);
>  	}
> =20
> +	if (async->scrqs)
> +		setup_buf->async_sub_crq_handle =3D cpu_to_be64(async->scrqs[0].cookie=
);
> +
>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
>  	mad =3D &evt->iu.channel_setup;
>  	memset(mad, 0, sizeof(*mad));

[ ... ]

> @@ -7191,9 +7223,74 @@ static void ibmvfc_release_channels(struct ibmvfc_=
host *vhost,
>  	}
>  }
> =20
> +/**
> + * ibmvfc_init_sub_crqs - Allocate and register all sub-CRQ channel sets
> + * @vhost:	ibmvfc host struct
> + *
> + * Allocates and registers the async, SCSI, and (if nvme_enabled) NVMe
> + * sub-CRQ channel sets in order. Returns immediately if mq_enabled is 0.
> + *
> + * On failure at any stage, previously registered and allocated channel =
sets
> + * are deregistered and freed in reverse order, and vhost->mq_enabled and
> + * vhost->do_enquiry are cleared under host_lock to prevent the host sta=
te
> + * machine from stalling in IBMVFC_HOST_ACTION_INIT_WAIT.
> + */
> +static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
> +{
> +	unsigned long flags;
> +
> +	ENTER;
> +	if (!vhost->mq_enabled)
> +		return;
> +
> +	/* register async_sub_crq channel */
> +	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
> +		goto out;
> +
> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs))
> +		goto release_async_sub_crq;
> +
> +	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
> +		goto deregister_async_sub_crq;
> +
> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs))
> +		goto release_scsi_sub_crqs;
> +
> +	if (vhost->nvme_enabled) {
> +		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
> +			vhost->nvme_enabled =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		} else if (ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
> +			ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
> +			vhost->nvme_enabled =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		}
> +	}

[Severity: High]
In ibmvfc_probe(), vhost->nvme_scrqs.desired_queues and
vhost->nvme_scrqs.max_queues are initialized to non-zero values even when
vhost->nvme_enabled is 0:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_probe() {
	vhost->nvme_enabled =3D mq_enabled ? nvme_enabled : 0;
	vhost->nvme_scrqs.desired_queues =3D min(max_nvme_queues, nr_nvme_channels=
);
	vhost->nvme_scrqs.max_queues =3D max_nvme_queues;
}

When vhost->nvme_enabled is 0, or when allocating or registering
vhost->nvme_scrqs fails in ibmvfc_init_sub_crqs() after async_scrqs and
scsi_scrqs succeed, vhost->nvme_scrqs.scrqs remains NULL while
vhost->mq_enabled and vhost->do_enquiry remain 1 and desired_queues and
max_queues remain non-zero.

During channel enquiry and setup
(ibmvfc_channel_enquiry_done()->ibmvfc_channel_setup()), if the VIOS reports
num_nvme_subq_channels > 0, ibmvfc_channel_setup() computes a non-zero
nvme_channels without checking vhost->nvme_enabled or nvme->scrqs:

	for (i =3D 0; i < nvme_channels; i++)
		setup_buf->channel_handles[scsi_channels + i] =3D
			cpu_to_be64(nvme->scrqs[i].cookie);

Similarly, in ibmvfc_channel_setup_done(), nvme->active_queues is clamped to
nvme->max_queues without checking whether nvme->scrqs is non-NULL, which
then dereferences nvme->scrqs[i].vios_cookie in the loop.

Should ibmvfc_channel_setup() and ibmvfc_channel_setup_done() guard the
nvme->scrqs accesses (or zero desired_queues and max_queues when
nvme_enabled is 0) in the same way async->scrqs is guarded?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-ibmvfc-fpi=
n-support-v18-0-d683b74736a3@linux.ibm.com?part=3D12
