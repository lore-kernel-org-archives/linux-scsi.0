Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56879394481
	for <linux-scsi@vger.kernel.org>; Wed,  4 Feb 2026 08:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770194276; cv=none; b=T8G8wxTXyjipEi5VLqwPBh7vRiMKSVh5WPx2Pq74wo8IgldrhkciuRGGBgNV/LyQwmj9eswwv50jTrkazp1VpVP+FQjFjeH7Y0yCGtq7dmVosLLdWzG18FCjIsyJxatFO6cqhOmQAd7GLH0CPEaThceEgwr8eNcMCuXkMMYV3wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770194276; c=relaxed/simple;
	bh=YdGqnKEXZqPfejPy+MWDZJlt5n9n5NEiIZZsEFwyGbI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h6Dq0/w0Rae2+RuRStpHMXUA2rRv+8S10vSbxlAR2QTgbeYUI/vuFYExLoQXU4pn7mo/PxxW/UHVoOgTv/Bb1aFoyhfH1A9bAYzLbSU1oX+QF6uF2W7JxRkZEhehbGLM9QR3wxiOhKS4HCJBy68Spf7D+m3E+9OaSpL4TT0EUpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BmyYo5Yc; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BmyYo5Yc"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-435a517be33so3897920f8f.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Feb 2026 00:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770194275; x=1770799075; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YdGqnKEXZqPfejPy+MWDZJlt5n9n5NEiIZZsEFwyGbI=;
        b=BmyYo5Yc+5frcx3oQ8iRzs7iSTpsXLh3VAmvVJf6i6XsSgQYrkNjrgtkkMoYpSP/HI
         FnHpHuSxoM7qexfaew2PxolAsGWMSVft7hG1BrF9tkkHubIAuijpD95UOMeETLMir3ZL
         5tjxePJimm8JTGZOcYiRAvGKCOUFgJciqumH8CaZLf+s5YOJ9AsFTgfgQmZqRCPf69xf
         TrPw7uEz525z5ySMLttoESHqeUnQw09eaCUUrQifgWhioU47YoXlT5jb/nQuKOsmKKle
         x6ETjMfPJRMKeKZjlb2CkFKJZO3mEnyBBqVOcr3iju16J4x4f7ZZgudvfzcbVyDdZtLw
         KYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770194275; x=1770799075;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YdGqnKEXZqPfejPy+MWDZJlt5n9n5NEiIZZsEFwyGbI=;
        b=P7OfbEjqQQ04klH34mr4TS1ttb31NYdKJbujNAne1UoSz/6WF08rPzbV5WxSCchjL8
         5UBupfuYb02lRERLX+PoflM6R2kL3psc99e2yJjeGBnmmdYZtk5a2FadG/+8x2WrR6o/
         bCfiYkzqkjUJlg7+wvQwM55TnAtKgkwaTXX9BUgzsWGLA0g6fP8O2kvYbJXVcskRl6kS
         VFyNwWwPuPqbhkWWrItk33sW/eCF1DYaQZMDWxin9ueW9cs5a7xfqAvn3+5ZD3PvvpW4
         JYUNM1MEdcVmCoRcvbDDr6HUbmKt/7gK+eAmEeJMIVR5d8glIVgvTkGGXtDK51ST1mK4
         ov4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWT8t90zeIOgE94xBoJlfi10TjwrfITV/1WCwZ0TiU4A/rCQYAravkEgBUgbfbkoe1lBVdeP8f8Y123@vger.kernel.org
X-Gm-Message-State: AOJu0YyaH00j00Pb4Hh+rHbEv7dkhOB1zsfVs6foqmwY8Qe8P0BxPnZM
	MD1zaMP44BBMqWDTea36BMwpqYYorPGQ1h8ynXXlbuls2hNF9ZoFAMY+
X-Gm-Gg: AZuq6aLa/XKU+wvG4v8JtETfWgzY4JWJqZQmrKLvqrmB7xzI/Wu1vK1cviiHx+3PJ0R
	oqBWigM+Y0kv5IXILIyLEleXoFazF/0BXbvcm1lWYVj4TRLCxlOnpsnojRsQ9IjkD44t3nRMEJQ
	4vX1DrMtZzrgPJDYpuFNYrEKc4OzXkggPkxp2nhy9Q4+M+RfWmuOKbNazhY/ehjEwaOQdv4hVjm
	39cDGS1nTz4TOklRbECf1OXAgx2JSSh1OGvNE5UjMW5GduTPcPP6DU3P3p071pFZ6m23tmpbsYC
	8/w7LTOjiWIdRoXkd6ju2C2queo2EkrXCRLqU2U0iDXbB7MW1b8l51KsuNAcgZRc2GXTcX3dFO2
	+HCoqT6gfvyQb55eUSWggaWXfKx2r+jVeKnhSuyNxhhQCinBYe4Q/jeGajLmOpnGS/qFxVklZHR
	gMBssvo2vgoQEbiw==
X-Received: by 2002:a05:6000:1885:b0:425:769e:515a with SMTP id ffacd0b85a97d-4361805c0famr3038165f8f.42.1770194274302;
        Wed, 04 Feb 2026 00:37:54 -0800 (PST)
Received: from [10.176.235.211] ([137.201.254.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43617e38e38sm4832086f8f.11.2026.02.04.00.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 00:37:53 -0800 (PST)
Message-ID: <a729a7d1b63d0b7e78806bfec238d8db2705c693.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix RPMB region size detection for UFS
 2.2
From: Bean Huo <huobean@gmail.com>
To: Alexey Charkov <alchark@flipper.net>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@wdc.com>,  Bart Van Assche <bvanassche@acm.org>, "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, Can Guo
 <can.guo@oss.qualcomm.com>,  linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Wed, 04 Feb 2026 09:37:51 +0100
In-Reply-To: <CAKTNdwG_RycHp++Z++D5HzcybSyQwvKbb++AhtXhNgE6sOoThQ@mail.gmail.com>
References: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net>
	 <8149b8cb5a7b36a1543ca05666f33a6373674e0e.camel@gmail.com>
	 <CAKTNdwG=He3iJ8cPo4fFbcEwQQRrt_SGzoviMhi2a3kMXAO8hA@mail.gmail.com>
	 <ad7e2d0e5b219b4b2ef2aa7ab342513a2c66171f.camel@gmail.com>
	 <CAKTNdwG_RycHp++Z++D5HzcybSyQwvKbb++AhtXhNgE6sOoThQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-01-30 at 18:49 +0400, Alexey Charkov wrote:
> > > The spec says it can only be up to 16MB maximum (see section 12.4.3.1
> > > RPMB Resources), so it should always fit. Happy to add a comment abou=
t
> > > that.
> > >=20
> > > Best regards,
> > > Alexey
> >=20
> > Hi Alexey,
> >=20
> > Thanks for the clarification on the 16MB RPMB limit - that addresses th=
e
> > overflow concern.
> >=20
> >=20
> > In your above operation, why not use SZ_128K to avoid the magic number?
> > BTW, please update your comment.
>=20
> Good point, thanks Bean! Will amend in v2.
>=20
> Best regards,
> Alexey

Alexey,=20

did you send your new version patch?

Kind regards,
Bean

