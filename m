Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061F719644B;
	Mon,  7 Sep 2026 03:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750702; cv=none; b=usn5oMi6XTjjAiEdytSAooL9pHtgZyg8pwMZBd+CqUSWy33eDL4oMWYXWYd2ZIMxhIQVcoFkV2tSMIB1wE0lszYgBeRoz7XrildxXRrvM0bPuaHGjmzv8GrMP+n5Clq7IrH3df+L68d5HIn2PIaXAFL8676O0ojkBb5XEXzu4eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750702; c=relaxed/simple;
	bh=jLeJ3XaiceRA35F3VFEGFjrNwQOMWnosi/CMlwoTKww=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ioSXaGEItNW7K4fXVHFUsVeLGtP2Sy0AToZLmMS7G67QWIbeiRItU1+EAgD+3WAjTOVyHaZ+GlmxWbN1DexnZJvaEm7iS7dhYWRL7Bh90OWdnEtypR+1q85qwvbSEMfZjQlJ/sC2lYT0GvImUtT9HfcpJPHROl+E5rqL5IMBKFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIAP3x08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIAP3x08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289071F00A3A;
	Mon,  7 Sep 2026 03:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750700;
	bh=B7C8BOOsVAObHkE2U5hjDDc+RCXNRFDO8uS+8n8h+kQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FIAP3x083qto17yrTsbmCJTMQzFN7XhmkrGMgHGeNLDJ+FXrO3orUbkKJOkTy8dgj
	 KaZpiTni4kLaoYDvFxt1h64dJqUOvW+DwlzTSCUQiD5FBnBYg2YStVdhKVJhfVJR96
	 /wGcq0xQXZzjTHqXacskH1ByEE9p+W/lmH61rcnKelhIQ5epi3Yxqo+KxtIAP8Si/I
	 yzuNGORr+bAeip4sZQBlrAaBFtO3KG0apZwuO4UCjBD/xW4bIwYJkTJ0+l5BLahi5G
	 w9eaNJf6DKrTCC7hpnkm+DRMtQ4EJCOT+ZdR8lh4ExeDTK2jRQJNXcJjR4F29moF1K
	 UtDfj/yDG1I2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 34/40] target: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-ide@vger.kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dlemoal@kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260907024343.1046387-35-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-35-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:11:39 +0000
Message-Id: <20260907031140.289071F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] Incomplete refactoring leaves hard-coded ASC and ASCQ values, vi=
olating the commit claim.

Pre-existing issues:
- [High] Pending Unit Attention incorrectly returns SAM_STAT_BUSY instead o=
f CHECK_CONDITION when UA interlock control is enabled.
--

commit ccd814e94e89b6a0920259ca5ec40d06ac0cee69
Author: Damien Le Moal <dlemoal@kernel.org>

target: use 16-bits defined sense codes

Refactor the target core code to use the 16-bits sense codes for building
sense and replace all hard-coded additional sense codes and additional
sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

[Severity: Medium]
The commit message states this patch will "replace all hard-coded additional
sense codes and additional sense code qualifiers with the enum values".=20
Is this refactoring complete?

Looking at the unmodified code in target_core_transport.c,
sense_detail_table still has hard-coded values like 0x25. Similarly,
core_scsi3_ua_allocate() in target_core_ua.c still checks for
ua_p->ua_asc =3D=3D 0x29. Should these remaining hard-coded values be updat=
ed
to use the 16-bit enum values to fully align with the commit description?

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/targ=
et_core_transport.c
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

[Severity: High]
This is a pre-existing issue, but does returning SAM_STAT_BUSY here cause an
infinite I/O retry loop if the target is configured with UA interlock?

In core_scsi3_ua_for_check_condition() below, when dev_ua_intlck_clear
is false, the loop breaks early and leaves the head variable set to 1.
This causes core_scsi3_ua_for_check_condition() to return false, which in
turn leads translate_sense_reason() to return SAM_STAT_BUSY instead of
properly formatting the CHECK_CONDITION with the pending Unit Attention
sense data.

Should this be reporting the CHECK_CONDITION instead of spinning on BUSY?

> diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core=
_ua.c
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

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D34
