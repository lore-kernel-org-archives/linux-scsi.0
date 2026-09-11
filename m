Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82E1496D3E;
	Fri, 11 Sep 2026 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142123; cv=none; b=oeJKCRBhnT8EhzRAkAucHSpDgEISIxddcfcOT/4HaeZjFCaR3xatmnycg0xiJ6/IteQOrBNn0esmEBaPvv+9a6+T2cmS1rvNNnxKoSIGsAQgGG+LUaYic4XrPu9wcvQXKycupIq13dZLsDW1u4+iCTzeXgO7dr9F7p8fRIy5SqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142123; c=relaxed/simple;
	bh=9sXx51M/TtW+S87yMjchFSacR4MPrrgcdgwqy32hvJs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPzjVOFy+Z/vb5MRp1/UUAgm5k7tbjLoSSv5t1ektJLE9ks/l/Q1J+JOmyoJCD8FL3Z1paHBYmXnxSl5o6DxH6qS2L8CzBFWpLkhiF6ILfuzL/JLBm4jxxqgCr+hJFPUz0dgIx+7ilO0eS+qn+vx3aCrMPfATFWurtjmT8+dQCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2WxiAhUd; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2WxiAhUd"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hhJzF2jT4zlfwJB;
	Fri, 11 Sep 2026 15:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789142117; x=1791734118; bh=QV5ANDlPFQ5PxKskxq7QRrGD
	AJ63bUT1w577A3L/Jqs=; b=2WxiAhUdIKl+p+h7dKcSrJ9LNE9S73AkZmgbiW7s
	vhrzmtX+/kUqa72FQw3xHyJAZqypILnyjyzjEYh2kDEYxla5OkhXQFY/KNo38AYF
	8a3Gvzdyf8E53CF03WMXtMdY6dUmscKog7/sbSBM7ob4mqhtgJEt5qPpokMf66mN
	cBouOnyQoDy7IJNp2I1g9xBOHjHvpqXWFcnJU7d+V+X7W5gydjyKgR0PAqkKFDkO
	dLyGHFL7rwn7KZMhfQ4fjG7EucKcml+2I7+4h2m+ouvUkOptHyQSqxXaYzFHoRis
	RozFTp3VHQqrbLn0V5SZ731z0Pxz8s2MdBSUWeGCbj3SNA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0peY0ucBD--m; Fri, 11 Sep 2026 15:55:17 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:b591:e5fc:52e3:a430] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hhJz527wGzlfvqM;
	Fri, 11 Sep 2026 15:55:12 +0000 (UTC)
Message-ID: <eb86ffe1-db3d-4b52-b4a7-08c9524a0dae@acm.org>
Date: Fri, 11 Sep 2026 08:55:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-mq: cleanup terminal request when it could not be
 queued
To: John Garry <john.garry@linux.dev>, axboe@kernel.dk,
 James.Bottomley@HansenPartnership.com, mkp@kernel.org, hch@lst.de,
 tom.leiming@gmail.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260911075415.634921-1-john.garry@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260911075415.634921-1-john.garry@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 12:54 AM, John Garry wrote:
> Sashiko points out that the SCSI midlayer error handling misses some
> cleanup for when a request could not be queued and won't be requeued [0].
> Specifically, clearing the SCSI cmd flags member is missing. Normally that
> would be cleared in the non-error path in scsi_end_request() (which also
> calls __blk_mq_end_request()).
> 
> Callchain blk_mq_cleanup_rq() -> scsi_cleanup_rq() does all the necessary
> cleanup, so call that in blk_mq_dispatch_rq_list() for when there was an
> error in the dispatch and the rq will be ended.
> 
> Note that dm-rq code calls blk_mq_cleanup_rq() for a cloned rq (or SCSI rq)
> for when the clone could not be queued and will be retried, but that path
> does not use the sched code (and blk_mq_dispatch_rq_list()).
> 
> [0] https://lore.kernel.org/linux-scsi/20260729161243.C918D1F00A3A@smtp.kernel.org/
> 
> Suggesested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: John Garry <john.garry@linux.dev>
Does this patch need a Fixes: tag? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
