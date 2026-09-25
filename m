Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0484547728A
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 21:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790373317; cv=none; b=FfiBcvV8fNEwOdm8Jfdjp5TQFxWRrjD8VYzeOS8X/0dfozS0nIvUhaBzQjEHv8U8DP/RTV2RkFEGNJHGA5M2pyt6dIz3p/WYmT6iVJKczYbzUobTUnCS1oSwxSuysKrFBUbV7f1j2Hy1HpezJN36DuGq8GeogqonBuacQJ60oNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790373317; c=relaxed/simple;
	bh=Nh3CSRcnTQE1l/HduodypiTOrQ1qbRJMopIvxGbMZj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wrn1qhZhKA3aune0gwoS8buhkVQeihAM2CViIURRhNSeCpDRK4rkm71dkfnfla2JKkCYeMG5LKYMaVh6JIO0I++gTQf6zz7gWaLDY+iilCR5gHZp+XfVqatkC1uEoNnJZvV90VRA5fuLqOdsLs7kQcLZQ6SvEsfl6Dvvql9rZzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NaDifzZ9; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NaDifzZ9"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hs4J21fbbzlfvpS;
	Fri, 25 Sep 2026 21:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790373311; x=1792965312; bh=ZcdwxZIRznE75ejorIyCGDum
	bdmzlK7Krhh+dFQUu4A=; b=NaDifzZ9qo3+HVa4xk9zMw3f2EXSaR2JMmLoY7cW
	RcDGCDpehyZdRlUY2wExnfOhnq5Du12upYECUEdt8Inxckab0+HyeIXfmmHs0t2o
	q6XpbLt4tvgfQiBO2RQ3MmcCuZmityJ1eeca2igbeipK9ZDHj1SSfNw4nTzLhuwV
	ZWNng7DEU2ZJlUPTQ0aXtQcYCXHLECieDSu/S0cKBq/xbwJsKPo8YWTZT2WZ3xQp
	1zMP/1N9te1GhPGWaCGXHdbkB15FXMlFCZNuVAenwdKWGKxqZ8wpGMlY3ZYcI271
	ttMfzgL/4mNXH4hQQcEdwdFm3c+sAQzmiRbZ6pPHxT7a/A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Sr68ZukCwUSt; Fri, 25 Sep 2026 21:55:11 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:9d67:ec98:e8f9:601a] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hs4Hy3cFjzlfvpG;
	Fri, 25 Sep 2026 21:55:09 +0000 (UTC)
Message-ID: <c0de128d-5c3a-4b53-a059-d382ab9f4d9e@acm.org>
Date: Fri, 25 Sep 2026 14:55:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] SCSI fixes for 7.3-rc4+
To: sashiko-reviews@lists.linux.dev,
 James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
References: <ea8f769b49f7d1185f588cf5b9202f300c280af7.camel@HansenPartnership.com>
 <20260925214614.0CD7E1F000FF@smtp.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260925214614.0CD7E1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 2:46 PM, sashiko-bot@kernel.org wrote:
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
>> index b95f187297aed..4f9a53769966f 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> [ ... ]
>> @@ -7886,7 +7886,9 @@ megasas_resume(struct device *dev)
>>   			goto fail_init_mfi;
>>   	}
>>   
>> -	if (megasas_get_ctrl_info(instance) != DCMD_SUCCESS)
>> +	scoped_guard(mutex, &instance->reset_mutex)
>> +		rval = megasas_get_ctrl_info(instance);
>> +	if (rval != DCMD_SUCCESS)
> 
> [Severity: Low]
> This isn't a bug, but this function relies heavily on goto-based error
> handling.
> 
> Does the introduction of a scope-based cleanup helper (scoped_guard) here
> violate the cleanup subsystem guidelines?
> 
> The kernel cleanup guidelines state that scope-based cleanup helpers and
> goto should not be mixed in the same function, as it can create confusing
> ownership semantics.

I assume the above refers to the rules in include/linux/cleanup.h?
In that header file I found the following:

  * Lastly, given that the benefit of cleanup helpers is removal of
  * "goto", and that the "goto" statement can jump between scopes, the
  * expectation is that usage of "goto" and cleanup helpers is never
  * mixed in the same function. I.e. for a given routine, convert all
  * resources that need a "goto" cleanup to scope-based cleanup, or
  * convert none of them.

I think these rules are too strict and should be relaxed.

>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 2ba244cf40ac7..54f4e7d7de02e 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -6817,11 +6817,17 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>   	}
>>   	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
>>   	blk_mq_quiesce_tagset(&hba->host->tag_set);
>> +	/*
>> +	 * Internal commands are submitted on the pseudo SCSI device. Let them
>> +	 * through so that the error handler can recover the link.
>> +	 */
>> +	blk_mq_unquiesce_queue(hba->host->pseudo_sdev->request_queue);
> 
> [Severity: High]
> Can this sequence lead to a use-after-free on hba->host->pseudo_sdev?
> 
> If a device error triggers ufshcd_intr(), it schedules hba->eh_work.
> Concurrently, the driver could be unbound, invoking ufshcd_remove().
> 
> ufshcd_remove() calls scsi_remove_host(), which destroys and frees the SCSI
> devices, including hba->host->pseudo_sdev.
> 
> Because ufshcd_remove() does not cancel hba->eh_work until later in
> ufshcd_hba_exit(), the error handler might execute
> ufshcd_err_handling_prepare() while teardown is in progress.
> 
> Is it possible for the code to dereference hba->host->pseudo_sdev here
> after it has already been freed?

This is an existing issue in the UFS driver that predates the UFS driver
changes shown above. Additionally, in a typical setup the UFS device is
not removable and hence ufshcd_remove() will never be called.

Thanks,

Bart.

