Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C04213C3CA;
	Thu,  4 Apr 2024 23:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712272715; cv=none; b=Wx1Ib4ZCAIykJiWOlljBxTWqS2O/KdHUpmQzXU3UxMPyP+dc7o4JPTpX0Xf/3o/LiDuExdnbRaFGfESEAGdskYOZ3OZYmLDAgutRP5z5TMAajP2pk0sqXOdm2ur0e6umgFMxVidCRO6ry5+JkqaVltwSf5Lx0Jn1921Dn4xv5Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712272715; c=relaxed/simple;
	bh=DXDFCwVy4/NBkqIwL6pbhRxV4Qhsh8G+zaqbv0EcJyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CuoInK7K7yL02kFks6gMcRDo+IOV83I0M0wp3CSd2YpTYQ03XNfw4n6atRHwSc091lgdsErWELu89n142kj+xOYAVfseX/rXhnEBRFaji6l1kAue80fxHRarvOshgXer1OZ35d0Bz6zhMJ7So0e7yvGlicPjLCZObj5Nm/VaoD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4/qaj6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4/qaj6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C35C433C7;
	Thu,  4 Apr 2024 23:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712272714;
	bh=DXDFCwVy4/NBkqIwL6pbhRxV4Qhsh8G+zaqbv0EcJyY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=K4/qaj6R1uigkUmlm5TVYTIBqmO2WVqWd3EZUAZlgzEYruuRw/RcKSCKjEdq+guPa
	 eTfsic9eH/cD7TrOmxMYD5zc/k20ux47Jr5LhIoADRlIQWFs+ne+3C+/VU6kO2N7hr
	 2ibHoS+IPbpRsxQRE4aONDQjhc0oobXFLL88lGXd1ST0ALg8Y5baSV853yEAzWeEmX
	 wjSkaeOCGOWC67O70IdaMeNKBOI9tk9hRcvHsT5SgZuX83qbsMe5GCjZlVthpmFra1
	 nG0b61SoF4FMrMtZ6q6bpeDzzLQIxcz9FP40uzrpbrNP8obeB7pPuf44FPjzl5mSYx
	 95g4Dgq1TAfyg==
Message-ID: <6bad5d07-01bf-466a-86bb-e082ed961049@kernel.org>
Date: Fri, 5 Apr 2024 08:18:32 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] block: Introduce zone write plugging
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-8-dlemoal@kernel.org>
 <c3bbe9ac-690c-43a7-bc75-3634af5cfe7a@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <c3bbe9ac-690c-43a7-bc75-3634af5cfe7a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/5/24 03:31, Bart Van Assche wrote:
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 88b541e8873f..2c6a317bef7c 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -828,6 +828,8 @@ static void blk_complete_request(struct request *req)
>>   		bio = next;
>>   	} while (bio);
>>   
>> +	blk_zone_write_complete_request(req);
> 
> Same comment here as above: the function name 
> blk_zone_write_complete_request() is misleading since that function is
> called for all request types and not only for zoned writes. Please
> rename blk_zone_write_complete_request() into
> blk_zone_complete_request().
> 
>> +	/*
>> +	 * If the plug has a cached request for this queue, try use it.
>> +	 */
> 
> try use it -> try to use it (I know this comes from upstream code).
> 
>> +	if (blk_queue_is_zoned(q) && blk_zone_write_plug_bio(bio, nr_segs))
>> +		goto queue_exit;
> 
> The order of words in the blk_zone_write_plug_bio() function name seems
> unusual to me. How about renaming that function into
> blk_zone_plug_write_bio()?

To be consistent with your other renaming ideas, what about "blk_zone_plug_bio()" ?


-- 
Damien Le Moal
Western Digital Research

