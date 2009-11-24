From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Tue, 24 Nov 2009 14:28:35 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911241418440.2881-100000@iolanthe.rowland.org>
References: <4B0C1C20.2080901@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <4B0C1C20.2080901@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Cc: tmhikaru@gmail.com, Kernel development list <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ext4@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 24 Nov 2009, Boaz Harrosh wrote:

> > I would have expected the READ to be retried, but in these two cases 
> > it wasn't.  The usbmon log contained five instances of this error 
> > sequence; the other three were retried successfully.  I don't know what 
> > the difference was.
> > 
> 
> Perhaps the time it took to complete.
> 
> I have a very old IDE disk connected to a USB box here, and some bad sectors take ages
> to return. One thing I wanted to investigate is why the complete Linux system is frozen
> for minutes when I "cp" one of these bad-sectors and then every thing is back to normal.
> It's just an inserted external box. Swap system and everything is on an another healthy HD.
> As if the USB controller actually locks the PCI bus, or the interrupts are off for a long
> while. (Or is it the BKL?)
> 
> Do you have time stamps on these?

Yes.  Each of the unsuccessful reads, whether retried or not, lasted
less than one millisecond.  So that's probably not the reason.


On Tue, 24 Nov 2009, Jan Kara wrote:

>   My naive guess would be that those non-retried reads were actually
> readahead. That's not retried if I remember correctly. Later, when we
> really needed the data, we sent another read request...

That would be my guess too.  I don't know how to verify it, though.

If you're interested in pursuing this farther, I can show you how to 
generate equivalent errors on demand using an emulated USB drive.  
At this point it's not clear how much more one could learn by doing 
this, however.

Alan Stern

