Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AF82D6E72;
	Sat,  5 Sep 2026 03:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579870; cv=none; b=s0Ogm9zSBQ5rvYR76WywW2dsyZ7GNrxcvNdRKq1xdAEYdJwMhJN6Uj2rnBGmgsJx+DTVY8xX1HP+D2inD1O24XPgjruWTiCMCKqSQIYeRu2kOpTzoN0JUmVNDUDOGYRRk/n90itRTxhBXgSTiqAlTSsgP1PYbAnY3bcwXJGbBc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579870; c=relaxed/simple;
	bh=nXVRBtzp0Z7NhYaTHGtdrGrHUMR8LizVnY1xuYrrY9w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ID/2CVQkwJY8nZK7npVoU50DpqsQiyuYWx3irJs4kvtVZBfReoZox55nzZay32VHHtvjF85RcMDvBeO//G6OECuR+Z4GFCD8miCLOQaqI9ntLoqkGinnzvVh2gXM9auC59w5RmiN+d6zNag8+2r+wpim/Jf5SAsWtko9izwzJno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DbAuFQVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DbAuFQVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0EA1F00A3D;
	Sat,  5 Sep 2026 03:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579868;
	bh=uuHBcTiv9GdUQMrjwrWKqOgBCym5A9KLpeFZ1AvEZCA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DbAuFQVkMCJTtT/uGL77FeSPWAjNjXpNWkV15ATcfAoV/Scc4+fp5Vt2++CglR+gX
	 YJdpQ24fYL4w8tLKMOKyzXZTXAQ1bN3UxK3bgLbtJkwYI5et68W5pt1mUmtEkRP1Ti
	 sR/q5m2uH60jaa2JdJvRl4Ud6WqnI4mQD4Hj7NO3OUia7bzDb7R8ek6N5WLEr/Yppb
	 UvqrhkF4EFOhp2Hk0BcrH7AGrU496pBjS/UEq7jh9yzacyVvyeVzTfsUQurTXe/w3W
	 9H6mgXiNFdkRKiFEOVgLsF/9W4QTUK75Gdqi8KASPEhNxPYyuhMQNFO5ZsJM17qXSJ
	 Bh0zqzLkRs/pw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260905032224.509860-31-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:44:27 +0000
Message-Id: <20260905034428.4C0EA1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Sense data built on the `srp_transfer_data` error path is disc=
arded because `se_cmd->scsi_status` is not set, causing a false SUCCESS res=
ponse to be sent.
--

commit 7b949e6613d985b08c96328371e1a1b2e1e41b6d
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ibmvscsi_tgt: use 16-bits defined sense codes

This commit refactors the IBM virtual SCSI target driver to use
scsi_set_sense_buffer() and replaces all hard-coded additional sense
codes with enum values. It aims to improve code clarity and testing
without any functional changes.

> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
> index 61f6828007654..e2af90b6da39b 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3757,9 +3757,8 @@ static int ibmvscsis_queue_data_in(struct se_cmd *s=
e_cmd)
>  		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
>  		se_cmd->scsi_sense_length =3D 18;
>  		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
> -		/* Logical Unit Communication Time-out asc/ascq =3D 0x0801 */
> -		scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> -					0x08, 0x01);
> +		scsi_set_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> +				      LU_COMMUNICATION_TIMEOUT);

[Severity: Critical]
This isn't a bug introduced by this patch, but it appears there is a
pre-existing flaw in how the sense data is handled here.

Because se_cmd->scsi_status is not updated to SAM_STAT_CHECK_CONDITION
when srp_transfer_data() fails, srp_build_response() will call
ibmvscsis_fast_fail() which sees the unchanged status of 0. As a result,
the block responsible for handling sense data in srp_build_response() is
skipped:

	rsp->status =3D ibmvscsis_fast_fail(vscsi, cmd);
	if (rsp->status) {
		...
		if (se_cmd->scsi_sense_length && se_cmd->sense_buffer) {
			rsp->sense_data_len =3D cpu_to_be32(se_cmd->scsi_sense_length);

This causes a SUCCESS response to be sent instead of a CHECK CONDITION,
which could lead the initiator to consume uninitialized or stale data from
its receive buffer. Would it make sense to update se_cmd->scsi_status to
SAM_STAT_CHECK_CONDITION here to ensure the failure is reported properly?

>  	}
> =20
>  	srp_build_response(vscsi, cmd, &len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D30
