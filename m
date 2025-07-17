Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0ED35963
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 14:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752764082; cv=none; b=J/m179yhZNH6DPVwTWg4LngovgmviTYrsh1m/drDHCiKv+zJMHe/x6/cxoBLgjEKjNORPLVzhVbQMck9w6IgWLmNPN4SCbRkNVrLco/wy+QN/8Cn9h4sj5IxYzoSydsFSfVGzdZBKGASnsG6rYZQ9nNV8hPiTuOERXi78v0UXR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752764082; c=relaxed/simple;
	bh=6GJZm+3lrq7+IRQsUKzMxu6oujhxjo1LFpEHywXw64I=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DUijByUrsyQF+nMAqn0kHYoByvroQmy/zcuq4tYCAsPPZceQWco+CCwaiVLVRKrhcGMtXg8lqDARr6q4Y/VUdHfKIj0vn64o2tx+IVAZn6Ha/MbZ5snjpMXbHPy2xFWbv29Jq1PajAc1VSU65dQ4gOtRaIs536CxL2aWaFSODa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmDNuzgN; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmDNuzgN"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ae0a0cd709bso389781266b.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752764079; x=1753368879; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GJZm+3lrq7+IRQsUKzMxu6oujhxjo1LFpEHywXw64I=;
        b=hmDNuzgNDvw44r0XpnLtDVrDN3mH0XhRxFUyToCUUU6Nt8BTN2gKsHCFhzS87pINxn
         VVnomLnfyMePOKBTlTdpZdngI+XoRygctKleHtmG+c/YJlJt2SSmG/45G67IDounEKSn
         lBizQKuSEWOlQMFB078bEvut2nVdfL7rOsGHL5ZrPtSPP09t8FOkBsrSEOVe5UZhgsiK
         iSWfly+khtYCWWF+nLO9nVlGAiS9FYzx5fTlpHD1AlUXvB3Pj1eFkRG4zOQq/NiecKzG
         ez7sKFCrH1LzavbK7UbJ+MsANn1VC9S3s3mIzMviHRYynd797DJThGTJY4jNWckDV2GV
         0yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752764079; x=1753368879;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6GJZm+3lrq7+IRQsUKzMxu6oujhxjo1LFpEHywXw64I=;
        b=jj6V/ilm6MsseZLWig80GE1f3/MX6vgW/XGl2/Z+oa+eSRWKWjEXWGGCl8SEdxMDBu
         wdZwdcSBwD10etEE3W+4BdgzF/tfoEkOLss86r2Ofpn433kgf+iQHPSyoAOPkT9+eqxE
         QvyH81v2yqkPAKHMf4AqpNNZnV/EiGUswXxOzvaqDH9qRmlo6LVzRyQZdKtP0Ur4iEUo
         N80+e/JKmkkgrU0AJcpgIfi/etzMaP2sRFfcg8CXI06LR8alF2acxZhjAXMeUbegzgkU
         EbHTFe2LZQ8YI5TZtaWoFO1iLr95gHu6GSnAbBh8ghf5uUQlciBJ/t/QjCMWCx5nQYeB
         OVDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHeBIoL/Wb9M2GB7zrSL8FfapTb6xufouh1MnCDhC28X6ryNTRx7oEqsS9vd1Rk8xRxSO2Tq9Nk2Y/@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6iUT4QQ18D7YwX5jWXLa6Q1dODtdOwaVMH0/TsBkV0mFBWThw
	xaCa+C1p95DiZaJwrrIrU5tJvQ4CUYqOKiBRsCssnTFe70Rb+SaRUeCg
X-Gm-Gg: ASbGncu5ytJFHLf74ouke428ELiE4s3BVCpIHXmoBxS3hZ6OuZ1QuMhLeV/ubDuwBuR
	0TfavHbyWAUQzrq+C+IDvKLQbjcDXZQMiOJ3626KozZQH/8MpnGgKT1iX7zjpz3hQDrGbuQv5gW
	wnYFqCq81+uhzPNsSJUGfmhjSlY8Y8IcfAV3iE2VFmjM+ZZ6IB4WH+A/OW53qJjhrkdojQN8xX9
	RTPABljAEd71awQ/MU+OGZabXRkLtGPYsaetPjIJQYKYq4n6AwpoU8KRYLXg/HNPiXBPk4T/LS6
	yQnBjtrHebCspn01IlgmLisenLWquaUJK5yV6B/eTwMb5P/Ad6oAFKiJKAXCwn9vby6qXCQ2ii2
	TWxdD4ProwbpRjpsOoSdib4zb
X-Google-Smtp-Source: AGHT+IFxszyCxxGq9QUj4Zlw/zEuocnWDvM4RD0QxrgccqMfoXpz6j3oIBbByXGFXJsF/ul67jwxsQ==
X-Received: by 2002:a17:907:a089:b0:ad8:942b:1d53 with SMTP id a640c23a62f3a-aec66076ee9mr10681566b.27.1752764078741;
        Thu, 17 Jul 2025 07:54:38 -0700 (PDT)
Received: from [10.176.234.34] ([137.201.254.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7e90388sm1386500766b.16.2025.07.17.07.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 07:54:38 -0700 (PDT)
Message-ID: <1b37b4990e22ecf05b458417026a7a854764831b.camel@gmail.com>
Subject: Re: [PATCH v2] ufs: core: Use link recovery when the h8 exit
 failure during runtime resume
From: Bean Huo <huobean@gmail.com>
To: Seunghui Lee <sh043.lee@samsung.com>, alim.akhtar@samsung.com, 
 avri.altman@wdc.com, bvanassche@acm.org,
 James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, sdriver.sec@samsung.com
Date: Thu, 17 Jul 2025 16:54:37 +0200
In-Reply-To: <20250717081213.6811-1-sh043.lee@samsung.com>
References: 
	<CGME20250717081220epcas1p224952b344389e4967beb893297f1ae02@epcas1p2.samsung.com>
	 <20250717081213.6811-1-sh043.lee@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-07-17 at 17:12 +0900, Seunghui Lee wrote:
> If the h8 exit fails during runtime resume process,
> the runtime thread enters runtime suspend immediately
> and the error handler operates at the same time.
> It becomes stuck and cannot be recovered through the error handler.
> To fix this, use link recovery instead of the error handler.
>=20
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and oth=
er error recovery paths")
> Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>

Based on my investigation, if child device's runtime-resume fails,the upper=
 layer will set the status back to suspended. It assumes that
the driver or error handler will communicate with the device and handle
recovery. If there is no better solution to fix this issue than this
patch, let's go with this.

Reviewed-By: Bean Huo <beanhuo@micron.com>

