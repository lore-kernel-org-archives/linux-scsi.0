Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD033E6DD2
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 08:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788511327; cv=none; b=Ss8Y5a3x3B3eDkML6YQV59RURTrlquBLJjKNLqzhI/8pKNEdQmRTpqOqtKoR9CNXMP9oReSgelZ+kVbRj6nt3Jnggo0CmU2fkUloivc/XKcU7j7b8ULUOcCHquCtT7tqnfA+cF+oJaF/Yvqs4SZc3FXDVcUU5QOtcIobJckJnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788511327; c=relaxed/simple;
	bh=mugTI76R2h9FgVXBE7jpReMLrRbhBJFWg+3YExb1gOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iUZ0MkoYwlireviDUYgBzL4sH7A44EV7kq2YxRbAZkxeDuAtlZB7ceyqF/zHgE2VXWx8JlBNuS7/hpbbEon78naQ4bc8qluVOy9AxKVFhYyTwL4BbznnmVDbW1Bo/u4oMbGll4a4xh8ajKDXMj5Zp1eJ3CeZ7u7QR8RqJMobhs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EFL3x7d6; arc=none smtp.client-ip=91.218.175.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EFL3x7d6"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mugTI76R2h9FgVXBE7jpReMLrRbhBJFWg+3YExb1gOs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788511322; v=1; x=1789116122;
 b=EFL3x7d6kP4vMzEPOsIm31HomUxwV1i98JtD1aaooauPFsvfm6cT9g+oHoxUpt6yHfkbYNpJ
 1nB5IFXxZCjbJpz71cdiWmGJtuerFQ1xUVAn9yW7cDY/tqxwaAyaA4xazmQ2aG0SCGh0iW0AoY3
 isvWoJBVktj8Cfw5bNdPfuG4=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id a8ade380311d3215;
	Fri, 04 Sep 2026 08:41:52 +0000
X-Mizu-Trace-ID: a8ade380311d3215
X-Migadu-Flow: FLOW_OUT
Message-ID: <cc170a4f-e013-4c95-9485-54a277fb7831@linux.dev>
Date: Fri, 4 Sep 2026 09:41:48 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/27] libmultipath: Add path selection support
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-4-john.g.garry@oracle.com>
 <20260901110417.E30DD1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901110417.E30DD1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:04, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Infinite loop in mpath_round_robin_path() due to concurrent path removal and cache overwrite.
> --
> 
> commit 5ea7b90698a3876a3c3c747f99ff79a9d52b1e32
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add path selection support
> 
> This commit abstracts NVMe ANA into enum mpath_access_state to support
> SCSI ALUA. It also adds path selection modes for round-robin, NUMA, and
> queue-depth.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> index 1cf20b0f62d07..26714116023a3 100644
>> --- a/lib/multipath.c
>> +++ b/lib/multipath.c
> 
> [ ... ]
> 
>> @@ -109,6 +231,146 @@ static struct mpath_device *mpath_next_dev(struct mpath_head *mpath_head,
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
> Could this loop run infinitely if `old` is unlinked from the list concurrently?
> 

locking is added later


> If Thread 1 enters mpath_round_robin_path(), loads `old = D` from
> `current_path[node]`, and is preempted, another thread could enter, find a
> fallback path Y, and overwrite `current_path[node] = Y`.

as above

> 
> When a removal thread subsequently calls mpath_clear_current_path(D), it would
> return false because the cached path is now Y. If this causes the removal
> thread to skip mpath_synchronize() and directly unlink D via
> mpath_delete_device(D), the path is removed from the list while Thread 1 still
> holds a reference to it.
> 
> When Thread 1 resumes, `old` is no longer linked. If there are no
> MPATH_STATE_OPTIMIZED paths to trigger an early break, mpath_next_dev() would
> cycle infinitely between the remaining active paths, because
> `mpath_device != old` would never evaluate to false.
> 
> Is there a way to ensure the loop termination condition remains valid even if
> `old` is concurrently replaced and removed?

as above

> 
>> +
>> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
>> +			continue;
>> +		if (mpath_device->access_state == MPATH_STATE_OPTIMIZED) {
>> +			found = mpath_device;
>> +			goto out;
>> +		}
> 

