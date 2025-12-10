Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495522EA171
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 09:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765360225; cv=none; b=d29YXW3hs29qwnOOl8J/J1EDiQqS5bMclYQJ7Vc+P10xjUx5FkxCh2sV0SuxoDk9XxEkYmE5+UebzwVQZF/ZvQebFx0Yh0HdmZIQrQxRtE1yJN8MwBKBh/6gFuyvl4Ri5MakVdaLlhS1acpd/TF8RLd6mHBmWWojsNRISa2NfBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765360225; c=relaxed/simple;
	bh=whCZjUGqv3vrEEtIiN/ZjgJpiaWYSpV1Iq0xItypr1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XbfNQQ3WALSvrflxNtskBCyoZNfLCljPavx+2ecXkTp8Z2UU+T7EZrWQmXFkopidDV4Y16tVF+d/xeitYFdIqZk64es24bnLWnQhTCfjzPiZYZFy9j7pQysV/wzAzGL2vW15wjeEu6GuPdAPN/XR+DlpeBj++6tfaMT16vl0nvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=v5/v7gAh; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="v5/v7gAh"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b735e278fa1so1183525866b.0
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 01:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765360220; x=1765965020; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oZE9JfKqeRb0SFtDgmq72mgYbh+yhXmkqKswR12GDlA=;
        b=v5/v7gAh4j4zVBpbIyH50Qbicn92XTFQ/KU+dz7OBBTXOxfse62sAgDNvoLm75yuzn
         npRltYfIHoat0XHyOrBH0dtxpsYUJLmyuO1hAMBYqUA1uxerg1lAxXIJtQqBwejriugN
         vsAqEYYVWCH9NuPU3+J5cZAV6HcR3PixoV+BLoESPbBYmgAjfQ2qJGRvvze1UzL8VLlu
         THhkBE06FpWgjyO1dOubKDJnsK4RHbl8vdiMFtJhe1XzgSyKf8sfIngtwgVeOmdSwcpE
         /OCJqHgJUh0370YwKl8PcAKYyjc7JU4n1EKVGBm5OLNqDu3WeI1UVvBetoLUOygeY3wb
         1A7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765360220; x=1765965020;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oZE9JfKqeRb0SFtDgmq72mgYbh+yhXmkqKswR12GDlA=;
        b=Xz1okCwElKMKksvo2RzjVjn7eQJ02Zb93bQHwi6gAbO4xKXS1WeaiB1JezSLSQLgpo
         V/5Dl3OT5YnE89C8kdM1sYvqVmpQEEbjTqalAHxrCIjanUSQn9j0lcP78fzql7/9jwBP
         ZvTsvsDK+kVTc8t7r0abr3IpFGFs9B5jDRZBkDnH0OFtczm7CwBXEe+z+3CLQFdZpxGZ
         9ZPi2/kXT/GhJviDKCkMglH0Oy9utrxsBJnlHrtal/P6AmWBXfK/RdsdYL/L+hBmzjds
         QU6ePYTba4WXQj/l2+7OL8AJC6AoWYNjimXUvZhB6Pfx/J349Mlrqj5OfH0hugfchW6c
         XqEw==
X-Forwarded-Encrypted: i=1; AJvYcCXW7xnmswFjQ/rOcBOV5A+sqzyuplqB0a/Z1pvSYBL5plfbJ0Yl3CEoRiD/HeRBLqdBvd4m6aUZMCOM@vger.kernel.org
X-Gm-Message-State: AOJu0YzVyrIj4m/9ABt+Fcq1qYmK85WcY2sk4Cusoh4SHsvm7zF3t8IR
	iVoeAf5Z4C4oa3CI6j6Kkgwj+nA0DTmYLmrIdxYmcqnF+7J3C0R+WPS7nuved1VC8wFY81/uqY3
	vniqB
X-Gm-Gg: ASbGncs5/2ZDwVvdFZUcbFLJOXyd9zRyu+k/sDKre2adTR8c3OZAJoewYWAxWEctNCu
	EwrMaZynZ09yVt8kt7RX/APkWFwXGFUPgDIXZyHemkwFzFkt35Ug8EInTcqLlazFodNv3bV+9mT
	1BS7LJIWyqe/Gv506BUA7iTtxLiC/h/8LrP3rVmbEckmM7N4xpIXsTh+ZGJycoTDp6fYkfh7H65
	NJ34Kw4GT0XVFyajnjThswoQ+Tc5fTV7cHNcQdEXwu2mLkpfs4PMsI2BCEoj8mw5AQVuRcvTxrv
	tV9aFl9UffyZg8ozEfsyq6OTWshXQB7kK95N+oeQQpLgjWpIHAdh9Dqxu52VVdgkRrbjHZPc+kq
	ZaSTJdF4Cv3pyhatGUn2oksYBNEZcKYRCUdDy65ZaXZY8kK57eStR3UmnZldcS5KcyAxdOk/P9y
	WA5Lu4Sg61DmeeHa127FssL6ZZWTieWpACggpsnqO2PpLZetTvPggmYDVdCrENSPdvi7eXPqaPm
	Gg=
X-Google-Smtp-Source: AGHT+IGQqcfjtS5Gd3gksd8VZay5YfyWjZxi9MAt2gHysXctBXrgnWSSGfPVdgIj8+61byLBhCsRJw==
X-Received: by 2002:a17:907:96ac:b0:b76:bcf5:a388 with SMTP id a640c23a62f3a-b7ce8450d3cmr195956366b.50.1765360220436;
        Wed, 10 Dec 2025 01:50:20 -0800 (PST)
Received: from localhost (p200300f65f00660876e6d1cee70127e1.dip0.t-ipconnect.de. [2003:f6:5f00:6608:76e6:d1ce:e701:27e1])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b7a715226b7sm366718066b.22.2025.12.10.01.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 01:50:19 -0800 (PST)
Date: Wed, 10 Dec 2025 10:50:18 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: kernel test robot <lkp@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	oe-kbuild-all@lists.linux.dev, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
Message-ID: <3cxoce4geqes4nfneujjgjscyspktptdthktnqlm2uqivtfvju@kddvyhidg6bh>
References: <1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig@baylibre.com>
 <202512101723.HHskrJpy-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fibr6uhimrcvt46t"
Content-Disposition: inline
In-Reply-To: <202512101723.HHskrJpy-lkp@intel.com>


--fibr6uhimrcvt46t
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
MIME-Version: 1.0

On Wed, Dec 10, 2025 at 05:20:24PM +0800, kernel test robot wrote:
> Hi Uwe,
>=20
> kernel test robot noticed the following build warnings:
>=20
> [auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]
>=20
> url:    https://github.com/intel-lab-lkp/linux/commits/Uwe-Kleine-K-nig/s=
csi-Pass-a-struct-scsi_driver-to-scsi_-un-register_driver/20251210-044843
> base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
> patch link:    https://lore.kernel.org/r/1931ec5bbe8d0ad82b6fbc77939d43bf=
5a4f177f.1765312062.git.u.kleine-koenig%40baylibre.com
> patch subject: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
> config: parisc-defconfig (https://download.01.org/0day-ci/archive/2025121=
0/202512101723.HHskrJpy-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251210/202512101723.HHskrJpy-lkp@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512101723.HHskrJpy-lkp=
@intel.com/
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> Warning: drivers/scsi/sd.c:3912 function parameter 'sdp' not described=
 in 'sd_probe'
> >> Warning: drivers/scsi/sd.c:4061 function parameter 'sd' not described =
in 'sd_remove'

Oh, this needs:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index afed915eb158..99a55bc026b4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3895,7 +3895,7 @@ static int sd_format_disk_name(char *prefix, int inde=
x, char *buf, int buflen)
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
  *	for each scsi device (not just disks) present.
- *	@dev: pointer to device object
+ *	@sdp: pointer to scsi device object
  *
  *	Returns 0 if successful (or not interested in this scsi device=20
  *	(e.g. scanner)); 1 when there is an error.
@@ -4051,7 +4051,7 @@ static int sd_probe(struct scsi_device *sdp)
  *	sd_remove - called whenever a scsi disk (previously recognized by
  *	sd_probe) is detached from the system. It is called (potentially
  *	multiple times) during sd module unload.
- *	@dev: pointer to device object
+ *	@sd: pointer to scsi device object
  *
  *	Note: this function is invoked from the scsi mid-level.
  *	This function potentially frees up a device name (e.g. /dev/sdc)

I added that to my local tree, so if I send out a v2 this will be
included. But I'm also open for someone picking up this version and
squashing the above changes into patch #4. :-)

Best regards
Uwe

--fibr6uhimrcvt46t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmk5QlcACgkQj4D7WH0S
/k7ougf8D2uDMTspGVVqQkC8rbY1Pu7JdYdkanHQpkF9MQ2QoNHWubEpLgub0vDV
gKnEQK4PinmXjC54YdECeAm5TR4/YBI1UUOqgFiD6ZX/dEUleOfl2t7gg5XIUnld
x+o1AC4WmU4cIt1ES7Fu7hw9bjyJMCDDmNyah+ZDv/bjXiARI8XuahstslbFSDtV
OQU9qh8TSfaecS29M7TtSFGwIasFZQ6rWpqTHBgL3TTYHi4FdfxvHFuJx/hDYcW3
TqR19jjETCMa7+y0m/OVTtzWH2qJhng0eJb8zBkD4NpxtLWudJDWADx6v2WVZ5YC
Ut9iv7NSyxJZ9vBCEe+d9L14BY41Iw==
=xqPc
-----END PGP SIGNATURE-----

--fibr6uhimrcvt46t--
