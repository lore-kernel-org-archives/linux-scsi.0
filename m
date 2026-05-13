Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF111427A
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 11:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778673249; cv=none; b=ttUZEEICgHtAe6SOvn048KuChNyccnMnMwqJjfc0Phq8v92h5+9LWzg4sLcr11qSuQ9iGpU7xIOwUBV+o24+/j5IQgKlMaqIsJA/bkOR9z4gCVCIgM0qSA6l4z8Zul4UJteEwlAn4BpM0ndW8VzKR8H/nOglmSLxGFzvTQwCuBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778673249; c=relaxed/simple;
	bh=jCicSXK8o3n9Uf7NDC3doDakPMtCSycPtUdtDwQnAMU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:Cc:
	 In-Reply-To:Content-Type; b=eZu29e+S1aaRwKwuoIGBLvMgcIE4hVGmAXgunHr9MJPXSy2ubG3tZDRhiwvdkCq+qkpzcJON0VzExq1nBm+y3gWVEq6kU6SpOj0V7DXhHGQEnbbVmqvugHJWQlV+fhPRIbnQeCoDtSJElRilDNR0WManitq0SNHXsyFzxbT06VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HMzjr0xX; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMzjr0xX"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4891b02a0acso6860715e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 04:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778673246; x=1779278046; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:from:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qCg8QRYrFFr3G1fc8RWe1MHKwoBOY1ARrs+jH0V29w=;
        b=HMzjr0xX2uRjqlJvmb+5aS49k2tdjA4KwGNZ//NKE/HvDq1W8xgq21V+iq+h4u4i6B
         cPC7FfV1Oog6iOSMWigJLWKSSDQFiH1SF22l7q+M+ecRBAJfi1bcFv/AFWlorPmtAWTK
         0/638g7HckgvV2rLdYAhx6G45XZSFyYRULL1U38xGvI9KNlz040B94SRY6hhhnGCp1cT
         SWKPvhKTtdsPRDaS2YNlxHo8JfAYavSS0+VtYUPKYEU2OM51lisee1ypRtMVJapWgTwG
         OgbQvBeQWLXy3N+PlCTaUvWECFBT2uvKv1ABsZWnuqvk8HWtUlZBJ7CL6bv0e8a0/tSU
         XEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778673246; x=1779278046;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:from:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qCg8QRYrFFr3G1fc8RWe1MHKwoBOY1ARrs+jH0V29w=;
        b=Nk+71cV8RWsm6PaqMHLKKNvd1WQcZEboe6eH4/bRIaSoLH2TCMb+AqnQP6fb8DNuYF
         67/WU/PkF4w/PlthgDc34ShtNpkQ0ExV03tYeRVVS1oRwv0tcw7IgxQYqbX6ld8mPx1+
         bRJDOEQ0YZWEw4VzgfQ1ZNYS0FP0V0qgm0WSsbPPSI+nVys5ILn2NVXEavjnWZhP/FG2
         CBRqAvi6KWRaozUDhzRLt5dxRouiEZIR3WlO8mSxC7dmX9bMA5KGab6TjPIdLVOrlgr0
         qtmpgJ2mQS7cr4MVIS9fH+NG/3KUeCgwfZQSwcfNlDvNSu05IaPLXDIf9GxoudVW3wNT
         4nHQ==
X-Gm-Message-State: AOJu0YzbWOYBkzmTVA6ZJ5cH2SBPFVirhUdnya/1C9Tlw1m2RwlGvfA/
	W8Rri+Xe1U0SwuTzy/2FEgc6fosyxnF0cxBULsKlpXEkPnM1sSWbyZg=
X-Gm-Gg: Acq92OEhl9rz7O3hv7PYbpo/0bbtY0sMk0pxPikkWNUt7SMJmquYMw8S4xc3MwZKg3T
	P34yXU2lQHfx471Q4JobLm4vhl982e2u/hSbbZENXuZZ0JLngLSaOyVc7bmhF/PRjKpDXfPVj8b
	mphCajCFZfyR+TCWklTM717sMQexAP0lCN82A9d2RSahseUdxE80oIKEPD16lBL/N59ixGLgh+c
	hSw2rLCy7jQ4SGVKbr2bbtRlCItKqxy68qBMnGO++DioXl+HQLbpKN13/tApc7DDTn0IUn0NS/2
	cuFV531p2FZP89K3vlu6qPv6q8us5WbRug9+prDBXnch6sh0f064rLpCKYdBjF8UOPRYzgrorne
	fIKMq4LOVjo5NU8Chx6uyB5Hh8zckgDv+2OD2rbBgYsifgatppxgXZK3RaJW5J1UNGC77/tXiKK
	bVXmCx4WdZWedPbp/qpGzdIjkMYogv73qqIElrocjkQ0GLBOIXn7gDVZbM6/uuirujPzw=
X-Received: by 2002:a05:600c:4341:b0:48f:d410:6076 with SMTP id 5b1f17b1804b1-48fd4106127mr2678675e9.7.1778673245839;
        Wed, 13 May 2026 04:54:05 -0700 (PDT)
Received: from localhost (142.red-80-39-130.dynamicip.rima-tde.net. [80.39.130.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f42a845sm39498845e9.20.2026.05.13.04.54.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 04:54:05 -0700 (PDT)
Message-ID: <6d0bcec8-1d73-43c5-a7dc-88ac474c88e4@gmail.com>
Date: Wed, 13 May 2026 13:54:04 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] scsi: devinfo: Add BLIST_NO_RSOC for Promise VTrak E310f
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Alexander Perlis <aperlis@math.lsu.edu>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nikkos Svoboda <nsvoboda@math.lsu.edu>
References: <20260512231254.27530-1-aperlis@math.lsu.edu>
 <f5f2c2d0-382e-4032-a5a4-c82aac3a4b80@gmail.com>
Content-Language: en-US, en-GB, es-ES
Cc: SCSI ML <linux-scsi@vger.kernel.org>
In-Reply-To: <f5f2c2d0-382e-4032-a5a4-c82aac3a4b80@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/13/26 1:08 PM, Xose Vazquez Perez wrote:
> On 5/13/26 1:12 AM, Alexander Perlis wrote:
> 
>> The extremely slow boots reported July 2014 in
>>    [Bug 79901](https://bugzilla.kernel.org/show_bug.cgi?id=79901)
>> for Promise VTrak E610f 3U 16-bay FC RAID enclosure occur also with
>> the Promise VTrak E310f 2U 12-bay FC RAID enclosure. The 2014
>>    [patch](https://bugzilla.kernel.org/attachment.cgi?id=144101&action=diff)
>> added support for the BLIST_NO_RSOC flag and specified that flag for the
>> Promise VTrak E610f. This current patch simply adds the E310f to that same
>> list. (My workaround has been to include
>>    scsi_mod.dev_flags=Promise:\"VTrak E310f\":0x20000040
>> among my kernel boot parameters.)
>>
>> One curiosity is the additional BLIST_SPARSELUN flag. This was also in
>> the 2014 patch for the E610f, and was already in place for *all* Promise
>> devices since 2007 due to commit
>>    e0b2e597d5dd ("[SCSI] stex: fix id mapping issue")
>> which added the line
>>    {"Promise", "", NULL, BLIST_SPARSELUN}
>> The 2007 commit message talks of issues with SuperTrak EX (stex) but
>> the added line did not limit itself to that particular device family.
>> The current patch for E310F, like the 2014 patch for E610f, adds
>> BLIST_NO_RSOC while preserving BLIST_SPARSELUN from 2007.
>>
>> Signed-off-by: Alexander Perlis <aperlis@math.lsu.edu>
>> Suggested-by: Nikkos Svoboda <nsvoboda@math.lsu.edu>
>> ---
>>   drivers/scsi/scsi_devinfo.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
>> index 68a992494b12..c6defe1c3152 100644
>> --- a/drivers/scsi/scsi_devinfo.c
>> +++ b/drivers/scsi/scsi_devinfo.c
>> @@ -218,6 +218,7 @@ static struct {
>>       {"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>>       {"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>>       {"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>> +    {"Promise", "VTrak E310f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
>>       {"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
>>       {"Promise", "", NULL, BLIST_SPARSELUN},
>>       {"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
> 
> 
> Regarding the Promise VTrak family, the Ex10 series models all share the
> same hardware base and firmware:
> 
> Firmware SR2.8(3.36.0000.02) for PROMISE VTrak Ex10 series models:
> E610fD - 3U, 16 bays, FC, dual controller
> E610fS - 3U, 16 bays, FC, single controller
> E610sD - 3U, 16 bays, SAS, dual controller
> E610sS - 3U, 16 bays, SAS, single controller
> E310fD - 2U, 12 bays, FC, dual controller
> E310fS - 2U, 12 bays, FC, dual controller
> E310sD - 2U, 12 bays, SAS, dual controller
> E310sS - 2U, 12 bays, SAS, single controller
> 
> Instead of adding each specific model, it might be more efficient to use a
> broader match string to cover the entire family, as they all exhibit the
> same behavior.
> 
> I would suggest consolidating these entries. For example:
> -     {"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
> +     {"Promise", "VTrak E310", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
> +     {"Promise", "VTrak E610", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
> 
> This would cover all variants.

