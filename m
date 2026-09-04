Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8E3372B4B;
	Fri,  4 Sep 2026 02:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788489429; cv=none; b=OXO/x4TBovBIGfz8uvKq3gkQMWoM4WKHnEMKGDG1ED09o8qrEKqvyOal2rA6Sqbl9XHtgL79ORvT/RKBfeEcQTZb+zVu0ad7qMODVI7RBYErLisZ7AzyUSt7VocQlgRDUDDsrookS0ekUrQsMjFH7kVG6jGSkwyq2nznm07z/pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788489429; c=relaxed/simple;
	bh=6WHwSr2QzsyC14wimEzGIeqTpL2+TIPMz3TDrB7PHLI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ofvT7IGkHJaT3w212H0OMX5WGKb66HzMlhg8T/sPoxA+NVUBQgh4fTiIygTb8JHPEn7zl4uZaJbiY2vhcwif9aKAwx+O6Ntw6AJEj5dYyrXMOowwpBX1QFeTsdT1Gxpgjio+MFtHOrxpIu9nbw3xR8hhwMKcSS36DbjWFnlirrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyFaKOEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyFaKOEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E051F000E9;
	Fri,  4 Sep 2026 02:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788489428;
	bh=TOsmOHsH0R7dEZhF+gXqYrH2duOUosjmqI2cDl/lTlU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QyFaKOEmPSxK4zfszgLUiwCAgvHZ1BkKBmX3O61E4S/nTKoodD4z4tGdMnxSSjq6C
	 kSgtlYv0wjxv9cF9gxeyBZkRYWqKks/6S26zbYwIyZcnBavPUzlp1gxHLW/ojbpKmA
	 BncoXS8xCcM1bR+kTX+2E4oEaj/1+A4o97cT2Yv37KyEJfk/lEmBvmTex9hGLn7Wy7
	 +ST1dXaO9F20koVVGKYWhR3YwwLWpO0ucgUzGsjDEXEmPRvjh+WzgQN52zXYTITRKY
	 WB4SMmw69zFxq+1JGb0RtI4eFYpGLR4PmFf+nl1f1LYuAGqH2Jc/IF7ls8hZpfGfca
	 e52BQy0g4l0zQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 34/40] target: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, cassel@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260904002644.157668-35-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-35-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 02:37:07 +0000
Message-Id: <20260904023707.A4E051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] When Unit Attention Interlock Control (`emulate_ua_intlck_ctrl`) i=
s configured to not clear UAs, reporting a Unit Attention fails and results=
 in a permanent `SAM_STAT_BUSY` loop instead of sending a `CHECK_CONDITION`.
--

commit 38089f6eddcf2270af001616b6a77553df3408ee
Author: Damien Le Moal <dlemoal@kernel.org>

target: use 16-bits defined sense codes

Refactor the target core code to use the 16-bits sense codes for building
sense and replace all hard-coded additional sense codes and additional
sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
> index dcfe945949167..ba208def8cb59 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c

[ ... ]

> @@ -3566,21 +3567,19 @@ static void translate_sense_reason(struct se_cmd =
*cmd, sense_reason_t reason)
> =20
>  	key =3D sd->key;
>  	if (reason =3D=3D TCM_CHECK_CONDITION_UNIT_ATTENTION) {
> -		if (!core_scsi3_ua_for_check_condition(cmd, &key, &asc,
> -						       &ascq)) {
> +		if (!core_scsi3_ua_for_check_condition(cmd, &key, &code)) {
>  			cmd->scsi_status =3D SAM_STAT_BUSY;
>  			return;
>  		}
>  	} else {

[ ... ]

> diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core=
_ua.c
> index 4276690fb6cbd..ea97b05d47ab7 100644
> --- a/drivers/target/target_core_ua.c
> +++ b/drivers/target/target_core_ua.c

[ ... ]

> @@ -232,8 +230,7 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd =
*cmd, u8 *key, u8 *asc,
>  		 * clearing it.
>  		 */
>  		if (!dev_ua_intlck_clear) {
> -			*asc =3D ua->ua_asc;
> -			*ascq =3D ua->ua_ascq;
> +			*code =3D scsi_sense_code(ua->ua_asc, ua->ua_ascq);
>  			break;
>  		}

[Severity: High]
This is a pre-existing issue, but I noticed a logic error in the UA reporti=
ng
mechanism that is still present.

When core_scsi3_ua_for_check_condition() executes the `!dev_ua_intlck_clear`
branch shown above, it breaks out of the loop early without setting the loc=
al
variable `head =3D 0`. Because the function simply returns `head =3D=3D 0` =
at the end,
it will always return false in this case.

As a result, when called by translate_sense_reason(), this false return val=
ue
causes the target to respond with SAM_STAT_BUSY instead of building the pro=
per
CHECK_CONDITION sense buffer.

Could this lead to an infinite retry loop? If the target responds with BUSY,
the initiator might indefinitely retry the command since the Unit Attention=
 is
never cleared or properly reported, potentially making the LUN completely
inaccessible.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D34
