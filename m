Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485DB2EEE60;
	Thu,  4 Jun 2026 22:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780613061; cv=none; b=p8D4al4O/F1kaG35LgDsUlUyZLZSxMhCGfDMg0u6EdJTbQDzZ6qbg5eU8AAI69BvZrW2wNI5k7MOHta5942ENEP7SWDKygVfBWCT3pIhXYZ4SaPKoOSKUvbwPK+tWeUZP2LSzuC0D2nEr8LNfJl26RLmkvhfgx4xRfNU0OZs7gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780613061; c=relaxed/simple;
	bh=8yG3hmJeXfhOki6iEgnszcBPwjW87nMiZVym7d7NkmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GbHkG4HWwCCi4ulj4rXMhXDWGP5/SM/qZ3GLIBM17AUTneyiml4B0StrjVWrQhZYV1kZQ6IZ0/O84UL+DYx67gzDrLkdSLgZMc/sg1CaVn0Zwd2j4eSaQH5cxTCGC/RbbDK6ZW+5KKRxJ1vOa/kfpVbWyj4DidRTOTVhs8NWVfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=bKVkdvyY; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="bKVkdvyY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1780613045; x=1781217845; i=deller@gmx.de;
	bh=PFMsaYqUkIvJcMLTpZQf1DqgjSH1Dec2993/mJDniwE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=bKVkdvyYWOMD039fytO+OTDkxbqYPSbXpK3Z7FwB6f+w4YmPln6oQAHZNs4PvXV2
	 1r2KXjhR/8Fe0kWMegg+0mXVFjkUuE24vz80TjRWlIu7+HtTO6624mjujRRvRW/Mp
	 CU4bZH8wNRJdXWNgshJUaZZHnY29tDx/zPQVcdd/uA9EVB2AzlcWzwlZoEK+t6D4R
	 PpwTUJXhUYRmA7MMndFC8qPvwcrTG+p76ptalLkWWaSB4nq1AkxSBVfgVUyP7hlUU
	 wZi47lVfB8o95TTtOBmVjoxLE1yhUOOvYW503e4v9wg6zbYsxsxjDrZuFGyy6vCv3
	 khq7JznSszoVP17+0g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MwQXH-1xMgC02Ukv-00yTHx; Fri, 05
 Jun 2026 00:44:05 +0200
Message-ID: <a3f9e96e-3bbb-4cfc-845c-58649405a1cf@gmx.de>
Date: Fri, 5 Jun 2026 00:44:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/8] zorro: Improve handling of pointers in
 zorro_device_id::driver_data
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>
Cc: linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 "Christian A. Ehrhardt" <christian.ehrhardt@codasip.com>,
 "Christian A. Ehrhardt" <lk@c--e.de>
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/b4ONhQClKbvxFm5HU0vfhRh79gGv/xtJ55Vi39S7by3cEpwjgY
 J80qonyXA3O7qgdTCSZXjFSqItahaZMZ+hEinZmtxId7dnI5rIDUi0jn1teNkRtH3f+4J2d
 BuCK0DJsMOMI19D3EqwyIP9P50P637WuIjdp5AE6pQKoCKx2+t30DLBloY2oXzXLyUALLNc
 X7TRNir3eFev9ubrXTxvw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:G2MXmyA/vFU=;zZfIg8BCGWf2Dqj0H2tSQBqiD+/
 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
 LTriLKyuAOzyfqUYlo=

Hi Uwe,

On 5/26/26 16:17, Uwe Kleine-K=C3=83=C2=B6nig (The Capable Hub) wrote:
> Hello,
>=20
> this series is about improving the handling of pointers in struct
> zorro_device_id's driver_data.
>=20
> While it's ok on all current Linux platforms to store a pointer in an
> unsigned long variable, it involves casting that loses type information.
> This can be nicely seen in patch #7 where after profiting from patch #6
> the compiler notices a missing const.
>=20
> Preparing for that change, all zorro_device_ids are converted to use
> named initializers, which is also a nice cleanup that could stand for
> itself, as it improves readability for humans. (That is necessary
> because an anonymous union can be initialized by name, but not using a
> list initializer.)
>=20
> My motivation for this series is the CHERI hardware extension. With that
> pointers are bigger than longs and thus you cannot store pointers in
> zorro_device_id::driver_data. So this series is also about getting
> support for CHERI into the mainline, but I hope the clean up effects
> mentioned above are justification enough to accept this series.
>=20
> The dependencies in this series are as follows:
>=20
>   - Patch #5 depends on #1, #2
>   - Patches #7 and #8 depend on patch #6.
>=20
> So if the ata maintainers agreed to merge their patch #1 via scsi, and
> Geert agrees to patch #5 and that it's also merged via scsi, patches #1,
> #2, #6 and #7 can go in without further coordination.
>=20
> Patches #3, #4 and #5 are only about using the same initialization style
> for all zorro_device_id and can go in without coordination.
>=20
> Best regards
> Uwe
>=20
> Uwe Kleine-K=C3=B6nig (The Capable Hub) (8):
>    ata: pata_budda: Use named initializer for zorro_device_id
>    scsi: Use named initializer for zorro_device_id
>    net: Use named initializer for zorro_device_id arrays
>    i2c: icy: Use named initializer for zorro_device_id arrays
>    video: fm2fb: Use named initializer for zorro_device_id array
>    zorro: Simplify storing pointers in device id struct
>    scsi: zorro7xx: Make use of struct zorro_device_id::driver_data_ptr
>    video: cirrusfb: Make use of struct zorro_device_id::driver_data_ptr
>=20
>   drivers/ata/pata_buddha.c             |  8 ++++----
>   drivers/i2c/busses/i2c-icy.c          |  4 ++--
>   drivers/net/ethernet/8390/hydra.c     |  4 ++--
>   drivers/net/ethernet/8390/xsurf100.c  |  4 ++--
>   drivers/net/ethernet/8390/zorro8390.c |  6 +++---
>   drivers/net/ethernet/amd/a2065.c      |  8 ++++----
>   drivers/net/ethernet/amd/ariadne.c    |  4 ++--
>   drivers/scsi/a2091.c                  |  6 +++---
>   drivers/scsi/gvp11.c                  | 17 ++++++++--------
>   drivers/scsi/zorro7xx.c               | 16 +++++++--------
>   drivers/scsi/zorro_esp.c              |  2 +-
>   drivers/video/fbdev/cirrusfb.c        | 28 +++++++++++++--------------
>   drivers/video/fbdev/fm2fb.c           |  6 +++---
>   include/linux/mod_devicetable.h       |  6 +++++-
>   14 files changed, 62 insertions(+), 57 deletions(-)

you may add to the series:
Acked-by: Helge Deller <deller@gmx.de>

Since it touches various subtrees, I assume you will merge it though your =
tree?

Helge
