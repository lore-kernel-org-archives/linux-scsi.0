Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8431186AFA
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 17:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724087885; cv=none; b=hTcuien9dv+4sYSICUqVT4tnGiLQxrnWfObyOCNf5RuYkf1sbOcC6RXM5WL8MTcuThPa5sZQJwOfZMpldgmAc1d0BH77m/1z7Jgdo8QBdHezTeH2+CHQkRXUc8soK4HCg1UJAg15G5z3lcTcGNBHzR6Vq7HRwXlbIb660qgXH3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724087885; c=relaxed/simple;
	bh=qtZImD9yTkpZIlem1qgjo6A3Mp4U79bIegpXAUg7BDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZsiQ+VDe6oZGzqdthlObGVDO4jznhy+37JDogw6Upzec2SCDfh9h8GSQgfTq6gzj0Dv1Vz0QGQXYVK9CMCOGqS3uaceFC2Ne3Ki40x/udesBxmP79MaB7CfMfL29i6nzDsme1wEhk+A1wlp4Av2gbaZ2Cc1suE6rsctGAt6qJaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eZPprG9c; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eZPprG9c"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WnfSB6VHtz6ClY90;
	Mon, 19 Aug 2024 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724087881; x=1726679882; bh=GkRLTNVS++nY3q/QnNrlToaE
	s/jAKqWpEEotfiLLmsA=; b=eZPprG9cjAJQQksnDJCRqzyRKd2ZFmlQ0cpUUJqE
	m8zS0EkipISbJBA1p4pxLKfWpTsDSjmK1onagGrJ4B93aCSmlpHbqYAHOoJnw5iJ
	qeyeoG/juxuxBLLuW1VDQhA4QalrVna78NFh1Fqk+FSrxksFK3x9u5V2cR3kkW1K
	BHS1gKwWFG4MNwUO5zUIx/PR9Rc5lbhUNh0pqSTi9EFC65nO6drDbQD9ErCY/PMR
	S/3BIMLTA5LWZQcu+Hn35hoVUQcB4iVCsAnO2nN7djVIsT6HYYQIrGzCjoO20pMW
	Z87eYAK747d4INO2fNjYQh6GVfTg5qQKh+anIPwg1R+XcQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Wbd2A5rfm8i6; Mon, 19 Aug 2024 17:18:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WnfS83PTyz6ClY8w;
	Mon, 19 Aug 2024 17:18:00 +0000 (UTC)
Message-ID: <bd0ad5fc-bf76-423a-b734-bc306b2edc45@acm.org>
Date: Mon, 19 Aug 2024 10:17:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/18] scsi: Expand all create*_workqueue() invocations
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20240816215605.36240-1-bvanassche@acm.org>
 <20240816215605.36240-2-bvanassche@acm.org>
 <686d0650-f5c9-4c86-9900-ba980baecb00@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <686d0650-f5c9-4c86-9900-ba980baecb00@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/24 4:25 PM, Damien Le Moal wrote:
> On 8/17/24 06:55, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> index 1078c20c5ef6..f49783b89d04 100644
>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>> @@ -2363,8 +2363,8 @@ static int _bnx2fc_create(struct net_device *netdev,
>>   	interface->vlan_id = vlan_id;
>>   	interface->tm_timeout = BNX2FC_TM_TIMEOUT;
>>   
>> -	interface->timer_work_queue =
>> -			create_singlethread_workqueue("bnx2fc_timer_wq");
>> +	interface->timer_work_queue = alloc_ordered_workqueue(
>> +		"%s", WQ_MEM_RECLAIM, "bnx2fc_timer_wq");
> 
> Very odd line split. And there are a few more like this one. Maybe your patch
> needs some manual tuning after running the script ?
> 
> The patch overall looks good to me, but it would be nice to have consistency in
> the line splitting. Personnally, I prefer the pattern such as:
> 
> -	kmpath_rdacd = create_singlethread_workqueue("kmpath_rdacd");
> +	kmpath_rdacd =
> +		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "kmpath_rdacd");
> 
> instead of:
> 
> -	lio_wq = create_singlethread_workqueue("efct_lio_worker");
> +	lio_wq = alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
> +					 "efct_lio_worker");
> 
> Though I guess that is a matter of taste :)

(reduced cc-list)

If I run "git clang-format HEAD^" on this patch, no code is changed. 
Does this perhaps mean that the .clang-format style file in the kernel
tree needs further tuning? The most recent change in that file other
than adding for-each macro names is from two years ago (see also commit 
781121a7f6d1 ("clang-format: Fix space after for_each macros")). Or does
this perhaps mean that there is broad agreement about the coding style
parameters in the .clang-format file?

Thanks,

Bart.


