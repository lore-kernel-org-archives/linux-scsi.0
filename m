From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] bugfix for an underflow condition in usb storage &
 isd200.c
Date: Mon, 4 Feb 2008 15:05:58 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802041500420.5186-100000@iolanthe.rowland.org>
References: <20080203192316.GF27785@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40286 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757157AbYBDUGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 15:06:00 -0500
In-Reply-To: <20080203192316.GF27785@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, USB list <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 3 Feb 2008, Matthew Dharm wrote:

> But, the modifications to usb_stor_access_xfer_buf() look good -- no
> request from a sub-driver should be allowed to scribble into memory.  The
> current code does make the implicit assumption that there is enough
> storage, and will walk right off the end of the sg list if there isn't.
> 
> I'm not sure I like the mods to usb_stor_set_xfer_buf().  Any place we set
> a status that we know is going to be thrown away is an invitation for a
> problem later if someone changes the code to preserve that status.  It's a
> jack-in-the-box, waiting to spring open in our face later.  The limit check
> (which mirrors the usb_stor_access_xfer_buf modification) and WARN_ON() are
> probably good.
> 
> In a strictly technical sense, the change to protocol.c are sufficient.
> That is, they will prevent a serious error.  There is a justification tho
> to fix all of the users of usb_stor_access_buf() to not attempt to use more
> SCSI buffer than exists.
> 
> My opinion is this:  Let's make the protocol.c mods (modulo my comments
> about setting useless status bits) now.  Then, let's decide if we're going
> to patch all the other users of the usb_stor_*_xfer_buf() functions as a
> separate discussion.

I think the correct approach is to modify those routines so that they 
will never overrun the s-g buffer (like Boaz has done), and _document_ 
this behavior.  Then the callers can feel free to try and transfer as 
much as they want, knowing that an overrun can't occur.  There won't 
be any need for a WARN_ON or anything else.

However the interface to usb_stor_access_xfer_buf() will have to change
slightly.  Right now if it sees that *sgptr is NULL, it assumes this
means it should start at the beginning of the s-g buffer.  But with 
Boaz's change, *sgptr == NULL means the transfer has reached the end of 
the buffer.  So I'll have to go through and audit all the callers.

Alan Stern

