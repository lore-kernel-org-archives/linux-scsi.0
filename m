From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue
	reached
Date: 05 Mar 2003 04:02:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1046833360.2757.43.camel@mulgrave>
References: <20030228111924.A32018@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id UAA09114
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2003 20:02:41 -0800
In-Reply-To: <20030228111924.A32018@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-02-28 at 20:19, Patrick Mansfield wrote:
> Hi -
> 
> Any comments or suggestions on the following patch?

Sorry for getting to this late, just returned from a nice long weekend
holiday.

> Patch is against scsi-misc-2.5.
> 
> I'm trying to break split queue_lock into a per scsi_device lock, and the
> starved code is in the way, plus it is not fair and looks like it has a
> couple of bugs. I started by trying to add a queue of request queues plus
> throttling to the current "starved" algorithm, but it was not too clean,
> so instead implemented this software enqueueing when the host can_queue
> limit is reached.

Could you elaborate on why a pending_queue (which duplicates some of the
block layer queueing functionality that we use) is a good idea.

Under the current scheme, we prep one command beyond the can_queue limit
and leave it in the block queue, so the returning commands can restart
with a fully prepped command but we still leave all the others in the
block queue for potential elevator merging. 

> This can use more resources (scsi_cmnd's) if the sum of queue_depths on a
> host is greater than can_queue, but it is fairer (when not all devices are
> hitting queue_depth limits, or if we had throttling with a throttling
> limit of 1) and simpler compared to using a queue of queues (or code
> similiar to the current starvation code).

It would certainly need some kind of throttling.  In the current code,
not taking a command off the block queue when we can't accept it gives
the elevator longer to work on merging; taking too many commands off
when we can't actually send them on might lead to the average command
size dropping.

James


