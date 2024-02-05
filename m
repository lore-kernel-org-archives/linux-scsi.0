Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77521D26D;
	Mon,  5 Feb 2024 05:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707111464; cv=none; b=E+wvOMp5ItYNX+0YKaOCFstj0Zav9uf7oTAvR/oP7JHz7XBvH3XSpE97xgyF5g9j0N4N9cH8ywSHWIcIYB7bZvYB/+dcKoD5fUCChJgbClJoF+CkY/U5KpnYzY3BdDzJ9GNLCB+XFJ4556oLhjVOFxC7NtKghmWzi0ZakWztgUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707111464; c=relaxed/simple;
	bh=aaQTQaU7diwUF84p6SKcghKkD9/PWyB7eOH+4EUyy94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jAXgi7ycNUFmv9rz2vFcFXouUWSLdzph6hhpVDNwdPNm0XBXwrC59CQlq4vRBv0Iq3TPt9AZB5fEij08aHjSc5+aeL/ZxuAdqVsDQnMJttLZpbZvAZ387tbb0tknM7CnGnjEaWASeCR9abN3qihSFB8JEip40MRQZhJH2xzWTCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EvN1l/KX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EvN1l/KX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FD4C433F1;
	Mon,  5 Feb 2024 05:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707111463;
	bh=aaQTQaU7diwUF84p6SKcghKkD9/PWyB7eOH+4EUyy94=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EvN1l/KXB6tIoSMgoXCoJv4SEt6xQ5zW+bF6ER5LpvwE+aJ6gS+93p4t5IIrny10y
	 v7jBKbMnLGr+1j00zcwkuuMbGQZJSs/sXMv+SQJdmZEGbk8OJS+U/GuvkE/wj6DZMf
	 aPSjVOtB/t90rNb4FZAibKhKin6MwjgwNPrVmndTyps8jTukfbgYRzbJ+se1uxMd/q
	 6vtp7KK6sKFov3md3UPB4vWM6AYOwrptDtMG3Zzajdmqd2Pps7+oLXWCpHwILNqcfk
	 sT78dDdQDyA4kPYxhZ1BfjebhkIM7X6QKZx5kxPSA2/BoRlgfK1QhgAJXX607nrHVJ
	 RS/YeY8FrWl/w==
Message-ID: <6e99511d-14f6-4077-87de-47ff285bc26c@kernel.org>
Date: Mon, 5 Feb 2024 14:37:41 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org> <Zb8K4uSN3SNeqrPI@fedora>
 <a3f17ffb-872b-49cf-a1a7-553ca4a272c0@kernel.org> <ZcBFoqweG+okoTN6@fedora>
 <58fa0123-e884-4321-9b9b-8575cc7b4e1d@kernel.org>
 <20240205051159.GA17817@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240205051159.GA17817@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/5/24 14:11, Christoph Hellwig wrote:
> On Mon, Feb 05, 2024 at 11:41:04AM +0900, Damien Le Moal wrote:
>>> I think only queue re-configuration(blk_revalidate_zone) requires the
>>> queue usage counter. Otherwise, bdev open()/close() should work just
>>> fine.
>>
>> I want to check FS case though. No clear if mounting FS that supports zone
>> (btrfs) also uses bdev open ?
> 
> Every file system opens the block device.  But we don't just need the
> block device to be open, but we also need the block limits to not
> change, and the only way to do that is to hold a q_usage_counter
> reference.

OK. So I think that Hannes'idea to get/put the queue usage counter reference
based on a zone BIO plug becoming not empty (get ref) and becoming empty (put
ref) may be simpler then. And that would also work in the same way for blk-mq
and BIO based drivers.

-- 
Damien Le Moal
Western Digital Research

