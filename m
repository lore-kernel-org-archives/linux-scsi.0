From: Wouter Depuydt <wouter.depuydt@gmail.com>
Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Mon, 24 Aug 2015 09:43:55 +0000 (UTC)
Message-ID: <loom.20150824T113849-717@post.gmane.org>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net> <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net> <20150518152034.GC5404@twins.programming.kicks-ass.net> <20150518160345.GA18673@twins.programming.kicks-ass.net> <20150518161146.GB18673@twins.programming.kicks-ass.net> <555F46F4.2090002@redhat.com> <20150522164002.GJ3644@twins.programming.kicks-ass.net> <2C438B34CAC8264398F5C7AF7411910A6347343E@G9W0731.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbbHXJpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Aug 2015 05:45:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1ZToJL-0007sY-N9
	for linux-scsi@vger.kernel.org; Mon, 24 Aug 2015 11:45:03 +0200
Received: from kulnet-nat-2.kulnet.kuleuven.be ([134.58.253.57])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2015 11:45:03 +0200
Received: from wouter.depuydt by kulnet-nat-2.kulnet.kuleuven.be with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2015 11:45:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz <at> infradead.org] 
> Sent: Friday, May 22, 2015 11:40 AM
> To: Tomas Henzl
> Cc: Oelke, Mark; don.brace <at> pmcs.com; ISS StorageDev; storagedev <at>
pmcs.com; linux-scsi <at> vger.kernel.org
> Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
> 
> On Fri, May 22, 2015 at 05:10:44PM +0200, Tomas Henzl wrote:
> > >> I've updated to 6.62 and it appears to be working now; or rather, it has
> 
> I've since gotten 6.64 from HP to test; which does not seem public yet.
> 
> 6.64 actually fixes the issue for me.
> 

Hi everone,

I've experienced a similar problem with a P411 controller in HBA mode.
Serial Number	PDNMH0ARH8P04A
Model	HP Smart Array P441 Controller
Firmware Version	2.52

This seems to be the latest firmware:
http://h20564.www2.hpe.com/hpsc/swd/public/detail?sp4ts.oid=7274903&swItemId=MTX_a476e21cd5e142608ff8d6aed5&swEnvOid=4176

I'm running smartd for monitoring, dayly short tests and weekly long tests.

Aug 23 13:57:11 smartd[3344]: Device: /dev/sdv [SAT], SMART Usage Attribute:
194 Temperature_Celsius changed from 41 to 42
Aug 23 13:57:42 kernel: [349157.766608] hpsa 0000:05:00.0: Abort request on
C6:B2:T18:L0
Aug 23 13:57:42 kernel: [349157.830545] hpsa 0000:05:00.0: Abort request on
C6:B2:T19:L0
Aug 23 14:00:10 kernel: [349305.554986]  [<ffffffffc02a3d20>]
hpsa_send_abort+0xa0/0x250 [hpsa]
Aug 23 14:00:10 kernel: [349305.555000]  [<ffffffffc02a7ff3>]
hpsa_eh_abort_handler+0x683/0x1290 [hpsa]
Aug 23 14:00:10 kernel: [349305.575005]  [<ffffffffc02a3d20>]
hpsa_send_abort+0xa0/0x250 [hpsa]
Aug 23 14:00:10 kernel: [349305.575019]  [<ffffffffc02a7ff3>]
hpsa_eh_abort_handler+0x683/0x1290 [hpsa]
Aug 23 14:02:10 kernel: [349425.572350]  [<ffffffffc02a3d20>]
hpsa_send_abort+0xa0/0x250 [hpsa]
Aug 23 14:02:10 kernel: [349425.572364]  [<ffffffffc02a7ff3>]
hpsa_eh_abort_handler+0x683/0x1290 [hpsa]
Aug 23 14:02:10 kernel: [349425.682988]  [<ffffffffc02a3d20>]
hpsa_send_abort+0xa0/0x250 [hpsa]
Aug 23 14:02:10 kernel: [349425.683001]  [<ffffffffc02a7ff3>]
hpsa_eh_abort_handler+0x683/0x1290 [hpsa]
Aug 23 14:03:10 kernel: [349457.674593] hpsa 0000:05:00.0: Controller lockup
detected: 0x00130001
Aug 23 14:03:38 kernel: [349485.657605] Workqueue: events
hpsa_monitor_ctlr_worker [hpsa]
Aug 23 14:03:38 kernel: [349485.657736]  <<EOE>>  [<ffffffffc02a5384>]
fail_all_cmds_on_list+0x74/0x6c0 [hpsa]
Aug 23 14:03:38 kernel: [349485.657765]  [<ffffffffc02aa9bb>]
hpsa_monitor_ctlr_worker+0x40b/0x4e0 [hpsa]
Aug 23 14:03:43 kernel: [349518.024245] Workqueue: events
hpsa_monitor_ctlr_worker [hpsa]
Aug 23 14:04:10 kernel: [349545.689592]  [<ffffffffc02a3d20>]
hpsa_send_abort+0xa0/0x250 [hpsa]
Aug 23 14:04:10 kernel: [349545.689605]  [<ffffffffc02a7ff3>]
hpsa_eh_abort_handler+0x683/0x1290 [hpsa]
Aug 23 14:04:10 kernel: [349545.805674]  [<ffffffffc02a3d20>]
hpsa_send_abort+0xa0/0x250 [hpsa]
Aug 23 14:04:10 kernel: [349545.805693]  [<ffffffffc02a7ff3>]
hpsa_eh_abort_handler+0x683/0x1290 [hpsa]
Aug 23 14:06:11 kernel: [349665.810469]  [<ffffffffc02a3d20>]
hpsa_send_abort+0xa0/0x250 [hpsa]
Aug 23 14:06:11 kernel: [349665.810483]  [<ffffffffc02a7ff3>]
hpsa_eh_abort_handler+0x683/0x1290 [hpsa]

W.


