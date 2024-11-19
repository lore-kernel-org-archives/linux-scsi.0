Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0402E1547FF;
	Tue, 19 Nov 2024 21:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732050511; cv=none; b=MbXxoGQgFshhDsQJUC/AfPE5qg5sVBePKNhpTaJjsCyUJpLAFOI4bonP45sML4eff+wK7J1Cbz241ntP1/lQLPQen9tkoqwVvr0TF4kl6eNS/7GCc7fKnzXoS1a5bCWJk3bGPNMBo4kFZGjIEdvNYCGlQnA3MwHMHJIuKhe4m+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732050511; c=relaxed/simple;
	bh=Rc5fRs3AwKSJTkXgQyxxF4KlGsc7kDFLZ6BQ3VdGAfs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JpZkhZY+n6amLCk/BQNBYAjxR9uVjI/ObwInii+meJVeJhFVQhDkvqMLU75jx8GtBTNToypz40A2TP+I6oH8x2JdZSd0XMdmKioY3qSzllxV5U33iLU2sAdDRolOJZDWEhJnz+Xfu6bojYkTuzcI0JLNQyJknJNVRdXN5qtrY98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vGrCHwtf; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vGrCHwtf"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtHCd2qGHzlgTWG;
	Tue, 19 Nov 2024 21:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732050505; x=1734642506; bh=qOXeeLm3y1Y/y69jssICvB27
	Vm9e99uv6Apy39Cxuvg=; b=vGrCHwtfWrazn02s9G/hWuas9Y0dP0JQjiXvjaZm
	nDxHqKh5eLESXTAsbCEiPg9XkeT1pzUzfjiyS9jqQaLKi4KEolC6sphyHmkMK4T4
	LZpN32SA0mwPY6+DovtG7c+i1pOO1cr0FHM0BsFWIAFsGXHgm/LK5k+7b23PIMH5
	xuPOdEwT1Uf5/M6rAI8FNcJrRkBbd8fqixuiFADQTok0i6Y6k+CZWNnjUnG/KH4R
	3p5T03U3/gTT1AMDdi5fK3D3ke3E9fLO4e8bo3w/2rXIoTF7bKZnGwbXWU5MzrPT
	Iijr4DIBqSJBLR1ipPregm0hzcF280178rT6OiqSY1Shtg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id brAr0maTsptE; Tue, 19 Nov 2024 21:08:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtHCW4zvGzlgTWK;
	Tue, 19 Nov 2024 21:08:23 +0000 (UTC)
Message-ID: <efdffb11-8753-48e6-a883-219a39376bae@acm.org>
Date: Tue, 19 Nov 2024 13:08:22 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 07/26] block: Support block drivers that preserve the
 order of write requests
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Hannes Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-8-bvanassche@acm.org>
 <a11b4023-5647-419b-9de3-f48024872cc6@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a11b4023-5647-419b-9de3-f48024872cc6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 11:37 PM, Damien Le Moal wrote:
> On 11/19/24 09:27, Bart Van Assche wrote:
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index a1fd0ddce5cf..72be33d02d1f 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -397,6 +397,11 @@ struct queue_limits {
>>   
>>   	unsigned int		max_open_zones;
>>   	unsigned int		max_active_zones;
>> +	/*
>> +	 * Whether or not the block driver preserves the order of write
>> +	 * requests. Set by the block driver.
>> +	 */
>> +	bool			driver_preserves_write_order;
> 
> Why not make this a q->features flag ?

I assume that you meant q->limits.features? I will look into this.

Thanks,

Bart.

