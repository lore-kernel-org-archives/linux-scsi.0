Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785792;
	b=0uMl9tKUYZ8Iyft+x4+Hd2hGs2dJI7gVBfkgZSR1W0tHawRhnQi+0o0AbRch2C6+rKVw
	 lnvHGp67QqhtFxIGhkLwZyN5MMVQM4elHaByApYczCw6MRL2pvO2QxRl+paHpubpqSdHS
	 cjyK3mCscMP0lO9NKoVzGx1cv1no2JeGnYHuUFa+W7ai9uREJ6Das8BzD1b3BbgKyxqqj
	 iMpDEJOr//KDlU3J7q6/eLpOsZGXcVaxP/xVrsemG7G0B+42a2rIwrMafcOA3Afj2VGAu
	 pdhQ5cxXkLnT/z5p2a8zT4sMOAEAwFR+5fBwvaOJBM3g72B8FXng8iTtZCvtbFOyMAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=KAS0wy/i0clkfxFIn/srR3uONpIvsKGVrttrQi0V7rA=;
	b=gH5Wr0jZtr5WKhdrbU5RSdWeygdc8qXYN2scxsafZpR6IczcEi+Ku1W9P5EFzvTYd5cF
	 4C1B9OQbpJX/VMMx5rUWCQ+u46EKTAqM2QViur+ND3tGsgzchABXwFmZTb4a4j1imabex
	 HHiV+C+iEJjXq0t3IucOsuSqnBV7Vq8ikAk+MAjHFT74MD8i04VehjC+xUWj/OcfKx+/b
	 ThYqVek4y+P7iNhdXbe0cZEYAeISJNwXOIUQntsPSK2NWkX0Dtj79kRo9N7DlW3ey7O0K
	 vRZmqbuFVHR0seOzaOa8OsC5i4UPrLnDbpCThuuQCopgPBa8iugXqZqAnsbacWA/M3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="T/R0dNr0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2CD606A32A;
	Fri, 23 Oct 2026 20:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T/R0dNr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D5E1F01825;
	Fri, 23 Oct 2026 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792785791;
	bh=KAS0wy/i0clkfxFIn/srR3uONpIvsKGVrttrQi0V7rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/R0dNr0LbtSXiXvXUJ24g0WTY/w5eU8Z7qh0qPRCVO0ww2DaLHWFknE2f2j525YS
	 09FGWnXIDBhQMzbL/c0xAESNxjKsoMiWgyCYMuhtmbGgn/Oq7DaMiTlIkA1FenRqdT
	 bWWeGAEybhfcrZfApkPo0nN0fREEAkTq9xvyitkstUmpWTvqLDEPRCfM8flXkFd9X3
	 U8uGlGzgZM1dsgDf612bqViOjrO/jsFq6UDBh61tU6O5T1NVzPkklFd2I1x9VAkA02
	 Zj+sfPfhwIiwL+uIqWXXEaxTl2QhmAUUsYc1gmvg0Hkv6yOoSzs07FsLkk7EM0HJga
	 YOYSOInifxybA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	Daniil Stas <daniil.stas@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Chris Healy <cphealy@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Subject: Re: [PATCH 5.10, 5.15, 6.1] hwmon: (drivetemp) Fix driver producing garbage data when SCSI errors occur
Date: Fri, 23 Oct 2026 16:02:49 -0400
Message-ID: <2026-10-23-1-daily-reply-0013-drivetemp-scsi-errors-6-1-5-15-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1792730299-21490-1-git-send-email-nobuhiro.iwamatsu.x90@mail.toshiba>
References: <1792730299-21490-1-git-send-email-nobuhiro.iwamatsu.x90@mail.toshiba>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Currently the driver just passes error codes of scsi_execute_cmd() to
> hwmon core, which is incorrect because hwmon only checks for negative
> error codes.

Queued for 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
