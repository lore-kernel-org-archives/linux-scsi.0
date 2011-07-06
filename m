From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 06 Jul 2011 09:24:09 -0500
Message-ID: <1309962249.3282.1.camel@mulgrave>
References: <Pine.LNX.4.44L0.1107061013440.1995-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40099 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989Ab1GFOYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 10:24:12 -0400
In-Reply-To: <Pine.LNX.4.44L0.1107061013440.1995-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roland Dreier <roland@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>

On Wed, 2011-07-06 at 10:20 -0400, Alan Stern wrote:
> On Wed, 6 Jul 2011, Roland Dreier wrote:
> 
> > Alan Stern's patch looks a bit fishy -- the scsi_free_queue() is moved
> > earlier than the
> > 
> > 	/* cause the request function to reject all I/O requests */
> > 	sdev->request_queue->queuedata = NULL;
> > 
> > which seems to leave a small window where the use-after-free can
> > happen, and it's not clear to me why the scsi_free_queue() has to move
> > at all.
> 
> Looks can be deceiving.  Although the scsi_free_queue() is higher up in
> the source file, it actually runs later than this code.  That's because
> __scsi_remove_device() -- this code -- gets called when the device is
> unregistered from the driver core, whereas
> scsi_device_dev_release_usercontext() -- where the scsi_free_queue() is
> moved to -- gets called when the last reference to the device is
> dropped.
> 
> Now, one of the things I'm not sure about (it would nice if James would
> pick up this thread again and comment) is whether queuedata should be
> set to NULL at unregistration time or later on, when the device and the
> queue are about to be freed.

Sorry, higher priority problems at the moment.  Sorry about the
->queuedata cockup, was thinking of sdev->request_queue. Moving the
queue free is wrong ... it recently moved to fix another oops.  Problem
most likely missing block guards on blk_execute_req() ... no check for
QUEUE_DEAD.

Will be back on Thursday.

James


