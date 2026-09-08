Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427083C3C0E;
	Tue,  8 Sep 2026 10:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788863353; cv=none; b=Wq5X337aUH/GOSbTauJ58DuDNRhfmYWnX0xolxmx1UpBSRuH7YjWaMkUxAuasFz/WtFlhqSZzBRgat9FUKWIf60lGIqPrc20f042sO6qhaOVHlABIXnCJa5mhrle+fSTazQk0s00pGECTZst3K6Su5008Zt9syitJOrnk0lHdig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788863353; c=relaxed/simple;
	bh=EaPzSoyIMO5dltwHgTWf961Z94e55VC7RgHkFSdGgtA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QCdAqqu/Ds4r1m9Rt+JjjSLAhP7/8wRO76d9ZTRFBTxbLBZcqVEK1blPIzRTaMW9Qe/e2F84ObkB4496J0eLp9vDhPjo3A5tyXWw1B+P48VsouxQ1v1fITUSO29q2IYr+BZ9zPDXAznGV3A2VbuIsBuLuniWlb/UbX31CneETek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNMAVW/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNMAVW/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544FE1F00A3A;
	Tue,  8 Sep 2026 10:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788863351;
	bh=a7KOD1sTXzBJrT8UvCCw0HrPpyOxMPpGfYty5PGWxCY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZNMAVW/K1MkQ2HZ8rcsrAHfmLbG970DZrNsq53TUionCg7SSBV3fYTuMaAFPQrfHq
	 2R/ITZsrey81abhKJ890bLcnxYOWXkf5aGBBxC8gHzsp9hIIJ9Nghagz5gnK+crU+M
	 U4yswCX3NBlKkH0t8W9ZFrX8n0UfQRwVixz36EesNkTcepEoVLoBubp8muzyaQ+KVp
	 5ahye7laDVGda+osJpFehZJpgiHWeEETjs3fi5oUWxXLEitV6JO30xEIh276OLrO45
	 CpFqfVCDFPHOU3xUnKunDgd6K895ce1TX2LSaYXL1ZqdOS9l+QlsCicCyi8Vri+KO5
	 J5uafORltHkQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 34/40] target: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260908090308.1085097-35-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-35-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:29:10 +0000
Message-Id: <20260908102911.544FE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unit Attention Interlock mode causes an infinite BUSY loop instead=
 of a CHECK CONDITION because 'head' is not cleared.
--

commit cfc53d67bb91faecefbe9471ddf472fc26d50df4
Author: Damien Le Moal <dlemoal@kernel.org>

target: use 16-bits defined sense codes

This commit refactors the target core code to use 16-bit sense codes and
replaces hard-coded additional sense codes and qualifiers with defined enum
values. The stated goal is to improve code clarity with no functional chang=
es
intended.

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

[Severity: High]
This is a pre-existing issue, but does this error handling correctly match
what is returned by core_scsi3_ua_for_check_condition() when Unit Attention
Interlock mode is enabled?

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
This is a pre-existing issue, but because this branch in=20
core_scsi3_ua_for_check_condition() breaks out of the loop without resetting
"head" to 0, the function ends up returning false below since head remains =
1:

	return head =3D=3D 0;

Since translate_sense_reason() interprets the false return as a failure, it
responds with SAM_STAT_BUSY. Does this leave the LUN completely wedged by
returning SAM_STAT_BUSY infinitely to all commands whenever Unit Attention
Interlock mode is enabled, preventing the initiator from ever clearing the
condition?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D34
