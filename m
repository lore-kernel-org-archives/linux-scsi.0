Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7077948AE36;
	Wed, 23 Sep 2026 12:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790166810; cv=none; b=YSqhExdBrj+Cdhfrs9zvzAzjad7WsLhQe/GpQGhLCk5GZ9WgGcru72gyB6MKvg8XyOgk5xZZErHjQ4MplUPwPlOAh9s3MOyk/gqfsi3tXZnnpNvDyWxz+C/AtcKRH+7KkcdcjznwWCrqp48WjuXiFYyj2oIeoq20tSjXiLz+Pgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790166810; c=relaxed/simple;
	bh=SzTF5HqPeUPx0qP1GBO4dTlPAUQtb4YERPftQs1AWS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L8j/9970mcwHBdTLM1Elvcs9sgmpdtXbnY05pzubg05UWGHuVIrcFX4vSKWtxl6POPbg7+ZhkZY8d9G2j+nLOf4WpDPXSE1mNDWEMcCuWUaDBTY36FXOtX/uW1UGtL/l7zNyEe0XizB2xIdYpYfotu5wfhyeRzbYTqyNVRozeJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ce/yk5pV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ce/yk5pV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C631F000FF;
	Wed, 23 Sep 2026 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790166802;
	bh=kBrf6iDdhmlId6Iw2U9oIeAfNtkm6QpVt39xAkxdVtA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ce/yk5pVKre156DpMzoUegjKSMewMzsgKAa7cT86ZgT/RZwwcOs0QXJ2RJwWlr4GF
	 RPMYjRBgpvG/Tun2VS0JkJMvWu13oEMc3XIM0drD5091zSFa4nlgQOmOC6BA/0l5bB
	 8/INGuZa+rn5DnaZoIzYgqAVIzuHW7CKQsrz5RszjxOsMscUW4vIwCOBllQVa4Qtkv
	 ZNG65a/ON0qpUret9YQtOma8rn5oGHnQDPh/u/T2pvRRoENrfALpqetuGFTOKnFxDX
	 2Q7TLIygO/vLg5eOkrkBTWrzTHTzCVRrQkJ0clSph4Ap0OG0TGNmYv3RHOkxFq13jd
	 PR2VnL4FnLIsg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC v8 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: linux-scsi@vger.kernel.org, lee@kernel.org, linux-leds@vger.kernel.org
In-Reply-To: <20260923121832.2613187-2-nbg2974@gmail.com>
References: <20260923121832.2613187-1-nbg2974@gmail.com>
 <20260923121832.2613187-2-nbg2974@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 12:33:22 +0000
Message-Id: <20260923123322.98C631F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] leds: memory corruption due to unaligned DMA buffer tx sharing cac=
heline
- [Low] leds: build failure due to undefined macro kzalloc_obj
- [Low] leds: build failure due to missing argument in blk_rq_map_kern()
- [Low] leds: build failure due to missing size argument in strscpy()
--

commit 823a081d978e63fdae64dbf79945582f7cc88fe2
Author: Liang Haowen <nbg2974@gmail.com>

leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit adds a new driver for ASUS Aura RGB LEDs present on ROG external
NVMe enclosures. It operates by registering a SCSI device handler to interc=
ept
and issue vendor-specific SCSI commands to control the LEDs.

> diff --git a/drivers/leds/rgb/leds-asus-aura-scsi.c b/drivers/leds/rgb/le=
ds-asus-aura-scsi.c
> index 0000000000000..eaba968598dbf 100644
> --- /dev/null
> +++ b/drivers/leds/rgb/leds-asus-aura-scsi.c
[ ... ]
> +struct asus_aura {
> +	struct scsi_device	*sdev;
> +	struct asus_aura_led	leds[ARION_NUM_LEDS];
> +
> +	/* Serializes the cached colours and pending flags. */
> +	spinlock_t		lock;
> +	struct work_struct	work;
> +
> +	/* DMA-safe staging buffer, the only memory ever mapped for DMA. */
> +	u8			tx[ENE_RGB_LEN];
> +};

[Severity: High]
Can this corrupt memory on non-cache-coherent architectures? The tx buffer =
is
a 3-byte array sharing a cacheline with the lock and work members. If mapped
for DMA, a cacheline invalidation during the DMA operation could clobber
concurrent CPU writes to the lock (e.g., from asus_aura_set()), leading to
lock corruption and crashes. Should this buffer be isolated to its own
cacheline using ____cacheline_aligned?

[ ... ]
> +static int ene_write_reg(struct asus_aura *aura, u16 reg,
> +			 const u8 *tx, u8 len)
> +{
[ ... ]
> +	/*
> +	 * Stack memory is not DMA-safe (VMAP_STACK), so the payload is
> +	 * copied into the per-device buffer first.
> +	 */
> +	memcpy(aura->tx, tx, len);
> +	ret =3D blk_rq_map_kern(rq, aura->tx, len, GFP_NOIO);

[Severity: Low]
Does this code compile? The blk_rq_map_kern() function requires five
arguments, including the request queue (struct request_queue *q) as the
first parameter, but only four are provided here.

[ ... ]
> +static int asus_aura_register_led(struct asus_aura *aura, int index)
> +{
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
Does this build? The strscpy() function takes three arguments: destination,
source, and the size of the destination buffer. The size argument is missing
here.

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
Is kzalloc_obj() a defined macro in this context? It seems its use here
could prevent the driver from compiling. Should this use kzalloc() with
sizeof(*aura) instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923121832.2613=
187-1-nbg2974@gmail.com?part=3D1
