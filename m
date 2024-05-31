Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9799C7BB19;
	Fri, 31 May 2024 05:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717134527; cv=none; b=qTXsnzmodbblm7FfvRMg/JNImMb4QjXC8Yc2GRHbtt+oJZ2/fiSK0aMB2aD6FqsuLreEt/9EswQuOan1A/O2q23NFZ6U8ZDbVaGhtQA6Ea2r05y7hP0zd5QQPB0C19zEzUsDnlBF1efDCZ4AitdfCILGm1rstJo3Y8m7k/9yFZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717134527; c=relaxed/simple;
	bh=eVrXEzwot4omFnfxTR5GE9RlbXUv0M+FbQxAZcDdUyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4Eyjr4f198zX9eFdQQMWVEQLffxwTNFk6QuDBZROan8Uc3evzGkDQ3QQPi/rDFLC67lhw7Rs7tawildsbkX3Umf3+fjk5sZEC1ZDXi1LEbRnTPl8GnI2g8frP7ypUOhv082NzmkcLQVZm8Q2bKfllvNy17UjHbwxUzZN4wVWqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0721C68BEB; Fri, 31 May 2024 07:48:33 +0200 (CEST)
Date: Fri, 31 May 2024 07:48:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Roger Pau Monn?? <roger.pau@citrix.com>,
	linux-um@lists.infradead.org, linux-block@vger.kernel.org,
	nbd@other.debian.org, ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 09/12] sd: convert to the atomic queue limits API
Message-ID: <20240531054832.GB17396@lst.de>
References: <20240529050507.1392041-1-hch@lst.de> <20240529050507.1392041-10-hch@lst.de> <1a1854bb-1f28-44d1-a4ac-30872bd6c3c8@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a1854bb-1f28-44d1-a4ac-30872bd6c3c8@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 30, 2024 at 10:16:33AM +0100, John Garry wrote:
>> -static void sd_config_write_same(struct scsi_disk *);
>> +static void sd_config_discard(struct scsi_disk *sdkp, struct queue_limits *lim,
>> +		unsigned int mode);
>
> Are there any reasons why we keep forward declarations like this? AFAICS, 
> this sd_config_discard forward declaration could be removed.

Mostly to avoid churn.  This is a series that needs to feed into the
block tree, so I don't want major churn in sd.c.  Maybe after the dust
has settled it would be nice to bring sd.c into a natural order.

>> -	blk_queue_max_write_zeroes_sectors(q, sdkp->max_ws_blocks *
>> -					 (logical_block_size >> 9));
>> +	lim->max_write_zeroes_sectors =
>> +		sdkp->max_ws_blocks * (logical_block_size >> 9);
>
> Would it be ok to use SECTOR_SHIFT here? A similar change is made in 
> sd_config_discard(), above

Sure.

>> +		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
>>   	}
>>      out:
>> @@ -3278,10 +3290,10 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
>>   }
>>     /**
>
> below is not a kernel doc comment

And that is on the one hand intentional to avoid documenting all the
obvious paramters in a local function, but on the other hand requires
removing the double *. Fixed.

>>   @@ -3683,28 +3696,33 @@ static int sd_revalidate_disk(struct gendisk 
>> *disk)
>>   	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
>
>
> is setting q->limits.max_dev_sectors directly proper?

No, and I've already fixed it in my local tree.

