From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Mon, 8 Nov 2010 09:38:08 -0800
Message-ID: <20101108173808.GA13326@kroah.com>
References: <20101108112456.GI4173@linux.intel.com>
 <272723.33242.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <272723.33242.qm-5Es2LHxk9sSvuULXzWHTWIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 08, 2010 at 09:27:22AM -0800, Luben Tuikov wrote:
> --- On Mon, 11/8/10, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > -0700, Luben Tuikov wrote:
> > > Eliminate an infinite loop whereby the SCSI layer
> > > would reissue a command (which would be failed by
> > > the driver) ad infinitum. (Invariably due to the
> > > driver's profuse use of the
> > > SCSI_MLQUEUE_DEVICE_BUSY returned result in its
> > > queuecommand() method.)
> > > 
> > > Also add a debug option and a few debug prints.
> > 
> > Why have you added your own debug scheme instead of using
> > dev_dbg?
> 
> Because, this debug "scheme" produces copious and otherwise
> unnecessary volume of debug information in a working driver. And
> because you can turn it on/off just for this driver. It is intended to
> be used only for debugging this driver and the UAS device(s) to which
> the driver communicates. 99.9% of the time, this setting will be a 'N'
> out there.  And this is what the Kconfig help entry says: "If unsure,
> say 'N'."

dev_dbg() is able to be turned on and off dynamically when the kernel is
running without rebuilding anything, which is what you really want to
have happen for a driver being used by normal users.

It also produces the output in a standard manner that we have all agreed
to follow.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
