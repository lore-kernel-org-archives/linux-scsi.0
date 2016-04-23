From: Johannes Stezenbach <js@sig21.net>
Subject: uas: order 7 page allocation failure in init_tag_map()
Date: Sat, 23 Apr 2016 23:10:49 +0200
Message-ID: <20160423211049.GA7105@sig21.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:43732 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbcDWVKy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2016 17:10:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

I bought a new backup disk which turned out to be UAS capable,
but when I plugged it in I got an order 7 page allocation failure.
My hunch is that the .can_queue = 65536 in drivers/usb/storage/uas.c
is much too large.  Maybe 256 would be a pratical value that matches
the capabilities of existing hardware?


[1859683.261465] usb 4-2: new SuperSpeed USB device number 8 using xhci_hcd
[1859683.281986] scsi host18: uas
[1859683.282003] kworker/0:2: page allocation failure: order:7, mode:0x208c020
[1859683.282008] CPU: 0 PID: 6888 Comm: kworker/0:2 Not tainted 4.4.6 #1
[1859683.282011] Hardware name: System manufacturer System Product Name/P8H77-V, BIOS 1905 10/27/2014
[1859683.282017] Workqueue: usb_hub_wq hub_event
[1859683.282021]  0000000000000286 00000000d38f5999 ffff8800751674d0 ffffffff813527de
[1859683.282026]  0000000000000000 000000000208c020 ffff880075167570 ffffffff81157c56
[1859683.282031]  ffff880075167580 ffff880075167508 ffffffff81f43840 ffffffff00f438b8
[1859683.282036] Call Trace:
[1859683.282045]  [<ffffffff813527de>] dump_stack+0x85/0xbe
[1859683.282050]  [<ffffffff81157c56>] warn_alloc_failed+0x12c/0x156
[1859683.282055]  [<ffffffff8115a6bb>] __alloc_pages_nodemask+0x73a/0x8f1
[1859683.282060]  [<ffffffff8151332b>] ? dev_vprintk_emit+0x1cb/0x1f1
[1859683.282065]  [<ffffffff8115aa58>] alloc_kmem_pages+0x22/0x8a
[1859683.282069]  [<ffffffff81172a71>] kmalloc_order+0x18/0x46
[1859683.282072]  [<ffffffff81172ac0>] kmalloc_order_trace+0x21/0xe9
[1859683.282077]  [<ffffffff811911d8>] __kmalloc+0x38/0x22f
[1859683.282081]  [<ffffffff81334319>] ? __blk_queue_init_tags+0x2f/0x73
[1859683.282085]  [<ffffffff8133429b>] init_tag_map+0x54/0xa3
[1859683.282088]  [<ffffffff8133432f>] __blk_queue_init_tags+0x45/0x73
[1859683.282092]  [<ffffffff81334371>] blk_init_tags+0x14/0x16
[1859683.282096]  [<ffffffff8153a032>] scsi_add_host_with_dma+0xc8/0x2a0
[1859683.282102]  [<ffffffffc002d1d3>] uas_probe+0x3aa/0x420 [uas]
[1859683.282107]  [<ffffffff81596b3b>] usb_probe_interface+0x1a6/0x22d
[1859683.282112]  [<ffffffff8151733a>] driver_probe_device+0x173/0x3a6
[1859683.282116]  [<ffffffff81517692>] __device_attach_driver+0x71/0x78
[1859683.282120]  [<ffffffff81517621>] ? driver_allows_async_probing+0x31/0x31
[1859683.282124]  [<ffffffff8151568b>] bus_for_each_drv+0x8a/0xad
[1859683.282128]  [<ffffffff815170dc>] __device_attach+0xba/0x14f
[1859683.282132]  [<ffffffff815177f2>] device_initial_probe+0x13/0x15
[1859683.282136]  [<ffffffff815165e2>] bus_probe_device+0x33/0x9e
[1859683.282140]  [<ffffffff815145a4>] device_add+0x2e4/0x56e
[1859683.282144]  [<ffffffff81595103>] usb_set_configuration+0x689/0x6d9
[1859683.282148]  [<ffffffff8136911e>] ? debug_smp_processor_id+0x17/0x19
[1859683.282152]  [<ffffffff8159ddf9>] generic_probe+0x43/0x73
[1859683.282156]  [<ffffffff81596982>] usb_probe_device+0x53/0x66
[1859683.282159]  [<ffffffff8151733a>] driver_probe_device+0x173/0x3a6
[1859683.282163]  [<ffffffff81517692>] __device_attach_driver+0x71/0x78
[1859683.282167]  [<ffffffff81517621>] ? driver_allows_async_probing+0x31/0x31
[1859683.282171]  [<ffffffff8151568b>] bus_for_each_drv+0x8a/0xad
[1859683.282175]  [<ffffffff815170dc>] __device_attach+0xba/0x14f
[1859683.282179]  [<ffffffff815177f2>] device_initial_probe+0x13/0x15
[1859683.282183]  [<ffffffff815165e2>] bus_probe_device+0x33/0x9e
[1859683.282186]  [<ffffffff815145a4>] device_add+0x2e4/0x56e
[1859683.282191]  [<ffffffff8158c229>] usb_new_device+0x241/0x38a
[1859683.282194]  [<ffffffff8158dbec>] hub_event+0xcb9/0x10f2
[1859683.282201]  [<ffffffff8109706e>] process_one_work+0x27f/0x4d7
[1859683.282206]  [<ffffffff810c1141>] ? put_lock_stats.isra.9+0xe/0x20
[1859683.282209]  [<ffffffff81097de4>] worker_thread+0x273/0x35b
[1859683.282214]  [<ffffffff81097b71>] ? rescuer_thread+0x2a7/0x2a7
[1859683.282217]  [<ffffffff8109c56b>] kthread+0xff/0x107
[1859683.282222]  [<ffffffff8109c46c>] ? kthread_create_on_node+0x1ea/0x1ea
[1859683.282228]  [<ffffffff8181b05f>] ret_from_fork+0x3f/0x70
[1859683.282231]  [<ffffffff8109c46c>] ? kthread_create_on_node+0x1ea/0x1ea
[1859683.282234] Mem-Info:
[1859683.282241] active_anon:21278 inactive_anon:69854 isolated_anon:0
                  active_file:212300 inactive_file:194346 isolated_file:0
                  unevictable:2018 dirty:87 writeback:0 unstable:0
                  slab_reclaimable:127644 slab_unreclaimable:12137
                  mapped:11526 shmem:13394 pagetables:5007 bounce:0
                  free:270678 free_pcp:1027 free_cma:0
[1859683.282252] DMA free:14412kB min:32kB low:40kB high:48kB active_anon:180kB inactive_anon:468kB active_file:268kB inactive_file:92kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15900kB mlocked:0kB dirty:4kB writeback:0kB mapped:172kB shmem:328kB slab_reclaimable:208kB slab_unreclaimable:92kB kernel_stack:0kB pagetables:56kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1859683.282255] lowmem_reserve[]: 0 3162 3597 3597
[1859683.282267] DMA32 free:904468kB min:6728kB low:8408kB high:10092kB active_anon:66188kB inactive_anon:237164kB active_file:803244kB inactive_file:704168kB unevictable:7024kB isolated(anon):0kB isolated(file):0kB present:3334492kB managed:3243208kB mlocked:7024kB dirty:280kB writeback:0kB mapped:37116kB shmem:40212kB slab_reclaimable:435236kB slab_unreclaimable:37848kB kernel_stack:3968kB pagetables:16696kB unstable:0kB bounce:0kB free_pcp:2008kB local_pcp:632kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[1859683.282270] lowmem_reserve[]: 0 0 435 435
[1859683.282281] Normal free:163832kB min:924kB low:1152kB high:1384kB active_anon:18744kB inactive_anon:41784kB active_file:45688kB inactive_file:73124kB unevictable:1048kB isolated(anon):0kB isolated(file):0kB present:522240kB managed:446092kB mlocked:1048kB dirty:64kB writeback:0kB mapped:8816kB shmem:13036kB slab_reclaimable:75132kB slab_unreclaimable:10608kB kernel_stack:1024kB pagetables:3276kB unstable:0kB bounce:0kB free_pcp:2100kB local_pcp:716kB free_cma:0kB writeback_tmp:0kB pages_scanned:124 all_unreclaimable? no
[1859683.282283] lowmem_reserve[]: 0 0 0 0
[1859683.282289] DMA: 13*4kB (UE) 7*8kB (UME) 14*16kB (UME) 4*32kB (UM) 4*64kB (UM) 1*128kB (E) 1*256kB (E) 0*512kB 3*1024kB (UME) 3*2048kB (UME) 1*4096kB (M) = 14412kB
[1859683.282314] DMA32: 20814*4kB (UME) 34763*8kB (UME) 13965*16kB (UME) 8010*32kB (UME) 949*64kB (UME) 18*128kB (UME) 1*256kB (E) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 904416kB
[1859683.282333] Normal: 15141*4kB (UME) 8667*8kB (UME) 1734*16kB (UME) 189*32kB (UME) 2*64kB (ME) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 163820kB
[1859683.282352] 424877 total pagecache pages
[1859683.282354] 4013 pages in swap cache
[1859683.282357] Swap cache stats: add 12705467, delete 12701454, find 5264270/6800842
[1859683.282359] Free swap  = 978068kB
[1859683.282360] Total swap = 2097148kB
[1859683.282362] 968179 pages RAM
[1859683.282364] 0 pages HighMem/MovableOnly
[1859683.282366] 41879 pages reserved
[1859683.283779] uas: probe of 4-2:1.0 failed with error -12


Johannes
