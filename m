From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: SCSI oops on USB disconnect, was: Issues with xHCI and USB 3.0
Date: Fri, 4 Nov 2011 07:48:40 -0700
Message-ID: <20111104144840.GA3079@xanatos>
References: <4EA54EBF.80905@iinet.net.au>
 <20111025072957.GA5821@xanatos>
 <4EA68418.9000504@iinet.net.au>
 <20111025113458.GA4590@xanatos>
 <4EA6B3FC.9010808@iinet.net.au>
 <20111027112831.GB4790@xanatos>
 <20111102190224.GB29845@xanatos>
 <4EB24040.1060208@iinet.net.au>
 <20111103202258.GA3585@xanatos>
 <4EB32928.6000901@iinet.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EB32928.6000901-AFFH1GffN5hPR4JQBCEnsQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt <mdm-AFFH1GffN5hPR4JQBCEnsQ@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 04, 2011 at 10:52:08AM +1100, Matt wrote:
> Hi Sarah,
> 
> On 4/11/2011 7:22 AM, Sarah Sharp wrote:
> >Can you try applying the attached patch and post the full dmesg?
> 
> No good, I'm afraid.  Dmesg uploaded here:
> http://pastebin.com/raw.php?i=vQCA0P3E
> 
> The only change I noticed was that parted hung irrecoverably when I
> attempted to access one of the disks to create a partition.  It
> normally pauses then complains that the disk is unavailable.
> 
> Thanks again for your ongoing help.

Actually, there was success, at least for the command I was trying to
fix:

[  294.617975] xhci_hcd 0000:03:00.0: Slot ID 1 Input Context:
[  294.617977] xhci_hcd 0000:03:00.0: @ffff880135d4b000 (virt) @ffffc000 (dma) 0x000000 - drop flags
[  294.617979] xhci_hcd 0000:03:00.0: @ffff880135d4b004 (virt) @ffffc004 (dma) 0x000003 - add flags
...
[  294.618062] xhci_hcd 0000:03:00.0: // Ding dong!
[  294.621423] xhci_hcd 0000:03:00.0: Successful Address Device command

That means the patch I sent you worked, so I'll send it off to Greg with
your Tested-by line, if you don't mind.

At this point, it's not an xHCI driver problem.  Instead your device
disconnects on its own, and you get this lovely oops message from the
scsi layer:

[  323.957501] hub 4-0:1.0: port 1, status 02c0, change 0041, 5.0 Gb/s
[  323.957504] usb 4-1: USB disconnect, device number 2
[  323.957506] usb 4-1: unregistering device
[  323.957508] usb 4-1: unregistering interface 4-1:1.0
...
[  325.484029] paging request at 0000001d00008000
[  325.484058] IP: [<0000001d00008000>] 0x1d00007fff
[  325.484090] PGD 0 
[  325.484108] Oops: 0010 [#1] SMP 
[  325.484136] CPU 1 
[  325.484147] Modules linked in: usb_storage uas sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables i2c_i801 pcspkr r8169 iTCO_wdt iTCO_vendor_support mii ipv6 i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[  325.484366] 
[  325.484380] Pid: 1901, comm: scsi_eh_5 Not tainted 3.1.0-rc4 #4 Shuttle Inc. SH61R4/FH61
[  325.484430] RIP: 0010:[<0000001d00008000>]  [<0000001d00008000>] 0x1d00007fff
[  325.484473] RSP: 0018:ffff880135871c18  EFLAGS: 00010006
[  325.484504] RAX: 0000001d00008000 RBX: ffff88013516ea10 RCX: 000000000000c43f
[  325.484544] RDX: 0000000000000000 RSI: ffff88013516ea10 RDI: ffff880136f88000
[  325.484583] RBP: ffff880135871c40 R08: 0000000000000002 R09: 0000ffff00066c0a
[  325.484622] R10: 0000ffff00066c0a R11: 0000000000000000 R12: ffff880136f88000
[  325.484660] R13: ffff880136f88000 R14: ffff880136f89548 R15: 0000000000000246
[  325.485824] FS:  0000000000000000(0000) GS:ffff88013fa80000(0000) knlGS:0000000000000000
[  325.487017] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  325.488200] CR2: 0000001d00008000 CR3: 0000000001a05000 CR4: 00000000000406e0
[  325.489404] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  325.490595] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  325.491763] Process scsi_eh_5 (pid: 1901, threadinfo ffff880135870000, task ffff88013334ae40)
[  325.492951] Stack:
[  325.494125]  ffffffff8122c4eb 0000000000000000 0000000000000000 ffff880137261048
[  325.495348]  ffff880136f88000 ffff880135871ca0 ffffffff813148e3 ffff880137260138
[  325.496574]  0000000000000282 ffff880135871c90 ffffffff811163d4 ffff880137260148
[  325.497799] Call Trace:
[  325.499007]  [<ffffffff8122c4eb>] ? blk_peek_request+0x3f/0x1d2
[  325.500236]  [<ffffffff813148e3>] scsi_request_fn+0x48/0x409
[  325.501461]  [<ffffffff811163d4>] ? kmem_cache_free+0x72/0xab
[  325.502685]  [<ffffffff81227338>] __blk_run_queue+0x1b/0x1d
[  325.503906]  [<ffffffff8131428a>] scsi_run_queue+0x1c0/0x22d
[  325.505126]  [<ffffffff813153d4>] scsi_next_command+0x39/0x49
[  325.506337]  [<ffffffff81315895>] scsi_io_completion+0x45d/0x4d7
[  325.507552]  [<ffffffff8130dc14>] scsi_finish_command+0xe4/0xed
[  325.508761]  [<ffffffff81312a3e>] scsi_eh_flush_done_q+0xfc/0x124
[  325.509971]  [<ffffffff8131310e>] scsi_error_handler+0x383/0x591
[  325.511175]  [<ffffffff81312d8b>] ? scsi_eh_get_sense+0x183/0x183
[  325.512380]  [<ffffffff81072a17>] kthread+0x84/0x8c
[  325.513580]  [<ffffffff814b01f4>] kernel_thread_helper+0x4/0x10
[  325.514782]  [<ffffffff81072993>] ? kthread_worker_fn+0x148/0x148
[  325.515984]  [<ffffffff814b01f0>] ? gs_change+0x13/0x13
[  325.517185] Code:  Bad RIP value.
[  325.518381] RIP  [<0000001d00008000>] 0x1d00007fff
[  325.519587]  RSP <ffff880135871c18>
[  325.520778] CR2: 0000001d00008000
[  325.521955] ---[ end trace 1bb950452c001516 ]---

Hopefully the SCSI folks will be able to help you with that.  James?

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
