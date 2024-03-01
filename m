Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7568953E0D
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709310614; cv=none; b=XgwXQT0yBF7+PFHOyhWRXUzCCQ1PjoiCQO/AjhMNDzUfaC/uD78ve8TgoLO3dfUn8t5LBwFe//CZB36/1Pf3C2aS0Afijn8eAqTYFTlGe45UWYdMiln5TYhftrhI2tEHXEAVXa7I7g0qUUEnqxT7XnOnPbzI+3sdAew83ZNEGlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709310614; c=relaxed/simple;
	bh=eApwMdV77Pr6TQOw2X9bSNSaGq9RsqwjQERYxJjbiRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OfIyWcNRMZMp8AB9xZll/GThpBDz1iLVVNxXHjes3MAHgRebEKk1EaEOR4fhr22eiobqjBgP7l/2bTejsnqyi3G9AEEei5PuRb2hBgxRAslC2SfPVTovxuyxKBo9itwOqJ3ikzxQz3XB75beZVJc9B+3DDb9m085xzSPbqijTBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e5c81ccfb9so529737b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Mar 2024 08:30:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709310613; x=1709915413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxY5u13o4NIGqi8UVa/l0eoG1+awUYdFkDwGxEeN9H0=;
        b=Ys3K5noXv+EJU9yLf+w5bHOSvWIdldpoIZXS8Yzt5l68vt/4XYhzxXSVIG+OSWxe78
         IvJWs5aYZIcFsubr3QeYXJRG1qTF/WczsXEyTd178DkJevtexnb/wAZuzHrp8bOJewFN
         7ACxc48RCnwP8HetXaUbsapY41lP9Nw5Ut4pdnQvkTqDrK/beD88W8EkpR8DIdTvTgcg
         6J+mJ/u8CIIy78RtkHPuPgGfvbhL7c6k8zY12WL+I1t+k9PitadxqImk0XeBQOUaB5YO
         HyIsYAjFAWSgUN3cbjX1TDsAf2uVnUHJhsCADqAbpAdWTscIXMROkTkDdePkn4+lM3+t
         /zog==
X-Gm-Message-State: AOJu0YzoS7C6NlSqG3OE5fk/XjAk0qPry6fCMZV2JbxZuZ4ceAaodB1H
	hZjXhNj51LJiuv85z9/f7h9UhpxgX8QRErYbXR85T10hS5gyZN6s
X-Google-Smtp-Source: AGHT+IFerv1qbC+PLlBKhDhvegr1ObmSf6ROFxLDFNSK8caIUiaiyUqV34g1lYo1NFBXk/TvyQEwlQ==
X-Received: by 2002:a05:6a20:7d82:b0:19c:a3de:647d with SMTP id v2-20020a056a207d8200b0019ca3de647dmr2126251pzj.19.1709310612764;
        Fri, 01 Mar 2024 08:30:12 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id e29-20020aa7981d000000b006e592a2d073sm3076895pfl.161.2024.03.01.08.30.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 08:30:12 -0800 (PST)
Message-ID: <61b4391a-8613-4ca5-b250-3253f2085712@acm.org>
Date: Fri, 1 Mar 2024 08:30:10 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Make CRC_T10DIF support optional
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240229172320.2494100-1-bvanassche@acm.org>
 <d94983a5-9c0c-494d-8fb7-51e3dd2d3460@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d94983a5-9c0c-494d-8fb7-51e3dd2d3460@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/1/24 00:59, John Garry wrote:
> On 29/02/2024 17:23, Bart Van Assche wrote:
>> Not all scsi_debug users need data integrity support. Hence modify the
>> scsi_debug driver such that it becomes possible to build this driver
>> without data integrity support.
>>
>> Cc: Douglas Gilbert<dgilbert@interlog.com>
>> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
>> ---
>>   drivers/scsi/Kconfig                          |   2 +-
>>   drivers/scsi/Makefile                         |   2 +
>>   drivers/scsi/scsi_debug-dif.h                 |  65 +++++
>>   drivers/scsi/scsi_debug_dif.c                 | 224 +++++++++++++++
>>   .../scsi/{scsi_debug.c => scsi_debug_main.c}  | 257 ++----------------
>>   5 files changed, 308 insertions(+), 242 deletions(-)
> 
> That's a pretty light commit message for so many modifications.

Hi John,

Thanks for having taken a look. The patch description is short because
this patch doesn't do much: it splits the scsi_debug source code in two
files and modifies the Kconfig and Makefile. No functional changes are
present in this patch.

Thanks,

Bart.

