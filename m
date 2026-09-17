Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41484AD4B9;
	Thu, 17 Sep 2026 09:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637817; cv=none; b=Yi66T7ipGadsF44G4mnN+YnymhiRY5RT7eRVIPjuKkJPf2iyPa+2dxl0hOQoc6JluKcjm2YS/7vG6KZ04lbIYzeZJMtO9o5zinNgAhaDWapqbZ9azVgxsWngPyX2jC/ufip1bHe7+KtewL3rFUvuCRWC7t5FKEJN4U1sIju92lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637817; c=relaxed/simple;
	bh=2Sf+S9cOAIGjnMuUoWLx3jxqSb4baH2NMOZXkOdv1ME=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=u1+g5QJ2dgVXt+ugrptkwEzoHWE/SH6zqfVH/nIJ0o5BnkwEfBlQtYkCp1m4YINHTWekJdDXUuCTYVAdA4ZLYqfRuIW4FyLb2oli1cyQypMFZivIxCF9TeFqDjTD/dCtK0NkHgl0tJcpFdW5+czif3AjzQh1u17BZG6zkgvVX+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=DTlSowL3; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="DTlSowL3"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4qKfA/3QEG+L09Ej0W0JUmXjP14WgIp0UD1F6ZxKGEQ=;
	b=DTlSowL3Lp5IlKr8I4O810oODvMG7RcpjuCN6edc+KXf4K5wuZSjrdzelnteyiCUA85xklR42
	Dh95ybOJeH696idTZaIq8ejFJpU4zjPmnUGz89VJlcGcMXrPC5kFQBdz1GQx3hRLRYlQybxG3WT
	YoMMQNUSbU+e5zhyb1bW5mE=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hlr2Y5dl2z12LHn;
	Thu, 17 Sep 2026 17:25:25 +0800 (CST)
Received: from kwepemp200001.china.huawei.com (unknown [7.202.195.150])
	by mail.maildlp.com (Postfix) with ESMTPS id 687014057F;
	Thu, 17 Sep 2026 17:36:33 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200001.china.huawei.com (7.202.195.150) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 17 Sep 2026 17:36:33 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 17 Sep 2026 17:36:32 +0800
Message-ID: <f9071dfe-2345-6ee3-c4ae-8408bdf781e4@huawei.com>
Date: Thu, 17 Sep 2026 17:36:32 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] scsi: libsas: Fix SMP IO deadlock during HA resume
Content-Language: en-CA
To: John Garry <john.garry@linux.dev>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <mkp@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260826032845.1632348-1-yangxingui@huawei.com>
 <a97c6cfb-8476-1030-a07a-fea1c004ecbe@huawei.com>
 <2c1aee3c-3ea5-44f7-915c-5a812a261032@linux.dev>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <2c1aee3c-3ea5-44f7-915c-5a812a261032@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemp500015.china.huawei.com (7.202.195.9)

Hi John

Thank you for the review.

On 2026/9/16 21:58, John Garry wrote:
> On 9/11/26 02:00, yangxingui wrote:
>> Hi John & Jason,
>>
>> Kindly ping for review...
> 
> What about the sashiko comment:
> 
> - [High] Bypassing PM reference counting via a global state flag creates 
> a race condition where concurrent independent threads can submit SMP 
> I/Os without holding a PM reference, risking premature hardware suspend.
> 
> It looks correct.

Agreed. Although the possibility is very slim.
The SMP IO which sas_drain_work() waits on cannot outlive the
SAS_HA_RESUMING window, but a BSG request submitted during the window
takes no PM reference for the duration of its IO, and the controller
may autosuspend underneath it. v2 takes the reference with
pm_runtime_get_noresume()/pm_runtime_put_noidle() instead: the usage
counter stays elevated for the IO duration, without waiting for the
already ongoing resume.

> 
>>
>> On 2026/8/26 11:28, Xingui Yang wrote:
>>> During sas_resume_ha() -> sas_drain_work(), 
> 
> This is poorly described - what does during sas_resume_ha() -> 
> sas_drain_work() even mean?

The deadlock happens during a runtime resume, while
sas_resume_ha() is inside sas_drain_work(), flushing the event and
discovery workqueues. That flush includes the DISCE_RESUME work queued
when the phys come back up: sas_resume_devices() -> sas_resume_sata()
resumes the ATA ports through the libata error handler and waits for
it in sas_ata_flush_pm_eh(). So the resume is blocked in
sas_drain_work() waiting on that error handling - and the error
handling's reset of the expander-attached ATA device blocks on the
host being RPM_RESUMING, i.e. on the very resume which is waiting on
it.

> 
>> ATA EH will trigger SMP
>>> IOs via
>>> sas_phy_reset() -> sas_smp_phy_control() for expander-attached ATA 
>>> devices.
> 
> What commands are these specifically?

SMP PHY CONTROL (hard reset or link reset) commands, sent to the
expander which owns the phy of the ATA device being recovered:

   ata_eh_recover() -> ata_eh_reset() -> sas_ata_hard_reset()
     -> lldd_I_T_nexus_reset() -> sas_phy_reset()
       -> sas_smp_phy_control() -> smp_execute_task_sg()

A directly-attached device would take the lldd_control_phy() path
instead, which is why only the EXP topology deadlocks.


Thanks,
Xingui
.
