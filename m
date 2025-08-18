Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D22322540
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 16:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755534367; cv=none; b=PxqcYPe83KRdC9lI7MRTKE8cBB0omVtR0I192gEKAV7BOf7i/fdCyENzcy+YgQgk070owFu7gFSEL55vg87+Jcw9Q0iMVthV5Wgf+kI/yJbANHutJjG0KdmYAlQPys3JqpszkO2RR9POBf7wATgG1C72Wg9Yg2qYvsczRRQZbgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755534367; c=relaxed/simple;
	bh=VW8Me3qrlKGdcdXUAIRa+81YzWNskw0X68zDtal2yUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V28VErUaHg6Lh4UOjFz5ZSSQ31GOqECd5oo/p7lBLfLit6rv8u9MzPODqQ3OIappKKrh6NB4GjTQU5ucMw+Kmu+6Yp8lf1XgoDlWI0ltJQnIpU+ApRslG5VwnAobC1oLFYDLEVH6etCINxMGn+soTct/MRBpslQFyUUZQTG09DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0UliDDUf; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0UliDDUf"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c5J462tQ6zm0yst;
	Mon, 18 Aug 2025 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755534357; x=1758126358; bh=0ZpK1DADWvPIi1xMxwb17Pha
	hzufRMwhssvMr2Iyai8=; b=0UliDDUfWwmQaSANXwLsMegluTE+K5c9ZNlWDnP+
	HM86oqCQPHROJg0PrsiT+CeFl/egnZU0+Zt2AjOymfL0NX2qdSqz+ygYeKDHTwX6
	sb5nKyzELJlzV8mVoIpRO2cVVkmowGcmESAwGtwX6VnzjJKNFLBCg41FAY4iRBfm
	TyT6XgJagEXLMetaw/j21LTJnSMzTiyaUC8Atl6T9HVwH/jh9uaXdGG5rhoxFUBb
	TgCaKg8jZepibM0NvN9nr3AFUDiqeJx4zbs0j/AVVjA7BGMyCSrQK3ri2d14q7z1
	HOZM7b5vQwGl2D9ssUD+an4AQ+nt3GqCepHZ0NkGyhIT7Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jRKN8NAnS3rg; Mon, 18 Aug 2025 16:25:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c5J421jPfzm0yV4;
	Mon, 18 Aug 2025 16:25:53 +0000 (UTC)
Message-ID: <1a108058-87d9-487b-aca3-adea737a6f19@acm.org>
Date: Mon, 18 Aug 2025 09:25:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, hare@suse.com
References: <20250811173634.514041-1-bvanassche@acm.org>
 <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
 <d4151040-ab1a-4b3c-b5f9-577e907b43fc@acm.org>
 <ff0705fe-0bac-408e-a073-a833525dabf8@oracle.com>
 <e651aa7e-aad2-4e4e-afff-3e89a61f13f9@acm.org>
 <71a41bd0-1243-4fb3-ae83-c2cfae229296@oracle.com>
 <5a5c975e-9514-4adf-9888-4149e6d201a0@acm.org>
 <34d25450-ecbc-41c3-bfab-ba7598849886@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <34d25450-ecbc-41c3-bfab-ba7598849886@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/25 1:37 AM, John Garry wrote:
> On 15/08/2025 18:30, Bart Van Assche wrote:
>> On 8/15/25 12:50 AM, John Garry wrote:
>>> Anyway, here is a reference implementation:
>>> https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send- 
>>> email- john.garry@huawei.com/
>>
>> The description of that patch says what the patch does but not why the
>> .reserved_queuecommand() function pointer is introduced.
> 
> Motivation:
> 
> Any driver which supports reserved commands will need to have a check 
> for reserved command in the .queuecommand callback (for special 
> handling). In addition, some more general reserved command handling will 
> prob need to be added to scsi_dispatch_cmd().
> 
> As such, having common handling for reserved commands in 
> scsi_dispatch_cmd() makes sense (so that each LLD does not have to 
> duplicate handling).

Hi John,

Thanks for having explained the purpose of that patch. Although that
patch will make it harder to integrate .queue_rqs() support in the SCSI
core, I will look into integrating that patch in this patch series.

Thanks,

Bart.
