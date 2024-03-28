Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09407225A8;
	Thu, 28 Mar 2024 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668808; cv=none; b=oyOck4qVBmqcXCYDm0UCmyeGu0kXnqE+7rEp/TeQ/2QzL8LJNUWvZHQQaMnyMjbp/+ibawTCHZIZu5YUSmI1xddbNs0PbHxvMbt+cGvhMRUI0QHooHByxgMitV362N6f7ZpCvetAYLb+hsTU8uxL0YviKCq80aeA0Jy+3TJcrf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668808; c=relaxed/simple;
	bh=acNr/7O7ETr3TVm8FMiSAjIE6RNlrjgxYatCP/czSgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aSE3+6E7TUeBRNbw9XeHiuLS2La95TN+MTWDbl/b8zWgpNYLjWJ5Yko/k3hRSTAliFV/kb5+Wdw3iZmlryPqv/9EBV3pDOsLgxBZW3S4s58wtwJSDdBjBd/OLpvRNb5Ay+BCF4ORmSKdlXmSf8Fw0YYiQ7yVg6qAifELzboKq5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwdjxtMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwdjxtMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CC0C433C7;
	Thu, 28 Mar 2024 23:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711668807;
	bh=acNr/7O7ETr3TVm8FMiSAjIE6RNlrjgxYatCP/czSgY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ZwdjxtMyLSc1vFLmryHzC6HyLefkMtf0FbDRkSNmGWTy63yDMS+hsfBm30dAPUPFf
	 jjoWq1w+RHmU/8dWoAuz8zqgcyiXhAx4A4NGGUfcwmqKxhkNDiEcLtLRzxVZnApnDu
	 sIPBAUM27CCfiGlDt5xuxfsysRje32c1+E+XSXETdvhMQ4IEeA+hhDdwRr2TZfO7mb
	 ordLpdn1ldkZfHftj1KnqxeJSpUR7duoCZCtv82sTMqIglxWynNUoHfTdMl7QtyJW9
	 EJgKCbjWNG9beviXgKvp8SUGYpMus3FJ+7+QXcsQSmdzJWVxhHKR2v+QGpvmfgxhjS
	 yu3GTnE37ruRg==
Message-ID: <942f4fa7-217b-4551-8215-3b1acf97a7ba@kernel.org>
Date: Fri, 29 Mar 2024 08:33:24 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v3 00/30] Zone write plugging
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <171166712406.796545.15002324421306835511.b4-ty@kernel.dk>
 <67a6eeea-253f-4568-b73d-aa05173cdb41@kernel.org>
 <0b15c2ad-71c0-4cc6-b00b-293966525a97@kernel.dk>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <0b15c2ad-71c0-4cc6-b00b-293966525a97@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 08:27, Jens Axboe wrote:
> On 3/28/24 5:13 PM, Damien Le Moal wrote:
>> On 3/29/24 08:05, Jens Axboe wrote:
>>>
>>> On Thu, 28 Mar 2024 09:43:39 +0900, Damien Le Moal wrote:
>>>> The patch series introduces zone write plugging (ZWP) as the new
>>>> mechanism to control the ordering of writes to zoned block devices.
>>>> ZWP replaces zone write locking (ZWL) which is implemented only by
>>>> mq-deadline today. ZWP also allows emulating zone append operations
>>>> using regular writes for zoned devices that do not natively support this
>>>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>>>> driver and device mapper zone append emulation to use ZWP emulation.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [01/30] block: Do not force full zone append completion in req_bio_endio()
>>>         commit: 55251fbdf0146c252ceff146a1bb145546f3e034
>>>
>>> Best regards,
>>
>> Thanks Jens. Will this also be in your block/for-next branch ?
>> Otherwise, the series will have a conflict in patch 3.
> 
> It'll go into 6.9, and I'll rebase the for-6.10/block branch once -rc2
> is out. That should take care of the dependency.

OK. Thanks. I will wait for next week to send out v4 then.

-- 
Damien Le Moal
Western Digital Research

