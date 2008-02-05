From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Tue, 5 Feb 2008 10:42:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802051037040.4167-100000@iolanthe.rowland.org>
References: <47A8213B.9050705@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47A8213B.9050705-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-lYEaACU144FWk0Htik3J/w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 5 Feb 2008, Boaz Harrosh wrote:

> > However the interface to usb_stor_access_xfer_buf() will have to change
> > slightly.  Right now if it sees that *sgptr is NULL, it assumes this
> > means it should start at the beginning of the s-g buffer.  But with 
> > Boaz's change, *sgptr == NULL means the transfer has reached the end of 
> > the buffer.  So I'll have to go through and audit all the callers.
> > 
> > Alan Stern
> > 
> > -
> No it does not, this as not changed. Please look again.

You look again.  Your patched code goes like this:

		struct scatterlist *sg = *sgptr;

		if (!sg)
			sg = (struct scatterlist *) srb->request_buffer;

Hence if *sgptr is NULL upon entry, it is taken to mean that the 
transfer should start at the beginning of the s-g buffer.

		/* This loop handles a single s-g list entry, which may
		 * include multiple pages.  Find the initial page structure
		 * and the starting offset within the page, and update
		 * the *offset and *index values for the next loop. */
		cnt = 0;
		while (cnt < buflen && sg) {

Hence if sg is NULL, it indicates the end of the buffer has been 
reached.  And then down near the end of the routine:

		*sgptr = sg;

Hence if the end is reached and the caller makes another call to try 
transferring more data, the additional data will get stored back at the 
beginning of the buffer.

> Note that this patch was tested and working. It is a bug
> in v2.2.24 and it should be accepted already. One way or
> the other.
> 
> Callers of usb_stor_access_xfer_buf() need not change.
> Matthew Dharm should decide if he wants the WARN_ON in 
> usb_stor_set_xfer_buf() or not and be done with it.
> 
> I have found and fixed the bug, but it is not a SCSI
> related bug, and it is not do to any scsi changes. It
> is a bug from the SG changes of early 2.6.24. Please
> take it through the USB tree. Feel free to change it
> the way you like it, and submit it.

I will post a new version of this which handles all these issues.  
Expect it in a day or so.

Alan Stern
