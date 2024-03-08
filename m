Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1839120325
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709917510; cv=none; b=BHxaqBed3AZ2VcrW6OJImPqqbF3lbqCCsLY2DeCXG6b91/X8DSWWXhlMcqKEhVvV1WwYpGm6KSMmg2ZG1nPI87CNZqhG6e//Joi9GqroVhtxpo5XarOMeQi57Bgm7/GjR2h307WRUgc7sLCwQ5DBeb5EuqwNeG2SIlwPE5gk57g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709917510; c=relaxed/simple;
	bh=a9B1XKf5v4a+2i7pOUkHcFgBwp8ihsYwhnXpzw194+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OJvE4+OBuys/0LqT1psLXiDlC/2xHtOBDFQwtnOa+ppA8jVNf/uEtPHxoSa68r3j0cPLuicV0iKseBgXMQiUgz7yo4nQBTjaPASN+aOuWffVog28bOwJqhclDO4KB4UNyFrA0FbTC+Y9zwbdGx5Q7E5F+qhs2SiSFJ4wAQTkKm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CifkeWXt; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CifkeWXt"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c495be1924so33517439f.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Mar 2024 09:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709917507; x=1710522307; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pt9oq3K3EFlza+ec+x3ugAytq31JzWCtDXSc9tgPdyg=;
        b=CifkeWXt8MULvB0rh2Dw87gIpnVZZqyT7d2k7PkQM70LVlq09Ocbye/u5g+rAPLkgE
         h+oujU74OO3HbSvlSUUVytFD5TbM1rCBXAluJFbWwPX3HoVa3WdKQJ2z3c7kDz74p9TO
         wJAPt9W+fdrrMLzUdUFBhRk4IF9wNlxeG1jgoWlCcWv/Np3UsvP+XlrfMOzlxvyXYjRo
         y3zwKg3Hy53trImEqDc4ZI6GP01ftaZsmPzaHZc49tbVn8hHb6+F0FptA8CshLYgL2tq
         k2CUelT9GKovtIrloNGQXy1+v71K2GrBSFIIyURb5EWJj5ar3V9pyGd7s46u9qIQxu5o
         6w5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709917507; x=1710522307;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pt9oq3K3EFlza+ec+x3ugAytq31JzWCtDXSc9tgPdyg=;
        b=ZNvZxF7ABLjzexwxT1DZMiUdue3QSu5dWPKWl+u28lu6YVo6PV9Q6RHCuSJmDZ9vMY
         8xM2s6Vg7apeZ12z8MddqJvGDyY1f+rC+AvsmuFTUnzd589jeeSXI9gQDGRrO+ITIVnK
         Z7l/Uzqo69Ei3ISJqPUEO7bxVh0soUy6/B2Zzhb8LcWyGmAWGCG7Ew14f8CqbBGMTf4d
         cnZbjLEJaPsEgZDs44FA5itw9wfPiEd5EOl97lU6OXhQd6yoSWcRjg8EERpIln1pxr4U
         48keOQkkv7wshNWLp0l5RropWi7eD4w0cL5hdYx7+vifz+ESTetijI9hc0UwlNAK7r/K
         SD3g==
X-Forwarded-Encrypted: i=1; AJvYcCVCKshEl7NEY4CgWRIPlbE31fVCqmODmI1i9MCgFOHNkLpdlK5RZ4lO5PHWWDE2oSLBvLO+4tWtRzCZJeAcFwgb+KIJi0fpW8HIDg==
X-Gm-Message-State: AOJu0YyU60Svqa1ea7IVtTzTOQ/tA6vCaD4IPLga13qpUNBPesU01qPl
	QFLz0/KWHSTGfU14+18vdQpJbH8W/P0q85wK316p4oc+Z3ItgGO861vRAmhgw0k=
X-Google-Smtp-Source: AGHT+IF7mIwvt3cedayTCmkSThguzKrWUC+b8e/OGO4yRw2KQGJBO/bSFddqcKtpqeOPe1BOt1/DQg==
X-Received: by 2002:a05:6e02:1a43:b0:365:224b:e5f7 with SMTP id u3-20020a056e021a4300b00365224be5f7mr2793675ilv.1.1709917507163;
        Fri, 08 Mar 2024 09:05:07 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y8-20020a029508000000b0047477265b90sm4767944jah.24.2024.03.08.09.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Mar 2024 09:05:06 -0800 (PST)
Message-ID: <eef12540-84b6-4591-a797-6cfea7b28d48@kernel.dk>
Date: Fri, 8 Mar 2024 10:05:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/10] fs: Initial atomic write support
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
 djwong@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 dchinner@redhat.com, jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
 ojaswin@linux.ibm.com, linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, nilay@linux.ibm.com, ritesh.list@gmail.com,
 Prasad Singamsetty <prasad.singamsetty@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
 <20240226173612.1478858-4-john.g.garry@oracle.com>
 <1f68ab8c-e8c2-4669-a59a-65a645e568a3@kernel.dk>
 <67aa0476-e449-414c-8953-a5d3d0fe6857@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67aa0476-e449-414c-8953-a5d3d0fe6857@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/8/24 9:52 AM, John Garry wrote:
> On 08/03/2024 16:34, Jens Axboe wrote:
>> On 2/26/24 10:36 AM, John Garry wrote:
>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>> index d5e79d9bdc71..099dda3ff151 100644
>>> --- a/io_uring/rw.c
>>> +++ b/io_uring/rw.c
>>> @@ -719,7 +719,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>>>       struct kiocb *kiocb = &rw->kiocb;
>>>       struct io_ring_ctx *ctx = req->ctx;
>>>       struct file *file = req->file;
>>> -    int ret;
>>> +    int ret, rw_type = (mode == FMODE_WRITE) ? WRITE : READ;
>>>         if (unlikely(!file || !(file->f_mode & mode)))
>>>           return -EBADF;
>>> @@ -728,7 +728,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>>>           req->flags |= io_file_get_flags(file);
>>>         kiocb->ki_flags = file->f_iocb_flags;
>>> -    ret = kiocb_set_rw_flags(kiocb, rw->flags);
>>> +    ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
>>>       if (unlikely(ret))
>>>           return ret;
>>>       kiocb->ki_flags |= IOCB_ALLOC_CACHE;
>> Not sure why you took the lazy way out here rather than just pass it in,
>> now there's another branhc in the hot path. NAK.
> 
> Are you saying to change io_rw_init_file() to this:
> 
> io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
> 
> And the callers can hardcode rw_type?

Yep, basically making the change identical to the aio one. Not sure why
you did it differently in those two spots.

-- 
Jens Axboe

