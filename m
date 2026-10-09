Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCF7547054;
	Fri,  9 Oct 2026 08:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791534029; cv=none; b=J5Ok7OUJSZvAXqhmX5Q/gte0rblIbTEkRNkyWJLWQy174uGLIBYxG5mWgk4bge/3gQuG2ZzJ9Tz0iemkoCG0wiX02idwIaHUM05R3IobOKISnVUAyDSiEAITXMac6w/0cYWlnHAHw+zBe9g6vm1WOECWSXZtuyAPXMmXWfUbcJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791534029; c=relaxed/simple;
	bh=xOwzGWN+USzcefBNI8xdmyQDNX9v26vSK2uct5s4ze4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=MGXG3esU/Ukhwo7ovMk6wpLLYwfvlMuiRG0Q/P4UwInPmIMBpa6bb/cXgVbakH/pvuRR2RIDjXL/Evva1Gw9KIw4lF6bJsqvq9mjwzxP3V7rYbt559YUeQroU5IZrphAgnEOSH18pwq21G8/ZBRiPG1AOSX4mhFg6NaeYvEekNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfkQ+Tg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfkQ+Tg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42031F000FF;
	Fri,  9 Oct 2026 08:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791534028;
	bh=jbHxsDVjzyCCbR5e+D9fKqHLrddR/HwQTSslLnUDcLQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CfkQ+Tg7Tlr5Vjja/ujQl1QExilHAcZRlsQc/AnsKJZ9Ac7opjJGRY2qs1vV5Xrz3
	 mXXqfGa7zIeb+AXhaLyptQR4+WrgwpN8x/d3YvVaEoD2ej6XrvnXm141fL1YVuH7DN
	 6WSrB3I4wS5cvqVL+13JohO8KZUYlxOnCglRmVCVcewIGIsA6uv0maEwR8njwOdHAU
	 iABl91aG8w7n3N3Cnhhv3br2lTCRpsonIAjpXAsUiDOg0SK4mR91AbdkcLKODG/Fsm
	 9+cMTnAnC90deJWSh0eskWb7/3WpFOYR33KgzzrUi8NEuhGNKt+6qW2fFf6CUrNyW+
	 bDa8S+oQBsY1w==
Message-ID: <sashiko-outbox-165073@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] usb: uas: add US_FL_QDEPTH_075 quirk to cap
 queue depth at probe time
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luca Cecchi" <luca.cecchi.info@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261009081225.304319-2-luca.cecchi.info@gmail.com>
References: <20261009080341.295646-1-luca.cecchi.info@gmail.com>
 <20261009081225.304319-1-luca.cecchi.info@gmail.com>
 <20261009081225.304319-2-luca.cecchi.info@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 08:20:28 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The previous patch in this series ("usb: uas: implement
> .change_queue_depth to allow per-device queue depth override") lets
> userspace lower a device's queue depth via the standard sysfs
> attribute, but only after udev has had a chance to act. That still
> leaves a window between probe and udev's write where the device runs
> at the full default depth.
>=20
> This adds US_FL_QDEPTH_075: it caps can_queue to 3/4 of the device's
> reported maximum directly in uas_probe(), closing that window for
> devices that need it. Applied here to the Lexar ES3 enclosure
> (21c4:0003) from the previous patch.
>=20
> v3: Sashiko AI review found two real issues in v2 (first version of
>     this patch, sent alongside v2 of patch 1), both fixed:
>=20
> [ ... ]
>       from udev.
>     - Mixed 70/30 read/write load: 614MB/s read + 263MB/s write, zero
>       events.
>=20
> Signed-off-by: Luca Cecchi <luca.cecchi.info@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009081225.3043=
19-1-luca.cecchi.info@gmail.com?part=3D2

