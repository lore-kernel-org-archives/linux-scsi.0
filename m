From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: 24 Apr 2003 10:26:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051194392.1754.12.camel@mulgrave>
References: <Pine.LNX.4.44L0.0304240954480.738-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:4613 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262731AbTDXOPH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 10:15:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.0304240954480.738-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andries.Brouwer@cwi.nl, stelian@popies.net, afafc@rnl.ist.utl.pt, Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, mike@hingston.demon.co.uk

On Thu, 2003-04-24 at 10:05, Alan Stern wrote:
> You probably already know this, but I'll point it out anyway.  The 
> protocol.c file contains 4 different translation routines:
> 
> 	usb_stor_qic157_command(),
> 	usb_stor_ATAPI_command(),
> 	usb_stor_ufi_command(),
> 	usb_stor_transparent_scsi_command().
> 
> The third one already contains the 4->8 modification and your patch adds 
> it to the fourth.  But it's still missing from the first two.
> 
> I agree with James Bottomley's comment that it's not really safe to be 
> doing this at all, even if we do feel sure that sufficient buffer space 
> exists.  After all, some other data may be using that space.
> 
> Better solutions would be not to issue the 4-byte call at all, 
> or to recognize that it failed and re-issue with at least 8 bytes.  That 
> way no questionable buffer-size conversion is needed.  There's also the 
> advantage of not having to do the same thing in 4 different places within 
> usb-storage.

Actually, the better solution might be to enforce a minimum transfer
length for non-scatter gather transfers.  Although we could enforce this
in the mid-layer allocations, we'd be in difficulty for user issued
commands, so the scheme that copes with everything would be a bounce
buffer type of thing (you supply a transfer request too short for the
device, I provide the bigger buffer and then give you back what you
asked for).

Better suggestions?

James


