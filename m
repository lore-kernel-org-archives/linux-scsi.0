From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a
 256 byte sector SCSI disk is attached
Date: Fri, 28 May 2010 15:25:34 -0500
Message-ID: <1275078334.4479.31.camel@mulgrave.site>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
	 <201005281634.o4SGYU6M015956@demeter.kernel.org>
	 <4C001999.1010703@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab0E1UZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 16:25:40 -0400
In-Reply-To: <4C001999.1010703@cfl.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dmarkh@cfl.rr.com
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2010-05-28 at 15:29 -0400, Mark Hounschell wrote:
> On 05/28/2010 12:34 PM, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=16058
> >
> >
> >
> >
> >
> > --- Comment #6 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-05-28 16:34:28 ---
> > Reply-To: James.Bottomley@suse.de
> >
> > On Fri, 2010-05-28 at 10:58 -0400, Alan Stern wrote:
> >   
> >> On Fri, 28 May 2010, Mark Hounschell wrote:
> >>
> >>     
> >>> First READ(10):
> >>>
> >>>  sde:
> >>> ahc_calc_residual: Entered
> >>> ahc_calc_residual: return Case 5-1 resid = 0x800
> >>> ahc_calc_residual: return Case 5-2 resid = 0x800
> >>>
> >>> scsi_finish_command: Entered for cmd(10):0x28 0x00 0x00 0x00 0x00 0x00
> >>> 0x00 0x00 0x08 0x00
> >>> cmd->result = 0x00000000
> >>> good_bytes == old_good_bytes = 0x800  scsi_get_resid(cmd) = 0x800
> >>> New good_bytes = 0x0
> >>> scsi_finish_command: Complete
> >>>
> >>> From here it just keeps repeating this read of 8 blocks. (2048 bytes) so
> >>> it looks like the machine is hung.
> >>>       
> >> Probably not hung, just doing a lot of retries.  It should time out 
> >> eventually, but it might take a long time (perhaps as long as 15 
> >> minutes).  The combination of the block layer and the SCSI layer isn't 
> >> very good at knowing when to give up.
> >>     
> > Actually, I think this is a partition read.  Each partition manager
> > tends to read a page through the page cache.  If we get an error, we
> > seem to re-read to fill the cache.
> >
> >   
> >>> Now, I know for a fact that _if_ this read CDB is actually being sent to
> >>> the drive, it's actual residual count will be zero. These are working
> >>> disks and that read CDB is valid.
> >>>
> >>> Why is ahc_calc_residual saying that the residual count is as though the
> >>> read never took place? I noticed that the first read on all the SATA
> >>> drives was for 4096 bytes, why is this one only 2048? Should it have
> >>> been 4096 and ahc_calc_residual assume that?
> >>>       
> >> I don't know the answer to any of these questions.  They could well be
> >> due to bugs in the driver, and I know nothing about how the aic7xxx
> >> driver works.  You should talk to someone who does.
> >>     
> > I'll take this one ... although we're a bit lacking in documentation for
> > this driver.
> >
> > I think the 2048 is because something is hardcoded to think 8 sectors is
> > a page.
> >
> > James
> >
> >   
> Your probably right. But is a 256 byte sector really a supported sector
> size for a linux fs on a SCSI disk?

In theory the block layer can support any power of two sector size (or
really any sector size which is a divisor of the page size).  We had a
use for 256 byte sectors once, so they're in SCSI.  In practice, since
they're so rare, the code paths are never tested (as you found out) and
there's a more annoying problem which is since the linux base sector
size is 512, you have to multiply to get from 256 to 512 ... for all
other sector sizes you have to divide, so any conversion routine that
only right shifts would get this wrong.

>  When it sees a 768 byte sector disk,
> it says it's an unsupported size and goes on with the boot process
> without even doing a read for a partition table.

that's because 768 isn't a power of 2, so it's completely unsupportable.

>  Should maybe it be
> doing the same for a 256 byte sector disk???

Possibly ... I don't know what the 256 byte sector support was for ...
all I know is that whatever it was, I don't have one.

James


