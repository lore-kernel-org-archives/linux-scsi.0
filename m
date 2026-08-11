Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC9613D51E;
	Tue, 11 Aug 2026 03:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786417384; cv=none; b=mykxlOcp9jG6U/i+XjdDvlj3PGbrc5eQ+dgewe0/jhYmchleE4o9jKuJaveNnvdUR3ArzdH4jIGOgUtkMgODCEBfWDL9bKusHfqt6goOl7DZR5MZGuqRwixLulW4mo/X4B/gCeZPrGWh/FULrd6H7ISmhTc6J9+ysSBNLAe7wWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786417384; c=relaxed/simple;
	bh=8Td/ok4h6UkvSbyt0QoFfSKcdK9isfEBb2B8LGA1418=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=meQzpdjMKEDEMQHypX3845yYnAzcijd1N50ymtU9UeKn/0k58Q45E8/IeO7cqqANpTMBIODoeEdJCQkwZ55g0bF/8+ni8jjpO+7OSGl+6j0o3QzTH1EDhnJO23U+v6jnltPuPtpfsJbZ70HLilMVeB+evznzPVLWZF7zRICMT1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=M+iwAcca; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="M+iwAcca"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bmHhHqDRMLtjlZBcLecaYF/tXN6si5roWjmCL8ISvo8=;
	b=M+iwAcca8MqKT/UXR9+PKLRlvgWFsGF0LsY/vym9dI2QaC3l6oTO6BFxUdYC9xGaKT/K2iKsd
	GYd9ltfDPMqJQthsELVpq68lZ3wm02MSf4Ongekq7RbJO1SA3aGJXD8hcjDZaOUxGS/ee7cUinn
	eNkDQu6TChEid4l0mZZiy5w=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hJx401ly4z1cyR8;
	Tue, 11 Aug 2026 10:52:16 +0800 (CST)
Received: from kwepemp500005.china.huawei.com (unknown [7.202.195.153])
	by mail.maildlp.com (Postfix) with ESMTPS id ACB804056C;
	Tue, 11 Aug 2026 11:02:51 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500005.china.huawei.com (7.202.195.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 11:02:51 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 11:02:50 +0800
Message-ID: <e7980d39-09e6-19db-2514-d45a7448045a@huawei.com>
Date: Tue, 11 Aug 2026 11:02:50 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v9 1/2] scsi: libsas: refactor sas_ex_to_ata() using new
 helper sas_ex_to_dev()
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260624063230.3264029-1-yangxingui@huawei.com>
 <20260624063230.3264029-2-yangxingui@huawei.com>
 <11581a25-caa6-4ea3-9aa0-2a4dacb7f34e@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <11581a25-caa6-4ea3-9aa0-2a4dacb7f34e@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh200012.china.huawei.com (7.202.181.121) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi John,

Thanks for the review.

On 2026/8/10 23:51, John Garry wrote:
> On 24/06/2026 07:32, Xingui Yang wrote:
>> Introduce sas_ex_to_dev() to return any device type attached to an
>> expander phy. The new helper is then used by sas_ex_to_ata() to reduce
>> code duplication.
>>
>> Also add a defensive NULL check for ex_dev to guard against callers
>> passing a NULL device.
>>
> 
> Why would someone want to lookup a device attached to an expander device 
> which is NULL? If this is possible later, then mention it.

No current caller passes a NULL ex_dev. The check was added in v7 based 
on an automated Sashiko AI review suggestion, which may contain some 
noise. Removed in v10.

>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 19 ++++++++++++++-----
>>   drivers/scsi/libsas/sas_internal.h |  1 +
>>   2 files changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index f471ab464a78..fc6d8f3c9dca 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -345,13 +345,16 @@ static void sas_set_ex_phy(struct domain_device 
>> *dev, int phy_id,
>>            SAS_ADDR(phy->attached_sas_addr), type);
>>   }
>> -/* check if we have an existing attached ata device on this expander 
>> phy */
>> -struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int 
>> phy_id)
>> +/* return the domain device attached to an expander phy */
>> +struct domain_device *sas_ex_to_dev(struct domain_device *ex_dev, int 
>> phy_id)
>>   {
> 
> sas_ex_phy_to_dev() seems a better name, as sas_ex_to_dev() is quite 
> vague. I know that it matches sas_ex_to_ata(), but it is not a good 
> pattern to match.

Ok, Renamed to sas_ex_phy_to_dev() for consistency with 
sas_ex_phy_discover() and other phy-related helpers.


Thanks.
Xingui

