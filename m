Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAC4386545
	for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 09:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774257335; cv=none; b=GoPE2UXg8Inrh9NnX8LgHIEyqaPNe7jU5q8s5Abv4TkPXKJJYaWZ27rSJWdwfnuejwv8O0DpISzzPfA/JYv81Nhz+vDZTgWsNb1oauwjNy7Nyt6xH0pFcTdWG2G23T5TGdmJjLsoGbGR/4V/oZqrqqjyQ6SwlHzdqG/Qf86/E0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774257335; c=relaxed/simple;
	bh=qdA44R/ZD2AU0lFSrU8KXeGmW4fAmBeQaM3Te8hIG3s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n+HHVCrDUyUdimRUcFltpk74w9oZYcVpaOrVamQoLIiDzAFG8LfWDZdxWTUcgiShPKegqkDH2grNFMwyfA3pPd/xzqbz7x+Xhsd7rEwKKcHma2g+g0PNbV1zqBIMHQTxkQiatFZPYdJbCbF469W3YVfEnEKLr2kt1onkL9asycI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Twf5hSL0; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Twf5hSL0"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-483487335c2so30483135e9.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Mar 2026 02:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774257332; x=1774862132; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qdA44R/ZD2AU0lFSrU8KXeGmW4fAmBeQaM3Te8hIG3s=;
        b=Twf5hSL0LjxxMLp7AHR1g7OqhkqB2oGoG50w8HIBVNSgr1gcgMguVjkcr5BvRI9A70
         lChK5vlXJzi+9/z2PAdAhYlOr8inHuHh9YWpnBEaS8RGaUKSgJKaklb+vSm222bpFnAM
         mV/bHomWjSmbeEoSmQenHxCvQjiuWLlQDr8pL7gsBcKopjc932WwjTIZS14dw9Dy4g7m
         4pfnAadkYokbB3mU9TASI4phmDzSVCS5jZJBA54w27dMtjPGcpy4XhMmJL7JEdsQ3iQV
         CL7m4zQR4suv9sg4Z0Yr8gjDShMZzWcQ9tPBINv9aycbtPovRyzeUwWGg3uqgabb04cs
         RBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774257332; x=1774862132;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdA44R/ZD2AU0lFSrU8KXeGmW4fAmBeQaM3Te8hIG3s=;
        b=Zwxi/1pm/NdhmjpcpEVxqq1QHUqFDLgSFn/BlbtVR4wxeJwj3NYHDy+SuoS9lmK83t
         03kP286y/oIUN00cG8aBz/W9hOUZ523YWsIJCS83GGAqZthglQc5Tdmk2OKR3u/fgQRg
         JkuNeN7xcF1lghWOcvX0uLNQEJ3Oq7z0ICy09wvceFt/lrH+6Agq1//wm6nJwuUmNwp5
         UhErjGbfHMBsb7Kej90ULzkiGSz8dVs0cXaLEk9GcQa21+S7hF9A9sBzEf6E5rb2bdY9
         dTrqM1QEIwiPmsdLCw1/vWPspPIqDzZCmO14R/02ukHKcRIzpQLYr76sl+3cBixCbSEB
         Xx4w==
X-Gm-Message-State: AOJu0YwwzgfWFLji7UGq7H5SJFX0gR979se0EJkiHjCzSky1F10llnc5
	95zXLx4leJuIlCFbbe6iGEbM/VKmDYqt3znAEzGLSC6weuqp7TvUbW20
X-Gm-Gg: ATEYQzzKGhqirFmBYz2WoxiWevSZ5RSVRJS4h852pME/tMKTIoox+8+V4K6XYlWufCo
	R0hzFP5DIaVnNaM0NKJd5QxRtg2DtAJ21wNqsneK9l9OhPInhGNKqKjHLcIM272m3UaqMWqFXS3
	Qx46kYqqT5H4CKZjhqyGZsrrV0/Mi8gBbqie8iFcY1pteN02coL8UlA9BzSlYWcmWnR47lY7vBu
	fKCBsYrLiIsPpUDdbtXi+XeobXwJDNptwo8GleUT0b/qyu+CIbhCQ2lEOpgGoAyZgZiTzz5YR7I
	QKlJqu6MbXsxCtisaCgi0lmnJ3UPNaZNCl+ZBw147x9ZI9U7h3VeGdbOsEfNiGHKmPiJgRyKQrH
	eDmKOVJh8r7bvbgjNAlOLyz1gT2LcoNsr0B4NCrN56+YvdkZjOu5R5IEWRO24e7SiIWVPWDZ+1F
	C4ARugwpm3exhExUcM4f+PuJpaHyorUVMMEoGM
X-Received: by 2002:a05:600c:c84:b0:485:3812:36f6 with SMTP id 5b1f17b1804b1-486fee0bcc1mr158424375e9.21.1774257332190;
        Mon, 23 Mar 2026 02:15:32 -0700 (PDT)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487003ec0d5sm100137185e9.1.2026.03.23.02.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 02:15:31 -0700 (PDT)
Message-ID: <799143ca545c8ea156455a871aa50a6e55e6bf95.camel@gmail.com>
Subject: Re: [PATCH v4 04/12] scsi: ufs: core: Add support for TX
 Equalization
From: Bean Huo <huobean@gmail.com>
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 bvanassche@acm.org,  beanhuo@micron.com, peter.wang@mediatek.com,
 martin.petersen@oracle.com,  mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Bao D.
 Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter
 <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
Date: Mon, 23 Mar 2026 10:15:28 +0100
In-Reply-To: <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
	 <20260321031021.1722459-5-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-03-20 at 20:10 -0700, Can Guo wrote:
> MIPI Unipro3.0 introduced PA_TxEQGnSetting and PA_PreCodeEn attributes fo=
r
> TX Equalization and Pre-Coding. It is Host Software's responsibility to
> configure these attributes for both host and device before initiating
> Power Mode Change to High-Speed Gears.
>=20
> MIPI Unipro3.0 also introduced TX Equalization Training (EQTR) to identif=
y
> optimal TX Equalization settings for use by both Host's and Device's
> UniPro. TX EQTR shall be initiated from the most reliable High-Speed Gear
> (HS-G1) targeting High-Speed Gears (HS-G4 to HS-G6).
>=20
> Implement TX Equalization configuration and TX EQTR procedure as defined
> in UFSHCI v5.0 specification. The TX EQTR procedure determines the optima=
l
> TX Equalization settings by iterating through all possible PreShoot and
> DeEmphasis combinations and selecting the best combinations for both Host
> and Device based on Figure of Merit (FOM) evaluation.
>=20
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>

Can, fix those two nits and add my Reviewed-by tag. Thanks!

Reviewed-by: Bean Huo <beanhuo@micron.com>
