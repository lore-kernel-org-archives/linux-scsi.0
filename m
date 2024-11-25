Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503982500C8;
	Mon, 25 Nov 2024 03:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732507161; cv=none; b=SArIcX9Gw/m7sEtomZ62oKYJwDXjtluHFcyWSfGC2SBBQ0voVc6JF0PmMxXPakPT+oa/ohDFVs1kfVRMd4JCOoLo3ru0OcHSOjc7hneUd7LVFFO6s7bgxrVLSWv840EQo5xPW07y4KLn4ll0kVnumZ4587ENbPIlvWnKUihQxyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732507161; c=relaxed/simple;
	bh=UF56BhxwCIoOMw+YQED4SzWrVat0LCWYQfjquaCUaak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKHWdaOriXefkiWahT8XCSmtqm4UMu9Qw1WX/ivWhqgsvyLtMVWR29obt12AN284e/t2NwCI/k9dfG/vhvx9feveiEa2nIfyoXtDbd9hkOq8HuyZw2h6m47rxDBnfJeKPMVB0A0J6jd2908OxCTlalReTJxNddg0sT9+HmmtuPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ir2ZUeHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ir2ZUeHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEB0C4CECE;
	Mon, 25 Nov 2024 03:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732507159;
	bh=UF56BhxwCIoOMw+YQED4SzWrVat0LCWYQfjquaCUaak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ir2ZUeHfhyiHYjJ6RQtVw6RFs/lScppvLllRFcndtuTyjNvI3Gl6A/JGbHnCbZPPg
	 eN3hXo/P77pRH56NleWMEaaDj8/dhUJuPbtCmi+GO8rES9/bCsmL3SIcqKi0W/WTy+
	 632HY80VuDG+7NXwvLSYuDCE4YE7NKi6efvvABV5G5UaoyuLf0M8sOrXj480KaxpRr
	 /6SX9Cp6FiTHEeiGMN8BStmy+9O/6R5NqmiXyMfpTixg+Yr8K2ZC3PunEwWc85DoMq
	 7/pCu24xVNzkDCHd03CXmV1EoYh2ioN3/COjTiXjxd6ydpwN4GaI0Qz8eDXEeU9uf0
	 7s1MZSaLJnrrQ==
Message-ID: <6a8c5376-4464-4069-b936-a733c03ce805@kernel.org>
Date: Mon, 25 Nov 2024 12:59:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS devices
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
 <de43ae13-240a-4653-b8ac-f36c433d9ffb@acm.org>
 <d594be95-2cbf-4f9c-8508-d7adcedb148b@kernel.org>
 <9f26b8a8-f6b5-4329-a899-a2cd1bc51851@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <9f26b8a8-f6b5-4329-a899-a2cd1bc51851@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/22/24 3:00 AM, Bart Van Assche wrote:
> On 11/20/24 7:20 PM, Damien Le Moal wrote:
>> I am only trying to see if there is not a simpler approach than what you did.
>> The less changes, the better, right ?
> 
> Hi Damien,
> 
> I agree with you that we should select the simplest approach that yields
> the desired performance.
> 
> Regarding the proposed approach, forcing unplugging a zone write plug
> from the driver once a command is passed to the driver and the driver
> did not reject it, is this approach compatible with SCSI devices that
> may report a unit attention? If two zoned writes for the same zone are
> submitted in order to a SCSI device and the SCSI device responds with a
> unit attention condition to the first write then the second write will
> fail with an "unaligned write" error. This will have to be handled by

I have never seen this happen (i mean UNIT ATTENTION being returned) in
practice with SAS HDDs. Not sure how zoned UFS devices behave though.

> pausing zoned write submission and by resubmitting zoned writes after
> all pending zoned writes for the given zone have completed. In other
> words, if higher queue depths are supported per zone, we cannot avoid
> increasing the complexity of the code in block/blk-zoned.c. If we cannot
> avoid increasing the complexity of that code, I think we can as well
> select the approach that yields the highest performance and the fewest
> changes in the block layer code for regular reads and writes.

But it seems that all we need to do is a better request handling in the
requeue+dispatch queue to handle requeued writes. I am not yet convinced that
zone write plugging needs a lot of changes beside allowing more than one write
per zone and some form of throttling based on feedback from the requeue path.
I.e. the current code throttles write command issuing every time one command is
submitted: the submission "plugs" the write plug. In your case, it seems that
the plugging should be driven by the requeue path, or the driver. Unplugging of
a plug happens currently when a BIO completes, but in your case, it would need
to be also driven by the requeue path or driver.

I am thinking that things could be cleaner/easier to maintain with a zoned
write requeue special path. May be... I am thinking aloud here as I have not
tried to code anything.

> 
> Thanks,
> 
> Bart.
> 
> 


-- 
Damien Le Moal
Western Digital Research
