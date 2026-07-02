Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718C92D6E58
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 02:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782961167; cv=none; b=X6NRHIKwBJLfN1qoKQ8H/cdcSR/brcGDm8WUgYoC8gmHDE49YQXjga45qlIUtgj+nETQhLyFx/KVfNzkKAaGkwtK5HLkibTUlsZDVIaPvhFOReTDreMzre1ucaPEg0nj5vf1t5msCU1IZB+4d5SCq+FFIfjFMCPPP0XpsCTvxnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782961167; c=relaxed/simple;
	bh=DebgqhEZkgj58ldLUI9wjiRFF5lhNDqWhIKmbG05g9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qzbOhiFcddIbsQUD1Vuge8Pr9piXa5vXbO1sNfCWPChgx/lKJTLlRqqFpmTUgvukcGWu2qsM72+EuXbzTi7oNeiNaNYSUWdnOJXzyhnVXPFzSffQ2iXTZ5o28oavh1qo8Aru47XPL2R32ByjlpdJlys+O1Uk6gZuieWNymwdg5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=TXCA26dX; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="TXCA26dX"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JwkcEgQbKhJFQ80C4M37yQGc4WQLmieDThvYuzb8Or0=;
	b=TXCA26dXGlA9EBDxFByG8Y0EI22xMO+KUdeL2N+oT6VhNa/MaxdMPbOe7Dv4aNlyAiZACMSpu
	/bEvhz81BujNAmTRiE20sdLn8P17LDbF0N5CYGgPy5s9r4ajW1nGsFTG51eDVZ7ai7sDZb6/o1n
	VuSmPRpARE+VWuEGWxlkRhY=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4grLvz67XKzmV7h;
	Thu,  2 Jul 2026 10:50:07 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E46B40580;
	Thu,  2 Jul 2026 10:59:18 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 2 Jul 2026 10:59:17 +0800
Message-ID: <a2ec2355-9e09-1a64-b36e-42501a604bbc@huawei.com>
Date: Thu, 2 Jul 2026 10:59:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
Content-Language: en-CA
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20260630065157.421203-1-yangxingui@huawei.com>
 <20260630071935.A15C61F00A3A@smtp.kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260630071935.A15C61F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh500001.china.huawei.com (7.202.181.130) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/6/30 15:19, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [High] The `flush_workqueue(hisi_hba->wq)` placement is ineffective, failing to prevent the autosuspend race for newly discovered PHYs.
> 
> Pre-existing issues:
> - [High] PHY down events are silently dropped during resume because `HISI_SAS_RESETTING_BIT` remains set, permanently leaving libsas state out of sync.

I've sent v2 which removes the flush_workqueue() entirely, as it is 
unnecessary.

> commit ce8bc2a47295d4675bf4efa43c713662a8cd5696
> Author: Xingui Yang <yangxingui@huawei.com>
> 
> scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race
> 
> This patch resolves a deadlock during HA resume by moving the
> PHYE_RESUME_TIMEOUT notification to after sas_drain_work(). It restores
> the draining sas_resume_ha() behavior in hisi_sas and introduces a
> flush_workqueue() to prevent an autosuspend race.
> 
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> index 213d5b5dea94f..901f508e8be77 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> @@ -5262,14 +5262,8 @@ static int _resume_v3_hw(struct device *device)
>>   	}
>>   	phys_init_v3_hw(hisi_hba);
>>   
>> -	/*
>> -	 * If a directly-attached disk is removed during suspend, a deadlock
>> -	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
>> -	 * hisi_hba->device to be active, which can only happen when resume
>> -	 * completes. So don't wait for the HA event workqueue to drain upon
>> -	 * resume.
>> -	 */
>> -	sas_resume_ha_no_sync(sha);
>> +	sas_resume_ha(sha);
>> +	flush_workqueue(hisi_hba->wq);
> 
> [Severity: High]
> Does this flush_workqueue() placement miss newly queued discovery events?
> 
> sas_resume_ha() drains the libsas event_q and disco_q. By flushing hisi_hba->wq
> after this drain, any hisi_sas_phyup_pm_work items on hisi_hba->wq will queue
> PORTE_BYTES_DMAED events to event_q that bypass the drain.
> 
> Since hisi_sas_phyup_pm_work then calls pm_runtime_put_sync(), its PM reference
> is dropped. When _resume_v3_hw() returns, the system PM reference is also
> dropped, allowing the controller to autosuspend while the missed discovery
> works execute asynchronously and attempt to send IO to a suspended controller.
> 
> Should the flush be placed before sas_resume_ha() so the generated events are
> caught and synchronously processed by sas_drain_work()?

Given that the flush is a no-op in the normal case and the PM reference
counting already protects against the race in the late-arrival case, v2
removes the flush_workqueue() entirely and removes the corresponding
justification from the commit message.

> 
>>   	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
> 
> [Severity: High]
> This is a pre-existing issue, but are PHY down events silently dropped during
> resume because HISI_SAS_RESETTING_BIT remains set?
> 
> In _resume_v3_hw(), HISI_SAS_RESETTING_BIT is kept active across the
> sas_resume_ha() call. If a PHY loses its link during this time, the hardware
> interrupt handler drops the event:
> 
> drivers/scsi/hisi_sas/hisi_sas_main.c:hisi_sas_phy_down() {
> 		if (test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) ||
> 		    phy->in_reset) {
> 			dev_info(dev, "ignore flutter phy%d down\n", phy_no);
> 			return;
> 		}
> }
> 
> When HISI_SAS_RESETTING_BIT is finally cleared here, it does not call
> hisi_sas_rescan_topology() to recover dropped events. Could this permanently
> leave libsas state out of sync if a PHY disconnects during the resume wait?

this is a pre-existing issue. This patch does not
introduce or worsen it: it restores the pre-fbefe22811c3140 behavior
where sas_resume_ha() (the draining variant) is used, so the
HISI_SAS_RESETTING_BIT window is the same as it was before that commit.
This issue should be addressed in a separate patch.
