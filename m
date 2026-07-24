Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6773B36F428
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784917005; cv=none; b=pp6KBs0OFslgnqnS1Qw/Pu2SIfEZN9/dnzWDXkMyxdUudMHwmXIRgdkGmbdoN7xq2RZgWOr9GnLjHjiIMoB+M2O3e8BNNoCUoOveUtZu9Oa5qESlNq7UZ8+u4zmFUXsoZ4RLiiMN79+O5R3IJPkQytOG/2VYNO7WZoelrJUY59E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784917005; c=relaxed/simple;
	bh=HI4ZjpFJ6gWrpx+/LFYtKw8eYugjuQL8zuG/1SOya1U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m5zqu/rV6Ur5J0A8OPWG59XfZuI1XhgActV0MxnUql/MGqb0MHt7W8daCCRqUCjkIrS8mbmDqlu1cIMQSCyBGTrGTihShohQQkvvEzzzKi9OjYObcSYftBZ/dxPmICtDFOCC8O4W01Vg0PXued+aXDTeWA0uaPqQdwiFKZi/QzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fS2bI6r2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fS2bI6r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26461F000E9;
	Fri, 24 Jul 2026 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784917004;
	bh=in479gVUAwzSiIFSaUpZwrhLMDcdLY/f/jnqhLDZLn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fS2bI6r2jfqsoVuo/SnwsTj30mhKLomNZD7qGywaJFS0N7AmfzsvqNkI9qdR0RyxD
	 BVSHKYdR2RGBOs5qcwZ5PJoLLIMhPlLX7DV+PKGzzCrHHRNx5Qsnf4FAPSRerCX2ue
	 if+GvygsLRd+nbBTxCxB61r/rYyLVZRqAJWkkGLaJA5pnXYXRBpgJ/ssEL9swbfhRg
	 s3aUiUy8DyAa4kWoGj2MOjHXpQ5ZjPKj3fkmlqxC/vySWUJU0EI8YDRKndlLL6rcQy
	 q5tvW/cbqAoX2xyGmiKEAWuK2u2Xt77fxV2h2h0ltdQcmkJdHuHiML00kwnoIssVSE
	 qEZ/N3dlI5l9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/13] scsi: fnic: Send NVMe LS requests through FDLS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-10-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-10-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:16:43 +0000
Message-Id: <20260724181643.E26461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The driver fails to transmit an FC ABTS frame when aborting or tim=
ing out an NVMe LS request, but immediately frees the local OXID, leading t=
o potential exchange corruption and cross-talk.
- [High] Missing bounds check on `ls_req->rqstlen` leads to a heap buffer o=
verflow when copying the NVMe LS request payload into the fixed-size FC fra=
me.
--

--- Patch [9]: [PATCH v6 09/13] scsi: fnic: Send NVMe LS requests through F=
DLS ---
commit c185a494dac754c12b5da24b26550de80039d738
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Send NVMe LS requests through FDLS

This commit adds the FC frame wrapper for NVMe LS requests and builds LS
request frames from the NVMe-FC transport callback. It allocates OXIDs,
tracks outstanding LS requests on the target port, and arms request timers.

Closes: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@int=
el.com/

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 697a4fdfd576f..0b05dc9698be2 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> @@ -1337,6 +1337,129 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
>  	ls_req->done(ls_req, -ETIMEDOUT);
>  }

[Severity: High]
Does this timeout handler fail to transmit an FC ABTS frame?

When an NVMe LS request times out or is aborted, the driver frees the OXID
back to the pool in nvfnic_ls_req_timeout() (and the corresponding abort
handler) but appears to skip sending an FC ABTS frame to the target to
terminate the exchange.

If the target is still processing the request, it may send a delayed respon=
se.
If the freed OXID is reused for a new request, could the target's delayed
response match the new request, misrouting the payload and causing data
corruption?

> +
> +/**
> + * nvfnic_ls_req_send - Send NVMe FC link service (LS) request
[ ... ]
> +int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
> +		  struct nvme_fc_remote_port *rport,
> +		  struct nvmefc_ls_req *ls_req)
> +{
[ ... ]
> +	frame =3D fdls_alloc_frame(iport);
> +	if (frame =3D=3D NULL) {
> +		FNIC_NVME_DBG(KERN_ERR, fnic,
> +		     "Failed to allocate frame to send NVME LS REQ");
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		return -ENOMEM;
> +	}
[ ... ]
> +	ls_req_payload =3D frame + FNIC_ETH_FCOE_HDRS_OFFSET + sizeof(*fchdr);
> +	memcpy(ls_req_payload, ls_req->rqstaddr, ls_req->rqstlen);

[Severity: High]
Does this code overflow the frame buffer?

The unchecked ls_req->rqstlen is directly used as the size parameter for
memcpy() into the fixed-size mempool buffer returned by fdls_alloc_frame().

If ls_req->rqstlen is larger than the available space in the frame, could
this cause a heap buffer overflow?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D9
