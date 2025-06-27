Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041631411EB
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 20:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751057948; cv=none; b=TqhFIEdEhPaVpWFmHqlveZr8QCqN9Ittzqv+ABbZyJWiMYJpkqShcjOv+gjAjRQHBwCRFQhHCk4OdIyh/kTdPRHo9DcYLTyOwGfSwfOJ8mpTJAu1y7ZSoAc9doqaWADDAYY6PBdHR6niygXRWM6Gjj5B+o+5IohHw3h+IfqWKLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751057948; c=relaxed/simple;
	bh=U4P1hMnzfAprTJqUrLemXiXpH/XIICsX5XlY7N+GLLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RWMU5AMsi6nnnhPA/xDnMkAJd55qCOGZLc0BVPfS3QbthUCISeDTg2+So+fbk35afiWpj7N1ayLIeRaTVAvqu8i6paJ00sUiGi2gTaEN9nzB2GovykjJg/VAVZAuVvKuE8r4Ue0y5HbrTA5hHNNhXyUOMquQ12zUKbdOauruSQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kS0U23M/; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kS0U23M/"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bTSbG0Mp3zlmm8g;
	Fri, 27 Jun 2025 20:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751057944; x=1753649945; bh=nnsixN05TvhVCGz3MmYb1ym3
	MFWGSBEnC2eGew9p+tg=; b=kS0U23M/RGXKtFL8kk5upVcuDu4KT//kEbI5kXAB
	lrZe8nCeMtPyeK1QdpOijhYAo7od/559BFzMp9cF4LWpLotPeLx71Z9+zzvLRNup
	R3SIn7QKpWp6/1ovHPGIULJmf7EzyS8iLqHGxdK7MJLNvTrzR45nGPGxC8TjuiIZ
	WhF6t5XW1wW/Q7AwhdP85RNv5W4eY8lnUdMe1lAKlp95w6ZhFB6MR8aPJSWMQKBF
	p7DTqjYDgX4au8O0luzPo3OlO91VLlgsDUdQkljkWFCPXLFfo5v/wgNgEvtK33b8
	zsHBSI5oLMkQZO6RsvRZS4rO7/9zZslTQB8YDl+WlJH4RA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8_eNposnmXvR; Fri, 27 Jun 2025 20:59:04 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bTSb903XLzlgqTw;
	Fri, 27 Jun 2025 20:58:59 +0000 (UTC)
Message-ID: <37ae7c51-2216-4a5d-84d0-20c1f1fdf0da@acm.org>
Date: Fri, 27 Jun 2025 13:58:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: core: Make scsi_cmd_priv() accept const
 arguments
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
 <20250624210541.512910-3-bvanassche@acm.org>
 <1fe19ff4-a266-4b0d-a90c-c6e07fc83acc@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1fe19ff4-a266-4b0d-a90c-c6e07fc83acc@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/27/25 5:08 AM, John Garry wrote:
> On 24/06/2025 22:05, Bart Van Assche wrote:
>> Instead of requiring the caller to cast away constness, make
>> scsi_cmd_priv() accept const arguments.
> 
> Are there even instances where we are casting away const (for calling 
> this function)? I assume not, since there are no changes to get rid of 
> the casting away const.

I have a patch pending that would need to cast away constness without 
this patch. See also
https://lore.kernel.org/linux-scsi/20250403211937.2225615-1-bvanassche@acm.org/

Bart.

