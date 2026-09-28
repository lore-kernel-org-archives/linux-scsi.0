Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E8F3016FB;
	Mon, 28 Sep 2026 03:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790567250; cv=none; b=hSNXaUrEveYO+HNA0bfAL5++Os7tVO3d83zw4YaXfCoTa9rsQRlyNgPiiizcFcZsOqVsuxTTUpCEdwIxCI/Lov8Ya9M2KpN0O+ZcOTbfAPHsP983O388BH0h8GaQO4MJWmRQ7iETiWBvKYwgGZNA7YAj+JUXDUZipdOvoT4qjk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790567250; c=relaxed/simple;
	bh=1pI2NvRt6AwO0gUDO3bhyE0t/VpIyoWVA0DZ93oNm/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=j/3jJ0dQe25j1IBvqteMq72JS9eLjBdQsB/eTSpp+rTy4Shybo94LJ5uMTpCtEZajr49jx8nTZZKx7g80TGIs6JEV7NqFbx9uKAkbYpVMMpzG2SiUlP4Q2y9pwZ16FB6u8SC9Wgzdk38WweFjX5zV0z652Dwb2KJGngVp/z3L/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=NJ1HWfh2; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="NJ1HWfh2"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ln/09fRuQVnxo0OTaplP2HOn3wcpsCViwKAKRqmzVDw=;
	b=NJ1HWfh2PO2/3yR6tlYBe9VtXj7bJ5/Mm5hMvaQdzaK844BBCegcu8qQoymVhoRVi1WJ94VTE
	aApR0QSzhgl/ie9PKpuUpNCtgfuYbMzL9zJHHam9enp5JCLz6gXz7Nvyn/rCQjF50EcPmfZ24Dm
	CEnBxK8bk4USR0udYv6LoRY=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4htRlF4Q37zKm9J;
	Mon, 28 Sep 2026 11:35:05 +0800 (CST)
Received: from kwepemp500010.china.huawei.com (unknown [7.202.195.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 4DDDF40565;
	Mon, 28 Sep 2026 11:47:17 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500010.china.huawei.com (7.202.195.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 28 Sep 2026 11:47:17 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 28 Sep 2026 11:47:16 +0800
Message-ID: <abedcbaf-9c98-b927-5ec4-3e7a8ee8c8e7@huawei.com>
Date: Mon, 28 Sep 2026 11:47:16 +0800
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
 <ddfd984f-4690-5c0d-76ca-30bd505e3ab1@huawei.com>
 <a58c704f-be1c-406d-a512-933d38cce44a@linux.dev>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <a58c704f-be1c-406d-a512-933d38cce44a@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/9/22 18:37, John Garry wrote:
> On 9/22/26 04:10, yangxingui wrote:
>>>>
>>>> It is also a narrow trigger: a directly-attached ATA device resets its
>>>> phy via lldd_control_phy() (no SMP IO), so it needs an expander-
>>>> attached ATA device whose EH lands inside the drain of a runtime
>>>> resume - which is why the testing of 3dbbbf656b85, whose scenario was
>>>> the disk-wake race, did not catch it.
>>>
>>> uh, the expander-attached SATA disk scenario would be a very common 
>>> scenario - do you test this always when developing this code?
>> Yes，we do have a full test suite, but it runs per machine topology. The
>> 3dbbbf656b85 validation ran on the direct-attach configuration, since
>> the HA resume race it was fixing was originally reported there. The
>> expander topology was covered in the next test round, and this
>> deadlock showed up as soon as we switched to it: on that topology
>> every ATA port resume goes through the EH reset (that is how
>> ata_sas_port_resume() is implemented), so the SMP IO against the
>> ongoing runtime resume happens on essentially every cycle.
>>
> 
> So it seems that the expander-attached scenario was not tested for that 
> comment mentioned.
> 
> You need to test directly-attached and expander-attached config for any 
> relevant patchset.
> 
> Otherwise we have this scenario that alternate configs are continually 
> broken.

Understood, we will cover both configurations going forward.

> 
>>>>
>>>> Given that, should Fixes: point at 3dbbbf656b85 instead? I kept
>>>> 0da7ca4c4fd9 as that is where the pm_runtime_get_sync() being fixed
>>>> comes from, but the deadlock itself only exists where 3dbbbf656b85
>>>> is.
>>>>
>>> I am just wondering why this needs to be fixed so many times...
>> Aha - each respin addressed a review finding on the PM
>> reference handling, not a re-fix of the deadlock. The core fix is
>> unchanged since v1.
>>>
>>>
>>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>>> b/drivers/scsi/libsas/ sas_expander.c
>>> index 811c9eb4fef1..5a8cdd3682fe 100644
>>> --- a/drivers/scsi/libsas/sas_expander.c
>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>> @@ -61,8 +61,22 @@ static int smp_execute_task_sg(struct 
>>> domain_device *dev,
>>>       struct sas_internal *i =
>>>           to_sas_internal(dev->port->ha->shost->transportt);
>>>       struct sas_ha_struct *ha = dev->port->ha;
>>> -
>>> -    pm_runtime_get_sync(ha->dev);
>>> +    bool ha_resuming = test_bit(SAS_HA_RESUMING, &ha->state);
>>> +
>>> +    /*
>>> +     * While the host is resuming, ha->dev may be RPM_RESUMING and
>>> +     * the resume blocked in sas_drain_work() waiting for this very
>>> +     * SMP IO, so waiting for the host to resume here would deadlock.
>>> +     * Hold the reference without resuming, the hardware is already
>>> +     * initialized by the LLDD before sas_resume_ha() runs.
>>> +     */
>>> +    if (ha_resuming) {
>>> +        pm_runtime_get_noresume(ha->dev);
>>> +    } else {
>>> +        res = pm_runtime_resume_and_get(ha->dev);
>>>
>>> why change from pm_runtime_get_sync() to pm_runtime_resume_and_get()?
>>
>> That addresses the pre-existing issue which Sashiko flagged:
> 
> Then that would be a separate change.

Ok. With the resume moved to the BSG entry point this is
resolved naturally: smp_execute_task_sg() uses get_noresume() (void
return, nothing to check), and the resume_and_get() at the callsite
checks its result.
> 
>> the
>> return value of pm_runtime_get_sync() was ignored, so on a failed
>> resume the code would blindly proceed to submit the SMP task anyway.
>> Simply checking the return of pm_runtime_get_sync() would be awkward:
>> it keeps the usage counter incremented even on failure, so the error
>> path would also need a manual pm_runtime_put_noidle() to balance it.
>> pm_runtime_resume_and_get() rolls the counter back internally and
>> returns 0 or an errno, so the check is just "if (res) return res;"
>>
>>>
>>> +        if (res)
>>> +            return res;
>>> +    }
>>>
>>> So when is it required to really do pm_runtime_resume_and_get() (and 
>>> not pm_runtime_get_noresume())? I mean, when is this called such that 
>>> we need to resume the ha->dev?
>> Outside the resume window, the caller that needs the resume is BSG
>> userspace SMP requests (sas_smp_handler): ses/expander tools query
>> the topology at any time and nothing else holds the host awake, so
>> the host may have autosuspended; the resume also re-registers the
>> devices (the PHYE -> dev_found path runs inside the resume), so the
>> IO can proceed. This is the case 0da7ca4c4fd9 was written for.
>> The other callers either cannot run while the host is suspended or
>> already hold their own PM reference, so they never exercise the
>> resume path.
> 
> So then could the RPM resume calls be moved higher up, like at the 
> smp_execute_task_sg() callsite? Would that work?

Yes, that works and is cleaner:

@@ smp_execute_task_sg()
-	pm_runtime_get_sync(ha->dev);
+	/*
+	 * Non-blocking: a sync resume here would deadlock against
+	 * sas_drain_work() during HA resume.
+	 */
+	pm_runtime_get_noresume(ha->dev);
  	...
-	pm_runtime_put_sync(ha->dev);
+	pm_runtime_put(ha->dev);

@@ sas_smp_handler()
+	/*
+	 * The host may have autosuspended. This is the only
+	 * smp_execute_task_sg() caller which can find it suspended,
+	 * so resume it here.
+	 */
+	ret = pm_runtime_resume_and_get(dev->port->ha->dev);
+	if (ret)
+		goto out;
+
  	ret = smp_execute_task_sg(dev, job->request_payload.sg_list,
  			job->reply_payload.sg_list);
+
+	pm_runtime_put(dev->port->ha->dev);

The get_noresume() is kept for the discovery path.  Discovery work
normally runs inside an event worker's PM reference, taken at
sas_notify_port_event() notify time and held until the handler has
flushed the disco queue.  The exception is sas_rediscover_ex_phy(),
which requeues DISCE_REVALIDATE_DOMAIN from within the revalidation
worker itself: flush_workqueue() does not wait for work items queued
during execution, so that chained revalidation runs with no outer PM
reference and its SMP could race autosuspend.

We confirmed this race by fault injection on expander-attached SATA:
with the usage hold removed, the host autosuspended while the chained
revalidation was issuing its SMP and the command timed out against
the suspending host.  With the get_noresume() in place, the same test
shows the suspend attempt being caught by the existing usage check in
_suspend_v3_hw() ("PM suspend: host status cannot be suspended") and
aborted, so the revalidation completes with the host active.

For the original deadlock, the SMP which the resume path itself
issues (sas_ata_hard_reset() -> sas_phy_reset() ->
sas_smp_phy_control()) now completes normally during HA resume, and
BSG SMP queries against an autosuspended host resume it correctly.

> 
> The check which you initially proposed for testing SAS_HA_RESUMING looks 
> racy.

Right, the check is gone entirely with this restructure.

Thanks for the guidance.  I'll send v4.

Thanks,
Xingui
.

