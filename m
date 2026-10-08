Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E711BD9D0;
	Thu,  8 Oct 2026 03:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429098; cv=none; b=ZPRMcEQB4Hdz/BpQ6l5Wjis8Tcy807WGAYmjwQWPN2sP7Tag0vgrgqbszN4Ek5qwWidjUhTD1iL9mMI22xAh2DS9XlxxKfjRwdbo2EGJ26haML902vO9yWBkQzqZuhrK+D/JV1WAwhnlNSO63QhWcasOV0yVffIrTm4Vh0QqHoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429098; c=relaxed/simple;
	bh=3lFjYCxe8XVsB1lwh0y7mBlYEnrUXDiZXtAHT+AMPIA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Gd7nxKfwQzGql5m1129dwn0faIjNP+nr5mxUrW/s0PUIKJqoYZWLykTrfy3hNn9c6f+PB0aFWmg+BP4VkhDiXX4SChZqyNfvr8vsIupUJUeodnFqcopqM30m6oaNo8v7k5e2PyUcsH81mYvynacEpLcVQG8AiHee2vcv0f9bK38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=pMEQFdBl; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="pMEQFdBl"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EnAilI4OKlZkOu1J/21Tk8Yja2DTm5YBtKfiECaMkEY=;
	b=pMEQFdBlcL4rvGZvtimghz+ug5SD7NvSyTViLXt22VlA4n3OZ1HAWLombKm/ZvEiRagt5DFLN
	sneokgFD1Qd6N5Cn4SmL0N/TZ5mtH8Y/kmHKdfmh4YG92k4htm7dcKaTG3zLao/hIAAFXwyX5Ux
	vU6XSZFNbMeJ/WdhM2Nkgk0=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4j0ZTD2Zf6z1K9d4;
	Thu,  8 Oct 2026 10:59:12 +0800 (CST)
Received: from kwepemp500001.china.huawei.com (unknown [7.202.195.40])
	by mail.maildlp.com (Postfix) with ESMTPS id F33734056C;
	Thu,  8 Oct 2026 11:11:26 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500001.china.huawei.com (7.202.195.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:11:26 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:11:26 +0800
Message-ID: <ba5d9188-937c-237c-e104-9b66e7c3be3e@huawei.com>
Date: Thu, 8 Oct 2026 11:11:25 +0800
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
To: John Garry <john.garry@linux.dev>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <mkp@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260928040234.992912-1-yangxingui@huawei.com>
 <820657c2-1cbd-47d8-92f2-477531692135@linux.dev>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <820657c2-1cbd-47d8-92f2-477531692135@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi, John

On 2026/9/30 18:40, John Garry wrote:
> On 9/28/26 05:02, Xingui Yang wrote:
>> smp_execute_task_sg() calls pm_runtime_get_sync() on the host before
>> issuing an SMP command. When that command is itself issued from the
>> HA resume path, the get_sync() deadlocks: it waits for the ongoing
>> resume (the device is RPM_RESUMING), while the resume is blocked in
>> sas_drain_work() waiting for that same SMP IO to complete.
>>
>> The deadlock needs an expander-attached SATA disk. 
> 
> What do you mean by "deadlock needs an expander-attached SATA disk?
Yes, that is the only configuration whose resume-time hard reset is
implemented as an SMP command. The disk's phy belongs to the
expander, so the ATA EH hard reset is an SMP PHY CONTROL sent to the
expander (sas_ata_hard_reset() -> sas_phy_reset() ->
sas_smp_phy_control() -> smp_execute_task_sg()), a directly attached
SATA disk resets the HBA's own phy through lldd_control_phy(), and
SSP devices are reset through TMFs, so neither issues SMP on resume.
An SMP request from outside the resume path cannot construct the
cycle either: a BSG request arriving while a resume is in progress
blocks waiting for that resume (get_sync() before this patch,
resume_and_get() at the new call site) before it takes the expander
cmd_mutex, and the resume waits for nothing in the BSG context - it
can only be a victim of the deadlock, never a participant.

> 
>> During
>> sas_resume_ha() -> sas_drain_work(), DISCE_RESUME ->
>> sas_resume_sata() -> ata_sas_port_resume() requests ATA_EH_RESET,
>> and the hard reset for such a disk is done via SMP PHY CONTROL
>> (sas_ata_hard_reset() -> sas_phy_reset() -> sas_smp_phy_control() ->
>> smp_execute_task_sg()). Direct-attached SATA resets through
>> lldd_control_phy() and SSP devices use TMFs, so neither hits this.
>>
>> Replace the get_sync()/put_sync() pair with
>> pm_runtime_get_noresume()/pm_runtime_put(). smp_execute_task_sg()
>> only needs to hold off autosuspend while the SMP is in flight, and it
>> must not try to resume the host: a sync resume issued from the HA
>> resume path itself is what deadlocks, and by the time sas_resume_ha()
>> runs, hw_init has already reinitialized the hardware, so the device
>> is accessible without one.
>>
>> The usage reference is still required. 
> 
> Do you mean that usage reference from pm_runtime_get_noresume() is still 
> required?

Yes, the reference taken by the pm_runtime_get_noresume() which
replaces the get_sync(). It is not an artefact of the conversion:
the chained revalidation described in the next paragraph runs
outside the event workers' PM references, so without it its SMP
could race autosuspend.

>> Discovery work normally runs
>> inside an event worker's PM reference, taken at
>> sas_notify_port_event() notify time and held until the handler has
>> flushed the disco queue. sas_rediscover_ex_phy() however requeues
>> DISCE_REVALIDATE_DOMAIN from within the revalidation worker itself,
>> and flush_workqueue() does not wait for work items queued during
>> execution, so that chained revalidation runs with no outer PM
>> reference - without the get_noresume(), its SMP could race
>> autosuspend.
>>
>> For the BSG path, sas_smp_handler() is the only caller which may
>> find the host autosuspended: expander SMP requests do not go through
>> any SCSI device request queue, so nothing else in that path holds
>> the host awake. Resume it there with pm_runtime_resume_and_get()
>> and check the result.
>>
>> Fixes: 3dbbbf656b850 ("scsi: libsas: Fix HA resume deadlock and 
>> hisi_sas disk-wake race")
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> 
> Question: do you have a (non-hisi_sas) SAS HBA card whose driver uses 
> libsas? pm8001 would be such an example. It would be nice to verify that 
> all these and other non-rpm libsas changes does cause regression there.

We don't have a pm8001 card at hand. From analysis the patch is a
no-op for the LLDDs without runtime PM support: pm8001 and isci
only register system suspend/resume through SIMPLE_DEV_PM_OPS(), and
aic94xx and mvsas register no PM ops at all. For every PCI device
the PCI core forbids runtime PM by default and marks the device
runtime-active (pci_pm_init()), and enables runtime PM later
(pci_bus_add_device()), those devices are thus permanently RPM_ACTIVE
with the usage counter held, and can never runtime-suspend. In that
state get_noresume()/put() only moves the usage counter - exactly
what the get_sync()/put_sync() they replace did - and
pm_runtime_resume_and_get() in sas_smp_handler() succeeds (runtime
PM is enabled and the device is already active), so the new error
check never rejects a request on them.

The only observable difference would be userspace enabling runtime
PM (power/control = auto) on a driver which does not support it, and
that configuration is broken independently of this patch.

Conversely, should an LLDD gain runtime PM support later, it would
need this patch: the deadlock is in the shared resume path - any
runtime-resuming LLDD with an expander-attached SATA disk in the
domain hits it identically - and the reference/resume split
completes the generic protection model, while the LLDD-side
obligations (device links, hw reinit before sas_resume_ha()) are
unchanged.


Thanks,
Xingui


