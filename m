Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A20F28000A
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 20:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752609833; cv=none; b=ivmh3vBzWwuQcxnswjCq1fOunEMe1dlm4sUl2FmbYJZ49ZeeWy33cgJlckSBfHD7XiuoGZGB8xI0xDHNgIiDHft8tiZ/csWjUM/JJ4XGaHORMcUDVmRbYZy3rTWE/XDLprKtDfQrMQ97oy/DxT02mJxazWpAK3K8/583rxmAr2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752609833; c=relaxed/simple;
	bh=9s8LdlwXdcYypN+nIN7f6z5gfWpxbZo9Ck1C0HbdBGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmJMD7xaAjFY3xVgr14doYpT4KfvKxwZinHCjcnDh0oyOae60geJjdfSPZb10aw15jsur8Td65+V97ACGWL+voC1WXW6T773KzYA6b0xNwuIRIU4HMPnBuB2kpxOeVOx0mGyuEV4WJswzN4c63+LGrVQ044Fl5k+ZK2PsBcOU38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQNBvoiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQNBvoiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D116C4CEE3;
	Tue, 15 Jul 2025 20:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752609832;
	bh=9s8LdlwXdcYypN+nIN7f6z5gfWpxbZo9Ck1C0HbdBGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kQNBvoiMDXt/n8TBQsPZnTtR5ISkLWVF9kcSyFKPI2osHvnFIxQMXWuPXh5bdOBl6
	 uYeFaRi58fxGlw3Py1QZwEmD7mpqf1wue7/Q5i2KwPzBNF9BP3UtisJn5cQCX5htxX
	 hLH+JaE1oMp/+ne5OwEUfH4VvkQRvjM9TtbyuYKxIDalu9tWIQjvilRsMsF4eZB9s/
	 sUNGlGQ6pNGVcLuRBpAffcJ4g+1Qo2jjjH4tRGAO6ETHDPfVv45BaWrSAaWXRxY4GU
	 9ebAKE4ltklBT9Sys3dBS6DAlISgRVUs6PdlNRfPWGH1hXe1Io8ysOWzklznDs0128
	 gSrvehqe2ciUg==
Date: Tue, 15 Jul 2025 14:03:50 -0600
From: Keith Busch <kbusch@kernel.org>
To: John Meneghini <jmeneghi@redhat.com>
Cc: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
	hch@lst.de, sagi@grimberg.me, axboe@kernel.dk,
	james.smart@broadcom.com, dick.kennedy@broadcom.com,
	njavali@marvell.com, linux-scsi@vger.kernel.org, hare@suse.de
Subject: Re: [PATCH v8 7/8] nvme: sysfs: emit the marginal path state in
 show_state()
Message-ID: <aHa0JpsASqGuHdOA@kbusch-mbp>
References: <20250709211919.49100-1-bgurney@redhat.com>
 <20250709211919.49100-8-bgurney@redhat.com>
 <aG7pSA6TOAANYrru@kbusch-mbp>
 <35738598-0733-408c-8597-20c3599a8973@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35738598-0733-408c-8597-20c3599a8973@redhat.com>

On Tue, Jul 15, 2025 at 03:42:32PM -0400, John Meneghini wrote:
> On 7/9/25 6:12 PM, Keith Busch wrote:
> > On Wed, Jul 09, 2025 at 05:19:18PM -0400, Bryan Gurney wrote:
> > > If a controller has received a link integrity or congestion event, and
> > > has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
> > > instead of "live", to identify the marginal paths.
> > 
> > IMO, this attribute looks more aligned to report in the ana_state
> > instead of overriding the controller's state.
> > 
> 
> We can't really do this because the ANA state is a documented protocol state.
> 
> The linux controller state is purely a linux software defined state.  Unless I am wrong, there is nothing in the NVMe specification which defines the nvme_ctrl_state.

Totally correct.
 
> This is purely a linux definition and we should be able to change is any way we want.

My kneejerk reaction is against adding new controller states. We have
state checks sprinkled about, and special states just make that more
fragile.
 
> We debated adding a new NVME_CTRL_MARGINAL state to this data structure,
> 
> enum nvme_ctrl_state {
>         NVME_CTRL_NEW,
>         NVME_CTRL_LIVE,
>         NVME_CTRL_RESETTING,
>         NVME_CTRL_CONNECTING,
>         NVME_CTRL_DELETING,
>         NVME_CTRL_DELETING_NOIO,
>         NVME_CTRL_DEAD,
> };
> 
> If you don't like the flag we can do that. However, that doesn't seem worth the effort since Hannes has this working now with a flag.

What you're describing is a "path" state, not a controller state which
is why I'm suggesting the "ana_state" attribute since nothing else
represents the path fitness. If nvme can't describe this condition, then
maybe it should?

Where does this 'FPIN LI' message originate from? The end point or
something inbetween? If it's the endpoint (or if both sides get the same
message?), then an ANA state to non-optimal should be possible, no? And
we already have the infrastructure to react to changing ANA states, so
you can transition to optimal if something gets repaired.
