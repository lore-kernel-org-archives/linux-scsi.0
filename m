From: Gal Rosen <galr@storwize.com>
Subject: Re: [PATCH] qla2xxx: Fix dpc_thread race on the module unload
Date: Tue, 29 Jul 2008 10:30:30 +0300
Message-ID: <1217316630.4133.100.camel@galr-linux>
References: <488E02DE.5080100@vlnb.net>
	 <1217267776.3503.112.camel@localhost.localdomain> <488E0C78.80205@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.storwize.com ([62.90.10.208]:4277 "EHLO swdc2.storwiz.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752658AbYG2Haf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2008 03:30:35 -0400
In-Reply-To: <488E0C78.80205@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

Hi All,

I used qla initiator driver based on 2.6.23-8 which was modified to
support target mode and virtual port on AL topology.
The issue does not related to the target. As I wrote in other thread it
happens also when in one shell insmod'ing the driver and in other shell
rmmod'ing it.
My Oops is pointing as Andrew stated to the
qla24xx_report_id_acquisition() routine, because after loading the
driver I created vport, then rmmod'ing the driver without deleting the
vport. In that case interrupt comes to report about the deletion of the
vport, and request the dpc thread. So for sure we need to call
qla2xxx_wake_dpc() routine instead of calling wake_up_process() routine,
where we don't check the dpc_thread pointer.
I am not sure this is enough but I can test it, because as I wrote again
in other thread, and Vlad quote here, if someone request wake up of the
dpc thread, check that it is not NULL, call to wake_up_process()
routine, and exactly at this point other task got the CPU, set the
pointer to NULL and stop the dpc thread, then we have a problem.

Below is the Oops with Vlad fix revision 470 in SCST with the addition
of the lock but without the change in qla_mbx.c.  

[67324.049497] [4525]: scst: exit_scst:1652:SCST unloaded
[67324.765692] qla2xxx 0000:06:00.1: LIP reset occured (f8ef).
[67325.295690] qla2xxx 0000:06:00.1: LIP occured (f8ef).
[67325.315689] qla2xxx 0000:06:00.1: LOOP UP detected (4 Gbps).
[67325.415700] Unable to handle kernel NULL pointer dereference at
0000000000000008 RIP: 
[67325.416599] [<ffffffff80226b1e>] task_rq_lock+0x2e/0x90
[67325.418171] PGD 22d737067 PUD 22df2d067 PMD 0 
[67325.419114] Oops: 0000 [1] SMP 
[67325.419736] CPU 0 
[67325.420162] Modules linked in: qla2xxx loop scsi_transport_fc
[67325.421333] Pid: 4382, comm: qla2xxx_12_dpc Tainted: GF
2.6.23.8-64bit-fc-nfs #10
[67325.422998] RIP: 0010:[<ffffffff80226b1e>] [<ffffffff80226b1e>]
task_rq_lock+0x2e/0x90
[67325.424736] RSP: 0018:ffff81022e14bb00 EFLAGS: 00010086
[67325.425870] RAX: 0000000000000086 RBX: 000000000000000f RCX:
0000000000000000
[67325.427379] RDX: 0000000000000000 RSI: ffff81022e14bb80 RDI:
0000000000000000
[67325.428899] RBP: ffff81022e14bb20 R08: 0000000000000000 R09:
ffff81022d160010
[67325.430406] R10: 0000000000000000 R11: ffffffff8050faf0 R12:
ffffffff807a4000
[67325.431925] R13: 0000000000000000 R14: ffff81022e14bb80 R15:
0000000000000246
[67325.433433] FS: 0000000000000000(0000) GS:ffffffff8071d000(0000)
knlGS:0000000000000000
[67325.435147] CS: 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[67325.436371] CR2: 0000000000000008 CR3: 000000022dec0000 CR4:
00000000000006e0
[67325.437890] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[67325.439398] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[67325.440921] Process qla2xxx_12_dpc (pid: 4382, threadinfo
ffff81022e14a000, task ffff81022c6040c0)
[67325.442813] Stack: 000000000000000f ffff81022d160000
0000000000000000 ffffc20000038000
[67325.444551] ffff81022e14bbb0 ffffffff80226ddf ffff81022e14bbd0
0000000000000046
[67325.446143] 0000000000000000 ffff810008abc918 000000002c6042e0
ffff81022c6040c0
[67325.447697] Call Trace:
[67325.448252] [<ffffffff80226ddf>] try_to_wake_up+0x2f/0x370
[67325.449485] [<ffffffff80237854>] lock_timer_base+0x34/0x70
[67325.450736]
[<ffffffff8805a9cb>] :qla2xxx:qla24xx_process_response_queue+0x18b/0x1f0
[67325.452442] [<ffffffff8805bdd8>] :qla2xxx:qla24xx_intr_handler
+0x158/0x200
[67325.453976] [<ffffffff80237710>] process_timeout+0x0/0x10
[67325.455196] [<ffffffff88054b0b>] :qla2xxx:qla2x00_mailbox_command
+0x1db/0x5d0
[67325.456787] [<ffffffff80597980>] thread_return+0x0/0x5c0
[67325.457978] [<ffffffff80237854>] lock_timer_base+0x34/0x70
[67325.459214] [<ffffffff88056a17>] :qla2xxx:qla2x00_get_adapter_id
+0x87/0x130
[67325.460765] [<ffffffff80237710>] process_timeout+0x0/0x10
[67325.461983] [<ffffffff8804fa9f>] :qla2xxx:qla2x00_configure_loop
+0x33f/0x17a0
[67325.463573] [<ffffffff80237854>] lock_timer_base+0x34/0x70
[67325.464807] [<ffffffff880568ea>] :qla2xxx:qla2x00_get_retry_cnt
+0x5a/0x100
[67325.466333] [<ffffffff8805882c>] :qla2xxx:__qla2x00_marker
+0xec/0x110
[67325.467781] [<ffffffff880588b0>] :qla2xxx:qla2x00_marker+0x60/0x90
[67325.469157] [<ffffffff88051b3e>] :qla2xxx:qla2x00_abort_isp
+0x24e/0x610
[67325.470638] [<ffffffff8804c290>] :qla2xxx:qla2x00_do_dpc+0x430/0x560
[67325.472052] [<ffffffff8804be60>] :qla2xxx:qla2x00_do_dpc+0x0/0x560
[67325.473431] [<ffffffff8804be60>] :qla2xxx:qla2x00_do_dpc+0x0/0x560
[67325.474820] [<ffffffff80242e8b>] kthread+0x4b/0x80
[67325.475902] [<ffffffff8020c608>] child_rip+0xa/0x12
[67325.477005] [<ffffffff80242e40>] kthread+0x0/0x80
[67325.478069] [<ffffffff8020c5fe>] child_rip+0x0/0x12
[67325.479171] 
[67325.479486] 
[67325.479486] Code: 49 8b 45 08 4c 89 e3 8b 40 18 48 8b 04 c5 40 8c 74
80 48 03 
[67325.481393] RIP [<ffffffff80226b1e>] task_rq_lock+0x2e/0x90
[67325.482617] RSP <ffff81022e14bb00>
[67325.483356] CR2: 0000000000000008

Message from syslogd@HP1b at Tue Jul 22 02:25:48 2008 ...

Message from syslogd@HP1b at Tue Jul 22 02:25:48 2008 ...
HP1b kernel: [67325.419114] Oops: 0000 [1] SMP 
HP1b kernel: [67325.483356] CR2: 0000000000000008

Gal.

On Mon, 2008-07-28 at 22:14 +0400, Vladislav Bolkhovitin wrote:
> James Bottomley wrote:
> > On Mon, 2008-07-28 at 21:33 +0400, Vladislav Bolkhovitin wrote:
> >> This patch fixes race on dpc_thread field of struct scsi_qla_host,
> >> which can lead to crash on the module unload.
> >>
> >> This patch is against 2.6.26
> > 
> > I'm afraid adding a lock is almost certainly the wrong way to handle
> > this type of failure. 
> 
> Why? It's simple and fully solves the problem. All the events, which 
> left unhandled, because there is nobody to wake up by 
> qla2xxx_wake_dpc(), are not relevant after the driver's shutdown.
> 
> > What should be done is to make sure the qla is
> > correctly shut down (i.e. no tasks requiring the dpc_thread can be
> > performed) *before* killing the thread ...
> 
> Sure, in ideal it would be the best approach. But, certainly, it would 
> be a lot more complicated and error-prone.
> 
>  From other side, actually, it doesn't matter much for me how it will be 
> fixed, if it's fixed.
> 
> > it sounds like shutdown is
> > slightly broken in the current driver ... could you post the oops
> > details and we can try to work out what the problem is
> 
> Gal, can you send the details, please?
> 
> > James
> > 
> > 
> > 
> 
