From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Concurrent SG_SCSI_RESET ioctls
Date: Sat, 11 Oct 2014 23:04:17 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CEB29F@G4W3202.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
 <20141011161110.GA16812@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:25388 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaJKXGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Oct 2014 19:06:49 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>



> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Saturday, 11 October, 2014 11:11 AM
...
> >
> > Hi Robert,
> >
> > can you take a look at the patches at:
> >
> > http://git.infradead.org/users/hch/scsi.git/shortlog/refs/heads/scsi-ioctl
> >
> > and confirm if they fix your issue?
> 
> Thanks.  That's a bit better, but sg_reset can now run into
> "No such device" errors.
> 
> sg_reset: starting device reset
> sg_reset: starting device reset
> sg_reset: SG_SCSI_RESET failed: No such device
> sg_reset: completed device (or target or bus or host) reset
> sg_reset: starting device reset
> sg_reset: completed device (or target or bus or host) reset
> sg_reset: starting device reset
> sg_reset: completed device (or target or bus or host) reset
> 

Running fio concurrently with all the sg_resets, it also led to
a hang with:
* all the fio threads sitting in blk_mq_get_tag, reported
  as blocked tasks after 120 seconds
* all the sg_resets from pass 23 hung 

Starting with sg_reset pass 22, where 6 of 14 got
"No such device", here is the serial log (with a few
extra prints added in the scsi midlayer):

[ 2750.165637] ------------------ loop-sg_reset pass 22:
[ 2750.175055] sd_ioctl continuing cmd=0x2284
[ 2750.175469] sd_ioctl continuing cmd=0x2284
[ 2750.175470] sd_ioctl default cmd=0x2284
[ 2750.175474] calling scsi_try_bus_device_reset
[ 2750.175476] hpsa_eh_device_reset_handler called with ffff8804097297c0
[ 2750.175482] hpsa 0000:04:00.0: resetting scsi 2:0:0:0: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En- Exp=3
[ 2750.181328] hpsa 0000:04:00.0: resetting scsi 2:0:0:0 completed successfully
[ 2750.181330] scsi host2: waking up host to restart after TMF
[ 2750.181377] sd_ioctl continuing cmd=0x2284
[ 2750.181377] sd_ioctl default cmd=0x2284
[ 2750.181379] sd_ioctl continuing cmd=0x2284
[ 2750.181381] sd_ioctl continuing cmd=0x2284
[ 2750.181382] sd_ioctl default cmd=0x2284
[ 2750.181382] calling scsi_try_bus_device_reset
[ 2750.181383] sd_ioctl default cmd=0x2284
[ 2750.181384] hpsa_eh_device_reset_handler called with ffff8803f55de500
[ 2750.181388] hpsa 0000:04:00.0: resetting scsi 2:0:0:12: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En- Exp=3
[ 2750.181427] hpsa 0000:04:00.0: resetting scsi 2:0:0:12 completed successfully
[ 2750.181428] scsi host2: waking up host to restart after TMF
[ 2750.181443] calling scsi_try_bus_device_reset
[ 2750.181444] calling scsi_try_bus_device_reset
[ 2750.181446] hpsa_eh_device_reset_handler called with ffff8803f966ae00
[ 2750.181447] hpsa_eh_device_reset_handler called with ffff88042d558cc0
[ 2750.181451] hpsa 0000:04:00.0: resetting scsi 2:0:0:8: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En+ Exp=3
[ 2750.181454] hpsa 0000:04:00.0: resetting scsi 2:0:0:9: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En- Exp=3
[ 2750.181562] hpsa 0000:04:00.0: resetting scsi 2:0:0:8 completed successfully
[ 2750.181564] scsi host2: waking up host to restart after TMF
[ 2750.181570] hpsa 0000:04:00.0: resetting scsi 2:0:0:9 completed successfully
[ 2750.181572] scsi host2: waking up host to restart after TMF
[ 2750.181] sd_ioctl continuing cmd=0x2285
[ 2750.181840] sd_ioctl default cmd=0x2285
[ 2750.181842] sd_ioctl continuing cmd=0x2285
[ 2750.181842] sd_ioctl default cmd=0x2285
[ 2750.181982] sd_ioctl continuing cmd=0x2285
[ 2750.181982] sd_ioctl default cmd=0x2285
[ 2750.181987] sd_ioctl continuing cmd=0x2285
[ 2750.181988] sd_ioctl default cmd=0x2285
[ 2750.181990] sd_ioctl continuing cmd=0x2285
[ 2750.181990] sd_ioctl default cmd=0x2285
[ 2750.182075] sd_ioctl continuing cmd=0x2285
[ 2750.182076] sd_ioctl default cmd=0x2285
[ 2750.182148] sd_ioctl continuing cmd=0x2285
[ 2750.182148] sd_ioctl default cmd=0x2285
[ 2750.182210] sd_ioctl continuing cmd=0x2285
[ 2750.182211] sd_ioctl default cmd=0x2285
[ 2750.182362] sd_ioctl continuing cmd=0x2285
[ 2750.182362] sd_ioctl default cmd=0x2285
[ 2750.182498] sd_ioctl continuing cmd=0x2285
[ 2750.182499] sd_ioctl default cmd=0x2285
[ 2750.185274] sd_ioctl continuing cmd=0x5331
[ 2750.185275] sd_ioctl default cmd=0x5331
[ 2750.185277] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.185612] sd_ioctl continuing cmd=0x2285
[ 2750.185613] sd_ioctl default cmd=0x2285
[ 2750.185614] sd_ioctl continuing cmd=0x2285
[ 2750.185615] sd_ioctl default cmd=0x2285
[ 2750.185888] sd_ioctl continuing cmd=0x2284
[ 2750.185889] sd_ioctl default cmd=0x2284
[ 2750.185892] calling scsi_try_bus_device_reset
[ 2750.185894] hpsa_eh_device_reset_handler called with ffff8804097297c0
[ 2750.185900] hpsa 0000:04:00.0: resetting scsi 2:0:0:5: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En+ Exp=3
[ 2750.191332] hpsa 0000:04:00.0: resetting scsi 2:0:0:5 completed successfully
[ 2750.191334] scsi host2: waking up host to restart after TMF
[ 2750.191357] sd_ioctl continuing cmd=0x2285
[ 2750.191358] sd_ioctl continuing cmd=0x2285
[ 2750.191360] sd_ioctl continuing cmd=0x2285
[ 2750.191361] sd_ioctl default cmd=0x2285
[ 2750.191361] sd_ioctl default cmd=0x2285
[ 2750.191362] sd_ioctl default cmd=0x2285
 2750.191363] sd_ioctl continuing cmd=0x22855
[ 2750.191364] sd_ioctl default cmd=0x2285
[ 2750.191364] sd_ioctl continuing cmd=0x2285
[ 2750.191365] sd_ioctl default cmd=0x2285
[ 2750.191366] sd_ioctl default cmd=0x2285
[ 2750.191368] sd_ioctl continuing cmd=0x2285
[ 2750.191368] sd_ioctl default cmd=0x2285
[ 2750.191369] sd_ioctl continuing cmd=0x2285
[ 2750.191370] sd_ioctl default cmd=0x2285
[ 2750.191375] sd_ioctl continuing cmd=0x5331
[ 2750.191376] sd_ioctl default cmd=0x5331
[ 2750.191377] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.191390] sd_ioctl continuing cmd=0x2284
[ 2750.191391] sd_ioctl default cmd=0x2284
[ 2750.191394] calling scsi_try_bus_device_reset
[ 2750.191395] hpsa_eh_device_reset_handler called with ffff88042d558cc0
[ 2750.191399] hpsa 0000:04:00.0: resetting scsi 2:0:0:6: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En+ Exp=3
[ 2750.191454] hpsa 0000:04:00.0: resetting scsi 2:0:0:6 completed successfully
[ 2750.191455] scsi host2: waking up host to restart after TMF
[ 2750.192487] sd_ioctl continuing cmd=0x2285
[ 2750.192488] sd_ioctl default cmd=0x2285
[ 2750.192648] sd_ioctl continuing cmd=0x2285
[ 2750.192648] sd_ioctl default cmd=0x2285
[ 2750.193005] sd_ioctl continuing cmd=0x2285
[ 2750.193006] sd_ioctl default cmd=0x2285
[ 2750.193055] sd_ioctl continuing cmd=0x2285
[ 2750.193056] sd_ioctl default cmd=0x2285
[ 2750.193963] sd_ioctl continuing cmd=0x2285
[ 2750.193964] sd_ioctl default cmd=0x2285
[ 2750.194211] sd_ioctl continuing cmd=0x2285
[ 2750.194212] sd_ioctl default cmd=0x2285
[ 2750.194514] sd_ioctl continuing cmd=0x2285
[ 2750.194515] sd_ioctl default cmd=0x2285
[ 2750.194522] sd_ioctl continuing cmd=0x2285
[ 2750.194523] sd_ioctl default cmd=0x2285
[ 2750.195154] sd_ioctl continuing cmd=0x2285
[ 2750.195155] sd_ioctl default cmd=0x2285
[ 2750.195156] sd_ioctl continuing cmd=0x2285
[ 2750.195157] sd_ioctl default cmd=0x2285
[ 2750.195448] sd_ioctl continuing cmd=0x2285
[ 2750.195448] sd_ioctl default cmx2285
[ 2750.196647] sd_ioctl continuing cmd=0x2285
[ 2750.196648] sd_ioctl default cmd=0x2285
[ 2750.197132] sd_ioctl continuing cmd=0x2285
[ 2750.197133] sd_ioctl default cmd=0x2285
[ 2750.197134] sd_ioctl continuing cmd=0x2285
[ 2750.197135] sd_ioctl default cmd=0x2285
[ 2750.197157] sd_ioctl continuing cmd=0x2285
[ 2750.197157] sd_ioctl default cmd=0x2285
[ 2750.197708] sd_ioctl continuing cmd=0x2285
[ 2750.197708] sd_ioctl default cmd=0x2285
[ 2750.198254] sd_ioctl continuing cmd=0x2285
[ 2750.198260] sd_ioctl default cmd=0x2285
[ 2750.198281] sd_ioctl continuing cmd=0x2285
[ 2750.198282] sd_ioctl default cmd=0x2285
[ 2750.198338] sd_ioctl continuing cmd=0x2285
[ 2750.198338] sd_ioctl default cmd=0x2285
[ 2750.199244] sd_ioctl continuing cmd=0x2285
[ 2750.199245] sd_ioctl default cmd=0x2285
[ 2750.201160] sd_ioctl continuing cmd=0x2285
[ 2750.201161] sd_ioctl default cmd=0x2285
[ 2750.202978] sd_ioctl continuing cmd=0x5331
[ 2750.202979] sd_ioctl default cmd=0x5331
[ 2750.202980] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.203182] sd_ioctl continuing cmd=0x5331
[ 2750.203182] sd_ioctl default cmd=0x5331
[ 2750.203184] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.204202] sd_ioctl continuing cmd=0x2285
[ 2750.204202] sd_ioctl default cmd=0x2285
[ 2750.205480] sd_ioctl continuing cmd=0x2285
[ 2750.205480] sd_ioctl default cmd=0x2285
[ 2750.209410] sd_ioctl continuing cmd=0x5331
[ 2750.209411] sd_ioctl default cmd=0x5331
[ 2750.209413] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.216017] sd_ioctl continuing cmd=0x5331
[ 2750.216018] sd_ioctl default cmd=0x5331
[ 2750.216019] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.217894] sd_ioctl continuing cmd=0x2285
[ 2750.217895] sd_ioctl default cmd=0x2285
[ 2750.219160] sd_ioctl continuing cmd=0x2285
[ 2750.219161] sd_ioctl default cmd=0x2285
[ 2750.221139] sd_ioctl continuing cmd=0x5331
[ 2750.221140] sd_ioctl default cmd=0x5331
[ 2750.221185] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 27503518] sd_ioctl continuing cmd=0x5331
[ 2750.223519] sd_ioctl default cmd=0x5331
[ 2750.223521] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.229958] sd_ioctl continuing cmd=0x5331
[ 2750.229959] sd_ioctl default cmd=0x5331
[ 2750.229961] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY
[ 2750.833956] sd_ioctl default cmd=0x2284
[ 2750.835317] calling scsi_try_bus_device_reset
[ 2750.837390] hpsa_eh_device_reset_handler called with ffff880409505380
[ 2750.840046] hpsa 0000:04:00.0: resetting scsi 2:0:0:4: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En- Exp=3
[ 2750.844430] hpsa 0000:04:00.0: resetting scsi 2:0:0:4 completed successfully
[ 2750.846862] scsi host2: waking up host to restart after TMF
[ 2750.851673] sd_ioctl continuing cmd=0x2285
[ 2750.853238] sd_ioctl default cmd=0x2285
[ 2750.854572] sd_ioctl continuing cmd=0x2285
[ 2750.856024] sd_ioctl default cmd=0x2285
[ 2750.857500] sd_ioctl continuing cmd=0x2285
[ 2750.859011] sd_ioctl default cmd=0x2285
[ 2750.860439] sd_ioctl continuing cmd=0x2285
[ 2750.862025] sd_ioctl default cmd=0x2285
[ 2750.863615] sd_ioctl continuing cmd=0x2285
[ 2750.865214] sd_ioctl default cmd=0x2285
[ 2750.869520] sd_ioctl continuing cmd=0x5331
[ 2750.871225] sd_ioctl default cmd=0x5331
[ 2750.872554] hpsa_ioctl rejecting cmd=0x5331 with -ENOTTY

[ 2751.852314] ------------------ loop-sg_reset pass 23:
[ 2751.856118] sd_ioctl continuing cmd=0x2284
[ 2751.857561] sd_ioctl continuing cmd=0x2284
[ 2751.857562] sd_ioctl default cmd=0x2284
[ 2751.857568] calling scsi_try_bus_device_reset
[ 2751.857571] hpsa_eh_device_reset_handler called with ffff8803f5454840
[ 2751.857577] hpsa 0000:04:00.0: resetting scsi 2:0:0:1: Direct-Access     HP       LOGICAL VOLUME   RAID-0 SSDSmartPathCap+ En- Exp=3
[ 2751.868394] sd_ioctl default cmd=0x2284

[ 2879.197989] INFO: task fio:13086 blocked for more than 120 seconds.
[ 2879.200164]       Tainted: G            E  3.17.0+ #93
[ 2879.201948] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2879.204610] fio             D 0000000000000000     0 13086  13081 0x00000000
[ 2879.207085]  ffff88040383b7d8 0000000000000086 ffff88040383b7a8 ffff880403838010
[ 2879.209890]  0000000000012c40 0000000000012c40 ffff8800b1533050 ffff8804038fc190
[ 2879.212612]  ffff88040383b7a8 ffff88043f412c40 ffff8804038fc190 ffff88040383b908
[ 2879.215323] Call Trace:
[ 2879.216116]  [<ffffffff815a8fe9>] schedule+0x29/0x70
[ 2879.217840]  [<ffffffff815a90bc>] io_schedule+0x8c/0xd0
[ 2879.219677]  [<ffffffff81276fd7>] bt_get+0x107/0x190
[ 2879.221434]  [<ffffffff8108fc40>] ? bit_waitqueue+0xa0/0xa0
[ 2879.223318]  [<ffffffff812770cc>] blk_mq_get_tag+0x6c/0xc0
[ 2879.225100]  [<ffffffff812735de>] __blk_mq_alloc_request+0x1e/0x230
[ 2879.227280]  [<ffffffff81274c6a>] blk_mq_map_request+0x17a/0x1d0
[ 2879.229437]  [<ffffffff81275017>] blk_sq_make_request+0x97/0x380
[ 2879.231473]  [<ffffffff81138545>] ? mempool_alloc_slab+0x15/0x20
[ 2879.233516]  [<ffffffff8126a7c0>] generic_make_request+0xc0/0x100
[ 2879.235580]  [<ffffffff8126a871>] submit_bio+0x71/0x140
[ 2879.237413]  [<ffffffff811415d8>] ? set_page_dirty_lock+0x38/0x60
[ 2879.239559]  [<ffffffff8126269c>] ? bio_set_pages_dirty+0x4c/0x70
[ 2879.241635]  [<ffffffff811d40c8>] do_blockdev_direct_IO+0xa88/0xbb0
[ 2879.243761]  [<ffffffff8113774a>] ? filemap_map_pages+0x1ca/0x210
[ 2879.245853]  [<ffffffff811cf040>] ? I_BDEV+0x10/0x10
[ 2879.247571]  [<ffffffff811d3641>] ? do_blockdev_direct_IO+0x1/0xbb0
[ 2879.249770]  [<ffffffff811d423c>] __blockdev_direct_IO+0x4c/0x50
[ 2879.251815]  [<ffffffff811cf040>] ? I_BDEV+0x10/0x10
[ 2879.253581]  [<ffffffff811cffde>] blkdev_direct_IO+0x4e/0x50
[ 2879.255512]  [<ffffffff811cf040>] ? I_BDEV+0x10/0x10
[ 2879.257171]  [<ffffffff81137d93>] generic_file_read_iter+0x143/0x150
[ 2879.259425]  [<fffff811cf270>] ? ioctl_by_bdev+0x50/0x50
[ 2879.361362]  [<ffffffff811cf2a7>] blkdev_read_iter+0x37/0x40
[ 2879.363266]  [<ffffffff811df890>] aio_run_iocb+0x230/0x430
[ 2879.365163]  [<ffffffff815a8ace>] ? __schedule+0x34e/0x720
[ 2879.367489]  [<ffffffff81188c90>] ? kmem_cache_alloc+0x70/0x160
[ 2879.369590]  [<ffffffff811dfc69>] io_submit_one+0x1d9/0x440
[ 2879.371524]  [<ffffffff811e000c>] do_io_submit+0x13c/0x200
[ 2879.373441]  [<ffffffff81089223>] ? pick_next_task_fair+0x163/0x220
[ 2879.375574]  [<ffffffff811e00e0>] SyS_io_submit+0x10/0x20
[ 2879.377431]  [<ffffffff815acc52>] system_call_fastpath+0x16/0x1b
[ 2879.379568] INFO: task fio:13087 blocked for more than 120 seconds.
[ 2879.381729]       Tainted: G            E  3.17.0+ #93
[ 2879.383444] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2879.385954] fio             D 0000000000000001     0 13087  13081 0x00000000
[ 2879.388409]  ffff88041c6f77d8 0000000000000086 ffff88041c6f77a8 ffff88041c6f4010
[ 2879.390840]  0000000000012c40 0000000000012c40 ffff88042f0010d0 ffff88041c6570d0
[ 2879.393269]  ffff88041c6f77a8 ffff88043f432c40 ffff88041c6570d0 ffff88041c6f7908
[ 2879.395706] Call Trace:
[ 2879.396527]  [<ffffffff815a8fe9>] schedule+0x29/0x70
[ 2879.398264]  [<ffffffff815a90bc>] io_schedule+0x8c/0xd0
[ 2879.400047]  [<ffffffff81276fd7>] bt_get+0x107/0x190
[ 2879.401780]  [<ffffffff8108fc40>] ? bit_waitqueue+0xa0/0xa0
[ 2879.403897]  [<ffffffff812770cc>] blk_mq_get_tag+0x6c/0xc0
[ 2879.405835]  [<ffffffff812735de>] __blk_mq_alloc_request+0x1e/0x230
[ 2879.408000]  [<ffffffff81274c6a>] blk_mq_map_request+0x17a/0x1d0
[ 2879.410100]  [<ffffffff81275017>] blk_sq_make_request+0x97/0x380
[ 2879.412150]  [<ffffffff81138545>] ? mempool_alloc_slab+0x15/0x20
[ 2879.414230]  [<ffffffff8126a7c0>] generic_make_request+0xc0/0x100
[ 2879.416293]  [<ffffffff8126a871>] submit_bio+0x71/0x140
[ 2879.418100]  [<ffffffff811415d8>] ? set_page_dirty_lock+0x38/0x60
[ 2879.420237]  [<ffffffff8126269c>] ? bio_set_pagesrty+0x4c/0x70
[ 2879.522322]  [<ffffffff811d40c8>] do_blockdev_direct_IO+0xa88/0xbb0
[ 2879.524574]  [<ffffffff8113774a>] ? filemap_map_pages+0x1ca/0x210
[ 2879.526708]  [<ffffffff811cf040>] ? I_BDEV+0x10/0x10
[ 2879.528567]  [<ffffffff811d423c>] __blockdev_direct_IO+0x4c/0x50
[ 2879.530624]  [<ffffffff811cf040>] ? I_BDEV+0x10/0x10
[ 2879.532297]  [<ffffffff811cffde>] blkdev_direct_IO+0x4e/0x50
[ 2879.534267]  [<ffffffff811cf040>] ? I_BDEV+0x10/0x10
[ 2879.535967]  [<ffffffff81137d93>] generic_file_read_iter+0x143/0x150
[ 2879.538206]  [<ffffffff811cf270>] ? ioctl_by_bdev+0x50/0x50
[ 2879.540107]  [<ffffffff811cf2a7>] blkdev_read_iter+0x37/0x40
[ 2879.542055]  [<ffffffff811df890>] aio_run_iocb+0x230/0x430
[ 2879.543892]  [<ffffffff815a8ace>] ? __schedule+0x34e/0x720
[ 2879.545775]  [<ffffffff811dfc69>] io_submit_one+0x1d9/0x440
[ 2879.547724]  [<ffffffff811e000c>] do_io_submit+0x13c/0x200
[ 2879.549701]  [<ffffffff811e00e0>] SyS_io_submit+0x10/0x20
[ 2879.551580]  [<ffffffff815acc52>] system_call_fastpath+0x16/0x1b
[ 2879.553618] INFO: task fio:13088 blocked for more than 120 seconds.
<several more of those>


