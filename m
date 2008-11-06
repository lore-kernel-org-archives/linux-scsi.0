From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb = ffff88006a338480
Date: Thu, 6 Nov 2008 14:36:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811061435070.23473-100000@iolanthe.rowland.org>
References: <20081106095757.2c2fcdc3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41885 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751005AbYKFTgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 14:36:41 -0500
In-Reply-To: <20081106095757.2c2fcdc3.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Kysela <bkysela@gmail.com>, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 6 Nov 2008, Andrew Morton wrote:

> > The error message:
> > 
> > > [  152.701070] usb-storage: Error in queuecommand: us->srb = ffff88007dfd0680
> > 
> > means that the SCSI layer has told usb-storage to start a new command 
> > before the old one completed.  This could happen, for example, if the 
> > SCSI layer had gotten confused and tried to cancel a command that 
> > wasn't running -- then it would think usb-storage was idle when in fact 
> > it was still busy.  (This was the failure mechanism resulting from the 
> > timeout changes.)
> > 
> 
> OK, thanks.  I'll cc linux-scsi, but I have this-wont-be-getting-fixed
> feelings on this one :(
> 
> I wonder what's special about Brian's setup.

Brian, if you can use usbmon to monitor what happens during the file 
copy and subsequent error, it might provide a clue.  Instructions are 
in the kernel source file Documentation/usb/usbmon.txt.

Alan Stern

