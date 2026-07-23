Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5E01A6816
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766693; cv=none; b=Eqa48nCV5FBf4gcK6IMvkFb8oaRS/J5P7EkelINu9VngibHOuUtB05HOJKunbfuiNIVcfzoE1U+bkU4oGBnxmXyoLZOShMO8C/HN9V7hhf7kd7nAm4oF2/qmR4M1ddeCcdTmsrxQXTSvk6Qlknq6XDb0i+oAYFo8Gg7ho18vf1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766693; c=relaxed/simple;
	bh=lzdU+EiNVKHf7khKI3/cyWXPssJtStI1N/Nd+AyhjBU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uOsndCpe7SvY4uMO4H5SxwajNG4Qj96R0DQQteDVw+LTYB9tiscJtdhLg0bJDHB3P4LVBredbqNW1umm6Evj5+RKL8sW33BpD3OsP8Iv3H7WV6peYj1W7rSSlyX//oFJkfmwFWf8pUldfJPwzCUIzzgByWXjxKz0Ry0mKT3nY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANfCHMYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANfCHMYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E141F000E9;
	Thu, 23 Jul 2026 00:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766692;
	bh=2uV1BmbU3fOB4cfC6gwZcgfmjql2bz1aNRR1Cwzw0Dc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ANfCHMYzmg2zzIQ9YIVB18seK4PkngSdc49obs8nAdmaDflpj7RJuNtsxAExAc4BP
	 sh1gi9DgP2vJVR1Ez2G73IHp+zIa9KhxYeufLe7JVhKtpRSSXEx3YG3OC2qAxM0Qli
	 JqbE8IzH/iCNvpvvL2wpDmpU6oP7mQJimZznbk4wbZTrfJ8lY3MoB3Qnng+imVg1jC
	 9jlyj1SyjaQ09+abYuiA/01jsEQoMIugt2KIrf6earEX80Ay+15jz24Z3zoX4Fgg1x
	 Rb3hzr77zhNBTlOjtKy/LBKbiZwb0rLMSMBRSaOEs2w0Nt2U4d2o5g3VFbvaLHtvjb
	 mh/RmMlIIY8yw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/33] ibmvfc: send NVMe target discovery MAD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-16-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-16-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:31:31 +0000
Message-Id: <20260723003131.E9E141F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Concurrent SCSI and NVMe target discovery requests race, causing D=
MA data races and ignored discovery responses.
- [High] NVMe targets are ignored by the host state machine and lifecycle l=
oops, leading to memory leaks and uninitialized targets.
--

--- Patch [15]: [PATCH v2 15/33] ibmvfc: send NVMe target discovery MAD ---
commit 64be8514770ed6154d989f0192b5c3cb746d46d2
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: send NVMe target discovery MAD

This commit extends target discovery to send protocol-specific discover-tar=
get
MADs for NVMe/FC. It uses a protocol-aware discovery helper to build and su=
bmit
an NVMe discover-target request, processing the returned target count into =
the
NVMe channel group's discovery buffer.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index a700e2554e692..1d2a88e9fe941 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -5011,19 +5016,30 @@ static void ibmvfc_discover_targets_done(struct i=
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
If SCSI and NVMe target discovery requests are sent concurrently, won't the
first completion trigger ibmvfc_discover_targets_done() and immediately set
the host action to IBMVFC_HOST_ACTION_ALLOC_TGTS?

This state transition wakes the worker thread, which then calls
ibmvfc_alloc_targets().

Because ibmvfc_alloc_targets() unconditionally loops over both the nvme_scr=
qs
and scsi_scrqs discovery buffers to parse targets, could the worker thread
read from a buffer while it is still being actively modified by the VIOS via
DMA for the slower, in-flight protocol?

Additionally, when the slower protocol finally completes, its transition to
ALLOC_TGTS is ignored because the host is no longer in INIT_WAIT. Does this
cause those discovered targets to be silently dropped?

[Severity: High]
When NVMe targets are successfully discovered here, they are eventually
allocated and appended to vhost->nvme_scrqs.targets by ibmvfc_alloc_target(=
).

However, looking at the host state machine loops in ibmvfc_do_work()
(specifically for IBMVFC_HOST_ACTION_TGT_INIT) and the teardown logic in
ibmvfc_link_down():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_do_work()
    case IBMVFC_HOST_ACTION_TGT_INIT:
        list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
            if (tgt->action =3D=3D IBMVFC_TGT_ACTION_INIT) {
                tgt->job_step(tgt);
                break;
            }
        }

These loops appear to only iterate over vhost->scsi_scrqs.targets.=20

Will this cause the newly populated NVMe targets to be completely ignored
for initialization?

Does this also mean these NVMe target structures will leak during driver
teardown, since ibmvfc_link_down() also only cleans up the scsi_scrqs list?

>  		break;
>  	case IBMVFC_MAD_FAILED:
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D15
