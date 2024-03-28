Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5EF137C3A;
	Thu, 28 Mar 2024 21:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711661333; cv=none; b=posy+GD+d7S9UUB7o1ZJoNmMi/Ifxhg/O9DaVvTPqa46WCFR5SHIWBGdAIdhYjCVZyI4Z1jYwa4fLVomTZyjO/7AReRlh96k4DGp4NCWQbXNJKVjYEkmQyTYRzd2T3CWe3aPoND0VkLNEy2SPoNTbzqhdZTl8GBPjRLuJogPlg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711661333; c=relaxed/simple;
	bh=XAu95XQjenYh/THudJHrOxPVhYWAANYorb5GW8FtKHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=APS6Y3qdIrUmFot/HfwqWUJhpnn5KE4WafNS2fCN8ml82QFwF32grJ+eHhVQ0XRMPhYCaeE2V3dvMoKnbGQZRxrYmt2Gg7qi1WlpYwKto7XReXPO3lYaJoX/tV7RQ94tU3XxZoEV2jeZk9DPsHU+RiOS5bsV+ax69SGkhP2dhPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xZDP9qYZ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xZDP9qYZ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5Gr24tZPzlgTGW;
	Thu, 28 Mar 2024 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711661327; x=1714253328; bh=FmXK1EB0uACV+GAD7WU+M1L+
	YJGjsqGi3oLvgjjCfNI=; b=xZDP9qYZFbYHUEUhfJRQ3Podey/KTRt7J/o8s9AK
	CXY1ZwKCZi057UaO+Y0hMNB1ZEGlvDdMtRfHiOAoHQBj4FCQQI0VCnfrR4vNUTkp
	TIl93ze6//3P8C3KqxjGv28jWQ5rW+92q7cJZqxBH23ssyIVdlVgPACo0cEgQh2l
	3eyweGUsTqOW+4ZYi0dxxPK8+ELhWnFL3V0E8mcL5O+nhz4oS4wTNoLTV6mWmB4/
	RD2SooLgtOEjG/pAZSMraF/UG+NPIMMztzbVHtFAAXCvqHPbgYAVkm9hmzH4rYu4
	99f8/C7AADEIPDDs3/XwDoH0yDmWoDtUQ3e+yIocXIcoMw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iH-ndkCFmm3u; Thu, 28 Mar 2024 21:28:47 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5Gqy1grgzlgTHp;
	Thu, 28 Mar 2024 21:28:45 +0000 (UTC)
Message-ID: <b09d7101-4124-4d77-b33a-977e2b555607@acm.org>
Date: Thu, 28 Mar 2024 14:28:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/30] block: Remove req_bio_endio()
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-4-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> Moving req_bio_endio() code into its only caller, blk_update_request(),
> allows reducing accesses to and tests of bio and request fields. Also,
> given that partial completions of zone append operations is not
> possible and that zone append operations cannot be merged, the update
> of the BIO sector using the request sector for these operations can be
> moved directly before the call to bio_endio().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

> -	if (unlikely(error && !blk_rq_is_passthrough(req) &&
> -		     !(req->rq_flags & RQF_QUIET)) &&
> -		     !test_bit(GD_DEAD, &req->q->disk->state)) {
> +	if (unlikely(error && !blk_rq_is_passthrough(req) && !quiet) &&
> +	    !test_bit(GD_DEAD, &req->q->disk->state)) {

A question that is independent of this patch series: is it a bug or is
it a feature that the GD_DEAD bit test is not marked as "unlikely"?

Thanks,

Bart.
