Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E4C36E478;
	Thu,  8 Oct 2026 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791462729; cv=none; b=KQQJ6FhZdJm4tRMrM9aGLH/SRPzPaUZHdbs7+DVMY5SyiNOw2S6F53E6AHPfaZVXG1s2Bi4a9dn7OA0BDw9cuigSMb7quimJN5gdvDHbE+vMqX3rTGpNoHiiT99mwHjiJdvC6xbVXhBXK9Iu17udK3yZcHjLC44yhB95LIopNIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791462729; c=relaxed/simple;
	bh=uGE0VMiM7blq4jZbeQ5ZnfKrDVDABk4uGT734FNXEbk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=FSDZXn+ifxrOgfHfxKl194T094EjwP9lG05KA4pCpvdHVuLFCdv90hTsY33e4Wstp4noqzG/HH1F48BPELWQ03W0CLihCeiu+W9Pb+QbNCfHPdO7il38OSKzo0b7pMBzosWeCsBB2ELDDGqvdc9w8QZl3YaI+m5aUbSC19gfOQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNGCRH9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNGCRH9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703441F000FF;
	Thu,  8 Oct 2026 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791462727;
	bh=qBBAc7f00A2dndtcAWkvdRNpA22/JFBIhkR2g+rGJcU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZNGCRH9OwIkWr1AzCWFi36scnuNxqaejyz/4DpIy9KdalqayYDkHpsRxEIUdR4xw0
	 GAuQ26jhvc0BVcaeQ6u7aeScJ6KiNpjslpu1JQY2emCVghlIclHpemcE35SSil/DiA
	 GL7N+A3xWr0R6cFi9UfM7g13E+HUP6TTykGRuDU5a0jrmdNJBAgZ3qiQAMtiOqGysD
	 WKUGkbPPqZ8Oxt4kQM4QOqbWU92Nf4bbkBjds9jI4kxUc95M8roCHXMLriUifUsCA3
	 R/DDaLzHxovkmlcRkq6LFO+/EgHSyl0A7eHtNrEgk0cwZb/Q1aBpcZqsxhDtTy6y47
	 P6+vjdyyX/LNw==
Message-ID: <sashiko-outbox-164145@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] usb: uas: implement .change_queue_depth to allow
 per-device queue depth override
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luca Cecchi" <luca.cecchi.info@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
References: <20261008112645.1820678-1-luca.cecchi.info@gmail.com>
 <20261008122604.1862534-1-luca.cecchi.info@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 12:32:07 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> uas_host_template does not implement .change_queue_depth. Because of
> that, the standard sysfs queue_depth attribute stays read-only for
> every UAS device, not just mine: scsi_sysfs.c:sdev_store_queue_depth()
> requires sht->change_queue_depth to be non-NULL before it allows a
> write.
>=20
> uas_probe() already defaults can_queue to qdepth - 2, with a comment
> acknowledging that "some bridge firmwares" need extra margin. That
> margin isn't enough for every bridge. Right now the only way to work
> around a bridge that needs more headroom is the IGNORE_UAS quirk,
> which disables UAS entirely and falls back to BOT/usb-storage - a
> large performance cost for a queue-depth problem.
>=20
> This patch wires up .change_queue_depth so affected users can lower
> the depth for just their device (e.g. via a udev rule matching
> [ ... ]
>     already used by uas_sdev_configure() and the other scsi_device-
>     level callbacks in this file) instead of casting
>     sdev->host->hostdata, which was pushing the line past 80 columns.
>=20
> Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008122604.1862=
534-1-luca.cecchi.info@gmail.com?part=3D1

