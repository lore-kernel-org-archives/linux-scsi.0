Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5722C344D94
	for <linux-scsi@vger.kernel.org>; Thu,  5 Feb 2026 08:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770280383; cv=pass; b=OpxAuu8kHL8BS5FGkZmGdF4UO89486ovy3DukcZEqT+Hffib7b5+4CbtQuk7Xu/S+q0qJPyZfh1qaf0jWQhZikYxZQsl/8v0WxLEb6U/EhongtBIWIOSaCfyeuAQx9m4uZaE2PfshEx42F2JkRjTbzCeSPKmLSLga+lkPv9H7ZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770280383; c=relaxed/simple;
	bh=4nRf6SHJsVhZfYah+s5gm1QOcWTJwdFxjn6FWyPfPpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iL6VO1WZ1G8nwR3Ii3eg3XVMxCi6HFhCMugyMg1gUkzFCQ91Ev8X/sr+820KC1Z0o16TtE8N85apv+rq4na1RW7UTi21J38U8nQxnMlZPh2qBAipLT3PTxWH68aQbSk5IuCOBFveTmUdSAgyfn9CYmwc0Po6uf49hH/1UZutPMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=HjcjDghD; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="HjcjDghD"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so123110066b.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2026 00:33:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770280382; cv=none;
        d=google.com; s=arc-20240605;
        b=O25BBfE4qMLX03rm9tH64zQs7KLzBHu+TZluuaowq5iOwcrgqvLbQFxDXPJRdbk/9f
         0hP8uQx/Zrn4c6i3bAXGFsBJc7vTOBspjw5swFWO3B82rm3bIn4Ca485r7h4qZ8X74kN
         CT+21wgNvoXjYQuS6JU1fAhBEPzYnuN3izHezXD6Zb2cijxxVVgqe5bSAXI5xGDT7rFo
         A/PgpXwOPxoDiwnvRkKDFfYRazHtlXfd8xdYRE76AT3MHVhErTPkG6zqbScTwgS/QSK2
         Qzf4+IBohPE0tPbDCvvMLYGmYjAWKRieXW/cErDiaVLVnAUjAwIXyqw1Q6OTuX1uMzCh
         rEjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4nRf6SHJsVhZfYah+s5gm1QOcWTJwdFxjn6FWyPfPpI=;
        fh=a7Z7VV0c4KPjhs5qQpKX6pDTxUvqpcP+nnuAVxePFO4=;
        b=Hp74pXJhweKNlPYjZgkP2sk0wWEu5MrGcAN/UvTlTM/tIE+nlS/RhwUL0sGZc1ltGR
         2HeavL0P0dtcPwtRgDriNlREAoHRB+cLQ2R2k8LKQ2h40/AAclAU9PPgorzFHfBfOHsv
         GYtzD2yqNr8IJHNuHZojv1VeoD4rLg40237r3IdNten96k8huFgLeL/VHnypNXG4ublM
         1+USIWid4qaUft1raRkJDfa3Ok9V2lKbso8l9itjgy/6UvS3nh1AVUGtgKKFAD90CJvH
         4G7H/eBOhN55eAaZHEb4usVpkdXuhqwFKJ04uVQNrDCviwj8Z/saP7EsDjew1Sfxs4Hz
         dbMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1770280382; x=1770885182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nRf6SHJsVhZfYah+s5gm1QOcWTJwdFxjn6FWyPfPpI=;
        b=HjcjDghDS/90cGDiNRVffTvIvz0gqHw2tenTaaodvNszai2MyVomSf+bHa73gQdxBg
         doZEZZ+RFD1NqfNhAIWk2ZXiSu+5422TIROD/L3lcaZFi0LJkLStltJgBLHCo7Z7TIN+
         Qx14E0+EHu0G+bXlr47C0hn0yRGBWpVpg49hpRvHZ5AB1nzvOo9xwCN3qyD6X0wipujk
         1SMuYmgAQ4BOtlgTEjWpoOoAsK0xChsMwp5/5sVpenSig/T0/TiCziPf5kPWnpSvN5Hv
         oz1KNNoYCKc+xK4d3bl4lSF9Ht9REYLObBeDaDPHGS1souRnzKY++t/Nae1J0Td1trec
         eDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770280382; x=1770885182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4nRf6SHJsVhZfYah+s5gm1QOcWTJwdFxjn6FWyPfPpI=;
        b=gX+sjSm1lhmmidydsNUozpepqkGnQuuNek55HvKIbxzyHm468rIHK9wqGaxDHKSZaN
         iwFyxlNKQ1gnqlMDH7llng5ktiFkcvVbnehdP7Thz9DnMPjzwfqBjgpu6v2WHairhdvo
         8DBsJVWvNgTdW08vlz1CDxyVU17kbmK9jRzGrOWVB92XIsL3evwNCUnWsnMQ2fEUuO/H
         QcXEiH/tpnFCoLGsx/3jhlsRMpLXVAO+/W1ZHAk8LhEncoGMd/NgY+mZYqfBWvkhIVC3
         wKe6PFA4HFB6/4aDk7lGd3kNhs8gjy06uILCmRM7kfo9zIlHBfjCAPZB+KBRXbKLD3+2
         4+BA==
X-Forwarded-Encrypted: i=1; AJvYcCXPWNrKKVoz9tFhyxD56eTfoMzwRCUMear4z4m5IrDYody3E22kBr2Of8b+ZaCvKHv2z951iXhctujw@vger.kernel.org
X-Gm-Message-State: AOJu0YzABlLigI1f3EzaVVBdeINBcIj7ZGYxHCcnCC74l7GdROJvMtxa
	B28NlB3t73ng7Ns3z+knt3271yXkgKuKc7hlhSCJslvYqS8+X3HwbN9BmY4/DqccwxwfQIrau7p
	L7kmR0mG2jAtF9Rh9AZ5lpe9JU6bMjiOlZV6LVCHMxg==
X-Gm-Gg: AZuq6aLDE7wiqnDtFnYalLlx8CXKTMa1Uq27gHtvulz7yD/sPNfk7rejbtCWBWMO7cn
	PXw7iK6+djB7guBjNYnrOnwpvWqFIcXfBfQha67mKqY1jwz94xzdtUVz0B5wbGJpdeQk+VIAJBj
	6hYwUeqUk+koyd40+/PDG3f28YT5K16vFHx5EP6HUSkg0Q+mLdQ+GcFrJERFJU3ym4FbqSuWNWU
	zh9ph0KW4irf7OYodvVlz19fRKUN4jCLyBQHBLTj0fKUXXU9xBMRo1uATHNboio+JwThCrW7Ffv
	y0Q2zr5Q0au1GxpMMLC+0nKvCoB/
X-Received: by 2002:a17:906:8f8a:b0:b88:637d:aa75 with SMTP id
 a640c23a62f3a-b8e9f3c9e3emr429179066b.30.1770280381624; Thu, 05 Feb 2026
 00:33:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net>
 <8149b8cb5a7b36a1543ca05666f33a6373674e0e.camel@gmail.com>
 <CAKTNdwG=He3iJ8cPo4fFbcEwQQRrt_SGzoviMhi2a3kMXAO8hA@mail.gmail.com>
 <ad7e2d0e5b219b4b2ef2aa7ab342513a2c66171f.camel@gmail.com>
 <CAKTNdwG_RycHp++Z++D5HzcybSyQwvKbb++AhtXhNgE6sOoThQ@mail.gmail.com> <a729a7d1b63d0b7e78806bfec238d8db2705c693.camel@gmail.com>
In-Reply-To: <a729a7d1b63d0b7e78806bfec238d8db2705c693.camel@gmail.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Thu, 5 Feb 2026 12:32:51 +0400
X-Gm-Features: AZwV_QiABBd14DLM48ZE4ziYazv0fNb_LhoTNM5ingrU5uicHByC4S43axTn9GU
Message-ID: <CAKTNdwGE5oR-axDGYfBCsmG_p=G1oeKCDZ6GmYoRHMN1PXcJSg@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix RPMB region size detection for UFS 2.2
To: Bean Huo <huobean@gmail.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bean,

On Wed, Feb 4, 2026 at 12:37=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> On Fri, 2026-01-30 at 18:49 +0400, Alexey Charkov wrote:
> > > > The spec says it can only be up to 16MB maximum (see section 12.4.3=
.1
> > > > RPMB Resources), so it should always fit. Happy to add a comment ab=
out
> > > > that.
> > > >
> > > > Best regards,
> > > > Alexey
> > >
> > > Hi Alexey,
> > >
> > > Thanks for the clarification on the 16MB RPMB limit - that addresses =
the
> > > overflow concern.
> > >
> > >
> > > In your above operation, why not use SZ_128K to avoid the magic numbe=
r?
> > > BTW, please update your comment.
> >
> > Good point, thanks Bean! Will amend in v2.
> >
> > Best regards,
> > Alexey
>
> Alexey,
>
> did you send your new version patch?

Just sent it out, thanks for your help!

Best regards,
Alexey
