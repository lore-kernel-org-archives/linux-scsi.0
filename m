From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Thu, 31 Jan 2008 15:56:31 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801311546450.22845-100000@iolanthe.rowland.org>
References: <47A22744.7010201@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33432 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754100AbYAaU4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:56:32 -0500
In-Reply-To: <47A22744.7010201@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mark Glines <mark@glines.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 31 Jan 2008, Boaz Harrosh wrote:

> >> The code in usb_stor_access_xfer_buf() will 
> >> now correctly attempt to transfer according to buflen and what ever is available
> >> at the passed sg's. Now this can be less or it can be more. SCSI standard defines
> >> this as underflow/overflow. When overflow should be reported as negative values.
> >> and an error status. (BUT not CHECK_CONDITION)
> > 
> > I don't understand.  How could you ever transfer more data than the 
> > requested amount?  The host won't expect to receive it and won't be 
> > able to handle it when it arrives.
> > 
> > (Furthmore, the USB mass-storage specification does not permit more 
> > data to be transferred than requested.  This fact isn't relevant to our 
> > discussion because we're talking about situations where the data was 
> > transferred via a non-standard protocol.  But even so...)
> That's fine then the transfer will abort with an error condition and will
> be handled correctly.

I still don't understand.  Can you explain exactly what an overflow 
condition (negative residue) really means?

Does it mean that the device had more data available than the host
asked for?  If it does, then you don't need to change the isd200 code
at all.  The changes to protocol.c will be enough.

However you should realize that usb-storage, as it stands, won't work
properly with negative residues.  Look at usb_stor_Bulk_transport() in
transport.c.  The residue variable is declared to be unsigned int.  
There's also code later on in the routine which assumes the residue is
never negative.

Alan Stern

