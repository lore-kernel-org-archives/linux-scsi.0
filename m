Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4EA149C7E
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 17:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720458667; cv=none; b=dAa1x294S9NCQ9tqLSsFmqf7ZmD6oJmW5ZkmD8gkcG26i/kjrT675jf0GEjsvldDfifxTjxYgeCe0N5DJOKx++XRUKgYkhEX2LlMawlLrdWUtmcu5IMhRIxVB7Ff369xapqNHG1wZV+unTUG1Ph1Os27NQDrQUC7qjxe7tqbECY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720458667; c=relaxed/simple;
	bh=OVQC7SYfwWsSzxp49HtF8Qr/XFbwjUALqvlsN0LiY0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hulnfR9fi7I/MXNWVb0zl4wIOylzKaU6/EoZmzadhtAh22s3ezrn4YfYRdoSodABdedWVGQ3MxGclZ58A22kAgXyMQHlcv5IRwWnVL+yrzOLQhH5+J1x+Iig82gZW+5HeO0rtuDYcOCF26Kz5C2IkU7OEsDXG3GMLX76QzcNdco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VW3wRrQJ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VW3wRrQJ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WHrHM5Nv1zlfrxv;
	Mon,  8 Jul 2024 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720458649; x=1723050650; bh=nM/K845VvhK9Waepeb1P+shP
	ZozSBE4pq5yXKWUL6YE=; b=VW3wRrQJLHw45O1Bu9+066uNAlvaMidhV62DtQW/
	IG1XFnMWoDsWr1juVgtQJH2WTWq0I1Y5wsEc/3NyyA/Uc0byELK8owPEITeTlQij
	9kRBndUckktISpmygJSBYqp41E6+ANsKSFA1PXU62mfgz+iDrI9MtbfqYiyyr9kr
	m4tNe/oUkk9fA1BCJh9ie+K4/iAh4kdqsvvvTMX68HEMkwu/aSGsNSYDBLjZC6xm
	Cn0EcFXEhxbuHHbYu070vbOvGBfjmpFXRVGLjqCIz1r7dogLxLYHMSMqUJWttjtI
	DM0QY0jBnjRBEe8jINVpHSmuGMamAbjLxvP3p9mhbr5GSw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mL7ZTk_XAmXJ; Mon,  8 Jul 2024 17:10:49 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WHrH93751zlnNF5;
	Mon,  8 Jul 2024 17:10:45 +0000 (UTC)
Message-ID: <f40ce193-1abb-4518-9cfe-5e35af636502@acm.org>
Date: Mon, 8 Jul 2024 10:10:43 -0700
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
 <0bf21926-574a-46fc-82e4-86527ea59b3b@acm.org>
 <20240706163321.GA3980@thinkpad>
 <8544aa91-1044-41df-8650-2a3fa3d58016@acm.org>
 <20240708104415.GB5745@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240708104415.GB5745@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/24 3:44 AM, Manivannan Sadhasivam wrote:
> On Sat, Jul 06, 2024 at 08:24:06PM -0700, Bart Van Assche wrote:
>> On 7/6/24 9:33 AM, Manivannan Sadhasivam wrote:
>>> On Wed, Jul 03, 2024 at 01:36:46PM -0700, Bart Van Assche wrote:
>>>> If an UFSHCI controller is reset, the controller is reset from MCQ mode
>>>> to SDB mode and it is derived from the hba->mcq_enabled structure member
>>>> that MCQ was enabled before the reset. In other words, moving all
>>>> hba->mcq_enabled assignments into ufshcd_mcq_{enable/disable}() would
>>>> break the code that resets the UFSHCI controller.
>>>
>>> Hmm, could you please point me to the code that does this? I tried looking for
>>> it but couldn't spot.
>>
>> * There is no "hba->mcq_enabled = false;" statement anywhere in the UFS
>>    driver core. This shows that the reset code does not reset
>>    hba->mcq_enabled.
> 
> Right. So this flag is used to reconfigure the MCQ mode upon HCI reset.
> Previously we never disabled MCQ mode as well. But that is being changed by this
> patch.

Only in an error path.

>> * From the UFSHCI specification, offset 300h, global config register:
>>    in the "reset" column I see 0h for the queue type (QT) bit. In other
>>    words, if a UFS host controller is reset, if MCQ is enabled (QT=1),
>>    it must be disabled (QT=0) until the application processor enables it
>>    again.
>>
> 
> So this means, once the HCI is reset, the QT field will become '0' by default.
> So if MCQ mode is supposed to be enabled, then driver has to explicitly enable
> it.
> 
> But only place where you disable MCQ is when ufshcd_alloc_mcq() fails (in this
> patch). Then you also set 'hba->mcq_enabled = false' afterwards. I fail to
> understand why you cannot move the assignment to the enable/disable API itself.
> 
> If you do not set the flag after calling the ufshcd_mcq_disable() API, your
> argument makes sense. But that's not the case. Perhaps I'm missing anything
> obvious?

What do you want? That I move the "hba->mcq_enabled = false;" statement
into ufshcd_mcq_disable()? That would be wrong because (a) it would
introduce a confusing behavior difference between ufshcd_mcq_enable()
(does not modify hba->mcq_enabled) and ufshcd_mcq_disable() (would
modify hba->mcq_enabled if I implement your proposal) and (b) wouldn't
reduce the code size because ufshcd_mcq_disable() only has one caller.

Bart.
