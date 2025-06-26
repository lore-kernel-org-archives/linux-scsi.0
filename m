Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B183411CBA;
	Thu, 26 Jun 2025 00:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896051; cv=none; b=aupInaohlTRTIvmYEZjl8DTnM8KGcXtQQBTw5BPSrZ4N1Q8bUhQ1qj2CGtotITFVymwUvrj3vHeJIb//GYTjlhbM1SouG2lAJQrlacjP/pKq5/+CsPAZw+oGBUOa4OG2H4zEFYqVsMfwaz54F/EnBuUTO1bCoheKRFZiKmzHtAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896051; c=relaxed/simple;
	bh=tZ4wRwRuH0O3JH2xMlilUiVAzRnwvyZ54IObfur1zhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OL4s6ksNkuzNxPIQ27QjtfgutmM6gE7Nm0rA/+CzdYn+98r9gQsjdWgP2s9yIQt3AbtCNvJJGS0+om7VQcyuU9Vg7cQejwYs2VZW/Fin1XJYTZDg/hEfBiGlXrmQRcH/GO+h7xBP6R9Dpnv+bIprPB5squCOuk+SESfUcBFup/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SgkuH7YN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SgkuH7YN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1ABC4CEEA;
	Thu, 26 Jun 2025 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750896051;
	bh=tZ4wRwRuH0O3JH2xMlilUiVAzRnwvyZ54IObfur1zhU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SgkuH7YNryEma3tLhMxS3YDiei/raSSBQzeH1fvLyMSDqU8zOKAjc9f7CwYBKNOKP
	 g6fhFbMAIUxitnD7jXAU8XmLW6N90G59dFRSZz9rIwdTnt+/4soU1mQDUBUyKcTdE5
	 2vDabNB8F7i8Qaz+WrPCS85rl9V4uAoH1SfHPH8uSRsl0qmRP19mU5oIYbE1Mrv9RP
	 UvBaGaF00aO8/5PO+BHsNYeC1d8pUPIFn4bItIhyFmi39TViiBxzHJga7sKxqjjPvd
	 yXD80YaaSk0oCFV5sIGiee2w0Cdnlf8ww7sI/jR7l5bLMNVwTSK/9SefBBITJG01/q
	 A9nMfu0AvQvDQ==
Message-ID: <aeeb5b64-e539-4f0b-b80e-5aaecde55550@kernel.org>
Date: Thu, 26 Jun 2025 09:00:49 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 02/12] block: Rework request allocation in
 blk_mq_submit_bio()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-3-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250616223312.1607638-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 07:33, Bart Van Assche wrote:
> Prepare for allocating a request from a specific hctx by making
> blk_mq_submit_bio() allocate a request later.
> 
> The performance impact of this patch on the hot path is small: if a
> request is cached, one percpu_ref_get(&q->q_usage_counter) call and one
> percpu_ref_put(&q->q_usage_counter) call are added to the hot path.

Numbers ?

The change is forcing a queue enter for all BIOs because you remove the cached
request optimization. So I am not sure it is the impact is that small if you
have a very fast storage device.


-- 
Damien Le Moal
Western Digital Research
