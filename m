Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D250D13BC3C
	for <linux-scsi@vger.kernel.org>; Thu,  9 May 2024 03:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715226777; cv=none; b=KDy4Q3IgM7/6+LS5rIHv8qPLX62NEohXAGhWPvsSQ7emjJaCeXrQKn5JQURQGIqfGE1HQJA84Z9AzeCOi4uw0Eav884PZH87HU1pk/1zSkO0ROuJegLjmyJmJmaH1Fy7DVAXo4qzOz0kjmMkzLVRIxqcJwhnrxyCiQzB8qwWFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715226777; c=relaxed/simple;
	bh=ze7qEioftqx5LL7FJOIJRd8F0TFzml7UeGuxfuguLBU=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=T5V2WQc0wOAusRWJ5HYbYtkbvitq/YE0IxyvtEGtkE1kpWYIWksXfC619orrqsDzHdk0e5bhQ5hGyccP+OqftgXQTu346fcu96Bbjp5F2deCKdlAEAKJBxz1eOT2ZxA4mj57oz+NtEoNSKDsSfiPl5z0wSHyTsxOoGaNzTdb+iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VZdLF1gzVztTSl;
	Thu,  9 May 2024 11:49:25 +0800 (CST)
Received: from canpemm500003.china.huawei.com (unknown [7.192.105.39])
	by mail.maildlp.com (Postfix) with ESMTPS id 2109A1400D7;
	Thu,  9 May 2024 11:52:52 +0800 (CST)
Received: from canpemm500004.china.huawei.com (7.192.104.92) by
 canpemm500003.china.huawei.com (7.192.105.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 11:52:51 +0800
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 9 May 2024 11:52:51 +0800
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>, John Garry
	<john.g.garry@oracle.com>, "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
 <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
 <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <0c4ea5fd-9013-4ade-0597-b42626fe5757@huawei.com>
Date: Thu, 9 May 2024 11:52:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)

On 2024/5/8 16:29, Li, Eric (Honggang) wrote:
>> -----Original Message-----
>> From: John Garry <john.g.garry@oracle.com>
>> Sent: Wednesday, May 8, 2024 3:48 PM
>> To: Li, Eric (Honggang) <Eric.H.Li@Dell.com>; Jason Yan <yanaijie@huawei.com>;
>> james.bottomley@hansenpartnership.com; Martin K . Petersen <martin.petersen@oracle.com>
>> Cc: linux-scsi@vger.kernel.org
>> Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS expanders in a domain
>>
>>
>> [EXTERNAL EMAIL]
>>
>> On 08/05/2024 01:59, Li, Eric (Honggang) wrote:
>>>>> Call to sas_ex_join_wide_port() makes the rest PHYs associated with
>>>>> that existing port
>>>> (making it become wideport) and set up sysfs between the PHY and
>>>> port. > Set PHY_STATE_DISCOVERED would make the rest PHYs not being
>>>> scanned/discovered again (as this wide port is already scanned).
>>>>
>>>> If you can just confirm that re-adding the code to set phy_state =
>>>> DISCOVERED is good enough to see the SAS disks again, then this can
>>>> be further discussed. >>
>>> OK. I will work on that and keep you updated.
>>
>> I expect a flow like this for scanning of the downstream expander:
>>
>> sas_discover_new(struct domain_device *dev [upstream expander], int
>> phy_id_a) -> sas_ex_discover_devices(single = -1) ->
>> sas_ex_discover_dev(phy_id_b) for each phy in @dev non-vacant and non-discovered ->
>> sas_ex_discover_expander( [downstream expander]) for first phy scanned which belongs to
>> downstream expander.
>>
>> And following that we have continue to scan phys in sas_ex_discover_devices(single = -1) ->
>> sas_ex_discover_dev(phy_id_b) ->
>> sas_ex_join_wide_port() ->  for each non-vacant and non-discovered phy in phy_id_b which
>> matches that downstream expander.
>>
>> Can you see why this does not actually work/occur?
>>
> 
> before calling sas_ex_join_wide_port(), sas_dev_present_in_domain() finds the attached_sas_address of PHY (phy_id_b) is already in the domain of that root port, and then disable all PHYs to that downstream expander (in sas_ex_disable_port(dev, attached_sas_addr))
> Therefore, I think we need to switch the order of function call to sas_ex_join_wide_port() and sas_dev_present_in_domain().

If this is true then all cascaded expanders will have this issue, I 
wonder why the test guys have not report it until now.

Thanks,
Jason

祝一切顺利

> 
