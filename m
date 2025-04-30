Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0367C1E32C3
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 07:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998791; cv=none; b=Kbmar5TwHi/YlA+ubSstnXleWgymOS09B/abMc710QbsK+acoRIjRPQ/3JHCsu0I4VzVqau9mhb6OelDnn76rvRHWycjVd6nwTcJW/CXeBOrAfekvZrvmNbY/SxBHHnEjFeK0A1IFgrO8dj7lFLpy5lE6Yn1MhfQSLvqOfE8JF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998791; c=relaxed/simple;
	bh=RYF5rT5SGXiuiOMM3oZfVuad7Ga744mi0LsZrurPLlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krMdjZHC3dYeH6AixTLO37hwDwG+n0lcwMajyWWMOIbs/osJ9wIlOx1CeQ6Id+OGjtjF4+iMW61/CzGqECZjlXIH9mwhxQYzbqwC2I+9bekFK+/Xy6EPkg+1CXU+EmWaOgxdzdSMYnTLDAw3Zq/VYRpCnBeB4gjrfLlrAdWJmjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HdAaxTbH; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HdAaxTbH"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cebe06e9eso46053245e9.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 00:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745998788; x=1746603588; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5U9OMJXkSPz8hKC+syIhe+oLvZq6aylg9p+TfyNHAYs=;
        b=HdAaxTbHS+veqEqCbCoTewjMJY68d5CBRPqjO4CQzHYraydK6c2WF9FOZ/tTUbfVLR
         Ly81+fApsU6mZeI6ygUxM1V7Fsf+IJZ1ifGysYqGaNNqRc7c71+4EYG1mYhwPEKnU+1+
         zKe/qvVH9sfda6jaQJc1i54j5memYI2mahU6+2EFZedrv+OYh2ruaBFFDEwSENYxe+Z/
         nuIb42Uapn8lk4RmWcnhuW3Xqas1cC75W7qHb+KayY14Z/RV3vutWRrYC+Ol5Ts8pBFM
         nXBIQW/bDZQM1Gs/k7n8bmYVW9nnqajeLlvHSd5wdxY0TJJTFIb+1N3rZaLRc1pIpdYf
         8Hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745998788; x=1746603588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5U9OMJXkSPz8hKC+syIhe+oLvZq6aylg9p+TfyNHAYs=;
        b=FwX4WKa/idNrI5tH9sHbURV4VruJqwcvOOSAXBPC3IaPcTeWLyhxzX5YoGW5rykVFH
         3vcEMesTQG1zViwvPrFI6IiKMvtxlhbVDhQacSW19Vq968O7UQ21Igr6UIQCjxXSmsym
         9QuxODCN1UmnLohmwUXBnvT52c4pMZLMeKaYoaeRdqgwmJO8zHp8axejT88fnWStFuzK
         t0kWH5jG7cTnQMUkPXhz6Khk6FSS7/1sWqdai80WjJ9KgM38My1c2ePDelzttQ/O79jH
         JWgEDcbwr6wYakQuprTVMjr2vrmixKGQPwwdyjrIbPUcB+blybfKzzjs9bYXRKLmwwCQ
         Qw6g==
X-Forwarded-Encrypted: i=1; AJvYcCX7w2AGNRLw2D9J2soCntMKCR0Etx4urb0Wm2+JblGtPAkewpazTtyHVW6WqLxIEC36uvwzXyWfwV6w@vger.kernel.org
X-Gm-Message-State: AOJu0YximyWnQ6DJwFc4pF98n+EOIuirE8hRU3zCVDitIQqzJNff98HZ
	j8iPAjAqfW0MMDxNqzWk+Gi7FBNNZu+hL+bCqeQjtWEN2U8nk7YwM2mqf55BNM4=
X-Gm-Gg: ASbGncvUc7gDzha898F/bReam3v7LV+rjojrsX065rWPHt4KtxU1rZQlyrLlWTjchUG
	PS+ZyBtQmFJVJvSCC17FUNKHdCzd8Wj+xLJsOV9MiDvX2mA1CRPPYzQm1i12PbETKL8qlcoZ6rz
	M4Y+Wv+887lr57qj/UYZpWdwgGRrYK0KVcpB776XX3riFOC7IirUDZPknkTGsEd1U2B4nMDqNjZ
	1u9lwakjo3/hXgzPD2ytFxtw0grAf1W+IEbxHSmVBEzVhUwDuv7wLL2kWtfLaHgwVKW3e+8zC4+
	XB9QwxEq2yWDcsTZE1SXkBIhMOrNMGWH6dMZ8JITXdi826O/aUOdyQlhZ7r84XpGmICohzNfsdW
	VIVJC2nQ=
X-Google-Smtp-Source: AGHT+IE8jp0ZjUVoh7f9msS1Shj+zFFjpix/VROzqHbjQs2YUPeE4capqjHRAxR03y+nyYOapSyDRw==
X-Received: by 2002:a05:600c:500a:b0:43b:d0fe:b8ac with SMTP id 5b1f17b1804b1-441b2695e64mr12959955e9.30.1745998788203;
        Wed, 30 Apr 2025 00:39:48 -0700 (PDT)
Received: from ?IPV6:2001:a61:13c6:eb01:e359:8d71:4b9a:921f? ([2001:a61:13c6:eb01:e359:8d71:4b9a:921f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2ba4b10sm14125645e9.16.2025.04.30.00.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 00:39:47 -0700 (PDT)
Message-ID: <41bc286e-6e6b-4ae8-ad6a-3bdf56cd172b@suse.com>
Date: Wed, 30 Apr 2025 09:39:47 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in reselect()
To: Finn Thain <fthain@linux-m68k.org>, Nathan Chancellor <nathan@kernel.org>
Cc: Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
 <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 30.04.25 03:36, Finn Thain wrote:
> 
> On Tue, 29 Apr 2025, Nathan Chancellor wrote:
> 
>> This if statement only existed for a debugging print but it was not
>> removed with the debugging print in a recent cleanup
> 
> The patch you called "cleanup" has a "fixes" tag. Strange.
> 
> I think it's unreasonable to refer to a patch which alters object code as
> "cleanup".

Hi,

yes, I was unsure about terminology used for code that is by default not
compiled, but would not compile if the attempt is made to compile it.

	Regards
		Oliver

