Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25393E4C62;
	Fri, 15 May 2026 08:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778835533; cv=none; b=ktHOSsK1dcGHk6xdfu33J+qiKoqvWHayh/ydPzcyCNctdmysNP+tH1sDRZaJsHEsdLBlXYn2DxCk2F/wsub1A/JPOI82YIAwais5bUFpF3csMNN8+DALxnGzLdykNBdfG/JcLZ4tL+ve3YHAudDHEXXsDOM6pdkPa7pO9ViQHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778835533; c=relaxed/simple;
	bh=EVtamznznwlgDcC/y8UYy3Z1+X8I0QtMM/Kb4QMrrME=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iD/wQaTIXoxGksW1apBlT7wW7mcSchQ//n7B60EcCepY2VePsefARpPMBrny5U9mEmRwvc614jK/hHXOvFA8nzlg6ixe0k0jl7w5dfCTTHVFi1A3sAyCCM2fNz+gkGX4IRBHvvjzMJBahRXQFt2Dr/KYBBBdDpOC0hGDABoalL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=mIiuGACN; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="mIiuGACN"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aXVlpQtJKwL25iI4nbjMjgxjr+oLWWvc25k/Wfc4iYc=;
	b=mIiuGACNq6MpEpyCSohsygC4in86jgssi+Gy9HPYNFtA6geMjHAxdb/ZpGc9H3/cx8rqYfFVT
	scxtObnhxFVOloYfJF/V1F7Atb+v37vyZvYyFAwfYE+XJH4+FHYfhTBOZPscF8f0B0dndWvs0YL
	f3wO65cBwbc6qN8sczebfdY=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gH1CM3mq6zpTJN;
	Fri, 15 May 2026 16:51:43 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A9A52025F;
	Fri, 15 May 2026 16:58:48 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 15 May 2026 16:58:47 +0800
Message-ID: <ba3629cb-e193-5892-1f47-7e675931f744@huawei.com>
Date: Fri, 15 May 2026 16:58:47 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 0/3] scsi: libsas: handle linkrate change in
 sas_rediscover_dev
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260513021603.3023329-1-yangxingui@huawei.com>
 <11d3560e-d956-4f0d-abc6-2ed897e0ce45@oracle.com>
 <391ec8d3-3bf7-16fc-774a-96c917c67d56@huawei.com>
 <c4e4c99f-a13c-4e28-8650-48be1f96d7cf@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <c4e4c99f-a13c-4e28-8650-48be1f96d7cf@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh500016.china.huawei.com (7.202.181.150) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/5/14 17:35, John Garry wrote:
> On 13/05/2026 09:14, yangxingui wrote:
>>
>>
>>
>> On 2026/5/13 15:29, John Garry wrote:
>>> On 13/05/2026 03:16, Xingui Yang wrote:
>>>> When a device attached to an expander phy experiences a linkrate change
>>>> (e.g., due to cable reconnection or negotiation), the current code in
>>>> sas_rediscover_dev() treats it as "broadcast flutter" and takes no 
>>>> action
>>>> if the SAS address and device type remain unchanged.
>>>
>>> Can sas_rediscover_dev() check the linkrate (vs expected) to 
>>> understand that this flutter has renegotiated the linkrate and then 
>>> consider it not just a flutter?
>>
>> Hi, John
>> Theoretically, it is possible. As early as 2019, Jason attempted to 
>> propose the solution you mentioned. He conducted a relatively 
>> comprehensive assessment for flutter, including scenarios where the 
>> SAS address changes or the ATA ID changes. However, in actual use, 
>> such situations almost never occur unless there is an extremely short 
>> time window during which the drive is swapped or a new SATA drive is 
>> replaced. Because this solution is associated with other modifications 
>> and may have significant impacts, it has not been adopted.
>>
>> https://urldefense.com/v3/__https://lore.kernel.org/linux- 
>> scsi/20190130082412.9357-6-yanaijie@huawei.com/__;!!ACWV5N9M2RV99hQ! 
>> K7CIIOxMVXErIMxcZlvm10YX3EVqp0rhSbh_ARyqnaFDmtaqqJtoLTJQui0- 
>> Ox_URh97f8oyREG8htBVo2aC3Ew$
>> Currently, scenarios involving changes in linkrate are relatively more 
>> common, and such situations can be easily reproduced by manually 
>> adjusting the linkrate by sysfs. Therefore, a less impactful 
>> synchronous update solution was adopted.
>>
> 
> What Jason did was to check if same device for flutter, which is not 
> really the same thing as what you want.
> 
> I just don't like these special case callbacks which you propose, as 
> they seem fragile and too specialized.
> 
> Is it possible to just check the linkrate and mark the device as gone 
> and rediscover when this flutter occurs occurs?

Hi, John.
I have updated a new version according to your suggestions.

Thanks,
Xingui
.

