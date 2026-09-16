Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA2030216D;
	Wed, 16 Sep 2026 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789569514; cv=none; b=U6rYlEmK7QGuqcZnObiHjFHHg6FFK5qtud2DmbJ5AOYrgeVsAkxD8ifd4KniX9iwbts74oZZiZjvE/5Veuwm72mRcUjwj9Jj7MzvgnOwWJnhTGZ26Ox3L8bR6s/4RF1MBCAauj22kQx5shhM7STuZJEPK4zotvjCyXKXMTOlf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789569514; c=relaxed/simple;
	bh=SAaUZGK6HhitAArliPZWW2TIL3VruYSE/HOsA3yJulY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iRj22O6m+umQoX+0/eY4KDcLejdySvj3SWPfiLrEpYrHE4goLaSl+WRG66kOw/cg2meLtD6qWeOQhd4qdT6vFu/lWISumf9WgGduWIJ+ageKb+im916ro0c6YLS7yBKHXus8vQ4JTuN/b9FRUmBi53YhfNKJDrpBaKkOWrZaXcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DU4pZ7QF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DU4pZ7QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520721F000FF;
	Wed, 16 Sep 2026 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789569512;
	bh=hHGmgnVc0ESRq0FOyQJkvQvhus4V+/q6oG/3XX5xsqI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DU4pZ7QFIceNPE8ymlTRDEhIYit4SWw7o7A7k40xyb63v9YyBLqRzkSxTZXO8WKdq
	 ZxCxMV0zjJqNBsf9D7vacD/WctAfHXWB/DiZGD2ppV4qWWc/lTewEgycadggFWcoLE
	 +RyErzN2UTSQsnVYDY1p4ZCKh3dYD6Ird8cFqmyPvU2mrkPbmHC9iPxN7lAVM0XZX4
	 JMIHGZX0O4BNIEu/oJKekDObKIo1/G36XZY2N47GZH8/7SV1J/mrWOt1DvULDemeag
	 1uCwxZ3DNsu4brD35nPlfeCTe4QjLYttaZT4sS2nLWTuO8m4DkaVV9dC3w7jRirkI0
	 XriHNUNn2uz/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v6 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-leds@vger.kernel.org, lee@kernel.org
In-Reply-To: <202609162200.RFCv6-1.lhw@gmail.com>
References: <202609162200.RFCv6-0.lhw@gmail.com>
 <202609162200.RFCv6-1.lhw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 14:38:31 +0000
Message-Id: <20260916143832.520721F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] leds: build failure due to undefined kzalloc_obj()
--

commit 8323106d834da191a6608c0c1f5330cc2b52094f
Author: Liang Haowen <nbg2974@gmail.com>

leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit adds a new driver for ASUS Aura RGB LEDs on ROG external NVMe
enclosures. It exposes the 4 independently addressable LEDs as multicolor L=
ED
class devices driven via vendor SCSI commands.

> diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-=
aura-scsi.c
> new file mode 100644
> index 0000000000000..4e039bdbe76ac
> --- /dev/null
> +++ b/drivers/leds/leds-asus-aura-scsi.c
[ ... ]
> +static int asus_aura_attach(struct scsi_device *sdev)
> +{
> +	struct asus_aura_zone *zone;
> +	int i, ret;
> +
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	zone =3D kzalloc_obj(*zone, GFP_KERNEL);

[Severity: Low]
Does this code fail to compile because kzalloc_obj() is undefined? In
asus_aura_attach() in drivers/leds/leds-asus-aura-scsi.c, this line trigger=
s a
compilation error since kzalloc_obj() is not a valid Linux kernel memory
allocation API. Should this be a call to kzalloc(sizeof(*zone), GFP_KERNEL)
instead?

> +	if (!zone)
> +		return SCSI_DH_NOMEM;
> +	zone->sdev =3D sdev;
> +	spin_lock_init(&zone->lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202609162200.RFCv6-=
1.lhw@gmail.com?part=3D1
