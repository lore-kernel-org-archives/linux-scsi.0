From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Questions about scsi_target_reap and starget/sdev lifecyle
Date: Tue, 21 Jun 2005 17:22:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506211711080.1365-100000@iolanthe.rowland.org>
References: <20050621205858.GB30526@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:27880 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262526AbVFUVWV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 17:22:21 -0400
In-Reply-To: <20050621205858.GB30526@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 21 Jun 2005, Mike Anderson wrote:

> I have asked this multiple times, but I will again. If the hba knows to
> fail everything by some internal state in the LLDD why does it not also
> know to flush all commands back to the scsi mid layer in this unplugged
> state so we do not have to deal with canceling them from the mid-layer. 

With usb-storage, part of it is my fault.  It never occurred to me that we
should fail all outstanding commands prior to calling scsi_remove_host,
since I expected the midlayer to take care of things.  I'll try changing
usb-storage and see if it works with scsi_host_cancel coming after
scsi_forget_host (or even removed entirely!).

> I think it has been stated many times if commands always go in through
> queuecommand and always return through scsi_done it makes the chances of
> errors a lot less.

I agree.  The current state must have arisen for historical reasons.  

Alan Stern

