Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C112175A85;
	Sat,  5 Sep 2026 03:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579792; cv=none; b=G6i3TPyjl/lC9W8PxTqMAbEQaxXosEcBhdD/ldADhKLNgsdr3f1mtoU41zIenBPuyiZTP4MMRNalfAlk3KCInR6uXnusmuLTmSM+SOmSjKfBUpaBvCnJ6+mLCHt2jvIt7HP2QN8XbJ0S5xaudzy1ap+Uu6qrYjWUBd+x4uG1dW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579792; c=relaxed/simple;
	bh=6VvrAjd5JluoFcpBm/+aAm3UsGwSm/N7ko89HzVOTdM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KtFEkWgZOC8KTZk0xIDBF+KSIbPm91XKQYQbQFl5/kENP4jbr69Nx6j6lZ4G2+44sxnl4u2Sk7u8sYC9GI8f2lWv6WCEUtKBK8lqzsiXIqhXkSSbOVLFXe5Pk/mAQLXYQyfVvjRETBevtN9oy31OE/cly4PvQ5ZEBNjQecvITlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=neiRIC0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="neiRIC0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D4B1F00A3D;
	Sat,  5 Sep 2026 03:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579790;
	bh=mvuHnL+/AmP35a/6g1Zjy8DWD0w3zg1EItT0a0qRRtc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=neiRIC0sVkwqNs6+7ZsyS2HTBQKvYUR79PsKez9z9sBsuJAqQ/X8YQ43kvYphVTiX
	 dT6u0MhBAiR0I0LXD2c9ryWW1alec7rMiOAyt9Atpoa56Eo2FdpBhbBvprdNRibyP3
	 aRiP77pHka42qgoTJLLtT2vLQ///64bH+HHNKPxOmbx+qg8tGbNt4+3jTbivw1rLfd
	 gZJXXGXpxdnu80X8Lx1CQQgAe3SNUUfpz72qB1+HtHtjBZmCPxPPnjOFMp+vVQbSb/
	 nMsDEgETbdmCeggoWxz4U7muWXK/CLo9Omv7rQCLfjOGOqWfhYalKqW3dUAHpCBM3r
	 gprIRmbKQyJvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 34/40] target: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260905032224.509860-35-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-35-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:43:09 +0000
Message-Id: <20260905034310.59D4B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The primary target core sense table still uses hard-coded hex va=
lues despite the patch's stated goals.

Pre-existing issues:
- [High] Incorrect handling of Unit Attention interlock control causes an i=
nfinite loop of SAM_STAT_BUSY responses.
--

commit ab469d8780b2c8fe9ab41d6ba54779a304754b35
Author: Damien Le Moal <dlemoal@kernel.org>

target: use 16-bits defined sense codes

This commit refactors the target core code to use 16-bit sense codes.
It replaces hard-coded additional sense codes and qualifiers with the
enum values defined in include/scsi/scsi_sense.h to improve clarity.

> target: use 16-bits defined sense codes
>=20
> Refactor the target core code to use the 16-bits sense codes for building
> sense and replace all hard-coded additional sense codes and additional
> sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.

[Severity: Medium]
Does this patch miss updating the sense_detail_table in
drivers/target/target_core_transport.c?

Looking at the source, sense_detail_table still contains hard-coded hex
values for asc and ascq (such as 0x25 for LOGICAL UNIT NOT SUPPORTED),
which seems to contradict the stated intent to replace all of them.

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

[ ... ]

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

[Severity: High]
This is a pre-existing issue, but does this early break cause an infinite
loop of busy responses when emulate_ua_intlck_ctrl is not zero?

When dev_ua_intlck_clear is false, the loop in
core_scsi3_ua_for_check_condition() breaks before setting head =3D 0.
This causes the function to return false since head is initialized to 1.

In translate_sense_reason(), receiving false causes it to set the status
to SAM_STAT_BUSY instead of properly reporting the unit attention.

The initiator will retry, hit the exact same uncleared unit attention,
and receive a busy response indefinitely.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D34
