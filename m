Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC94146D5A
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 16:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381073; cv=none; b=rWjcY5L2hYcTPvUNjGzhbJQ8I2PavCyzkizVGorHyOkTVAZWUXLholteD4d5FmsIjGiX7B0jgaALIYKJ15gPanwqXLveJxV7U2BhJRTZwbwJbW79uw0HOY+HXx7HiMVnrftt22+vf0/6korDPTLjrE4DblO7izUkGt0S9dPoWmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381073; c=relaxed/simple;
	bh=9K03K1EOb8N+Ye1xk9pBTeEFKwI2LrZ11+DIvfyUMMw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2j+Fe7if0AATIX1mXBlIVRhlZWVuPQ3aw9xZs7Ol2DPuMv1Iy9Oji/rygrSrrKMidZpFpShCHG2y0ovThC2LPef12WIkcAeAjPuq6ekJ4YfGZxC4JlfQrsto6ebTdtjnmGNuvVw3R7ICpeJ1+EIiSnD3RsO/w6y6VykOw/DovA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FaQFEUyn; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FaQFEUyn"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7041465b084so36928b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 09:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718381071; x=1718985871; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hCV+IWPk0IvkJKtq2bRF2qxH9qFCYf5hnPfztISGB5o=;
        b=FaQFEUynhkHMl9J/rAt4Z4QUQgbrc7UVEbBDgAhsJ6FkxZhgjmTBnjktvoPg/oE4AV
         CRgb6oqD/4TglpnMU8QyeZSzco3USa9DR+I/d5BJgRh+Gtw8O2F2iIhksc9yGlFj5VOc
         oGgqeb7X5gPmTnoxBzXbJkFo7sB4e/HZAZw3pqpWzr+oPEk1BWGxBxET7PveqWFuhgaN
         CR1LEiUZViJ/V/k8rlI5I88iWpBKQH5ezUGHTmXuAR8TpT9Ugws7DQH4C1ofuNxjc+Bl
         5KWjr3H4fvP/OzpQ45OEmMzT9hpkm5Ys0MbuGixhsLKqDaEvLN3Jywn/YAI4X3Fkqt0L
         mDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381071; x=1718985871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hCV+IWPk0IvkJKtq2bRF2qxH9qFCYf5hnPfztISGB5o=;
        b=aAM+QDwTSt+M0TCGVFvYbGLSog4ZyXH5FbsAOaChBHnry0dm3Q2B5pOHm0iyExrDq9
         l65dvpK+UQ79GRUBBApEi4fnJ1Mwb8Xdz5Dxn6yxi8t6htd310S4QAH+OB1Qh1T1Cojp
         snIggo88YsOd5C1rmj8W+V1N/bXLYGz9D1HoJ2B/ypuJ9HtEOBpBQZH+ycQrYtcfrbqD
         3qqRfrApAPUOLMc9n12odHS28KvyLn3iywkGGVrey1Qd0mAsi+/tjR9//Hpx2ZQ1bhfU
         cbGmGWRWkQoD8vsmjs52j4b1GNGJZkovauKrSGvcgDWRwbL5zl0bsUTv2PiAcXA9/xJT
         jkFQ==
X-Forwarded-Encrypted: i=1; AJvYcCViJeld+Z/xPx3ms9iL3/VgkxU0cQ0Bfl0/oP3KDP4QigY4YwWr6vc+zXQjiU3mr7TEI9GTkruUK2mQho2qC4cbjSCK0U2ZPUBqFg==
X-Gm-Message-State: AOJu0YyViWmdrSz2ZE57Wc+VbzwVsQzx5Fzk85FKbNc6eRYu40g0Uz1A
	dldBepinwuIKSuxpsFeGdEuAJPHK7x+GMfBmPX4EJiJgN0yc05ggROrPSlqJU9o=
X-Google-Smtp-Source: AGHT+IFcef25ONKjtc899Mq79qjBziTk8bpO5RUNlOaMS9rx17DLdtap7aVVIksBs4B1DV1O5X5XIA==
X-Received: by 2002:aa7:80d7:0:b0:705:daf0:9004 with SMTP id d2e1a72fcca58-705daf091c8mr2211921b3a.3.1718381071337;
        Fri, 14 Jun 2024 09:04:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb8d9acsm3207006b3a.197.2024.06.14.09.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:04:30 -0700 (PDT)
Message-ID: <af0144b5-315e-4af0-a1df-ec422f55e5be@kernel.dk>
Date: Fri, 14 Jun 2024 10:04:28 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240613084839.1044015-1-hch@lst.de>
 <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
 <20240614160322.GA16649@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240614160322.GA16649@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 10:03 AM, Christoph Hellwig wrote:
> On Fri, Jun 14, 2024 at 06:33:41AM -0600, Jens Axboe wrote:
>>> The series is based on top of my previously sent "convert the SCSI ULDs
>>> to the atomic queue limits API v2" API.
>>
>> I was going to queue this up, but:
>>
>> drivers/scsi/sd.c: In function ?sd_revalidate_disk?:
>> drivers/scsi/sd.c:3658:45: error: ?lim? undeclared (first use in this function)
>>  3658 |                 sd_config_protection(sdkp, &lim);
>>       |                                             ^~~
>> drivers/scsi/sd.c:3658:45: note: each undeclared identifier is reported only once for each function it appears in
> 
> That sounds like you didn't apply the above mentioned
> "convert the SCSI ULDs to the atomic queue limits API v2" series before?

That might indeed explain it... Surprising it applied without.

-- 
Jens Axboe

