Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6110F19C556;
	Tue,  2 Dec 2025 07:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764658859; cv=none; b=u9qXCm+TREIY6WCh4rezii2k1nUwfiPGy2SUO+ma8fuO2jZYe/OGH1Wlk2xinZlMUsBm9u3VC4VIVGe2NBtz8mjZbr7xHLjEF3gLiYkcbcNn8AwbE7g4lbaK6XzCGoMg/02uKDjxgeHzcDw4LY5ibum/yyOr+/LPu3uiMg8EOxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764658859; c=relaxed/simple;
	bh=O5C9+q9B82d+E7fupEUSTFiuht3DMCrOlPEtXZag10I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uZ7x2847wFDXg+wwbjOU0PMcjdMU+Ymf/aJCib8xrONosiuz/H7dyDpVO51iCMN0GGXSgjoCzT1QOAiwlhF1y+6WiCkpZXHWFORuOMTyvetO5nkKQ1FOyfTRn/HFmSoIfI4r/+mn/0K08KXsFu41fXKvmafefOEu+AYflyACCws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=EYg9XyiX; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="EYg9XyiX"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Tb5v2eVzayH5ifHUNTXZSH8uQI01+V4aEYe+rtjiTJ0=;
	b=EYg9XyiXCWNE2Pup8gHj5E6nixUfehGzIYfYkklzd7oKKdsCPm0JaAnmlqTAh+/MLBhwRBnzB
	wF7NkpZFadLdutWZ8ErX8HVYa8bO/4eAWfPk8yLtKuHHndeuW8rRc/Fid7gqed9XPMR0klOelpV
	PwV/A0FCh9NR9WPjIP1nDCg=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dLBSt5sxnz1prKT;
	Tue,  2 Dec 2025 14:58:54 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 927601804F7;
	Tue,  2 Dec 2025 15:00:47 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Dec 2025 15:00:46 +0800
Message-ID: <4ad97a1e-7d84-9b49-bf6a-9a21bdae4d29@huawei.com>
Date: Tue, 2 Dec 2025 15:00:46 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] Revert "scsi: libsas: Fix exp-attached device scan after
 probe failure scanned in again after probe failed"
Content-Language: en-CA
To: Jason Yan <yanaijie@huawei.com>, John Garry <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20251021073438.3441934-1-yangxingui@huawei.com>
 <88a3dd70-69a7-affd-8495-9333f95350d0@huawei.com>
 <ef93ed19-9a94-4652-b220-cf88e5b57b69@oracle.com>
 <8911e1d8-98d3-9c1d-1329-c9dd78cda45e@huawei.com>
 <1c2341ae-ffda-412a-af7f-5458e621fa33@oracle.com>
 <78a9384c-7a1d-43b7-a16f-d0bc6863fd1e@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <78a9384c-7a1d-43b7-a16f-d0bc6863fd1e@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh100009.china.huawei.com (7.202.181.94) To
 kwepemj100018.china.huawei.com (7.202.194.12)

On 2025/12/1 21:27, Jason Yan wrote:
> 在 2025/12/1 20:51, John Garry 写道:
>> On 27/11/2025 07:27, yangxingui wrote:
>>> Hi, John
>>>
>>> I'm glad to receive your reply.
>>>
>>> On 2025/11/27 14:47, John Garry wrote:
>>>> On 27/11/2025 00:59, yangxingui wrote:
>>>>> Kindly ping for upstream.
>>>>>
>>>>> On 2025/10/21 15:34, Xingui Yang wrote:
>>>>
>>>> Your reasons for revert is light on details.
>>>>
>>>>>> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
>>>>>>
>>>>>> As the disk may fall into an abnormal loop of probe when it fails 
>>>>>> to probe
>>>>>> due to physical reasons and cannot be repaired.
>>>>
>>>> So for a faulty disk we get into a indefinite loop, right?
>>> Yes, because a hard reset for SATA disk is executed during the error 
>>> handler, a BC event will be received after the disk probe fails, and 
>>> the probe will be re-executed on the disk.
>>
>> You need to add these details to the commit log.
>>
>>>>
>>>> What about case where this was helping before?
>>> A temporary fault injected into the disk or link, which can be 
>>> recovered after a short time.
>>
>> I'm ok with this if Jason is...
> 
> I think we can merge this patch first and fix the previous issue later 
> because this issue is more critical. So:
> 
> Reviewed-by: Jason Yan <yanaijie@huawei.com>
> .

Ok, I have resent a new version and update the commit log.

Thanks,
Xingui
.
