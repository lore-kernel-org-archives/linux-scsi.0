Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C71420E334;
	Tue, 21 Jul 2026 11:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784632235; cv=none; b=q1fhMNTo7E9g3639TVfDq/R5vgJyxXq7rc6braqJuhkpu30+Nuwa9i1i3jpB6fNKsFJDjk70hcuYt/x0BK1/3bKW0bqWYSknEzy6JwXMsvPi5KJ/QWpu7eDOzBgIyQnydVZe6NezSFBDvRR7hG1RIPdp2Y2WdfemveIOzZFIaLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784632235; c=relaxed/simple;
	bh=e+XmcQJFlNH9BejvMnQCksa7kAn7PyTrlARyyVXgc3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=fs81hVGCav1+WeTIJOEP6g8ZZRT+7/R4lz6t723kI1BEs3GJTVJOU3RGLAeFLMRnQrFm0YU2U5BCUFSfSbaBXLDIbMtHcSX617fhnW499KQ3VDwBXM8gkUS/vGDHzsr8eXsSq54CFDq+htysbCCpl00YzkmPBZ9JPL+umElw6SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=WuCbUzA6; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="WuCbUzA6"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YdteU8ICcIeZHwg1Hfao03dSi3WvdaW7XcPistsvvgY=;
	b=WuCbUzA6TFkc27liu1PSC4WzKqJTfmB0O9/b+47fhwa0yiA7CYrdoxwSG/Iw3KbHiThdN/PWm
	3pYFibu+Mwfh3XKJ7j0lk7G60OmUO/Xriwk3WZRsGJsDq/jFAJGHHWrCVusW9Ty9xeeFCtZ/qyU
	xRHQrq5hl+GNkCNSYK7TfxQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h4Dvg70KzzKmWD;
	Tue, 21 Jul 2026 19:01:03 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D61840578;
	Tue, 21 Jul 2026 19:10:28 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 21 Jul 2026 19:10:27 +0800
Message-ID: <55307987-d86b-f28c-7c39-0a6bafe182bb@huawei.com>
Date: Tue, 21 Jul 2026 19:10:27 +0800
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
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <c9a91dd7-b158-4416-93bb-9ae1e1acb8a3@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh200004.china.huawei.com (7.202.181.111) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/7/20 17:47, John Garry wrote:
> +
> 
>> +void hisi_sas_spinup_notify(struct scsi_device *sdev)
>> +{
>> +    struct domain_device *dev = sdev_to_domain_dev(sdev);
>> +    struct sas_ha_struct *sha;
>> +    struct hisi_hba *hisi_hba;
>> +    struct sas_phy *local_phy;
>> +    struct hisi_sas_phy *phy;
>> +
>> +    if (dev->parent && dev_is_expander(dev->parent->dev_type))
>> +        return;
>> +
>> +    sha = SHOST_TO_SAS_HA(sdev->host);
>> +    hisi_hba = sha->lldd_ha;
>> +
>> +    local_phy = sas_get_local_phy(dev);
>> +    phy = &hisi_hba->phy[local_phy->number];
>> +    if (phy->identify.target_port_protocols & SAS_PROTOCOL_SSP)
>> +        hisi_sas_notify_phy_event(phy, HISI_PHYE_SPINUP_NOTIFY);
>> +    sas_put_local_phy(local_phy);
>> +}
>> +EXPORT_SYMBOL_GPL(hisi_sas_spinup_notify);
> This could go in libsas

Hi, John.
Are you suggesting that we add an event like `PHYE_NOTIFY_ENABLE_SPINUP` 
and a callback like `lldd_notify_enable_spinup` to libsas? If so, should 
libsas parse the sense data directly—for instance, by handling it within 
the `sas_ssp_task_response()` function?

Thanks,
Xingui
