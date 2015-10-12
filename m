From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH, RFC] blk-mq: use a delayed work item for timeouts
Date: Mon, 12 Oct 2015 14:26:27 -0600
Message-ID: <561C1773.9020309@fb.com>
References: <1444678154-24766-1-git-send-email-hch@lst.de>
 <561C0B3C.70004@fb.com> <561C1324.3030800@fb.com>
 <20151012202217.GA880@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50086 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbbJLU05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 16:26:57 -0400
In-Reply-To: <20151012202217.GA880@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: hare@suse.de, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On 10/12/2015 02:22 PM, Christoph Hellwig wrote:
> On Mon, Oct 12, 2015 at 02:08:04PM -0600, Jens Axboe wrote:
>>> No that's definitely fine with me, imho most error handling callbacks
>>> should be in process context for ease of use in the driver.
>>
>> Took a closer look. The patch looks incomplete. The hot path for blk-mq is
>> blk_add_timer(), looks like you left that one alone in the conversion?
>
> Oh, damn.  I had that part in my initial version that also crudely
> converted the old request code and dropped a bit too much.  That should
> defintively do the queue_deayed_work.

Yep

>> Might be easier to just leave the timer alone, and if it actually fires
>> _and_ we have to do something, punt to a workqueue instead of invoking the
>> timeout handler directly.
>
> queue_delayed_work just assigns two additional fields, then sets
> timer->experies and does an add_timer.  So it's the generic implementation
> of your above scheme.  I'd much rather use the generic version if
> possible instead of trying to recreate it.

I agree, converting to delayed work in general is the cleaner solution. 
The hot path is really NOT doing anything at all, that's the usual path. 
If it isn't, then we've screwed up. And the conversion to 
delayed_work_pending() from timer_pending() looks fine as well, that's 
another important piece.

-- 
Jens Axboe

