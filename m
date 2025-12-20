Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BBA29A1
	for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2025 00:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766189131; cv=none; b=YCrQdy8tFIl9Q+q6Lla89FOoJk1eGS17+JSHOjRn+E2RXJIdPl80y3DjbBjrxFOlwCAeGh6NDgOj23kWwSdnfKIIR+oQPNIqulcNgr/JL4Hzan3OdVsMYRU8YY4idUgy9c6ztIEh+Iia9aW/jC/CcdGhYQCtF8eVcLSAtR9a+nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766189131; c=relaxed/simple;
	bh=DHYtOjNzy3eBHAtmW1uYWjhjDKZ7cTMfkNRmOYczYlE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OESSNJUfJz5H5U9mUPTdVPpmLjKnHxM6cCSSecGYsrN+Xye5RgbfFBq+90l1QrcHpSHjwKMa3q+exE+/xfW8342yjxlU+inV18RfjXgia/bdKM5MwdD3VQrbnTH1OO4L7kJU/PKKQNCW7crve4TF3ksVB8GkZ6Q4d5kAoB1wfh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gS3Der2o; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gS3Der2o"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34c718c5481so2179831a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 16:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766189129; x=1766793929; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/fszDsH7M6WI1L2IR47y+E3YL7X4tFcHpI5uqo91tN4=;
        b=gS3Der2o4o6yE+D2H1UypWizCLeJllzxpz4/4gXlRzML+BJgAc4I8JmCyTwMBk2j0m
         9RjT0918F6n/hswwMdqfSaXu+2M99IG4ivKdUA+clKJ15PgfFKFFKnNJixpkC2pbdwWy
         /chPwwhwXN5SpqA9MnXXRB7oyrkJght9p1yK7PxT+iuauy+z5EWP0iJ5YxBzMf673b47
         ve0bVG84bdRX4AYw3DZAWKMAoOj2dr0Qbn2u3h/zC/vvxxciJy4C33wcaWFo6t3UZgan
         2dJSm59Yi54ohi7QlVBuvqXvYlir6OyEi7b/7WSLfRRggIoqm5Tgrw9rOI2Lo3hZLbZh
         Si9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766189129; x=1766793929;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/fszDsH7M6WI1L2IR47y+E3YL7X4tFcHpI5uqo91tN4=;
        b=SpxKDpXWtD8f3Qmdglk3JiE0SqtwGzdZg3fpm/sTI9+b2WVSuTkDH2hbG3tRIZ93q8
         eFSlt7XFlAND/8YOv11PGwVwOo3u05fxBpqbV1tvMiWHAH1RmYbeLQtK9doBPey5EV8F
         F7DuWP0/0LDPiZGAswOPOp1hPs3QHfBufNcKEdH7BSt1B++NAA3VlIbYRo0nMdtmFB4r
         5GFFt/T+WKusgMAz1Y4NnQqBNcqniOy/Tj/a+BRKVbh/qlzEC9OVm9ocrTEVuEO0GEBU
         D+ilpHkJ0pYsASu8Ns4gKXq0I7DPdBkNJp7jPUQoT5H+mc9OmCZDlRyCtoB5ZsTL1miL
         /m0w==
X-Gm-Message-State: AOJu0Yzwl9PR/3QlEVZQhdrhqnNXgaJCvXLNyOLCxVv0F/h7/ARgRfW4
	oz1HjSZHrQVppL085GGcMJfezR5nA+4rGsByXMtPqBg1uwCct5JlUldD
X-Gm-Gg: AY/fxX7aouusLlhX+3MjLvYKuD1pFBy4dNldSXWkm5BL8sx8yG0IBBaGWkx+GZGZzzl
	23miz7+7CHz+cfbbts/G9dUj1XgodhDiYq5LUxUDmaD5ve+FGFE+zdz6Dfbg4SC+4K5wNRwKE9x
	d6Z8x399TD91kiuVZp5G7qSwIv492DIoEwxPxQ9S0yOJbO7G9eFzTwo3qRv1bsPbVh6RXTs+LBW
	U0RY/frOdxbIe/ldj9W7CuP6nZqcB39gqNDZPOT4rmGnjycM/lQ07dgJW7xJH+0NUV4bwDS3qAe
	qh+e0vOYSiXrZh9OXCs+hPPF96oVe4aFJDyB48iu2WH2o/NfbPGOI+y+9z1izRrcC/Z0wcAtFX6
	C9p/M0xJMJBdVOCZEfxvam5L0jUrYjH5DkacJQIJdgV+QbsdXi3GZSazgnbxflH4tZaPPX+3+y0
	6axiZ8Ek7nfX9hmdMWHyqJSM/t1g21mwG0oG7mp0RVuIKV9WeduQg5QR1qDunBddrEXVUi8FEFQ
	2rukyvq5h7XEodvQ+A8386WF1VQ5bstNH0nsLIObS9E
X-Google-Smtp-Source: AGHT+IFqZXzMq97UtLhwZ68/9PyK5v2d/rDCXYQKm3T9+VHPCh/2PFZEf7OWn/oRRUV0AJC9PNc/5w==
X-Received: by 2002:a05:7022:213:b0:11a:4016:44a5 with SMTP id a92af1059eb24-121722de1e1mr6241495c88.24.1766189128839;
        Fri, 19 Dec 2025 16:05:28 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm14089306c88.16.2025.12.19.16.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 16:05:28 -0800 (PST)
Message-ID: <ddf72e7a-a5a0-48d0-8714-9f3caa4345bb@gmail.com>
Date: Fri, 19 Dec 2025 16:05:21 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/6] scsi: core: Improve IOPS in case of host-wide tags
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251216223052.350366-1-bvanassche@acm.org>
 <20251216223052.350366-7-bvanassche@acm.org>
 <ac537693-ec0c-4c50-8ee9-a02975f0e18c@kernel.org>
 <dba8da69-1f14-48a5-a540-01e8659b7d3a@acm.org>
 <074e472e-4320-4d42-b4ac-a1fa7585e2b6@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <074e472e-4320-4d42-b4ac-a1fa7585e2b6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/25 3:06 PM, Damien Le Moal wrote:
> On 12/20/25 02:35, Bart Van Assche wrote:
>> On 12/16/25 7:24 PM, Damien Le Moal wrote:
>>> On 12/17/25 07:30, Bart Van Assche wrote:
>>>> The SCSI core uses the budget map to restrict the number of commands
>>>> that are in flight per logical unit. That limit check can be left out if
>>>> host->cmd_per_lun >= host->can_queue and if the host tag set is shared
>>>> across all hardware queues or if there is only one hardware queue  Since
>>>
>>> Missing a period at the end of the sentence (before Since). But more
>>> importantly, this does not explain why the above is true, and frankly, I do not
>>> see it...
>> Hi Damien,
>>
>> The purpose of the SCSI device budget map is to prevent that the queue
>> depth limit for that SCSI device is exceeded. If there is only a single
>> hardware queue or there is a host-wide tag set and host->cmd_per_lun is
>> identical to host->can_queue, it is not possible that the queue depth
>> for a single SCSI device is exceeded and hence the SCSI device budget
>> map is not needed.
> 
> Still very confusing because as far as I understand things, a host is not
> necessarily a LUN/block device (you can have several devices/LUNs on the same
> host). So in general host->can_queue != device max queue depth. Also, I am not
> entirely sure if host->cmd_per_lun and max queue depth of the LUN are the same
> thing, given that SCSI does not define a maximum device queue depth...

Hi Damien,

There are important use cases, e.g. the UFS driver, where
host->can_queue is identical to the maximum queue depth per logical
unit. A single UFS device typically supports multiple logical units.

>> Please help with reviewing the ATA patch in this series.
> 
> For AHCI, we are dealing with single queue devices, always. For this case, I do
> not think that the scsi budget is needed since we will always have scsi tag ==
> ATA tag, between 0 and 31. So if you can allocate a tag, you can always submit
> the command.
> 
> But for libsas HBAs, I am not sure at all if what you did is solid/works,
> because I still do not understand it. Please provide more detailed explanations
> in your code (comments) and commit messages to better explain what you are doing
> is safe.

I plan to modify scsi_needs_budget_map() in patch 6/6 such that SCSI
hosts that define a .change_queue_depth method and/or that set
.track_queue_depth. This will prevent that this optimization applies to
libsas HBAs. From include/scsi/libsas.h:

#define __LIBSAS_SHT_BASE						\
	[ ... ]
	.change_queue_depth		= sas_change_queue_depth,	\
	[ ... ]

Thanks,

Bart.
