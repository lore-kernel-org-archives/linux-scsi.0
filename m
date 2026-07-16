Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AF42C21D8
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 09:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784195152; cv=none; b=Jbi4UbCsRXlO/z6c4MXBQWDjQoMMmHV8KxscovgCoT/KCEAKpLm3p9GGF8rrhGgWTTMp44fpGqBxVItkLYGaa5tPbH/60gYHz+3Oea2gaMPCRQy+UeEILWQKzAqKgoUR17ArgB7KksYGEukoTnWAkxngbTihZFnd3fkLV56/wwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784195152; c=relaxed/simple;
	bh=DXHIPIx2VuUUtJcFUxJQ7iBRX0E16+iSuTLuu4xI+lU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HyomuIYqflwBmvGJzKlNinM+PWJOyTWfYBlaufz673QTnprgQTTLqACPcPF45XI12waNAD2Q91aq30C4NW/HQEfGH/tz0LZ54uI9eetGGlXt68U7dF5E3E3FkCLQ1t9r2E+XsTzHYKrPrrbNAXmsCgnQroO+NrZxGSITzmp6aco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=GUw3oPzG; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="GUw3oPzG"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GslGGlaZ38+Ofq+gpW5fJ69tPLIPXH9n5BlMGa7ZAaA=;
	b=GUw3oPzGiJym0ECAqOLfyWQCC8xCvsQ9dAg+dYNYmFuCOxAtZjouHodGnb9dT+t9q7oFs9OqI
	arU27EyiXvHdpadw+ryfgdXDpsqTTcScJZUtcuJ9Qvnswu/CoqFi+/+9/vxTF/q1b54YvzqP2ar
	dJpKfQ5lCtBFBLootHnabJ4=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h17GK28FgzmVD7;
	Thu, 16 Jul 2026 17:36:25 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 72F4840572;
	Thu, 16 Jul 2026 17:45:44 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 16 Jul 2026 17:45:44 +0800
Message-ID: <93ae1a51-4d7f-62fd-08e4-352043d87bfb@huawei.com>
Date: Thu, 16 Jul 2026 17:45:43 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
Content-Language: en-CA
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20260716081145.3950172-1-yangxingui@huawei.com>
 <20260716084735.91D7A1F000E9@smtp.kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260716084735.91D7A1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh100005.china.huawei.com (7.202.181.88) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/7/16 16:47, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Removing `sas_resume_ha_no_sync()` and restoring `sas_resume_ha()` reintroduces a resume deadlock for hardware events like `PHYE_LOSS_OF_SIGNAL`.
> --
> 
> --- Patch [1]: [PATCH v3] scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race ---
> commit f62439ea23dd5d0db3e1f9ebd2572dcb77f2890b
> Author: Xingui Yang <yangxingui@huawei.com>
> 
> scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race
> 
> This patch moves the PHYE_RESUME_TIMEOUT notification after sas_drain_work()
> to fix a deadlock in the resume path. It then removes sas_resume_ha_no_sync()
> and restores the draining sas_resume_ha() in hisi_sas.
> 
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> index 213d5b5dea94f..8a2500993e19d 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> [ ... ]
>> @@ -5261,15 +5261,7 @@ static int _resume_v3_hw(struct device *device)
>>   		return rc;
>>   	}
>>   	phys_init_v3_hw(hisi_hba);
>> -
>> -	/*
>> -	 * If a directly-attached disk is removed during suspend, a deadlock
>> -	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
>> -	 * hisi_hba->device to be active, which can only happen when resume
>> -	 * completes. So don't wait for the HA event workqueue to drain upon
>> -	 * resume.
>> -	 */
>> -	sas_resume_ha_no_sync(sha);
>> +	sas_resume_ha(sha);
>>   	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
>>   
>>   	dev_warn(dev, "end of resuming controller\n");
> 
>> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
>> index 0bec236f0fb59..c3f3d05b46dea 100644
>> --- a/drivers/scsi/libsas/sas_init.c
>> +++ b/drivers/scsi/libsas/sas_init.c
> [ ... ]
>> @@ -426,6 +426,23 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
>>   		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
>>   			 i, i > 1 ? "s" : "");
>>   	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
>> +
>> +	/*
>> +	 * All phys are back up or timed out. Turn on I/O and drain
>> +	 * pending work.
>> +	 */
>> +	scsi_unblock_requests(ha->shost);
>> +	sas_drain_work(ha);
> 
> [Severity: High]
> Could this reintroduce a resume deadlock for hardware events like
> PHYE_LOSS_OF_SIGNAL?
> 
> During host resume in _resume_v3_hw(), hardware is re-enabled via
> phys_init_v3_hw() just before calling sas_resume_ha(). If a hardware event
> fires during the 25-second wait window, the interrupt handler will queue it.
> 
> Looking at sas_defer_event() in sas_event.c, events for suspended phys are
> not deferred:
> 
> drivers/scsi/libsas/sas_event.c:sas_defer_event() {
>      ...
>      if (test_bit(SAS_HA_RESUMING, &ha->state) && !phy->suspended) {
>          ... deferred = true;
>      }
>      ...
> }
> 
> Since it isn't deferred, the event worker executes it immediately:
> sas_phye_loss_of_signal() -> sas_deform_port() -> sas_destruct_devices() ->
> sas_rphy_delete() -> device_del().
> 
> Because hisi_sas uses device links with DL_FLAG_PM_RUNTIME, device_del()
> triggers a synchronous resume (pm_runtime_get_sync()), which blocks waiting
> for the host to finish resuming.
> 
> At the same time, this sas_drain_work() call blocks waiting for the event
> worker to finish, resulting in a deadlock. Could a hardware event fire
> during this wait and cause this scenario?

The deadlock cannot occur due to a contradiction in the triggering 
conditions.

For PHYE_LOSS_OF_SIGNAL to execute synchronously during
sas_drain_work(), it must bypass sas_defer_event(), which requires
phy->suspended == 1 (since SAS_HA_RESUMING is still set during
drain). But PHYE_LOSS_OF_SIGNAL also requires an active link on that
phy to generate a hardware interrupt — and phy->suspended == 1 means
the phy was deactivated by lldd_port_deformed() during suspend, with
no active link to lose.

We have verified that removing a disk during suspend does not generate
a phy loss event — the phy is already deactivated.

During resume, if the phy came back up (suspended == 0), the event is
deferred by sas_defer_event() and does not execute during drain. If
the phy never came up (suspended == 1), there is no link and no
interrupt. Either way, the deadlock condition cannot be reached.

Thanks,
Xingui
