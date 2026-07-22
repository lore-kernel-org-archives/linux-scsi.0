Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6663D361DD5
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 06:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702903; cv=none; b=qXzef8DTHQuu1sVgAqlvruXwU6H7ECTvZvRWQfbSv/kW7BqlDfYC39GEecCnzcDbAgXPCdL4p6HUeU03n8bihM4x+jQ0G47cNnwRN9sCjfioCc2Nw1qzgkNTjYKz2scXA/hFsngPbeJRKdDQHJ+ssVlvZPPfHqNWxdlXs0SuIck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702903; c=relaxed/simple;
	bh=bWxDTNdb1IS6VdrGc9KrzGTU1MZVc75F+6nYyNHkFhA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nnRpiHji9DoXZO1bLPw6qiqQYvFFKyRpkmrye1xZVbdnGSJalX+8D3tAxlV1jFwIr/x4eg+nW3XqKZA2666Vv6M8hNu4i5w4yRwBZOgWg7Tau+SbQV++RU4cuAjqmXfmbCBBHCSQhVNdGi3nW/UP/SvyZ8E34GZnB+rYHf76E3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPLD4a1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPLD4a1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56F71F000E9;
	Wed, 22 Jul 2026 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784702901;
	bh=GEE7shxnA3KZ6yMDfFjsMHdXHcp1eYj4RYXuWF36RI0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fPLD4a1quDiOYcZ3liF4pEru8UiM/ngP8U50Uv01FWbJxa07xLFJbWFZc/bfUVIj4
	 su/VD1rJ9LTligoC6bSA4k6YBcJH4MUdnCp+3imUMIqznzWcRgsDO+L4R+vRxD0GH5
	 jI074T6mHRlPzrMGUM7FEo2OrbZC6sckHGOuh0Lo9jCctzMPRzCe8UReBr8YiN9WEm
	 WnHNvqJSkmh/X+axVQ1WvMo3uOikrosFdktWuUrNalgQnfDRK0PTYshCdkt3sZiLew
	 GgWyh5h64PTi1w7rMeyClwicCSIyQQ721H/wMx4UoPBBD/ZTLBSiRwham3mFvvDBwH
	 sHYMBMOCyB5jA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: avoid strlen() in
 target_core_call_addhbatotarget()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dmitry Antipov" <dmantipov@yandex.ru>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722063523.669361-1-dmantipov@yandex.ru>
References: <20260722063523.669361-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 06:48:21 +0000
Message-Id: <20260722064821.B56F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Incomplete replacement of strlen(): a redundant call to strlen(name=
) remains in the error handling path despite the length already being captu=
red.
--

--- Patch [1]: [PATCH] scsi: target: avoid strlen() in target_core_call_add=
hbatotarget() ---
commit 03360414acae57f08ec406c8bedc559ab4a7788c
Author: Dmitry Antipov <dmantipov@yandex.ru>

scsi: target: avoid strlen() in target_core_call_addhbatotarget()

This commit avoids calling strlen() by leveraging the return value of
snprintf() to detect if the string exceeds the maximum length.

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index 2b19a956007b7..3214047031b86 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -3635,13 +3635,13 @@ static struct config_group *target_core_call_addh=
batotarget(
>  	unsigned long plugin_dep_id =3D 0;
>  	int ret;
> =20
> -	if (strlen(name) >=3D TARGET_CORE_NAME_MAX_LEN) {
> +	ret =3D snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);
> +	if (ret >=3D TARGET_CORE_NAME_MAX_LEN) {
>  		pr_err("Passed *name strlen(): %d exceeds"
>  			" TARGET_CORE_NAME_MAX_LEN: %d\n", (int)strlen(name),

[Severity: Low]
Since ret now holds the exact length of the input string, could this remain=
ing
call to strlen(name) in target_core_call_addhbatotarget() be replaced with =
ret
to completely avoid strlen() on this path?

>  			TARGET_CORE_NAME_MAX_LEN);
>  		return ERR_PTR(-ENAMETOOLONG);
>  	}
> -	snprintf(buf, TARGET_CORE_NAME_MAX_LEN, "%s", name);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722063523.6693=
61-1-dmantipov@yandex.ru?part=3D1
