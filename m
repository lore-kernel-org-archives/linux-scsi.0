From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: 04 Feb 2003 12:33:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044383605.2014.23.camel@mulgrave>
References: <20030204162326.A30755@lst.de>
	<20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de>
	<20030204091955.A24785@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA19660
	for <linux-scsi@vger.kernel.org>; Tue, 4 Feb 2003 10:33:30 -0800
In-Reply-To: <20030204091955.A24785@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-02-04 at 11:19, Patrick Mansfield wrote:
> We really need to limit to what the scsi_device (thinks it) can handle
> (currently new_queue_depth). Otherwise we could have QUEUE_FULL storms,
> plus we really don't want that many scsi_cmnd's outstanding (i.e. limited
> by the amount of memory we can allocate) when we have many scsi_devices on
> the system. If we lowered the request queue limit that would hurt
> scsi_devices (and maybe adapters) with a low queue limits.

I agree with this.  It is a guarantee the mid-layer makes to the LLD
(and there are some LLDs with static issue queues for which this is a
hard requirement).  I think (once the dust has settled and we've agreed
which field holds the current queue depth) what's needed is a check in
the scsi_request_fn() to see if we're over the LLD's current depth for
the device and plug the queue and exit if we are.  The next returning
command will unplug and send.

This way of doing things means that we're free to prep as many commands
as we can, but we guarantee only to have the correct number outstanding
to the LLD.

James


