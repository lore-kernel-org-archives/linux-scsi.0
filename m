Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476D321373;
	Thu, 28 Mar 2024 22:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711665632; cv=none; b=Ww0YImvZLOenpXAIub0yPOW642vRYoKh1MEqQrtMstgVzKdIXhYeacUTr6pLh1wSER9IfgiCcakYRg90h71m2U5CuMWinZlo/vs9uNc3351W5xGxq76w27GLzyXM6XoJOmxdeLhIKGTbkJdRNAUElser7k1+ONo9qyHW+ho7Wj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711665632; c=relaxed/simple;
	bh=L3X0Xnax9iVKs+XHjAefS7Akxvkh+AtFCIbY2t9uftA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dEmMIP5Pdotk9iOsKlEB6dghI3JX0kiAem2R2ebo55j27i6lvF+uskfdkyvn4XhXKv1p050bHXs2kW47Cw2ZTOJzKCs9Erfc/9gTNLYLW7qz1Y+ahFbWVot6iLkJsrAVHLmrKfEgD1L3EpPqMLnf50mi1nJJLGcMdc/VuNPge7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKL1pVNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKL1pVNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEC5C433C7;
	Thu, 28 Mar 2024 22:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711665630;
	bh=L3X0Xnax9iVKs+XHjAefS7Akxvkh+AtFCIbY2t9uftA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=CKL1pVNv0A3aoxvhFAwLxjSII9r1BAq1NXf2VJhqJgPS4bB/4SwZwsyp292zFMoRS
	 +VU3QnyxvzzfuyvhgL8Ys9gUU8A1idoqjJGNvt+ceyroEaJhuGOOJzX047JU0Wh53D
	 58glHIIfOhuc30qRTVc8aJBhJMQTeSLJ4gNV8/zxmaRlHVdSrMi+E9BQzrZ0ypgw1R
	 4r9/BBEu0SW/kd3TVl1jECIFiyYwpG5KFTazhN+EeXXP/p9VEI7CblsdKq5wqKvve+
	 J7bq+GQH+LTidg/pZwoKJvP70riymgYCBKbCXP4M7N1VFVEwAHLMYmCCulpq6I6i68
	 CS27Wwyt7jKmg==
Message-ID: <a8db1c86-945e-4155-8a57-0eb2d618adbd@kernel.org>
Date: Fri, 29 Mar 2024 07:40:27 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/30] block: Remember zone capacity when revalidating
 zones
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-8-dlemoal@kernel.org>
 <38575b90-7cd1-48f9-8c86-a77ef372900d@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <38575b90-7cd1-48f9-8c86-a77ef372900d@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 06:38, Bart Van Assche wrote:
> On 3/27/24 5:43 PM, Damien Le Moal wrote:
>> +		/*
>> +		 * Remember the capacity of the first sequential zone and check
>> +		 * if it is constant for all zones.
>> +		 */
>> +		if (!args->zone_capacity)
>> +			args->zone_capacity = zone->capacity;
>> +		if (zone->capacity != args->zone_capacity) {
>> +			pr_warn("%s: Invalid variable zone capacity\n",
>> +				disk->disk_name);
>> +			return -ENODEV;
>> +		}
> 
> SMR disks may have a smaller last zone. Does the above code handle such
> SMR disks correctly?

SMR drives known to have a smaller last zone have a smaller conventional zone,
not a sequential zone. But good point, I will handle that on the check for
conventional zones.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

