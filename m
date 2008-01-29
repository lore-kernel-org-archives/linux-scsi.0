From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 14:17:20 -0500
Message-ID: <1201634240.3069.33.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0801291032210.4229-100000@iolanthe.rowland.org>
	 <1201624455.3069.10.camel@localhost.localdomain>
	 <479F7009.3020306@panasas.com>
	 <1201632515.3069.28.camel@localhost.localdomain>
	 <479F774B.60303@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <479F774B.60303-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-01-29 at 20:58 +0200, Boaz Harrosh wrote:
> > Your new code does
> > 
> > int partial; <- stack uninitialised
> > sb_stor_bulk_transfer_sglist(..., &partial, ...);
> > scsi_set_resid(srb, scsi_bufflen(srb) - partial);
> > 
> > If the function doesn't touch partial, as it doesn't in the error legs,
> > resid now gets set with rubbish.
> > 
> > Actually, my code is still wrong .. we have to set it to
> > scsi_bufflen(srb) - scsi_resid(srb) so that it comes back the same if
> > left untouched.
> > 
> >> I have such a device and I get one reset but then every thing works nice.
> >> This is with debug on. I'll try to make it fail.
> > 
> > James
> > 
> > 
> Sorry I still don't see it.
> 
> original code did sb_stor_bulk_transfer_sg(..., &srp->resid, ...)
> 
> but sb_stor_bulk_transfer_sg does the:
>  int partial; <- stack uninitialised
>  sb_stor_bulk_transfer_sglist(..., &partial, ...);
> 
> and then unconditionally sets *residual = length_left;
> I do not see an "error legs" case in sb_stor_bulk_transfer_sg().

This is really programming 101. This:

static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned
int pipe,
		struct scatterlist *sg, int num_sg, unsigned int length,
		unsigned int *act_len)
{
	int result;

	/* don't submit s-g requests during abort/disconnect processing */
	if (us->flags & ABORTING_OR_DISCONNECTING)
		return USB_STOR_XFER_ERROR;

The return USB_STOR_XFER_ERROR; is called an error leg.  It returns
without updating *act_len thus leaving &partial uninitialised.

James
