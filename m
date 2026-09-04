Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD36C44BC87
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 10:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518567; cv=none; b=AxgHAtO3BMqgDhzpaLNoefWlTpghb7crQ5I253DgWilLAb8iUZ+Tw8lX0IdNOWntlhPR79ni5fSDznaNYhUPr5BRNcbh6jspIcX96JEEx0Cb5d3sNSGkxl3FPgWx1yzCEfzFIv6auwPg3j9gHqWi1yDGpO3e+mPX+7CLKxfB+lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518567; c=relaxed/simple;
	bh=3eGbGpaiJkSJDxpx9xc+XjxObIRpjfGF5zwgJme+sxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uds2acIrLzlJmef7ov8rEyPGOyvGfP+OMpynYUvxPKrDf1N6PWxPXGwS/4SCTQ/vKE0mtKyiwigjIqd2aPdSrziOO3d94oXt4pyKAxplaOHjOHMTRd7nG96w4SfcSEpcojiViU9HOqMoTXZE2gMUxFTFpDCYaZf+k40bTKmQuyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lVotfOSu; arc=none smtp.client-ip=95.215.58.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lVotfOSu"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3eGbGpaiJkSJDxpx9xc+XjxObIRpjfGF5zwgJme+sxU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788518561; v=1; x=1789123361;
 b=lVotfOSuPAAQ5r4FctJWCZc7+NFrxpHzZFXaK8fTwz/7XHM2+e5zE7AS/bjDnWKG2q1juFX0
 /zJCqHPjvCmYTyPSFDcDpMtvmgNHIDeKW3AtQ4L3hhOatR6/AE54PepWJ5jh5E699u9gvIM2tYg
 4RQ8ImiuE7vlLW9NpwYzE7qc=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id d9c98f6a4a4bc61c;
	Fri, 04 Sep 2026 10:42:41 +0000
X-Mizu-Trace-ID: d9c98f6a4a4bc61c
X-Migadu-Flow: FLOW_OUT
Message-ID: <f46c8465-e61e-4e79-adad-d7578b4f358b@linux.dev>
Date: Fri, 4 Sep 2026 11:42:40 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 18/27] scsi-multipath: failover handling
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-19-john.g.garry@oracle.com>
 <20260901110950.8159E1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901110950.8159E1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:09, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Path failover is prematurely aborted if the underlying path device is removed, and dropping its reference causes a sleep-in-atomic bug.
> --
> 
> commit 657b83f2533d51dce7950c14bb5248625186e04d
> Author: John Garry <john.garry@linux.dev>
> Subject: scsi-multipath: failover handling
> 
> This commit implements failover handling for scsi_cmnd by requeuing the
> master bio of each bio attached to a failed request. Failover is detected
> in scsi_mpath_clone_end_io() when blk_path_error() occurs.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
> 
> [ ... ]
> 
>>   static void scsi_mpath_clone_end_io(struct bio *clone)
>>   {
>>   	struct bio *master_bio = clone->bi_private;
>>   
>> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
>> +		struct block_device *bi_bdev = clone->bi_bdev;
>> +		struct request_queue *q = bi_bdev->bd_queue;
>> +		struct scsi_device *sdev = scsi_device_from_queue(q);
>> +		struct scsi_mpath_device *scsi_mpath_dev;
>> +		struct mpath_device *mpath_device;
>> +		struct mpath_head *mpath_head;
>> +		unsigned long flags;
>> +
>> +		if (!sdev)
>> +			goto end_bio;
> 
> [Severity: High]
> If the underlying device is being removed and scsi_device_from_queue()
> returns NULL, does this prematurely abort the failover?
> 
> Bailing out here directly propagates the path error to the master bio,
> which seems to break the multipath failover guarantee.
We need the sdev to lookup the mpath_head. However I can also get the 
mpath_head from master_bio->bi_bdev->bd_disk->private_data, so I can do 
away with any sdev usage altogether.

> 
>> +
>> +		scsi_mpath_dev = sdev->scsi_mpath_dev;
>> +		mpath_device = &scsi_mpath_dev->mpath_device;
>> +		mpath_head = mpath_device->mpath_head;
>> +
>> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
>> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
>> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
>> +
>> +		mpath_schedule_requeue_work(mpath_head);
>> +		put_device(&sdev->sdev_gendev);
> 
> [Severity: High]
> Can this put_device() call trigger a sleep-in-atomic panic?

See above

> 
> Since scsi_mpath_clone_end_io() executes in the softirq context of a bio
> end_io handler, dropping the last reference here can call
> scsi_device_dev_release(), which explicitly enforces might_sleep().
> 
> Could mpath_head be safely derived directly from
> master_bio->bi_bdev->bd_disk->private_data instead of indirectly through
> the underlying path device?
> 
>> +		return;
>> +	}
>> +
>> +end_bio:
>>   	master_bio->bi_status = clone->bi_status;
>>   	bio_put(clone);
>>   	bio_endio(master_bio);
> 

