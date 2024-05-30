Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AD84D8BF;
	Thu, 30 May 2024 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099763; cv=none; b=Hhl+DGjYKyO9xXR85yFUQ3Aq4qSYHPZGgXb7uOYVnD4TfQJZvThdJjbnYqe8lbmVP2ymVqOUqn6W7a5dxDq4mEXZXaFMKirbt33fKcJ1V4E5mIxlP3f5K+TVsdorGN8ZG+qNCGapK1L9mL2j/Y/iIsCM68b+3BKG6fLm2hUNGKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099763; c=relaxed/simple;
	bh=7tR/h9bUU3ufTl+LbkOMaqMvZgQ0PvIO8Z8PkBE6qrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6U2SC4C5C8pImxfoKC7lyk0mTcgY1GC/e8Lc8lM4c1l9SgqfhIaFKHfeMVnt20Kcqj6W7siQV0zltdxWVHNnhic7Y1WzfkEiHIkuAyaQoLex+JQhfCMHoIkv+Uf5LHEsJ29aLXT1OqoQpt1ECypW1UW/OdxvU1fgWQBYFD0UiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nQibsLkJ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nQibsLkJ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vqy5F1Q97zlgMVW;
	Thu, 30 May 2024 20:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717099757; x=1719691758; bh=72TYEp9qG+JFxDJOhc8vL98i
	94kXdGccHRpnAQFkti8=; b=nQibsLkJj+e718qU89zq/w3b+Xj7bZcJX1t4S5Ib
	6Y2TqQaSrn/m9KkYDg8nG47BrzEZi5y6e/fkqJH0jKclSqaBOiW4YJTNeGb1Sp0q
	ZkAl4cqRGtJ9BhVg3y0q9c8DIYnTeW34UN3c12ZZq8UlXTpwStkplQ+/oORhUCu1
	CTLLln6gMBNxvppMEcu/G6wtlrVMp25vVLoBMfI4CsCDWdrrCAO59XEhKrT6cbhE
	Cef818A+XIhDPVWZrIoeq54kVP/vsyNbked97rhR5i8C7RP7qmtB77Ne3Id9P9eD
	p014OI2YgEP5j/ozLgrC3mtdb8oHumiTveZFFAH+BafSnw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AYBsZ1kn-wfP; Thu, 30 May 2024 20:09:17 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vqy5720mhzlgMVV;
	Thu, 30 May 2024 20:09:14 +0000 (UTC)
Message-ID: <12bdbf52-d97c-4c47-8e8b-bfc10bbdc985@acm.org>
Date: Thu, 30 May 2024 13:09:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] block: add special APIs for run-time disabling of
 discard and friends
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-13-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> A few drivers optimistically try to support discard, write zeroes and
> secure erase and disable the features from the I/O completion handler
> if the hardware can't support them.  This disable can't be done using
> the atomic queue limits API because the I/O completion handlers can't
> take sleeping locks or freezer the queue.  Keep the existing clearing
> of the relevant field to zero, but replace the old blk_queue_max_*
> APIs with new disable APIs that force the value to 0.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

