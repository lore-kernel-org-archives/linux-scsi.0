Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEEA302149
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784916356; cv=none; b=ojlZur7PvT6mLwx+Mum7Mk7mTUiQF4YMZJNna095pm7SPg0hljHauDIcl0UGsAHFPfvMOxdo2DBfbRgiSPH8J+2sDoUKJ3uyF01PQ9Ui6JTFIzdvJuoUZy497iu78B3aiduH+WV6byOCfLJGkolPnfrJEP3p56mJIHXXpwU0dao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784916356; c=relaxed/simple;
	bh=ePQmg4GK0Mr78GEmxXkAmnMqsK7AOuAFBvTxiqFK9AQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EdyN0AodEzJCsuPICeuiIa+TI4G13hN9VTibz3Wls1RS2cO5Lwn01Qdm+2FrbxbS/NKZ4DyRrjE39zVIMk3xpa41eIQoZ+BQlHLOLpSytkQtSU7cgz9ACHhG/hw//xrjWhvYXowFISl5sDjhKFdGGxU3TZznIsZdkAPVmNx0Wy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHUdWDGk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHUdWDGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E3D1F000E9;
	Fri, 24 Jul 2026 18:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784916355;
	bh=eeO8bxmOOL+Y3Lrw9ft3LwasddzYLXNpyCfo7mvNM/Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iHUdWDGkMbhJnvMx7iMjo4ajjQR0WDPAw7ErERLJ1p3PE18b8o9gvmUxnqdR1Yo0w
	 SFmXGZeu53BsnMBZFK2qG/kZipuOdGhzdgzpzcGfiXrpV8nSpm38GGs+hhoclHZK/e
	 h4vVyJ7c86Z5Ws35R8L9F7Nt4zi03eZjLuSSmR91ATm3xM1l0PSpvRON9rylJCyamQ
	 7r1UzHNOxZT8Km8ZQI20FbBge0n6uX6VDf1SJq95q02+waHf7GH2vyTY/UV1fwUMLe
	 YAipmDiF00zTKvZqYBmCPCCYJTXp60RW6mYGVYSRs2DmuYeYwjC5anh/9nvGodPswB
	 HMVEPNjRG8NUQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 04/13] scsi: fnic: Advertise NVMe initiator service
 parameters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-5-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-5-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:05:54 +0000
Message-Id: <20260724180554.C2E3D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The commit sets `iport->service_params` to advertise NVMe initiato=
r service parameters, but this field is never read. The actual PRLI frame i=
s hardcoded to advertise FCP capabilities instead.
--

--- Patch [4]: [PATCH v6 04/13] scsi: fnic: Advertise NVMe initiator servic=
e parameters ---
commit ed8174a20b4f25dad8815dfbe2e3def2feb4906c
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Advertise NVMe initiator service parameters

This commit sets FC service parameters according to the selected initiator
role. It keeps FCP retry and confirmation bits for FCP initiators, and
advertises NVMe initiator and SLER bits for NVMe initiators.

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 3a365ea455b1a..5850d51b0e8f6 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -1016,11 +1016,16 @@ static int fnic_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
>  	iport->max_flogi_retries =3D fnic->config.flogi_retries;
>  	iport->max_plogi_retries =3D fnic->config.plogi_retries;
>  	iport->plogi_timeout =3D fnic->config.plogi_timeout;
> -	iport->service_params =3D
> -		(FNIC_FCP_SP_INITIATOR | FNIC_FCP_SP_RD_XRDY_DIS |
> -		 FNIC_FCP_SP_CONF_CMPL);
> -	if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
> -		iport->service_params |=3D FNIC_FCP_SP_RETRY;
> +	if (IS_FNIC_FCP_INITIATOR(fnic)) {
> +		iport->service_params =3D (FNIC_FCP_SP_INITIATOR |
> +				FNIC_FCP_SP_RD_XRDY_DIS | FNIC_FCP_SP_CONF_CMPL);
> +		if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
> +			iport->service_params |=3D FNIC_FCP_SP_RETRY;
> +	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
> +		iport->service_params =3D (FNIC_NVME_SP_INITIATOR);
> +		if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
> +			iport->service_params |=3D FNIC_NVME_SP_SLER;
> +	}

[Severity: High]
Is iport->service_params actually used when sending the PRLI request?

Looking at fdls_send_tgt_prli() in drivers/scsi/fnic/fdls_disc.c, it appears
the PRLI payload hardcodes the FCP parameters directly:

    .sp =3D {.spp_type =3D 0x08, .spp_flags =3D 0x0020,
           .spp_params =3D cpu_to_be32(0xA2)}

If the service_params field is ignored, will the NVMe initiator feature fall
back to advertising FCP capabilities (type 0x08) instead of NVMe, preventing
successful discovery and login for NVMe targets?

> =20
>  	iport->boot_time =3D jiffies;
>  	iport->e_d_tov =3D fnic->config.ed_tov;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D4
