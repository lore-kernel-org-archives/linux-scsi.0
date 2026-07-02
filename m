Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E642B72A
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 08:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980507; cv=none; b=rsN1O2aGNJK93xwerZZTH8BPDf1Dtayu3tAz+DKQ4MDDhI41biY1O8V3C2gZDa6JhvYzwK+jfPoTqiCmISdi98oTPvEug6Fa83cUUgumGqbrE1Jw2yd2U5A0T9HuorguY8+TkYfPwubaEdq7vpiJS/8xvHOYMVJ2BrRmVL53rXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980507; c=relaxed/simple;
	bh=R4mp7V+YISkOypWb0SQxXjiw/iBRtLqjKB6U4228okw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4nFgghguLzsx2/P1C1bWXfTDeEJ0Agb85pTF5tHW7bXuF+lryoQCl7Kg9uTEYMbh3EUaG89jZ6mPupwB5ZRiQ+Kd0WrUgQ8iRmMCH5Fk9EtQWCd2C2CK2nSiCST4o+DNtqMWUayW9a8gqEJsx36rCyo8m2zMxs1kwYUK8eQQYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kuCy1KHz; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kuCy1KHz"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c9c9916f75so8787345ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2026 01:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1782980505; x=1783585305; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jxRVo9aIbyDvvuZPFaTnF8c++ORfuni0RdSeL1BmfKU=;
        b=kuCy1KHzHoeS2zEmb+4FSTe9q4dN8DxeqHzlrHeFiGfr6pOA4wadlZkzN2gCvijbvy
         N+Jh5AUOz8BZjwQfwJEvHJI2CSuXfdNzBMNB9JhnNqWRRHGujDHeMIMjwVpbW4xFQ55B
         9uAaQbKHY5tQo9lLaGdovLGaYaKNvzuamDnmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782980505; x=1783585305;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jxRVo9aIbyDvvuZPFaTnF8c++ORfuni0RdSeL1BmfKU=;
        b=XIU/P19Pkp1eVVMa8ngNN4Zodf6Na7EcwOkUu5hNBGcqMWLLjU2f8KhM/VMxwYCQWg
         CkutsclsppOAOHv5Ixgq6BSGDVGkiRXq7WBCFe663ENsCARRu8q8GzG3foGNu6ChhH7R
         fq86u5nu1op/bvne5JpHzEnO2HS+jMFNbN1mx7Eo7vTRJ3KQcsAJOyCm6Y6Yo0ezE766
         Z+XAVkZNdqNVIpQ9Iipa87Bq4Ajc2e03Qg9Z9AVjwp/kJNN17I6hhp1NNSABlnMNp7jj
         +fYJW8lY2XFzEE2DuU2bXKSCDbSNSjLbh6ID5Ahy3h/LB4OhX7QOGpFlIu15+udKLM7G
         xw+w==
X-Forwarded-Encrypted: i=1; AHgh+RoWllzXQvi/jJCgcPNuDvyBvd41UqjHg9nJhA6pCbZxlFtUgHZBzWNC99yn5um5quHRLl70KhdSpxeL@vger.kernel.org
X-Gm-Message-State: AOJu0YzZDxZuJ9gF2QPcpkmiBufQOwi21v03iJbpcNDNzRqMEgmSibyz
	d7DvthijBX6tejux32DOj2AGpr6IDYmpvUAhfxV+3BSjr49tEl3hymvjpYfMVddB2g==
X-Gm-Gg: AfdE7cnaZbtDpl7/FhhcKBml5ZaqsozFi5GDrJ2gLk8BNjdDaJ08PzYC9C6QS+fFbuV
	rln6YwN3+rA4gyK2MNr7Bkh/kfM6ws0lPoErJRjaV2PVlSRH+cnAfeHapFavFU7/KoNSApHGEzK
	5kIa0COI4NQsNzxPsFIpXd1Daj2fhGLXK4rUS080X2RvGZjOGpZinJYRCXEUs29RHMArlEfblLb
	hbC9bp5Ir6jRQ4VSzDYEZdCZZtL3Q5gcY46YzzM7hD3mPhsmXRq7O6FXaLtzlgELBtWEg/viL1t
	IYgPCZq+gvAlVDrmli/r8obF1a3aIZ+2pM8H2ZA938JROgodiML4y6L05uz/GpEDyvGYt6g4ND+
	7fJU3ZUiC3W2ekMeNlH6za0DOmksspoQ7DlR7Mj6sXjmbYFI2emTAgedngpVr7cYT9sY1P1cN5z
	ypHh6lgcRntrYwpiKkt7M9qJW98VYEgq5W5HJwesWy1qfhP2xanjfA
X-Received: by 2002:a17:902:d2c1:b0:2c9:aae1:a61a with SMTP id d9443c01a7336-2ca7e6bf4dcmr59316055ad.14.1782980505205;
        Thu, 02 Jul 2026 01:21:45 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:4e88:f8c5:c424:2d65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca9a7c397asm10090435ad.0.2026.07.02.01.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 01:21:44 -0700 (PDT)
Date: Thu, 2 Jul 2026 17:21:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Oliver Neukum <oneukum@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, 
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org, Tomasz Figa <tfiga@chromium.org>
Subject: Re: [usb-storage] [RFC PATCH] usb: storage: uas: limit consecutive
 device resets in error handling
Message-ID: <akYexlPJiSlhYICe@google.com>
References: <20260701040335.810297-1-senozhatsky@chromium.org>
 <e2599d9b-5dd9-47db-8339-f1aa825a11d6@suse.com>
 <akXJuqvHLUpcjXIv@google.com>
 <ea2e824c-dded-423e-a242-56b9860d3430@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea2e824c-dded-423e-a242-56b9860d3430@suse.com>

On (26/07/02 10:08), Oliver Neukum wrote:
> On 02.07.26 04:25, Sergey Senozhatsky wrote:
> 
> > <4>[ 750.651133] rq: tag=0 hctx=0 op=WRITE sector=13860872 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> > <4>[ 750.651205] rq: tag=1 hctx=0 op=WRITE sector=13865992 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> > <4>[ 750.651263] rq: tag=2 hctx=0 op=WRITE sector=13863944 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> > <4>[ 750.651320] rq: tag=3 hctx=0 op=WRITE sector=13862920 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> > <4>[ 750.651379] rq: tag=4 hctx=0 op=WRITE sector=13861896 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> > <4>[ 750.651437] rq: tag=5 hctx=0 op=WRITE sector=13864968 len=524288 age=76536 ms pid=11900 comm=image_burner state=D
> 
> [..]
> > <4>[ 812.091136] rq: tag=0 hctx=0 op=WRITE sector=13863944 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> > <4>[ 812.091194] rq: tag=1 hctx=0 op=WRITE sector=13862920 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> > <4>[ 812.091242] rq: tag=2 hctx=0 op=WRITE sector=13861896 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> > <4>[ 812.091289] rq: tag=3 hctx=0 op=WRITE sector=13860872 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> > <4>[ 812.091335] rq: tag=4 hctx=0 op=WRITE sector=13865992 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> > <4>[ 812.091381] rq: tag=5 hctx=0 op=WRITE sector=13864968 len=524288 age=137976 ms pid=11900 comm=image_burner state=D
> 
> This looks to me like the block layer keeps writing to the same sectors.
> In other words the issue I see is with the block layer.

Oh, this is just our simple blk-mq watchdog.  Those are the same 5
stalled requests (WRITES), it's just they got reported twice - same
tags, same sectors, etc. they just got older (age 78k ms -> 137k ms
since submission).

> Do you know what triggers the error handler at the very first timeﬂ

Unfortunately, no.
