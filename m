From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Fri, 20 Jun 2008 22:17:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806202212040.8121-100000@netrider.rowland.org>
References: <1213999774.3443.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3263 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752294AbYFUCRc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2008 22:17:32 -0400
In-Reply-To: <1213999774.3443.49.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 20 Jun 2008, James Bottomley wrote:

> > In this case the fill data is getting treated as real data.  Does this
> > clarify the situation?
> 
> Yes, thanks.  It's a bit nasty from a security point of view, since the
> leaking data apparently belonged to a different command.

Indeed; the data belonged to the previous command.  It definitely is a 
security hole.

>  Wouldn't a
> better fix (and a more secure one) be to clear from the end of the valid
> data to the end of the buffer?

It certainly would be easier and shorter.  I'll send in a patch to do
it next week.

Whether it would be _better_ is a question of taste.  I don't really
like the idea of telling a caller "Here's your data.  Some of it is
valid (but we're not going to tell you how much) and the rest is set to
0.  Do the best you can with it."  What if somebody had preset their
buffer to some value other than 0?

Alan Stern

