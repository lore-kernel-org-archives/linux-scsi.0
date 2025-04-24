Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423A3199948
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2025 06:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745475287; cv=none; b=H6GiaZhq2U7Vw9N1ZM84YTvtd32kSpQZJSQt1Fww/cvfjovU3361RryWP8GJGezTINcJbj7ygdZC858oInmB8yEsyJnbBdQt85G2cJpZ8wqXEZuDwoPZKMlNXVgRlYE8ky6AksYpthAX6UzctbSjr4DHTl87ArH3DGNCXadjrwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745475287; c=relaxed/simple;
	bh=ikZlhbwKTHjaNDw4vZfG0SZokKJ4sUFvzcUkdejt9Ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MwUZEYKA7POYpZJhEqo+WCNSFWu8u0Vmm54T2fqtA2YOtj9oky1WXndntDQQN/cxAryrjI8jV2LhgB7R7Oo8HU0End0U/2bFKdFc0T+O6BOV/CnfImJTQWwxIFzT0+yGYuBMahH1ywbO/rZbhvfs9+lXj+3Ia2j0330gbcpJ76w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dN2c56vw; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dN2c56vw"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso76937166b.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 23:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745475283; x=1746080083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FC7LE0QO/t68hv5Jq9QCAxCamjYGyd/GLyn/JiI3/KQ=;
        b=dN2c56vw4ZTOVKERBGurF+zV3b6VlahhZc0ONj3f/X/1X0I5m2rijFgQjKpyXQoFoj
         sg5B41XB0d2fwGfeYvNrs7C5C023kviOxxp8DSJ/IEPJijKwzc/gvsKGHGp5SdjpxsOw
         m4aUhNVFy4lJLsqDnGa0thZqbsrYiR6ZBYYbikwuGobDDyxFEXYrcvH5mg+Ed8khErUp
         oQcBDp7HcFEb9bmmv6qsoKFhIGFA0mOvbIyvyTu9wRppeDV8Y7q5nacvCcy2UieMD+q8
         35pLNwZKKUbjpqI1jc3vk+MJWCbz/oBsUa4VUxN4lIYU2+hOsT8HuU1Q9TgSQjGE2opF
         jiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745475283; x=1746080083;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FC7LE0QO/t68hv5Jq9QCAxCamjYGyd/GLyn/JiI3/KQ=;
        b=QPDLpp9r29mZF25RdZmva7lX4Hn263ABROkTjpukd3rhAfGuJbCk0SYEK98WgWUDYB
         K4CzvyrwfG6eUs3auK3pJk762XacMO8pEUB97v6h7CySRTpZncEkdeyljd/yuOJyHeDT
         3cdenEnRO9ulPNOgf63pGpReM7hHYgvD5t8Y3ledst0bTxoDJriuWQwOAzFsbKN+gHT/
         Qlz19piw5XGTfVyXIw86+PV6oDWwBk89OC5JpAsONQvMotvofrm1C61JVNvmm5jBHlxZ
         DPiDm62szMg0ykSv/qEeq0grHNQ0dBbSf/X6tB8BQaYVVH+ps/VVzxS61Pg83G3kfPmF
         8Rkg==
X-Forwarded-Encrypted: i=1; AJvYcCXcqm7CPCkTnCFiybH9QmkriWsr9tjrh2WaCN+OdFJPVDdOUPj1lWQgnPlywkSmTa3I8gvhfZAfUT5q@vger.kernel.org
X-Gm-Message-State: AOJu0YzFNBSHti3kzOZi3jtvOZfDlb+QBYkydcGbLSMikfD1CCkFCmzI
	wuk/jPsZrh5ykUVtAGxnnewJk5hkahPKJHD0ch6IXy2PufNBXqXcd9/BdkpD7lE=
X-Gm-Gg: ASbGncucBhymImJp5Q01YTKzPFrBQCx5D4j7QZS8HPf9LWjvQ3H+EsqJ5DLwZL7IlBF
	MjpvJSfxgjgERjnMF/CsuYXdeuEnfCpY+8gRwZlAVGyoqrw9X4xIIDhuG0VAHp7fKw9QplwVhnM
	U86bIEbKF+T+KxFt5NYS43oEzxJsygq8o0fUJDmKNTS+/H+vd3O/Lr/8Iaygmk9ublO9mLFxZaK
	fchDfEaMNtYgW4J9Un1MPF65KxI/KcXSjQ6e+PI1bsGPwqwnGdg/uf4bPdiGNQSz3d4KUKGmJgO
	GUcyKzxQiJo+gkOvdcgkguQ/11TIHzuLt+sVOQ4rbtFHGEZwL3tpQ2Skh9yUDWGkfUk01kN7TVf
	r
X-Google-Smtp-Source: AGHT+IEBYlBl1CDzg+KOpWOrCm6Q7eogybzfxFRvlWGQ3CGxlUHRr5ImO3LVC7md8m90Q9SDovihig==
X-Received: by 2002:a17:907:9801:b0:aca:d6fd:39a with SMTP id a640c23a62f3a-ace5744ffcemr125020366b.51.1745475283411;
        Wed, 23 Apr 2025 23:14:43 -0700 (PDT)
Received: from ?IPV6:2001:a61:2b7f:8f01:ed13:8888:df70:a3b? ([2001:a61:2b7f:8f01:ed13:8888:df70:a3b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59830f51sm51667466b.5.2025.04.23.23.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 23:14:43 -0700 (PDT)
Message-ID: <801f48a0-53ec-4ef6-a507-3c73ba8acaaf@suse.com>
Date: Thu, 24 Apr 2025 08:14:42 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] target: Move IO path stats to per cpu
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250424032741.16216-1-michael.christie@oracle.com>
 <20250424032741.16216-2-michael.christie@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20250424032741.16216-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/24/25 05:26, Mike Christie wrote:
> The atomic use in the main IO path is causing perf issues when using
> higher performance backend devices and multiple queues. This moves the
> stats to per cpu. Combined with the next patch that moves the
> non_ordered/delayed_cmd_count to per cpu, IOPS by up to 33% for 8K
> IOS when using 4 or more queues.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_device.c | 69 +++++++++++++++++++++--------
>   drivers/target/target_core_stat.c   | 69 ++++++++++++++++++++++++-----
>   include/target/target_core_base.h   | 20 ++++++---
>   3 files changed, 121 insertions(+), 37 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
