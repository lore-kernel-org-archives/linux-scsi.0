From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Thu, 31 Jan 2008 14:34:09 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801311425540.2502-100000@iolanthe.rowland.org>
References: <47A21AB6.5060203@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41649 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752707AbYAaTeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 14:34:11 -0500
In-Reply-To: <47A21AB6.5060203@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mark Glines <mark@glines.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 31 Jan 2008, Boaz Harrosh wrote:

> On Thu, Jan 31 2008 at 19:49 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 31 Jan 2008, Boaz Harrosh wrote:
> > 
> >> @@ -228,9 +228,14 @@ void usb_stor_set_xfer_buf(unsigned char *buffer,
> >>  {
> >>  	unsigned int offset = 0;
> >>  	struct scatterlist *sg = NULL;
> >> +	unsigned int count;
> >>  
> >> -	usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
> >> +	count = usb_stor_access_xfer_buf(buffer, buflen, srb, &sg, &offset,
> >>  			TO_XFER_BUF);
> >> -	if (buflen < scsi_bufflen(srb))
> >> -		scsi_set_resid(srb, scsi_bufflen(srb) - buflen);
> >> +
> >> +	/* Check for underflow */
> >> +	if (buflen > scsi_bufflen(srb))
> >> +		count = buflen;
> >> +
> >> +	scsi_set_resid(srb, scsi_bufflen(srb) - count);
> >>  }
> > 
> > This last "if" statement doesn't look right.  And since you know that
> > count will never be larger than scsi_bufflen(srb), you don't have to
> > check for underflow at all.  Just leave out the "if" and call
> > scsi_set_resid() directly.
> > 
> > Alan Stern
> > 
> I was thinking about that hard. And I disagree. It could be that we have
> sg-list length (The total of all sg->length) that does not match
> scsi_bufflen() - More or less.

If that ever happens we'll be in big trouble.  Not just here but in 
other places as well.

> The code in usb_stor_access_xfer_buf() will 
> now correctly attempt to transfer according to buflen and what ever is available
> at the passed sg's. Now this can be less or it can be more. SCSI standard defines
> this as underflow/overflow. When overflow should be reported as negative values.
> and an error status. (BUT not CHECK_CONDITION)

I don't understand.  How could you ever transfer more data than the 
requested amount?  The host won't expect to receive it and won't be 
able to handle it when it arrives.

(Furthmore, the USB mass-storage specification does not permit more 
data to be transferred than requested.  This fact isn't relevant to our 
discussion because we're talking about situations where the data was 
transferred via a non-standard protocol.  But even so...)

> so the code is actualy
> 	if (buflen > scsi_bufflen(srb))
> 		scsi_set_resid(srb, scsi_bufflen(srb) - buflen); /* Negative overflow */

Okay, let's assume that both buflen and the sum of the sg-list lengths
are somehow greater than scsi_bufflen(srb).  You still don't know that
they are equal to each other.  All you know is that the amount actually
transferred is stored in count.  Hence the negative overflow value
should be

	scsi_bufflen(srb) - count

and not

	scsi_bufflen(srb) - bufflen.

Alan Stern

