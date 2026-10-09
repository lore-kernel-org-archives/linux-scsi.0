Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FE5471D16
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 07:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791530006; cv=none; b=TJb1F7h9ptqWSmirfqCmR3L04+VyWdKxT6rOO1xNvLantqNQVvR/YcYVRIEbhWwFCOzxR2hmENtxdKqaZWUImEUp3rAvIX5d+wr4Ntqe2HTGY64knsTjossWMv9T3RotquppA2p+EoVSNHjWAf30i2zS2u3sGJw9Q7IGDwRV/f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791530006; c=relaxed/simple;
	bh=PDTiPlAY3rbxSw5smnBQsj1cJqsQLPi9cn4AwxUoIpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=u9WF4IHmkOCHjkOeZO90SVX/AFhQOQEikzuGxT8MJbmGlvW52BYOv1THkwtS54CXbl7p+0QF1N0Hir/3aFebax+peTfdRbfpTmGjH04o2xswN8JMjd99CdYlJDXp4THgl51SrALJQ8Dv67Xn+ZJLlmIBANCA5dJDxiAbkc7IjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=MrV0+wUD; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="MrV0+wUD"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bs/USAvwO4TVtK6TLifr4cGsQsC1h8UgHimCuc7fbNc=;
	b=MrV0+wUDXchOxCrmFnPfUMyoe3CPOqmtgIf1SYUKRRF0AW65roILwjthl628mvA4J97Pfswq0
	c3Mv2PTSS7RRkwAzGJGX3z6qCrIsKN9UFzGTwDnhFUcWmTUzVNnj+UpwlT46MZQuA1NLhaI0U4C
	y95UUlkiojg1TS1/j0Rfl9g=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j1HpG5ZHwznTy7;
	Fri,  9 Oct 2026 15:01:26 +0800 (CST)
Received: from kwepemp200002.china.huawei.com (unknown [7.202.194.160])
	by mail.maildlp.com (Postfix) with ESMTPS id 067DF4055B;
	Fri,  9 Oct 2026 15:13:22 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200002.china.huawei.com (7.202.194.160) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 15:13:21 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 15:13:21 +0800
Message-ID: <c46780b6-2956-241b-a0c8-0d4fc930db3c@huawei.com>
Date: Fri, 9 Oct 2026 15:13:20 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 4/4] scsi: hisi_sas: Fix spinup failure for SAS SSP
 devices in Active_Wait state
Content-Language: en-CA
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
 <20261009033238.1076098-5-yangxingui@huawei.com>
 <sashiko-outbox-164806@kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <sashiko-outbox-164806@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/10/9 11:58, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] pm: usage count underflow due to incorrect pm_runtime_get_if_active() check in hisi_sas_spinup_notify()
> --
> 
> commit 255dba6c6286916d717929164fd02a77f83d3168
> Author: Xingui Yang <yangxingui@huawei.com>
> Subject: scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait state
> 
> This commit addresses spinup failures for directly-attached SSP devices
> waiting in the Active_Wait state. It parses sense data during slot
> completion and queues work to send a NOTIFY(ENABLE SPINUP) primitive while
> managing the runtime PM state of the controller.
> 
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> index 944ce19ae2fc1..cf7aa0a699cde 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
>> @@ -996,10 +996,25 @@ static void hisi_sas_phyup_pm_work(struct work_struct *work)
> [ ... ]
>> +static void hisi_sas_spinup_notify_work(struct work_struct *work)
>> +{
> [ ... ]
>> +	hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
>> +	dev_info(dev, "spinup notify primitive on phy%d\n", phy_no);
>> +
>> +	pm_runtime_put_sync(dev);
> 
> [Severity: Medium]
> If the earlier pm_runtime_get_if_active() check bypassed a negative error
> code, will this cause a runtime PM usage count underflow since the reference
> was never successfully incremented?
> 
>> +}
> [ ... ]
>> @@ -1639,6 +1654,34 @@ void hisi_sas_controller_reset_done(struct hisi_hba *hisi_hba)
> [ ... ]
>> +void hisi_sas_spinup_notify(struct hisi_hba *hisi_hba,
>> +			    struct sas_task *task)
>> +{
> [ ... ]
>> +	if (!pm_runtime_get_if_active(hisi_hba->dev))
>> +		return;
> 
> [Severity: Medium]
> Does this check properly handle negative error codes?
> 
> pm_runtime_get_if_active() returns 1 if the device is active, 0 if inactive,
> and a negative error code (like -EINVAL) if runtime PM is disabled. If it
> returns -EINVAL, !(-EINVAL) evaluates to false, causing execution to proceed
> without actually acquiring a PM reference.
> 
> Should this check be `if (pm_runtime_get_if_active(...) <= 0)` instead?

-EINVAL only occurs while runtime PM is
disabled, which never overlaps with CQ completions on this driver, so
the check only ever sees 0 or 1 and every put stays paired with a taken
reference. '<= 0' would disable the notify entirely on !CONFIG_PM
builds (the stub always returns -EINVAL), so I'd like to keep the
current check.
