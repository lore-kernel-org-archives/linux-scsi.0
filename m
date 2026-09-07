Received: from mta1.migadu.com (out-20.mta1.migadu.com [95.215.58.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B3F5B21A
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782427; cv=none; b=XBKlYurtv6AO0hhzoYcvc9AZyDk1aTw2/P0Gt6jfBSoB0//LoJDu675JNSRRxryVZchaUwm2Svo4coHsQCIlCm47IKqepD85Yo2AT62Pn1hzfW2geG67iXPlckDmFow5QoH4LD/AjdeUD30Mh8vyFnLD28YLLap8zq0wd/kU/0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782427; c=relaxed/simple;
	bh=rTsYp2NGw5bcO20fwMn5il/lu32/vuPJF65Qflx9zbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxP2sTdx4x1DKUJXbrIK3F6DBdtoeJ0/GqU86CJZd9kvtmgrZA5wJXsywkdMXLlhipCI2vZnnpobMgb+Y9L8D6fiQR+0ePqV6fdfpqHRvEOHV5BzEpwhyxpkHSKn3f0TJulZJprQfcxjU3si4v3UrRW55sa3f9yVCrUNcKGv2e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NyLhGZLJ; arc=none smtp.client-ip=95.215.58.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NyLhGZLJ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rTsYp2NGw5bcO20fwMn5il/lu32/vuPJF65Qflx9zbk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788782423; v=1; x=1789387223;
 b=NyLhGZLJb6PElmqv6aGTg/CVlLOCyEZ816N/OZV9E0HrbLX2dkjg0/McSAWaHW9IqKouPgzt
 p4qvSEn/6c7v2mpmBrO5loKf6CWDlxbR2rT5NCOJnmjrpkgisbYIBBLhyQK0QsLkKhKzqx00Nem
 zC7dZAV5Kr4J3OFPy2rG70rI=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 2c071b0a3a216c58;
	Mon, 07 Sep 2026 12:00:18 +0000
X-Mizu-Trace-ID: 2c071b0a3a216c58
X-Migadu-Flow: FLOW_OUT
Message-ID: <a710c011-e85d-40f3-a6c5-d8344d608430@linux.dev>
Date: Mon, 7 Sep 2026 13:00:13 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/27] libmultipath: Add path selection support
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-4-john.g.garry@oracle.com>
 <20260907110926.ED4271F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907110926.ED4271F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 12:09, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> 
> New issues:
> - [High] Infinite loop in `mpath_round_robin_path()` if the current round-robin path is concurrently removed from the device list, causing an SRCU deadlock.
> - [High] `mpath_round_robin_path` fast-path incorrectly returns an unlinked path, breaking failover.
> - [Medium] Calling `list_is_singular()` on an RCU-protected list without holding the update lock causes a data race on `head->prev`.
> - [Medium] Path selection functions bypass the `.is_optimized` callback, violating the API contract and causing inconsistent path evaluation.
> - [Low] Missing bounds check on iopolicy index in `mpath_get_iopolicy`.
> 
> Pre-existing issues:
> - [Medium] `mpath_device_set_live()` silently swallows setup failures, leaving the driver unaware of the aborted initialization.
> --
> 
> commit 59f56cbf3b60a1ec3a1336f453b4cd772a005e7b
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add path selection support
> 
> This commit adds path selection support to libmultipath, providing
> round-robin, NUMA, and queue-depth selection modes similar to NVMe. It also
> abstracts NVMe ANA into enum mpath_access_state to allow SCSI ALUA usage
> and introduces iopolicy management functions.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 574868ce53381..3541357d07f8d 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
>> @@ -7,8 +7,245 @@
> 
> [ ... ]
> 
>> +int mpath_get_iopolicy(char *buf, int iopolicy)
>> +{
>> +	return sprintf(buf, "%s\n", mpath_iopolicy_names[iopolicy]);
>> +}
> 
> [Severity: Low]
> Does this code overflow mpath_iopolicy_names[] if a caller provides an
> uninitialized or out-of-bounds iopolicy value?

The caller should sanitize iopolicy

> 
> [ ... ]
> 
>> +static struct mpath_device *__mpath_find_path(struct mpath_head *mpath_head,
>> +					int node)
>> +{
>> +	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
>> +	struct mpath_device *found = NULL, *fallback = NULL, *mpath_device;
>> +
>> +	list_for_each_entry_srcu(mpath_device, &mpath_head->dev_list, siblings,
>> +		srcu_read_lock_held(&mpath_head->srcu)) {
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
> 
> [ ... ]
> 
>> +		switch(mpath_device->access_state) {
>> +		case MPATH_STATE_OPTIMIZED:
> 
> [Severity: Medium]
> Does this code bypass the driver's dynamic state evaluation by accessing
> access_state directly instead of invoking the provided
> mpath_path_is_optimized() callback wrapper?
> 
> If a driver like SCSI ALUA dynamically changes state, this will read
> stale data.

ALUA support will be added later

> 
>> +		    if (distance < found_distance) {
>> +			    found_distance = distance;
>> +			    found = mpath_device;
>> +		    }
>> +		    break;
> 
> [ ... ]
> 
>> +static struct mpath_device *mpath_round_robin_path(
>> +				struct mpath_head *mpath_head)
>> +{
>> +	struct mpath_device *mpath_device, *found = NULL;
>> +	int node = numa_node_id();
>> +	enum mpath_access_state access_state_old;
>> +	struct mpath_device *old =
>> +			srcu_dereference(mpath_head->current_path[node],
>> +				&mpath_head->srcu);
>> +
>> +	if (unlikely(!old))
>> +		return __mpath_find_path(mpath_head, node);
>> +
>> +	if (list_is_singular(&mpath_head->dev_list)) {
> 
> [Severity: Medium]
> Calling list_is_singular() on an RCU-protected list without holding the
> update lock causes a data race on head->prev. In RCU-protected lists,
> only next pointers are safely updated for lockless readers.

locking will be added later

> 
> [Severity: High]
> Does this fast-path blindly return old without verifying if it is actually
> the element present in the singular list?

as above

> 
> If the previously cached old path was concurrently removed from dev_list
> and exactly one valid path remains, list_is_singular() evaluates to true,
> causing the function to incorrectly return the unlinked path instead of
> the remaining valid path.
> 
>> +		if (mpath_path_is_disabled(mpath_head, old))
>> +			return NULL;
>> +		return old;
>> +	}
>> +
>> +	for (mpath_device = mpath_next_dev(mpath_head, old);
>> +	    mpath_device && mpath_device != old;
>> +	    mpath_device = mpath_next_dev(mpath_head, mpath_device)) {
> 
> [Severity: High]
> Can this loop spin infinitely if old is concurrently removed from the
> RCU-protected list?

as above

> 
> The loop relies on reaching old again to terminate. If a concurrent writer
> unlinks old using list_del_rcu(), it is removed from the circular list but
> its next pointer remains intact. mpath_next_dev() follows old->next into
> the remaining list elements, wrapping around and circling the remaining
> elements indefinitely without ever evaluating mpath_device == old.
> 
> If all remaining paths are non-optimized or disabled, the loop never hits
> the break condition, spinning forever under the SRCU read lock and stalling
> any writer.
> 
>> +
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
>> +		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
> 
> [Severity: Medium]
> Similar to __mpath_find_path(), does this bypass the driver's dynamic state
> evaluation by accessing access_state directly rather than calling the
> mpath_path_is_optimized() callback wrapper?
> 
>> +			found = mpath_device;
>> +			goto out;
>> +		}
>> +		if (mpath_device->access_state == MPATH_STATE_NONOPTIMIZED)
>> +			found = mpath_device;
>> +	}
> 
> [ ... ]
> 
>> @@ -133,6 +371,19 @@ void mpath_device_set_live(struct mpath_device *mpath_device)
>>   		}
>>   		queue_work(mpath_wq, &mpath_head->partition_scan_work);
>>   	}
> 
> [Severity: Medium]
> This is a pre-existing issue, but does mpath_device_set_live() silently
> swallow setup failures earlier in this function?

Yes, this just minics what NVMe does

> 
> If device_add_disk() fails, for example due to memory exhaustion, the
> function clears the MPATH_HEAD_DISK_LIVE flag and returns early, masking
> the failure from the caller and leaving the driver unaware of the aborted
> initialization.
> 
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	if (mpath_path_is_optimized(mpath_head, mpath_device)) {
>> +		int node, srcu_idx;
>> +
>> +		srcu_idx = srcu_read_lock(&mpath_head->srcu);
>> +		for_each_online_node(node)
>> +			__mpath_find_path(mpath_head, node);
>> +		srcu_read_unlock(&mpath_head->srcu, srcu_idx);
>> +	}
>> +	mutex_unlock(&mpath_head->lock);
>> +
>> +	mpath_synchronize(mpath_head);
>>   }
> 

