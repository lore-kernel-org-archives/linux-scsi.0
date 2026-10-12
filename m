Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FB048F823;
	Mon, 12 Oct 2026 14:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816982; cv=none; b=gLo7bL36PPm1WXyNV7/+VuIj0KzheF7L1r9gKFbUITNE3jKmTr7ZMl2l4GBq0UzpJa3EebC2R7/Zmc86PVuRYjrPGlm8wotAK46jygbglo7d4+f3YHBULPK3gx6qDaJQZW/5hdrGw24JQ97pf8ssuSW40Q5IZ/pPLCmODLdzN6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816982; c=relaxed/simple;
	bh=ishzPVyKu2qY2jUnErlAm9ahhxnqMtBg+Jpx3E7yB6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XOHaxzZFGX4Iszn39xkbvKELlUxtNVXTFJsKxlJP24hQNv40GWWQjqI2I0Fcd08UM6ze7Rg4xQvDmHMsDS0xZc0Y5jowQ5/eISMkyL6GOSI54q41XtVjxpJmNXX/cShHqWByNuqZ422/BnFG/GEDvfi+3YHSxKaruJSMrq2+wV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYaGUdBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYaGUdBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289F01F0089B;
	Mon, 12 Oct 2026 14:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791816981;
	bh=JD/vkOmtYdY7J+1RPSuKb6c3MeXy0Peui4nNMAplvFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DYaGUdBvHVmFHVerZCpGkORE0Zjihrp1xB/Pu5DSkX47PgfL6Wlpc7AllqIOP8/o/
	 n6M91RNoRU4mO648OkQfdSWmFtLmEP/Jf+vL/L7wBCB7BJMmLrWC2sagmOsIu2aO82
	 Jv7IwO/GN377cvgV9ZjdL/VPAO5Q8rvJvEPjYjK0HvYd3tB2I0XQQyuOiNgIORiDuS
	 a3DHxNK4hNYJqRCc36uxNlhUoDwVOO1Ef9P6kkRm4pAaQWQdpjrEEGhGwQOmjYH55P
	 X121EeizR9kL91owYrMsPwzSSzKKGfA0xVG5F2SC5wPAJkonPdY0foPwaaKqGFeRXd
	 ERpqI6mAVbMNA==
Message-ID: <46272028-d50a-40fa-806b-186f1f9575c2@kernel.org>
Date: Mon, 12 Oct 2026 16:56:18 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/9] block: add storage element management ioctls
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-5-dlemoal@kernel.org> <20261012143146.GB8609@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261012143146.GB8609@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/12 16:31, Christoph Hellwig wrote:
>> +static int blkdev_flush_and_truncate(struct block_device *bdev,
>> +				     blk_mode_t mode)
>> +{
>> +	int ret;
>> +
>> +	inode_lock(bdev->bd_mapping->host);
>> +	filemap_invalidate_lock(bdev->bd_mapping);
>> +	ret = blkdev_issue_flush(bdev->bd_disk->part0);
>> +	if (!ret)
>> +		ret = truncate_bdev_range(bdev, mode, 0,
>> +					  bdev_nr_bytes(bdev) - 1);
>> +	filemap_invalidate_unlock(bdev->bd_mapping);
>> +	inode_unlock(bdev->bd_mapping->host);
> 
> Sashiko is obviously confused here about partitions that aren't supported
> on zoned devices.  The conventional zones argument isn't entirely
> stupid, but also not a great one.  Maybe we should add a check to just
> reject the ioctls if conventional zones are present, as that would make
> a mess of the depop anyway?

Not sure sure it makes sense. 3 things can happen:
1) The conv zone goes offline on remove
2) The conv zone goes read-only on remove
3) The conv zone content is totally unknown on restore since that is a
destructive op.

So the "data loss" comment makes sense only in the case (2). All other cases
lose the data anyway. As we make it clear that the user is responsible for sync
& no io before issuing a remove ioctl, I am not sure if we really need to do
anything special here. And we cannot really do anything special since we do not
know which zones are going to be affected. So either we do nothing and let the
user deal with potentially cached data not physically accessible anymore (not
great), or like here invalidate everything.
>> +static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
>> +					blk_mode_t mode, void __user *argp)
> 
> The usual naming and type nit here again.  I'm going to stop that now.


-- 
Damien Le Moal
Western Digital Research
