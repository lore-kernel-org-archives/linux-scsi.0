Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEEE314A79
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782145488; cv=none; b=gZt4wDqdYh1JGj47HB6ZqriYclo01txXzWywXfM2C2yS7RaZotgCXhRAaJAIs+vSk9CfQsRp3I1RmCS+96jaeyRPaZtHSezmeK2TrsARQsQXJUGmV3eY6fb9kxD5ZjZH0HCFZwHWO53KUN4dMM2mvHfM23DtMmSCSYJIDRhnAWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782145488; c=relaxed/simple;
	bh=mxwyew6Adx/LFnxjvZk/R6qTu7TikJg4khgEigZBuSs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LFhf+jBb1HN99wWQOpaCUOLiAg/r5SlcVG120ErNAhuxXZc0qq7y8w1hfu8+G6kXhEPf+loBLapciECrKOzRJQtwQtjFaOHOe3YM8IikvleFN0kMAQpLR7FbwQttDqr7cd2AIR9V36KpS9BKMD6+QyttCdbCHXtSimOhg6Z1III=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTcPlTC4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTcPlTC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5E91F00A3A;
	Mon, 22 Jun 2026 16:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782145487;
	bh=/z7nlAx4iJoWDvJOEQqK5L1XhssxRevuKibThVulNWw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UTcPlTC43rreIG2kqEVEqXj/zoXhHdVGaLrf7TmPvXFPrCWVd32YGgjegIaph8i4X
	 47Tk/ZKhwU1GrHd0VZmSbzD6GHGSbS/VTgDdcaAtZ4GEWKPAwAsfBbczfnH0KwgBFn
	 Y3IqobRRFXRszPmOST6Qd1Tc+RY8GHxt/nfso2G6j/7ujqaoL7XRG7I1a14f5L/Y8I
	 qtbU+OsMxrfr/awGesrMpq48fi/GDtNudg3UIsFbag9WasbqVoFJJAt2SCu+pNuFGA
	 qSvww3b6+XMp0fqYFEwAMKKWj3kEzpLB+zUUZ9w7iGBmj7GOdopXL6KeQHrS+Obfom
	 EQFgs6IhSbPbQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haoxiang Li" <haoxiang_li2024@163.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260622160028.1240496-1-haoxiang_li2024@163.com>
References: <20260622160028.1240496-1-haoxiang_li2024@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 22 Jun 2026 16:24:46 +0000
Message-Id: <20260622162447.6A5E91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Stale `c->device` pointer dereference in `hpsa_ciss_submit` an=
d `hpsa_ioaccel_submit` error paths, leading to Use-After-Free.
- [High] Pre-existing DMA mapping and SG chain block leak in `hpsa_ciss_sub=
mit` when `dev->in_reset` is true.
- [High] Unbalanced decrement of `dev->commands_outstanding` on command que=
ueing failure.
--

commit bdf6566123989a4c6b9d8e36ab36f21d9c3079ed
Author: Haoxiang Li <haoxiang_li2024@163.com>

scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path

If phys_disk->in_reset is set, the function returns directly without
undoing the resources acquired for the command. Add the missing error
cleanup by unmapping the IOACCEL2 SG chain block when needed, unmapping
the SCSI command, and dropping the outstanding IOACCEL command count
before returning.

> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index a1b116cd4723d..8edad1830abe4 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -5017,6 +5017,10 @@ static int hpsa_scsi_ioaccel2_queue_command(struct=
 ctlr_info *h,
> =20
>  	if (phys_disk->in_reset) {
>  		cmd->result =3D DID_RESET << 16;
> +		atomic_dec(&phys_disk->ioaccel_cmds_out);
> +		scsi_dma_unmap(cmd);
> +		if (use_sg > h->ioaccel_maxsg)
> +			hpsa_unmap_ioaccel2_sg_chain_block(h, cp);
>  		return -1;
>  	}

[ ... ]

> static int hpsa_ciss_submit(struct ctlr_info *h,
> 			    struct CommandList *c,
> 			    struct scsi_cmnd *cmd,
> 			    struct hpsa_scsi_dev_t *dev)
> {
[ ... ]
> 	if (hpsa_scatter_gather(h, c, cmd) < 0) { /* Fill SG list */
> 		hpsa_cmd_resolve_and_free(h, c);
> 		return SCSI_MLQUEUE_HOST_BUSY;
> 	}
>=20
> 	if (dev->in_reset) {
> 		hpsa_cmd_resolve_and_free(h, c);
> 		return SCSI_MLQUEUE_HOST_BUSY;
> 	}

[Severity: High]
This is a pre-existing issue, but I noticed a similar DMA mapping leak here
in hpsa_ciss_submit(). If dev->in_reset is true, the function returns=20
SCSI_MLQUEUE_HOST_BUSY but hpsa_cmd_resolve_and_free() does not unmap the=20
scatter-gather list previously established by hpsa_scatter_gather(). Does=20
this cause a leak of the IOMMU mappings or bounce buffers when the midlayer=
=20
retries?

[ ... ]

> static struct CommandList *cmd_tagged_alloc(struct ctlr_info *h,
> 					    struct scsi_cmnd *scmd)
> {
[ ... ]
> 	atomic_inc(&c->refcount);
> 	hpsa_cmd_partial_init(h, idx, c);
>=20
> 	/*
> 	 * This is a new command obtained from queue_command so
> 	 * there have not been any driver initiated retry attempts.
> 	 */
> 	c->retry_pending =3D false;
>=20
> 	return c;
> }

[Severity: Critical]
This is also a pre-existing issue, but does cmd_tagged_alloc() return a=20
command block without clearing the c->device pointer? Neither this function
nor hpsa_cmd_partial_init() clear c->device. If an early error occurs in=20
hpsa_scsi_queue_command() (like a failure in hpsa_ioaccel_submit() or=20
hpsa_ciss_submit()) before c->device is reassigned to the current device,=20
the cleanup path calls hpsa_cmd_resolve_and_free():

> static void hpsa_cmd_resolve_events(struct ctlr_info *h,
> 		struct CommandList *c)
> {
> 	struct hpsa_scsi_dev_t *dev =3D c->device;
[ ... ]
> 	if (dev) {
> 		atomic_dec(&dev->commands_outstanding);

[Severity: High]
This is a pre-existing issue, but if c->device is stale, will this
dereference a potentially freed device structure and cause a use-after-free
when calling atomic_dec()?

Additionally, does this unconditionally decrement dev->commands_outstanding
even if it was never incremented for this command? The counter is only
incremented inside __enqueue_cmd_and_start_io(), so an early error could
cause an unbalanced decrement and an underflow.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260622160028.1240=
496-1-haoxiang_li2024@163.com?part=3D1
