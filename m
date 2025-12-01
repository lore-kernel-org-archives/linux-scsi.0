Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7718430BB94;
	Mon,  1 Dec 2025 13:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764595689; cv=none; b=RQZebqwOTvuND62Aco0tvNty7mRh6Ar9lFntEHUIvxlw33JrgylG00hfHKdmVpkva3Y3CmkHshoHbl17DzdaYZ4m+yf4m9rjRDM8t/BKt8C/kmJSnsKoXaX7Tg+I0XobcUSLIH2LyqdtgQIFEAtZ4zJJoK454qCFKn8oGCHvW38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764595689; c=relaxed/simple;
	bh=0oN6DuZeHipz1dxgIofiRa+yv2GlS6zcOwdlkVgTeDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XVWAJWbeAO8DszF/sdDju7KGSIyN87UtSCJ3LqeRmj4lbF+hfYq+cfDkPGnghLVk7LJCvE7CGSwW53SI66F8VCjDdmAY4/p1ffboWjXkxdzQu7cSb1iWvw60xTUhi3XXikmAe9lMrgQWrefqoaA6ZkAVUPSoMrSw1U/1X4CF3Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=KMMPEp8q; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="KMMPEp8q"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/0hadbzVvYI9WB7qc6D3FIo3eb72MCXxRfKRPGtO6mg=;
	b=KMMPEp8qNp+le30zEJ8SRD8Sub+WQT/rEX1OWpoCVXHGSRsb56w5CezLnaXLOHz8LDOXPVULh
	lGfO5Z1LRanmjGaNeVjISfB3JH14q9waLQj38iJT9Glgodk0PCMua/wtf99pmKGfBZ0cgumoChA
	TwfsahyfLzRnuVEt66rkZaw=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dKl5z6Zphz1cyPF;
	Mon,  1 Dec 2025 21:25:59 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 53B1F14011F;
	Mon,  1 Dec 2025 21:27:51 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 1 Dec 2025 21:27:50 +0800
Message-ID: <78a9384c-7a1d-43b7-a16f-d0bc6863fd1e@huawei.com>
Date: Mon, 1 Dec 2025 21:27:49 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after
 probe failure scanned in again after probe failed"
To: John Garry <john.g.garry@oracle.com>, yangxingui <yangxingui@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20251021073438.3441934-1-yangxingui@huawei.com>
 <88a3dd70-69a7-affd-8495-9333f95350d0@huawei.com>
 <ef93ed19-9a94-4652-b220-cf88e5b57b69@oracle.com>
 <8911e1d8-98d3-9c1d-1329-c9dd78cda45e@huawei.com>
 <1c2341ae-ffda-412a-af7f-5458e621fa33@oracle.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <1c2341ae-ffda-412a-af7f-5458e621fa33@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/12/1 20:51, John Garry 写道:
> On 27/11/2025 07:27, yangxingui wrote:
>> Hi, John
>>
>> I'm glad to receive your reply.
>>
>> On 2025/11/27 14:47, John Garry wrote:
>>> On 27/11/2025 00:59, yangxingui wrote:
>>>> Kindly ping for upstream.
>>>>
>>>> On 2025/10/21 15:34, Xingui Yang wrote:
>>>
>>> Your reasons for revert is light on details.
>>>
>>>>> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
>>>>>
>>>>> As the disk may fall into an abnormal loop of probe when it fails 
>>>>> to probe
>>>>> due to physical reasons and cannot be repaired.
>>>
>>> So for a faulty disk we get into a indefinite loop, right?
>> Yes, because a hard reset for SATA disk is executed during the error 
>> handler, a BC event will be received after the disk probe fails, and 
>> the probe will be re-executed on the disk.
> 
> You need to add these details to the commit log.
> 
>>>
>>> What about case where this was helping before?
>> A temporary fault injected into the disk or link, which can be 
>> recovered after a short time.
> 
> I'm ok with this if Jason is...

I think we can merge this patch first and fix the previous issue later 
because this issue is more critical. So:

Reviewed-by: Jason Yan <yanaijie@huawei.com>
