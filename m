Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF098370AC7
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179537; cv=none; b=QRRpKf5CPgKGkKVunYOQocXkCkTXFhyQLHyGmKwnc2HcMv5wPHK6kmG+syrCal44rMvuwMmJZX41zFM2B0TsroEfHybnr0ei5G4b3Nsn8RHlrvA79pZ92skON6jTkdKkbB8nbQo8wwsv4dCbBNXHa8oKZMTQidyNno+SdcizTAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179537; c=relaxed/simple;
	bh=Aib2o8GvXani+LOJgZ4xMjRe2FfsvVr+gQvdVluYYIs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eA8PBWxSaFgF8ZCUjj5oSKZ3K2FiXeW00ey9VJnTytGeeN4aDHwWK36VmKLimPhPT0Fcb5zAYlul6oUOfsyJ6wbGqYBdUXtvnnj5xdK97tSXHBB2uVjl3t6ncEFdzkxaooeMIG/sbQ+PSRW5EFH6PWs8oXG1PPmXn/sV1jXbr6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apBv7Nx3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apBv7Nx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781341F000E9;
	Tue, 23 Jun 2026 01:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179536;
	bh=f4+n3RMxnMvYWQ7NgT/T8SEDEp4kxnRTi+1IZjIrQ/o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=apBv7Nx3BtdOnS6N7NGHsRlZkrhvW1xLBScNW85i1fBc3r5NaYu6N71U1zBOHwyX8
	 POeYk8VcW94Q1iTgHUeAGsr9uWLAHF2n9Mbh4c3ooocDVog8/ctRG9gVBPfI+dO3zK
	 NOYW85OIjnto3mgZkQqFY6TbFw3986nW0waWnOPkCJ1nTX/g9sN59IY8LHHW1M/qDG
	 tBhlZB7X03uVSncAtuQM3Tp137k3sj816Q+ciP+wzb92lLfpJub9hvXmEX1Fw7l72p
	 S1SpnqGQHUR5z0ryJOnGPXXso+XgGv7twNsD6ykFlJ/8Uio8V61twojXvLx9e7/vnO
	 xPDqHaR9s91cA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 11/29] ibmvfc: send NVMe target discovery MAD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-12-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-12-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:52:15 +0000
Message-Id: <20260623015216.781341F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Parallel SCSI and NVMe discover targets MADs race to advance the h=
ost initialization state machine, causing the slower protocol's targets to =
be permanently ignored and breaking retry handling.
- [Low] The newly added `proto_type` array is missing the `static` keyword,=
 making it a globally visible symbol.
--

commit e89ce7e682793b58e5019c746ffde18602fe635b
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: send NVMe target discovery MAD

This commit extends target discovery to send protocol-specific
discover-target MADs for NVMe/FC. It introduces a parallel discovery flow
for NVMe alongside SCSI targets.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index efac82c48258a..53480d150042e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -173,6 +173,11 @@ static const struct {
>  	{ IBMVFC_FC_SCSI_ERROR, IBMVFC_COMMAND_FAILED, DID_ERROR, 0, 1, "PRLI t=
o device failed." },
>  };
> =20
> +const char *proto_type[] =3D {
> +	"SCSI",
> +	"NVMe",
> +};

[Severity: Low]
This isn't a bug, but can this array be declared as static? It is currently
exposed to the global kernel namespace which could lead to linker
collisions.

> +
>  static void ibmvfc_npiv_login(struct ibmvfc_host *);
>  static void ibmvfc_tgt_send_prli(struct ibmvfc_target *);
>  static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *);

[ ... ]

> @@ -5001,19 +5006,30 @@ static void ibmvfc_discover_targets_done(struct i=
bmvfc_event *evt)
>  {
>  	struct ibmvfc_host *vhost =3D evt->vhost;
>  	struct ibmvfc_discover_targets *rsp =3D &evt->xfer_iu->discover_targets;
> +	struct ibmvfc_channels *channels;
>  	u32 mad_status =3D be16_to_cpu(rsp->common.status);
> +	u32 opcode =3D be32_to_cpu(rsp->common.opcode);
>  	int level =3D IBMVFC_DEFAULT_LOG_LEVEL;
> =20
> +	if (opcode =3D=3D IBMVFC_DISC_TARGETS)
> +		channels =3D &vhost->scsi_scrqs;
> +	else
> +		channels =3D &vhost->nvme_scrqs;
> +
>  	switch (mad_status) {
>  	case IBMVFC_MAD_SUCCESS:
> -		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
> -		vhost->scsi_scrqs.num_targets =3D min_t(u32, be32_to_cpu(rsp->num_writ=
ten),
> -						      max_targets);
> +		ibmvfc_dbg(vhost, "Discover %s Targets succeeded\n",
> +			   proto_type[channels->protocol]);
> +		channels->num_targets =3D min_t(u32, be32_to_cpu(rsp->num_written),
> +					      max_targets);
> +		ibmvfc_dbg(vhost, "%d %s targets found\n", channels->num_targets,
> +			   proto_type[channels->protocol]);
>  		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);

[Severity: High]
Does this code create a race condition between the SCSI and NVMe discovery
MADs?

If both SCSI and NVMe discoveries are running asynchronously, whichever MAD
completes first will call ibmvfc_set_host_action() and advance the host
state from IBMVFC_HOST_ACTION_INIT_WAIT to IBMVFC_HOST_ACTION_ALLOC_TGTS.

When the slower MAD subsequently completes, ibmvfc_set_host_action()
will ignore the transition to IBMVFC_HOST_ACTION_ALLOC_TGTS because the
state is no longer IBMVFC_HOST_ACTION_INIT_WAIT. This causes the targets
from the slower protocol to be permanently ignored.

Additionally, if the first MAD fails, could the state machine revert to
IBMVFC_HOST_ACTION_INIT and issue a new batch of discovery commands
while the slower MAD is still in-flight?

>  		break;
>  	case IBMVFC_MAD_FAILED:
>  		level +=3D ibmvfc_retry_host_init(vhost);

[ ... ]

> @@ -5074,9 +5090,29 @@ static void ibmvfc_discover_targets(struct ibmvfc_=
host *vhost)
>  	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
> =20
>  	if (!ibmvfc_send_event(evt, vhost, default_timeout))
> -		ibmvfc_dbg(vhost, "Sent discover targets\n");
> +		ibmvfc_dbg(vhost, "Sent discover SCSI targets\n");
>  	else
> -		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
> +		goto link_down;
> +
> +	if (!ibmvfc_nvme_active(vhost))
> +		return;
> +
> +	evt =3D ibmvfc_get_disc_event(&vhost->nvme_scrqs);
> +	if (!evt) {
> +		ibmvfc_log(vhost, level, "Discover NVMe Targets failed: no available e=
vents\n");
> +		ibmvfc_hard_reset_host(vhost);
> +		return;
> +	}
> +
> +	if (!ibmvfc_send_event(evt, vhost, default_timeout))
> +		ibmvfc_dbg(vhost, "Sent discover NVMe targets\n");
> +	else
> +		goto link_down;
> +
> +	return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D11
