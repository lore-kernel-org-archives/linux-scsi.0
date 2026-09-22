Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E235DA40;
	Tue, 22 Sep 2026 03:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790046668; cv=none; b=SGUGweMCJ2303dvQ9GhmFQewQbK+YAygQ4q1ocUXl0IGR2eOgcOZIsZtnMrpOeypPGpksSCT9hONOwLjW3NrRx6kU5eNTXgcqu4GemRNcuS6hia0DDGk/W434vzKKNHbUGfvrd0u835oWF7X7A6bU5NjigB8N1zQ3s/eTpMHGkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790046668; c=relaxed/simple;
	bh=LEhiKXrsa9wPe2o9opQQ7L4hj3c4FrkO/Sei/IQZ8uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mhYAW6eqkIzS8iDx8pevI/fFZvMeuVEHxTI1q+ERujADXwR2VcgD0lFBiOTL4byuAUJeA9A1NcYhRek9rSCU+iTPVLOIW1jbYrX5DBlZsGwvQ/vgdBTdNLvOB0316OCuXmADqJjG8fZKkpU49NCquCA+sseUKne3bZjXzDyvFro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Rrd24Wl1; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Rrd24Wl1"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=k5AmA5f0tlPXBzWQkjQDl52DMR5WoW+q26nsSEM0zNs=;
	b=Rrd24Wl1TgOMx1e7NB2T2sJk9yI39bZYQXjL5EioMZykup7nyHyb6LWt4qjqQsCogreuq2QgH
	CjybcdEVXAndbnHUXjILURWpodsId3jwOZBTTCSxLhRToXmP/iOMHbATF/b5SB1fZYHzruFiNCu
	+CnXChV9cySYA7NzMNDB0I8=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hplFW0dTlznTVd;
	Tue, 22 Sep 2026 10:59:59 +0800 (CST)
Received: from kwepemp200006.china.huawei.com (unknown [7.202.195.217])
	by mail.maildlp.com (Postfix) with ESMTPS id D62C24057C;
	Tue, 22 Sep 2026 11:11:00 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200006.china.huawei.com (7.202.195.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 11:11:00 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 11:11:00 +0800
Message-ID: <ddfd984f-4690-5c0d-76ca-30bd505e3ab1@huawei.com>
Date: Tue, 22 Sep 2026 11:10:59 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] scsi: libsas: Fix SMP IO deadlock during HA resume
Content-Language: en-CA
To: John Garry <john.garry@linux.dev>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <mkp@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260918070307.381207-1-yangxingui@huawei.com>
 <9a72eeb3-ca32-4241-9e21-74cf894a9bf1@linux.dev>
 <bab95bba-3091-30e5-91ba-0fd459db0101@huawei.com>
 <627a27fc-b025-4bc1-8601-b0fca0e1c4e1@linux.dev>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <627a27fc-b025-4bc1-8601-b0fca0e1c4e1@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/9/21 22:05, John Garry wrote:
> On 9/21/26 13:21, yangxingui wrote:
>> Hi, John
>>
>> On 2026/9/21 19:37, John Garry wrote:
>>> On 9/18/26 08:03, Xingui Yang wrote:
>>>> When the controller resumes, sas_resume_ha() -> sas_drain_work()
>>>> processes the DISCE_RESUME work, which restores the ATA ports through
>>>> the libata error handler (ata_sas_port_resume() requests ATA_EH_RESET)
>>>> and waits for it in sas_ata_flush_pm_eh(). For an expander-attached
>>>> ATA device the hard reset in that recovery is an SMP PHY CONTROL
>>>> command sent to the expander:
>>>>
>>>>    ata_eh_recover() -> ata_eh_reset() -> sas_ata_hard_reset()
>>>>      -> lldd_I_T_nexus_reset() -> sas_phy_reset()
>>>>        -> sas_smp_phy_control() -> smp_execute_task_sg()
>>>
>>> This seems like an obvious issue. How come it was not found earlier? 
>>> It is apparently fixing a patch which is 5 years old.
>>
>> The deadlock was not reachable for most of those 5 years - it is a
>> regression of 3dbbbf656b85 ("scsi: libsas: Fix HA resume deadlock and
>> hisi_sas disk-wake race"), which restored the draining sas_resume_ha()
>> in hisi_sas.
>>
>> 0da7ca4c4fd9 was part of the same 2021 series as fbefe22811c3 ("Don't
>> always drain event workqueue for HA resume"), which switched hisi_sas
>> to the non-draining sas_resume_ha_no_sync(). The two were designed
>> together: without the drain, nothing in the resume path waits on the
>> ATA error handling, so the pm_runtime_get_sync() in
>> smp_execute_task_sg() could at most delay the EH until the resume
>> callback returned - no circular wait.
>>
>> 3dbbbf656b85 restored the drain to fix the disk-wake race (the
>> controller autosuspending while disks were still waking up), which for
>> the first time made the resume wait on the ATA EH - and with it the
>> SMP PHY CONTROL for an expander-attached ATA device. So the deadlock
>> window is really since 3dbbbf656b85, not since 0da7ca4c4fd9.
>>
>> It is also a narrow trigger: a directly-attached ATA device resets its
>> phy via lldd_control_phy() (no SMP IO), so it needs an expander-
>> attached ATA device whose EH lands inside the drain of a runtime
>> resume - which is why the testing of 3dbbbf656b85, whose scenario was
>> the disk-wake race, did not catch it.
> 
> uh, the expander-attached SATA disk scenario would be a very common 
> scenario - do you test this always when developing this code?
Yes，we do have a full test suite, but it runs per machine topology. The
3dbbbf656b85 validation ran on the direct-attach configuration, since
the HA resume race it was fixing was originally reported there. The
expander topology was covered in the next test round, and this
deadlock showed up as soon as we switched to it: on that topology
every ATA port resume goes through the EH reset (that is how
ata_sas_port_resume() is implemented), so the SMP IO against the
ongoing runtime resume happens on essentially every cycle.

>>
>> Given that, should Fixes: point at 3dbbbf656b85 instead? I kept
>> 0da7ca4c4fd9 as that is where the pm_runtime_get_sync() being fixed
>> comes from, but the deadlock itself only exists where 3dbbbf656b85
>> is.
>>
> I am just wondering why this needs to be fixed so many times...
Aha - each respin addressed a review finding on the PM
reference handling, not a re-fix of the deadlock. The core fix is
unchanged since v1.
> 
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c 
> b/drivers/scsi/libsas/sas_expander.c
> index 811c9eb4fef1..5a8cdd3682fe 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -61,8 +61,22 @@ static int smp_execute_task_sg(struct domain_device 
> *dev,
>       struct sas_internal *i =
>           to_sas_internal(dev->port->ha->shost->transportt);
>       struct sas_ha_struct *ha = dev->port->ha;
> -
> -    pm_runtime_get_sync(ha->dev);
> +    bool ha_resuming = test_bit(SAS_HA_RESUMING, &ha->state);
> +
> +    /*
> +     * While the host is resuming, ha->dev may be RPM_RESUMING and
> +     * the resume blocked in sas_drain_work() waiting for this very
> +     * SMP IO, so waiting for the host to resume here would deadlock.
> +     * Hold the reference without resuming, the hardware is already
> +     * initialized by the LLDD before sas_resume_ha() runs.
> +     */
> +    if (ha_resuming) {
> +        pm_runtime_get_noresume(ha->dev);
> +    } else {
> +        res = pm_runtime_resume_and_get(ha->dev);
> 
> why change from pm_runtime_get_sync() to pm_runtime_resume_and_get()?

That addresses the pre-existing issue which Sashiko flagged: the
return value of pm_runtime_get_sync() was ignored, so on a failed
resume the code would blindly proceed to submit the SMP task anyway.
Simply checking the return of pm_runtime_get_sync() would be awkward:
it keeps the usage counter incremented even on failure, so the error
path would also need a manual pm_runtime_put_noidle() to balance it.
pm_runtime_resume_and_get() rolls the counter back internally and
returns 0 or an errno, so the check is just "if (res) return res;"

> 
> +        if (res)
> +            return res;
> +    }
> 
> So when is it required to really do pm_runtime_resume_and_get() (and not 
> pm_runtime_get_noresume())? I mean, when is this called such that we 
> need to resume the ha->dev?
Outside the resume window, the caller that needs the resume is BSG
userspace SMP requests (sas_smp_handler): ses/expander tools query
the topology at any time and nothing else holds the host awake, so
the host may have autosuspended; the resume also re-registers the
devices (the PHYE -> dev_found path runs inside the resume), so the
IO can proceed. This is the case 0da7ca4c4fd9 was written for.
The other callers either cannot run while the host is suspended or
already hold their own PM reference, so they never exercise the
resume path.

log as follow:
[root@localhost ~]# smp_discover /dev/bsg/expander-5\:0
   phy  11:U:attached:[5446a2eb02349000:00  t(SSP)]  12 Gbps
   phy  16:U:attached:[5001882016000001:00  i(SSP+STP+SMP)]  12 Gbps
   phy  17:U:attached:[5001882016000001:01  i(SSP+STP+SMP)]  12 Gbps
   phy  18:U:attached:[5001882016000001:02  i(SSP+STP+SMP)]  12 Gbps
   phy  19:U:attached:[5001882016000001:03  i(SSP+STP+SMP)]  12 Gbps
   phy  24:D:attached:[500e004aaaaaaa1e:24  V i(SSP) t(SSP)]  12 Gbps

[47910.943602] jamy pm_runtime_resume_and_get(ha->dev)
[47910.969905] hisi_sas_v3_hw 0000:74:04.0: resuming from operating 
state [D0]
[47912.205965] hisi_sas_v3_hw 0000:74:04.0: neither _PS0 nor _PR0 is defined
[47912.213852] hisi_sas_v3_hw 0000:74:04.0: waiting up to 25 seconds for 
4 phys to resume
[47912.268896] hisi_sas_v3_hw 0000:74:04.0: phyup: phy0 link_rate=11
[47912.275986] hisi_sas_v3_hw 0000:74:04.0: phyup: phy1 link_rate=11
[47912.276017] hisi_sas_v3_hw 0000:74:04.0: dev[7:2] found
[47912.282976] hisi_sas_v3_hw 0000:74:04.0: phyup: phy2 link_rate=11
[47912.282980] hisi_sas_v3_hw 0000:74:04.0: phyup: phy3 link_rate=11
[47912.303834] hisi_sas_v3_hw 0000:74:04.0: dev[8:1] found
[47912.310296] hisi_sas_v3_hw 0000:74:04.0: dev[9:1] found
[47912.316809] hisi_sas_v3_hw 0000:74:04.0: end of resuming controller
[47912.316817] sas: broadcast received: 0
[47912.324219] sas: REVALIDATING DOMAIN on port 0, pid:282487
[47912.329870] jamy pm_runtime_put(ha->dev)


Thanks,
Xingui
.
