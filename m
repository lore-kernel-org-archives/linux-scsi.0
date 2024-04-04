Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3FB51033
	for <linux-scsi@vger.kernel.org>; Thu,  4 Apr 2024 22:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712270022; cv=none; b=c7hZQJ4E2zj7Z440IJ4/T7xMWCCMGPIMN1ymUuKC4t10t2pxnBRpWcemfivf2wuqL/LqqxwDWt+EMy5m51ivltSZ6Hn/B27dNsavBXXG0THvg5p/n86NJ4mwXSbDBLkb6iChGn6Evtm0OJAUeJJznd74uEq1Y/EXhxHU1/HeZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712270022; c=relaxed/simple;
	bh=RUlXg1XwiIDPp+M8fRU7/M/n/ne/ZMbkyMBnLriDopI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lgK4/C6Z+pogIGXY2qcGrV9LGKqUQrwIT+z+4WvN3lRioDQdr1CJoGEKPy0hKmH9T+uZG8ZOza1yA4bGEpQVqbKIp84pdOl0MdaLVIqOlHqCeJOkIdq0Y+t4iwUuh7sg5wm8k5ZKSWBDGvsm38eoxvZvYL/Rtxlb/fMLq2X3y1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=KjUWQiYz; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=KjUWQiYz; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="KjUWQiYz";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="KjUWQiYz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712270019;
	bh=RUlXg1XwiIDPp+M8fRU7/M/n/ne/ZMbkyMBnLriDopI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=KjUWQiYzvbbTuyzpxtjhrEPzh+LIHcI4qEMnECnhrKF+any7lKbTFhgrF0YiCEGYj
	 SFrrd4ypgdvw+T325yTX6ztgA8Ob04pJCfhm33SBSe5EBHRIeds3NBPPXikvgdjZdJ
	 0MmTRE4W0MKYqALQoXfxgILtxxsannEjPzcPoun0=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id E23331287E4A;
	Thu,  4 Apr 2024 18:33:39 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id XJgT8YcTK5MD; Thu,  4 Apr 2024 18:33:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712270019;
	bh=RUlXg1XwiIDPp+M8fRU7/M/n/ne/ZMbkyMBnLriDopI=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=KjUWQiYzvbbTuyzpxtjhrEPzh+LIHcI4qEMnECnhrKF+any7lKbTFhgrF0YiCEGYj
	 SFrrd4ypgdvw+T325yTX6ztgA8Ob04pJCfhm33SBSe5EBHRIeds3NBPPXikvgdjZdJ
	 0MmTRE4W0MKYqALQoXfxgILtxxsannEjPzcPoun0=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2ABD01287CC0;
	Thu,  4 Apr 2024 18:33:39 -0400 (EDT)
Message-ID: <784db8a20a3ddeb6c0498f2b31719e5198da6581.camel@HansenPartnership.com>
Subject: Re: startup BUG at lib/string_helpers.c from scsi fusion mptsas
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Justin Stitt <justinstitt@google.com>
Cc: Charles Bertsch <cbertsch@cox.net>, linux-scsi@vger.kernel.org, 
	MPT-FusionLinux.pdl@broadcom.com
Date: Thu, 04 Apr 2024 18:33:38 -0400
In-Reply-To: <f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com>
References: <5445ba0f-3e27-4d43-a9ba-0cc22ada2fce@cox.net>
	 <CAFhGd8pTAKGcu2uLzUDDxto1sk5-9zQevsrXp-xL0cdPcGYaGg@mail.gmail.com>
	 <5ac64c472d739a15d513ad21ca1ae7f8543ad91c.camel@HansenPartnership.com>
	 <CAFhGd8pg78F1vkd6su6FeF3s0wgF8BdJH+cOUsUdqLmuK6O+Pg@mail.gmail.com>
	 <f8b8380bf69a93c94974daaa4e2d119d8fcc6d0f.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2024-04-04 at 18:29 -0400, James Bottomley wrote:
> On Thu, 2024-04-04 at 15:04 -0700, Justin Stitt wrote:
[...]
> > It's interesting that fortify doesn't like if the len argument is
> > one byte larger than the source argument because while technically
> > it does overread the buffer strscpy will manually write a NUL-byte
> > to the destination buffer.
> > 
> > The easy fix I see that doesn't limit the amount of representable
> > data is to increase these fields by 1 to match sas_expander_device.
> > 
> > diff --git a/drivers/message/fusion/mptsas.c
> > b/drivers/message/fusion/mptsas.c
> > index 300f8e955a53..44b492698e06 100644
> > --- a/drivers/message/fusion/mptsas.c
> > +++ b/drivers/message/fusion/mptsas.c
> > @@ -2833,10 +2833,10 @@ struct rep_manu_reply{
> >   u8 sas_format:1;
> >   u8 reserved1:7;
> >   u8 reserved2[3];
> > - u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN];
> > - u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN];
> > - u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN];
> > - u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN];
> > + u8 vendor_id[SAS_EXPANDER_VENDOR_ID_LEN+1];
> > + u8 product_id[SAS_EXPANDER_PRODUCT_ID_LEN+1];
> > + u8 product_rev[SAS_EXPANDER_PRODUCT_REV_LEN+1];
> > + u8 component_vendor_id[SAS_EXPANDER_COMPONENT_VENDOR_ID_LEN+1];
> 
> This is a reply returned by the firmware ... we can't just
> arbitrarily change field sizes because then it won't match what the
> firmware is sending.

But additionally this is a common pattern in SCSI: using strncpy to
zero terminate fields that may be unterminated in the exchange protocol
so we can send them to sysfs or otherwise treat them as strings.  That
means we might have this problem in other drivers you've converted ...

James


