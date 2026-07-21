Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A292505AA;
	Tue, 21 Jul 2026 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640814; cv=none; b=EeWhSKiNDwx1HXUMpJ8hHn/Ki9tdMF6fiDz7WBngfeToylJ68hCqCHksxAyam1OY8sP8rvrNiN3UfkeU4evof7g4cJvYBiKRo2B34t+JwCUJz0uXZ2xvYLELVvEUnHgRyGXONfUxwpSikNkWqpNS19D9JVRIbrykJjhnb35Mptc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640814; c=relaxed/simple;
	bh=DR+L7n4Xf+A5V6ZVMtxzikHCSzPYGT2UsPxSPX3CHd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=D9DOdwCIO2xA158SWV/L952woXIWDZgQhUqvPzyOmEptsTIrZIfymDMCCEifEIG58MR0wSWXDkyXVlbrpdYQ+fVyG77lvvYRQJAL4GMumr223fIGj3XFEcnO7MTe1qA81+AbKaAfmQBq6nLsfmmAC93/JVhPBkS9jlMrekpzwdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=o6EQi0Rb; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="o6EQi0Rb"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=raPCYR2N6e3oPXhADVO/PiTQ6pXOoNY81CcEkkgMVGA=;
	b=o6EQi0RbpNuNJm5KuzaBk1qqVNmlHIFIfGNA7MslUd6pPK4kwp+5C1iELZr6+bpazow52//9r
	uujy2tpeoIKiBPe6X60hH7E1F61s5kBdCG4gr6W7z6qzBbesY2q7WgzxDLEBrF2hCBGWVOcECTi
	DTuQF5qID9MDd2jnReTivVc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4h4J4l5bjqz1T4GB;
	Tue, 21 Jul 2026 21:24:07 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 304F040579;
	Tue, 21 Jul 2026 21:33:27 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 21 Jul 2026 21:33:26 +0800
Message-ID: <7baf77e4-345b-3419-6562-f0e435227e5a@huawei.com>
Date: Tue, 21 Jul 2026 21:33:25 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 2/2] scsi: hisi_sas: add spinup_notify callback to
 handle Active_Wait/Idle_Wait SSP devices
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<dlemoal@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<hare@suse.com>
References: <20260703022833.36847-1-yangxingui@huawei.com>
 <20260703022833.36847-3-yangxingui@huawei.com>
 <c9a91dd7-b158-4416-93bb-9ae1e1acb8a3@oracle.com>
 <55307987-d86b-f28c-7c39-0a6bafe182bb@huawei.com>
 <a2ecff55-aabd-48b4-a702-7e052646f22c@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <a2ecff55-aabd-48b4-a702-7e052646f22c@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500005.china.huawei.com (7.202.181.135) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/7/21 20:33, John Garry wrote:
> On 21/07/2026 12:10, yangxingui wrote:
>>
>>
>> On 2026/7/20 17:47, John Garry wrote:
>>> +
>>>
>>>> +void hisi_sas_spinup_notify(struct scsi_device *sdev)
>>>> +{
>>>> +    struct domain_device *dev = sdev_to_domain_dev(sdev);
>>>> +    struct sas_ha_struct *sha;
>>>> +    struct hisi_hba *hisi_hba;
>>>> +    struct sas_phy *local_phy;
>>>> +    struct hisi_sas_phy *phy;
>>>> +
>>>> +    if (dev->parent && dev_is_expander(dev->parent->dev_type))
>>>> +        return;
>>>> +
>>>> +    sha = SHOST_TO_SAS_HA(sdev->host);
>>>> +    hisi_hba = sha->lldd_ha;
>>>> +
>>>> +    local_phy = sas_get_local_phy(dev);
>>>> +    phy = &hisi_hba->phy[local_phy->number];
>>>> +    if (phy->identify.target_port_protocols & SAS_PROTOCOL_SSP)
>>>> +        hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY);
>>>> +    sas_put_local_phy(local_phy);
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
>>> This could go in libsas
>>
>> Hi, John.
>> Are you suggesting that we add an event like 
>> `PHYE_NOTIFY_ENABLE_SPINUP` and a callback like 
>> `lldd_notify_enable_spinup` to libsas? If so, should libsas parse the 
>> sense data directly—for instance, by handling it within the 
>> `sas_ssp_task_response()` function?
> 
> Yeah, it would be something like that.
> 
> But the method to solve this issue is unclear.
> 
> Back to the original issue: hisi_sas_spinup_notify_work() calls 
> sl_notify_ssp, but sl_notify_ssp is called already in 
> hisi_sas_phyup_work_common() - so why is it needed to be called again? 
In fact, the trigger for this point sometimes fails to take effect.

> If it is because hisi_sas_phyup_work_common() is only for 
> direct-attached disks, and we need to call sl_notify_ssp for expander 
> attached disks?

NOTIFY(SPIN UP) is primarily intended for direct-attached HDD wake-up 
post-IDENTIFY exchange. Routing it to an Expander may conflict with SAS 
topology constraints and could disrupt link-layer arbitration, 
indicating that a conditional disable mechanism for cfg_notify_en in 
non-direct topologies is advisable.

Thank,
Xingui
.

