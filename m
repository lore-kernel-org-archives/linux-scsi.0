Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB1E1957FC
	for <linux-scsi@vger.kernel.org>; Wed,  5 Mar 2025 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741194223; cv=none; b=TmsZHWgFqzdiPVfca3/S+hOVdqKGpq4wD6XF6mis9V++Zv2TvT9h9AMfjbk4Y3NwKV8/jYxHIDF4miS/d1EBEZCvQwa/VtuehrAZz9ibaJl7hsPzmZOPro4+eXG/q9ekdhgRdBgKcXRtl4pPwZl9ASAEf8IKla1EhHrzCjhRJrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741194223; c=relaxed/simple;
	bh=JNa80S5ubLg4TDjQSpy0UyE71ytxV5jGCgzwAqIqK+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cj4ehuVvHgoPXz55gfjJAwTgRFC1ryCRwCNvkaAVS0KenO9in4yUBcWSTEuBwFrZ7eTdXIyTyzAcXm3QYJoKU3X2KLdZVHdJp/hFPSC6XZV0wAoxj6RxI41XYtkIHAL8UOmU6qxI1knYDUUXs4Hy3RMOeiKySyhuB0TnpHIplnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K5IaHcgO; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K5IaHcgO"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85ad9632156so265792939f.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2025 09:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741194220; x=1741799020; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ye8jYdlNGDHRbJBuQVYikUVt9cJikB2/kGvMNNsxwb0=;
        b=K5IaHcgOHc8On8kfp6yjGrZA9svYKaun8JwL9mMrK8BDjFcQU1uktcnnCRlc9NQMv+
         Qilk86CX/toNRa1qPFUZrP/j+8BzgFxOH/owMJKIICpER2QXZt8NlE8e5SCn42me+2GE
         UC9kFDVFn/TUnRelwNdDXmntMZjFkslHkNkLnqmkjTxc4Y6BhOzybAMJDQkYoybLIKbn
         7ebaCTGmKbeL/ccmsl4O5cfjwBJfKmhsNyao3hRlRX7XSw7SuVRLcv/kmti0xxcgyWL5
         dIdvmhe/Eb8d5rP1vTVoBUEQx+TreOFMddnnezDtQkRabreIeyiWflxNzpAbuBBwPSJ8
         H0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741194220; x=1741799020;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ye8jYdlNGDHRbJBuQVYikUVt9cJikB2/kGvMNNsxwb0=;
        b=TBOhcu40Tf9iqf47oBjTH5aqjSjWuXLAA3hInPbU8gbkfkJmZl+DgvUnsIfKwqSOnP
         eDRlNdsbt5C6s+AbLde3ChK3Ur2cpGS5s2RZ8x+IeFuqTOq9ZtvzFhJhT2WkRAuhDSZI
         htaGkTYVTqgbs5WFysWfmfjO9EBjQ9G6YnQ4iIYDk/8Q7sII+zbYeNrzJylqXu7iBuRl
         kaeWwf5zT6idIPQEqjawyHTwnhsyf3X4YZKbWgBj4jIGHCs3OVav6yQB/9LzY5KZBvoN
         e68L37x9JHwEIfL4TGuCQsqx2UppVdA7mVsU5pMUu7zYiZAqfE+TeyCFEMwr8y+DHRcD
         Coqw==
X-Gm-Message-State: AOJu0Yztv7wBQs46QLFrJNxggThb5GyhpttNIwKYRbRdYhHQU5O1Cf2U
	lcG0iDoLogOeoSBJ8WYXEXyBmc6TxisR0XggbIaLpnlrejS6EoyhHcq3KNp4iDANRVZSdigO/aQ
	3
X-Gm-Gg: ASbGncv+pMCXuBpdNYSTKeKSSsFA9nC3d51qcRfnRBkjo/7aYnliCGFqQIenLegbvqM
	0m9pwajfmqRxLmx7MOy1dHdy9Yte+ZyxqScjIPQqQ/RRpyRoMGMw0o72/nptf7lssqUxd/uQn5j
	X9SKeMhzGnckaWgdB0KzF0T7O/Uy0x8zljzUk71iaSU2S1MGIFTJgdK0FR2UAB5Y2dnAPVWDnBk
	tuCP09f5xQ6kobb50NPnTNkZ+6MiaiHCG2y5LIlUhYzA/W1TB1qWbbSHgujLPyoJP34C8zjn+YG
	k6lZQknNBQHWw6cm1sAsOXTsW7r7HtEU3oPKuyok
X-Google-Smtp-Source: AGHT+IE0j+KmAvI0GONGGBRb0yBcq84nelhQkWdG5WvM7FpdyUDmfmueemR8L5YM73nIkMZVBa983w==
X-Received: by 2002:a05:6602:368c:b0:855:c259:70e8 with SMTP id ca18e2360f4ac-85aff729c93mr545166439f.0.1741194219973;
        Wed, 05 Mar 2025 09:03:39 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85aed8bc2e3sm115220339f.10.2025.03.05.09.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 09:03:39 -0800 (PST)
Message-ID: <c5e6b923-69b1-47d8-b313-ba339eac9501@kernel.dk>
Date: Wed, 5 Mar 2025 10:03:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/rw: handle -EAGAIN retry at IO completion
 time
To: John Garry <john.g.garry@oracle.com>, io-uring@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20250109181940.552635-1-axboe@kernel.dk>
 <20250109181940.552635-3-axboe@kernel.dk>
 <2b43ccfa-644d-4a09-8f8f-39ad71810f41@oracle.com>
 <c64a86d1-36cd-46b1-82fa-4ac4a4cf9cd2@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c64a86d1-36cd-46b1-82fa-4ac4a4cf9cd2@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/25 9:57 AM, John Garry wrote:
> On 04/03/2025 18:10, John Garry wrote:
> 
> +
> 
>> On 09/01/2025 18:15, Jens Axboe wrote:
>>> Rather than try and have io_read/io_write turn REQ_F_REISSUE into
>>> -EAGAIN, catch the REQ_F_REISSUE when the request is otherwise
>>> considered as done. This is saner as we know this isn't happening
>>> during an actual submission, and it removes the need to randomly
>>> check REQ_F_REISSUE after read/write submission.
>>>
>>> If REQ_F_REISSUE is set, __io_submit_flush_completions() will skip over
>>> this request in terms of posting a CQE, and the regular request
>>> cleaning will ensure that it gets reissued via io-wq.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
> 
> Further info, I can easily recreate this on latest block/io_uring-6.14 on real NVMe HW:

Thanks, I'll take a look!

-- 
Jens Axboe

