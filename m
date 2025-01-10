Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2793B2F3E;
	Fri, 10 Jan 2025 05:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736485678; cv=none; b=UXc61hGYBz5hQuQFodsysMCfiZkjSXuQboul6ALv5E61tpwFtBk5MvBZAX4xI3SQPoPP0Yk1dKmSA8pwQifYvlIABeOlS9C7Zdf44HS/+F8lB4X/5ZvpOsVVpVms2AIJ1H2BXNMLJdzwiKqmsT/lRMdE82K+eDeCSW+VWMesMgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736485678; c=relaxed/simple;
	bh=S7Xf9aLv3oCPLGJxtHVkEWSoywvAAp7cOY+G2ljovOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRdGsSQnF9QOzqaIiXPL/lKexkFLpUcfrXozcpcUs7dncddLJve1oOxfzd2vbgiAGpPRqhZf7czWWRfvN6p4JgsNyo/g3emBFbFPqM7uU0Ay01t14RgOyIFbfO1ddTWUbzOUMuX194fsdc3mImMMsau4NSaHhKUAAnGOU425n28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPM8zfv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPM8zfv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0FEC4CED6;
	Fri, 10 Jan 2025 05:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736485677;
	bh=S7Xf9aLv3oCPLGJxtHVkEWSoywvAAp7cOY+G2ljovOc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jPM8zfv8DqgClXk8x4RzD4kDZAjdZZrBblYHCSbaAaiEt1aWulMH1U7+XNabmX7XO
	 oa7r0vWauXZJ9RkzxFjuu+E0UkmzFm2fgiRjedAQPZcBkyHueJmBEtHFiyRv4BxNNF
	 2L2qdmOddWT8L7yOC+XtP3ZMbByCpEaGV+5kaKqMOLU425EkL+CK+Ee6ptBzXSKpRm
	 x8iKu1VLX8g52JzWw6Rh9Qmjix7AH2xe7CklGh9T8LCD8GMmOSj/xRaPrjPE1RCuWp
	 7SiFgmSNITSQDlIMceMtZMzRLrmQV8C4OcLEK+203CxCLnmO3FnqSOwHz6o3VvtNBW
	 FTLuZsy3MZokA==
Message-ID: <bf6328f2-c660-4431-9ef6-39722dafa9e7@kernel.org>
Date: Fri, 10 Jan 2025 14:07:55 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/26] blk-zoned: Fix a deadlock triggered by
 unaligned writes
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-6-bvanassche@acm.org>
 <6729e88d-5311-4b6e-a3da-0f144aab56c9@kernel.org>
 <8c0c3833-22e4-46ae-8daf-89de989545bf@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <8c0c3833-22e4-46ae-8daf-89de989545bf@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/25 04:11, Bart Van Assche wrote:
> On 11/18/24 6:57 PM, Damien Le Moal wrote:
>> And we also have the possibility of torn writes (partial writes) with
>> SAS SMR drives. So I really think that you cannot avoid doing a
>> report zone to recover errors.
> (replying to an email of two months ago)
> 
> Hi Damien,
> 
> How about keeping the current approach (setting the 
> BLK_ZONE_WPLUG_NEED_WP_UPDATE flag after an I/O error has been observed)
> if write pipelining is disabled and using the wp_offset_compl approach
> only if write pipelining is enabled? This approach preserves the
> existing behavior for SAS SMR drives and allows to restore the write
> pointer after a write error has been observed for UFS devices. Please
> note that so far I have only observed write errors for UFS devices if I
> add write error injection code in the UFS driver.

If you get write errors, they will be propagated to the user (f2fs in this case
I suspect) which should do a report zone to verify things. So I do not see why
this part would need to change.

> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
