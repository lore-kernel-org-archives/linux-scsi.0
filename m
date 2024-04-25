Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB1014A8F
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 02:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714013869; cv=none; b=RXoDmWH7GEF7rsW5tYzopkQL2v6Xur6edJofZuOw3+O2O5NWAXpCs75123k0iMK99uArzmskTuQ8gX+qxtOulBe4p4jC/3KZ5CHyjxYGtD2IoE5+7JeGILqGb3quSVxFte+TFRsVQv87cDRVeBMhgBtZrbSUkL4IPjIfllsWCms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714013869; c=relaxed/simple;
	bh=mOaX0aN5GdQ+4he2dbSA3m4paQF6TH+COfTE/KmsZtk=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YYV1RWVIlN+iOLl+oXMIlK/hfeh+DIhe64D2T5GytuYoPWzd16A/IabI6o+z5lXvZPBoodIShQQmppx8RUFnnvUR+BbHkBxOwyxbHTc+Fay+uIkFjyR1OyDEQx8ymB77KbEN0ZoJwKpRMNS6P55kBDYb+pYuH7K0QVJZX60UOdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VQ0p82F4Bz1ymc4;
	Thu, 25 Apr 2024 10:55:12 +0800 (CST)
Received: from canpemm100003.china.huawei.com (unknown [7.192.104.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C9651401E9;
	Thu, 25 Apr 2024 10:57:44 +0800 (CST)
Received: from canpemm500004.china.huawei.com (7.192.104.92) by
 canpemm100003.china.huawei.com (7.192.104.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 10:57:43 +0800
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 10:57:43 +0800
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: John Garry <john.g.garry@oracle.com>, "Li, Eric (Honggang)"
	<Eric.H.Li@Dell.com>, "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <b1a5552c-689e-d220-88d3-56d24752be5b@huawei.com>
Date: Thu, 25 Apr 2024 10:57:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500004.china.huawei.com (7.192.104.92)

On 2024/4/24 18:46, John Garry wrote:
> On 24/04/2024 09:59, Li, Eric (Honggang) wrote:
>> Hi,
>>
>> There is an issue in the function sas_ex_discover_dev() when I have 
>> multiple SAS expanders chained under one SAS port on SAS controller.
> 
> I think typically we can't and so don't test such a setup.

Eric,

I also don't understand why you need such a setup. Can you explain more 
details of your topology?

> 
>>
>> In this function, we first check whether the PHY’s 
>> attached_sas_address is already present in the SAS domain, and then 
>> check if this PHY belongs to an existing port on this SAS expander.
>> I think this has an issue if this SAS expander use a wide port 
>> connecting a downstream SAS expander.
>> This is because if the PHY belongs to an existing port on this SAS 
>> expander, the attached SAS address of this port must already be 
>> present in the domain and it results in disabling that port.
>> I don’t think that is what we expect.
>>
>> In old release (4.x), at the end of this function, it would make 
>> addition sas_ex_join_wide_port() call for any possibly PHYs that could 
>> be added into the SAS port.
>> This will make subsequent PHYs (other than the first PHY of that port) 
>> being marked to DISCOVERED so that this function would not be invoked 
>> on those subsequent PHYs (in that port).
>> But potential question here is we didn’t configure the per-PHY routing 
>> table for those PHYs.
>> As I don’t have such SAS expander on hand, I am not sure what’s impact 
>> (maybe just performance/bandwidth impact).
>> But at least, it didn’t impact the functionality of that port.
>>
>> But in v5.3 or later release, that part of code was removed (in the 
>> commit a1b6fb947f923).
> 
> Jason, can you please check this?

The removed code is only for races before we serialize the event 
processing. All PHYs will still be scanned one by one and add to the 
wide port if they have the same address. So are you encountering a real 
issue? If so, can you share the full log?

Thanks,
Jason

祝一切顺利！

> 
> Thanks!
> 
>> And this caused this problem occurred (downstream port of that SAS 
>> expander was disabled and all downstream SAS devices were removed from 
>> the domain).
>>
>> Regards.
>> Eric Li
>>
>> SPE, DellEMC
>> 3/F KIC 1, 252# Songhu Road, YangPu District, SHANGHAI
>> +86-21-6036-4384
>>
>>
>> Internal Use - Confidential
> 
> .
