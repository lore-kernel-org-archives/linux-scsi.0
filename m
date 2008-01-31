From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
	isd200.c
Date: Thu, 31 Jan 2008 10:00:51 -0800
Message-ID: <20080131180051.GA22341@kroah.com>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org> <47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe> <47A1E6A0.8050500@panasas.com> <47A2033D.2050502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <47A2033D.2050502-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 31, 2008 at 07:19:57PM +0200, Boaz Harrosh wrote:
> 
>   scsi_scan is issuing a 36-byte INQUIRY request to llds. isd200 would
>   volunteer 96 bytes of INQUIRY. This caused an underflow condition in
>   protocol.c usb_stor_access_xfer_buf(). So first fix is to
>   usb_stor_access_xfer_buf() to properly handle underflow conditions.
>   Then usb_stor_set_xfer_buf() should report this condition as a negative
>   resid. Should we also set cmnd->status in the underflow condition?
> 
>   Then also isd200.c is fixed to only return the type of INQUIRY && SENSE
>   the upper layer asked for.
> 
> Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>

As this is a regression and hits 2.6.24, can you send the final version
of this patch to the stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org address so we can get it into the
2.6.24.y tree?

thanks,

greg k-h
