Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C334A3D5D
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999557; cv=none; b=Z+aGaRKSEs84JWKgdlQnM0RlzpJeVpx6LpQDaXb9bsdiP9so7UvzfMHAql4zBqsNLsovWypX7HP/IvfzUBUmBajgKSo7rz7hbf6P/mkwNtSyn9AwZ4rRULgKBzGnyO3A+v9RNY1n5gbLIsXu6q+iYkLXmIJxbNtiXcG+sxTYNPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999557; c=relaxed/simple;
	bh=sv5IypIgEI13ebg5/SpkNFBLXvflcqcFz54Dum5Wb+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ulea4i7SeXaN7sGmkFoy39W6EK7PkPMsQwrSVjUuBJ5SiRrWLkBTqLXLXXTJFCZ66H6J2pLXOosKHtKXWuGNl/+Erh15U9d5ajpodrohq/looq2pqnU7L+JyxLAr6NRHT/eUdacYUNOi98b7GoaX/IOS8oZvzBUrlWx2sMsW4jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uKZ5dpER; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uKZ5dpER"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sv5IypIgEI13ebg5/SpkNFBLXvflcqcFz54Dum5Wb+E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789999553; v=1; x=1790604353;
 b=uKZ5dpERP6wlwP8wM3rTQgQNk1SXr5MqbeOQIzfB0wCzTEZ1VXVrQCHtgisvk82uPCVqDTRG
 MkZacrBAkHJxRqqegiUu9ZIio8Keup4NySVVGVLakTfsXkSQgI910bJbdG4rWLT9J32ACQytLvI
 B2iSWC5e5cQpTltVWPm8oQL8=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 2392f7eb4c68b734;
	Mon, 21 Sep 2026 14:05:53 +0000
X-Mizu-Trace-ID: 2392f7eb4c68b734
X-Migadu-Flow: FLOW_OUT
Message-ID: <627a27fc-b025-4bc1-8601-b0fca0e1c4e1@linux.dev>
Date: Mon, 21 Sep 2026 15:05:48 +0100
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
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <bab95bba-3091-30e5-91ba-0fd459db0101@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/21/26 13:21, yangxingui wrote:
> Hi, John
> 
> On 2026/9/21 19:37, John Garry wrote:
>> On 9/18/26 08:03, Xingui Yang wrote:
>>> When the controller resumes, sas_resume_ha() -> sas_drain_work()
>>> processes the DISCE_RESUME work, which restores the ATA ports through
>>> the libata error handler (ata_sas_port_resume() requests ATA_EH_RESET)
>>> and waits for it in sas_ata_flush_pm_eh(). For an expander-attached
>>> ATA device the hard reset in that recovery is an SMP PHY CONTROL
>>> command sent to the expander:
>>>
>>>    ata_eh_recover() -> ata_eh_reset() -> sas_ata_hard_reset()
>>>      -> lldd_I_T_nexus_reset() -> sas_phy_reset()
>>>        -> sas_smp_phy_control() -> smp_execute_task_sg()
>>
>> This seems like an obvious issue. How come it was not found earlier? 
>> It is apparently fixing a patch which is 5 years old.
> 
> The deadlock was not reachable for most of those 5 years - it is a
> regression of 3dbbbf656b85 ("scsi: libsas: Fix HA resume deadlock and
> hisi_sas disk-wake race"), which restored the draining sas_resume_ha()
> in hisi_sas.
> 
> 0da7ca4c4fd9 was part of the same 2021 series as fbefe22811c3 ("Don't
> always drain event workqueue for HA resume"), which switched hisi_sas
> to the non-draining sas_resume_ha_no_sync(). The two were designed
> together: without the drain, nothing in the resume path waits on the
> ATA error handling, so the pm_runtime_get_sync() in
> smp_execute_task_sg() could at most delay the EH until the resume
> callback returned - no circular wait.
> 
> 3dbbbf656b85 restored the drain to fix the disk-wake race (the
> controller autosuspending while disks were still waking up), which for
> the first time made the resume wait on the ATA EH - and with it the
> SMP PHY CONTROL for an expander-attached ATA device. So the deadlock
> window is really since 3dbbbf656b85, not since 0da7ca4c4fd9.
> 
> It is also a narrow trigger: a directly-attached ATA device resets its
> phy via lldd_control_phy() (no SMP IO), so it needs an expander-
> attached ATA device whose EH lands inside the drain of a runtime
> resume - which is why the testing of 3dbbbf656b85, whose scenario was
> the disk-wake race, did not catch it.

uh, the expander-attached SATA disk scenario would be a very common 
scenario - do you test this always when developing this code?

> 
> Given that, should Fixes: point at 3dbbbf656b85 instead? I kept
> 0da7ca4c4fd9 as that is where the pm_runtime_get_sync() being fixed
> comes from, but the deadlock itself only exists where 3dbbbf656b85
> is.
> 
I am just wondering why this needs to be fixed so many times...


diff --git a/drivers/scsi/libsas/sas_expander.c 
b/drivers/scsi/libsas/sas_expander.c
index 811c9eb4fef1..5a8cdd3682fe 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -61,8 +61,22 @@ static int smp_execute_task_sg(struct domain_device *dev,
  	struct sas_internal *i =
  		to_sas_internal(dev->port->ha->shost->transportt);
  	struct sas_ha_struct *ha = dev->port->ha;
-
-	pm_runtime_get_sync(ha->dev);
+	bool ha_resuming = test_bit(SAS_HA_RESUMING, &ha->state);
+
+	/*
+	 * While the host is resuming, ha->dev may be RPM_RESUMING and
+	 * the resume blocked in sas_drain_work() waiting for this very
+	 * SMP IO, so waiting for the host to resume here would deadlock.
+	 * Hold the reference without resuming, the hardware is already
+	 * initialized by the LLDD before sas_resume_ha() runs.
+	 */
+	if (ha_resuming) {
+		pm_runtime_get_noresume(ha->dev);
+	} else {
+		res = pm_runtime_resume_and_get(ha->dev);

why change from pm_runtime_get_sync() to pm_runtime_resume_and_get()?

+		if (res)
+			return res;
+	}

So when is it required to really do pm_runtime_resume_and_get() (and not 
pm_runtime_get_noresume())? I mean, when is this called such that we 
need to resume the ha->dev?
