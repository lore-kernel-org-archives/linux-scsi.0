From: Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org>
Subject: 5.1-rc1: mpt init crash in scsi_map_dma, dma_4v_map_sg on sparc64
Date: Tue, 19 Mar 2019 13:19:08 +0200
Message-ID: <dbed1f7e-cf7b-0e87-841e-e4dd1eb1ed23@linux.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Language: et-EE
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, MPT-FusionLinux.pdl-dY08KVG/lbpWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Tried 5.1-rc1 on a bunch of sparcs, this hits all my sparcs with sun4v and mpt scsi.

[    2.733263] Fusion MPT base driver 3.04.20
[    2.742995] Copyright (c) 1999-2008 LSI Corporation
[    2.743052] Fusion MPT SAS Host driver 3.04.20
[    2.743881] mptbase: ioc0: Initiating bringup
[    3.737822] ioc0: LSISAS1064 A3: Capabilities={Initiator}
[   17.566584] scsi host0: ioc0: LSISAS1064 A3, FwRev=010a0000h, Ports=1, MaxQ=511, IRQ=27
[   17.595897] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x5000c5001799a45d
[   17.598465] Unable to handle kernel NULL pointer dereference
[   17.598623] tsk->{mm,active_mm}->context = 0000000000000000
[   17.598723] tsk->{mm,active_mm}->pgd = ffff800008802000
[   17.598774]               \|/ ____ \|/
[   17.598774]               "@'/ .. \`@"
[   17.598774]               /_| \__/ |_\
[   17.598774]                  \__U_/
[   17.598894] swapper/0(1): Oops [#1]
[   17.598937] CPU: 12 PID: 1 Comm: swapper/0 Not tainted 5.1.0-rc1 #118
[   17.598994] TSTATE: 0000000080e01601 TPC: 00000000004483a8 TNPC: 00000000004483ac Y: 00000000    Not tainted
[   17.599086] TPC: <dma_4v_map_sg+0xe8/0x5c0>
[   17.599127] g0: ffff8000086d1d51 g1: 00000000ffffffff g2: 0000000000010000 g3: ffff8000086b8000
[   17.599197] g4: ffff8000086c0000 g5: ffff8001fef78000 g6: ffff8000086d0000 g7: ffffffffffffffff
[   17.599267] o0: ffff8001f526bc90 o1: 00000000000001e2 o2: ffff8001f4fc2000 o3: ffff8001f4fc2000
[   17.599337] o4: ffff8001f4fc1144 o5: ffff8001f5002800 sp: ffff8000086d1db1 ret_pc: 0000000000740720
[   17.599415] RPC: <mptscsih_qcmd+0x280/0x660>
[   17.599456] l0: 0000000024000000 l1: 000000000000ff00 l2: 0000000000080000 l3: 0000000000010000
[   17.599526] l4: ffff8001f5002830 l5: 0000000000ff0000 l6: ffff8001f46c7e10 l7: ffff8001f4fc1000
[   17.599596] i0: ffff8001f4b350b0 i1: ffff8001f526be28 i2: 0000000000000001 i3: 0000000000000002
[   17.599665] i4: 0000000000000010 i5: 0000000000000000 i6: ffff8000086d1f01 i7: 0000000000725570
[   17.599745] I7: <scsi_dma_map+0x50/0xc0>
[   17.599781] Call Trace:
[   17.599824]  [0000000000725570] scsi_dma_map+0x50/0xc0
[   17.599881]  [0000000000740720] mptscsih_qcmd+0x280/0x660
[   17.599940]  [0000000000723dec] scsi_queue_rq+0x6ac/0x880
[   17.600005]  [0000000000680198] blk_mq_dispatch_rq_list+0x138/0x540
[   17.600065]  [0000000000685154] blk_mq_do_dispatch_sched+0x54/0x100
[   17.600124]  [000000000068560c] blk_mq_sched_dispatch_requests+0xec/0x160
[   17.600186]  [000000000067e83c] __blk_mq_run_hw_queue+0x9c/0x180
[   17.600246]  [000000000067eaa8] __blk_mq_delay_run_hw_queue+0x188/0x1e0
[   17.600307]  [000000000067ff74] blk_mq_run_hw_queue+0x54/0x140
[   17.600365]  [0000000000685be0] blk_mq_sched_insert_request+0x120/0x180
[   17.600424]  [000000000067a394] blk_execute_rq+0x34/0x60
[   17.600483]  [00000000007218cc] __scsi_execute+0xcc/0x1a0
[   17.600543]  [0000000000725f40] scsi_probe_and_add_lun+0x1e0/0xec0
[   17.600603]  [0000000000726e98] __scsi_scan_target+0xb8/0x680
[   17.600663]  [000000000072757c] scsi_scan_target+0x11c/0x140
[   17.600727]  [000000000072e9b8] sas_rphy_add+0x138/0x1c0
[   17.600777] Disabling lock debugging due to kernel taint
[   17.600837] Caller[0000000000725570]: scsi_dma_map+0x50/0xc0
[   17.600896] Caller[0000000000740720]: mptscsih_qcmd+0x280/0x660
[   17.600956] Caller[0000000000723dec]: scsi_queue_rq+0x6ac/0x880
[   17.601018] Caller[0000000000680198]: blk_mq_dispatch_rq_list+0x138/0x540
[   17.601078] Caller[0000000000685154]: blk_mq_do_dispatch_sched+0x54/0x100
[   17.601138] Caller[000000000068560c]: blk_mq_sched_dispatch_requests+0xec/0x160
[   17.601210] Caller[000000000067e83c]: __blk_mq_run_hw_queue+0x9c/0x180
[   17.601271] Caller[000000000067eaa8]: __blk_mq_delay_run_hw_queue+0x188/0x1e0
[   17.601333] Caller[000000000067ff74]: blk_mq_run_hw_queue+0x54/0x140
[   17.601392] Caller[0000000000685be0]: blk_mq_sched_insert_request+0x120/0x180
[   17.601453] Caller[000000000067a394]: blk_execute_rq+0x34/0x60
[   17.601513] Caller[00000000007218cc]: __scsi_execute+0xcc/0x1a0
[   17.601574] Caller[0000000000725f40]: scsi_probe_and_add_lun+0x1e0/0xec0
[   17.601635] Caller[0000000000726e98]: __scsi_scan_target+0xb8/0x680
[   17.601696] Caller[000000000072757c]: scsi_scan_target+0x11c/0x140
[   17.601758] Caller[000000000072e9b8]: sas_rphy_add+0x138/0x1c0
[   17.601819] Caller[0000000000743b64]: mptsas_add_end_device+0xc4/0x100
[   17.601882] Caller[0000000000746964]: mptsas_scan_sas_topology+0x164/0x300
[   17.601943] Caller[0000000000749094]: mptsas_probe+0x2d4/0x440
[   17.602004] Caller[00000000006bf948]: pci_device_probe+0xc8/0x160
[   17.602066] Caller[000000000070dab0]: really_probe+0x1b0/0x2e0
[   17.602126] Caller[000000000070de10]: driver_probe_device+0x50/0x100
[   17.602186] Caller[000000000070e0a8]: device_driver_attach+0x48/0x60
[   17.602245] Caller[000000000070e140]: __driver_attach+0x80/0xe0
[   17.602302] Caller[000000000070c484]: bus_for_each_dev+0x44/0x80
[   17.602360] Caller[000000000070ca74]: bus_add_driver+0x134/0x200
[   17.602419] Caller[000000000070e790]: driver_register+0x70/0x120
[   17.602478] Caller[00000000009f2e4c]: mptsas_init+0x110/0x138
[   17.602536] Caller[0000000000427490]: do_one_initcall+0x30/0x180
[   17.602593] Caller[00000000009dab9c]: kernel_init_freeable+0x144/0x1e4
[   17.602644] Instruction DUMP:
[   17.602648]  80a1c001
[   17.611695]  b9651003
[   17.611728]  80a6a000
[   17.611762] <c25f0000>
[   17.625496]  8330700d
[   17.625529]  04400126
[   17.625562]  c277a79f
[   17.649127]  c25fa7df
[   17.649161]  84103fff
[   17.649193]
[   17.664729] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009

-- 
Meelis Roos <mroos-Y27EyoLml9s@public.gmane.org>
