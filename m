Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3684C77B1;
	Tue,  8 Sep 2026 09:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860883; cv=none; b=cIY59lS0whJzTZiuz232CMrlcrWosvxZOPNcSpchZSEVfQ/l3u4Qjzfp90sK2rzGTyeHMdoKyPdTfhr8uQxhUdMjYtKPE2yjVrGIDcPj7DCF/yhp84rAvU+2D0yM/OWwvirjLM2DVZWrjmhDXPtIhu59gzx88kcFXcewYa+/lLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860883; c=relaxed/simple;
	bh=feSwl6O0VbIHiO0BB6cVcL0ak6K88Mw0wBfoGWc1m7w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z+V8FzgebSp/1EVvUVHcWFm3q3mbfiX9arCB06dXQtXLeTYZ8Qhvr8zzD3T8IuYbSbaQi+J8/xXeIpc/VWblL6i3nT2Q5XKYg9XeM0QBPHrQTDOgjEqVkEWjZINCc2HKbwsyg+VPCe2VC4XpPTK8P2xyzAb3KK/+Yh5BD3ZiBbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJpdCYwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJpdCYwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76801F00A3A;
	Tue,  8 Sep 2026 09:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788860882;
	bh=YRB5LEZ8+qTm5H92vAnEeaCJ5zbmhpJK9MzuOyKBwso=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JJpdCYwq8oW8eGSZ6Ytx1DyX8PdvNdJh9UQkrtPnxMBUXFn1dFn+ocklZnq61dqAc
	 LiGy0D4Mc11gnwfpjHouDqgCGuf9PPtWySqiJZ6J50z0XrhmfTiRTco0fzod6votbb
	 gwryceT5cEFsUu7kCbuJiAJ8DTJUaHDafSf2MgrqTbproBU1rRENsidG7h1hgdBEMI
	 /pyRpvExt1d5AJFXuDaw79yorYuhWV4NGH0tmCwfAHRmzBMfJyZPRuq9uGXd0m4pDh
	 OqkSRFGiI4KzSRNqjuSWgRUV6dJLSENkMXRpYukppr0DHDMw+b5Ua8QbyeXkf6LA8w
	 Ta8hTDGqX46yQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 17/40] scsi: mpt3sas: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260908090308.1085097-18-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 09:48:01 +0000
Message-Id: <20260908094801.D76801F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Local variable 'rc' in _scsih_determine_disposition is declared st=
atic, causing a global data race.
--

commit 237624bf0d56187b272fd92abe88d5f7ffa6aef7
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: mpt3sas: use 16-bits defined sense codes

Refactor the mpt3sas driver to replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

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

[Severity: High]
This isn't a bug introduced by this patch, but there is a pre-existing=20
issue with the 'rc' variable being assigned here.=20

In drivers/scsi/mpt3sas/mpt3sas_scsih.c, _scsih_determine_disposition()=20
declares 'rc' as a function-scope static variable:

        static enum device_responsive_state rc;

Because mpt3sas controllers use separate workqueue threads=20
(firmware_event_thread) for each controller, systems with multiple HBAs=20
can invoke _scsih_determine_disposition() concurrently.=20

Since 'rc' is shared globally across all CPUs and controllers without=20
locking, can one thread's assignment to 'rc' be overwritten by another=20
thread before the function returns?=20

Could this concurrent modification lead to returning an incorrect=20
disposition (like DEVICE_READY instead of DEVICE_ERROR) and cause=20
subsequent logic errors during SCSI device discovery or polling?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D17
