Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C831DD392
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 23:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110200; cv=none; b=rrqvafILJSoqN2ZkTcQnvFwXiqkXCWAEPBfeZfe2jXVAhJTIy86z3Jmx16MjOXMPS9ID2OP2eiq1RwsBCiGRDtRDb0tJzRwF2LXMEPupIyPAD+jznT69mA0C/HzAPM5uH78XT0tKCdxyWNbTv1tFDjHMYqqeqwf7LQLHQEFFYZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110200; c=relaxed/simple;
	bh=RNqQiRJtB55A+VeWj5dqdRt3lAFgnNHEfImNr/FqWNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uEGJI1Ha3UDj1TQ0uK0eq3viOGnKKCgfWCyCajmPV4vy+aolQ+23foNzpXNJX00tA7onpk/bUsWkUlxuzMc4AIiT9zMwjelDEP/UnlAzeE30+DxZCRobyvDGcH8Qtwz5M0FuLSK4OB1R84tJbxpTZLv8s0ZLapvCPzmcrttH5gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FphnHXPd; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FphnHXPd"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WnpjK67lPzlgVnN;
	Mon, 19 Aug 2024 23:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724110195; x=1726702196; bh=mtovbg19uyz0jPbVZRRdhYzO
	eo5Mp9AGqi4kJQB5cB4=; b=FphnHXPdpCKaXNsmLML0mPySi5/+44ffTT58wbm8
	6iHRTPipILATrp2p2k6c1uub6wRf99XgLJqooZ/gOd98FY3j1lXqhWZ99uCscgoa
	FGJpkmVA5RFc14AXE1TIW6zd2Y3Fg+VwtsqwdypOIDiwAEG9FoNDWb+svWWCJoac
	m8Z7p/m30Doe6VvrzMEmCKNesp0IVwzDS/LZi/ni7BTLg8KAiK3kBMcUpgP3g9zN
	qetw51b6cqMG1b/7D3sQatW65tiwnXCJ6G6g9S3EUKDUKF4nlhlF6+CmkKS5K8dk
	nLvOfW5Bnz2Dyc3jBtRJNVFZQSC6yXdSXiAtHPuxxvNHYw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nEH2qbByjP2J; Mon, 19 Aug 2024 23:29:55 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WnpjH2xNNzlgVnK;
	Mon, 19 Aug 2024 23:29:55 +0000 (UTC)
Message-ID: <029dcfca-2a28-4f29-bc60-f1ef6c2b85e6@acm.org>
Date: Mon, 19 Aug 2024 16:29:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: core: Retry passthrough commands if
 SCMD_RETRY_PASSTHROUGH is set
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michael.christie@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240809193115.1222737-1-bvanassche@acm.org>
 <20240809193115.1222737-2-bvanassche@acm.org>
 <d226bf67-1d68-4e50-a20f-93a806f6860d@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d226bf67-1d68-4e50-a20f-93a806f6860d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 4:25 PM, Damien Le Moal wrote:
> On 8/10/24 04:31, Bart Van Assche wrote:
>> +	if (blk_rq_is_passthrough(req) &&
>> +	    !(scmd->flags & SCMD_RETRY_PASSTHROUGH))
>>   		return true;
>>   
>>   	return false;
> 
> 	return (req->cmd_flags & REQ_FAILFAST_DEV) ||
> 		(blk_rq_is_passthrough(req) &&
> 		 !(scmd->flags & SCMD_RETRY_PASSTHROUGH));
> 
> maybe ? Not necessarily more readable though.
> 
>> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
>> index 45c40d200154..19c57446ab23 100644
>> --- a/include/scsi/scsi_cmnd.h
>> +++ b/include/scsi/scsi_cmnd.h
>> @@ -58,8 +58,11 @@ struct scsi_pointer {
>>    */
>>   #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
>>   #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
>> +/* If set, retry a passthrough command in case of a unit attention. */
> 
> "...in case of error". There are other sense keys than unit attention and there
> is no code checking that this flag applies only to unit attention.
Hi Damien,

Thanks for the detailed feedback. Since Martin replied to this series
that he will reconcile his changes with mine, I plan to wait until
either Martin posts his patches or until Martin asks me to repost my
patches.

Thanks,

Bart.
