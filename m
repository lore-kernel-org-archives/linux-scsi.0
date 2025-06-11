Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF882F4301
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 23:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749683375; cv=none; b=IPmO/3xHJtRYDzsXYrXTac8aHfR1aob2ovZ7sQSxA9qo6D5NKTjNUaKPN3KY9M4L8jOtmAwv9JUAoAUk7HZT6XOzC/pD+fuL1bV9WLbY8fQZP/0EYelBDev/yD1OUXZutp6mPbySmyYc3lrRyu5k4SjoF9YJKYaWuwjYfhoJzsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749683375; c=relaxed/simple;
	bh=+mZf/PE/zwc6zUQWsJI9PGkMPBHoNjyTaMs700Efda0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uS6W/n19HigqlCOer4LuHDyowCN3qz7Nar6OGHSX4Mkfbxo7PEwBppH+NXj6sMJU849joxKpcZ2wMQDlzntBvtGekiiHN8mVMAlXIZOdqsXPcdSN9q+KYIFCMwqeteNdMfBsA0a1l8kR9TpbVozcve4LXD0vG8UoIw/VSy5oDgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8Oe6qoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8Oe6qoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B62AC4CEEF;
	Wed, 11 Jun 2025 23:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749683374;
	bh=+mZf/PE/zwc6zUQWsJI9PGkMPBHoNjyTaMs700Efda0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=f8Oe6qoaV1CecP4uhQoWHWnEX0FCqzvaEDrosl5/KNBlEL7SHJ94mTR7G3g6QIw8w
	 D8suY2j/Y5+e889cUpyjzE5hfA70YYY01xLC1q+X9YJHPSoaa5HoXMvX4+1dXvCX6c
	 XtMcGj6LwqjECiBu8r+qWQQ5p1Q4TGC/Xf5xKYe/8A6GLwyiAMH6ahgQrjVyvRZooq
	 5elSPQn9XifK0uYUWXihsi4fQjhyqseqf5nNFZXi6DlKxGNDavfAENM/UtCycHcU3J
	 TQCquQw/hBxlviiXjB+OUCMHXbt35WKwp0NpCKrFSWy4KhwBUWRfSM8JOM3Phf2aI1
	 4hW/kIWyuDVhQ==
Message-ID: <ad209d00-91c9-4d59-a47a-2ece8552bc01@kernel.org>
Date: Thu, 12 Jun 2025 08:09:33 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: Set a default optimal IO size if one is not
 defined
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250611122921.3960656-1-dlemoal@kernel.org>
 <f1877d65-6b7b-4d71-899d-d6b3d8bafbdc@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <f1877d65-6b7b-4d71-899d-d6b3d8bafbdc@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/25 00:35, Bart Van Assche wrote:
> On 6/11/25 5:29 AM, Damien Le Moal wrote:
>> +static void sd_set_io_opt(struct scsi_disk *sdkp, unsigned int dev_max,
>> +			  struct queue_limits *lim)
>> +{
>> +	struct scsi_device *sdp = sdkp->device;
>> +	struct Scsi_Host *shost = sdp->host;
>> +
>> +	lim->io_opt = shost->opt_sectors << SECTOR_SHIFT;
>> +	if (sd_validate_opt_xfer_size(sdkp, dev_max))
>> +		lim->io_opt = min_not_zero(lim->io_opt,
>> +				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
>> +	if (!lim->io_opt) {
>> +		lim->io_opt = ALIGN_DOWN(lim->max_sectors << SECTOR_SHIFT,
>> +					 sdkp->physical_block_size - 1);
>> +		sd_first_printk(KERN_INFO, sdkp,
>> +			"Using default optimal transfer size of %u bytes\n",
>> +			lim->io_opt);
>> +	}
>> +}
> 
> shost->opt_sectors and lim->max_sectors both have type unsigned int so
> when shifting these left there is a risk of overflow. As an example,
> from the scsi_debug driver:
> 
> 	.max_sectors =		-1U,

The code already was like that for opt_sectors and no-one complained.

> Shouldn't integer overflows be prevented instead of letting these
> happen?

Sure, can do that.


-- 
Damien Le Moal
Western Digital Research
