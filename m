Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580ED4A0138;
	Fri, 11 Sep 2026 15:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789141988; cv=none; b=KnjvjDWSwP4doFZCwMr8z9Gx9jBmett6axhdJZg1ha6Qx3nc1pIoB8qg7dYWWOkPpM3jNsmAqvkCLHVFqEG2af1HzYy05w8/RR0S+p/cqxDvfoKhWuT6VfHLovkLjmjeHVAORjCKNIdDUcadeOuAacSPTtZD2DP7vDUyYU592zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789141988; c=relaxed/simple;
	bh=6b52kQCpcdBblO5/dYwMXJhGcfPKugDKju8SklhnRMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BhxCPmzyCBFIRR2KN6kFWtWXiHH7PjDlAcU8CtKWLmWxmqBRT9TLwwfMVThry7/rSdNoT6egqVw2Q42qwDCKKCWXtCZtre7/HvZVLAIqnLrnpUKzVDRMmFtN6YQqfOxpL7SO4jwCsV2TkcUQofp12CckiFrp+qMuxaewLkfr/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h+X4USw5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h+X4USw5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hhJwd4f1xzlfwJB;
	Fri, 11 Sep 2026 15:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789141982; x=1791733983; bh=ipODu939eUAqXhuEAaeg7avR
	p3ZONlwlL+3pRhVU7/o=; b=h+X4USw5mp5bq7dw2YOswakGDs4mGO0nzr53AP0T
	ngHJPAWxlLrdPgRQDmmraeV5K0ivMAdEzQDyjsML/dxEr5aq2VY8gWySt+Xdv/bi
	FsTuDq3gKVZuRn5TZ9Keo87aCep/G96+0y7BZZ17i2NAB36Rg2z9nBRMa8GEe3dM
	8Oxdh3L5qzh8JNpUvtmIbnH3jVTbJSdJGLBxw40F3GsTYWExFdY/waAnd9akP2C7
	j9gGpoopsh+wqN9qqq+mW8AEp45mnKJmcyhMoSNlGR3NS7y4RJ6swSk6H0GM93ov
	wHL7dMSKVoFfjYUZabrMv4jNwM4iU01RHH68S6CI/cGuPQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zW4BQTbXjeKT; Fri, 11 Sep 2026 15:53:02 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:b591:e5fc:52e3:a430] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hhJwW5cMYzlfvqM;
	Fri, 11 Sep 2026 15:52:59 +0000 (UTC)
Message-ID: <b057e613-4b3f-4db1-97bb-66a4ac7420ba@acm.org>
Date: Fri, 11 Sep 2026 08:52:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Quiesce SCSI devices instead of host
 tagset during error handling
To: Stanley Jhu <stanleyjhu@google.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, stable@vger.kernel.org
References: <20260902082306.2299159-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260902082306.2299159-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/26 1:23 AM, Stanley Jhu wrote:
> Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
> switched UFS internal commands to allocate requests on
> hba->host->pseudo_sdev->request_queue, which shares the host tagset with
> regular LUNs.
> 
> During error recovery, ufshcd_err_handling_prepare() calls
> blk_mq_quiesce_tagset(&hba->host->tag_set), marking all queues in the
> tagset as quiesced, including pseudo_sdev->request_queue. When
> ufshcd_verify_dev_init() subsequently issues internal commands (e.g. NOP
> OUT UPIU) via blk_execute_rq(), blk_mq_run_hw_queue() skips running the
> quiesced queue, resulting in an unrecoverable circular wait deadlock.
> 
> Resolve this by quiescing only logical units attached to the host via
> shost_for_each_device() during error handling. Because
> shost_for_each_device() explicitly skips pseudo SCSI devices (via
> scsi_device_is_pseudo_dev() in __scsi_iterate_devices()), regular LUNs
> are quiesced to prevent retry storms, while pseudo_sdev remains
> unquiesced so internal commands can be dispatched and completed during
> error recovery.
> 
> Clock scaling and command pause (ufshcd_pause_command_processing) paths
> continue to use blk_mq_quiesce_tagset() as they require freezing all
> queues including internal commands.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
