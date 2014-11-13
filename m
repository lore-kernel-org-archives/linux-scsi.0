From: Christoph Hellwig <hch@infradead.org>
Subject: Re: making the queue_type attribute read only, was: Re: tag handling
 refactor V2
Date: Thu, 13 Nov 2014 03:28:30 -0800
Message-ID: <20141113112830.GB16818@infradead.org>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
 <20141112174142.GA14359@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B4029593A10D8@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbaKML2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Nov 2014 06:28:31 -0500
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593A10D8@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>

On Thu, Nov 13, 2014 at 12:33:41AM +0000, Elliott, Robert (Server Storage) wrote:
> A queue_type of "none" disables the SCSI midlayer automatic queue depth
> adjustments based on TASK SET FULL vs. other status values, while
> "simple" enables them.  That's the feature where TASK SET FULL reception
> causes the queue depth to be lowered, while several GOOD status values
> in a row causes it to be increased.

That's not what it's supposed to do, and I faily to see how it would do
that.  Pick a random change_queue_type implementation before my patch:

static int
lpfc_change_queue_type(struct scsi_device *sdev, int tag_type)
{
	if (sdev->tagged_supported) {
		scsi_set_tag_type(sdev, tag_type);
		if (tag_type)
			scsi_activate_tcq(sdev, sdev->queue_depth);
		else
			scsi_deactivate_tcq(sdev, sdev->queue_depth);
	} else
		tag_type = 0;

	return tag_type;
}

So if sdev->tagged_supported is not set it's literally a no-op.
Else if we want to move to none we first do the scsi_set_tag_type call
which ends up setting sdev->ordered_tags and sdev->simple_tags to 0.
Then we call scsi_deactivate_tcq which for a non-mq devices calls
calls blk_queue_free_tags which just clears the QUEUE_FLAG_QUEUED
flag, which causes the block layer to not generated tags anymore, and
causes blk_rq_tagged to be false for every request submitted after
this point. I then also calls scsi_adjust_queue_depth which clears
sdev->ordered_tags and sdev->simple_tags a second time, but otherwise is
a no-op as we pass in the current depth.

Can you explain in what exact scenario you used the attribute to disable
the queue full tracking? 


> That logic doesn't work very well right now, so that sysfs file
> might be the best way to keep controlling the automatic adjustment
> feature even if it no longer controls whether tags exist.

I'd rather introduce a sysfs attribute to control that specific behavior
instead of reling on weird accidental side effects.

> One problem is it adjusts the queue depths for all devices sharing
> the same target number; we talked about letting the host choose
> the policy (http://marc.info/?l=linux-scsi&m=140440001619574&w=2).

I've got some patches for queue full tracking pending, but tackling the
scope qualifier is still on the todo list.  I really need someone to
sign up helping to test it, writing the code is fairly easy
.
> Even if that is corrected, the ramp-up/ramp-down algorithms
> and controls are not quite right for the full range of device 
> types (SSDs to HDDs).  With SSDs, I saw the queue_depth:
> * ramp down by about 10 every 2 seconds
> * with the default queue_ramp_up_period of 120000: never ramp up
> * with a queue_ramp_up_period of 120: ramp up by 16 ever 2 seconds
> 
> At 1M IOPS, 2 seconds is far too long to decide anything; some
> algorithm changes are needed.

Agreed, the static timing seems wrong.  A count of successfull
completions might be a better idea.
