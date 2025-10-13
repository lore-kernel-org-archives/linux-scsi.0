Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C24C21E0AD;
	Mon, 13 Oct 2025 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760372583; cv=none; b=ZKes3wuqQN8KoVNFVC/KxhmwWP16c8N5onC1WV43Ks9R06XRduAyz0lbNosiMluRTQuUFXtlP8DdA/+4FEGBf7AZcsaw/KaZOG8bpSzZGVpMbXQjsGsh9GHlJGpxtXyfQA79j+dAYucQoBOg6l7frzGN1mAZXvBCnCbKvW5knAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760372583; c=relaxed/simple;
	bh=pLaAxxAOeuMykOqTybKDCApaEgiMMJ2A2v6pqACPv7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Qx/w8btMVRw3B0SQP41Dc3UlecJX4VazpGeyR2oA6ksAiGwZI6kqx+T2NfDzf9rOEOaeGUvAjttq7UTaVe1ueHE94LEQTZbjD+MPrm3f22fGmVcFvEgEm/3dCfsM5E1uGaIXVI2jbZK5FLzYc9ETtt9Vyegj2ojmvXFxzUSNkzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gtEmUH4t; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gtEmUH4t"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cljH85qk9zm0yT2;
	Mon, 13 Oct 2025 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760372387; x=1762964388; bh=bu9PLA/8Y7BBIVllLT5wV7kp
	7DEkGnJNGbY9I0R2Gbw=; b=gtEmUH4t67Uj9puGkOv72IVaukCEpxtWbRmeaTW6
	jLtvFM65wvMoWvlK7p2D1/oOlBgGowQCCFyVkcn9h7wrXyFM3rFZ2ifecXltCk78
	od8msuu/JVZFXvJGUbWwbXOlJPCvbm5mGcQSMUDxoWdzmBdk7cgAwQQ4Po6Bwyc0
	AR9SsbpBRo5eN2OrVBq1OCaSMPmhUis4bO5EWr0Wkr4hqQh376cxDdNtEPy7cguw
	akIcDfJ8XMebtf8MbsE8sSeH85bZhlv5UOX+kWaUzMfS38VMZVQpZ5YJXZ62mgRV
	bQGDX77GKNj1my5iwwE2rS/0A6hp+VV9nsPHVwT9ViZs8w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uHKd_n-NCFLX; Mon, 13 Oct 2025 16:19:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cljH13cN6zm0yTR;
	Mon, 13 Oct 2025 16:19:40 +0000 (UTC)
Message-ID: <f90010b2-7db1-412c-8526-47339bf4aa6b@acm.org>
Date: Mon, 13 Oct 2025 09:19:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Initialize a variable mode for PA_PWRMODE
To: Wonkon Kim <wkon.kim@samsung.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924@epcas1p4.samsung.com>
 <20251002070027.228638-1-wkon.kim@samsung.com>
 <4c894d68-7d0e-49a0-b582-477bcc7f351d@acm.org>
 <000001dc3c1a$33e23030$9ba69090$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <000001dc3c1a$33e23030$9ba69090$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 1:20 AM, Wonkon Kim wrote:
>> On 10/2/25 12:00 AM, Wonkon Kim wrote:
>>>    static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
>>>    {
>>>    	struct ufs_pa_layer_attr *pwr_info = &hba->pwr_info;
>>> -	u32 mode;
>>> +	u32 mode = 0;
>>>
>>>    	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
>>
>> Since there is more code that passes a pointer to an uninitialized
>> variable to ufshcd_dme_get(), the untested patch below may be a better
>> solution:
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
>> 127b691402f9..5226fbca29ec 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -4277,8 +4277,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32
>> attr_sel,
>>    			get, UIC_GET_ATTR_ID(attr_sel),
>>    			UFS_UIC_COMMAND_RETRIES - retries);
>>
>> -	if (mib_val && !ret)
>> -		*mib_val = uic_cmd.argument3;
>> +	if (mib_val)
>> +		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
>>
>>    	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
>>    	    && pwr_mode_change)
>>
>>
> 
> There are some attributes to use 0 as valid value.
> e.g. PA_MAXRXHSGEAR is set to 0 for NO_HS=0
> If it has 0 for valid value, most of value 0 are regarded as FALSE, unsupported or minimum.
> And these cases seems to check ret for command success/fail in code.
> However, is it ok to set 0 for ufshcd_send_uic_cmd() fail?
> 
> If it can't, it needs to initialize mode.
> Value 0 for PA_PWRMODE is invalid.

Hi Wonkon,

Modifying ufshcd_dme_get_attr() doesn't exclude checking the return
value of ufshcd_dme_get_attr(). I propose to modify
ufshcd_dme_get_attr() such that it always initializes *mib_val and also
to check the ufshcd_dme_get_attr() return value wherever appropriate.

Thanks,

Bart.
