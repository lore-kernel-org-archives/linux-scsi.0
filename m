Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92231B3957
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 15:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749743599; cv=none; b=Oc48xGZ3/fPTXvGDg2n9d+RynH5RcqQgU10qQ/EjK25w36NyNFgVC+wOA5IhDCF0yaoEXXL1Tc2yrbkpRWczMNIQqbOav4tlMwwWzyzMjqNW23O9QkgYjdHgl5BT/693IxU2CLaTKafo3+ggLPG3wqT7MZInrrzgfJRKow3rAnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749743599; c=relaxed/simple;
	bh=iY0OlImDAV3JximPlXr2G5359rOCrvkrfj6XY1aYxM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=q9GlZBZCRpHEpoZ5UgqQZoUKZDuOsIXXuvPNxEezutXcW5+CY2d9gyDit1iLNEP0gxxneyS2fAA4IRn9eCSuEK7ZIZi0c8FMw1DoYsuxqG48msHZg5fi1ZgUvuZuFF0ZLqiUojuYbOPhwPUHtGMFaZN6FZYKVU/8x2V24EMzQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1TgAPeuD; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1TgAPeuD"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bJ6WB6NMzzm0ysj;
	Thu, 12 Jun 2025 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749743589; x=1752335590; bh=IiH2LZVByUnV1LPL7JF9ziAT
	XzdWTD071lx3UVYQDBc=; b=1TgAPeuDQRNaQXg+qsxFi4ku2c8CMVbJMhesLizu
	4/PD0Nmb2hMkXoL6IwdsiW4wxnYHqgsv18KLeU75kIL1OOaDePOX40mO5SnbsLhH
	kSiPG2qmlOnbVc3ByJHkpgMSvXwVK6JhL+fOy70KBfC4KGfwSrasPjthgNmR0Ts4
	oauKFqrXrPi9aal+1iSbSwnmeIgLMBE9DHq3zSzFsx05MVEEVsVVT6aNDPy0Ihva
	5tJOJiA/RUGrWGixM/ifTAck7v13M3YGWOv2boOLKd4QDEbelXJhZi5V+pwd7xxr
	5OTNMbBpP/dd8APmDEHmgDtlqYpcBlhu9dn20n84DJXDNQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qwCDJpPTHol2; Thu, 12 Jun 2025 15:53:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bJ6W81kDPzm1Hc2;
	Thu, 12 Jun 2025 15:53:06 +0000 (UTC)
Message-ID: <9cabd627-b22b-4ef3-87b0-cb5a9a97aea8@acm.org>
Date: Thu, 12 Jun 2025 08:53:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: sd: Prevent logical_to_bytes() from
 returning overflowed values
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250612060211.1970933-1-dlemoal@kernel.org>
 <20250612060211.1970933-2-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250612060211.1970933-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 11:02 PM, Damien Le Moal wrote:
> Make sure that logical_to_bytes() does not return an overflowed value
> by changing its return type from unsigned int (32-bits) to size_t
> (64-bits).

size_t is only 64 bits on 64-bit systems. Shouldn't size_t be changed
into u64? See also https://en.wikipedia.org/wiki/64-bit_computing.

> -static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
> +static inline size_t logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
>   {
>   	return blocks * sdev->sector_size;
>   }

Since 'blocks' represents an LBA instead of a byte offset divided by
512, please consider changing "sector_t blocks" into
"u64 logical_blocks". Independent of this patch, "sector_size" probably
should be renamed into "logical_block_size" since the word "sector" is
only used in references to "physical sector" in the SBC specification.

Otherwise this patch looks good to me.

Thanks,

Bart.
