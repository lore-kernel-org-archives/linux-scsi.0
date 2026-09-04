Received: from mta0.migadu.com (out-230.mta0.migadu.com [91.218.175.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D003ABD9F
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 10:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517070; cv=none; b=goh3p/TZOSD8eKZuuQgZRR+2e5MoMlu/ztzrO2DRLndvrwvuq4BX0rhqqQ/BEDRw7F+pLTenUV4uY4ZfXD9r4timI6n0RlOy9qewWrgIRkO5H4EORJcscicLuEO8ROdU9mElU7lmnw8GAGP7cmb/Q+CRTYKpdnP8cXIK/uIsRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517070; c=relaxed/simple;
	bh=n5DBSvuizZADcWbCkQAI8CIqyuP/kuqCWJM28ekY+uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THAyq5S3e28P2yfqNJNDw/yHq7Dnriyn0ERbjg3imvCHXWiAQLO3HKCo/BSTNS70TxKA0kFghH3D8qSWIQ0ggJetfe3s/IHEyVXMeBsb6AG3zVePBLZ7hcI8cxG0Cmauq/mvNvNuw7LBg+LFv5pr9HCrs23hQqgM/BMdM0xCXFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OwqtKpMI; arc=none smtp.client-ip=91.218.175.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OwqtKpMI"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=n5DBSvuizZADcWbCkQAI8CIqyuP/kuqCWJM28ekY+uc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788517066; v=1; x=1789121866;
 b=OwqtKpMImPj1+RA3GjrsBmff5ffLlFf7f7wpWn01j0nP+5i5W+0CMJ+dylXtRl9VEbGbv+en
 D6E3APjc441T7JARTsAyxN8qDz80YtVF7PgYICX+FdGa8gke7ae4gJCt5ZHUisK2hmb2u90WC8j
 tyyDgYJlbG+l4J+BXCM0MsVc=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 760ee5f4c6136a2f;
	Fri, 04 Sep 2026 10:17:45 +0000
X-Mizu-Trace-ID: 760ee5f4c6136a2f
X-Migadu-Flow: FLOW_OUT
Message-ID: <d4876ad9-ef80-4a4d-89a3-025bcdaa747e@linux.dev>
Date: Fri, 4 Sep 2026 11:17:41 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 14/27] scsi-multipath: support iopolicy
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-15-john.g.garry@oracle.com>
 <20260901111121.5C7DE1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901111121.5C7DE1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:11, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] A TOCTOU race between updating the I/O policy and lockless path resolution can cause a path evaluated under the old policy to be permanently cached.
> --
> 
> commit 23d70dc129a3932ccedd2e25833214d5d4fedd20
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: support iopolicy
> 
> Add support to set the multipath iopolicy. The default policy can be set via
> a module parameter, and it can be dynamically updated via a sysfs attribute.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 1c04947d906ea..7164bc61e65e1 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> @@ -99,8 +116,41 @@ static ssize_t scsi_mpath_device_vpd_id_show(struct device *dev,
>>   }
>>   static DEVICE_ATTR(vpd_id, S_IRUGO, scsi_mpath_device_vpd_id_show, NULL);
>>   
>> +static ssize_t scsi_mpath_device_iopolicy_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct scsi_mpath_head *scsi_mpath_head =
>> +		container_of(dev, struct scsi_mpath_head, dev);
>> +	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
>> +
>> +	if (!mpath_iopolicy_store(&scsi_mpath_head->iopolicy, buf))
>> +		return -EINVAL;
>> +
>> +	mpath_clear_paths(mpath_head);
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [Severity: Medium]
> Is there a race condition here between updating the I/O policy and lockless
> path resolution?
> 
> If an administrator writes to the iopolicy sysfs attribute while an I/O
> request is concurrently finding a path, this sequence appears possible:
> 
> Thread 1 (I/O) evaluates the path under the current policy (e.g.,
> round-robin) and selects a path.
> 
> Thread 2 (sysfs) updates the policy to NUMA here in
> scsi_mpath_device_iopolicy_store(), and calls mpath_clear_paths(), setting
> current_path[node] = NULL.
> 
> Thread 1 finishes path selection and executes this in __mpath_find_path()
> located in lib/multipath.c:
> 
> 	if (found)
> 		rcu_assign_pointer(mpath_head->current_path[node], found);
> 
> This would overwrite the NULL with the path chosen under the old policy.
> Subsequent I/Os calling mpath_numa_path() would see a non-NULL
> current_path[node] and use it directly, permanently caching a stale path
> under the new policy.
> 
> Does mpath_clear_paths() need synchronization against concurrent path
> resolutions to prevent caching paths evaluated under the old policy?

Yeah, maybe an srcu sync is required

> 
>> +	mpath_schedule_requeue_work(mpath_head);
>> +	/*
>> +	 * Ensure requeue work completes, as this work could run later when
>> +	 * the mpath_head is gone.
>> +	 */
>> +	flush_work(&mpath_head->requeue_work);
>> +	return count;
>> +}
> 

