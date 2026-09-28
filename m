Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F5C4279FE
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790580617; cv=none; b=GHx9U5yR57l7RoeSnbmKpmWvBHFpT5FTfha7oSi45d4gQtuRto0Y6OX/C546DpndqOwUFPMc4Z1PDIbTmwYr+fSLH0Vh6QLAq1MT6MTeftFgliUxH7mIJ0RS4qdcekbRQsjDYhD0aC6IoE8NUaNj5zCA+NHQ8JqVKII5hzB6hNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790580617; c=relaxed/simple;
	bh=ulwdoKlnm9iFWq5E6UCo62FF072s8WTbOgN/5aXhXTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=tc0bY+ZTc98suuFZDyRgSsLHHyTR00naI6cdUTV/WDGzEbGe0cY0ODSRKoWYLygDs0a7csVxPD+CedxKYimqf0N6djfQxwOKuJ5/CCb9a2XSmT/yrvoDV9i0Qnz7G+hFvHepxhclStNP3lev2j8GzxYJiXo50YkRmMieS3A+moM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Am2oR0LC; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Am2oR0LC"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zFNR1HKv8+U6iad+NvXD8vViws7Ht9Uld34Us6uYLuY=;
	b=Am2oR0LCmpyJY0rvk5CAWhaXGM2B5XtN6oomBd5IM6HpZp/WoStvM+C0SftS/UhI4UCk/jMHM
	LYkhDuchlVUlNVi8XKo2UBsDm/OfGisAuERM2XfXoPvRZVqvGI0lEBSD7s88C/foQ54wqO/t6T0
	8i/ulCCNlgQTjFa0x8ufX3U=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4htXhP6WgtzpStW;
	Mon, 28 Sep 2026 15:17:57 +0800 (CST)
Received: from kwepemp100004.china.huawei.com (unknown [7.202.195.164])
	by mail.maildlp.com (Postfix) with ESMTPS id A18704057A;
	Mon, 28 Sep 2026 15:30:04 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100004.china.huawei.com (7.202.195.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 28 Sep 2026 15:30:04 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 28 Sep 2026 15:30:04 +0800
Message-ID: <707da9b4-5342-beca-0f24-a850c96ded9e@huawei.com>
Date: Mon, 28 Sep 2026 15:30:03 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4] scsi: libsas: Fix SMP IO deadlock during HA resume
Content-Language: en-CA
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20260928040234.992912-1-yangxingui@huawei.com>
 <20260928041457.BA0891F0089A@smtp.kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260928041457.BA0891F0089A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/9/28 12:14, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: libsas: hardware access on suspended host in smp_execute_task_sg()
> --
> 
> commit b6ffaa3a7e18a8e3fec2c6c49ebb1c88915b9f8d
> Author: Xingui Yang <yangxingui@huawei.com>
> 
> scsi: libsas: Fix SMP IO deadlock during HA resume
> 
> smp_execute_task_sg() calls pm_runtime_get_sync() on the host before
> issuing an SMP command. When that command is itself issued from the
> HA resume path, the get_sync() deadlocks: it waits for the ongoing
> resume (the device is RPM_RESUMING), while the resume is blocked in
> sas_drain_work() waiting for that same SMP IO to complete.
> 
>> The usage reference is still required. Discovery work normally runs
>> inside an event worker's PM reference, taken at
>> sas_notify_port_event() notify time and held until the handler has
>> flushed the disco queue. sas_rediscover_ex_phy() however requeues
>> DISCE_REVALIDATE_DOMAIN from within the revalidation worker itself,
>> and flush_workqueue() does not wait for work items queued during
>> execution, so that chained revalidation runs with no outer PM
>> reference - without the get_noresume(), its SMP could race
>> autosuspend.
> 
> [Severity: High]
> Does pm_runtime_get_noresume() actually prevent this race if the device
> has already autosuspended?
> 
> When chained revalidation occurs in sas_discover.c:sas_revalidate_domain(),
> it runs without an outer PM reference. If the host autosuspends before
> smp_execute_task_sg() runs, pm_runtime_get_noresume() will only increment
> the usage counter and leave the device suspended.
> 
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index 811c9eb4fef11..26c2099c28b97 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -62,7 +62,11 @@ static int smp_execute_task_sg(struct domain_device *dev,
>>   		to_sas_internal(dev->port->ha->shost->transportt);
>>   	struct sas_ha_struct *ha = dev->port->ha;
>>   
>> -	pm_runtime_get_sync(ha->dev);
>> +	/*
>> +	 * Non-blocking: a sync resume here would deadlock against
>> +	 * sas_drain_work() during HA resume.
>> +	 */
>> +	pm_runtime_get_noresume(ha->dev);
> 
> [Severity: High]
> If the host has already autosuspended when this is called, will this cause
> a crash or hardware fault?

For the chained revalidation the "already
autosuspended" state cannot arise: the host cannot finish
autosuspending while the chained round is queued, because
_suspend_v3_hw() -> sas_suspend_ha() -> sas_drain_work() drains the
disco queue, so the suspend callback blocks until that round, queued
on the same queue, has completed. The round can at worst observe
RPM_SUSPENDING, never RPM_SUSPENDED, and the PCI power state is only
lowered after the driver callback returns - which the drain prevents -
so commands are never dispatched to a powered-down host.

Within the RPM_SUSPENDING window the reference taken by
pm_runtime_get_noresume() is caught by the existing checks: the core
usage check rejects the suspend outright, and if the attempt has
already passed it, the check added by e368d38cb952 ("PM suspend: host
status cannot be suspended") aborts it. We verified this by fault
injection: without the reference the host suspends while the chained
revalidation has an SMP in progress and the command times out - a
recoverable discovery failure, with the reference in place the same
test shows the suspend attempt aborted by that check, with the round
running on an active host.

[162894.251646] hisi_sas_v3_hw 0000:74:04.0: end of resuming controller
[162894.251649] sas: broadcast received: 0
[162894.251664] sas: REVALIDATING DOMAIN on port 0, pid:894458
[162894.259057] sas: SMP 500e004aaaaaaa1f: usage=3 status=0
[162894.259063] sd 5:0:2:0: [sdh] Starting disk
[162894.259066] sd 5:0:3:0: [sdi] Starting disk
[162894.276354] sas: ex 500e004aaaaaaa1f phy00 change count has changed
[162894.352863] sas: INJECT: faking replacement on phy02 (real 
5000c5008f23d735)
[162894.361300] sas: ex 500e004aaaaaaa1f phy02 replace 5000c5008f23d735
[162894.375076] smp_execute_task_sg: inject smp timeout
[162900.390107] sd 5:0:3:0: [sdi] Synchronizing SCSI cache
[162900.390110] sd 5:0:2:0: [sdh] Synchronizing SCSI cache
[162900.403138] sd 5:0:2:0: [sdh] Stopping disk
[162900.428158] sd 5:0:3:0: [sdi] Stopping disk
[162916.262081] sas: smp task timed out or aborted
[162916.267906] hisi_sas_v3_hw 0000:74:04.0: abort task: rc=5
[162916.274434] sas: SMP task aborted and not done
[162916.280002] sas: done REVALIDATING DOMAIN on port 0, pid:894458, res 
0xffffffba
[162916.297048] hisi_sas_v3_hw 0000:74:04.0: dev[20:1] is gone
[162916.304433] sas: REVALIDATING DOMAIN on port 0, pid:894458
[162916.304437] sas: SMP 500e004aaaaaaa1f: usage=1 status=0
[162916.304455] hisi_sas_v3_hw 0000:74:04.0: entering suspend state
[162916.310802] smp_execute_task_sg: inject smp timeout
[162916.317864] hisi_sas_v3_hw 0000:74:04.0: PM suspend: host status 
cannot be suspended // <============ cannot be suspended
[162936.742077] sas: smp task timed out or aborted
[162936.747971] hisi_sas_v3_hw 0000:74:04.0: abort task: rc=5
[162936.754523] sas: SMP task aborted and not done
[162936.760126] sas: done REVALIDATING DOMAIN on port 0, pid:894458, res 
0xffffffba
[162936.768890] hisi_sas_v3_hw 0000:74:04.0: entering suspend state
[162937.187359] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[162937.194389] sas: ata76: end_device-5:0:5: dev error handler
[162937.194395] sas: ata77: end_device-5:0:7: dev error handler
[162937.194431] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[162937.204475] hisi_sas_v3_hw 0000:74:04.0: dev[19:2] is gone
[162937.211372] hisi_sas_v3_hw 0000:74:04.0: dev[21:1] is gone
[162937.218221] hisi_sas_v3_hw 0000:74:04.0: dev[22:5] is gone
[162937.225065] hisi_sas_v3_hw 0000:74:04.0: dev[23:5] is gone
[162937.231850] hisi_sas_v3_hw 0000:74:04.0: dev[24:1] is gone
[162937.238602] hisi_sas_v3_hw 0000:74:04.0: dev[25:1] is gone
[162937.245397] hisi_sas_v3_hw 0000:74:04.0: dev[26:1] is gone
[162937.252142] hisi_sas_v3_hw 0000:74:04.0: dev[27:1] is gone
[162937.266997] hisi_sas_v3_hw 0000:74:04.0: end of suspending controller

The other callers hold the host active through their own context: the
BSG path resumes it first (sas_smp_handler() calls
pm_runtime_resume_and_get()), event-triggered discovery - including
the ata port probe of a newly found SATA device, which the discovery
work item waits for - runs inside the event workers' PM references,
EH commands run with failed commands still outstanding - which holds
the host active through the hisi_sas device links (16fd4a7c5917) - or
are issued from the resume path itself (RPM_RESUMING, hw_init already
done), and the sysfs PHY paths hold their own reference.

Thanks,
Xingui


