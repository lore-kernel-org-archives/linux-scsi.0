Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA33BBF1
	for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 23:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668470; cv=none; b=nM/fdLJmV+Ooovsk+N0eCOExdydmB52OKi1vXDyLi4o6mWWW4YJ2Kxu6Z+tx+QAk/1Rmp4gSgP9LvszDvV51VwcUrmrSgoU0RenEx5SH757sCQhVVFAiccsRvR591CmFn4mSE36e20sz9qo65it7w4rU/Dw2DhGWKUed7t/+34g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668470; c=relaxed/simple;
	bh=ru98vq4enDKJaA6AbOY6HePE6BW/e39AtqUFr1SA1eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XtKrCJ54DoYhesLC8Fqf0iDcBSnqhbbtUOp92kSYjcX8bPO7g0gVdOA/KNcVWbVg/HBbsrKotNumBVUdJK3ZH/Xtkmi6HjxTC6iyyN00dt2+DqvC/iLnf98GtO9LBqRemUQSFMTJU+jLl6mFQXfHciqs75jx+gjIgrmuKL/EZU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Mo25R+rg; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Mo25R+rg"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dde367a10aso2543315ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Mar 2024 16:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668468; x=1712273268; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bCjm33wW7K1Ph4Bsfelc544yZvvykuRqTR/BQI/H9BQ=;
        b=Mo25R+rg+GNRHfao0KXvXBix4KVd+fnffT3qc+nLm32yORMaUacMYSmxcAJQO4vivu
         7h5kfr9odkQ0y4ZtZHBV0FobAQiVMcLl2KHg/d7H4HHgUu6t9d4SVoNl8SCHhiL1GwOm
         EJv7vb2rada3JFznl/eUgB2Qy9bf6Kn1uaVEY13ZmBMf8ZYQOzlLVlFpYz7oFdM3itSh
         eUtZTbTgOrgJnMGh7q3NNYGW6LJQoHazMAEFPXRYSJNlNwdHTGrAooDv2QThYSw+pR8W
         sFiB2hEusXsM6W3ngOfttkpcIaib25N8H1yvRZtPUrv469d/D2tPgYV6i1o7z/z/+cG5
         dw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668468; x=1712273268;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bCjm33wW7K1Ph4Bsfelc544yZvvykuRqTR/BQI/H9BQ=;
        b=s9s9LJn0om9LuJQMMViE+cXx/4pgpvfsoCkh2J8QPYj/k6aEIomSyNgFJPmpGXSqVF
         nBxOYCWtOOs8Pf2zCFC2uEOHnGuKc72EOoitsA/D/8upTsXVQvMnDYchK422pMe033W0
         yzOLpNKbzKD+HhK5LHUKw5rSIi8MqKpIr4ucRYiqXOTH0/YhItGYlol+9O4zZnig9eDV
         NQ5zdw+4Yn2dQhyKdAFoAYog0dQLV32DLp5bu9CUHM+hPTx9MpmONPxSOBaMgrvYq9W0
         GTBtJpoCYmP1taXdJ5wGXmCTxE8Q9aCyQf7UMDTr+ErjO1HIqJHn43i+M6ixH4CPORv/
         ranA==
X-Forwarded-Encrypted: i=1; AJvYcCX3RBRLxriW1jjwHlOdHFWx4kmMStOUYy2TwK+v0wj9yAIpH9v+G6W7TNQ6s7CtYchG0WuvzqxthFb7g3w8m5f5gj5QwLhTmWqHVQ==
X-Gm-Message-State: AOJu0Yx9IzoH7v2zTc7eRyxhVRuJ+4azMSMg7+8PZyILM/9eu9jsx9MA
	hhJb19ZWAcEHig8ldEV9WkBS0vNAvXBWGE4ikIb93IHp6FMs5fKqIWewwcjEylg=
X-Google-Smtp-Source: AGHT+IEzRSgPscwrQROpiBW893aXOX7Rqe6qefWWB6pwH5sKBp8T5k7GdQKDIPe0gtsPnzS2djJ3tQ==
X-Received: by 2002:a17:902:b205:b0:1df:fbc3:d130 with SMTP id t5-20020a170902b20500b001dffbc3d130mr951768plr.1.1711668467993;
        Thu, 28 Mar 2024 16:27:47 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id x21-20020a170902ea9500b001dcf91da5c8sm2198892plb.95.2024.03.28.16.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 16:27:47 -0700 (PDT)
Message-ID: <0b15c2ad-71c0-4cc6-b00b-293966525a97@kernel.dk>
Date: Thu, 28 Mar 2024 17:27:46 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v3 00/30] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <171166712406.796545.15002324421306835511.b4-ty@kernel.dk>
 <67a6eeea-253f-4568-b73d-aa05173cdb41@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67a6eeea-253f-4568-b73d-aa05173cdb41@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 5:13 PM, Damien Le Moal wrote:
> On 3/29/24 08:05, Jens Axboe wrote:
>>
>> On Thu, 28 Mar 2024 09:43:39 +0900, Damien Le Moal wrote:
>>> The patch series introduces zone write plugging (ZWP) as the new
>>> mechanism to control the ordering of writes to zoned block devices.
>>> ZWP replaces zone write locking (ZWL) which is implemented only by
>>> mq-deadline today. ZWP also allows emulating zone append operations
>>> using regular writes for zoned devices that do not natively support this
>>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>>> driver and device mapper zone append emulation to use ZWP emulation.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [01/30] block: Do not force full zone append completion in req_bio_endio()
>>         commit: 55251fbdf0146c252ceff146a1bb145546f3e034
>>
>> Best regards,
> 
> Thanks Jens. Will this also be in your block/for-next branch ?
> Otherwise, the series will have a conflict in patch 3.

It'll go into 6.9, and I'll rebase the for-6.10/block branch once -rc2
is out. That should take care of the dependency.

-- 
Jens Axboe

