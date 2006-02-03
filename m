From: john stultz <johnstul@us.ibm.com>
Subject: Re: Fw: [Bugme-new] [Bug 5998] New: oops on mount "kernel access
	of bad area, sig: 11 [#1]"
Date: Fri, 03 Feb 2006 11:00:49 -0800
Message-ID: <1138993250.10057.125.camel@cog.beaverton.ibm.com>
References: <20060202150719.0dafc8ae.akpm@osdl.org>
	 <43E306AC.60004@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35998 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1945895AbWBCTAx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 14:00:53 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k13J0qfZ007248
	for <linux-scsi@vger.kernel.org>; Fri, 3 Feb 2006 14:00:52 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k13IwscY214288
	for <linux-scsi@vger.kernel.org>; Fri, 3 Feb 2006 11:58:54 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k13J0pn6001271
	for <linux-scsi@vger.kernel.org>; Fri, 3 Feb 2006 12:00:52 -0700
In-Reply-To: <43E306AC.60004@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@osdl.org>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Fri, 2006-02-03 at 08:30 +0100, Stefan Richter wrote:
> > ieee1394: sbp2: aborting sbp2 command
> > sd 0:0:0:0: 
> >         command: cdb[0]=0x28: 28 00 09 27 c0 03 00 00 02 00
> > ieee1394: sbp2: aborting sbp2 command
> > sd 0:0:0:0: 
> >         command: cdb[0]=0x0: 00 00 00 00 00 00
> > Oops: kernel access of bad area, sig: 11 [#1]
> > PREEMPT 
> > NIP: C0023FF8 LR: C0023FF8 SP: EFC0FEB0 REGS: efc0fe00 TRAP: 0300    Not tainted
> > MSR: 00001032 EE: 0 PR: 0 FP: 0 ME: 1 IR/DR: 11
> > DAR: 00000000, DSISR: 40000000
> > TASK = c134b230[317] 'scsi_eh_0' THREAD: efc0e000
> > Last syscall: -1 
> > GPR00: 00000000 EFC0FEB0 C134B230 00000001 C05BDE28 FFFFFFFF C0650000 C0664E84 
> > GPR08: 00040000 00000001 C13DF400 EFC0E000 C0650000 00000000 00000000 00000000 
> > GPR16: 00000000 C02EF5A0 C06070EC C0586F7C C06070EC C0586F7C C06070EC C0650000 
> > GPR24: 00000003 C13EE204 C13EE268 00000001 00009032 00000000 C13EE1C0 C02EF440 
> > NIP [c0023ff8] complete+0x28/0x90
> > LR [c0023ff8] complete+0x28/0x90
> > Call trace:
> >  [c02ef45c] scsi_eh_done+0x1c/0x30
> >  [c03248b8] sbp2scsi_abort+0x158/0x170
> >  [c02efbcc] scsi_send_eh_cmnd+0x10c/0x1a0
> >  [c02efce8] scsi_eh_tur+0x88/0xe0
> >  [c02f0930] scsi_error_handler+0x450/0xa10
> >  [c00437e8] kthread+0x108/0x110
> >  [c0007534] kernel_thread+0x44/0x60
> > note: scsi_eh_0[317] exited with preempt_count 1
> > 
> > 
> > Steps to reproduce: Not easily reproduced.
> 
> It looks actually different from what I described above. Perhaps 
> scsi_eh_done was called on a command which was already completed shortly 
> before. sbp2scsi_abort calls the "done" handler for the command to be 
> aborted and for all other pending commands (for the latter to be 
> enqueued again). Sbp2 also calls the done handler right after a SBP-2 
> reconnect in sbp2_update, i.e. after the FireWire bus was reset. Perhaps 
> one or the other or both places in sbp2 need to take the Scsi_Host's 
> host_lock.
> 
> John, do you have the syslog still available from when the oops 
> occurred? Was there a reconnect logged?

I don't believe so. When I got home and unplugged the disk, all I got
was:

ieee1394: Node changed: 0-01:1023 -> 0-00:1023
ieee1394: Node suspended: ID:BUS[0-00:1023]  GUID[0001a35000048584]

However the /dev/ nodes were still present, so I rebooted the box,
instead of confusing udev by trying to plug it back in.

Let me know if there's anything else you need.

thanks
-john

