Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EC83546F0;
	Fri, 31 Jul 2026 20:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528730; cv=none; b=cG1Oy3v2r7GWOjtRblrEOljZpYyTrrvudL4kZSnepSpwKhOrYIcEMjxThLBs2FCH29O/cTnsgQ3KQedLikSiYZwtGfALuQYNLLu+nTtgeoD/VEHqVSUpm/ZA5HPvARBlwVKixeI++ndARQ93hPocaUvFChIprZLYK+09dtzRB/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528730; c=relaxed/simple;
	bh=h8tvHwIIwbLUuYMmK8n2ro2JdfKzDcQo/XNIBX3+sLI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UdoJ710zJanBKDqbWpm7QZL/bPMlziBJBh0dvCnrp1j0qPhgL8+REFYGn9/eefl+/XaQpsY6S3Bp/3ceY2bUqTzf1sSLWAIHDutcmYtD3XNBxnBvu1W6va3qSXXMDtJzGeYUDht9eu2U1E8Ft5tEaYWrjDMPtnVHaCDXrmqDREs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IP1cFUOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IP1cFUOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02A01F00AC4;
	Fri, 31 Jul 2026 20:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785528728;
	bh=2eQgVJkPT8NVfMQWvpqrdCU2+xR7t2iMDAP115Cfn1k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IP1cFUOC80MU72nHW3cA/OPgkmBsZjsbfwq3xuHvgckagliihvJZDkPJ9V99j1Ddh
	 IVAjKQ7UNB/C6E3pXJx6IuRf30N32LADV0OUl6CKC6iEz+32zWIdshYFdVFwosZxkS
	 proK1rBNupCVSXb/y8MKBM5ww2ayOY0DxzOaOm4hYcDhjma8sfk1a+e1GRy21WrigJ
	 5Vbr8BQNPbHNKstHKQdu+78hWwIQqQMifPPmg5xHb4CfK8HmJRWl3XPKdzakJTGB3d
	 d6Q99bPYUGZa9ppp9UgvobWC6jv+4kOn/+/SRIGnPcw4zg0xsq8z1iLoB5vY0wDedQ
	 /Nwo3XmLaWecA==
From: sashiko-bot@kernel.org
Subject: Re: [RESEND PATCH 4/6] drm_hyperv: Remove support for synth video
 protocol of old Hyper-V hosts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Kelley" <mhkelley58@gmail.com>
Cc: linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260730201123.1767-5-mhklinux@outlook.com>
References: <20260730201123.1767-1-mhklinux@outlook.com>
 <20260730201123.1767-5-mhklinux@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 20:12:08 +0000
Message-Id: <20260731201208.A02A01F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] The static inline function `hv_drm_version_ge()` and the `synthvid_=
version` field in `struct hv_drm_device` are left behind as dead code.

Pre-existing issues:
- [High] Timeout of VMBus resolution request leaves the channel open, allow=
ing delayed responses to corrupt memory and desynchronize wait completions.
--

--- Patch [4]: [RESEND PATCH 4/6] drm_hyperv: Remove support for synth vide=
o protocol of old Hyper-V hosts ---
commit 942daa19258c15938630a14160717e1dd6e0fbc1
Author: Michael Kelley <mhkelley58@gmail.com>

drm_hyperv: Remove support for synth video protocol of old Hyper-V hosts

This commit removes support for older synthetic video protocols, as running
Linux on Hyper-V hosts earlier than WS2016 and Windows 10 is no longer
supported. It simplifies the protocol version negotiation to only request
the WIN10 version.

> diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_proto.c b/drivers/gpu/drm/=
hyperv/hyperv_drm_proto.c
> index f0ef627b4898a..cea1ea2595cd6 100644
> --- a/drivers/gpu/drm/hyperv/hyperv_drm_proto.c
> +++ b/drivers/gpu/drm/hyperv/hyperv_drm_proto.c

[ ... ]

> @@ -581,11 +570,9 @@ int hv_drm_connect_vsp(struct hv_device *hdev)
> =20
>  	hv->screen_depth =3D SYNTHVID_DEPTH_WIN8;
> =20
> -	if (hv_drm_version_ge(hv->synthvid_version, SYNTHVID_VERSION_WIN10)) {
> -		ret =3D hv_drm_get_supported_resolution(hdev);
> -		if (ret)
> -			drm_err(dev, "Failed to get supported resolution from host, use defau=
lt\n");
> -	}
> +	ret =3D hv_drm_get_supported_resolution(hdev);

[Severity: Low]
Since the only caller to hv_drm_version_ge() and the only reader of=20
hv->synthvid_version are removed by this patch, should both the static=20
inline function in hyperv_drm_proto.c and the struct field in=20
hyperv_drm.h be removed as well to avoid leaving dead code behind?

> +	if (ret)
> +		drm_err(dev, "Failed to get supported resolution from host, use defaul=
t\n");

[Severity: High]
This is a pre-existing issue, but I wanted to ask about the error
handling here.

If hv_drm_get_supported_resolution() times out waiting for a response,
the code logs an error but execution continues without closing the
channel or returning an error.

If the host sends a delayed response later, wouldn't it trigger
hv_drm_receive_sub() and asynchronously overwrite hv->init_buf while
subsequent requests are actively building a new request in that shared
memory? It looks like this might also spuriously trigger complete(&hv->wait)
and desynchronize the state.

Could this timeout be handled by returning an error or resetting the
channel to prevent data corruption?

> =20
>  	if (!hv->screen_width_max) {
>  		hv->screen_width_max =3D SYNTHVID_WIDTH_WIN8;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730201123.1767=
-1-mhklinux@outlook.com?part=3D4
