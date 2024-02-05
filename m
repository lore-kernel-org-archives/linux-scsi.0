Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7097E48CD1;
	Mon,  5 Feb 2024 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707176530; cv=none; b=Jo3sA96ZiUpqzGNsweXeNwiVFUBUKUxToLA/cuQz/S/+OIFMKHsA5ZsNfWsSxvKlARQFZWDc5+Twtt2QWAxlTMU/zMm6BmPvvusMitP/kL09XTLz1DiOB5zkNePsvuYeZC44wXyjTXn7aDWra9ezlRGaeN85km8UxddOtHaTkP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707176530; c=relaxed/simple;
	bh=eJCqmMQe44w1+a59VfdTY2VeKJVUxrMJNSwvOZcIw8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sNWlksifg7CyL0qnVhDqsxGP2Hhx2pVTHoeMO3ZWiIMFRrVGaFBvX6eE6WgTQGLUHPQu+AHCjPWWBMCljfRW+mWcT9flVKMVgUwQ+ACQdX/QicCStFqRs9MNhiz829QDNRap0YG5XIzK2jvtCoLT+/WchlrYBegdJ5WD/Jz90+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h5/mt6RM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h5/mt6RM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C26C433F1;
	Mon,  5 Feb 2024 23:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707176530;
	bh=eJCqmMQe44w1+a59VfdTY2VeKJVUxrMJNSwvOZcIw8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h5/mt6RM3fsosC/Ji6ghSwydcA7dcHuz0lp9pXuWnttr+FVLm8sO59x5R1EOhjWe5
	 b8LKmhTL5zj1hTVslzi5QAvfaFoIqq6+mqG2jHSCWvORzPQKLrdfNbDoANXau8HB1j
	 DuiuOCFexLb/7drOf0sQg8kCMIYOZHvcc2Z4/8AhTZogzeUj5GLH1NP94/S3VXEBjW
	 Ld+x18c2f5nGRwzoCj0rec+BpIU62YwYKlPGBVUUTx+6FQZvdszA1JmCa7Gb1LPCDG
	 wuOx4kaRAJPbMf79P0jOOHpvV+AdC0oeYBo0+geSVDGHoxNPElB+iE7DUvaxE6RcOi
	 hByVpQyVNMoAw==
Message-ID: <ee72eeb6-f929-4879-906a-a628faa1c374@kernel.org>
Date: Tue, 6 Feb 2024 08:42:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <7c98aae0-46d1-473d-8d60-8252a96c414a@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <7c98aae0-46d1-473d-8d60-8252a96c414a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 02:21, Bart Van Assche wrote:
> On 2/1/24 23:30, Damien Le Moal wrote:
>> The patch series introduces zone write plugging (ZWP) as the new
>> mechanism to control the ordering of writes to zoned block devices.
>> ZWP replaces zone write locking (ZWL) which is implemented only by
>> mq-deadline today. ZWP also allows emulating zone append operations
>> using regular writes for zoned devices that do not natively support this
>> operation (e.g. SMR HDDs). This patch series removes the scsi disk
>> driver and device mapper zone append emulation to use ZWP emulation.
> 
> How are SCSI unit attention conditions handled?

???? How does that have anything to do with this series ?
Whatever SCSI sd is doing with unit attention conditions remains the same. I did
not touch that.

-- 
Damien Le Moal
Western Digital Research

