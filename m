From: Mark Haverkamp <markh@osdl.org>
Subject: RE: 2.5.59-dcl2
Date: 29 Jan 2003 12:09:56 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043870995.11929.12.camel@markh1.pdx.osdl.net>
References: <0E3FA95632D6D047BA649F95DAB60E570185EEEF@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570185EEEF@EXA-ATLANTA.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <atulm@lsil.com>
Cc: "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, andmike@us.ibm.com, linux-scsi@vger.kernel.org

On Wed, 2003-01-29 at 11:41, Mukker, Atul wrote:
> What might be happening here is, FW is retrying the command for some
> iterations and each of them times out. The total timeout is greater than the
> expected window.
> 
> A SCSI trace would tell us exactly what is going on there.

Unfortunately we don't have a SCSI analyzer here.

Mark.
> 
> Thanks
> -Atul Mukker
> 
> -----Original Message-----
> From: Matt_Domsch@Dell.com [mailto:Matt_Domsch@Dell.com]
> Sent: Wednesday, January 29, 2003 12:35 AM
> To: markh@osdl.org
> Cc: andmike@us.ibm.com; linux-scsi@vger.kernel.org; atulm@lsil.com
> Subject: RE: 2.5.59-dcl2
> 
> 
> > From: Mark Haverkamp [mailto:markh@osdl.org]
> > I sent a bug report the the kernel bugzilla a while ago. It 
> > got assigned
> > to someone at IBM by default.  This is a problem we have been having
> > between our megaraid cards and an IBM enclosure for some time.  I get
> > around it by disabling report luns in my kernel configuration.  
> > 
> > Could you take a look at the bug and let me know if I've 
> > included enough
> > information to make sense.  I included debug output for the 
> > 1.18 and 2.0 driver.
> > 
> > http://bugme.osdl.org/show_bug.cgi?id=183
> > 
> > or
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=183
> 
> Mark, your description in the bug appears accurate.  Here's what happens:
> 
> 1) REPORT_LUNS is sent to the IBM enclosure, command times out.
> 2) scsi_unjam_host() runs, trying the error handlers...
> 3) megaraid abort handler, then the reset handler called (3 times), none of
> which do anything at all because the command has already been issued to the
> firmware, and the card itself isn't getting reset.  Both those routines
> return failure.
> 4) so scsi_unjam_host() offlines the device
> 5) scsi_decide_disposition() sees device is offline and returns success,
> freeing the command for future use again.
> 6) command eventually completes and the mega_rundoneq() calls
> cmd->scsi_done() on it, but cmd has been filled with 0x5a's so it Oopses.
> 
> 
> The scsi mid-layer shouldn't free a command that hasn't actually been
> aborted/reset because it *could* come back from the firmware after the
> timeout has expired, and the driver has a reference to it (need
> refcounting...)  This could potentially lead to an exhaustion of the command
> pool though, if a command *never* comes back.
> 
> How long does it take for the IBM enclosure to return REPORT LUNS?  Since
> this works on aic7xxx within the timeout period, I'm guessing the megaraid
> firmware takes a long time to deal with it since it's a pass-through device.
> 
> I believe there is a way to issue an adapter reset command to the megaraid
> firmware, though neither driver series 1.18 or 2.00 do so presently.
> Copying Atul for insight as to what effects this would have on the
> controller and commands in flight...
> 
> Thanks,
> Matt
> 
> --
> Matt Domsch
> Sr. Software Engineer, Lead Engineer, Architect
> Dell Linux Solutions www.dell.com/linux
> Linux on Dell mailing lists @ http://lists.us.dell.com
-- 
Mark Haverkamp <markh@osdl.org>

