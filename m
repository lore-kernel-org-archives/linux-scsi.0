From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx: Recursion depth exceeded
Date: Fri, 20 Jan 2006 13:08:57 -0800
Message-ID: <20060120210857.GH3159@andrew-vasquezs-powerbook-g4-15.local>
References: <43CFC55D.9080206@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:36115 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S932189AbWATVJE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 16:09:04 -0500
Content-Disposition: inline
In-Reply-To: <43CFC55D.9080206@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 19 Jan 2006, Michael Reed wrote:

> This causes console input to stop being accepted and the inability to shutdown the system.
> 
> 
>  QLogic Fibre Channel HBA Driver: 8.01.04-k-fw
> from the sles10-latest kernel received yesterday, which is essentially
> 2.6.15-git12.  This has rpfixes_2.diff already applied.

Yes, I've yet to submit that variant...

> I did a switchdisable followed by a switchenable 5 seconds later.
> 
> Jan 19 10:35:16 duck klogd: qla2300 0012:00:02.1: LOOP DOWN detected (2).
> Jan 19 10:35:16 duck klogd: qla2300 0012:00:02.0: LOOP DOWN detected (2).
> Jan 19 10:35:16 duck klogd: qla2300 0012:00:01.1: LOOP DOWN detected (2).
> Jan 19 10:35:16 duck klogd: qla2300 0012:00:01.0: LOOP DOWN detected (2).
> Jan 19 10:35:16 duck klogd: qla2300 0002:01:06.0: LOOP DOWN detected (2).
> Jan 19 10:35:16 duck klogd: qla2300 0002:01:04.1: LOOP DOWN detected (2).
> Jan 19 10:35:16 duck klogd: qla2300 0002:01:06.1: LOOP DOWN detected (2).
> Jan 19 10:35:16 duck klogd: qla2300 0002:01:04.0: LOOP DOWN detected (2).
> 
> Well, okay, SIX seconds later . :)
> 
> Jan 19 10:35:43 duck klogd: qla2300 0012:00:01.1: LOOP UP detected (2 Gbps).
> Jan 19 10:35:45 duck klogd: run_workqueue: recursion depth exceeded: 4
> Jan 19 10:35:45 duck klogd:
> Jan 19 10:35:45 duck klogd: Call Trace:
> Jan 19 10:35:45 duck klogd:  [<a000000100012b00>] show_stack+0x40/0xa0
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35f9e0 bsp=e00000b07a3593b0
> Jan 19 10:35:45 duck klogd:  [<a000000100012b90>] dump_stack+0x30/0x60
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fbb0 bsp=e00000b07a359398
> Jan 19 10:35:45 duck klogd:  [<a0000001000c9d90>] run_workqueue+0x90/0x280
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fbb0 bsp=e00000b07a359358
> Jan 19 10:35:45 duck klogd:  [<a0000001000c9fd0>] flush_cpu_workqueue+0x50/0x1e0
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fbb0 bsp=e00000b07a359328
> Jan 19 10:35:45 duck klogd:  [<a0000001000ca220>] flush_workqueue+0xc0/0x160
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a359300
> Jan 19 10:35:45 duck klogd:  [<a0000001000ca3e0>] flush_scheduled_work+0x20/0x40
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a3592e8
> Jan 19 10:35:45 duck klogd:  [<a000000100554570>] fc_rport_tgt_remove+0xf0/0x140
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a3592b8
> Jan 19 10:35:45 duck klogd:  [<a000000100554820>] fc_rport_terminate+0xa0/0x180
> Jan 19 10:35:45 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a359280
> Jan 19 10:35:49 duck klogd:  [<a000000100554950>] fc_remote_port_delete+0x50/0xe0
> Jan 19 10:35:49 duck klogd:                                 sp=e00000b07a35fc10 bsp=e00000b07a359258
> Jan 19 10:35:49 duck klogd: run_workqueue: recursion depth exceeded: 4

As this pinging of the workqueue during removal has some real awful
side-effects.  I have a series of patches which attempt to work around
the semantic requirements.

I'll post them ASAP, in the interim, Mike could you grab the following
mbox patchset (apply with git-am):

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.01.04k/pr600.diff

Thanks,
Andrew

