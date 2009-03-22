From: jan sonnek <ha2nny@gmail.com>
Subject: Re: Regression - locking (all from 2.6.28)
Date: Sun, 22 Mar 2009 05:45:05 +0100
Message-ID: <49C5C251.50903@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030008090006040105080009"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:57418 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZCUVow (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Mar 2009 17:44:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org

This is a multi-part message in MIME format.
--------------030008090006040105080009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have tried applied some patch (view down) to -mm kernel
(last mmotm 26.29-rc8-mm1), but It was not
successfull. When I have disabled Acceleration
(Option "NoAccel" "true"), I was able to start X system,
but in my dmesg is still error messages (attachement)


Bug page:
http://bugzilla.kernel.org/show_bug.cgi?id=12619

 > On Mon, 2009-03-02 at 12:11 -0800, Andrew Morton wrote:
 > > > Mar  1 00:06:51 localhost kernel: [   74.008165] unreferenced 
object 0xf6c4daf0 (size 52):
 > > > Mar  1 00:06:51 localhost kernel: [   74.008170]   comm 
"swapper", pid 1, jiffies 4294893427
 > > > Mar  1 00:06:51 localhost kernel: [   74.008175]   backtrace:
 > > > Mar  1 00:06:51 localhost kernel: [   74.008179]     [<c018978c>] 
kmemleak_alloc+0x17e/0x28e
 > > > Mar  1 00:06:51 localhost kernel: [   74.008185]     [<c0186b86>] 
kmem_cache_alloc+0xdc/0xe7
 > > > Mar  1 00:06:51 localhost kernel: [   74.008190]     [<c01a53bd>] 
alloc_buffer_head+0x16/0x71
 > > > Mar  1 00:06:51 localhost kernel: [   74.008196]     [<c01a5b91>] 
alloc_page_buffers+0x23/0xad
 > > > Mar  1 00:06:51 localhost kernel: [   74.008200]     [<c01a5fd4>] 
__getblk+0x192/0x26b
 > > > Mar  1 00:06:51 localhost kernel: [   74.008205]     [<c01d91f4>] 
jread+0x105/0x1de
 > > > Mar  1 00:06:51 localhost kernel: [   74.008209]     [<c01d932b>] 
do_one_pass+0x5e/0x38c
 > > > Mar  1 00:06:51 localhost kernel: [   74.008213]     [<c01d96f8>] 
journal_recover+0x41/0x9d
 > > > Mar  1 00:06:51 localhost kernel: [   74.008218]     [<c01db8d4>] 
journal_load+0x47/0x7b
 > > > Mar  1 00:06:51 localhost kernel: [   74.008221]     [<c01d43d1>] 
ext3_fill_super+0xe9d/0x144c
 > > > Mar  1 00:06:51 localhost kernel: [   74.008225]     [<c018d721>] 
get_sb_bdev+0xfa/0x140
 > > > Mar  1 00:06:51 localhost kernel: [   74.008231]     [<c01d2070>] 
ext3_get_sb+0x18/0x1a
 > > > Mar  1 00:06:51 localhost kernel: [   74.008235]     [<c018c71f>] 
vfs_kern_mount+0x41/0x7c
 > > > Mar  1 00:06:51 localhost kernel: [   74.008241]     [<c018c7a8>] 
do_kern_mount+0x37/0xbe
 > > > Mar  1 00:06:51 localhost kernel: [   74.008247]     [<c019f0bf>] 
do_mount+0x5f7/0x630
 > > > Mar  1 00:06:51 localhost kernel: [   74.008253]     [<c019f167>] 
sys_mount+0x6f/0xac
 > > I suspect kmemleak has gone nuts here.
 >
 > It seems that the buffer_head structure allocated above is stored in
 > page->private. However, the page structures are no longer scanned in
 > newer versions of kmemleak. That's the hunk that was removed after
 > comments about the contiguity of a node's memory:
 >
 > +     /* mem_map scanning */
 > +     for_each_online_node(i) {
 > +             struct page *page, *end;
 > +
 > +             page = NODE_MEM_MAP(i);
 > +             end  = page + NODE_DATA(i)->node_spanned_pages;
 > +
 > +             scan_block(page, end, NULL);
 > +     }
 >
 > The alternative is to inform kmemleak about the page structures returned
 > from __alloc_pages_internal() but there would be problems with recursive
 > calls into kmemleak when it allocates its own data structures.
 >
 > I'll look at re-adding the hunk above, maybe with some extra checks like
 > pfn_valid().

Looking again at this, the node_mem_map is always contiguous and the
code above only scans the node_mem_map, not the memory represented by
the node (which may not be contiguous). So I think it is a valid code
sequence.

If the above gets too deep into the nodes structure, an alternative
would be:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 09b6fd7..0f17e62 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3552,6 +3552,11 @@ static void __init_refok 
alloc_node_mem_map(struct pglist_data *pgdat)
  		map = alloc_remap(pgdat->node_id, size);
  		if (!map)
  			map = alloc_bootmem_node(pgdat, size);
+		/*
+		 * Inform kmemleak to scan the node_mem_map arrays as the page
+		 * structure may contain pointers to other objects.
+		 */
+		kmemleak_alloc(map, size, 1, GFP_ATOMIC);
  		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
  	}
  #ifndef CONFIG_NEED_MULTIPLE_NODES
-- 


Many thanks,
Jan Sonnek



--------------030008090006040105080009
Content-Type: text/plain;
 name="dmesg-noaccel"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-noaccel"

[ 1724.965479] =========================================================
[ 1724.965491] [ INFO: possible irq lock inversion dependency detected ]
[ 1724.965501] 2.6.29-rc8-mm1-hanny #23
[ 1724.965507] ---------------------------------------------------------
[ 1724.965516] swapper/0 just changed the state of lock:
[ 1724.965523]  (fasync_lock){.-....}, at: [<c019867b>] kill_fasync+0x20/0x3a
[ 1724.965545] but this lock took another, HARDIRQ-unsafe lock in the past:
[ 1724.965552]  (&f->f_lock){+.+...}
[ 1724.965560] 
[ 1724.965562] and interrupts could create inverse lock ordering between them.
[ 1724.965568] 
[ 1724.965574] 
[ 1724.965576] other info that might help us debug this:
[ 1724.965584] 3 locks held by swapper/0:
[ 1724.965590]  #0:  (&dev->event_lock){-.-...}, at: [<c02da4cf>] input_event+0x35/0x6a
[ 1724.965610]  #1:  (rcu_read_lock){.+.+..}, at: [<c02d9136>] __rcu_read_lock+0x0/0x30
[ 1724.965631]  #2:  (rcu_read_lock){.+.+..}, at: [<c02dcd6e>] evdev_event+0x0/0xe2
[ 1724.965649] 
[ 1724.965651] the first lock's dependencies:
[ 1724.965657] -> (fasync_lock){.-....} ops: 253 {
[ 1724.965672]    IN-HARDIRQ-R at:
[ 1724.965681]                                        [<c0147a3a>] __lock_acquire+0x204/0xb4a
[ 1724.965696]                                        [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.965709]                                        [<c039df42>] _read_lock+0x2d/0x5d
[ 1724.965722]                                        [<c019867b>] kill_fasync+0x20/0x3a
[ 1724.965733]                                        [<c02dcaeb>] evdev_pass_event+0x60/0x66
[ 1724.965745]                                        [<c02dcde1>] evdev_event+0x73/0xe2
[ 1724.965758]                                        [<c02d91fc>] input_pass_event+0x5c/0x7f
[ 1724.965771]                                        [<c02da419>] input_handle_event+0x366/0x36f
[ 1724.965784]                                        [<c02da4ee>] input_event+0x54/0x6a
[ 1724.965796]                                        [<c02f6a5f>] hidinput_hid_event+0x24c/0x279
[ 1724.965811]                                        [<c02f3e49>] hid_process_event+0x8d/0xbc
[ 1724.965824]                                        [<c02f41b4>] hid_report_raw_event+0x33c/0x348
[ 1724.965838]                                        [<c02f426b>] hid_input_report+0xab/0xbc
[ 1724.965851]                                        [<c02fa52c>] hid_irq_in+0x86/0x182
[ 1724.965864]                                        [<c02b3e96>] usb_hcd_giveback_urb+0x68/0x9c
[ 1724.965878]                                        [<c02d3247>] uhci_giveback_urb+0xf6/0x1f1
[ 1724.965891]                                        [<c02d3a3c>] uhci_scan_schedule+0x5f8/0x85f
[ 1724.965903]                                        [<c02d571f>] uhci_irq+0x12b/0x13f
[ 1724.965916]                                        [<c02b3a68>] usb_hcd_irq+0x32/0x81
[ 1724.965928]                                        [<c0157218>] handle_IRQ_event+0xa4/0x121
[ 1724.965942]                                        [<c015843d>] handle_fasteoi_irq+0x77/0xb0
[ 1724.965955]                                        [<ffffffff>] 0xffffffff
[ 1724.965967]    INITIAL USE at:
[ 1724.965974]                                       [<c0147b7a>] __lock_acquire+0x344/0xb4a
[ 1724.965986]                                       [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.965998]                                       [<c039dcdd>] _write_lock_irq+0x33/0x63
[ 1724.966010]                                       [<c01982b6>] fasync_helper+0x44/0xe4
[ 1724.966022]                                       [<c024b0ea>] tty_fasync+0x50/0xea
[ 1724.966037]                                       [<c024d1ca>] tty_release_dev+0x57/0x409
[ 1724.966049]                                       [<c024d593>] tty_release+0x17/0x21
[ 1724.966062]                                       [<c018f5e1>] __fput+0xcf/0x158
[ 1724.966074]                                       [<c018f688>] fput+0x1e/0x20
[ 1724.966085]                                       [<c018cd8a>] filp_close+0x56/0x60
[ 1724.966098]                                       [<c018ce03>] sys_close+0x6f/0xa9
[ 1724.966110]                                       [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.966124]                                       [<ffffffff>] 0xffffffff
[ 1724.966133]  }
[ 1724.966138]  ... key      at: [<c04f9324>] fasync_lock+0x10/0x24
[ 1724.966152]  -> (&f->f_lock){+.+...} ops: 427 {
[ 1724.966166]     HARDIRQ-ON-W at:
[ 1724.966174]                                          [<c0147af8>] __lock_acquire+0x2c2/0xb4a
[ 1724.966188]                                          [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.966200]                                          [<c039da1c>] _spin_lock+0x2d/0x5d
[ 1724.966213]                                          [<c01989de>] do_fcntl+0x222/0x2bc
[ 1724.966225]                                          [<c0198ad2>] sys_fcntl64+0x5a/0x6e
[ 1724.966238]                                          [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.966250]                                          [<ffffffff>] 0xffffffff
[ 1724.966261]     SOFTIRQ-ON-W at:
[ 1724.966269]                                          [<c0147b1b>] __lock_acquire+0x2e5/0xb4a
[ 1724.966281]                                          [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.966293]                                          [<c039da1c>] _spin_lock+0x2d/0x5d
[ 1724.966305]                                          [<c01989de>] do_fcntl+0x222/0x2bc
[ 1724.966318]                                          [<c0198ad2>] sys_fcntl64+0x5a/0x6e
[ 1724.966329]                                          [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.966340]                                          [<ffffffff>] 0xffffffff
[ 1724.966351]     INITIAL USE at:
[ 1724.966358]                                         [<c0147b7a>] __lock_acquire+0x344/0xb4a
[ 1724.966371]                                         [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.966383]                                         [<c039da1c>] _spin_lock+0x2d/0x5d
[ 1724.966395]                                         [<c0198326>] fasync_helper+0xb4/0xe4
[ 1724.966407]                                         [<c024b0ea>] tty_fasync+0x50/0xea
[ 1724.966419]                                         [<c024d1ca>] tty_release_dev+0x57/0x409
[ 1724.966431]                                         [<c024d593>] tty_release+0x17/0x21
[ 1724.966444]                                         [<c018f5e1>] __fput+0xcf/0x158
[ 1724.966455]                                         [<c018f688>] fput+0x1e/0x20
[ 1724.966466]                                         [<c018cd8a>] filp_close+0x56/0x60
[ 1724.966480]                                         [<c018ce03>] sys_close+0x6f/0xa9
[ 1724.966492]                                         [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.966505]                                         [<ffffffff>] 0xffffffff
[ 1724.966515]   }
[ 1724.966519]   ... key      at: [<c0b7f750>] __key.20487+0x0/0x8
[ 1724.966531]  ... acquired at:
[ 1724.966536]    [<c01481fd>] __lock_acquire+0x9c7/0xb4a
[ 1724.966547]    [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.966557]    [<c039da1c>] _spin_lock+0x2d/0x5d
[ 1724.966566]    [<c0198326>] fasync_helper+0xb4/0xe4
[ 1724.966575]    [<c024b0ea>] tty_fasync+0x50/0xea
[ 1724.966585]    [<c024d1ca>] tty_release_dev+0x57/0x409
[ 1724.966595]    [<c024d593>] tty_release+0x17/0x21
[ 1724.966605]    [<c018f5e1>] __fput+0xcf/0x158
[ 1724.966614]    [<c018f688>] fput+0x1e/0x20
[ 1724.966622]    [<c018cd8a>] filp_close+0x56/0x60
[ 1724.966633]    [<c018ce03>] sys_close+0x6f/0xa9
[ 1724.966643]    [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.966653]    [<ffffffff>] 0xffffffff
[ 1724.966662] 
[ 1724.966666] 
[ 1724.966668] the second lock's dependencies:
[ 1724.966675] -> (&f->f_lock){+.+...} ops: 427 {
[ 1724.966689]    HARDIRQ-ON-W at:
[ 1724.966696]                                        [<c0147af8>] __lock_acquire+0x2c2/0xb4a
[ 1724.966710]                                        [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.966722]                                        [<c039da1c>] _spin_lock+0x2d/0x5d
[ 1724.966734]                                        [<c01989de>] do_fcntl+0x222/0x2bc
[ 1724.966746]                                        [<c0198ad2>] sys_fcntl64+0x5a/0x6e
[ 1724.966758]                                        [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.966770]                                        [<ffffffff>] 0xffffffff
[ 1724.966781]    SOFTIRQ-ON-W at:
[ 1724.966788]                                        [<c0147b1b>] __lock_acquire+0x2e5/0xb4a
[ 1724.966801]                                        [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.966814]                                        [<c039da1c>] _spin_lock+0x2d/0x5d
[ 1724.966825]                                        [<c01989de>] do_fcntl+0x222/0x2bc
[ 1724.966836]                                        [<c0198ad2>] sys_fcntl64+0x5a/0x6e
[ 1724.966847]                                        [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.966860]                                        [<ffffffff>] 0xffffffff
[ 1724.966870]    INITIAL USE at:
[ 1724.966877]                                       [<c0147b7a>] __lock_acquire+0x344/0xb4a
[ 1724.966890]                                       [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.966903]                                       [<c039da1c>] _spin_lock+0x2d/0x5d
[ 1724.966914]                                       [<c0198326>] fasync_helper+0xb4/0xe4
[ 1724.966926]                                       [<c024b0ea>] tty_fasync+0x50/0xea
[ 1724.966939]                                       [<c024d1ca>] tty_release_dev+0x57/0x409
[ 1724.966951]                                       [<c024d593>] tty_release+0x17/0x21
[ 1724.966963]                                       [<c018f5e1>] __fput+0xcf/0x158
[ 1724.966975]                                       [<c018f688>] fput+0x1e/0x20
[ 1724.966987]                                       [<c018cd8a>] filp_close+0x56/0x60
[ 1724.966999]                                       [<c018ce03>] sys_close+0x6f/0xa9
[ 1724.967011]                                       [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1724.967024]                                       [<ffffffff>] 0xffffffff
[ 1724.967034]  }
[ 1724.967038]  ... key      at: [<c0b7f750>] __key.20487+0x0/0x8
[ 1724.967049] 
[ 1724.967051] stack backtrace:
[ 1724.967059] Pid: 0, comm: swapper Not tainted 2.6.29-rc8-mm1-hanny #23
[ 1724.967066] Call Trace:
[ 1724.967077]  [<c039b4d5>] ? printk+0x14/0x17
[ 1724.967087]  [<c01472f0>] print_irq_inversion_bug+0xea/0xf7
[ 1724.967098]  [<c0147333>] check_usage_forwards+0x36/0x3f
[ 1724.967107]  [<c0146cbb>] mark_lock+0x110/0x1f4
[ 1724.967117]  [<c01472fd>] ? check_usage_forwards+0x0/0x3f
[ 1724.967128]  [<c0147a3a>] __lock_acquire+0x204/0xb4a
[ 1724.967140]  [<c0148437>] lock_acquire+0xb7/0xd4
[ 1724.967150]  [<c019867b>] ? kill_fasync+0x20/0x3a
[ 1724.967160]  [<c039df42>] _read_lock+0x2d/0x5d
[ 1724.967170]  [<c019867b>] ? kill_fasync+0x20/0x3a
[ 1724.967179]  [<c019867b>] kill_fasync+0x20/0x3a
[ 1724.967189]  [<c02dcaeb>] evdev_pass_event+0x60/0x66
[ 1724.967198]  [<c02dcde1>] evdev_event+0x73/0xe2
[ 1724.967210]  [<c02d91fc>] input_pass_event+0x5c/0x7f
[ 1724.967220]  [<c02da419>] input_handle_event+0x366/0x36f
[ 1724.967232]  [<c024ad54>] ? add_timer_randomness+0xee/0x108
[ 1724.967243]  [<c02da4ee>] input_event+0x54/0x6a
[ 1724.967254]  [<c02f6a5f>] hidinput_hid_event+0x24c/0x279
[ 1724.967265]  [<c02f3e49>] hid_process_event+0x8d/0xbc
[ 1724.967276]  [<c02f41b4>] hid_report_raw_event+0x33c/0x348
[ 1724.967289]  [<c02f426b>] hid_input_report+0xab/0xbc
[ 1724.967299]  [<c02fa52c>] hid_irq_in+0x86/0x182
[ 1724.967309]  [<c02b59a2>] ? usb_unanchor_urb+0xb/0x85
[ 1724.967320]  [<c02b3e96>] usb_hcd_giveback_urb+0x68/0x9c
[ 1724.967331]  [<c02d3247>] uhci_giveback_urb+0xf6/0x1f1
[ 1724.967340]  [<c039d867>] ? _spin_unlock_irqrestore+0x58/0x65
[ 1724.967352]  [<c02d3a3c>] uhci_scan_schedule+0x5f8/0x85f
[ 1724.967363]  [<c0145d3a>] ? put_lock_stats+0x1e/0x29
[ 1724.967374]  [<c02d571f>] uhci_irq+0x12b/0x13f
[ 1724.967384]  [<c02b3a68>] usb_hcd_irq+0x32/0x81
[ 1724.967395]  [<c0157218>] handle_IRQ_event+0xa4/0x121
[ 1724.967406]  [<c015843d>] handle_fasteoi_irq+0x77/0xb0
[ 1724.967416]  [<c01583c6>] ? handle_fasteoi_irq+0x0/0xb0
[ 1724.967423]  <IRQ>  [<c039e32a>] ? do_IRQ+0x4a/0x8c
[ 1724.967440]  [<c010316e>] ? common_interrupt+0x2e/0x34
[ 1724.967452]  [<c014007b>] ? timekeeping_suspend+0x61/0x70
[ 1724.967465]  [<c023e552>] ? acpi_idle_enter_simple+0x13a/0x165
[ 1724.967477]  [<c02f184e>] ? cpuidle_idle_call+0x6a/0x9c
[ 1724.967487]  [<c0101d9b>] ? cpu_idle+0x7f/0xb4
[ 1724.967498]  [<c0398e34>] ? start_secondary+0x20e/0x24e
[ 1921.835352] unreferenced object 0xf2fa1100 (size 64):
[ 1921.835359]   comm "dbus-daemon", pid 2852, jiffies 364589
[ 1921.835363]   backtrace:
[ 1921.835372]     [<c018ca01>] kmemleak_alloc+0x17e/0x291
[ 1921.835377]     [<c0189872>] __kmalloc+0x10f/0x11a
[ 1921.835382]     [<c0199e94>] do_sys_poll+0xb8/0x3bf
[ 1921.835386]     [<c019a2ea>] sys_poll+0x45/0x8f
[ 1921.835391]     [<c0102b07>] sysenter_do_call+0x12/0x35
[ 1921.835396]     [<ffffffff>] 0xffffffff


--------------030008090006040105080009--
