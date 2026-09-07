Received: from mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158CD45038
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783043; cv=none; b=T+2dZlrrarO1JxSoOOL0RQ44j8BYb1jndljXGxbyuAtTnEbbwF+5O/1xzM4Ixivzkjfl21MrxsKhj8mgZuXbRWjmyZ2lOTKvJ+0rXQtW1S90HXf18foyr5FAJrdZWoaApjKwxBUDN39H1QPi3EWekQbJ9JJrf/Yavx88BgRovPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783043; c=relaxed/simple;
	bh=5QMaGMhloJZ8X7unOM4uVeF7Ycv2Zye+o487DoK3d/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=frAULDMXP+y7mTzlFCvkknK/HbuYgVirT674D4Mz1alQKOwaSNGfakVJrqBJEUEJ9JfhLMoiN9t9rhzwShtkof0kXUghkt9WOZJj2BLQi2LjKyPYzKRr/+X5KurrMeSPCZFOrHy319Lxoss/XAzZwZtdyZnGwD3aOlyKXrtT+VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jeC99CA3; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jeC99CA3"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5QMaGMhloJZ8X7unOM4uVeF7Ycv2Zye+o487DoK3d/Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788783039; v=1; x=1789387839;
 b=jeC99CA3rHdX9vBstRJqaBIBkZFU3qaYdm3j6IpAnwUUuSsPiDePtnRvhELghaJkjlzYL6uk
 stP9MIqgRYu/rPVTmNA6tBTG+lVONGclIVKgSJwcyB5OaX2I1zSiLlj6T9+rfGNvdz4LLJpINsG
 xWuSCBj4uqHjpik75ztwaKe4=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id dcd267842b1cde3d;
	Mon, 07 Sep 2026 12:10:29 +0000
X-Mizu-Trace-ID: dcd267842b1cde3d
X-Migadu-Flow: FLOW_OUT
Message-ID: <02d55880-ac40-4cbc-82fe-d175c81bbd19@linux.dev>
Date: Mon, 7 Sep 2026 13:10:28 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 17/27] scsi-multipath: revalidate paths upon device
 unblock
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-18-john.g.garry@oracle.com>
 <20260907115604.63C811F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907115604.63C811F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 12:56, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Concurrent invocation of device block/unblock during initialization dereferences a NULL scsi_mpath_head.
> - [High] TOCTOU race in scsi_device_block and scsi_internal_device_unblock accessing multipath state outside state_mutex, causing a NULL pointer dereference during device teardown.
> --
> 
> commit d9e004c51ebcdd24da98702a7fb3f90971c90665
> Author: John Garry <john.garry@linux.dev>
> 
>      scsi-multipath: revalidate paths upon device unblock
> 
> This patch adds a revalidation step for multipath devices when a scsi_device
> is unblocked, clearing paths and requeuing any queued bios.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 56200a7f5c748..1a6f5e1fd80cb 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -3093,6 +3093,8 @@ static int scsi_internal_device_unblock(struct scsi_device *sdev,
>>   	mutex_lock(&sdev->state_mutex);
>>   	ret = scsi_internal_device_unblock_nowait(sdev, new_state);
>>   	mutex_unlock(&sdev->state_mutex);
>> +	if ((ret == 0) && sdev->scsi_mpath_dev)
>> +		scsi_mpath_revalidate_paths(sdev->scsi_mpath_dev);
> 

See response for v7

> [Severity: High]
> Are there race conditions involving multipath state modification outside of
> the sdev->state_mutex?
> 
> It appears a concurrent __scsi_remove_device() could acquire state_mutex,
> transition the device to SDEV_CANCEL or SDEV_DEL, and call
> scsi_mpath_remove_device(). This sets scsi_mpath_dev->scsi_mpath_head to
> NULL. When scsi_internal_device_unblock() resumes, it could call
> scsi_mpath_revalidate_paths() which then attempts to use the NULL pointer.
> 
> Is it also possible for this code to execute on a partially initialized
> multipath device?
> 
> During device discovery, scsi_mpath_dev_alloc() assigns sdev->scsi_mpath_dev
> but initially leaves scsi_mpath_dev->scsi_mpath_head as NULL while
> performing a blocking INQUIRY. If a transport event (like a link flap)
> concurrently triggers scsi_target_block() and scsi_target_unblock(),
> scsi_internal_device_unblock() could be called and operate on the still-NULL
> scsi_mpath_head.
> 
> The same unprotected call pattern appears to exist in scsi_device_block(),
> which was introduced in a prior patch in this series.
> 
> [ ... ]
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index b16fe6a55fa73..456351fee4b98 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -238,6 +238,14 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
>>   	return 0;
>>   }
>>   
>> +void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
>> +{
>> +       struct scsi_mpath_head *scsi_mpath_head = scsi_mpath_dev->scsi_mpath_head;
>> +       struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
> 
> [Severity: High]
> If scsi_mpath_head is NULL due to the races mentioned above during unblock
> or block operations, will this unconditionally dereference the NULL pointer
> when calculating the offset for mpath_head?
> 

