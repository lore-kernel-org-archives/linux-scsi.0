Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47BB2D7395
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 14:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769784568; cv=pass; b=In5jh69ikOX91upC8bd30Jl5nnIo+kUzBHnxiqv9blZdVKsjg2SaU6fqASgv2E4S861UTwZCJ/XB/GC0jEJIejjAMVEI8sB04DiP1u+EWJpS7ma61S/N2epAAMyvIe3OvjhutTuEwF8rATRAiBWMiEBTcBD6bm53glnW8O1TV9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769784568; c=relaxed/simple;
	bh=t4RRHGhKC9qO704K4djE/1HbC4sMRGVkjqlOcgIBrdY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uss1oJRs4jKsf4GXdW56vp1r0i2lkel3kQBgnlMedWMzg5MN+M8OIzhwlXO02AcPvOWv26G+79cR0FiLa3kQtXy2Y5PtPGT2Vpxlx1MRLQA9rVEg9fo0fQ9f3Q8ZPsKBw7iWEMkSNxJ7sPt7QiaL5nHHegUaN7kX0KP9Kuap9xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=9O4q55gZ; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="9O4q55gZ"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65815ec51d3so3832325a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 06:49:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769784565; cv=none;
        d=google.com; s=arc-20240605;
        b=Obibxm6Sbscd2wR4+nrzfRpwhQ0AJjTxqif4cyxuSt8BjW5Aj16I50o+TvXBhw8PWB
         RAzHEQNxP8YhcddqwZb9mjYe0/LwlmnXWbamAXTAP+Tcjno50MWxeB5O2qlX7QvvDr8O
         +hZCImBWfmuxVbWNLj1ZuUDhvUHEZADQbr/Z3filuauke8UsbnIb+ULNjWRM4MMIJ3Cp
         HUqCA3sePbw+wlQ4AWd4tFUbjqNMctOxiULTbOoplBiKcqkWZ4ASBGfo5nYSMDij5teE
         dK4Q+goAHZcrq0/ELPVtTSYm7CpikRFkhAODmG6DzkeOgWa9mmMy3O8AmGWwoyaZ01zh
         0jPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x6T4fm8App9HWL62KcSJuniw6LuHUvq2dfOPNBe2zag=;
        fh=g+PuKG3vlDF3Kmok0EcW5jaoZmLYeZUP7aGBC9qNVA4=;
        b=D48+EHh0Ee2wcN92Qu3+sSivf/CNr9JPZDgebe8Iv7gKddht5rE38itfM1tX40VShi
         yM/Vd1VUWUgQ/dMUJ9BW2M+PPVQAUxVzqWP2Mcq+alDLbNnO53Xr/fL5Mk6oZitje6L5
         ZL8ONbSueDIuc34lrmdgSopCl7JRE4diCAbXmszDI3D5R0AT9wUGJL4KVcH0nTgFk0e7
         KZ+1cKUlH36JQKv+Gi6sSqlwHO6hhnnQDVmaLMTW7rDIwumoijU9XW55llru/cMmqoAT
         Qhzb7mOcucsF7SNBeHiIuDpoz0Ys8Aijvz04DhjmtxyH4d/4ur2QltTyBAHyFy15QL8P
         AKsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1769784565; x=1770389365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6T4fm8App9HWL62KcSJuniw6LuHUvq2dfOPNBe2zag=;
        b=9O4q55gZ48tBmbH5KulEm2lX+1IWxcoaUuNjUC8wFx2wrrTKdHh1E7i+flosSMwiml
         JqnPzetZ8i5fvY+EDYO/9VRCjj1CGDAuJdaTY4o55kaRxt5QsDJMQ8nBGdTxb/UCMXBc
         drP251s4Q4Co9sX6ZmLA+0TWm4F1lJbR1xJ+YFlwHHmPB75ze14THmhsYovFoSKB/8tM
         fnk2G0XIZ7HdH7c7+sF+bSz7Dn15KhsjssvjgQ1LkQ3Dwx5uzQL+tspBMPj65CUD0U8N
         4XYT6V/x/m5Glj2jLIfJMLSN7qlCFYQwusloUfxBrgNNZmREtEiC4iRld+2dS5wxnAuH
         wonw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769784565; x=1770389365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x6T4fm8App9HWL62KcSJuniw6LuHUvq2dfOPNBe2zag=;
        b=ZJTk9eJTxVHhRZYfZ8nYXjIrYbSAIt76dIk+EMZ8p2JXESEi2Vv1FGaGfDjDQIhcP1
         gz4D/FytVVZbvLUrCd5OiEtFKAXPTwcT/Z+s0noc7Z3aj2uOFX6fstaGqQgwd6A6/B8W
         alNuHCqgTSItZiZ/lqURcwHvccH+U1GFesQcx+glip/ipgrgr0F4rZXQsvuSb0uvZ42O
         AsIYC0aFPLeJhp86uhegDCU2jkg+YKMxfMCEYL3lcCyhBbhQHrBCA3ltQaD0gwZau+Ot
         UL4ccNbyUZ+Gd7BE8kKKVULa/wVCR+pCo8WPeiLkcba0QxwYoXFlMRSRAW2U0b/v1miS
         hIvg==
X-Forwarded-Encrypted: i=1; AJvYcCV/4qBGgz53p7rSeo5qsXW0HS8d2eJt99b8YLVvipZyuLkT1vXF+ZB3YwnPCBLJ+/fie0Ayu9fJSGuU@vger.kernel.org
X-Gm-Message-State: AOJu0YxZPmtX5UOFKYcmDOkxGdZPzesdUfSW9SQYLaF/ZQlhGDxcZBGg
	A/jJJSnxb3aeDiyiaZqHIFyfg08nBgy3Gazt6iqPdTIqy0DbbZqal+ZBOWvrpPS95bEkevrdhDd
	e4yj+Mt4TnqJzM5NxTaGq9FzilU59c6MS9XDoS3wwAg==
X-Gm-Gg: AZuq6aKMQTkfx9uy5Hc9SGd/yk31Crf+ASeqt6+HVMaFXeobvtIPChEOqjwaoCCb/ZM
	UYMjCOZV5VCldP15AYoy5l4oY3pK0tsIC3RryjVtw5s0s3sXIIuS08+YVTMABQLiDSezsepzDEs
	16KUgmjQOSox5IjCNZhotti+NEH9fHlldmOl0zLj6xnQCBlO8KpPFmRBtJ4rwuSunCBVus1at1f
	jTSgagLqI+UHnWejjAT6X/m9+mnPZIeWfVuBhTLDE55h1ypPHivaeK2S6BGUHVho8fOl68re38W
	VJGdHedASBrZilNC52yT2J52uBuy
X-Received: by 2002:a17:906:4785:b0:b87:2c88:ce40 with SMTP id
 a640c23a62f3a-b8dff6073d9mr215693166b.27.1769784565271; Fri, 30 Jan 2026
 06:49:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129-ufs-rpmb-v1-1-691534ab723f@flipper.net>
 <8149b8cb5a7b36a1543ca05666f33a6373674e0e.camel@gmail.com>
 <CAKTNdwG=He3iJ8cPo4fFbcEwQQRrt_SGzoviMhi2a3kMXAO8hA@mail.gmail.com> <ad7e2d0e5b219b4b2ef2aa7ab342513a2c66171f.camel@gmail.com>
In-Reply-To: <ad7e2d0e5b219b4b2ef2aa7ab342513a2c66171f.camel@gmail.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Fri, 30 Jan 2026 18:49:14 +0400
X-Gm-Features: AZwV_QiavZVaj1w9rZNPzvcULQmPuISNIJXVnTsDwBtZZh2I1Sg-X-NvmZQE7LI
Message-ID: <CAKTNdwG_RycHp++Z++D5HzcybSyQwvKbb++AhtXhNgE6sOoThQ@mail.gmail.com>
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

On Fri, Jan 30, 2026 at 2:26=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> On Thu, 2026-01-29 at 21:10 +0400, Alexey Charkov wrote:
> > On Thu, Jan 29, 2026 at 8:53=E2=80=AFPM Bean Huo <huobean@gmail.com> wr=
ote:
> > >
> > > On Thu, 2026-01-29 at 11:38 +0400, Alexey Charkov wrote:
> > > > +                       hba->dev_info.rpmb_region_size[0] =3D
> > > > +                               get_unaligned_be64(desc_buf
> > > > +                                       +
> > > > RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_COUNT)
> > > > +                               <<
> > > > desc_buf[RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_SIZE]
> > > > +                               >> 17; /* convert to 128 kBytes uni=
ts */
> > > > +               }
> > > >          }
> > >
> > > Hi Alexey,
> > >
> > > thanks for your fix, I didn't notice there is UFS 2.x on the market w=
hich
> > > will
> > > use UFS OP-TEE RPMB framework.
> >
> > Hi Bean, it turns out many of the UFS modules for Rockchip RK3576
> > based devices are 2.2. I'm poking around the OP-TEE support on that
> > platform, and discovered that the existing driver didn't see the RPMB
> > at all, spent quite a bit of time trying to figure it out before
> > spotting the difference between the two spec versions :)
> >
> > > here is potential u8 Overflow, since for the UFS3.x+, it is u8 in uni=
t
> > > descriptor, but
> > >
> > >
> > > The calculation can overflow for larger RPMB regions (>32MB):
> > >    - A u8 can only represent up to 255 =C3=97 128KB =3D ~32MB
> > >    - The shift result is assigned directly without bounds checking
> >
> > The spec says it can only be up to 16MB maximum (see section 12.4.3.1
> > RPMB Resources), so it should always fit. Happy to add a comment about
> > that.
> >
> > Best regards,
> > Alexey
>
> Hi Alexey,
>
> Thanks for the clarification on the 16MB RPMB limit - that addresses the
> overflow concern.
>
>
> In your above operation, why not use SZ_128K to avoid the magic number?
> BTW, please update your comment.

Good point, thanks Bean! Will amend in v2.

Best regards,
Alexey
