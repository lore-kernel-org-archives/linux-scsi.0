From: Brian Kysela <brian.kysela-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] usb-storage: Error in queuecommand: us->srb = ffff88006a338480
Date: Mon, 10 Nov 2008 14:24:03 -0500
Message-ID: <20081110192403.GA605@ezra.hsd1.tn.comcast.net>
References: <20081107005438.GA26198@ezra.hsd1.tn.comcast.net> <Pine.LNX.4.44L0.0811070953460.2437-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811070953460.2437-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 2008-11-07 at 10:00 -0500, Alan Stern wrote: 
> On Thu, 6 Nov 2008, Brian Kysela wrote:
> 
> > On 2008-11-06 at 14:36 -0500, Alan Stern wrote: 
> > > On Thu, 6 Nov 2008, Andrew Morton wrote:
> > > 
> > > > > The error message:
> > > > > 
> > > > > > [  152.701070] usb-storage: Error in queuecommand: us->srb = ffff88007dfd0680
> > > > > 
> > > > > means that the SCSI layer has told usb-storage to start a new command 
> > > > > before the old one completed.  This could happen, for example, if the 
> > > > > SCSI layer had gotten confused and tried to cancel a command that 
> > > > > wasn't running -- then it would think usb-storage was idle when in fact 
> > > > > it was still busy.  (This was the failure mechanism resulting from the 
> > > > > timeout changes.)
> > > > > 
> > > > 
> > > > OK, thanks.  I'll cc linux-scsi, but I have this-wont-be-getting-fixed
> > > > feelings on this one :(
> > > > 
> > > > I wonder what's special about Brian's setup.
> > > 
> > > Brian, if you can use usbmon to monitor what happens during the file 
> > > copy and subsequent error, it might provide a clue.  Instructions are 
> > > in the kernel source file Documentation/usb/usbmon.txt.
> > 
> > Since it's a large file, I have posted the content of usbmon here:
> > 
> > http://www.kysela.org/pub/1.mon.out
> > 
> > I also got another kernel bug and system freeze on that copy, after the
> > copy process hung, when I pulled the drive out:
> 
> This is exactly the failure mechanism I described earlier.  The usbmon
> log shows that a communications error occurred and usb-storage tried to
> carry out error recovery.  The drive apparently did not reset itself,
> because when the READ was reissued no data was received.  In fact, the
> log _ends_ at the point where the READ was reissued; no more data was
> transferred in either direction.  Presumably the next thing to occur
> was a command timeout.
> 
> And since the block-layer timeout code in 2.6.28-rc2 is known to be
> buggy, it's not surprising that the copy process hung at that point.  
> It would be better to run this test under 2.6.27; that way we might
> learn something new.

I tested with 2.6.27.5 and found that, although the process would hang as often
as usual, it always recovered instead of needing to reboot. No kernel bug or
system freeze, no climbing load avg, etc. Here is the usbmon output on a
failed copy:

http://www.kysela.org/pub/4.mon.out

The syslog:

[ 1003.736201] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 1003.738949] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 1003.741886]  sdb1
[ 1112.311917] end_request: I/O error, dev sdb, sector 667600
[ 1112.311956] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.312038] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.312074] end_request: I/O error, dev sdb, sector 667840
[ 1112.312121] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.312131] Buffer I/O error on device sdb1, logical block 512
[ 1112.312137] lost page write due to I/O error on sdb1
[ 1112.312159] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.312168] Buffer I/O error on device sdb1, logical block 576
[ 1112.312172] lost page write due to I/O error on sdb1
[ 1112.312181] Buffer I/O error on device sdb1, logical block 577
[ 1112.312185] lost page write due to I/O error on sdb1
[ 1112.312193] Buffer I/O error on device sdb1, logical block 578
[ 1112.312198] lost page write due to I/O error on sdb1
[ 1112.312211] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.312234] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.312247] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.379235] sd 6:0:0:0: rejecting I/O to offline device
[ 1112.379640] FAT: unable to read inode block for updating (i_pos 9253)

Brian
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
