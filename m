Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D7B82D90
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 22:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712268309; cv=none; b=iCcUHfDK9htJM7lq8hgtmPkftYa9s1vWWkMc54n7QDyTYSi11idokXDVNNhnYp/72gumPxEt2gNAonfEPCbMy+bWb56a+q+qEqnSozs7GtEiGcnWl5FXpHIXOBHIlfM9ojG6iwTcGENpnZLrVf3Plp5bGrr0y5IcuqxBFuTRiww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712268309; c=relaxed/simple;
	bh=IIBj5X6bBc4/LxhRW0FfOL/v928F6SAkg5oC1taCMaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uaxqxLjICaNiyr9/2LWNgu5SNBtXXDPspoJOFa6UYBQCYARjVHnApXwhHCz/rvdXeoVHgf3+SSE2/zoCvySXWFjlJtmDDYYQnZykRjl3mlq9dOjSOb0CaHWji99/Ej4R1lV4Cnly4LbRBB0cWIz8BL80WQgj2yBHUVZHep71VhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iJJZK05m; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJJZK05m"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-516d3776334so166706e87.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Apr 2024 15:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712268306; x=1712873106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3eSTvSnOgK4YzeoezmaWErdzU5LmO3dZmkhC0DPiBFA=;
        b=iJJZK05mdjwgbWIJHqkqmqkBMyGKwOuY4psVPZDvm4EfaDmauytE8LCz5SykuiTs5P
         K3DnedFRxhCDBVZw4YchlDyZQekb+A4dcjciJYHJFbMfonb5RLsQ4T0xEoTFVd+hCWHE
         Wa71uAfmDzaxF+gW6g7V/PO/iBnFHT+zOLvzuM1he9Tmx8CEsxBP/Qs+EW3BpGgOjenF
         DP2ACnaQK4cka2DhIWTgtp9Ov6T2iCicSlGhv5x/vcgjkPuO0VGhBG3XLHyud1gIC5xo
         +Ln8BGyee9M0s5Q/mXjiNBltA36LhW48+sNzXVB5Dw1+hhlS/Jhryzz97PEg6gGY24o+
         Kqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712268306; x=1712873106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3eSTvSnOgK4YzeoezmaWErdzU5LmO3dZmkhC0DPiBFA=;
        b=n1Fm0kLxjvcTn4LNmwVSUpKJXWJiFUMuJyxbdiFma0YsHC818LXOTny1Kzl+GqyXnN
         fllQAKraFcx27TuPcfQ5pz5AJN0g4+fTEySkvpd86kPVlsRlyc+i1oUFfYVOmjpC6Xed
         hX/xl7UNdCYXwFsYmosY4wvqMqMXVb92dnJisc1prRhixwmmvitg1TqmyrCYGBPx7zaj
         rWdzIhKLtvzO1HsuHS3zm7Kp/v9/jKpxq/9H8T1JwkU+ulfPUymzznkXo9kU3hxazu6L
         qmtqlcx/ge5tSpXRLH0hWPKngsxv4nU2bbUsi9MvlBrhpIWfLNXdHRcZqAv0jSg/0Fsl
         lnSg==
X-Forwarded-Encrypted: i=1; AJvYcCUOUJ09/V05SxHv9F9Kgg5WCYjjkiA00JTVjbu0lz1xvdotEiJRfkgJmX8KZWd1ZqazFZoLG/NNJj9koYTe6rXuYPkBa5JKXfHxuA==
X-Gm-Message-State: AOJu0YxNBvxVjGjKTa7pL9suKCUrbwrlHKw150rpGFqd9pvDGK54Znsq
	dAkVDcALBZXPU5mJMTZ3zw/tQIzS7pXBm34mi3vik4ftmXGsyobwCXK1HDtcG+2rpx29nn4tgQV
	R1IP61gmXY0i5F3l/G+dMqFmciifu4wrL22XY
X-Google-Smtp-Source: AGHT+IFYmHfn5azczNaLQpbnyydrfyyAc2zVAYrUxGEn4/Nmsz7+P0W4Ib1sEnGGm/Nrgvq1LqyErja9HNSOf5bXklk=
X-Received: by 2002:a05:6512:304c:b0:513:cbde:8764 with SMTP id
 b12-20020a056512304c00b00513cbde8764mr3108046lfb.57.1712268305952; Thu, 04
 Apr 2024 15:05:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net> <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
 <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
In-Reply-To: <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 4 Apr 2024 15:04:54 -0700
Message-ID: <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 4, 2024 at 2:53=E2=80=AFPM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Thu, 2024-04-04 at 14:38 -0700, Justin Stitt wrote:
> [...]
> > I am not sure how my patch [1] is triggering this fortify panic. I
> > didn't modify this printk or the string arguments (ioc->name), also
> > the change from strncpy to strscpy did not introduce any strnlen()'s
> > which seems to be the thing fortify is upset about:
> > "2024-04-01T19:18:28.000000+00:00 zGMT kernel - - - detected buffer
> > overflow in strnlen"
> > or
> > "2024-04-01T22:23:45.000000+00:00 zGMT kernel - - - strnlen: detected
> > buffer overflow: 9 byte read of buffer size 8"
>
> it's sitting in the definition of sized_strscpy in fortify-string.h

I see now, I was jumping to the definition in lib/...

>
> Since the fields in question aren't zero terminated there's a bad
> assumption that you can do strnlen on the source field.

It's interesting that fortify doesn't like if the len argument is one
byte larger than the source argument because while technically it does
overread the buffer strscpy will manually write a NUL-byte to the
destination buffer.

The easy fix I see that doesn't limit the amount of representable data
is to increase these fields by 1 to match sas_expander_device.

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsa=
s.c
index 300f8e955a53..44b492698e06 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2833,10 +2833,10 @@ struct rep_manu_reply{
  u8 sas_format:1;
  u8 reserved1:7;
  u8 reserved2[3];
- u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
- u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
- u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
- u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
+ u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
+ u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN+1];
+ u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN+1];
+ u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN+1];
  u16 component_id;
  u8 component_revision_id;
  u8 reserved3;


which matches:

struct sas_expander_device {
...
#define SAS_EXPANDER_VENDOR_ID_LEN 8
char   vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
#define SAS_EXPANDER_PRODUCT_ID_LEN 16
char   product_id[SAS_EXPANDER_PRODUCT_ID_LEN+1];
#define SAS_EXPANDER_PRODUCT_REV_LEN 4
char   product_rev[SAS_EXPANDER_PRODUCT_REV_LEN+1];
#define SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN 8
char   component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN+1];
...

If this is A-OK, I'll send a patch.

>
> James
>

Thanks
Justin
