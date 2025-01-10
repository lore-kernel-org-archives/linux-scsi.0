Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05518BA50;
	Fri, 10 Jan 2025 05:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736485852; cv=none; b=cCU9tDD5eKJfrPrQc1EbW5hReKLggNAYiqjflAeX4jCCKzKtZZFM6ZhyzJ+7f/9DOUECGxQhI0fm+j6apR5fnySDeCJ9TrN/dTYxxzhoHtqxpHGJUJOoBszF+pWH8aoeKTxbJQIrp7I92NU0bPK75PTRULv/S+nYGjN7Mhu7jPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736485852; c=relaxed/simple;
	bh=xA25l5UV4vAw69zi9EvaWxEou/QHHqrcOJjx6XUuNmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYQhCZajRbl2myP5pbnR+qQ7jgeE+XGmaRmzKpNS12d6pest1j+IJwt0qaEUqB5pnf2Ur6wAPbhwMzUFU/1tWkleK1bFJKEoWeofGc3+KJs+Uc/bP7yHjgASdwupQlHqoMgXj9/fma8FffJq5O4mPUtwHIiYH1kPWHqYZGLZr5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmddhFJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmddhFJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE42C4CED6;
	Fri, 10 Jan 2025 05:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736485851;
	bh=xA25l5UV4vAw69zi9EvaWxEou/QHHqrcOJjx6XUuNmw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kmddhFJBYOuTKrJ6Ftwvc0USSyYaQBk8tRsJv/wDkEruHPqe9kIiUFMRoAewmfX+D
	 S6vKu4eOS6lY0Ga9SO28jnd87KvGeObU4AZnj20Kc1FDxK6esKLJDEJ6acWJWmbfJU
	 kncy5A6YhMTD5miWYWSS4aWH+lSQoyCQXpZVcgGFK4Kg06fByesjTYpfq5oeuPwIuT
	 6woJ6E6dnZPOeZ5rv9r7kPAkfRFXngfUNLXtntMs31Ryp41HEybNU5tgq0SduDK6s0
	 85KkAke/LbV1Y585U013NydCsOYYdpOcqAjZ50bRTa2y3WKrC4tbxAOw5XcZsaiLjH
	 g5H7RE+lZQUjQ==
Message-ID: <fe7c85ee-11ad-43fd-a38f-5ab56e28f8dc@kernel.org>
Date: Fri, 10 Jan 2025 14:10:49 +0900
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
 <cbbcd4b5-0134-4b8b-bd06-d0a2091118f5@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <cbbcd4b5-0134-4b8b-bd06-d0a2091118f5@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/10/25 04:02, Bart Van Assche wrote:
> On 11/19/24 12:01 AM, Damien Le Moal wrote:
>> On 11/19/24 09:27, Bart Van Assche wrote:
>>> This patch series improves small write IOPS by a factor of four (+300%) for
>>> zoned UFS devices on my test setup with an UFSHCI 3.0 controller. Although
>>> you are probably busy because the merge window is open, please take a look
>>> at this patch series when you have the time. This patch series is organized
>>> as follows:
>>>   - Bug fixes for existing code at the start of the series.
>>>   - The write pipelining support implementation comes after the bug fixes.
>>
>> Impressive improvements but the changes are rather invasive. Have you tried
>> simpler solution like forcing unplugging a zone write plug from the driver once
>> a command is passed to the driver and the driver did not reject it ? It seems
>> like this would make everything simpler on the block layer side. But I am not
>> sure if the performance gains would be the same.
> 
> (replying to an email from two months ago)
> 
> Hi Damien,
> 
> Here is a strong reason why the simpler solution mentioned above is not
> sufficient: if anything goes wrong with the communication between UFS
> host controller and UFS device (e.g. a command timeout or a power mode
> transition fails) then the SCSI error handler is activated. This results
> in ufshcd_err_handler() being called. That function resets both the host
> controller and the UFS device (ufshcd_reset_and_restore()). At that time
> multiple commands may be outstanding.
> 
> In other words, submitting UFS commands in order is not sufficient. An
> approach is needed that is compatible with the SCSI error handler and
> also that ensures that commands are resubmitted in LBA order per zone
> after the SCSI error handler has completed.

If the failed commands are retried, they will be requeued and you will not see
the error as the request will not be completed yet, no ? And if you do see the
error back in the block layer, you cannot just retry the command at will. The
issuer must do that, no ? I am confused...

Please send patches to discuss based on code. That will be easier.

> 
> The statistics I have access to show that the UFS error handler is
> activated infrequently or never on any single device but also that it is
> activated a nontrivial number of times across the entire device
> population.
> 
> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
