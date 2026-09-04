Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2644A2041
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788529325; cv=none; b=h5kLDpx1Oy2IhPmn24YNQjJtn/BNJSU3EGElg7wU1ogVv7nwuYeYtgrobJ1gITtp/AP4SUk7zhvW29TcH99ntyreKz4nLPVE12v7dJMn0H0R+cu/hs6MKT/dV3ZrWM3aaj/W74b8at8tMTJibgjAKHuzllhquWnP0SLoYjX605Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788529325; c=relaxed/simple;
	bh=gWIIqAYa7JwgMqe3ng6cFBLQxMyS39YunS7cWQHkFq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhWcCFYWj184o+g/HZKm608UraGwaoprLxTnZHU9ThhT21srPNAlPUaLG1wiEHvZONorvg5bMj1K9tNqwiVpaF957sfXb3o6VnwzlIF2os9o3A9hMbYgVqIL6JjPf6vNa7gA54/ftqPX0ySEkFq23JLHjMoWPV5SqmabChePUL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mC8oCDCQ; arc=none smtp.client-ip=95.215.58.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mC8oCDCQ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gWIIqAYa7JwgMqe3ng6cFBLQxMyS39YunS7cWQHkFq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788529320; v=1; x=1789134120;
 b=mC8oCDCQcPWxQ7hNzp7g5/seLUPqdhrrTMtaR4m5n65FoRKSTL4bMgPkXKLBhs3R7bhKIowo
 tuqz5SX7yaCGlC/DndshyRvOphsskH+Z/CXnBiICTviXG5T25+C4hAjXAeRf+U0cl0SFdThKADS
 y+pc79QvSekl6g93CLAcecEw=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id ae4793192e6b9aed;
	Fri, 04 Sep 2026 13:42:00 +0000
X-Mizu-Trace-ID: ae4793192e6b9aed
X-Migadu-Flow: FLOW_OUT
Message-ID: <117e96e3-f1c6-4a84-94b0-8c164cab209b@linux.dev>
Date: Fri, 4 Sep 2026 14:41:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 16/27] scsi-multipath: clear path when device is
 blocked
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-17-john.g.garry@oracle.com>
 <20260901110210.2409C1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901110210.2409C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:02, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Calling synchronize_srcu() inside an iteration loop defeats bulk quiesce optimizations and stalls transport error recovery.
> - [High] Path clearing is missing for devices blocked natively by low-level drivers.
> - [High] TOCTOU race in `scsi_device_block` accessing `sdev->scsi_mpath_dev` without locking causes NULL pointer dereferences and Use-After-Free during device initialization or removal.
> --
> 
> commit a4233dac056f9047f69ee519256fc76b917ab456
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clear path when device is blocked
>      
> This commit adds scsi_mpath_dev_clear_path() and invokes it from
> scsi_device_block() to clear a device path when it becomes blocked.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index af27fd3df8d46..f02b3a50e20cd 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
> [ ... ]
>> @@ -3009,6 +3010,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
>>   		scsi_stop_queue(sdev);
>>   
>>   	mutex_unlock(&sdev->state_mutex);
>> +	if ((err == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_dev_clear_path(sdev->scsi_mpath_dev);
> 
> [Severity: High]
> Is there a TOCTOU race when accessing sdev->scsi_mpath_dev after releasing
> the state_mutex?
> 
> If __scsi_remove_device() runs concurrently on another CPU, it can acquire
> the state_mutex, change the state to SDEV_DEL, release the lock, and invoke
> scsi_mpath_remove_device(), which sets scsi_mpath_head to NULL.
> 
> Since err was cached as 0, this execution path could proceed to safely
> evaluate the if-statement, then call scsi_mpath_dev_clear_path(), resulting
> in a NULL pointer dereference on scsi_mpath_head.

That will not happen unless the sdev disappears, which should not happen 
when scsi_device_block() is being called.

> 
> 
> [Severity: High]
> Are low-level driver initiated blocks missing this path clearing logic?
> 
> When low-level drivers natively block devices due to hardware errors, they
> call scsi_internal_device_block_nowait(). This bypasses scsi_device_block()
> entirely and directly calls scsi_stop_queue(sdev), meaning multipath
> failover won't be triggered.
> 
> Should path clearing be added for native blocks as well?

No, as mpath_clear_current_path() -> mpath_synchronize() may block. Not 
clearing paths is not critical, as we should not use the path if it is 
disabled anyway.

> 
>>   
>>   	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
>>   		  __func__, dev_name(&sdev->sdev_gendev), state);
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 68fe50f62158c..b16fe6a55fa73 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
>> @@ -238,6 +238,16 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct mpath_device *mpath_device = &scsi_mpath_dev->mpath_device;
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +       if (mpath_clear_current_path(mpath_device))
>> +               mpath_synchronize(mpath_head);
> 
> [Severity: High]
> Does this code stall bulk quiesce operations during error recovery?
> 
> This function is called by scsi_device_block(), which is executed in a loop
> for all targets and LUNs during error recovery:
> 
> scsi_block_targets()
>    device_for_each_child() -> target_block()
>      starget_for_each_device() -> scsi_device_block()
> 
> Since mpath_synchronize() is a wrapper for synchronize_srcu(), waiting
> synchronously on an SRCU grace period here inside the loop could result in
> multi-second stalls, potentially cascading into command timeouts and
> unrecoverable host resets.
> 

We can address it if it becomes a real problem.
