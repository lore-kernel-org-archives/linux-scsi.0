Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0D544AB9D
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 10:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517714; cv=none; b=m9rnMess/QtATHfj4z6RMZ6q8VcmrPdogpQjwmkRWki96avVIT+zcNOk05f1CusDiixo+Gz6MGtF2+4woBLgDjnhXcb/YRL9kJhmZWZmZ2vTxmNbKWe4h+bbMv0EEtG4AlQhOs5Lrzx8jGYTCMFzteT0+keWTjhZ+qh+s8UFnnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517714; c=relaxed/simple;
	bh=z4R36ZA/T7Ab+zK4BLS9IjXROG1y96L29XGD9o8l6MU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bFr8BGQhXyiICF25lXLTgZ0B8UNW+y5K1hjk3vh0UgwpesjVVR9MpBs/vK7PgT645nsRHDgeNieCPjvZfJgDvfDCrWBiPYOxt4J/nXqRsehAao4+XTVOVY5DeyiBY36CuIp0+QJXAXzjQ11zWEHazaJKk4c+iAs+1p93IzZg1pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XCTCvs1X; arc=none smtp.client-ip=95.215.58.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XCTCvs1X"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=z4R36ZA/T7Ab+zK4BLS9IjXROG1y96L29XGD9o8l6MU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788517710; v=1; x=1789122510;
 b=XCTCvs1XU0n8bt3v0YwVmhRmUQEPC1SSjDdnN8u7/jVeosUppuYew4oXUTmwHNLFVNVhrlQt
 qR7ksOExJCOSNFksiBDgtD7YzL9TOwHnFBl4TDSM/kS3FjOTz1pfA5XMaAxJgc9FyB4tUerv3/s
 8p/YZCZVMpjtN7CyZW+i36/M=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 2a8bbbdeaa5ab8bb;
	Fri, 04 Sep 2026 10:28:30 +0000
X-Mizu-Trace-ID: 2a8bbbdeaa5ab8bb
X-Migadu-Flow: FLOW_OUT
Message-ID: <434526d4-4996-4de3-a3b6-29860bc178b8@linux.dev>
Date: Fri, 4 Sep 2026 11:28:29 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 17/27] scsi-multipath: revalidate paths upon device
 unblock
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-18-john.g.garry@oracle.com>
 <20260901111258.4F9381F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901111258.4F9381F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:12, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Unsynchronized access to `sdev->scsi_mpath_dev` in `scsi_internal_device_unblock()` races with device initialization, leading to a NULL pointer dereference or Use-After-Free.
> --
> 
> commit 9827c5b37e1215c845ce584c07c0fadae92e797b
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: revalidate paths upon device unblock
> 
> This commit revalidates paths when a scsi_device is unblocked. It clears
> any paths and requeues queued bios as part of the revalidation process.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index f02b3a50e20cd..189263ce56624 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -3093,6 +3093,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
>>   	mutex_lock(&sdev->state_mutex);
>>   	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
>>   	mutex_unlock(&sdev->state_mutex);
>> +	if ((ret == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
> 
> [Severity: High]
> Does this lockless access to sdev->scsi_mpath_dev race with device
> initialization?
> 
> If a transport unblock event occurs concurrently with hardware discovery,
> scsi_internal_device_unblock() might read sdev->scsi_mpath_dev while it is
> being initialized.

That should not happen - sdev->scsi_mpath_dev setup is done before that 
sdev is even added and transport would be calling unblock on it.

> 
> For instance, scsi_multipath_sdev_init() publishes the pointer before
> initialization is fully complete:
> 
> drivers/scsi/scsi_multipath.c:scsi_multipath_sdev_init() {
>      ...
>      scsi_mpath_dev->sdev = sdev;
>      sdev->scsi_mpath_dev = scsi_mpath_dev;
>      ...
> }
> 
> Could calling scsi_mpath_revalidate_paths() here lead to a NULL pointer
> dereference when it attempts to access an uninitialized scsi_mpath_head?
> 
> Additionally, if initialization fails and the structure is freed in the error
> path, could this result in a use-after-free?

Again, the same as above.

> 
>>   
>>   	return ret;
>>   }
> 
> [ ... ]
> 

