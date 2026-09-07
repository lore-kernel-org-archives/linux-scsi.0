Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B73F471CEA
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782936; cv=none; b=idFzfVnf75O8C6fnYmcNKFmuRPsa+yXaX6BXO4vM0s8yTl/MR91EMuowjiyr2UM3wdM/Cu8SwNyUKw8H6y5RkDeR/JhKSSrNRq6fc9wJA30WY+IQDUnoiCkPysm6THqcDdzuUTYkPI3xYdbNJndxfS77Nt03U5BB0Xe5yb0mkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782936; c=relaxed/simple;
	bh=kfFnSU/7zFllPOudkJHsIOLgV2JEJ2uAalpmf2UYtco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I04WhHcABxLt00V13tAlO1KsUGlNF+iMrwPxklXZdAyFBqBbhrec6w7jnMIpxneHL3m8errzNF5oJDN5Z+l64HdSrp9lNOvKjgpzERbELZEg1670kO04bRiCgHS4nGiEcXz05IpCU3q1s1yERv4YWe/A/Y7ddqZ5rnj1CxtD/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CCTQjzIt; arc=none smtp.client-ip=91.218.175.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CCTQjzIt"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kfFnSU/7zFllPOudkJHsIOLgV2JEJ2uAalpmf2UYtco=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788782932; v=1; x=1789387732;
 b=CCTQjzItLWu18Bx0Fra85IPwA6w2mwnzE6iTlV0dm8CayUXKCQTLImAiDU3dKSTud+uww+bo
 Iac8JUAD33a+bpYvEddDh+cD1RduOrEaweiz7x9xV+PwTK5klQ9lwCAtGNL1hIal5JXpdySOKE5
 u8CXkPil8/MuWQGkoGbQkIag=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 98d6343c45b2d21c;
	Mon, 07 Sep 2026 12:08:52 +0000
X-Mizu-Trace-ID: 98d6343c45b2d21c
X-Migadu-Flow: FLOW_OUT
Message-ID: <27c27730-5184-4290-9a85-6cc983caeede@linux.dev>
Date: Mon, 7 Sep 2026 13:08:51 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 16/27] scsi-multipath: clear path when device is
 blocked
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-17-john.g.garry@oracle.com>
 <20260907114906.3EC7C1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907114906.3EC7C1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 12:49, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Lockless and unrefcounted access to `sdev->scsi_mpath_dev` in `scsi_device_block()` leads to Use-After-Free and Null Pointer Dereferences during concurrent device initialization or removal.
> --
> 
> commit 352c419b223cf3635501b6ef6ac4632a3b017a6d
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: clear path when device is blocked
> 
> This commit adds scsi_mpath_dev_clear_path() and calls it from
> scsi_device_block() when a device path becomes blocked.
> 
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 48aab0df30b76..56200a7f5c748 100644
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
> Can this lockless access to sdev->scsi_mpath_dev lead to a use-after-free
> during concurrent device removal?
> 
> If __scsi_remove_device() drops the reference and clears scsi_mpath_head,
> and scsi_device_block() races with it, it drops state_mutex and then reads
> sdev->scsi_mpath_dev locklessly. Could it proceed to call
> scsi_mpath_dev_clear_path() and dereference freed pointers?
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
> 
> [Severity: High]
> Are these pointers safe to dereference during concurrent device
> initialization?
> 
> When scsi_mpath_dev_alloc() calls scsi_multipath_sdev_init(), it assigns
> sdev->scsi_mpath_dev early, before fully initializing the pointers.

Same response as v7

> 
> If a concurrent scsi_target_block() transitions the device to SDEV_BLOCK,
> could it call scsi_mpath_dev_clear_path() and dereference an uninitialized
> or null scsi_mpath_head here, resulting in a crash?
> 
>> +
>> +       if (mpath_clear_current_path(mpath_device))
>> +               mpath_synchronize(mpath_head);
>> +}
> 

