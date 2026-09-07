Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4BE2D0C89;
	Mon,  7 Sep 2026 02:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749759; cv=none; b=Sy72ZQtohjusBKJ1OKAzEa6EiCqdBKRNL80QtjZZP/zzv18Y4lf2hFX4jLgCABD8qBZ1PY6QytEshj6ontTNJiVUygk3C6OdRVBX7xy4k17N1YwOM2Nn6EEtFFJTiDwWiCCcoOr8PE1UBXfumL9xHh5gYNIv67ICas2rTqMVqf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749759; c=relaxed/simple;
	bh=qf3GnfoJ/N2DMWWfGShoxe018hA5qIkma4zoYXB+dFI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uv0dOJYLo5deA/sBzOm8A0kSwMnHvPWhbhxqgj3oQq37ED6RIFzVM+lkW85VP03cnEHHM1F0Mu0D+XBA0c2MHbgH9b93zOR3R/YpWh3KHEfN4zSGduHx6jTMd3+pvYRJrRFrhl8LVIlzZoL8qqTGmp37hxlLUu4OtYAthriD6gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDq33o0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDq33o0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32301F00A3A;
	Mon,  7 Sep 2026 02:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749758;
	bh=aiAdXG3mCvdWPEmbFyY09jhSHcWU1W5LB7SM78ODs34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oDq33o0NL/TELdVCwM6pMfv2GV5bvrkObzT8yJk9/M7loVE0c/9IUmBc1pscI6NlS
	 Hc7UhcJgTgUMJZpryPIP3E4K3xt8hdKrCD3ZHzwNRJ7NcWzlxGu7yGxqmFplvFflqT
	 V/Y87ixg94t8VJvGilizgNL+HLXXqNiJxavTC10OxdxaCA3tY3Zxv13tyzzKbEEszf
	 KxizC3gEjJCW900mnHcGJfTUgSBPUno3vxGUTvWInCSFR+FbeM3efk4aNp2VTQ2GYw
	 ONhEtitgjpb37J3JeojlXxvVAV5bzGT1jrFmhXhAxsrEkY/ndCLibGsIQZUY86E8+D
	 jXI6GIoCltr2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/40] scsi: mpt3sas: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: dlemoal@kernel.org, linux-s390@vger.kernel.org, cassel@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-18-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:55:57 +0000
Message-Id: <20260907025557.A32301F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `rc` variable in `_scsih_determine_disposition` is declared as=
 `static`, which causes a data race across concurrent executions.
--

commit 4f69934411b8a4f00e0553bbc3f43bf991c80d7a
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mpt3sas: use 16-bits defined sense codes

Refactor the mpt3sas driver to replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 0e12009a87f62..085d4672db854 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
[ ... ]
> @@ -7691,38 +7691,41 @@ _scsih_determine_disposition(struct MPT3SAS_ADAPT=
ER *ioc,
> =20
>  	if (check_sense) {
>  		_scsih_normalize_sense(transfer_packet->sense, &sense_info);
> -		if (sense_info.skey =3D=3D UNIT_ATTENTION)
> +		if (sense_info.skey =3D=3D UNIT_ATTENTION) {
>  			rc =3D DEVICE_RETRY_UA;
> -		else if (sense_info.skey =3D=3D NOT_READY) {
> -			/* medium isn't present */
> -			if (sense_info.asc =3D=3D 0x3a)
> +		} else if (sense_info.skey =3D=3D NOT_READY) {
> +			if (sense_info.asc =3D=3D ASC_MEDIUM_NOT_PRESENT) {
>  				rc =3D DEVICE_READY;
                        ^^

[Severity: High]
This is a pre-existing issue, but does the use of the static rc variable
in _scsih_determine_disposition() cause a data race across concurrent
executions?

Looking at the variable declaration at the beginning of the function:

static enum device_responsive_state
_scsih_determine_disposition(struct MPT3SAS_ADAPTER *ioc,
	struct _scsi_io_transfer *transfer_packet)
{
	static enum device_responsive_state rc;

Since rc is declared as static, it is shared across all concurrent
invocations of the function. Can this cause the function to return an incor=
rect
device_responsive_state (e.g., DEVICE_ERROR instead of DEVICE_READY or vice
versa) for a device when executing concurrently during adapter scanning or =
event
processing across multiple threads?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D17
