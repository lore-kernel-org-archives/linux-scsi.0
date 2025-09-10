Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ED63112D9
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2025 21:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540194; cv=none; b=kgZEbvsJw6CR5QleuR9m21h09XXUijDyfNYjlj03PF4asB5dbNANsgZ51aO0cObTCkyUEewCzYCYZaXZ57HqUBbzY28tyykxbgS2aeqhne2TcUMBa2cyQWjpJacmhcEOttvgk3HW7rrr4GPn8Vez61g3rNDGRTUM55SuhFGiavA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540194; c=relaxed/simple;
	bh=4URFQy0xWeymJ0tM5SQtiBIy9L6+1j/6fLsh1mSk8J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XYgxWlyVBG/A4H2/UvFJ7C0y+TrpkHTT8TAg4aX5o1l5OviScdMDEKhb3GT9n7/0AfBrFfapaN2BKyJ1HdUzAbPWHH0FvTRBAFAwJkgKm5g4MFAq8P4PtFhhwNDL6jcSw+zssOVWtWO6BhC247br0EvypmWt4cmN3GE6XP6nMEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Q8Bnc0kb; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Q8Bnc0kb"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cMYsp493Dzm0ytT;
	Wed, 10 Sep 2025 21:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757540189; x=1760132190; bh=UjeVCyEkOs44J8MXKTWSLm+B
	82XeM5qW5ukl47nU7zA=; b=Q8Bnc0kbIJWxsNylQbjrAAzwRaiVv/QswNPHN7WI
	4yPu4in9DOyv0txU8sowF3iCVkovQxob56MnP2gqPn4UEMfDhmVhTrC1ggaH+WRH
	DEnHng6OLbrA+yAWGVMwcXyv2dyy6LzhlJlXxQwE9yr5GVtK8rNZ3TCQWrAbpaAq
	SRhOg4puSQzWQFMKv20xAdMdYVrWFg+24Z0+WCywI7NvxuLf+0IjNQdeMINBvdNN
	BfnFVjITd1qu6oVf9Yl0FH6SYToJjGCv//De7L4ZPL9swU8mv+W+mEPZKb7aKHcO
	XieN0o++79xwVcnbln7yHFoaVivJK7RU0ahDh2sOkkQR6g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zSYZLwOJnJZ9; Wed, 10 Sep 2025 21:36:29 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cMYsj5SkTzm0yVY;
	Wed, 10 Sep 2025 21:36:24 +0000 (UTC)
Message-ID: <ffc809cb-7e5b-4ea6-8e48-dc7549d17b9a@acm.org>
Date: Wed, 10 Sep 2025 14:36:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/26] scsi: core: Do not allocate a budget token for
 reserved commands
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-4-bvanassche@acm.org>
 <7341ada1-05c4-4a70-94e3-cd208d47231d@oracle.com>
 <719e714a-6f15-46b9-b4f1-b697ea00ef66@acm.org>
 <c9b3a67a-20f2-4d2a-9b31-6a492dd17f81@oracle.com>
 <4477b1b9-be63-4e0e-9fdd-2b9633e8acca@acm.org>
 <ae0d289b-a61f-4546-a886-ab904fb76b79@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ae0d289b-a61f-4546-a886-ab904fb76b79@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 6:39 AM, John Garry wrote:
>>>>
>>>> Yes. The UFS error handler may be invoked if the SCSI budget has 
>>>> been exhausted and may have to allocate a reserved command to 
>>>> recover from
>>>> the encountered error. The UFS error handler may e.g. submit a START
>>>> STOP UNIT command if the UFS device is in the suspended state to bring
>>>> it back to a fully powered state. See also the ufshcd_rpm_get_sync(hba)
>>>> call in ufshcd_err_handling_prepare().
>>>
>>> I assumed that the budget map depth for the psuedo sdev would be the 
>>> same size as the number of reserved commands, right? If that is true, 
>>> if we have a reserved command allocated, then we must have budget as 
>>> well available.
>>
>> A budget map is allocated by the SCSI core to enforce the
>> host->cmd_per_lun limit. That limit does not apply to pseudo SCSI
>> devices. 
> 
> Sure, but if you had a budget map for the pseudo sdev then it would be 
> simpler, as you don't require special checks, below. I appreciate that 
> the budget map is not relevant to psuedo sdev to enforce any queue depth 
> limit tracking. I am just suggesting to have consistency between all 
> sdevs, to have less special cases.

Agreed, but a new patch series has been posted in which the
sdev->budget_map.map test is essential. See also
https://lore.kernel.org/linux-scsi/20250910213254.1215318-1-bvanassche@acm.org.

Thanks,

Bart.
