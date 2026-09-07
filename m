Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867B4446073
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788783241; cv=none; b=M9Td+CguCNWHBOXW421/AvY7w5q9GDjbaO4kZk+djFBUQGlTKVAon75GtA/9G6io9zFjnV3PaB83pqES6MFpY3aPn3YwPks0jqRCoDUDWLIK9WjozjBIUHnkTOTSOccbFn3s4flz+bD6uMaKnaXc4lOaPCLb3UlHsrYxlP0yuEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788783241; c=relaxed/simple;
	bh=wC4DD3vYWT6BUWrF2nLEmOn200aeVmJ0cr7K8E6rmJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dzHYxh+HUdgGekfiwcM4NxHDrCheptUhNOcivvcQkTCgJ01DkKG3SnhHg3tSFLCWK5yyZQKnThXK/fvK+2VQuUl8Y7j8EJyCe53EEyaTPbZ76VJ8E/tiKNabr3U54mG2RVzG+KcoL6wz1sC4aPX0TWnnjrD6/3C9E+re8DQLrEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w54zA7ra; arc=none smtp.client-ip=91.218.175.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w54zA7ra"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=wC4DD3vYWT6BUWrF2nLEmOn200aeVmJ0cr7K8E6rmJc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788783237; v=1; x=1789388037;
 b=w54zA7ra17O2iYMUNJfc8IIFPf4My+FPmwsqwzM3tt4jEfwQeFljc3jtYHXMUA/YBRXgEgxj
 T0a+UoDmxbqhcy7neuRBXx7eCEww1AKF9hgQOtpbck20G/SLM5A/lCt3bKcVqmGJMGUflachq5q
 gnwLQ9CSbTcgre+//v/27qaE=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 3ceba2e31de0f972;
	Mon, 07 Sep 2026 12:13:57 +0000
X-Mizu-Trace-ID: 3ceba2e31de0f972
X-Migadu-Flow: FLOW_OUT
Message-ID: <6cdf70ce-aba6-4377-bdaf-2efddae55fd1@linux.dev>
Date: Mon, 7 Sep 2026 13:13:56 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 18/27] scsi-multipath: failover handling
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-19-john.g.garry@oracle.com>
 <20260907120233.8A50C1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907120233.8A50C1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 13:02, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Missing cancellation of `requeue_work` during `scsi_mpath_head` destruction leads to Use-After-Free.
> - [Low] The custom `bio_list_add_master()` function is an unnecessary and unsafe reinvention of `bio_list_add()`.
> --
> 
> commit 9189539f81df33ce64a7c19420baf37ebf587b37
> Author: John Garry <john.garry@linux.dev>
> 
> scsi-multipath: failover handling
> 
> This patch implements failover handling for SCSI commands when the target
> device's transport is down. It requeues the master bio of each attached
> bio when a failover occurs, using scsi_mpath_clone_end_io() to handle
> the failover process.
> 
>> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
>> index 456351fee4b98..12200664ed676 100644
>> --- a/drivers/scsi/scsi_multipath.c
>> +++ b/drivers/scsi/scsi_multipath.c
>> @@ -256,10 +256,34 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev)
>>                  mpath_synchronize(mpath_head);
>>   }
>>   
>> +static inline void bio_list_add_master(struct bio_list *bl,
>> +				struct bio *master_bio)
>> +{
>> +	if (bl->tail)
>> +		bl->tail->bi_next = master_bio;
>> +	else
>> +		bl->head = master_bio;
>> +	bl->tail = master_bio;
>> +}
> 
> [Severity: Low]
> Is it necessary to use this custom list insertion function instead of the
> standard bio_list_add()?
 > > This custom bio_list_add_master() function mimics bio_list_add() 
but omits
> the master_bio->bi_next = NULL assignment. While master_bio->bi_next is
> structurally guaranteed to be NULL in the block layer at this point,
> reinventing bio_list_add() without its safety guarantees seems to add
> unnecessary complexity and a theoretical risk of singly-linked list
> corruption.

As mentioned, The NULLify of master_bio->bi_next is unneeded. But I 
suppose we can use bio_list_add() - I can do it later

> 
>> +
>>   static void scsi_mpath_clone_end_io(struct bio *clone)
>>   {
>>   	struct bio *master_bio = clone->bi_private;
>>   
>> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
>> +		struct mpath_head *mpath_head =
>> +				master_bio->bi_bdev->bd_disk->private_data;
>> +		unsigned long flags;
>> +
>> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
>> +		bio_list_add_master(&mpath_head->requeue_list, master_bio);
>> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
>> +		bio_put(clone);
>> +
>> +		mpath_schedule_requeue_work(mpath_head);
> 
> [Severity: High]
> Can scheduling this requeue work lead to a use-after-free during device
> destruction?
> 
> While the I/O failover path here is protected for disk devices because
> del_gendisk() blocks until the bio completes, non-disk SCSI devices
> (like tape drives) do not create an mpath disk. 

We don't support them.

> If an ALUA state change
> event triggers scsi_mpath_revalidate_paths(), requeue_work can be scheduled.
> 
> If the device is hot-removed, scsi_mpath_head_release() frees the
> scsi_mpath_head structure without calling
> cancel_work_sync(&mpath_head->requeue_work):
> 
> drivers/scsi/scsi_multipath.c:scsi_mpath_head_release() {
>      ...
>      mpath_head_uninit(mpath_head);
>      kfree(scsi_mpath_head);
> }
> 
> If asynchronous mpath_requeue_work() executes after the structure is freed,
> it could access the freed mpath_head structure and cause a kernel panic.
> 
>> +		return;
>> +	}
>> +
>>   	master_bio->bi_status = clone->bi_status;
>>   	bio_put(clone);
>>   	bio_endio(master_bio);
>>
> 

