From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] hpsa: scsi-mq support
Date: Sun, 13 Nov 2016 10:44:47 +0100
Message-ID: <cba051f8-3055-53c4-2860-ee4c51a7043d@suse.com>
References: <1478879194-32529-1-git-send-email-hare@suse.de>
 <20161111163532.GA14922@infradead.org>
 <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com>
 <20161112173223.GA22158@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:60490 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbcKMJpD (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Sun, 13 Nov 2016 04:45:03 -0500
In-Reply-To: <20161112173223.GA22158@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On 11/12/2016 06:32 PM, Christoph Hellwig wrote:
> On Fri, Nov 11, 2016 at 07:22:05PM +0100, Hannes Reinecke wrote:
>> Well, it's the same as with megasas and mpt3sas. Each of those have
>> a single MMIO register where the driver writes the address of the
>> command into. What exactly the hardware does in the back doesn't
>> really matter here; the command is in memory and the hardware can
>> access it as it sees fit. So from that point of view we can assume
>> having a submission queue to match the completion queue;
>> With that setup we do have a contention point on the single command
>> register, but that's about it.
>> We still should benefit from scsi-mq, though.
>
> How do we benefit from scsi-mq in this case?  We still hit global
> cachelines like commands_outstanding in the driver, and we lost the
> batching done by the ctx -> hw_ctx layering for the single queue
> blk-mq case.  We also get much less efficient merging and will not
> have the chance of having and I/O schedule in the near future.
>
One day to mark with bright red in the calendar.

Christoph Hellwig is telling me _NOT_ to use scsi-mq.

 > But back to my question from the last mail:  What workload is improved
 > by using this patch?
 >
This patch was done so see what would needed to be done to convert a 
legacy driver.
As I was under the impression that scsi-mq is the way forward, seeing 
that it should be enabled per default.
But I must have been mistaken. Apparently.

Slightly confused,

Hannes
