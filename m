Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBDD2E62B9;
	Fri, 18 Jul 2025 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752856341; cv=none; b=K5X6NQjyISIJJu+jZsMNSHCE4MptdvM5Krorr2HJDkVGtyhQ+Mdm4r7DjhqC2vvwedzMEGt0noI9Wwj5Pft+XuKKAaqnZL/+Lv11i0hrL0ax0nJ1dfmfRfIU4wOF6PLvVKIBBOX6JI7F0PUnXxmKugB5BtFNpsvoIBKI9OTZyEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752856341; c=relaxed/simple;
	bh=L3lDMDXyd/6/F9dfMzCJxOqS8xiHs9Q04y/rowjgKog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MVoUydeoDwsBh74Y5eGEYV7hDNLdhWeXkli3ebsYNTAAcU1tHajPAS0cUc/DHjq4LyXkWLfk6Z6xeXZ+bZeCfjwcLl2W5EPeol+lcCH7MoiwEcsqaKsrsgFI+KsYS4Jt2hb4qW8H/xJJyDbH/ew+ITeQ3gmH7VaSHjlBn+S4eyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wMcQo1uc; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wMcQo1uc"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bkFgk55q7zm0ySG;
	Fri, 18 Jul 2025 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752856336; x=1755448337; bh=PO92qdt1Q6jYJiDKfKKIr6tS
	6eT1IljAZ52lfVvwCZk=; b=wMcQo1ucmjr1f+qgPiH2wH/iWkN+lFOmEp/4fwgs
	etC0+KTH0XoGURBUR1cvJ3w6OXUX2wfnYhtQekwhezhSXqve3fh5dibFrPxzskm4
	nM9f06X/kpgyW8zdFB2HAcNYxgYZAty8Id/OoWmVTYZquhSSaXtjrVpyh9hVq8lK
	85CSuhY7U0hEq6B/9s5SekPaKYaLhzuSdWiwWJ+jaRKI5C2j6Yp5g7CaGTNAs2n4
	C7xhVRqI5Tkd3i6/KmgTnxfzIyfRdKIsKQshoP4Ucqa0IyXuV+05/zg2c7NA9aiJ
	D9+yzMxleIxWwIAd4/ISUVRgrjJ7E7nmlMhkL84aqAi4KQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oIwaxjOPCRXb; Fri, 18 Jul 2025 16:32:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bkFgd5rVzzm0ySc;
	Fri, 18 Jul 2025 16:32:12 +0000 (UTC)
Message-ID: <aa4ac3ff-19c8-4fe4-b4b2-03013c3a06fc@acm.org>
Date: Fri, 18 Jul 2025 09:32:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 00/12] Improve write performance for zoned UFS devices
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <ad7b1c95-2b60-4ffc-930f-555105798f4d@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ad7b1c95-2b60-4ffc-930f-555105798f4d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/25 12:39 AM, Damien Le Moal wrote:
> On 7/18/25 05:57, Bart Van Assche wrote:
>> Changes compared to v20:
>>   - Converted a struct queue_limits member variable into a queue_limits feature
>>     flag.
>>   - Optimized performance of blk_mq_requeue_work().
>>   - Instead of splitting blk_zone_wplug_bio_work(), introduce a loop in that
>>     function.
>>   - Reworked patch "blk-zoned: Support pipelining of zoned writes".
>>   - Dropped the null_blk driver patch.
> 
> Why ? null_blk does not maintain submission order ?

It does, but modifying scsi_debug is sufficient to test this patch
series. Do you perhaps want me to restore the null_blk patch?

Thanks,

Bart.
