From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] cciss: fix error reporting for SG_IO
Date: Fri, 24 Aug 2007 12:24:31 +0200
Message-ID: <20070824102431.GD23758@kernel.dk>
References: <20070814195338.GA10828@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757543AbXHXKY6@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070814195338.GA10828@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, james.bottomley@steeleye.com, hch@infradead.org, steve.cameron@hp.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 14 2007, Mike Miller (OS Dev) wrote:
> Patch 1/1
> Steve has been trying to send this out but it doesn't seem to be getting
> anywhere. Please review this patch for accuracy. There's a couple of things
> not clear to us.
> 
> Thanks,
> mikem
> 
> --------------------------------------------------------------------------------
> We found a problem with the way cciss was filling out rq->errors.
> Previously, it just put a 1 or a 0 in there and used the negation
> of this as the uptodate parameter to one of the functions in the
> block layer, being a block device.
> 
> For the SG_IO support, this is not sufficient, and we noticed
> that for example, sg_turs from sg3_utils does not correctly
> detect problems due to cciss filling out rq->errors incorrectly.
> 
> So, below is my attempt at fixing this, but I'm not completely
> sure I did it all right.  It is better than before, in that
> now sg_turs seems to detect when things go wrong (e.g.:
> when a disk is inaccessible due to cables being yanked, it
> notices.)
> 
> There is some stuff in scsi.h:
> 
> > /*
> >  *  Use these to separate status msg and our bytes
> >  *
> >  *  These are set by:
> >  *
> >  *      status byte = set from target device
> >  *      msg_byte    = return status from host adapter itself.
> >  *      host_byte   = set by low-level driver to indicate status.
> >  *      driver_byte = set by mid-level.
> >  */
> > #define status_byte(result) (((result) >> 1) & 0x7f)
> > #define msg_byte(result)    (((result) >> 8) & 0xff)
> > #define host_byte(result)   (((result) >> 16) & 0xff)
> > #define driver_byte(result) (((result) >> 24) & 0xff)
> 
> I'm unsure about the msg_byte (sg_turs appears not to 
> look at it.)  I used a device specific code (cciss 
> notion of CommandStatus) here.  Not sure if that's correct, 
> but not sure what else I would use.  Any clarification on 
> that would be helpful.  And of course, let me know if you 
> notice anything else I might have screwed up.
> 
> -- steve
> 
> Signed-off-by: Stephen M. Cameron <steve.cameron@hp.com>
> 
> ---
> 
>  drivers/block/cciss.c |   81 ++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 63 insertions(+), 18 deletions(-)
> 
> diff -puN drivers/block/cciss.c~sg_io_fix_error_reporting drivers/block/cciss.c
> --- linux-2.6.23-rc2/drivers/block/cciss.c~sg_io_fix_error_reporting	2007-08-13 09:44:58.000000000 -0500
> +++ linux-2.6.23-rc2-scameron/drivers/block/cciss.c	2007-08-13 09:44:58.000000000 -0500
> @@ -2366,30 +2366,57 @@ static inline void resend_cciss_cmd(ctlr
>  	start_io(h);
>  }
>  
> +/* inverse of macros in scsi.h */
> +
> +#define shift_status_byte(x) ((x) & 0xff)
> +#define shift_msg_byte(x) (((x) & 0xff) << 8)
> +#define shift_host_byte(x) (((x) & 0xff) << 16)
> +#define shift_driver_byte(x) (((x) & 0xff) << 24)
> +
> +#define make_status_bytes(s, m, h, d) \
> +	shift_status_byte((s)) |\
> +	shift_msg_byte((m)) |\
> +	shift_host_byte((h)) |\
> +	 shift_driver_byte((d))

Please don't make that a macro, make it a function. Otherwise it looks
ok, care to fix that up and resubmit?

-- 
Jens Axboe
