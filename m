Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01F030B51F
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 01:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778721092; cv=none; b=Aw6HCh4NPZBlzXFunaQd0o3PQNtLM6ZCJLRkks1ayEYUiWwPFLad6RXLt+88UG5MO9PL+A1qAJ76hXk/caUrcKSMN9R+AUf5hRyAQEjuznZZprxiXre1M3Is0rxJmtkUmx3ereS4yuZ8XkiL3kMS/jCJzO4JSOuaM6gNGXdqxIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778721092; c=relaxed/simple;
	bh=ztkBsso23UpsXKr+O3LFaui6uvG8T0h+LZPrqrbSnbA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EzGjPWhAdVK5jW+KsWyX5Uaa8+hhH5mq8IBM7SjrSlhNM/AxEA0W7D8LmAXKLfZyngYZqTTFQeTLC/HVBcbpGTzSpLgOFv6lxYntcgPriGH3EHVG9VTTxwpbMdrWnQUJOlvRHWLyxDru5+DfExTOPmjfj7KOVNtbw3pZJw9sy48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gnjmvanl; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gnjmvanl"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38e7d983f91so71799261fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 18:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778721089; x=1779325889; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gPLC8u0hvKKYM/8QgR5AdV8zrX0b253adiqGeSRKT8I=;
        b=Gnjmvanl+YFBDEZ2g4JNRLlCz3BMG+T8JlQ7GmIJctJCtbuQ45NI0Xfp7m2iOO4Cxv
         6kdJ2/6xFJR6//jlgwnESZyknd1mcU3OTUTh3Lnl9F3ajuHcpI5U7LMgTS9Hh++pQj9Z
         OW5zD1RE+xzKCbtlxAZBowidVmH5RZDJHZZL9SLQGpuhK9lKpHNt3U+n5knUOztlnopY
         FqI1XYqLteGyN1ImwhFe8ddsVfml0TVY9A51UsbjTkdv8bqldYWzLouf/LI840H16hAJ
         aTot2ioSJTXTdZ7xWYHouBVS6EzyUShg5lal2HMxVLP0iT9UGlI6NVFbydB4V9zSbySd
         D3Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778721089; x=1779325889;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPLC8u0hvKKYM/8QgR5AdV8zrX0b253adiqGeSRKT8I=;
        b=Aw98Yz5csVMN2yVNRY5uB/PJ4TU14UfqRPWEvT8eMiXxKT/9SpuG/azxf7A4VGME+m
         1utTRxr1S71YTnZflMSNSh5RDzcCBQd7mXitxsJQ7thbk4Spmgb7gB5WpRoSSdhoX15O
         H+h7JzUhQyRVKAXQ07lr2kHyLP0/rg45C6PoKJeMR7lm8dEP+d4xywhCklDRPXOWInAA
         IcvlaM0w/fTHjtVMWtTLo1u3NfT20iHh47abCS+mhPSFDtZuCQnn4vxfWxYUsWsTM70u
         ZP4RV7a2LA7kCxhEoyLpGZk3Wh0bpLl2MaSDTH4RcHzrPtkUSVXWQx1yK80s763k702h
         Zn+g==
X-Forwarded-Encrypted: i=1; AFNElJ8sS+rbSM0yFDYbVDkfa9d//fgvJUhM+RG5XPmCIrj3v04R5e1+5WoxTU7D7eH5AGtQ7UESgOwpQd2L@vger.kernel.org
X-Gm-Message-State: AOJu0YxuWRz8yNp7deHuy1WfnP9+zHW91wmUpCAqX6C4IQCEvdUXYkyN
	/7YWd6noRWkfWJquJPMljQlgF/kXEcLi+KVJmItJGR4cH0CT/K5c7Ra5
X-Gm-Gg: Acq92OER33JRyYtI9Z5blKT5T3D9MP2XMBQlzAeD1XPo4Kpj1w1Sm0dZrTkkP1FAEKa
	DFUezSuy6u4+rMxJHj0w3j8YrSeBJxOkuSk6YXQKPKG3KbWR13BRvDSoU4cT7TTIQdDZFIXwEbC
	FVv899fNizsuXZZSqrs8G6oThZQ976vMw+DIs1TJPxSsHPjRcV9uCABErUHmY1l029uTxsE29PG
	PtkXgGLtgRIkpbfWtW+UGYIvIYk2Xqk9bTHnpIdzsV/kOnsvpxYhPXYWj4DMWJ7GLhL54TNAgyr
	ay2DKH608626pmibmEuKWsX+TNZwSKcBBZ3Z9+U2Z8iGxI3Po7XrpcqW92veip+I2x68UH277OE
	hqcAlHGoA/t6XVMJ6ei0OFHl6FEExEL3KQCT6115wAi8r+rqauh3FbGKfPoBpnfNfzzWG1BEMIW
	ZaIV3KcGzQOZhuOecqueC21YeSDctyXqQ/YJ8MgQ==
X-Received: by 2002:a05:651c:198e:b0:38d:fca1:4a6c with SMTP id 38308e7fff4ca-3944e9ceea9mr18879511fa.17.1778721088536;
        Wed, 13 May 2026 18:11:28 -0700 (PDT)
Received: from localhost ([2001:863:36e:5104:a331:7451:88e0:34ca])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3945cab2976sm2330881fa.20.2026.05.13.18.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 18:11:28 -0700 (PDT)
Message-ID: <4e757864-c062-4467-83b4-1e0d08b68b2d@gmail.com>
Date: Thu, 14 May 2026 03:11:24 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: mpt3sas: add hwmon support
To: Guenter Roeck <linux@roeck-us.net>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260512214703.655633-1-sautier.louis@gmail.com>
 <20260512214703.655633-3-sautier.louis@gmail.com>
 <934b475d-1d77-4670-af10-4f3f2ddad61d@roeck-us.net>
Content-Language: en-US-large
From: Louis Sautier <sautier.louis@gmail.com>
In-Reply-To: <934b475d-1d77-4670-af10-4f3f2ddad61d@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 13/05/2026 05:57, Guenter Roeck wrote:
>>   Documentation/hwmon/index.rst        |   1 +
>>   Documentation/hwmon/mpt3sas.rst      |  57 ++++++++
> 
> This is not appropriate. The description is wrong and misleading.
> mpt3sas is _not_ a hwmon driver. It is a chip access driver which
> happens to support hardware monitoring.
> 
> If this is part of the mpt3sas code and not a separate driver,
> please keep it there.
> 
> Thanks,
> Guenter

Hi,

Sorry about that, I had assumed this directory was also meant to contain
documentation for chip drivers that support hardware monitoring.

I will remove the documentation from v2 since there is currently no existing
mpt3sas page under Documentation/scsi/.

