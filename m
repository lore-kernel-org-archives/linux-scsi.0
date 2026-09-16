Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F74E13F8;
	Wed, 16 Sep 2026 12:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789561666; cv=none; b=OlAckHEfetRdfegm0wIxBLonsNOZ1bIJZNsxJ4KfU68YKi07/A0Ty1tlArR51YM5jnU2fMMgHnq0TrZgVnzz+XFSpt+4qqxI9JVsnfHelKSJuc84ZtXDic9rasZh0S6vYHso2zScihCwxXbkc161iItfscFTR0XWXAOH3sG5k3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789561666; c=relaxed/simple;
	bh=1nd/8P6T2zVrJoNxyfJqD8sFxenBg40XtKL7VE2CDrk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZwIHH97+j1ciA/SkcRsDZXpYc6icxr/Cqxl8C5UFaf/FXUCrhPZNy71WtBV0Jzjulm10jRq5hG/LQijCXOvSmplymh+3oxl65PT7LQAAIAWoTvKkB+6Q9Os/DCxtTYxpect56ghOtM55XqYKPWXvb7RUaAOUyaU4cAkRVE7O8w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4eldvR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4eldvR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921E51F000FF;
	Wed, 16 Sep 2026 12:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789561660;
	bh=PKeFjUWBRbd12a9J/W/C+VJ+sxvWqJzmP2tP8tu1KlU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j4eldvR+gCmFvXC/jvu9I8qxdZwAFZ2pqBnfz8PjIxknJjaqh/iuWxNTrZPx3V+TC
	 m7D7IdhCiRXpRhxHLVmM1hFdE39d283nkf8XA8Omjh81dc6GER/S8f05oXVmV07bqH
	 6pAvKMgNvIefBRytPGsGd4lWPGZUg8/0oKs3JjLMMHsuNFEy4K7NP7FGTxNaJ4Rtm/
	 1cZQIcbBdx6KygXzQ5rncwx8JY4MlvvvnLCFrALNWBLAtSTSRdL5tLiKx1zx2velut
	 2T0js8hgcr9ZkjvMCphenJEpQ3gCqAu72/UfksMO29Uu2bx/F36qCY2WAKpCb9mj44
	 bXnjoKf38cH+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v5 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: linux-scsi@vger.kernel.org, lee@kernel.org, linux-leds@vger.kernel.org
In-Reply-To: <202609162015.RFCv5-1.lhw@gmail.com>
References: <202609162015.RFCv5-0.lhw@gmail.com>
 <202609162015.RFCv5-1.lhw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 12:27:40 +0000
Message-Id: <20260916122740.921E51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Low] block: build failure due to missing request_queue argument in blk_r=
q_map_kern()
- [Low] leds: build failure due to undefined macro kzalloc_obj()
- [Low] leds: UAPI naming convention violation for LED class device
--

commit fe7900b55dc69157a3ef071f13e8783fac33da59
Author: Liang Haowen <nbg2974@gmail.com>

leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit adds a new SCSI driver for ASUS Aura RGB LEDs found on ROG
NVMe enclosures. It exposes each LED as a multicolor LED class device by
routing vendor SCSI commands. Updates are batched and scheduled via a
workqueue to prevent concurrent writes.

> diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-=
aura-scsi.c
> new file mode 100644
> index 0000000000000..a1e31dc3f0101
> --- /dev/null
> +++ b/drivers/leds/leds-asus-aura-scsi.c
[ ... ]
> +	if (arg_count) {
> +		ret =3D blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);

[Severity: Low]
Does this build against the current block layer?

The blk_rq_map_kern() function requires five arguments, including a
struct request_queue pointer. Only four arguments are provided here.

> +		if (ret)
> +			goto out;
> +	}
[ ... ]
> +	/*
> +	 * Include the sdev's H:C:T:L: every enclosure gets its own SCSI
> +	 * host, so the names stay unique when more than one is connected.
> +	 * With a static name the LED core would register the second
> +	 * enclosure's LEDs under renamed nodes (asus-arion:led0_1), which
> +	 * is the wrong device identity. The names are per-attachment, like
> +	 * sd X letters, and userspace is expected to enumerate.
> +	 *
> +	 * dev_name() renders the sdev as H:C:T:L; the extra colons would
> +	 * break the devicename:color:function scheme userspace parses LED
> +	 * class names with, so they are flattened to dashes and the name
> +	 * keeps exactly one separator.
> +	 */
> +	strscpy(hctl, dev_name(&zone->sdev->sdev_gendev), sizeof(hctl));
> +	strreplace(hctl, ':', '-');
> +	cdev->name =3D kasprintf(GFP_KERNEL, "asus-arion-%s:led%d", hctl, index=
);

[Severity: Low]
Does this naming scheme violate the UAPI LED naming convention?

The standard format requires two colons (devicename:color:function), as
documented in Documentation/leds/leds-class.rst. The comment above states
this follows the devicename:color:function convention, but the generated
name (e.g., asus-arion-xxxx:led0) only contains a single colon.

> +	if (!cdev->name)
> +		return -ENOMEM;
[ ... ]
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	zone =3D kzalloc_obj(*zone, GFP_KERNEL);

[Severity: Low]
Is kzalloc_obj() a valid macro in the kernel API?

It appears to be undefined, which will cause a build failure.
Should this just be kzalloc(sizeof(*zone), GFP_KERNEL)?

> +	if (!zone)
> +		return SCSI_DH_NOMEM;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202609162015.RFCv5-=
1.lhw@gmail.com?part=3D1
