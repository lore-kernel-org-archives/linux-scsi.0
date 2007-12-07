From: Bernd Schubert <bs@q-leap.de>
Subject: Re: everything in wait_for_completion, what is my system doing?
Date: Fri, 7 Dec 2007 14:09:33 +0100
Message-ID: <200712071409.33490.bs@q-leap.de>
References: <200712052144.54399.bs@q-leap.de> <20071206170911.4060cd1c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:41177 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbXLGNJf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 08:09:35 -0500
In-Reply-To: <20071206170911.4060cd1c.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hello Andrew,

thanks for your help!

On Friday 07 December 2007 02:09:11 Andrew Morton wrote:
> On Wed, 5 Dec 2007 21:44:54 +0100
>
> Bernd Schubert <bs@q-leap.de> wrote:
> > after scsi-recovery a system here went into some kind lock-up, everything
> > seems to be in wait_for_completion(). Please see the attached
> > blocked_states.txt and all_states.txt files.
> > This is 2.6.22.12, I can easily find out the line numbers if required.
> >
> > Any help is highly appreciated.
>
> Please cc linux-scsi on scsi-related reports.

Sorry, I these traces confused me a bit. I had absolutely no idea about a 
possible reason.

>
> > [blocked_states.txt  text/plain (20.5KB)]
> > [generate break]
> > [ 1818.566436] SysRq : Show Blocked State
> > [ 1818.570260]
> > [ 1818.570261]                                  free                     
> >   sibling [ 1818.579253]   task                 PC        stack   pid
> > father child younger older [ 1818.586987] events/7      D
> > 00000155dd642280     0    26      2 (L-TLB) [ 1818.593747] 
> > ffff81012b529ac0 0000000000000046 0000000000000000 ffff810128280d18 [
> > 1818.601321]  ffff8100ba2376f8 ffff81012b689630 ffff81012aff76b0
> > 000000078023e215 [ 1818.608870]  000000010003ca14 0000000000000000
> > ffff810001065400 0000000780430c13 [ 1818.616222] Call Trace:
> > [ 1818.618925]  [<ffffffff804ececb>] io_schedule+0x28/0x36
> > [ 1818.624207]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
> > [ 1818.630112]  [<ffffffff8036e5a1>] blk_get_request+0x36/0x6b
> > [ 1818.635755]  [<ffffffff8042f5cb>] scsi_execute+0x51/0x129
> > [ 1818.641240]  [<ffffffff880cc11b>]
> > :scsi_transport_spi:spi_execute+0x87/0xf8 [ 1818.648271] 
> > [<ffffffff880cd5ae>]
> > :scsi_transport_spi:spi_dv_device_echo_buffer+0x181/0x27d [ 1818.656739] 
> > [<ffffffff880cd801>] :scsi_transport_spi:spi_dv_retrain+0x4e/0x240 [
> > 1818.664139]  [<ffffffff880ce008>]
> > :scsi_transport_spi:spi_dv_device+0x615/0x69c [ 1818.671542] 
> > [<ffffffff880f16d1>] :mptspi:mptspi_dv_device+0xb3/0x14b [ 1818.678042] 
> > [<ffffffff880f27d3>] :mptspi:mptspi_dv_renegotiate_work+0xcb/0xef [
> > 1818.685348]  [<ffffffff80245bb8>] run_workqueue+0x8e/0x120
> > [ 1818.690905]  [<ffffffff80245d50>] worker_thread+0x106/0x117
> > [ 1818.696540]  [<ffffffff80249672>] kthread+0x4b/0x82
> > [ 1818.701474]  [<ffffffff8020ab28>] child_rip+0xa/0x12
> > [ 1818.706495]
> > [ 1818.708022] unionfs-fuse- D 000001a76ef63463     0  1119      1
> > (NOTLB) [ 1818.714764]  ffff810129765988 0000000000000082
> > 0000000000000000 ffffffff80337e22 [ 1818.722329]  ffff8101297658c8
> > ffff81012b652f20 ffff810129eec810 0000000600000000 [ 1818.729895] 
> > 000000010005204e 0000000000000000 ffff81000105c400 0000000680337c3e [
> > 1818.737249] Call Trace:
> > [ 1818.739953]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
> > [ 1818.745673]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
> > [ 1818.751664]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
> > [ 1818.757300]  [<ffffffff80269b24>]
> > balance_dirty_pages_ratelimited_nr+0x196/0x22f [ 1818.764781] 
> > [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d [
> > 1818.771641]  [<ffffffff80266210>]
> > __generic_file_aio_write_nolock+0x45a/0x491 [ 1818.778852] 
> > [<ffffffff802662a8>] generic_file_aio_write+0x61/0xc1 [ 1818.785101] 
> > [<ffffffff8032eb94>] nfs_file_write+0x138/0x1b7
> > [ 1818.790822]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
> > [ 1818.796372]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
> > [ 1818.801575]  [<ffffffff8028d5df>] sys_pwrite64+0x68/0x96
> > [ 1818.806959]  [<ffffffff80209d0e>] system_call+0x7e/0x83
> > [ 1818.812250]  [<00002b4eeec3ea73>]
> >
> > [snippage]
>
> Possibly your device driver had conniptions and stopped generating
> completion interrupts.
>
> Which driver is in use?

This is this time easily visible from the traces (mptspi_dv_device) ;) So its 
the mpt driver, we are using LSI22320 cards (I CC'ed Eric).

>
> I don't suppose it is repeatable.

Thats a clear "yes and no". Exactly this state we have got two or three times 
during an exhausting hardware stress test over the last weeks (with real and 
with simulated errors), but its not easily reproducible. Furthermore,  the 
hardware will go into production soon and I don't have the chance to simulate 
further errors.
However, we can easily get a similar state just on a raid6-rebuild (with high 
end hardware though. 
(You probably never won't run into into it with normal disks, we are doing 
software-raid over a bunch of several hardware raid systems).  

In the raid6-rebuild case the system is not completely locked up, just mostly. 
Somehow raid6-rebuild is still working, we can see this by the io usage 
status of the hardware-raids, but the system is completely blocked otherwise. 
Only pings and sysrq's are working.


Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
