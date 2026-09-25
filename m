Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5722C4A6CDF;
	Fri, 25 Sep 2026 13:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790344374; cv=none; b=dDo9PtKzxlMWEPS28ypD0wNHplJxVotuzTPIiUbIJM3skoDv0PvEe+m6+N4FLVTkyNL9gFcHbfp4hMJze74fmp0ws65uzT7z50zKFKOryQlvEscmsAdVPIgPw+vQHCIBKKJYypdPXJ/5Xud80oHuofyeGdeeHzJWdhSVWjh+OZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790344374; c=relaxed/simple;
	bh=aw1eyA4OuymV3vomPlLf+wxgimKQK4nLApRHrSBjFVs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=swUTqbqiSkVdFbKsj11fNlo1LSsce9dZehyYL1cP9ipr+w0mPBwxcPO254dPy5G0JpEwHiGo3E3DH/tHwRtlYxslP+QD/eTmgVLEj44QbDHh3vdJnWEahTb1TClz452ZtNi1Rsl1hJfoqXPztKwAZ5swClzUdJiqdLIzdqBub14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oikx6co1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oikx6co1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE881F00899;
	Fri, 25 Sep 2026 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790344371;
	bh=DvexeMzfSgLMQ+FvM2QENoRYhc/LQcuFL/BF/BUeykE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oikx6co1q1izML2hJeCi0YaSEQCgnk5fIbkq5nNlAqlaLB0BS5vkXMoItjmRZVw16
	 KQiDxQzhi9V3cQ2mTh9nAd903NgcJZXpvDufA2fxcWYNXsCM/qm5a9OSOMXhlyVina
	 Et9PGsSGnzy5O6wweY6Ybd4IolFd8ayukCoUyyaTRMDraz3Rl1xuOFV00VCV4f8m0A
	 w6mew9Lx7/xVIe5mSyFrX7YCvaZD7BQyPCRe19Ehihgw2NsBZwR4BVElIIe8B0bUEu
	 5D6YQTRDAObAof9DHi2+yHc8e2ESmlVeP7lBjf7WyUPsHjXwYMgcu8Ga99mKXLBu3s
	 YgbdrmQL0S78g==
From: sashiko-bot@kernel.org
Subject: Re: [RFC v9 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: linux-scsi@vger.kernel.org, lee@kernel.org, linux-leds@vger.kernel.org
In-Reply-To: <20260925134010.2815025-2-nbg2974@gmail.com>
References: <20260925134010.2815025-1-nbg2974@gmail.com>
 <20260925134010.2815025-2-nbg2974@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 13:52:51 +0000
Message-Id: <20260925135251.9EE881F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Low] leds: asus-aura-scsi: undefined function kzalloc_obj() causes build=
 failure
- [Low] leds: asus-aura-scsi: blk_rq_map_kern() missing required request_qu=
eue argument
- [Low] leds: asus-aura-scsi: strscpy() called with missing size argument
--

commit 4bfc2d1ddcebc584c1ac85ff43152c8925e0316d
Author: Liang Haowen <nbg2974@gmail.com>

leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit adds a new SCSI device handler and multicolour LED class driver
to support the ASUS Aura RGB LEDs present in ROG STRIX Arion external NVMe
enclosures. It sets up LED instances and maps hardware updates via vendor
SCSI commands over the block layer.

> diff --git a/drivers/leds/rgb/leds-asus-aura-scsi.c b/drivers/leds/rgb/le=
ds-asus-aura-scsi.c
> new file mode 100644
> --- /dev/null
> +++ b/drivers/leds/rgb/leds-asus-aura-scsi.c
[ ... ]
> +static int ene_write_reg(struct asus_aura *aura, u16 reg,
> +			 const u8 *tx, u8 len)
> +{
> +	struct scsi_device *sdev =3D aura->sdev;
> +	struct request *rq;
[ ... ]
> +	/*
> +	 * Stack memory is not DMA-safe (VMAP_STACK), so the payload is
> +	 * copied into the per-device buffer first.
> +	 */
> +	memcpy(aura->tx, tx, len);
> +	ret =3D blk_rq_map_kern(rq, aura->tx, len, GFP_NOIO);

[Severity: Low]
Does this code compile? The block layer API blk_rq_map_kern() requires 5
arguments, including the struct request_queue pointer as the first argument,
but only 4 are provided here.

[ ... ]
> +static int asus_aura_register_led(struct asus_aura *aura, int index)
> +{
> +	struct asus_aura_led *led =3D &aura->leds[index];
> +	struct led_classdev *cdev =3D &led->mc_cdev.led_cdev;
> +	char hctl[32];
[ ... ]
> +	/*
> +	 * The sdev's H:C:T:L keeps the names unique when more than one
> +	 * enclosure is connected; with a static name the LED core would
> +	 * register a second enclosure's LEDs under renamed nodes
> +	 * (asus-arion::led-0_1), the wrong device identity. The colons
> +	 * are flattened to dashes, the color section stays empty
> +	 * (multicolor, palette via multi_intensity) and the four
> +	 * identical zones take a "-N" ordinal, as
> +	 * Documentation/leds/leds-class.rst asks for.
> +	 */
> +	strscpy(hctl, dev_name(&aura->sdev->sdev_gendev));

[Severity: Low]
Can strscpy() be called with only 2 arguments here? The function requires 3
arguments (destination, source, count), and a 2-argument macro wrapper does
not exist in this tree. This will result in a compilation error.

[ ... ]
> +static int asus_aura_attach(struct scsi_device *sdev)
> +{
> +	struct asus_aura *aura;
> +	int ret;
> +
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	aura =3D kzalloc_obj(*aura, GFP_KERNEL);

[Severity: Low]
Is kzalloc_obj() an intended API here? It appears to be an undefined
macro/function which results in an immediate compilation error. Should this
be kzalloc() instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925134010.2815=
025-1-nbg2974@gmail.com?part=3D1
