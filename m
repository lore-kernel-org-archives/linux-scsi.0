Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4B11E534;
	Mon, 25 Mar 2024 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711392799; cv=none; b=LCazxIP/xdolaWI4RcFUDrfW3kie3/MuVdchdV1Nx1yqZGBY2Oge6z9vWlVccF6HbUNsiAJ+GkNMpkKdb5zhQ2RwnxvRW2UOU9jWbopi4P4eQS2aX2MCpg12C3QIMlWvjUaMfqpHaL0HwgaATMFFl1/HoR0Q3J9Uqn5D+SPjVN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711392799; c=relaxed/simple;
	bh=8HB8T+9QKi2BsmxvgtUg7ciBvTzwZx/p4zyHvH2zcwQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=oFqOxqzr1A0//DLjfGByX0xqaZnxZGbg2+a4eTV4wrApFELx1X+xwhnrKdfKga2Ub+photn0Mfj8Hic5i43HRtwtN3Cqd8REJ7tz4miiyM7wCDDhA83ZHv6tJou3azo/RW1ZJTyHXaSPnnldCkiD9OhPS1k2IdKQsa7HAaxIgKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QK5Jma2m; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QK5Jma2m"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V3MWx3rNrzlgVnN;
	Mon, 25 Mar 2024 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:subject:subject:from:from
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711392795; x=1713984796; bh=8HB8T+9QKi2BsmxvgtUg7ciB
	vTzwZx/p4zyHvH2zcwQ=; b=QK5Jma2mZGZFG0tWntSYAtsNFNzQTTKSGofdu3nN
	ASu72DGM2Mvuz/o8wDWrS3lkflhOmfqemdIhBxRIBMOt/pROSHJQPeQe0NJIWCCC
	j0wSPixsWb3uBI8CcBzCKEe8GVBTz5izmQne2MRhLMad8QV+k4Y2vBQhs5DtP5jC
	UrQ0zwtvEt1LfARPoLZCYuzPBh27vTfyGUieTm6ouPUxyvqJqizElTLuODjv4dWA
	INCewET+kzqXFcmxiZekooZezaOZWs+FxeLPcPaDsPH2intQO2ViNW7O7jkL3p5G
	CMkkBx/+kAgCW/qwZ6BwlUN2EWJO8J/65sA2IATb2pu+4g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O8IPN_-Z7MKH; Mon, 25 Mar 2024 18:53:15 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V3MWt3k88zlgTGW;
	Mon, 25 Mar 2024 18:53:14 +0000 (UTC)
Message-ID: <1159bc83-f252-49fe-a15a-e0d0eb18661f@acm.org>
Date: Mon, 25 Mar 2024 11:53:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 02/23] bsg: pass queue_limits to bsg_setup_queue
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net, MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-3-hch@lst.de>
Content-Language: en-US
In-Reply-To: <20240324235448.2039074-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 16:54, Christoph Hellwig wrote:
> This allows bsg_setup_queue to pass them to blk_mq_alloc_queue and thus
> set up the limits at queue allocation time.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
