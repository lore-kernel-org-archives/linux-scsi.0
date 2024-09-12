Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D1218EFF3;
	Thu, 12 Sep 2024 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153664; cv=none; b=bEfUzvVicO6KST0KfBDLe2cr1HnCz6DMK9DnWokqWR3Mt+jBLFv8zKXFmugOXfNard4vd7I9+U9Me/cHCk/2S3g7BPCBiVZahAoB0RmNyLSXmR5KSGvK5gtn2PxGHP8PZe1ZEdWdnCnk4LZ8B/Ym3B9sVIjbjAj/afywU3YZ97E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153664; c=relaxed/simple;
	bh=FiGsT7iRJbP7v9SqMgnOfhpz8TkQF0NUSpFtVT82w4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4XZ7jWFInfFXeyzmpXozbP7Yfvusj8z6f95Zw2L/xvoYWmtfdpD15z1d1GdTJx/bYCKrZpi21oV2SvAb66WUbN9FGFkg4kpLB1Pd7Ih2fQuNBC3og8A7XIlfhj8vueylLtrZGnKQUxI+xFxzYvjwv3GISUyQSm+QbQJmt2IwDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 338EB68AA6; Thu, 12 Sep 2024 17:07:37 +0200 (CEST)
Date: Thu, 12 Sep 2024 17:07:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, song@kernel.org,
	yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 1/4] block: Make bdev_can_atomic_write() robust
 against mis-aligned bdev size
Message-ID: <20240912150736.GA5534@lst.de>
References: <20240903150748.2179966-1-john.g.garry@oracle.com> <20240903150748.2179966-2-john.g.garry@oracle.com> <20240912131506.GA29641@lst.de> <0f2652ce-63e1-4399-8414-0bd150521e1b@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f2652ce-63e1-4399-8414-0bd150521e1b@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 12, 2024 at 03:58:00PM +0100, John Garry wrote:
> On 12/09/2024 14:15, Christoph Hellwig wrote:
>> On Tue, Sep 03, 2024 at 03:07:45PM +0000, John Garry wrote:
>>> For bdev file operations, a write will be truncated when trying to write
>>> past the end of the device. This could not be tolerated for an atomic
>>> write.
>>>
>>> Ensure that the size of the bdev matches max atomic write unit so that this
>>> truncation would never occur.
>>
>> But we'd still support atomic writes for all but the last sectors of
>> the device? 
>
> We should do be able to, but with this patch we cannot. However, a 
> misaligned partition would be very much unexpected.

Yes, misaligned partitions is very unexpected, but with large and
potentially unlimited atomic boundaries I would not expect the size
to always be aligned.  But then again at least in NVMe atomic writes
don't need to match the max size anyway, so I'm not entirely sure
what the problem actually is.

> I could also just reject any truncation on the atomic write in fops. Maybe 
> that is better.

It probably is.

