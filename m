Received: from mta1.migadu.com (out-143.mta1.migadu.com [95.215.58.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579D751A127
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790073466; cv=none; b=BjlDNeITpvwtuVHBCItQ6y3CRzKCkdSXlNHn3lhz6H5iGhi50jb2CvjLESqTFy60PngLmdX4aESAmkgaTvNIxNPfmShMF7YC5DKyOMtLwTTpqJtC6be6Tgw9I6Ra5lqw9pfmPZmGhtJFWNyS/Vi4PTVkZWg6gfxTkD7tD86JgYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790073466; c=relaxed/simple;
	bh=hOQCikqeresRs28eGornj2bzQ3r41eUFX91G9l/2z3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h5QCbRg6Ol0D36Xspxdv6nRdyBMoEDRnD3AaDjoDVM9sw8Zvq1x9sdPBmA/RIhMFz7XTvloxYbe6c0ltD0ukAwZvKdkz/fPRCriujQl8eETjIb1Uk/Kx+0/QdDKNPu+TK1MNVOFofQ+d3QeLh1td1rObsX8oHuTxTHKtrRJLXz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fiiOCG2z; arc=none smtp.client-ip=95.215.58.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fiiOCG2z"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hOQCikqeresRs28eGornj2bzQ3r41eUFX91G9l/2z3c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790073461; v=1; x=1790678261;
 b=fiiOCG2zAAOO8bqcgS3IUOm+YRG1lPxcca+I2CuxCosIPYoYoZPPwHZSiDB1Oem5FKo91Xtr
 +X3tqENu2EdQtv1NOrhST8amrihxE1nyfAbUVkZe+XXYr2Lo9/shj+AzoE8Ck5HH/FfbQigJNY8
 HSK1bs+Q0PnSxqgVPMi5sC0s=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 7c9d515ba9949150;
	Tue, 22 Sep 2026 10:37:41 +0000
X-Mizu-Trace-ID: 7c9d515ba9949150
X-Migadu-Flow: FLOW_OUT
Message-ID: <a58c704f-be1c-406d-a512-933d38cce44a@linux.dev>
Date: Tue, 22 Sep 2026 11:37:35 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: libsas: Fix SMP IO deadlock during HA resume
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
 jejb@linux.ibm.com, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260918070307.381207-1-yangxingui@huawei.com>
 <9a72eeb3-ca32-4241-9e21-74cf894a9bf1@linux.dev>
 <bab95bba-3091-30e5-91ba-0fd459db0101@huawei.com>
 <627a27fc-b025-4bc1-8601-b0fca0e1c4e1@linux.dev>
 <ddfd984f-4690-5c0d-76ca-30bd505e3ab1@huawei.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <ddfd984f-4690-5c0d-76ca-30bd505e3ab1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/22/26 04:10, yangxingui wrote:
>>>
>>> It is also a narrow trigger: a directly-attached ATA device resets its
>>> phy via lldd_control_phy() (no SMP IO), so it needs an expander-
>>> attached ATA device whose EH lands inside the drain of a runtime
>>> resume - which is why the testing of 3dbbbf656b85, whose scenario was
>>> the disk-wake race, did not catch it.
>>
>> uh, the expander-attached SATA disk scenario would be a very common 
>> scenario - do you test this always when developing this code?
> Yes，we do have a full test suite, but it runs per machine topology. The
> 3dbbbf656b85 validation ran on the direct-attach configuration, since
> the HA resume race it was fixing was originally reported there. The
> expander topology was covered in the next test round, and this
> deadlock showed up as soon as we switched to it: on that topology
> every ATA port resume goes through the EH reset (that is how
> ata_sas_port_resume() is implemented), so the SMP IO against the
> ongoing runtime resume happens on essentially every cycle.
> 

So it seems that the expander-attached scenario was not tested for that 
comment mentioned.

You need to test directly-attached and expander-attached config for any 
relevant patchset.

Otherwise we have this scenario that alternate configs are continually 
broken.

>>>
>>> Given that, should Fixes: point at 3dbbbf656b85 instead? I kept
>>> 0da7ca4c4fd9 as that is where the pm_runtime_get_sync() being fixed
>>> comes from, but the deadlock itself only exists where 3dbbbf656b85
>>> is.
>>>
>> I am just wondering why this needs to be fixed so many times...
> Aha - each respin addressed a review finding on the PM
> reference handling, not a re-fix of the deadlock. The core fix is
> unchanged since v1.
>>
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/ 
>> sas_expander.c
>> index 811c9eb4fef1..5a8cdd3682fe 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -61,8 +61,22 @@ static int smp_execute_task_sg(struct domain_device 
>> *dev,
>>       struct sas_internal *i =
>>           to_sas_internal(dev->port->ha->shost->transportt);
>>       struct sas_ha_struct *ha = dev->port->ha;
>> -
>> -    pm_runtime_get_sync(ha->dev);
>> +    bool ha_resuming = test_bit(SAS_HA_RESUMING, &ha->state);
>> +
>> +    /*
>> +     * While the host is resuming, ha->dev may be RPM_RESUMING and
>> +     * the resume blocked in sas_drain_work() waiting for this very
>> +     * SMP IO, so waiting for the host to resume here would deadlock.
>> +     * Hold the reference without resuming, the hardware is already
>> +     * initialized by the LLDD before sas_resume_ha() runs.
>> +     */
>> +    if (ha_resuming) {
>> +        pm_runtime_get_noresume(ha->dev);
>> +    } else {
>> +        res = pm_runtime_resume_and_get(ha->dev);
>>
>> why change from pm_runtime_get_sync() to pm_runtime_resume_and_get()?
> 
> That addresses the pre-existing issue which Sashiko flagged:

Then that would be a separate change.

> the
> return value of pm_runtime_get_sync() was ignored, so on a failed
> resume the code would blindly proceed to submit the SMP task anyway.
> Simply checking the return of pm_runtime_get_sync() would be awkward:
> it keeps the usage counter incremented even on failure, so the error
> path would also need a manual pm_runtime_put_noidle() to balance it.
> pm_runtime_resume_and_get() rolls the counter back internally and
> returns 0 or an errno, so the check is just "if (res) return res;"
> 
>>
>> +        if (res)
>> +            return res;
>> +    }
>>
>> So when is it required to really do pm_runtime_resume_and_get() (and 
>> not pm_runtime_get_noresume())? I mean, when is this called such that 
>> we need to resume the ha->dev?
> Outside the resume window, the caller that needs the resume is BSG
> userspace SMP requests (sas_smp_handler): ses/expander tools query
> the topology at any time and nothing else holds the host awake, so
> the host may have autosuspended; the resume also re-registers the
> devices (the PHYE -> dev_found path runs inside the resume), so the
> IO can proceed. This is the case 0da7ca4c4fd9 was written for.
> The other callers either cannot run while the host is suspended or
> already hold their own PM reference, so they never exercise the
> resume path.

So then could the RPM resume calls be moved higher up, like at the 
smp_execute_task_sg() callsite? Would that work?

The check which you initially proposed for testing SAS_HA_RESUMING looks 
racy.

> 
> log as follow:
> [root@localhost ~]# smp_discover /dev/bsg/expander-5\:0
>    phy  11:U:attached:[5446a2eb02349000:00  t(SSP)]  12 Gbps
>    phy  16:U:attached:[5001882016000001:00  i(SSP+STP+SMP)]  12 Gbps
>    phy  17:U:attached:[5001882016000001:01  i(SSP+STP+SMP)]  12 Gbps
>    phy  18:U:attached:[5001882016000001:02  i(SSP+STP+SMP)]  12 Gbps
>    phy  19:U:attached:[5001882016000001:03  i(SSP+STP+SMP)]  12 Gbps
>    phy  24:D:attached:[500e004aaaaaaa1e:24  V i(SSP) t(SSP)]  12 Gbps
> 
> [47910.943602] jamy pm_runtime_resume_and_get(ha->dev)
> [47910.969905] hisi_sas_v3_hw 0000:74:04.0: resuming from operating 
> state [D0]
> [47912.205965] hisi_sas_v3_hw 0000:74:04.0: neither _PS0 nor _PR0 is 
> defined
> [47912.213852] hisi_sas_v3_hw 0000:74:04.0: waiting up to 25 seconds for 
> 4 phys to resume
> [47912.268896] hisi_sas_v3_hw 0000:74:04.0: phyup: phy0 link_rate=11
> [47912.275986] hisi_sas_v3_hw 0000:74:04.0: phyup: phy1 link_rate=11
> [47912.276017] hisi_sas_v3_hw 0000:74:04.0: dev[7:2] found
> [47912.282976] hisi_sas_v3_hw 0000:74:04.0: phyup: phy2 link_rate=11
> [47912.282980] hisi_sas_v3_hw 0000:74:04.0: phyup: phy3 link_rate=11
> [47912.303834] hisi_sas_v3_hw 0000:74:04.0: dev[8:1] found
> [47912.310296] hisi_sas_v3_hw 0000:74:04.0: dev[9:1] found
> [47912.316809] hisi_sas_v3_hw 0000:74:04.0: end of resuming controller
> [47912.316817] sas: broadcast received: 0
> [47912.324219] sas: REVALIDATING DOMAIN on port 0, pid:282487
> [47912.329870] jamy pm_runtime_put(ha->dev)

