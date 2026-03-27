Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436063A6B72
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 07:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774594966; cv=none; b=KwcRAjb+aRc13xwPMBy5fIbOVEYfV4jR0XClY/tF/NcoZ6aOqJRb9U8kJiPakysJQx8Pn08ztVX4/W7PlmFqU5JTpQK6J25SFMzCkQRkpR2pLASasuhQ6N6C4YuYiOJ2ilmaBYpiyGrWSANP68pVA06a8p5OScrAb1Ofqb/0XtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774594966; c=relaxed/simple;
	bh=K0NU65iUAYQvOh1WDSTx62fRLZ4lQSk71rPspBEOQzw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WfdBwhsTHF+V2mOX+nU0vtJDswr12FAX1uEQW0s4dxlRXpQDU3kRnuUh5r1Xn0Gezbrx8FPV3OXIPmfFrby3lG0Skd+FUgaDhlpTAJGB0XHKg6W+VqJmSz3Lr7zDxoML4mr1ZhNU8SgPD0nIjGHOXlsPGkgQ5jAQk8rz82Z0iOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dfwhxI5E; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dfwhxI5E"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43b3d9d0695so1196637f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 00:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774594956; x=1775199756; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8kTV44QRDxew7Gw49InxhqyWyVfg6ic1CZM1bb6ukM8=;
        b=dfwhxI5Er778Wb2iRasfGmgjVg2q37zJsXR8gylTh6GJVyhUCFIWphiLelWNUGfeYI
         2G+lJnhPQx+HUiHXmaD65ZuNn2f3ziByBxnP9i05QmIfJi2TEArmJLjKqVKBbjopSN11
         q1sICgKwEdg55m9922GkRrrq4TpGFTSwcmZyOOwgYQkbdDk5SmGeNLHzDr6BMg1r7FxA
         sImHC3zSCjhz/ashywjQAYEYjDemnphssyXWBFgdqSUUBiOTJw8XQGpcj18xUJkQXppe
         400mZlDavy93m11XzPAXJl87ksjClsAyJGJhewD5XUBFXev/9weh4ETGkNR2YhRgq8Al
         NimA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774594956; x=1775199756;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8kTV44QRDxew7Gw49InxhqyWyVfg6ic1CZM1bb6ukM8=;
        b=OJV+5ORMn1YFZZBvb03u3+xVbplEZ//PogTJqqUx9FTmO16+P5hi53ARQXNpT5zcoK
         +jmxLuY581Q65G8WwqHFliJc+ILeO9dwv/r1iONcmNjCSRL+HTsirimQMT/xJYuJi1ge
         i9dqkUIsiPKKNlZAwRw/7dNlVmNLZXwZxGAMUq7SDCXjL8u5Z9OE9K19Nr8iO3gzY93z
         rO2RBfrSTqSppaOzUzB3uJoIr9OBCs1m1YC5Qn/Xg931u66NgFoDbKriz5rKJZrjW0YX
         9A32SOGcjxIuZ/e2vmuBoDsrfNWBNnYCX7KnJRC9loVEoFTczQ4LZ4bgsNvV+PibCpIu
         zl5A==
X-Forwarded-Encrypted: i=1; AJvYcCVBrcsQ+QX3opOylQrPiakxzqwM2mJM8ZyNnaR/xGoqwmwZZvQlWls8boKSUqL3ayawfY+rFQhmMu0Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8p0GnB+CGdvlj+n9rNGC9347OjENzRcWmdfhReWClrGu9eaeQ
	2Ve/r3lIYrkTWCsGOxz9GLJOzNonVcK84+vXCfoEUKOGYEu3rzVLxYlRvBcah1WNbUk=
X-Gm-Gg: ATEYQzyujJjy8kOsB0Yp/s+V8Gbb5NQz11wspQt3DnUO9N6TtSsgRlbw5fTpJIfE7aQ
	FYHpz9WQJBosJFErizrpcQbTsn3Pwm+m8WVHPnP3SzFEJgHAQJ2YzDv3argr1jH2JUs3hCTNBsS
	vdXluQPqCLsPPTY1QjRpFjUTpmwMiTX0JB6iaYTdKtUc3oH4Y6vcyReEB+XmgaVSjzP7Ksz7hsi
	z4QfGeS6tFSIpls6TeFaIigWT4cEtX3Urx6tA5dW2k+dqkslNjLwtfiZ1/olI/HCJx/FdcKH9wB
	adrjwCuE8ccOrvB3NUCkcbaAOo1ra+dWfcevQWIIgU1zbFCGjMoK5LsZHg+bGypF2lSxT88tMPg
	q2PwMBH+i4CmGNVUn5sks6TkbsU9YMhxfcabPg5qk/LcfQPylKz6Prt0kiHNh7Pm6bv2q1Qnk3+
	GNfkN43mliqNmTjHlBsBDUPajTRJqQe7LUvFjCT7rZSqcF+zcv8EMp71Q+rwGu
X-Received: by 2002:a05:6000:4703:b0:43b:9fee:9392 with SMTP id ffacd0b85a97d-43b9fee94b4mr1195313f8f.4.1774594955964;
        Fri, 27 Mar 2026 00:02:35 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a4e:1a01:f18a:19a0:4691:a8ea? ([2001:a61:2a4e:1a01:f18a:19a0:4691:a8ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919df953sm13543801f8f.29.2026.03.27.00.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 00:02:35 -0700 (PDT)
Message-ID: <04effda6-fdb9-4fb3-b73f-d951538f2fed@suse.com>
Date: Fri, 27 Mar 2026 08:02:34 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/13] scsi: Core ALUA driver
To: John Garry <john.g.garry@oracle.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
 jmeneghi@redhat.com, linux-scsi@vger.kernel.org,
 michael.christie@oracle.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260317120703.3702387-1-john.g.garry@oracle.com>
 <acAo0hr4BxXueQFM@redhat.com>
 <f72bc385-fdc1-4f4b-8567-bee083818400@oracle.com>
 <acFpYuaL-_9g90RI@redhat.com>
 <10aab639-2fe8-47b7-b821-12d21b6af874@oracle.com>
 <acGYbD6X55eA-ynl@redhat.com>
 <43ca92bc-af38-4833-841c-421997ed90fe@oracle.com>
 <acKYbwGlfgWKDxnF@redhat.com>
 <2f84e35f-3574-45e8-9567-4edcfdbe5a45@oracle.com>
 <ff1d65e0-bb5a-4dc1-8bbc-dc781acb341d@suse.com>
 <7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <7755e98f-5619-48ba-bcfc-b64eec930c40@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/26/26 13:16, John Garry wrote:
> On 26/03/2026 10:19, Hannes Reinecke wrote:
>>> @@ -80,6 +80,7 @@ config SCSI_MULTIPATH
>>>          bool "SCSI multipath support"
>>>          depends on SCSI_MOD
>>>          select LIBMULTIPATH
>>> +       select SCSI_DH_ALUA
>>>          help
>>>            This option enables support for native SCSI multipath 
>>> support for
>>>            SCSI host.
>>>
>>> And that is even enough, as Kconfigs should only specify build 
>>> requirements.
>>>
>>> We really should be also calling something like scsi_dh_attach() for 
>>> scsi multipath to ensure that DH is attached (and running to update 
>>> sdev->access_state).
>>>
>>> And I am not sure how the dh alua module is even autoloaded. I think 
>>> that on my ubuntu machine the multipath-tools.service does it - 
>>> something like this would not be nice for native SCSI multipath support.
>>>
>> Gnaa. But then we don't need this patchset at all.
>> Main point was that we _do not_ need to hook into scsi dh for implicit
>> ALUA.
> 
> But again I don't think that this is good enough. Native SCSI 
> multipathing will read sdev->access_state to know ALUA state. We can't 
> just rely on dh alua module running and doing what we need to know that 
> this value is valid. AFAICS, dm mpath relies on dh alua module to even 
> work at all:
> 
> device-mapper: table: 252:1: multipath: error attaching hardware
> handler (-EINVAL)
> 
> At this point I am more inclined to just have a small SCSI core ALUA 
> support for implicit ALUA, and allow scsi_dh_alua.c reuse functions from 
> that but not use sdev->alua structure, like in this series - trying that 
> is turning into a mess, I am finding.
> 
... where one finds himself inclined to think: 'told you so' :-)

And really, the SCSI alua handling doesn't need to be precise, in the
sense that the state is always up-to-date. It should be sufficient to
read the state once during startup, and then resend RTPG whenever we
get a sense code indicating that the ALUA state doesn't match.
We will be missing any changes between non-optimized and optimized,
but they are meaningless for the SCSI core anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
