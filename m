From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 10:05:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304240954480.738-100000@ida.rowland.org>
References: <UTC200304240946.h3O9kA600867.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1540 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263668AbTDXNxd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 09:53:33 -0400
In-Reply-To: <UTC200304240946.h3O9kA600867.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, USB development list <linux-usb-devel@lists.sourceforge.net>, mike@hingston.demon.co.uk

On Thu, 24 Apr 2003 Andries.Brouwer@cwi.nl wrote:

>     From: Stelian Pop <stelian@popies.net>
> 
>     > --- protocol.c~ Fri Nov 22 22:40:13 2002
>     > +++ protocol.c  Thu Apr 24 00:38:31 2003
>     > @@ -366,6 +366,8 @@
>     >                         srb->cmnd[2] = srb->cmnd[2];
>     >                         srb->cmnd[1] = srb->cmnd[1];
>     >                         srb->cmnd[0] = srb->cmnd[0] | 0x40;
>     > +                       if (srb->cmnd[8] < 8)
>     > +                               srb->cmnd[8] = 8;
>     >                         break;
>     >                 } /* switch (srb->cmnd[0]) */
>     >         } /* if (us->flags & US_FL_MODE_XLATE) */
> 
>     This patch (applied without the first one) does not make any
>     difference: memory stick initialisation still takes several
>     minutes to complete, floppy drive initialisation takes about
>     10 minutes before the block layer aborts the requests with
>     a read error.
> 
> OK. That perhaps means that the mode sense command doesnt
> pass through this code, e.g. because US_FL_MODE_XLATE
> is not set?
> 
> At first sight your reports do not give VendorID, ProductID.
> Do these devices occur in the unusual devices list?
> 
> Andries

Andries:

You probably already know this, but I'll point it out anyway.  The 
protocol.c file contains 4 different translation routines:

	usb_stor_qic157_command(),
	usb_stor_ATAPI_command(),
	usb_stor_ufi_command(),
	usb_stor_transparent_scsi_command().

The third one already contains the 4->8 modification and your patch adds 
it to the fourth.  But it's still missing from the first two.

I agree with James Bottomley's comment that it's not really safe to be 
doing this at all, even if we do feel sure that sufficient buffer space 
exists.  After all, some other data may be using that space.

Better solutions would be not to issue the 4-byte call at all, 
or to recognize that it failed and re-issue with at least 8 bytes.  That 
way no questionable buffer-size conversion is needed.  There's also the 
advantage of not having to do the same thing in 4 different places within 
usb-storage.

Alan Stern

