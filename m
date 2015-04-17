From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH, RFC] scsi: use host wide tags by default
Date: Fri, 17 Apr 2015 15:44:14 -0600
Message-ID: <55317EAE.10201@kernel.dk>
References: <1429301471-5666-1-git-send-email-hch@lst.de> <1429306960.1079.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33414 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbbDQVoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2015 17:44:18 -0400
Received: by paboj16 with SMTP id oj16so137856862pab.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2015 14:44:17 -0700 (PDT)
In-Reply-To: <1429306960.1079.25.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On 04/17/2015 03:42 PM, James Bottomley wrote:
>> @@ -662,32 +662,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>>    */
>>   int scsi_change_queue_depth(struct scsi_device *sdev, int depth)
>>   {
>> -	unsigned long flags;
>> -
>> -	if (depth <= 0)
>> -		goto out;
>> -
>> -	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>> +	if (depth > 0) {
>> +		unsigned long flags;
>>
>> -	/*
>> -	 * Check to see if the queue is managed by the block layer.
>> -	 * If it is, and we fail to adjust the depth, exit.
>> -	 *
>> -	 * Do not resize the tag map if it is a host wide share bqt,
>> -	 * because the size should be the hosts's can_queue. If there
>> -	 * is more IO than the LLD's can_queue (so there are not enuogh
>> -	 * tags) request_fn's host queue ready check will handle it.
>> -	 */
>> -	if (!shost_use_blk_mq(sdev->host) && !sdev->host->bqt) {
>> -		if (blk_queue_tagged(sdev->request_queue) &&
>> -		    blk_queue_resize_tags(sdev->request_queue, depth) != 0)
>> -			goto out_unlock;
>> +		spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>> +		sdev->queue_depth = depth;
>> +		spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>
> This lock/unlock is a nasty global sync point which can be eliminated:
> we can rely on the architectural atomicity of 32 bit writes (might need
> to make sdev->queue_depth a u32 because I seem to remember 16 bit writes
> had to be done as two byte stores on some architectures).

It's not in a hot path (by any stretch), so doesn't really matter...

-- 
Jens Axboe

