Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D170450AC03;
	Tue,  8 Sep 2026 10:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862688; cv=none; b=N0DD3agK6MDSv2OKgHoThEGodebyfs1vp/rW/JsYoYH5hNM9PWwQIrdqjJd0Dgltt1657U1wr+kpkR5EyS967g05jTXHZSWfVVcjWhNVjni9WAW8XxyQbx2PXdUyopL2KHlS5PKTtfsB2OAbhIV2UKbvSL3wGre821S57Nxahmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862688; c=relaxed/simple;
	bh=1E2efPjDQpL17mYzyFF3EKiYgM/UbJB2PUtSTS2cw8M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Vs3zj7DdNoX/p0r0DzslmkSjbCICXLlFA/Z2gaa40sYvIHRvrgqzKlwlUd2DsD4IYlA99SbealvAwZ7pH/DjQBz/ISXXJOR0qlqbFxulrBiGKjEWJAzqX4DLbvYr9y6b2x41eFW4wdZZAu5NBFZ8mIoeapn5xlrX1MEvw89NFIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=du5iyei4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="du5iyei4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7841F00A3E;
	Tue,  8 Sep 2026 10:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862686;
	bh=njKwg2qstIuF0gPw9B7833X2pWpFmfxLw9gOUpPiPQk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=du5iyei4XgtgGvCXVpwy8euyK0RqdO+PoZWB0GWXjvT2G51PruWK50nqaOjXEeBcp
	 gZBCmmCsAD39wFkE70heB01WO0ml58DJpuiniijgktIEZs4GBPBjIu82DnXCjiIMjv
	 ZwRsjq4/soxH5BApuKxIaXacupU6D1DB9LaomXItVMDCW0y+ei00/gF7X3nWwasgha
	 tDhYRCwRoMKOsUFan1uASzH/sWnh3MmzUxhaf/EH+o0JCxokwbJSJFbxbTDDkGF3l0
	 tjjEy6scie7DM1AkMGFE/S8oQHKWTR3HoC2p/tCydwPIs+msI9D3uzj6iaEYlHsna5
	 tfIZgIr6haopQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-31-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:18:04 +0000
Message-Id: <20260908101805.DE7841F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] In `ibmvscsis_queue_data_in`, when an `srp_transfer_data` failure =
occurs, the driver populates a sense buffer to indicate `LU_COMMUNICATION_T=
IMEOUT` but fails to set `se_cmd->scsi_status =3D SAM_STAT_CHECK_CONDITION`=
. As a result, the subsequent call to `srp_build_response` receives a `SAM_=
STAT_GOOD` (0) status, which causes it to completely bypass the sense data =
block and return a success response to the initiator, silently discarding t=
he data transfer error.
--

commit 5043a368074e156668da603aa4c348be519e5fb6
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ibmvscsi_tgt: use 16-bits defined sense codes

This commit replaces hard-coded SCSI sense codes and qualifiers with standa=
rd
enum values from include/scsi/scsi_sense.h in the IBM virtual SCSI target
driver. The change aims to improve code clarity and make the sense codes
self-documenting without altering existing functionality.

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
>  	}
> =20
>  	srp_build_response(vscsi, cmd, &len);

[Severity: High]
This isn't a bug introduced by this patch, but in this error path where
srp_transfer_data() fails, the sense buffer is populated with a timeout err=
or
but se_cmd->scsi_status is not updated to SAM_STAT_CHECK_CONDITION.

Does this cause the subsequent call to srp_build_response() to see a
SAM_STAT_GOOD (0) status?

Looking at srp_build_response(), it checks the status:

    rsp->status =3D ibmvscsis_fast_fail(vscsi, cmd);
    if (rsp->status) {
        ...
        if (se_cmd->scsi_sense_length && se_cmd->sense_buffer) {
            ...
            memcpy(data, se_cmd->sense_buffer, se_cmd->scsi_sense_length);
        }
    }

If rsp->status remains 0, the entire sense-copy block appears to be bypasse=
d.
Could this result in silently discarding the data transfer error and return=
ing
a success response to the initiator, causing it to consume uninitialized or
stale data?

Would it be appropriate to set se_cmd->scsi_status =3D SAM_STAT_CHECK_CONDI=
TION
before calling srp_build_response() in this failure path?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D30
