From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 4 Feb 2003 17:51:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204175146.A31515@lst.de>
References: <20030204162326.A30755@lst.de> <20030204081616.A24105@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030204081616.A24105@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Feb 04, 2003 at 08:16:16AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Feb 04, 2003 at 08:16:16AM -0800, Patrick Mansfield wrote:
> We are missing the above checks and functionallity in scsi_get_command.
> 
> The limit previously imposed by current_queue_depth via the number of
> scmnd's allocated is not checked - scsi_get_command should check
> device_busy < new_queue_depth.
> 
> I was trying to fix/hit this - surprisingly, I did not see performance
> problems (i.e. getting tons of QUEUE_FULLs), probably because my request
> queue limits are 128, and the disks are not old.

I wonder whether we really need it or whether the queue limits shouldn't
be enough.  If there's a chance I'd like to avoid having throttewling in
too many places.

> So one of the above needs to (conditionally ... based on gfp_mask?) get
> host/queue_lock, check limits, and conditionally add_wait_queue().

I don't think we need to add the waitqeue.  The scsi midlayer always
calls scsi_get_command with an GFP_ATOMIC argument, so we can't ever
wait, so this would only apply to the gdth drivers that calls it directly.
And even this driver only uses it for administrative commands (i.e. not
in the I/O) and the driver doesn't even compile in 2.5 :)

> What protects pool->users?

I assumed adding/removing hosts was serialized but it isn't.  I'll add
code to fix this in the next drop.

