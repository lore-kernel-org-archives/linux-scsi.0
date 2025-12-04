Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877D12441B8;
	Thu,  4 Dec 2025 01:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764813603; cv=none; b=EPd0JbTcx0iAcjZ99P4/zEcHgE4bT6kj83bEE/t/pVcSNO/go1N/fN5p8+StICQ6yqsxUV1hFoGiLfKZZRMH0OAiihjOb623j5VWi/mAxgKT9r8AaeLh3KUsXcullBDJDkOYPPYzJNsyx00B34pJW774+hQWDcMKvBqSYh7dbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764813603; c=relaxed/simple;
	bh=7lJ7xxiXnWecvBg6vyBSfhOI1I39vkjaoCqiSidpYEk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhnTXrdYPo09Vpe2rlhpZ9QFdxHjn17woi7MPMeKdXIteLOjLNmjL2zt5Fhiqi7V471hf6rPuOzjCxBn7NnwH/zYymG04CGH8IbKOJ/r+/femUStIUGTJHUEW3yUrR79QrmcDe6n8NUx/n/EJlPXmsyV+GQG+eaPhX5jDFjKZwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CbUmkKGx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CbUmkKGx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dMHkx421dz1XM0p4;
	Thu,  4 Dec 2025 01:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764813592; x=1767405593; bh=mu04r3xjnF/XdaFm5+FXVPgH
	pid/5c5wU8D36yCl4gg=; b=CbUmkKGxTlfIFEzLN+0ThKnFwraaePrDpH9qTXb1
	UgbVI/Dop5+8NOLFePMoXavZDTiSjk+/iw6PW4BjjClnPu0+TffuO0WbC4lNegZs
	3a1JvTMPD+evkXvzT7R3dAQFIa40hdVcK7rLCaxo5jAg7zqvQOEjBX1ratTCyMvg
	Ccicfzx6Y4K9ERcFEMYyaVfhusYxNkr9F8L/89ffXdODbt6bRomAgOif5NAqZMzJ
	OiG1mf0shiRiCpeL9O7vW4fp2KL3vsRWyaEgdxh8Zqn4XIZQpDCS6/94ds1u7WLB
	UCHo6HNKhJ8cx6UsQQHO0i6NNK7f3KEX1/+z/MA837mn4A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AF_IPRMnUGHh; Thu,  4 Dec 2025 01:59:52 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dMHkq3QFcz1XM0nm;
	Thu,  4 Dec 2025 01:59:46 +0000 (UTC)
Message-ID: <79e77629-f243-4468-8571-58725af92d77@acm.org>
Date: Wed, 3 Dec 2025 15:59:44 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 1/2] scsi: sd: fix write_same16 and write_same10 for
 sector size > PAGE_SIZE
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org, kernel@pankajraghav.com,
 Swarna Prabhu <s.prabhu@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>
References: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 1:05 PM, sw.prabhu6@gmail.com wrote:
>   static void *sd_set_special_bvec(struct request *rq, unsigned int data_len)
>   {
>   	struct page *page;
> +	struct scsi_device *sdp = scsi_disk(rq->q->disk)->device;

Instead of using this cumbersome approach to obtain the SCSI device
pointer, I recommend to change the 'struct request *rq' argument into
'struct scsi_cmnd *cmd' and to obtain the SCSI device pointer as
follows:

	struct scsi_device *sdp = cmd->device;

Otherwise this patch looks good to me.

Thanks,

Bart.
