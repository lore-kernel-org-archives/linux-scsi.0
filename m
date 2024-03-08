Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C29728DA5
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709918291; cv=none; b=mQxrGvaDk9nlX5OQ74HrW/HT6XZ8fF9GMcS6Ss7kaynj+C2UcJKeC4xUr14e11IER0x+2UdPaSkkUVv2AToHFHJa5aSUBgzy57traYfoUcvPZzxcWBXMmEOoGUlO83I5GBphnHQGeFj8jV3wBGUE96o1eVADxLSi34+/x+8EJ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709918291; c=relaxed/simple;
	bh=4QZFZIY/kmodj4JF06VYmGkSZCD9gnX1+VV1k7bwbbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqvRVFLFkdWXRWHOzCKmXMxnh1K2H2veizzNfbfGrFAdlyXIEuF3ZuKpKaig/R/Vvw450ORMTpFlwNqbvBpcOUgqHRTYZmOU6fG5Ikx9PQVwnRFyKW/Sp1bH01EldLNzYlp6bXinoOc/5kJreR4lVj8IR4ISHg9CXz0l7a3/6rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yTo4HQNQ; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yTo4HQNQ"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-365c0dfc769so2050065ab.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Mar 2024 09:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709918288; x=1710523088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OzUtklwPlJOuPJluAgACqxyTfZzplj9AthRwSYyjjp8=;
        b=yTo4HQNQDwfnjLZWlMPcHvoibIB96tsEqA9VKV1rvfdWH3cFsJcwVHWxEtFgAaga+X
         aKxk6r2GveOb1qd9TOhItsYIqtOXTWbjo4xsTZjRsMj4u51EhJLwJ5ugTebljVf0kda4
         +3/O/F9HD/ynzyFE4iCXfFLx/gjSKcf35VHGDhNmOT3o7FETuf9gj0GvkY2LhmhGhLxB
         de/ulcSmzTEbOuhG5BOxklup1aDj3cR4qUC6e0XzZSk15rTtANQ5rdJYgxz51jJhQvJ6
         dRkiAW8s9HiD3+hA/6dTbGeNjGLIUZo4S37nxzsQxqJDkgj/qBDgU24FfOI2yrg7USYN
         3RWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709918288; x=1710523088;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OzUtklwPlJOuPJluAgACqxyTfZzplj9AthRwSYyjjp8=;
        b=TprU+By4keT13DEw2hLwRoVynXxEXpqlT1ZI6wAoCrCGprBB6AsfxwO2DKtmNJ42b8
         qQRA8b227OTzCu4Q09JlKENG2qgGuaJJpjd9xb9WdjUvAeaqoM1bckb4t7uByFM5kb2B
         K2vrg+9qVkEn3tLxuSS6ilJ/yQE1n8tWwNQGsr6D83luBmIKJUCJm5kYaAZWoL4/hEH9
         X7N5v9K7B6jOWEgJ97/z7mIXdl8WcIjNYvwX+G4IJol+yDWxrIwbExVqJp7S8qEiWOJ+
         fGky8BRmXkUQmV2QuSqwWuDeNjYrg+dPT+XqQg62D/d+mM6xeGEWHhC0MRkM5wHtEdf0
         sXuw==
X-Forwarded-Encrypted: i=1; AJvYcCWXaBa1bGGGr8uOFAv7qEngO1YKPqa1TA7TZY8vlhWkBSIQEHe6LJVq/B6LlVX0oHBfeXOWmBhHZ/8POyIP65+vGXyf2rfsDz6TTA==
X-Gm-Message-State: AOJu0YyhUN7v5g41lCwuSWfRSkPbgYtxdoFwC4/Sxjcus3Oq5Sqcx7b5
	UWyDBk4c+O3pVhtVxaBSU8cqTAUezZbz8PC7ohjifOS3wZkVTWySsXt24cJ6+uk=
X-Google-Smtp-Source: AGHT+IHxACDHwXpB1DRHc3vyvQVo+hhXIx+dv77eD2O+Lwu72LmdLkTlNoD1vGHkQjkQPAl9xihoxQ==
X-Received: by 2002:a6b:7709:0:b0:7c8:7471:2f59 with SMTP id n9-20020a6b7709000000b007c874712f59mr2596113iom.0.1709918288476;
        Fri, 08 Mar 2024 09:18:08 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id do32-20020a0566384ca000b004743bc59379sm4533416jab.59.2024.03.08.09.18.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Mar 2024 09:18:08 -0800 (PST)
Message-ID: <30c3773b-4db3-4278-a127-df8c075e8109@kernel.dk>
Date: Fri, 8 Mar 2024 10:18:06 -0700
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
 <eef12540-84b6-4591-a797-6cfea7b28d48@kernel.dk>
 <8fde7b95-fed0-4cfd-a47e-455cccf1a190@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8fde7b95-fed0-4cfd-a47e-455cccf1a190@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/8/24 10:15 AM, John Garry wrote:
> On 08/03/2024 17:05, Jens Axboe wrote:
>>> And the callers can hardcode rw_type?
>> Yep, basically making the change identical to the aio one. Not sure why
>> you did it differently in those two spots.
> 
> In the aio code, rw_type was readily available. For io_uring it was
> not, and I chose to derive from something locally available. But
> that's a bit awkward and is not good for performance, so I'll follow
> your suggestion.

It's literally just one caller back, it's not like you had to look hard
to spot this. Don't take lazy shortcuts -  it's not very confidence
inspiring if this is the level of attention to detail that went into
this patchset.

-- 
Jens Axboe

