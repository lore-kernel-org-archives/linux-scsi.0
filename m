Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02061804F;
	Tue, 26 Mar 2024 07:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711439259; cv=none; b=kfWY3uKxqd2BX/bIrA+/PYwVEEJb8VMfU+t9xzj0VbSpRw5I6tCSvA9oU/uF5F6jLVv6dWpHL8M99cRU8BxkVyecOZttAgq5akKDXu9wCatjSHYb/Rt2zsJAy4N2iP9qRGOD++Oqke9Bv2yHNNm0JeuhsPLyTaLlweZ7FausHQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711439259; c=relaxed/simple;
	bh=WWBYCZLtpYpZuPu06uLxtgv78AbkHil0H8Oflmjn2QY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H2FHtftPBfmmz9HdS7q2plWY1FUdKAmm1gxgfC3PWjgNOulN5fwPmFx/7Ks4mx3CiCPqFT0oxwi5YrYzThv4XHVy4jkYRi7QkuO7+CRHejZMina57HuYaJbbQuNqn7zzk3FGVqylNnsL7Yc//H/bJxKGR6Bz7f3seXremuydQyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OD5z2IHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OD5z2IHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35019C433C7;
	Tue, 26 Mar 2024 07:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711439258;
	bh=WWBYCZLtpYpZuPu06uLxtgv78AbkHil0H8Oflmjn2QY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OD5z2IHPLRDWl0nUQJKl/tHqHEvAvqWKJVvLX8NMhomeJxooAUTP1oyCzp8V9Ac4F
	 POmhdQXbRmtjJ1XemluD478/tZmNmpDUnqXggEC4TEXKvmKWDt5+WlSR/ZDrA7a/Xt
	 raT2KgiKmrMH+ZlrT5XangSCdLMdQ0p1+0t7sJbGaMJLiODcf0anlw8ZelLA3cPy73
	 x7qJjid5nPhxTApilehNiB4hQjr/vhdRIfEBK1zBikkBkKsCOmg+Qc3c4Wi3fmqWh7
	 EbBWgwmRoSM3l2j/ilkxThO5GVAsoJx7b9SDWsTZd9LUS4SsN4QsiXUD9ltwGyG+Uk
	 HiRhzgu18r5iw==
Message-ID: <9d7a6183-31da-476f-9288-e5908de75b43@kernel.org>
Date: Tue, 26 Mar 2024 16:47:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/28] block: Introduce blk_zone_update_request_bio()
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-4-dlemoal@kernel.org>
 <20a3af4a-3075-4abc-8378-d55ea84a5893@acm.org>
 <0d3d0d81-66e0-4c7c-82dd-024972946666@kernel.org>
 <20240326063705.GA7696@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240326063705.GA7696@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/24 15:37, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 08:23:19AM +0900, Damien Le Moal wrote:
>> REQ_OP_ZONE_APPEND + RQF_FLUSH_SEQ is not something supported, and this patch
>> series is not changing that. The reason is that the flush machinery is not
>> zone-append aware and will break if such request is issued for a device that
>> does not support fua. We probably should check for this, but that is not
>> something for this series to do and should be a separate fix.
> 
> Btw, I don't think we're even catching this right now.  Would be great
> to have a submission path check for it.

Yep, we are not checking this, but we should. Will send a separate patch for this.

-- 
Damien Le Moal
Western Digital Research

