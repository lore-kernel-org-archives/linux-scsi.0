Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD56425A33C
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746015114; cv=none; b=gC6w6EhCmQTsIzcbE8TkeKWyFFOZaEAY8SdH82aO9yNel/hph5dS4wAzfVMq7pwHYrZSD+EQDsaJZKK09r9VfDuYOjwMSz+mUkXrcLEEhmVtAfLqCuA/KKMQNByjrTl5BK/bt/rQx5q29RMdPBHhdzQFc37FLZhMOhGWDdcQ3Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746015114; c=relaxed/simple;
	bh=9V8hG0kuB8a9dfhOvU2/xeY8oePk9/AvAiE5vkZROHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VB8+j01jEI9e9XHIw2LHswFrHEBAcn+X32gtNsifLUWTRzINscsI06LWIWOfIGvpEfD7SpGavsWL6SCZqsNuUXaQ2ZfrKNiFWBKcUogkuH6UiG4CQgjjB499C49fxJYi6feH6qo28g7NFIeO4LZyc2+E7lLBw8hmxEKcAOyhU34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U8RVpBHI; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U8RVpBHI"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac6e8cf9132so1423778366b.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2025 05:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746015111; x=1746619911; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B95QSXbaRKrQee1y60Xx4b/cA/KifuO/m3Um/1ZsFQ8=;
        b=U8RVpBHI9ee3qK4g5Ugqj5uHTpGyaOR8kAahmhHJ3zWag9c8c9XghJUa2ENiPZ3FjT
         hwHwzpazI7FVSmz9zVqqRaeGNGmUAr0MqJx4tVKOGM16j2XS/I6eSu7ukY4hGMis5BzD
         x+UgOZ3U/tSKTt/acvix3KpbSsdvAtf2NJ9O6CBbCyxN2fzrIboi0vLCsc5iAXZ4FjhQ
         KHQ4DPc35U4hPIliQo8BTWwqgtvUOpLcHechQBeI4wfYq44sNwjIA0tb5H7X5SXswERY
         JgoTMu5e3D5L8J2A6DNLR8RriPMXYXlrCEYmkmvmW1VNwHRbM+4D+53Ij9o8sJTz6pU4
         qsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746015111; x=1746619911;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B95QSXbaRKrQee1y60Xx4b/cA/KifuO/m3Um/1ZsFQ8=;
        b=i7EKnEsd5RWUG+sZnZ+j8TlCq2dYe7qq/l5TXH9RA5yEW3R6NXO1MMnHSRPsujgPwv
         Rsjr2FQGG+upYRAXKnXIcV9ASGfuCjWh+PrKAB88v3fAqySi+wvQIYFyakG6FCTr7bDK
         YvFI8DA4Q8YUuXLieGL4myJZlKMNS2ya4UyfEymYdEJ4NEnxsxA7pU/mtJzv5hC0elAc
         7OkjOfIE0izvc5Wn/OJYQJdjEDeTqY01epzl1aFkwMm5Xnsvh1ABanlbWZnmehcT38KB
         T19YgRTFuI9Ie2gBSWQf4Axkye53zcdLh/+lqJxSowTeFzmWLvDCloVREtaDkqC5BtbS
         PwSg==
X-Forwarded-Encrypted: i=1; AJvYcCVQ+pWRm9kFqEe16aPpr3wCK3+P9EkBTjLHtqlwp3jLQLs6h9KcFMNWlz2tFTkY7p1W8qXFKAf4nw64@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1f0uhoiKDYqeoVZkyisVxhj1NZpK2x9Xx+V2Dd51LYakcipOA
	S7ckEGHHx945qKX6cZiPpLtSNqrzGR+a5JcQKX1DUKXvWtnk4xSQ4w+XqzWvg5I=
X-Gm-Gg: ASbGncto+RMKAV3acDCI2ZUbPkoKSpdOrRdNLbk42qw/uwmFu1Z8iWBOK2RKCAUMNjK
	YKSaUFPL5ZW6tiXFa5T5XrbyEtlsx1lsX8IG4KCVuM/937j5d2b45W+HKmhx+kDj5kW9EdZTT6/
	4im3q9B8BWN+PorgSz0VaSPNuoIgeeT9/XUCA3/oSyAFpewauE4f5IatD9bFGiw5avCKhwi4eC4
	MBKVSWVTO2PhPZzAnXA8P7yzDjCv/ZijOwF5wKcHAKtghevNvTZX80A1rdQjh76YmPFaKX9Ov4B
	c6FNkJWQBTvuA7OjS1iUSGJcbRR8SgoeNSkP6TyBdQ4Wo5efVXs+g5F55bnYZmEnf04hgXHvqHM
	q41+YkVtpEPHXeC7P
X-Google-Smtp-Source: AGHT+IFr6SQQ+d2QrrxDwLOsR+z8bVyCtqJ1ToE4PnHRFIcIMnjdCwxrzr0yGNH9fg/1HzSz+gHXaQ==
X-Received: by 2002:a17:907:3e8c:b0:ac7:f348:b8bc with SMTP id a640c23a62f3a-acedc7be3f8mr277378366b.61.1746015110909;
        Wed, 30 Apr 2025 05:11:50 -0700 (PDT)
Received: from ?IPV6:2a02:3033:263:b03d:abf1:3c8d:23a2:52d? ([2a02:3033:263:b03d:abf1:3c8d:23a2:52d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ed702ecsm922371266b.137.2025.04.30.05.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 05:11:50 -0700 (PDT)
Message-ID: <06495223-342d-4759-995f-f62234fb1020@suse.com>
Date: Wed, 30 Apr 2025 14:11:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: dc395x: Remove leftover if statement in reselect()
To: Finn Thain <fthain@linux-m68k.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Ali Akcaagac <aliakc@web.de>,
 Jamie Lenehan <lenehan@twibble.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Colin Ian King <colin.i.king@gmail.com>, linux-scsi@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
References: <20250429-scsi-dc395x-fix-uninit-var-v1-1-25215d481020@kernel.org>
 <91ba6cf2-ca95-1ebe-837f-ecc89f547ea2@linux-m68k.org>
 <41bc286e-6e6b-4ae8-ad6a-3bdf56cd172b@suse.com>
 <bd660f83-434a-85dc-0037-7830f58acd6f@linux-m68k.org>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <bd660f83-434a-85dc-0037-7830f58acd6f@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.04.25 11:43, Finn Thain wrote:

>> yes, I was unsure about terminology used for code that is by default not
>> compiled, but would not compile if the attempt is made to compile it.
>>
> 
> Yes, I realize that you were referring to the intention as "cleanup" and
> not the actual patch that got merged.
> 
> I'm afraid my message was poorly expressed. I don't have a problem with
> your fix. I was only interested in the general case.

Well, in general I think such code is problematic. In general I think we should use dynamic debugging statements. The issue seems to be of terminology. However, we can hope that this will
go away and become moot.

	Regards
		Oliver
  
