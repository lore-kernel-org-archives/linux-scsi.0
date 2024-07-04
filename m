Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F0C8BFF;
	Thu,  4 Jul 2024 01:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720055661; cv=none; b=Xf9KKolyy7x12XWIE3yh2mP209wxzVzLOz6P31evCpfPZKtaQrjLwG2gBYb9DcHwgh5a2ggEwN88uIM3aRk2rqmX7XiuvsLduzmcMBhJ0d1IA+U4HIrBMYVCjDiJA3vI51SONZFe4MfaKurcQwGiWMm4oqIJ1m11/8UeafIzP9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720055661; c=relaxed/simple;
	bh=IT/0qmpouGjAntmssXPWkmLwzlopcZSsDDAtvyNgKEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=q0LZkdv5EXOMSx+ISPJQvQzYe0GAc+ywC1Zs1LRPwX13/vQCsKLq4CTk+3Zjtmkz7xBpifzgO9e+42vyrV0YEl8qsFaPWbHuyTBsz2kEEFdQgVyzqtsO/Qf7BgIT9zpEujavU7l6kjodiuq1I2o55r6/thEgTTDaYaqLrbGbOv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bIUrsvSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bIUrsvSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2958C2BD10;
	Thu,  4 Jul 2024 01:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720055660;
	bh=IT/0qmpouGjAntmssXPWkmLwzlopcZSsDDAtvyNgKEI=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=bIUrsvScsVgHP5PZtTZzAEYE8G+B2DRTUd4NbTIpfBpU27Eh19za6EANkCFIEB/0Y
	 0P0rGf4AvotTsziZ+/8U6tULA+zNfel+9XCB/+YxUIeN8fLJvEkGsxWm4jjyCKLL1G
	 0MTwPILpAKPkDM1+1/a0qXzwVZXuxe2UmQahzN9H3pH8lM0NSIVWqP4bG/SNzyEHF0
	 S64XrqXy0uaYQ/thWgtKJcMu6fgXg5+kHGnpd6OPHPMV3xpQR76mZ1UQDU8+9cwZl9
	 pidfLOqu8r15doN+QqZJWo2M23Qz8ou4+LVCunG34K+zOkClBUOUY3qwaF809ut/3N
	 xanmDc018kSrw==
Message-ID: <b011fe29-3602-4857-ac30-f47ce84d43d5@kernel.org>
Date: Thu, 4 Jul 2024 10:14:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] block: Remove REQ_OP_ZONE_RESET_ALL emulation
To: =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "axboe@kernel.dk" <axboe@kernel.dk>,
 "ming.lei@redhat.com" <ming.lei@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "mpatocka@redhat.com" <mpatocka@redhat.com>, "mst@redhat.com"
 <mst@redhat.com>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "jasowang@redhat.com" <jasowang@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>
References: <20240703233932.545228-1-dlemoal@kernel.org>
 <20240703233932.545228-5-dlemoal@kernel.org>
 <c2022791ae3b082d9da3694aadb4b089a991570a.camel@mediatek.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <c2022791ae3b082d9da3694aadb4b089a991570a.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/4/24 09:07, Ed Tsai (蔡宗軒) wrote:
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 71b7622c523a..0c25df9758d0 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -834,7 +834,7 @@ void submit_bio_noacct(struct bio *bio)
>>  			goto not_supported;
>>  		break;
>>  	case REQ_OP_ZONE_RESET_ALL:
>> -		if (!bdev_is_zoned(bio->bi_bdev) ||
>> !blk_queue_zone_resetall(q))
>> +		if (!bdev_is_zoned(bio->bi_bdev))
>>  			goto not_supported;
>>  		break;
>>  	case REQ_OP_DRV_IN:
> 
> It does the same thing as other zone operations, putting these together
> will be more cleaner?

Indeed. Will do that in v2.

-- 
Damien Le Moal
Western Digital Research

