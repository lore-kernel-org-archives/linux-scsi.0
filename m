Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6E84FC8D7
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 13:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567104; cv=none; b=ZKneQAhf1kieB32De4P/zyjzJxztAEedtlYvB0KW+u/ae8nX7qMK0+eZ1Gl6CNofFO9SzgvA4bBDEGwU2vaxemPfxc0NkhjCe+qCPdRKgLBKGgeWDe3xL9xyPQwC6XkIwWkhm+7StoS8ieCOiRFXHWh7OSfgF7CaqR0HtcOHDCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567104; c=relaxed/simple;
	bh=iiDYDHl9MKLKZ1/61/xpTK1CbKNRPXrS/wvReXuYRwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4wvpkTF6x4kr4/KLSGMVzbVegdfTS+emG2vrnVU/4BrW7rojM3tU3i7w8XjUgAV3+ej+qS/a5GYMoT0ui58/JhPjYcN03mYSLuvcgWJeyg/8O82qs/b+FBcvWV1pEcZ7qm0fWH4tbot/IUlbtvokrlwjbDEUABiyRuR9v1PpaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ba+bZUhJ; arc=none smtp.client-ip=91.218.175.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ba+bZUhJ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=iiDYDHl9MKLKZ1/61/xpTK1CbKNRPXrS/wvReXuYRwQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789567097; v=1; x=1790171897;
 b=Ba+bZUhJVZRNGz4Vo1lf2EfxsimXws44RGyCkaigz7bSfQHDHD4gTXhf0A8olb3L870aSvnM
 JIRNySaThwnfuATqHAlACmxfepHD5LkY5OBf3oBvP1XNKRqe9BG5d2cGX2hqGUtWzSga3VCArwr
 2AzR8hwg1QBUDZqOCWwNuTiY=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id a6997d378aa2180c;
	Wed, 16 Sep 2026 13:58:07 +0000
X-Mizu-Trace-ID: a6997d378aa2180c
X-Migadu-Flow: FLOW_OUT
Message-ID: <2c1aee3c-3ea5-44f7-915c-5a812a261032@linux.dev>
Date: Wed, 16 Sep 2026 14:58:02 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix SMP IO deadlock during HA resume
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260826032845.1632348-1-yangxingui@huawei.com>
 <a97c6cfb-8476-1030-a07a-fea1c004ecbe@huawei.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <a97c6cfb-8476-1030-a07a-fea1c004ecbe@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/11/26 02:00, yangxingui wrote:
> Hi John & Jason,
> 
> Kindly ping for review...

What about the sashiko comment:

- [High] Bypassing PM reference counting via a global state flag creates 
a race condition where concurrent independent threads can submit SMP 
I/Os without holding a PM reference, risking premature hardware suspend.

It looks correct.

> 
> On 2026/8/26 11:28, Xingui Yang wrote:
>> During sas_resume_ha() -> sas_drain_work(), 

This is poorly described - what does during sas_resume_ha() -> 
sas_drain_work() even mean?

> ATA EH will trigger SMP 
>> IOs via
>> sas_phy_reset() -> sas_smp_phy_control() for expander-attached ATA 
>> devices.

What commands are these specifically?

>> Since ha->dev is RPM_RESUMING at that point, pm_runtime_get_sync() blocks
>> waiting for the resume to finish, but the resume is blocked in
>> sas_drain_work() waiting for the SMP IO — a deadlock.
>>
>> Skip the PM get/put when SAS_HA_RESUMING is set. The hardware is already
>> initialized by the LLDD resume callback before sas_resume_ha() runs, 
>> so no
>> explicit resume is needed.
>>
>> Only hisi_sas enables runtime PM among libsas LLDDs, so other drivers
>> (pm8001, isci, aic94xx, mvsas) are unaffected.
>>
>> Fixes: 0da7ca4c4fd9 ("scsi: libsas: Resume host while sending SMP I/Os")
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_expander.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/ 
>> sas_expander.c
>> index 811c9eb4fef1..77ae2ae7b2c4 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -61,8 +61,17 @@ static int smp_execute_task_sg(struct domain_device 
>> *dev,
>>       struct sas_internal *i =
>>           to_sas_internal(dev->port->ha->shost->transportt);
>>       struct sas_ha_struct *ha = dev->port->ha;
>> -
>> -    pm_runtime_get_sync(ha->dev);
>> +    bool skip_pm = test_bit(SAS_HA_RESUMING, &ha->state);
>> +
>> +    /*
>> +     * Skip PM get/put during HA resume to avoid deadlock: the host is
>> +     * RPM_RESUMING and the drain waits for this SMP IO to finish, but
>> +     * pm_runtime_get_sync() would block on RPM_RESUMING. Safe because
>> +     * hardware is already initialized by the LLDD before call
>> +     * sas_resume_ha().
>> +     */
>> +    if (!skip_pm)
>> +        pm_runtime_get_sync(ha->dev);
>>       mutex_lock(&dev->ex_dev.cmd_mutex);
>>       for (retry = 0; retry < 3; retry++) {
>>           if (test_bit(SAS_DEV_GONE, &dev->state)) {
>> @@ -135,7 +144,8 @@ static int smp_execute_task_sg(struct 
>> domain_device *dev,
>>           }
>>       }
>>       mutex_unlock(&dev->ex_dev.cmd_mutex);
>> -    pm_runtime_put_sync(ha->dev);
>> +    if (!skip_pm)
>> +        pm_runtime_put_sync(ha->dev);
>>       BUG_ON(retry == 3 && task != NULL);
>>       sas_free_task(task);
>>

