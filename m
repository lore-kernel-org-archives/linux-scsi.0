Received: from mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662D846D09B
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 10:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518647; cv=none; b=U72kIJHYtMkNkO87y3O6Pf1nhaOV86kMtZWz50T/GyL9dFl/NFwtrK9rJZOWriQC0wAqoimTdVcZqOelogMUZLHWlh3YXZMYjw+UQ5rEpFg9kOuiSAC+ky4cgVvc09M4g6awUz8I9nbRzsryHGDmobcIclrXH3qlrReXu1Vhcsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518647; c=relaxed/simple;
	bh=LVeKNzzQZL0Ms6VZ+kHVgk+lZQq6D4t0ss/lQdmvwk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EWw2x7tKysYoGqcg5PjyYNlfpmlSC2W0xDHuB9ddVrYzjdsaf2URmQlyhJZpsq3UsVsQ6AnV6ZTOJNvtnrNgEqnrfP0wW2c5mLq648mCF1Tu45YZkxJrM4DjgbSBap3pK+g7U/udSl8fdDakVXZ+B5nY3toRLGEQcrRcaJsvSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HjY6Jghd; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HjY6Jghd"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LVeKNzzQZL0Ms6VZ+kHVgk+lZQq6D4t0ss/lQdmvwk4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788518643; v=1; x=1789123443;
 b=HjY6Jghd6aPeyhckwklr6D4omlvRaCMWypmssFriLAzMjBb9kGQa4Gp3G7tZlZ5fEgfBjUHO
 3hATysMEwYROPtVr7CSH+1ajmR0nHx7nVJCuH0UuJ3DgeGk/fxlITrcnRZC7F2BkdPJL3DbAniH
 3kApILfHPqUH3BkRsukElwII=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 314c50796aad1537;
	Fri, 04 Sep 2026 10:44:03 +0000
X-Mizu-Trace-ID: 314c50796aad1537
X-Migadu-Flow: FLOW_OUT
Message-ID: <999e39af-94e3-4d52-a36f-26b423556bbb@linux.dev>
Date: Fri, 4 Sep 2026 11:44:02 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/27] scsi-multipath: provide callbacks for path state
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-20-john.g.garry@oracle.com>
 <20260901111359.0FBA31F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901111359.0FBA31F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:13, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Path routing algorithms completely ignore ALUA path priorities due to reliance on a static state field.
> - [High] I/Os stranded in the requeue list during path unavailability will hang indefinitely because ALUA state recovery does not trigger a requeue list flush.
> --
> 
> commit 8deb21c730fe5e2ebafeae61cfbcd392c6ab5948
> Author: John Garry <linux.dev>
> 
> scsi-multipath: provide callbacks for path state
> 
> This commit provides callbacks for is_disabled, is_optimized, and
> available_path for SCSI multipath devices. The callbacks rely on the
> device's ALUA state and running state to dynamically determine path
> availability and routing priorities.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index fd28667792472..b9f6b1eb3c883 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>> +static bool scsi_mpath_is_disabled(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	unsigned char access_state = READ_ONCE(sdev->access_state) &
>> +					SCSI_ACCESS_STATE_MASK;
>> +
>> +	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
>> +		return true;
>> +
>> +	if (access_state == SCSI_ACCESS_STATE_OPTIMAL ||
>> +	    access_state == SCSI_ACCESS_STATE_ACTIVE)
>> +		return false;
>> +
>> +	return true;
>> +}
> 
> [Severity: High]
> When this function correctly returns true (for example, when an ALUA-managed
> storage path transitions to STANDBY), incoming I/Os are deferred to the
> multipath head's requeue list.
> 
> However, when the target recovers and the ALUA state changes back, is there a
> mechanism to wake up and flush these stranded I/Os?
> 
> The ALUA device handlers update sdev->access_state upon receiving an RTPG,
> but they do not appear to notify the core multipath layer to flush the requeue
> list. In NVMe, this is handled by kblockd_schedule_work(&head->requeue_work)
> when ANA state changes. Because sdev_state remains SDEV_RUNNING, unblock
> handlers are not triggered either. Will this lead to I/Os hanging
> indefinitely in the requeue list without a corresponding wake-up trigger?

All this will be improved with proper scsi-multipath ALUA support.

> 
>> +
>> +static bool scsi_mpath_is_optimized(struct mpath_device *mpath_device)
>> +{
>> +	struct scsi_mpath_device *scsi_mpath_dev =
>> +				to_scsi_mpath_device(mpath_device);
>> +	struct scsi_device *sdev = scsi_mpath_dev->sdev;
>> +	unsigned char access_state = READ_ONCE(sdev->access_state) &
>> +					SCSI_ACCESS_STATE_MASK;
>> +
>> +	if (READ_ONCE(sdev->sdev_state) != SDEV_RUNNING)
>> +		return false;
>> +
>> +	return access_state == SCSI_ACCESS_STATE_OPTIMAL;
>> +}
> 
> [Severity: High]
> Does the multipath core actually use this callback for path selection routing?
> 
> Looking at the core path routing algorithms in lib/multipath.c, such as
> __mpath_find_path, mpath_round_robin_path, or mpath_queue_depth_path, they
> appear to check the static struct field instead of invoking the callback:
> 
> lib/multipath.c:__mpath_find_path() {
>      ...
>      switch(mpath_device->access_state) {
>      ...
> }
> 
> Because mpath_device->access_state is hardcoded to MPATH_STATE_OPTIMIZED
> during device allocation in scsi_multipath_sdev_init() and is not dynamically
> synced with the ALUA state, won't the routing algorithms blindly place
> non-optimized active paths in the same preference bucket as optimized paths?
> This seems to bypass the newly introduced ALUA callbacks entirely for
> queue-depth or round-robin policies.

As above

> 
> [ ... ]
> 

