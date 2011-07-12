From: Jonathan McDowell <noodles@earth.li>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Tue, 12 Jul 2011 19:49:43 +0100
Message-ID: <20110712184943.GE6432@earth.li>
References: <20110704112727.GA2557@osiris.boeblingen.de.ibm.com>
 <Pine.LNX.4.44L0.1107041202170.12242-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107041202170.12242-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, axboe@kernel.dk, James Bottomley <James.Bottomley@HansenPartnership.com>, Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 04, 2011 at 12:04:54PM -0400, Alan Stern wrote:
> On Mon, 4 Jul 2011, Heiko Carstens wrote:
> 
> > On Sat, Jul 02, 2011 at 01:37:59PM -0400, Alan Stern wrote:
> > > The second bug, which hit me but apparently not any of you, is that the 
> > > request_queue's elevator gets deallocated while it is still in use.  
> > > That's because __scsi_remove_device() calls scsi_free_queue(), which 
> > > does blk_cleanup_queue(), which calls elevator_exit(), even though the 
> > > device file is still open and more requests will be submitted when the 
> > > file is closed.
> > > 
> > > I'm not sure of the right fix for this.  One possibility is to move the 
> > > scsi_free_queue() call to scsi_device_dev_release_usercontext().  Or 
> > > maybe the elevator_exit() call should be moved to blk_release_queue().
> > > 
> > > Also, I have no idea why this shows up with USB drives but not other 
> > > SCSI transports.  A fluke of timing?
> > 
> > FWIW, I reported a bug where the request_queue's elevator got deallocated
> > while it was still in use (fc transport with device hotplug):
> > 
> > http://www.spinics.net/lists/linux-scsi/msg52879.html
> 
> That does sound like the second bug I encountered.  Can you reproduce 
> it?  Does the patch here:
> 
> 	http://marc.info/?l=linux-kernel&m=130963676907731&w=2
> 
> fix the problem?

FWIW I'm seeing crashes when FC devices go away while in use as well,
under 2.6.39 and 3.0.0-rc6. I will try the patch linked to above, but
the most recent Oops was:

[71286.103409] end_request: I/O error, dev sdaw, sector 0
[71286.113710] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[71286.117681] IP: [<ffffffff81197828>] elv_completed_request+0x38/0x47
[71286.117681] PGD 2571c8067 PUD 253b81067 PMD 0 
[71286.117681] Oops: 0000 [#1] SMP 
[71286.117681] CPU 0 
[71286.117681] Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables autofs4 ipv6 kvm_intel kvm nfsd nfs lockd auth_rpcgss nfs_acl sunrpc dm_round_robin dm_multipath scsi_dh ipmi_devintf ipmi_si ipmi_msghandler sg evdev processor button thermal_sys serio_raw i5k_amb i2c_i801 ioatdma i2c_core dca rng_core tpm_tis tpm tpm_bios ext3 jbd dm_mod ses enclosure ata_generic ata_piix lpfc scsi_transport_fc scsi_tgt [last unloaded: scsi_wait_scan]
[71286.117681] 
[71286.117681] Pid: 0, comm: swapper Not tainted 3.0.0-rc6 #15 Intel S5000PAL./S5000PAL0 
[71286.117681] RIP: 0010:[<ffffffff81197828>]  [<ffffffff81197828>] elv_completed_request+0x38/0x47
[71286.117681] RSP: 0018:ffff88025fc03e10  EFLAGS: 00010002
[71286.117681] RAX: 0000000000000000 RBX: ffff880253cdc1c0 RCX: 00000000000003fe
[71286.117681] RDX: ffff880253155840 RSI: ffff880255e37c70 RDI: ffff880253cdc1c0
[71286.117681] RBP: ffff880255e37c70 R08: 00000001010ec65f R09: 0000000000000000
[71286.117681] R10: ffff880255e37c70 R11: ffffffff817e3e98 R12: 00000000fffffffb
[71286.117681] R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000000000
[71286.117681] FS:  0000000000000000(0000) GS:ffff88025fc00000(0000) knlGS:0000000000000000
[71286.117681] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[71286.117681] CR2: 0000000000000048 CR3: 0000000257144000 CR4: 00000000000006f0
[71286.117681] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[71286.117681] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[71286.117681] Process swapper (pid: 0, threadinfo ffffffff81600000, task ffffffff8165b020)
[71286.117681] Stack:
[71286.117681]  ffff880255e37c70 ffffffff8119c27e ffff880255e37c70 ffff880253cdc1c0
[71286.117681]  00000000fffffffb ffffffff8119d0c1 0000000000000000 ffff880255d733c0
[71286.117681]  ffff880255e37c70 0000000000000000 00000000fffffffb ffffffff8122dfbb
[71286.117681] Call Trace:
[71286.117681]  <IRQ> 
[71286.117681]  [<ffffffff8119c27e>] ? __blk_put_request+0x2e/0xb0
[71286.117681]  [<ffffffff8119d0c1>] ? blk_end_bidi_request+0x3b/0x55
[71286.117681]  [<ffffffff8122dfbb>] ? scsi_io_completion+0x431/0x48e
[71286.117681]  [<ffffffff811a110f>] ? blk_done_softirq+0x5f/0x6c
[71286.117681]  [<ffffffff8103bc7d>] ? __do_softirq+0xbe/0x194
[71286.117681]  [<ffffffff810569c6>] ? timekeeping_get_ns+0xd/0x2a
[71286.117681]  [<ffffffff8130dc0c>] ? call_softirq+0x1c/0x30
[71286.117681]  [<ffffffff81003fc5>] ? do_softirq+0x31/0x63
[71286.117681]  [<ffffffff8103ba69>] ? irq_exit+0x3f/0x9f
[71286.117681]  [<ffffffff8130d873>] ? call_function_single_interrupt+0x13/0x20
[71286.117681]  <EOI> 
[71286.117681]  [<ffffffffa012d0ca>] ? acpi_idle_enter_simple+0xb4/0xe2 [processor]
[71286.117681]  [<ffffffffa012d0c5>] ? acpi_idle_enter_simple+0xaf/0xe2 [processor]
[71286.117681]  [<ffffffff81277aba>] ? cpuidle_idle_call+0xe4/0x162
[71286.117681]  [<ffffffff81001da4>] ? cpu_idle+0xa5/0xdb
[71286.117681]  [<ffffffff816c1ba8>] ? start_kernel+0x38e/0x399
[71286.117681]  [<ffffffff816c138f>] ? x86_64_start_kernel+0xee/0xf2
[71286.117681] Code: 40 74 35 83 7e 44 01 74 04 a8 40 74 2b 83 e0 11 ff c8 0f 95 c0 83 e0 01 48 05 fc 00 00 00 ff 4c 87 04 f6 46 41 04 74 10 48 8b 02 
[71286.117681]  8b 40 48 48 85 c0 74 04 41 58 ff e0 59 c3 48 83 ec 08 48 8d 
[71286.117681] RIP  [<ffffffff81197828>] elv_completed_request+0x38/0x47
[71286.117681]  RSP <ffff88025fc03e10>
[71286.117681] CR2: 0000000000000048
[71286.117681] ---[ end trace 242b012d98a46112 ]---
[71286.117681] Kernel panic - not syncing: Fatal exception in interrupt

J.

-- 
Listen to the words, they tell you what to do...
