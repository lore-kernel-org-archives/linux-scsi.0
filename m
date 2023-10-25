Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03854C25B6B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 07:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjJYHZy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbjJYHZs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 03:25:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BCDBB;
        Wed, 25 Oct 2023 00:25:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA241C433C8;
        Wed, 25 Oct 2023 07:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698218746;
        bh=wVFafQGdH2BNwadQ8bZzTTUNNCrXbqihXvzUauz/N/8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=p5zgIZKSX+uXfDbBrPs6W1vReRZ5wAsgs0253lkIUtuoH79UlyIcNdeJlQNQpbegi
         nF3vf02/v777fuunJK+6ceKGAx90mawA0GX+gYmpULNqQBndyLwMrldisNRnqnj7Pa
         BNkfVi3TKGA9565pTv7Ggu8V7RCH+TRwDKeXvpEw2/yCN/BpHrpFsPEKE26C1uvsSm
         0iZJhAIK+kLEdvRJxkYwpwtocPPMjj/en2VqKBYYacu/dslMWvqUAtureq25kAjf/C
         bGnDvolrWlN3v9n7X3i9xKbQzPIYso3wH7B5eT2XqDY1bBL3U386kFG0E0GjKhpql0
         NPz+1jhcccUoA==
Message-ID: <e3e92b62-ebeb-42d1-8857-c66721c0325e@kernel.org>
Date:   Wed, 25 Oct 2023 16:25:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 10/19] scsi: core: Retry unaligned zoned writes
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-11-bvanassche@acm.org>
 <249db38e-43c0-46d7-9e61-7788ee710f42@kernel.org>
 <7027b9b9-80cb-418a-8510-b4104a8cdadf@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <7027b9b9-80cb-418a-8510-b4104a8cdadf@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/23 02:22, Bart Van Assche wrote:
> On 10/23/23 17:13, Damien Le Moal wrote:
>> On 10/24/23 06:54, Bart Van Assche wrote:
>>>   	case ILLEGAL_REQUEST:
>>> +		/*
>>> +		 * Unaligned write command. This may indicate that zoned writes
>>> +		 * have been received by the device in the wrong order. If zone
>>> +		 * write locking is disabled, retry after all pending commands
>>> +		 * have completed.
>>> +		 */
>>> +		if (sshdr.asc == 0x21 && sshdr.ascq == 0x04 &&
>>> +		    !req->q->limits.use_zone_write_lock &&
>>> +		    blk_rq_is_seq_zoned_write(req) &&
>>> +		    scmd->retries <= scmd->allowed) {
>>> +			sdev_printk(KERN_INFO, scmd->device,
>>> +				    "Retrying unaligned write at LBA %#llx.\n",
>>> +				    scsi_get_lba(scmd));
>>
>> KERN_INFO ? Did you perhaps mean KERN_DEBUG ? An info message for this will be
>> way too noisy.
> 
> Hi Damien,
> 
> Are you sure that KERN_INFO will be too noisy? On our test setups we see
> this message less than once a day. Anyway, I will change the severity level.

I am not sure. But better safe than sorry :)

So given that we should not scare the user with errors that are not errors (as
the next tries will succeed), we should be silent and log a message only if the
retry count is exhausted and we still see a failure.

> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

