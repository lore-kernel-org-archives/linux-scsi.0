Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADA6248F47
	for <linux-scsi@vger.kernel.org>; Sat, 22 Nov 2025 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763848229; cv=none; b=UgZPs6He5vjS4ryic54DamlOpMwe/7sF0cU5KZLuYGFDOGH8sXKaRzQlDA28jrmXYXWNiUmW3lJWjVEdjvX2pS6+ifYMZ9VkgMgxbjDRrjllMRtHsNImH4c8OIiyCuCchpxXMPMtgrVdz+DickIEknyBTyrmsGCB9oRkkjZ2LdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763848229; c=relaxed/simple;
	bh=rfoTv/vcDcHpqPYc567XyOgXz+CB29IrhpuLZMJ5lpU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=clAWjrTIAYlj+FIrSB8E5I6QO6Kf78lZLTojKLXcsBtwelgvBT69jiDLd5u843ugRbDng891dvh3hJYpwBKV2MmNXq7q41z1DV5iiyLCCjLeEVmUltn6KbW3e7eeMnFvX9fpJOO9m4sJCWXtxVVVSVk5mWLQuBkAd0MaFIwVO/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJL2Etn6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJL2Etn6"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47789cd2083so18315355e9.2
        for <linux-scsi@vger.kernel.org>; Sat, 22 Nov 2025 13:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763848226; x=1764453026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VzGD2PZne2Hvgq6k37X7YqrTYGMyVJ6AVnPA9INa9g=;
        b=YJL2Etn6nCMILbp44x63NiafwgjvPkLI7VcOm0y/9+MdgKKa3lmxoiDh8+Xq12UgAS
         4z7k2heDYb5sHdKov8Y6PW7anuI+76FfYcDHncTLtV4xyBaIKS6EWx7rAwBlbygbkEiX
         QOUQ0Jdmt93mb+J0UQbgDGArIgvHGmN/F45MSxTNPlynr2ntDRNz4rwirWNm2TKIqnJF
         pYoqF2MBm0PZnRpMAJiw1nQM7Nie7lg7FW5qV3ly2jQGdp2ENJF8FJJIlr71luNwa/6l
         eM4ibJ5sj/fTkt47yYBOTb60WW2r5wqg/NWgSpSqEN564U6njkB2bRK4WhbEv+hQfTE2
         +iqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763848226; x=1764453026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7VzGD2PZne2Hvgq6k37X7YqrTYGMyVJ6AVnPA9INa9g=;
        b=dqXdpNeLLm9vdM9k1RRwDFl4Jz16ChAG7T4wUfz+lOdX3eLQnw5yjIj9K962Z7suO6
         HpRRAZrsjeSoz3okrGdhOXzPqWDYRX7w8G84kLZ3zNieDQUt7F/cvzDd1kv8vnqi8S9J
         4KL2XMGFUUKcg0CPfX7Ax0oqAoP1/vKC3GahkQciawnB6QA+Gfz95WVd5MwxcO1/4vxW
         5HKauDF2slLA1MHkGqGqczmFmE49GTR5wARuwMnq5by2vDZHREVBVG/goWIDmRsLPUeC
         UyNk73xjARjDlQvTeuv3OZ/fTTpU6Yk4kHNOqTROXVtS8wQHX8GyXiRt/PZpaoR7G4oD
         Wh8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUGi4kjw+Pl9fBWSoa1RihPrMkYQfqqjioqQ4XDQOFySvgH97Qw2V0ob8JbPSOJLogRIoWpJonXXwRT@vger.kernel.org
X-Gm-Message-State: AOJu0YxNy7BBEbiEMqVvPVLYeECqkOoE4tXGfjnG6hmNcW6MHY9zous5
	Mot9hd0g1J9JUTtmP308snMIhPsnUvickzx9AL/B58MB1YXWNCeL+gQ1
X-Gm-Gg: ASbGncvdLcR8+ea1LfLtZNfa07BetAdQIrQlOj1HOWY56tSXT6SzKI37JtGe4R6f/ye
	hhD/TRzjXXoqZ3RKl+1m5afYoyOywZcXYeAcV3XbVRd6deeDfREx3L5z41k5e3uCDpmRZVStG/C
	CzYJoNjpco16FXTygYZ5u/aXRvgIsp8krB1rjzN4qWTNHHUvkyFP019or6+FTKvXodK6qwcBji6
	8GNZPj1D/8dlic2eY9U/wDaER7JTHuR7peVcWiMXc8dcOLSKcUy+4hnMUmQ4qrSXNixfvpk/yRB
	CiiwEji93gOy+7SOehZ5iWZgJfAooCjAkfKvzV09ZzshXGPWHQe2Ib0alMEI6tDJfpuM9uxpViO
	I04Mz9M3A3F4c78l9OQ0HePh5vBiQ68RofkMk2FC2WkkUklmzpegW7IOkbADwsm34juMSy7elVi
	hQWzYz7lhDAy1SzPgE2UtweL1oA2EPIl9TZV03b+zZT8qsK/Wkk5CFGDn9JGoZAHE=
X-Google-Smtp-Source: AGHT+IFa4wB3TXVM6n2AaqdODIKufZ2tRcZFuBHy0buOS58QPa65FnaGDLATe40D+AWpNpfwCfCNXA==
X-Received: by 2002:a05:600c:1c82:b0:477:9650:3175 with SMTP id 5b1f17b1804b1-477c1057310mr81311285e9.0.1763848225678;
        Sat, 22 Nov 2025 13:50:25 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1e868bsm108159615e9.4.2025.11.22.13.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 13:50:25 -0800 (PST)
Date: Sat, 22 Nov 2025 21:50:23 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH 26/44] drivers/scsi: use min() instead of min_t()
Message-ID: <20251122215023.2fe10a2b@pumpkin>
In-Reply-To: <2a8c62e1-6e29-4ac6-b661-7b5ec1763288@acm.org>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-27-david.laight.linux@gmail.com>
	<2a8c62e1-6e29-4ac6-b661-7b5ec1763288@acm.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Nov 2025 15:09:02 -0800
Bart Van Assche <bvanassche@acm.org> wrote:

> On 11/19/25 2:41 PM, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > and so cannot discard significant bits.
> > 
> > In this case the 'unsigned long' value is small enough that the result
> > is ok.
> > 
> > Detected by an extra check added to min_t().
> > 
> > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > ---
> >   drivers/scsi/hosts.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 17173239301e..b15896560cf6 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -247,7 +247,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >   	shost->dma_dev = dma_dev;
> >   
> >   	if (dma_dev->dma_mask) {
> > -		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
> > +		shost->max_sectors = min(shost->max_sectors,
> >   				dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT);
> >   	}  
> 
> So instead of the type cast performed by min_t() potentially discarding
> bits, the assignment potentially discards bits. I'm not sure this is an
> improvement.

In this case the assignment is fine - shost->max_sectors is on both sides,
so the value can only go down.

The issue is that dma_max_mapping_size() returns a 64bit value.
So if you have some magic high speed interface with a 2TB 'dma map'
then 'dma_max_mapping_size(dma_dev) >> SECTOR_SHIFT' is '1u << 32' so
is zero when cast to 'unsigned int'.
At that point things start going horribly wrong.

I don't think there are any such interfaces - so the bug this fixes
can't happen.

OTOH the same test does pick up a lot (and I mean a lot [1]) of driver code
that contains code like:
ssize_t do_xxx(...  size_t len)
{
	unsigned int copied = 0, frag_len;
	while (copied < len) {
		frag_len = min_t(unsigned int, len, MAX_FRAG);
		....
		copied += frag_len;
		len -= frag_len;
	}
	return copied;
}

If you manage to request a transfer for 4G (or more) then it doesn't work.
Now there might be a test earlier that stops that happening in a lot of places.
But from the perspective of the function it isn't true.
(I suspect readv() with a single iov[] can generate a big buffer.)
The compile-time test detects that (unsigned int)len may not equal len
and it can be fixed by changing to min(len, MAX_FRAG);
In this case it might be a real bug.

Note that a read can be truncated after a few bytes - it is only the
buffer size that needs to be massive.

	David

[1] I've just built allmodconfig - 'only' 488 more files needed changing.
A fair number of 'real bugs', a few false positives because PAGE_SIZE and
sizeof() are 64bit, and a lot of dubious code.
By far the worst are all the min_t([u8|u16], ...) in many cases the code
uses the type of the destination - so you get (eg):
	u8_var = min(u8, value_32 / 2, 255);

> 
> Thanks,
> 
> Bart.

