Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA99D3B443F
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999353; cv=none; b=Cr+gqdlq+x0wJR9AYudUZDJ/H4bw6xxB+7Bgf0PHWUPZRnV9qm4xuNIOxbq5ge/91iWeLxyHeWDJfJapYJoha0sPnxPiYcYB9Q8arbQdiR0fmGYe3a09bYWiNTq8p/042ZopIQNxRlvG96n52nihRwlm7o/K0mtvXfsHux1TmXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999353; c=relaxed/simple;
	bh=HgrnXyoKkdHCyXwZvY+WPJo8Xu1Sr3ugxqLpG2AGWg4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TsSo5EXKWbgdAYe5OdSuvd1TbOvCoMIdos3rK88dTCB/XLv3oUAMOg1dHUp5CYRPXBDI6GU6bO/nMtGseETmRJTE+OBkHSWLqcof5XshemnUOR9pz9QTtd5LC8TgyR6P2psamoY1FNWcdVKGyzHeag8huI1qAvtmqAi4URi3FKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktZu+1sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktZu+1sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3364C1F000E9;
	Mon, 17 Aug 2026 20:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999351;
	bh=BfGIlNrI9MC8DQUVoOqrbhGlbJMo7TGUC7o9L5OGhvQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ktZu+1sw/lrwVhGcgiW2EjbIi7LTmQMw64eXe8lW0g/6OrfN1sTnDGydSnQeVYM4k
	 1JDAVFL+2sjP7OMJk1phnZ6e54HlLxJHoYnShLeq6RMvvp4nvkEIOezQNXdi6nS2ox
	 34FmTRt24dsfToXR3LFr5iBTY6BrjGMP1/f47WjNWkeHfpiWGwQE8Yui45dFjPq4O3
	 mFQiQoPRERcMfWaA2e9r5oOJYXf7EwDXFjzzx8c+UHHv6TjDIeSAdaeX2stvGgb5o/
	 217m8ay6i1gXyvgbutG9qKApwt2buXUE11dHVYO82pCLLlrSZ+GDmS4Br8gIgKJaOe
	 GOMZy41jzsLPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 7/8] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-7-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-7-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:42:30 +0000
Message-Id: <20260817204231.3364C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] The newly added async_sub_crq is leaked and leaves its IRQ registe=
red if ibmvfc_alloc_channels() fails during SCSI channel initialization.
- [High] The async_sub_crq is completely omitted from the CRQ reset and re-=
enable sequences, breaking its lifecycle.

Pre-existing issues:
- [Critical] NULL pointer dereference in ibmvfc_channel_setup() when mq_ena=
bled =3D=3D 0.
- [High] Missing bounds checks on hypervisor-provided queue counts can lead=
 to out-of-bounds array accesses.
- [High] Error codes from request_irq() are unconditionally clobbered, sile=
ntly masking critical failures.
--

--- Patch [7]: [PATCH v6 7/8] scsi: ibmvfc: register and use asynchronous s=
ub CRQ for events ---
commit 10af0529db6ade6b831181ddc695f2e8713b38ee
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events
   =20
Wire the async sub-CRQ into the sub-CRQ lifecycle so it is allocated,
registered, and freed alongside the SCSI channel queues.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -5792,6 +5794,7 @@ static void ibmvfc_channel_setup_done(struct ibmvfc=
_event *evt)
>  		for (i =3D 0; i < nvme->active_queues; i++)
>  			nvme->scrqs[i].vios_cookie =3D
>  				be64_to_cpu(setup->channel_handles[scsi->active_queues + i]);

[Severity: High]
This is a pre-existing issue, but is it possible for an unexpectedly large
response from the hypervisor to cause out-of-bounds array accesses here?

Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_channel_setup_done(),
the unvalidated active_queues count returned by the VIOS is used directly
as a loop limit to write into the driver's nvme->scrqs and scsi->scrqs
arrays.

Could a malformed or compromised response corrupt adjacent memory?

> +		vhost->async_sub_crq.vios_cookie =3D be64_to_cpu(setup->async_sub_crq_=
handle);
> =20
>  		ibmvfc_dbg(vhost, "Using %u SCSI channels\n",
>  			   scsi->active_queues);
[ ... ]
> @@ -5851,6 +5854,7 @@ static void ibmvfc_channel_setup(struct ibmvfc_host=
 *vhost)
>  		for (i =3D 0; i < nvme_channels; i++)
>  			setup_buf->channel_handles[scsi_channels + i] =3D
>  				cpu_to_be64(nvme->scrqs[i].cookie);

[Severity: Critical]
This is a pre-existing issue, but does this loop risk a NULL pointer
dereference when mq_enabled is 0?

Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_channel_setup(),
if the driver is loaded with mq_enabled=3D0, ibmvfc_init_sub_crqs() returns
early without allocating scsi_scrqs.scrqs.=20

However, if a modern VIOS supports channels, the enquiry succeeds and sets
max_vios_scsi_channels > 0.

This would cause ibmvfc_channel_setup() to compute scsi_channels > 0 and
unconditionally execute this loop, accessing the unallocated
scsi->scrqs[i].cookie array.

> +		setup_buf->async_sub_crq_handle =3D cpu_to_be64(vhost->async_sub_crq.c=
ookie);
>  	}
> =20
>  	ibmvfc_init_event(evt, ibmvfc_channel_setup_done, IBMVFC_MAD_FORMAT);
[ ... ]
> @@ -6949,7 +6953,9 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host =
*vhost,
>  	for (i =3D 0; i < channels->max_queues; i++) {
>  		if (ibmvfc_register_channel(vhost, channels, i)) {

[Severity: High]
This is a pre-existing issue, but does ibmvfc_register_channel() silently
mask critical failures?

Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_register_channel(),
if request_irq() fails, the code jumps to the irq_failed label where it
executes:

rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);

If the hypervisor successfully frees the sub-CRQ, rc is overwritten with 0
(H_SUCCESS).=20

The function then returns 0, falsely indicating success to the caller,
which leaves the channel marked active but without an interrupt handler.

>  			for (j =3D i; j > 0; j--)
> -				ibmvfc_deregister_channel(vhost, channels, j - 1);
> +				ibmvfc_deregister_channel(
> +					vhost, channels, j - 1);
> +
>  			vhost->do_enquiry =3D 0;
>  			return;
>  		}
[ ... ]
> @@ -7004,10 +7010,27 @@ static int ibmvfc_alloc_channels(struct ibmvfc_ho=
st *vhost,
> =20
>  static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
>  {
[ ... ]
> +	/* register async_sub_crq channel */
> +	if (ibmvfc_register_channel(vhost, &vhost->scsi_scrqs, -1)) {
> +		ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +		vhost->do_enquiry =3D 0;
> +		vhost->mq_enabled =3D 0;
> +		return;
> +	}
> +
>  	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs)) {
>  		vhost->do_enquiry =3D 0;
>  		vhost->mq_enabled =3D 0;
>  		return;
>  	}

[Severity: High]
Does this error path leak the newly added async_sub_crq?

Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_init_sub_crqs(),
if ibmvfc_alloc_channels() fails during SCSI channel initialization, the
function returns early.

This skips deregistering or freeing the successfully allocated
async_sub_crq.

> @@ -7050,6 +7073,9 @@ static void ibmvfc_release_sub_crqs(struct ibmvfc_h=
ost *vhost)
>  	if (!vhost->scsi_scrqs.scrqs)
>  		return;

[Severity: High]
Could this early return bypass async_sub_crq cleanup entirely?

Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_sub_crqs(),
if scsi_scrqs allocation failed earlier, !vhost->scsi_scrqs.scrqs evaluates
to true, causing an immediate return.=20

When the module unloads, the memory for async_sub_crq is freed but its
IRQ remains registered, potentially causing a use-after-free panic if the
hardware triggers an interrupt.

> +	ibmvfc_deregister_channel(vhost, &vhost->scsi_scrqs, -1);
> +	ibmvfc_free_queue(vhost, &vhost->async_sub_crq);
> +
>  	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);

[Severity: High]
Are there lifecycle regressions during host adapter resets for async_sub_cr=
q?

Looking at drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_reset_crq(),
when the host adapter undergoes a reset, ibmvfc_reset_crq() and
ibmvfc_reenable_crq_queue() explicitly deregister and re-register the SCSI
and NVMe sub-CRQs.=20

However, async_sub_crq appears to be omitted from these sequences.

Across a reset, the async_sub_crq registration with the hypervisor becomes
stale, which would permanently break the receipt of asynchronous events
until the driver is reloaded.=20

Should async_sub_crq be included in the reset path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D7
