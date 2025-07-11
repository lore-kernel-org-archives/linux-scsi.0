Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739C31EFFBB;
	Fri, 11 Jul 2025 21:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752269201; cv=none; b=O9g9hXf9W5x56TMM4uGbyd3mnBXrTkJOL1+yi/hzcsN3G4MNYv31fLV2R2+aJ3/VlvV1S/HbGwiSZC/YvmC2s/HqFrKCjVef83F01HV5G3Z/XAXoDJ4wl2qWWsDKceenoYDfmqvGpmH5NPYAd9YCFNfbgK4Q/3veVRvqcTiVQWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752269201; c=relaxed/simple;
	bh=grxT6fnKRcLbjein3FVgJ/4e2IECYkuOPOKVylo6YII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pBVchxOFp4JHZfwOqBZ8wOraadNtzxWe2rQWG/q1aHsXTPk1MRcEngDY19LzgGtsrmkFdtI55/Hvr+ybG46282Jb84mlJI6xrXu9lyVCJJk15U99EHlIy207pezqXSH/6j20Kb1Y8XERFzwt4GNrlq3Gh7P0/JJzNj7x9XI91P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iBjXDASN; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iBjXDASN"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bf4XS4PT9zlgqW3;
	Fri, 11 Jul 2025 21:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752269190; x=1754861191; bh=FflfgiPnxV2oDEPh2A44+YMp
	EIRdMt54w1rr2YeydWU=; b=iBjXDASNZ1MxA0EPgnHUi5lFQKbuRqm7RDYzy4Lw
	pMU16FjxElhFYr1KeNV6jJoxnHLJzEXQDFyPqA39O4Vr9A5y1fvmO2I3w/EVLPcv
	CKyBA4MWFFt0MxlJSK0wPEaznZUv/G/but1pnokOZ/ShkbdeLZjUvgMekT2aVsma
	ocR/KpnfaoXmalbODxOet6IVPxzpSLIDFY98Tkl11dzV+YdowWvzenscVcIHL4/w
	CcZ2EjrslMn/ja3PxZ1hFtY7rCf/fHoPKZ8gFZbsp1rkpc/Ure8oasP23GmtYZlb
	ZdvM1WvZgbA9PP7LTJGpHTax4CkhH+apYyr8fT5pIAZFqA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WpZ5IrjF8CIe; Fri, 11 Jul 2025 21:26:30 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bf4XL00ZjzlgqTw;
	Fri, 11 Jul 2025 21:26:25 +0000 (UTC)
Message-ID: <cdea1f7f-768c-438b-afc7-32fcc5b4491c@acm.org>
Date: Fri, 11 Jul 2025 14:26:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 01/13] block: Support block drivers that preserve the
 order of write requests
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 Nitesh Shetty <nj.shetty@samsung.com>, Ming Lei <ming.lei@redhat.com>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-2-bvanassche@acm.org>
 <12ad2ed3-53b7-489a-9e91-ee6b1099f535@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <12ad2ed3-53b7-489a-9e91-ee6b1099f535@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/25 9:28 PM, Damien Le Moal wrote:
> See blk_stack_limits() and the section:
> 
> /*
>   * Some feaures need to be supported both by the stacking driver and all
>   * underlying devices.  The stacking driver sets these flags before
>   * stacking the limits, and this will clear the flags if any of the
>   * underlying devices does not support it.
>   */
> if (!(b->features & BLK_FEAT_NOWAIT))
> 	t->features &= ~BLK_FEAT_NOWAIT;
> if (!(b->features & BLK_FEAT_POLL))
> 	t->features &= ~BLK_FEAT_POLL;
> 
> And make driver_preserves_write_order a feature instead of treating it
> specially. Also, the name "driver_preserves_write_order" is not great. The
> driver may be preserving write order, but the hardware not (e.g. libata and AHCI).

How about adding this in include/linux/blkdev.h?

/*
  * The request order is preserved per hardware queue by the block 
driver and
  * the block device.
  */
#define BLK_FEAT_ORDERED_HWQ		((__force blk_features_t)(1u << 14))

Thanks,

Bart.
