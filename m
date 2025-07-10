Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0AF469D;
	Thu, 10 Jul 2025 04:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122461; cv=none; b=Jp1Izwnat8+88bQxj1743FmBrUJfmZwbEkU44kji0JHyONmq40NP60XiqDeY1wCtdB8SNNr/kiPEIOnCGbw+Moo6lQlFUR2StkafuXsvSc+73N76WD4WPYH3oPvaIwKEw67lub6z8XQVK1Mkh9mFMJi58W5TF70weiGovQPjpNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122461; c=relaxed/simple;
	bh=Cx+y0OE7Ff4XmQclhf3sBHp4jqVfKh/ICGJncw25nYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPln1HkJbGB3SPI7wKf8mIsLbbrsoy24S7jK7pw39M9uwVpIjU5ZNCWYaroXnatpsQ3zV04YH6QCz0IUe/3SoNCWtRtbLM23/gTJdSI6fPQMM9FxhhlkY+n+VbSWUufD4iDnzzRwojfk/J/o+Nbo68D8OvP75I86WBMo0arqM0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D0OfoxoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D0OfoxoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A021C4CEE3;
	Thu, 10 Jul 2025 04:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752122461;
	bh=Cx+y0OE7Ff4XmQclhf3sBHp4jqVfKh/ICGJncw25nYs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D0OfoxoCl/HFDI6FO1r6DT3LHiMAJ10+pI552yAMUy3yc9kWk2R/jnEO9rQEb4Ly5
	 dC0zDqME51GINjKAdztSbsdSCZ1DHYxLmTJKARFX2KR1Q7IWPJFSrlzmEDef/zjlOH
	 +5JgeHmxi1z5ATInCYw22p8hMfysapjRxuUD3i6csujOtNFGkWXfIjDzO97N+xmlyx
	 W2sQBv/Vz50x++tdzfVT/QiNqeiyq8rxOALH9Nfmql3IW48xTk/KHLAYicMTe6fjKY
	 pdC4/8VlCyMfX1T/STijEO3MqaCFWS3DdpblRciFByGcP478LHAOquG1Z9dMDVMoAm
	 c+zw+C7QzyYKQ==
Message-ID: <2e0b2c9d-03e5-4bf0-8e3f-6c9921a1b2be@kernel.org>
Date: Thu, 10 Jul 2025 13:38:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 03/13] blk-zoned: Add an argument to
 blk_zone_plug_bio()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-4-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250708220710.3897958-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/25 7:07 AM, Bart Van Assche wrote:
> Software that submits zoned writes, e.g. a filesystem, may submit zoned
> writes from multiple CPUs as long as the zoned writes are serialized per
> zone. Submitting bios from different CPUs may cause bio reordering if
> e.g. different bios reach the storage device through different queues.
> Prepare for preserving the order of pipelined zoned writes per zone by
> adding the 'rq_cpu` argument to blk_zone_plug_bio(). This argument tells
> blk_zone_plug_bio() from which CPU a cached request has been allocated.
> The cached request will only be used if it matches the CPU from which
> zoned writes are being submitted for the zone associated with the bio.

This needs to be squashed in patch 7. Otherwise, this cannot be reviewed as we
have no idea what that new argument to blk_zone_plug_bio() will be used for.


-- 
Damien Le Moal
Western Digital Research
