Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD5E74C14;
	Thu, 11 Jun 2026 01:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781141678; cv=none; b=f4K/WyngMC8m29b0XfoASmJNIGB5icNQK5f96kCfLT8W15TxM7YwF2PVmJrxWsl5hzWLbSSplDiPs60tx8R4GzoowgcwReKVNPES7MySUrq7s7EGNRRYcmbDy7GzJKPK3kaIZFHAnnXVoHIWhD2X2FTo0bspFUgb8Y0sAVpbzvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781141678; c=relaxed/simple;
	bh=r10PDlkogS5LBwV4B2rLhiwz+xRI3htAOVIJcXTYa+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DZZ1W8A2iK/nq65/L2UChs0BhbeZL44d+5YP7dcXSunF8rWIoPVA3buhjFjTFMX3Xb02dO+mlTuWI57IjpotMpx5HwjfXO5Il81qxNzBKDMCd0Vm2xflTPfJQ6XqxnvqyMu6FEz331r4m7OiZIxZaiNBPEDqQlaFlg8XQ48p10M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=YKTNrkQX; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="YKTNrkQX"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VHBRk+HjEpMLYhoU5qeYaEsvvHZ40VXCd1+Fxt6C0Hw=;
	b=YKTNrkQXP+3oXBOkOMnQTrFK5K+y2+DD2b25eUzNNu5qhDdX2g9kHkfe8wCwOSZbN4QbV+TWc
	FZQgzpMsbiwqkg6eYOfA2stjLlEOKmmYyCJbkYCQOIc6ey370toRT5fRNcEP1FRum6OrEnaw4OC
	iMXIaVDqIrYe1pON0CI/WU0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gbQ2z3zCjzcb1Y;
	Thu, 11 Jun 2026 09:26:19 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id B3FA74048F;
	Thu, 11 Jun 2026 09:34:32 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 11 Jun 2026 09:34:32 +0800
Message-ID: <2e082951-bdd6-564e-30a8-2ab21c9c2215@huawei.com>
Date: Thu, 11 Jun 2026 09:34:31 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v6 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260603092124.2221524-1-yangxingui@huawei.com>
 <20260603092124.2221524-3-yangxingui@huawei.com>
 <f51b19e3-0848-4384-85d7-8fe7a7b11754@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <f51b19e3-0848-4384-85d7-8fe7a7b11754@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500016.china.huawei.com (7.202.181.150) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/6/10 17:37, John Garry wrote:
> On 03/06/2026 10:21, Xingui Yang wrote:
>> +        return false;
>> +    } else if (SAS_ADDR(child_dev->sas_addr) != 
>> SAS_ADDR(phy->attached_sas_addr)) {
>> +        pr_info("ex %016llx phy%02d sas_addr changed from %016llx to 
>> %016llx\n",
>> +            SAS_ADDR(dev->sas_addr), phy_id,
>> +            SAS_ADDR(child_dev->sas_addr),
>> +            SAS_ADDR(phy->attached_sas_addr));
>> +        memcpy(phy->attached_sas_addr, child_dev->sas_addr, 
>> SAS_ADDR_SIZE);
> 
> can you comment in the code why you are going this?

Good point. I will add a comment explaining the reason.

sas_ex_phy_discover() has already updated phy->attached_sas_addr to the
new address discovered from the expander. However, 
sas_unregister_devs_sas_addr()
matches devices by comparing child->sas_addr with phy->attached_sas_addr
via sas_phy_match_dev_addr(). So we need to restore phy->attached_sas_addr
to the old device's address for proper matching.

I will update in next version.

Thanks,
Xingui


