Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177B71428F8
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 20:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720039027; cv=none; b=g58/rLcoe2f/mrBiFdVrElOSDlLnlp5AmiDc4tcSIfWHSgYGXob7m6atbj8R+5Kgcas703C9SxOU6tPNI80XWMMAGZmaibb3t22d1yBBqaAi4IsNTCUa39Zt72WkHRSyJWZyXWy+GqOR/vDwifQ5utvIUoFNocFS8uRQ+lEXN+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720039027; c=relaxed/simple;
	bh=5eb3A/0ENDoS5OS0UnrO2ix++TOlI9Ktdki36Whdfpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VDrEXe85WmGtmK0JpE5ETMZ+FeYa3Vjshg5+PPJOwr+wZmyE4M/pY+IG+ANRsNMXfSX7OU9SLoUIunjv5ezRYKQEhJO3RS23ragNF7z1F2x6A+GthgafI/P5BghuY/sITq5CN3A8zDoylr58qWL0rvxhRfqUx/SF1JegAlPdC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rVsehJwH; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rVsehJwH"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WDs5R2XvWz6CmR43;
	Wed,  3 Jul 2024 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720039013; x=1722631014; bh=0ex5p+nj1G546JueVlhwdxzR
	xf3zCupJsanN6Kuej+0=; b=rVsehJwHDkN7Jmqblk/ChnrxnzRuDgPer3oD+Hlf
	T52p9P2F/JZzWdYgynJ8Sgmm7RF7LeYOYmroVJ/vi1BeAzPrevHrkNA8ICF20AAV
	cLMXLJ/cgChUjMfoHei5PluvKiSm5QAgCAVWv+ops9p8sFBdnMg7xN4CZ9nfjf64
	s1QDGetDPmIdOgNxMmGsyPkfUHLtNtWDtkMvkpx35i9xwtZ3tlCuK5rOeEqIex8x
	2Hw598SE4/xQm6xyedNAJwwpxpSxxPjnAWiAdJn+Gw4oG3N+Lq0ISHeFJVrI+T/H
	nmVcXOUmg99Xws3dpmg4WSoSNGRWinsao34CUBYu7IkcIg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SsLqcyTQubzu; Wed,  3 Jul 2024 20:36:53 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WDs5F15Ymz6Cnv3Q;
	Wed,  3 Jul 2024 20:36:48 +0000 (UTC)
Message-ID: <0bf21926-574a-46fc-82e4-86527ea59b3b@acm.org>
Date: Wed, 3 Jul 2024 13:36:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] scsi: ufs: Make .get_hba_mac() optional
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>,
 Stanley Jhu <chu.stanley@gmail.com>, ChanWoo Lee <cw9316.lee@samsung.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Avri Altman
 <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Akinobu Mita <akinobu.mita@gmail.com>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-10-bvanassche@acm.org>
 <20240703132202.GE3498@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240703132202.GE3498@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/24 6:22 AM, Manivannan Sadhasivam wrote:
> On Tue, Jul 02, 2024 at 01:39:17PM -0700, Bart Van Assche wrote:
>> -	mac = hba->vops->get_hba_mac(hba);
>> +	if (!hba->vops || !hba->vops->get_hba_mac) {
>> +		hba->capabilities =
>> +			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
>> +		mac = hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_MCQ;
>> +		mac++;
> 
> Can you add a comment to state that the MAC value is 0 based?

Sure.

>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index b3444f9ce130..9e0290c6c2d3 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8753,13 +8753,15 @@ static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
>>   		if (ret)
>>   			return ret;
>>   		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
>> +			ufshcd_mcq_enable(hba);
>> +			hba->mcq_enabled = true;
> 
> If the 'mcq_enabled' assignment goes hand in hand with
> ufshcd_mcq_{enable/disable}, why shouldn't it be moved inside?

If an UFSHCI controller is reset, the controller is reset from MCQ mode
to SDB mode and it is derived from the hba->mcq_enabled structure member
that MCQ was enabled before the reset. In other words, moving all
hba->mcq_enabled assignments into ufshcd_mcq_{enable/disable}() would
break the code that resets the UFSHCI controller.

Thanks,

Bart.
