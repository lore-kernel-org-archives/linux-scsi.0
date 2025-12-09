Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BD332862D
	for <linux-scsi@vger.kernel.org>; Tue,  9 Dec 2025 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765315602; cv=none; b=ZzEQ+Eds1liTTqQdO1FQSpue1WZ3aDWGWrNd4W8HJP2a/We18Wc8QsHf20zgKW99cOaGmxUVZeiUDHvDAWt+1f2ZgtQJjKqBIbjOnbs1otGxsgKF324FNb+SA910FvC3d4dX5xDnJfj3Mgav9RU55A8wyrXXhjbXMX6sjhhOtFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765315602; c=relaxed/simple;
	bh=/pHDHDxU6hfgJJT8nqFLrEkunNthwWpW3H6rfoOkJUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1PAq3vxBkPQkA9E/XM3a3hF7vY99GPRcyjuf6SA8Eb41o5ccIdRI0lO0xX09JnjEssIKPB2LxZq2Pl7dcaqElsTEt/CyOscZ9+uhMDkO7O8Iho2UPy/yqAQAg0sBi3zHj5NOm19xo9ggr/G3bKxmGN3Fr77YU+4XV2izgCku48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=drejCEDN; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="drejCEDN"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so9920923a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 13:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1765315598; x=1765920398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwbbyU40SptznEhvch2S64/esv6V/zeeP+0i6BUXRGY=;
        b=drejCEDNL7UZk4OGxRP7LNH9L9xBRY2fM5NtV77wmqi77k0tb6oqoz6NON4kCqwZhh
         3UKJZ+CRgrpCPFWRB3Tk+y51isHlC0ALVMpJXKZJ3u3iJtmlxpSlrAPA/oqE5/ZBju+G
         IvwzqWxr6OOrYtSP2Msk+rQT8PlPAQ/2BNu+wvs9GBkGSATJqj+ebqhjuJxQPs2t4Czm
         JF2gg30hNZGwI/g171iR7xhjbxFR+kRRC2gExSrqO4oQvPQiYBw2oijcj7Sx8PCuggem
         XQInaFyOvZEWk/tmpOG8sBxlyz7tu4fY4+H6PvX4SuExgesBwM6YlK3anAjlaPYQrVjN
         fBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765315598; x=1765920398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwbbyU40SptznEhvch2S64/esv6V/zeeP+0i6BUXRGY=;
        b=FRcFBWFflUDPluKcNEn0iKwdxZNQ30IQEOq3/OE5PP9OgYW8TQmmNB0UrlzazP2+g1
         S5yp0m5YN4RMhLdN+sPL2M0MmdTI+P7vwpeYzZz/rhXvfCuNKCZly7eI9/RyrTfANh62
         luJBVK2GmGp5QEbJIVgsKn/uQzt0coZ6G3eZlwxRD2/+ghdqFwObJ/Yptx4vsHslRn4H
         JAooNjd+OzeGHDNPBHuzPXZPO09JjDUMy1dr9vQ5cTRAwrulEyI+ZQjf/yojfVWknTCT
         sMI1DB+o3gsnklUWl5eoQmlVqnBwTIyhTdCQNnDsoe/ap3BYq6r+uYZEgj0ysUg7szzA
         b5nw==
X-Forwarded-Encrypted: i=1; AJvYcCVuDoS7h2/Xrnyw/Brq532xXxh3FL9Zy/Dl5uvvdk22lX9ljEBhfx63YLI30HSX3SN6M2L13GX8YR56@vger.kernel.org
X-Gm-Message-State: AOJu0YwnStg+ITkMgdoU2zrC79ADM8LZXgJWpjy5xbNmFpDr4xFu2oEy
	gB6hBID6jr3WEb0GKkpP0LrzmTHhRyeDRPVf6Zaxp9xAircXrUYtHI7JdWWlMA7CykA=
X-Gm-Gg: ASbGnctkAmMOVZm7cGe1ZsB++pieNBNqQW4Z0sVTXZqzmxPQ7Jj7wWwv6jBgxxXrbDG
	fP7qLdbgstmQoTuyPzp0q6ehGBqJorz6Hx0a2fJ+fCW+l2UpLnJWuKTWULeW+9PjxHikCBAfwIK
	+XeH3ZsgMCgzqPFfsEi2f7h6COv8Z4cejgOPjVNGt2kFMJSzIMN9zJ1R/e3fvl+piaL64CD/lQu
	iU57Td/EYkbN6xMOn+u5FksKRVsCHz1w+rwQSHXitN8xPLjhauAAuNLoNx+M2kX23ID4x/ZPUyF
	d8DIh4Z1bp6450EB1iuaQQ9B2WtDFIYXhwIKW55HcgTJk1bPcrYzrmDGbofev+X2f1Ft8AUm+sl
	im6WBO8lmE0q0pilstdMz1KbOXyOEpm8vx4InEBru2Ssq/JrlwZvqPWleTi0dYwXSq+qLsixTM1
	5cRWhShTfo5pD3e1l+
X-Google-Smtp-Source: AGHT+IE/704fKY5SFopT+bENRWN8WXApAuAnyJrgtTVjIpKaAOUqjW7UFCte7tioWrFlOpYpgAq4Ww==
X-Received: by 2002:a17:906:f596:b0:b72:b8a9:78f4 with SMTP id a640c23a62f3a-b7ce8416484mr6240566b.39.1765315597154;
        Tue, 09 Dec 2025 13:26:37 -0800 (PST)
Received: from localhost ([2a02:8071:b783:6940:1d24:d58d:2b65:c291])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b79f4a15660sm1503242866b.63.2025.12.09.13.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 13:26:36 -0800 (PST)
Date: Tue, 9 Dec 2025 22:26:35 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
Message-ID: <zzg7idgonsinuydv3a63cr56627lw2ymfopjiwfycsoshipmjd@mwk3bihumcg3>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
 <59b408f6d89d402457a23564302afcbb334bc9dd.1765312062.git.u.kleine-koenig@baylibre.com>
 <818c2c48-6962-46bb-8268-d377eaed3083@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j765t24o26ukj26l"
Content-Disposition: inline
In-Reply-To: <818c2c48-6962-46bb-8268-d377eaed3083@acm.org>


--j765t24o26ukj26l
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/8] scsi: Make use of bus callbacks
MIME-Version: 1.0

Hello Bart,

On Tue, Dec 09, 2025 at 01:00:03PM -0800, Bart Van Assche wrote:
> On 12/9/25 12:45 PM, Uwe Kleine-K=F6nig wrote:
> > The objective is to get rid of users of struct device_driver callbacks
> > .probe(), .remove() and .shutdown() to eventually remove these. Until
> > all scsi drivers are converted this results in a runtime warning about
> > the drivers needing an update because there is a bus probe function and
> > a driver probe function. The in-tree drivers are fixed by the following
> > commits.
> Which runtime warning? Has that runtime warning perhaps been introduced
> by a patch series that has not yet been merged?

the warning is in driver_register() (drivers/base/driver.c):

        if ((drv->bus->probe && drv->probe) ||
            (drv->bus->remove && drv->remove) ||
            (drv->bus->shutdown && drv->shutdown))
                pr_warn("Driver '%s' needs updating - please use "
                        "bus_type methods\n", drv->name);

since commit 594c8281f905 ("[PATCH] Add bus_type probe, remove, shutdown
methods.") which is in v2.6.16-rc1.

Best regards
Uwe

--j765t24o26ukj26l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmk4lAkACgkQj4D7WH0S
/k5B/wgAo5h52rMSKabNpUg5lsH3FM1k9VLHrNvm45qbkYy2cmu6v8Yq9UDqInUV
HU2+DPUoB2/uBeJIyyZR/4UNnH1Uu7IxCBnAJYZrnhKG1r63j+duKHQ+aBj+M/XR
F8yYOrMlpbPGMQNr5ms6jQW1fkmgxDr9oE8VH5KHTi8Oq3tRTVtlwVtaVP4G7gM5
D4L7I1RZird903uM9OgUK27ZyiWkTYxfzde6OLyHCd0fv1SixHKecPbINxoJU9Sw
nG75SAtMR1NCyKOWMqdaJxie8LNdmJX4ngn2Q5e9dvemEcXhswVrgFqA91ByvkdJ
jZsmwB0gX1fNPMb8Js38AsnUtgGkag==
=g0Jn
-----END PGP SIGNATURE-----

--j765t24o26ukj26l--
