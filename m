From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH] 2.5.65, cciss_scsi, scsi error handling
Date: Tue, 18 Mar 2003 17:22:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <45B36A38D959B44CB032DA427A6E106404513385@cceexc18.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:

> On Tue, 2003-03-18 at 05:06, Stephen Cameron wrote:
[...]
> > Is it really accurate in this case to say
[as 2.5.65 kernel says about cciss)
> > 
> >   "ERROR: This is not a safe way to run your SCSI host
> >    ERROR: The error handling must be added to this driver"
[...]
> Yes, since if a command times out or fails for some reason, the driver
> will return I/O errors immediately (it could also lead to panics if you
> retain a reference to the now completed command inside the driver).

(responding here only to the parenthetical statement, 
No, the driver never decides that a command has timed out
precisely because we didn't want that problem.  (Oh no!
DMA just completed to...Don't know where. Time to panic!!!))

> 
> A fix like the one you propose: 
[...no-op error handling "fix" snipped...]
> Will simply cause the device to be offlined on the first error.
>
> Are the devices the cciss presents really genuine SCSI devices (which
> will have timeouts and report errors)?  In which case, you need proper
> error handling.
> 
> If they're just figments of the cciss controller imagination and
> commands will never error or timeout then perhaps you can get away with
> just filling in FAILED returns for a single error handler function.

Thanks for the reply James.

The devices are real scsi devices.  They will never timeout
on their own, from the driver's perspective.  If there is 
any timeout stuff happening, it would have to be due to scsi 
mid-layer timers expiring.

(Originally I had timeouts on the commands to guarantee 
completion, but nothing good happened if the timeout expired,
and all I ever got for the trouble was people complaining
(and rightly so) that their tape drives were getting set 
offline whenever they tried to erase a tape.  So I got rid of
that timeout.

I think we can implement the abort and device reset handlers,
(Seems like I tried this once before, but it got really ugly...  
Hmm, looking through my notes, I see this:

me> Tue Jul 17 10:35:19 CDT 2001
me> Actually, looking a bit harder, figured out the real problem 
me> was that the SCSI mid-layer's error processing code grabs the 
me> io_request_lock and disables interrupts before calling the 
me> driver's error handling routines. It holds the flags in a 
me> local variable inaccessible to the driver, so the driver 
me> cannot unlock and enable interrupts. Therefore, the driver 
me> must poll for command completions. The mid-layer assumes it 
me> knows that no commands are outstanding to the HBA when the 
me> error handling routine is called, but for our hybrid block/scsi 
me> driver, this assumption does not hold. So polling is not 
me> possible (or, overly complex) since we might get completions 
me> from the block half of the driver and we'd have to deal with 
me> those somehow.

I know the io_request_lock is gone, but similar things may still be 
going on... I remember having the idea of polling our own interrupt 
handler...

Anyway, I talked this (doing aborts and device resets) 
over with the firmware guys here, they seemed be of the 
opinion (off the top of their heads) that aborting commands and 
so on in the face of timeouts generally tends to make things worse, 
not better, but said it wouldn't really hurt.  (especially I was 
worried about i/o the array controller was doing  to disks on the 
same bus as the tape drive, disks of which linux knows nothing.)

Hmm.  If the tape drive were set off line, I wonder could I hot
plug it to get it back?

e.g. 
echo scsi revmove-single-device 0 0 0 0 > /proc/scsi/scsi
(physically hot unplug tape drive)
echo rescan > /proc/scsi/cciss1/1
(physically hot re-plug tape drive)
echo rescan > /proc/scsi/cciss1/1
echo scsi add-single-device 0 0 0 0 > /proc/scsi/scsi

I'll have to try it.  BTW people seemed to love our hot-plug
tape drives at linuxworld. (shameless plug, pun intended. :-)

-- steve



