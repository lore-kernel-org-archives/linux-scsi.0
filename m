From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 6/7 add and use a per-scsi_device queue_lock
Date: 25 Mar 2003 15:20:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048627234.2883.156.camel@mulgrave>
References: <20030324175337.A14957@beaverton.ibm.com>
	<20030324175422.A14996@beaverton.ibm.com>
	<20030324180227.A15047@beaverton.ibm.com>
	<20030324180247.B15047@beaverton.ibm.com>
	<20030324180304.C15047@beaverton.ibm.com>
	<20030324180325.D15047@beaverton.ibm.com>
	<20030324180341.E15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030324180341.E15047@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-03-24 at 20:03, Patrick Mansfield wrote:
> Add and use a per scsi_device queue_lock.

In doing this, you're introducing a locking heirarchy, which would need
to be documented.  If you need both the host and queue locks, which do
you take first?  The code implies that it's queue_lock and then
host_lock, which is a bit counter intuitive and leads to awful problems
for your starved_list: the host_lock is actually protecting the starved
list, so the way you currently have it, you have to drop the host lock
to acquire the queue_lock to run the block queue.  Unfortunately, doing
this could lead to the device being readded when running the queue. 
Thus, the queue_next_request can spin removing and adding the device to
the starved list---probably working from a copy of the starved list will
help with this.

I'd also like to see avoidance of the locking hierarchy where possible. 
i.e. in the scsi_request_fn for instance, can we move the actions that
need the host_lock outside the queue_lock?

James


