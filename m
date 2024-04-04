Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0644130495
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 22:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712269755; cv=none; b=svBSWYLlcLfyzsPH4pSSGzdrU2+zgrCvHJR+ZDI7AfMtUrERogv1/kondJ+38EOYhtTZR4mgAddxx6WnmPUnDDMOnSpXpd+934ln2Bblna1XW8pHU+NvKMnAH4q48xVyEoP41cKoJkVuh6a1f0wOqnmt7/6T1PSiYkj7ptbICMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712269755; c=relaxed/simple;
	bh=+6ZCBuLlzapOPznLZx274mIaM61Kz1QYO8Sy6hDU4L0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sDTHZ0i/+au6uHUGqm0mOppJQdYBG/4lO7YrjHfvmg88CvbIkhxRwngQ3hlrrtOZ6aL58D1MMBKZi506/UMeRU1hs7ja6Mtmv8fiGpmOULLAlYVeaqWAbntaBMg5+IPx4yuH5D7akCp8O5dOWGzhyWcHkfcGRIq4hOxPhxTBG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=jx0//3oE; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=jx0//3oE; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="jx0//3oE";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="jx0//3oE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712269751;
	bh=+6ZCBuLlzapOPznLZx274mIaM61Kz1QYO8Sy6hDU4L0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=jx0//3oEWWP6Mj8UJyIazVSMA28I7b2qmKqlMwwMu3f/LBb2BwJ5bbPw6qeHjuKCz
	 Rf72ZnJS8L6OUC3c0Q45pnUX1Ul4TS/n/aqTA5i/2kz2MGGaHz455p0h+DgYVaHvW0
	 1Y6O85BVBbhk5WgVfeUz1zUI0FqiIep9dCyCCFqY=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id EB3331287C5D;
	Thu,  4 Apr 2024 18:29:11 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id 9-U4s9NcPqnI; Thu,  4 Apr 2024 18:29:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712269751;
	bh=+6ZCBuLlzapOPznLZx274mIaM61Kz1QYO8Sy6hDU4L0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=jx0//3oEWWP6Mj8UJyIazVSMA28I7b2qmKqlMwwMu3f/LBb2BwJ5bbPw6qeHjuKCz
	 Rf72ZnJS8L6OUC3c0Q45pnUX1Ul4TS/n/aqTA5i/2kz2MGGaHz455p0h+DgYVaHvW0
	 1Y6O85BVBbhk5WgVfeUz1zUI0FqiIep9dCyCCFqY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4C05B1287BB6;
	Thu,  4 Apr 2024 18:29:11 -0400 (EDT)
Message-ID: <f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Justin Stitt <justinstitt@google.com>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Date: Thu, 04 Apr 2024 18:29:09 -0400
In-Reply-To: <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
	 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
	 <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
	 <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2024-04-04 at 15:04 -0700, Justin Stitt wrote:
> Hi,
> 
> On Thu, Apr 4, 2024 at 2:53 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > On Thu, 2024-04-04 at 14:38 -0700, Justin Stitt wrote:
> > [...]
> > > I am not sure how my patch [1] is triggering this fortify panic.
> > > I
> > > didn't modify this printk or the string arguments (ioc->name),
> > > also
> > > the change from strncpy to strscpy did not introduce any
> > > strnlen()'s
> > > which seems to be the thing fortify is upset about:
> > > "2024-04-01T19:18:28.000000+00:00 zGMT kernel - - - detected
> > > buffer
> > > overflow in strnlen"
> > > or
> > > "2024-04-01T22:23:45.000000+00:00 zGMT kernel - - - strnlen:
> > > detected
> > > buffer overflow: 9 byte read of buffer size 8"
> > 
> > it's sitting in the definition of sized_strscpy in fortify-string.h
> 
> I see now, I was jumping to the definition in lib/...
> 
> > 
> > Since the fields in question aren't zero terminated there's a bad
> > assumption that you can do strnlen on the source field.
> 
> It's interesting that fortify doesn't like if the len argument is one
> byte larger than the source argument because while technically it
> does
> overread the buffer strscpy will manually write a NUL-byte to the
> destination buffer.
> 
> The easy fix I see that doesn't limit the amount of representable
> data
> is to increase these fields by 1 to match sas_expander_device.
> 
> diff --git a/drivers/message/fusion/mptsas.c
> b/drivers/message/fusion/mptsas.c
> index 300f8e955a53..44b492698e06 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -2833,10 +2833,10 @@ struct rep_manu_reply{
>   u8 sas_format:1;
>   u8 reserved1:7;
>   u8 reserved2[3];
> - u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
> - u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
> - u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
> - u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
> + u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
> + u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN+1];
> + u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN+1];
> + u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN+1];

This is a reply returned by the firmware ... we can't just arbitrarily
change field sizes because then it won't match what the firmware is
sending.

James

