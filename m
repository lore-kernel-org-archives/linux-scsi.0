From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 4 Feb 2003 09:19:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204091955.A24785@beaverton.ibm.com>
References: <20030204162326.A30755@lst.de> <20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030204175146.A31515@lst.de>; from hch@lst.de on Tue, Feb 04, 2003 at 05:51:46PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Feb 04, 2003 at 05:51:46PM +0100, Christoph Hellwig wrote:
> On Tue, Feb 04, 2003 at 08:16:16AM -0800, Patrick Mansfield wrote:

> > I was trying to fix/hit this - surprisingly, I did not see performance
> > problems (i.e. getting tons of QUEUE_FULLs), probably because my request
> > queue limits are 128, and the disks are not old.
> 
> I wonder whether we really need it or whether the queue limits shouldn't
> be enough.  If there's a chance I'd like to avoid having throttewling in
> too many places.

We really need to limit to what the scsi_device (thinks it) can handle
(currently new_queue_depth). Otherwise we could have QUEUE_FULL storms,
plus we really don't want that many scsi_cmnd's outstanding (i.e. limited
by the amount of memory we can allocate) when we have many scsi_devices on
the system. If we lowered the request queue limit that would hurt
scsi_devices (and maybe adapters) with a low queue limits.

> > So one of the above needs to (conditionally ... based on gfp_mask?) get
> > host/queue_lock, check limits, and conditionally add_wait_queue().
> 
> I don't think we need to add the waitqeue.  The scsi midlayer always
> calls scsi_get_command with an GFP_ATOMIC argument, so we can't ever
> wait, so this would only apply to the gdth drivers that calls it directly.
> And even this driver only uses it for administrative commands (i.e. not
> in the I/O) and the driver doesn't even compile in 2.5 :)

Agree.

So, we should not externalize it (and we should get rid of scsi_do_cmd);
drivers should already be using scsi_allocate_request/scsi_{do,wait}_req.

-- Patrick Mansfield
