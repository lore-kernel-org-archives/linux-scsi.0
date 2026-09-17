Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CEB4F4024
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663209; cv=none; b=MMIotKx7f821obhC8KQPArVpq/mKSO6tyC7dHV9xp+MLmpPWgw02yubwy0P0IxD8B/uBQDOGGik0wde4jXH+OVl1yo5QdRgD9R5JEU/PBCR6O7vFH489T3Ub7ky1cextoLNJ/0D8QESER1YRhzgdB+MHa5PNMxbcs+gbMQyf8NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663209; c=relaxed/simple;
	bh=5wyaU3NVhUz5A179cpTymf6bHfKcSrzaY02+kaiTUtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IcS8Dd986M3edInu3HpWMwD0LzfbpubzVBXt7WDwmtkfkLUUqx7mzAdk+vKoDIreJxsstk1nKMxZ5Vy1c7OJqDdFadQKlJBYPRRAKaQVE/JyxkuYt08+DVccUiVgE0rLlvg29pZ8+tIt6RWvnlH0XKQtMzjRC1bRYJFJxmeVvaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RIPPutY6; arc=none smtp.client-ip=91.218.175.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RIPPutY6"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5wyaU3NVhUz5A179cpTymf6bHfKcSrzaY02+kaiTUtU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789663205; v=1; x=1790268005;
 b=RIPPutY6gyr9BCACa2D8QvQY5uyvYdiXiZCcbx5efnNk9pUHK8Vcmo24ghlMVor3A+RhKQoU
 xFr18p6fvS54wq9QxIM5h4QkaQS7G/EZCNAj6BAvQ5ruZprFy/2Fw+lUyVk5KtKex2zeEi4/9DN
 l0gEn8K9zvr4+HoExbNMUUrw=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id d30b162cbe0b806e;
	Thu, 17 Sep 2026 16:40:05 +0000
X-Mizu-Trace-ID: d30b162cbe0b806e
X-Migadu-Flow: FLOW_OUT
Message-ID: <77a96280-f7ee-46ed-bf9e-c2726bb75c57@linux.dev>
Date: Thu, 17 Sep 2026 17:40:03 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev> <aqu5Q_6EvfY7iRmk@ryzen>
 <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev> <aqvCeq9IsbjSJIEx@ryzen>
 <35ad0b9c-06bb-4ccd-8e58-fde4d859b85e@linux.dev>
 <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <3709D24B-4D27-44CC-92C5-59DC66309931@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/26 17:10, Niklas Cassel wrote:
>>> Right now, I don't see why WRITE ATOMIC should not be allowed on a ZBC
>>> drive.
>>>
>>>
>> So what happens when the write pointer is not aligned with Atomic alignment? Are atomic writes just not permitted in that scenario?
> 
> You are the expert when it comes to atomic writes.
> 
> But I would imagine that a device that implements both WRITE ATOMIC and ZBC
> would set the atomic alignment to the physical block size.

Sure, that sounds like a sane implementation. But there is nothing in 
the SCSI spec which mandates this (as far as I remember).

Maybe I am just being pedantic here in expecting the SCSI specs to be 
specific about interoperability of these two features.

> 
> That way the write pointer in sequential write required zones would always be aligned to both.
> 
> I/Os too larger than MAXIMUM ATOMIC TRANSFER LENGTH could be invalid for WRITE ATOMIC, but could be valid for regular writes.
> 
> Anyway, I will probably just drop this patch when I respin, since Damien did not fancy it.
> 
> I will keep the fix that ensures that we mark the blocks written by WRITE ATOMIC are marked as mapped:
> https://lore.kernel.org/linux-scsi/12d01f4b-4d9f-4079-908d- 
> ede50f7a28b4@kernel.org/

ok, I'll check it.

Thanks!

