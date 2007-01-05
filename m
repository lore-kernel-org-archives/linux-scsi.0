From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: megaraid_sas xscale interrupt mask?
Date: Thu, 4 Jan 2007 19:20:34 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822989085B@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42358 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030288AbXAECUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2007 21:20:42 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Malicki <jmalicki@metacarta.com>
Cc: linux-poweredge@dell.com, "Keith R. Baker" <krbaker+dpe@metacarta.com>, linux-scsi@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>


Hello Joe,

	The mask value 0x1f is to mask out interrupts. The value in the
current kernel code is appropriate for all controllers that the driver
supports. 

	Are you seeing any specific issue in driver with this mask
value?
	
Regards,

Sumant 

-----Original Message-----
From: Joe Malicki [mailto:jmalicki@metacarta.com] 
Sent: Wednesday, January 03, 2007 5:41 PM
To: Patro, Sumant
Cc: linux-poweredge@dell.com; Keith R. Baker; linux-scsi@vger.kernel.org
Subject: megaraid_sas xscale interrupt mask?

Hi Sumant,

While trying to debug Dell PERC 5/i RAID controller problems we've been
having with the megaraid_sas driver, we've been inspecting differences
between the Red Hat EL 4 kernel (which Dell officially supports) versus
the stock Linux 2.6.17.13 driver we use.  We found a very interesting
change, introduced into linux 2.6.16, that seems very odd to us:

http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/51f889b
d09bafd2d/cbbe2a30b8c2eb94?lnk=st&q=outbound_intr_mask+0x1f+0x00000001&r
num=1#cbbe2a30b8c2eb94

The title of the thread is "megaraid_sas: new template defined to
represent each type of controllers", and introduces this curious change:

 /**
  * megasas_disable_intr -      Disables interrupts
  * @regs:                      MFI register set
  */
 static inline void
 megasas_disable_intr(struct megasas_register_set __iomem * regs)  {
-       u32 mask = readl(&regs->outbound_intr_mask) & (~0x00000001);
+       u32 mask = 0x1f;
        writel(mask, &regs->outbound_intr_mask);

        /* Dummy readl to force pci flush */

Interrupts are enabled by writing "1" to the same register.

Is there a specific reason for this?  Is it possible that Dell PERC 5/i
controllers differ from LSI controllers in this respect?  It seems odd
that this change would be introduced without any explanation for what
it's meant to do, so I am very curious if it could be an inadvertently
introduced bug that is causing some problems.

Thanks!
Joe Malicki

--
Joseph Malicki
Software Engineer
Metacarta, Inc.
350 Massachusetts Avenue
4th Floor
Cambridge, MA 02451 USA

email: joe.malicki@metacarta.com

http://www.metacarta.com

Joe Malicki wrote:
> After upgrading to the new 5.0.3-0001 "package build" firmware, 
> released 12/12/06, from 
> http://support.dell.com/support/downloads/format.aspx?c=us&l=en&s=gen&
> osl=en&deviceid=9182&releaseid=R141188,
> we just experienced one firmware problem that's leaving a clear 
> traceback.  I don't know if this is
> 
> 1) the same problem we were experiencing before, that the new firmware

> introduced debugging/a detailed error message for (if this is the 
> case, I do really appreciate that Dell did this, since it may help to 
> fix these problems eventually),
> 2) A problem introduced by the new firmware, or
> 3) A preexisting problem that we never happened to experience before.
> 
> In the firmware logs at the end of this message, note that just 15 
> minutes after a battery relearn is finished and the battery finished 
> charging, we see the message:
> 
> 01/02/07  0:33:50: Diag Retention test is running...all activities are

> stopped
> 
> This corresponds to when the megasas driver timed out SCSI commands 
> and the controller stopped responding.
> 
> 1) Does anyone know what a "Diag Retention test" is?  Documentation 
> mentions "BBU Retention tests" and "NVRAM Retention tests", but not 
> "Diag Retention test" - is the "Diag Retention test" a synonym for one

> of these, or is it something different?
> 2) Has anyone seen a similar failure?
> 
> Note that 4 hours after the controller has been offline, a stack 
> backtrace, with a firmware source code file and line number, appears 
> in the firmware logs - which is something I wouldn't expect to happen 
> under any circumstances on a stable product - and seems to drop to a 
> debug console (we haven't tried hooking up a serial port to what look 
> like the headers on the PERC card, we didn't experiment too much the 
> first time it happened as it's a production machine we wanted to get
back up quickly).
> 
> We have previously noticed failures corresponding with patrol reads, 
> and this failure takes place several hours later, and the traceback 
> happens within the "PatrolReadTimer" procedure - is this the same
failure as before?
> 
> We don't yet have a clear reproduction case, but are working on it 
> with additional information we have from this crash (as we've begun 
> remote logging to capture the state of the machine as it's dying, 
> since syslog failing because it couldn't write to disk in previous 
> crashes lowered the amount of information we could get).
> 
> Thanks,
> Joe
> 
> Logs follow:
> 
> 01/01/07 20:16:57: PR cycle complete
> 01/01/07 20:16:57: EVT#06277-01/01/07 20:16:57:  35=Patrol Read 
> complete
> 01/01/07 20:16:57: Next PR scheduled to start at 01/02/07 18:13:20
> 01/01/07 21:17:01: EVT#06278-01/01/07 21:17:01:  44=Time established 
> as
> 01/01/07 21:17:01; (1727059 seconds since power on)
> 01/01/07 21:23:40: EVT#06279-01/01/07 21:23:40: 162=Current capacity 
> of the battery is below threshold
> 01/01/07 21:23:40: EVT#06280-01/01/07 21:23:40: 195=BBU disabled; 
> changing WB virtual disks to WT
> 01/01/07 21:26:40: EVT#06281-01/01/07 21:26:40: 153=Battery relearn 
> completed
> 01/01/07 21:26:40: Learn completed successfully
> 01/01/07 21:26:40: Next Learn will start on 04 01 2007
> 
> 01/01/07 21:26:40:       *** BATTERY FEATURE PROPERTIES ***
> 01/01/07 21:26:40:  _________________________________________________
> 
> 01/01/07 21:26:40:       Auto Learn Period     : 90  days
> 01/01/07 21:26:40:       Next Learn Time       : 228778000
> 01/01/07 21:26:40:       Battery ID            : 34ec019f
> 01/01/07 21:26:40:       Delayed Learn Interval: 0  hours from
scheduled
> time
> 01/01/07 21:26:40:       Next Learn cheduled on: 04 01 2007
> 01/01/07 21:26:40:  _________________________________________________
> 
> 01/01/07 21:26:55: EVT#06282-01/01/07 21:26:55: 147=Battery started 
> charging
> 01/01/07 21:26:55: EVT#06283-01/01/07 21:26:55: 162=Current capacity 
> of the battery is below threshold
> 01/01/07 21:49:40: EVT#06284-01/01/07 21:49:40: 163=Current capacity 
> of the battery is above threshold
> 01/01/07 21:49:40: EVT#06285-01/01/07 21:49:40: 194=BBU enabled; 
> changing WT virtual disks to WB
> 01/01/07 23:16:52: EVT#06286-01/01/07 23:16:52:  73=VD 00/0 Properties

> updated to [ID=00,dcp=0d,ccp=0c,ap=0,dc=0,dbgi=0] (from
> [ID=00,dcp=0c,ccp=0c,ap=0,dc=0,dbgi=0])
> 01/02/07  0:18:05: EVT#06287-01/02/07  0:18:05: 242=Battery charge 
> complete
> 01/02/07  0:33:50: Diag Retention test is running...all activities are

> stopped
> 01/02/07  4:41:08: TaskAdd: No more tasks available!!!
> [0]: fp=a00ffde4, lr=a0885aac  -  TaskAdd+7c
> [1]: fp=a00ffe00, lr=a086a3ac  -  PatrolReadTimer+fc
> [2]: fp=a00ffe40, lr=a0885f2c  -  TimerISR+a4
> [3]: fp=a00ffe60, lr=a088e428  -  FIQ_isr+48
> [4]: fp=a00ffe88, lr=a000a848  -  dbits+1787e34
> [5]: fp=a00ffe9c, lr=a000a24c  -  dbits+1787838
> [6]: fp=a00ffee4, lr=a0883440  -  kbhit+48
> [7]: fp=a00ffef8, lr=a0866e28  -  MonCheck+14
> [8]: fp=a00fff0c, lr=a0815930  -  diagRetentionCmdBlockDone+7c
> [9]: fp=a00fff34, lr=a084d630  -  CmdBlocked+1b4
> [10]: fp=a00fff60, lr=a0874c28  -  set_state+278
> [11]: fp=a00fff94, lr=a08748b0  -  raid_task+2f0
> [12]: fp=a00fffb8, lr=a088e0b0  -  main+3b0
> [13]: fp=a00fffe4, lr=a088c774  -  c_start+30
> [14]: fp=a00ffffc, lr=9e8804cc  -  _start+6c
> [15]: fp=a0018344, lr=a00061d0  -  dbits+17837bc
> [16]: fp=a00183fc, lr=4c0  -  000004c0
> MonTask: line 100 in file ../../raid/taskman.c 
> INTCTL=16c00000:1003dcf, IINTSRC=0:0, FINTSRC=0:0, CPSR=600000d3,
> sp=a00ffb28
> MegaMon>
> 
> T0: LSI Logic MegaRAID firmware loaded
> T0: Firmware version 1.00.02-0163 built on Nov 13 2006 at 18:32:21
> T0: Board is type 1028/0015/1028/1f03
> 
> T0: Initializing 1MB memory pool
> T0: LogInit: Flushing events from previous boot
> T0: EVT#06288-01/02/07  4:41:08:  15=Fatal firmware error: Line 100 in

> ../../raid/taskman.c
> 
> T0: EVT#06289-T0:   0=Firmware initialization started (PCI ID
> 0015/1028/1f03/1028)
> T0: EVT#06290-T0:   1=Firmware version 1.00.02-0163
> T0: EVT#06291-T0: 209=BBU Retention test was initiated on previous 
> boot
> T12: EVT#06292-T12: 210=BBU Retention test passed
> T12: EVT#06293-T12: 212=NVRAM Retention test was initiated on previous

> boot
> T12: EVT#06294-T12: 213=NVRAM Retention test passed
> T12: Authenticating RAID key: Done!
> 
> _______________________________________________
> Linux-PowerEdge mailing list
> Linux-PowerEdge@dell.com
> http://lists.us.dell.com/mailman/listinfo/linux-poweredge
> Please read the FAQ at http://lists.us.dell.com/faq
> 


