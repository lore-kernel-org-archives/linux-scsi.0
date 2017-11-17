From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: mvsas sata drives with high ioerr_cnt and long stalls
Date: Fri, 17 Nov 2017 11:31:59 +0200
Message-ID: <20171117093159.GL20756@reaktio.net>
References: <2efdd536-caa8-8da7-9c82-58d63670eb57@gmail.com>
 <33f1827f-e4fa-11a2-1c2f-94c7a4958d3b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:40131 "EHLO
        emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdKQJlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 04:41:19 -0500
Content-Disposition: inline
In-Reply-To: <33f1827f-e4fa-11a2-1c2f-94c7a4958d3b@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Larkin Lowrey <llowrey@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 16, 2017 at 08:55:07PM -0500, Larkin Lowrey wrote:
> It just got worse, under heavy sequential write load, all of the drives in
> the array where thrown out of the array and I got a stack trace.
> 
> I know I've been able to stress this array without issue but the last time I
> did that was several kernels ago.
> 

iirc some people earlier reported that their cards are overheating, and adding more cooling to either the case or a fan for the controllers helped. I don't know if that might be your issue aswell.

Other than that.. my general feeling is that mvsas driver is quite buggy, and unfortunately lots of people have had issues with it..


-- Pasi

> --Larkin
> 
> [ 5723.912580] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5723.920002] ata14.00: failed command: SMART
> [ 5723.924428] ata14.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 21 pio
> 512 in
> [ 5723.924428]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [ 5723.939938] ata14.00: status: { DRDY }
> [ 5723.943975] ata14: hard resetting link
> [ 5731.517360] ata14.00: qc timeout (cmd 0xec)
> [ 5731.521889] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [ 5731.528411] ata14.00: revalidation failed (errno=-5)
> [ 5731.533696] ata14: hard resetting link
> [ 5739.197688] ata14.00: qc timeout (cmd 0x27)
> [ 5739.202312] ata14.00: failed to read native max address (err_mask=0x4)
> [ 5739.209165] ata14.00: HPA support seems broken, skipping HPA handling
> [ 5739.215921] ata14.00: revalidation failed (errno=-5)
> [ 5739.221185] ata14: hard resetting link
> [ 5757.118460] ata14.00: qc timeout (cmd 0xef)
> [ 5757.122940] ata14.00: failed to set xfermode (err_mask=0x4)
> [ 5757.128864] ata14.00: disabled
> [ 5757.132218] ata14: hard resetting link
> [ 5759.510588] ata14: EH complete
> [ 5759.514162] sd 8:0:7:0: [sdm] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5759.514267] sd 8:0:7:0: [sdm] Read Capacity(16) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5759.514271] sd 8:0:7:0: [sdm] Sense not available.
> [ 5759.514313] sd 8:0:7:0: [sdm] Read Capacity(10) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5759.514316] sd 8:0:7:0: [sdm] Sense not available.
> [ 5759.514349] sd 8:0:7:0: [sdm] 0 512-byte logical blocks: (0 B/0 B)
> [ 5759.514352] sd 8:0:7:0: [sdm] 4096-byte physical blocks
> [ 5759.514440] sdm: detected capacity change from 4000787030016 to 0
> [ 5759.572801] sd 8:0:7:0: [sdm] tag#2 CDB: ATA command pass
> through(12)/Blank a1 06 20 00 00 00 00 00 00 e5 00 00
> [ 5766.988546] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5766.995950] ata8.00: failed command: SMART
> [ 5767.000362] ata8.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 21 pio
> 512 in
> [ 5767.000362]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 5767.015812] ata8.00: status: { DRDY }
> [ 5767.019730] ata8: hard resetting link
> [ 5769.431098] ata8.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5769.439017] ata8.00: revalidation failed (errno=-5)
> [ 5774.527196] ata8: hard resetting link
> [ 5774.687313] ------------[ cut here ]------------
> [ 5774.692252] WARNING: CPU: 4 PID: 11543 at drivers/ata/libata-core.c:5137
> __ata_qc_complete+0x103/0x150
> [ 5774.702108] Modules linked in: fuse binfmt_misc vhost_net vhost macvtap
> macvlan tap xt_CHECKSUM iptable_mangle tun xt_nat veth                 
> ebtable_filter ebtables 8021q garp mrp xfs ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 xt_addrtype nf_nat
> br_net                 filter bridge stp llc bonding cfg80211 rfkill
> nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6
> nf_conntrack_ipv6 nf_def                 rag_ipv6 xt_conntrack nf_conntrack
> ip6table_filter ip6_tables jc42 joydev amd64_edac_mod edac_mce_amd kvm_amd
> kvm irqbypass crct10                 dif_pclmul crc32_pclmul
> ghash_clmulni_intel ipmi_si ipmi_devintf ipmi_msghandler sp5100_tco
> i2c_piix4 k10temp fam15h_power tpm_tis                  tpm_tis_core
> acpi_cpufreq tpm shpchp dm_thin_pool dm_persistent_data dm_bio_prison bcache
> raid456 libcrc32c async_raid6_recov asy                 nc_memcpy async_pq
> async_xor async_tx
> [ 5774.776476]  raid0 btrfs xor raid6_pq raid10 drm_kms_helper igb ttm mvsas
> uas ptp drm crc32c_intel serio_raw mpt3sas libsas usb                
> _storage pps_core be2net raid_class dca scsi_transport_sas i2c_algo_bit
> [ 5774.794981] CPU: 4 PID: 11543 Comm: kworker/u65:5 Not tainted
> 4.13.12-100.fc25.x86_64 #1
> [ 5774.803581] Hardware name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS
> 3.0a       07/26/2013
> [ 5774.812273] Workqueue: events_unbound async_run_entry_fn
> [ 5774.817896] task: ffff90e7ca602640 task.stack: ffffb070caf50000
> [ 5774.824105] RIP: 0010:__ata_qc_complete+0x103/0x150
> [ 5774.829250] RSP: 0018:ffffb070caf539a8 EFLAGS: 00010046
> [ 5774.834790] RAX: 0000000000010010 RBX: ffff90f44b891d50 RCX:
> 0000000000000010
> [ 5774.842291] RDX: 0000000000000046 RSI: ffff90f44b891e00 RDI:
> ffff90f44b891d50
> [ 5774.849797] RBP: ffffb070caf539c0 R08: 0000000000000000 R09:
> ffffffffc037706d
> [ 5774.857321] R10: ffffb070caf539b0 R11: 000000000000075a R12:
> 0000000000000001
> [ 5774.864814] R13: ffff90f44b890000 R14: ffff90f44b892300 R15:
> ffff90f44b891e80
> [ 5774.872313] FS:  0000000000000000(0000) GS:ffff90e857d00000(0000)
> knlGS:0000000000000000
> [ 5774.880928] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 5774.887013] CR2: 00007fd028c4dc40 CR3: 00000015d6374000 CR4:
> 00000000000406e0
> [ 5774.894455] Call Trace:
> [ 5774.897155]  ata_qc_complete+0xc3/0x2b0
> [ 5774.901260]  ata_qc_issue+0xf1/0x290
> [ 5774.905097]  ata_exec_internal_sg+0x341/0x650
> [ 5774.909738]  ata_exec_internal+0x64/0xa0
> [ 5774.913988]  ? ata_exec_internal+0x64/0xa0
> [ 5774.918335]  ata_dev_read_id+0x2fa/0x5b0
> [ 5774.922542]  ? ata_eh_reset+0x230/0xd10
> [ 5774.926644]  ata_dev_reread_id+0x4a/0xe0
> [ 5774.930829]  ata_dev_revalidate+0x50/0x180
> [ 5774.935199]  ata_eh_recover+0x705/0x1300
> [ 5774.939377]  ? ata_phys_link_online+0x60/0x60
> [ 5774.944020]  ? sas_ata_printk+0xa0/0xa0 [libsas]
> [ 5774.948936]  ? ata_phys_link_offline+0x60/0x60
> [ 5774.953675]  ? ata_phys_link_offline+0x60/0x60
> [ 5774.958429]  ? sas_ata_printk+0xa0/0xa0 [libsas]
> [ 5774.963307]  ata_do_eh+0x49/0xb0
> [ 5774.966838]  ? ata_phys_link_online+0x60/0x60
> [ 5774.971528]  ata_std_error_handler+0x3e/0x70
> [ 5774.976053]  ata_scsi_port_error_handler+0x465/0x790
> [ 5774.981303]  async_sas_ata_eh+0x48/0x70 [libsas]
> [ 5774.986282]  async_run_entry_fn+0x38/0x160
> [ 5774.990674]  process_one_work+0x18c/0x3a0
> [ 5774.994982]  worker_thread+0x4e/0x3b0
> [ 5774.998941]  kthread+0x109/0x140
> [ 5775.002455]  ? process_one_work+0x3a0/0x3a0
> [ 5775.006918]  ? kthread_park+0x60/0x60
> [ 5775.010850]  ret_from_fork+0x25/0x30
> [ 5775.014751] Code: 00 00 48 85 d2 74 32 83 f9 02 77 60 4c 8b 4a 38 4d 85
> c9 0f 84 5a ff ff ff 8b 53 60 45 31 c0 41 ff d1 48 8b 4                 3 50
> e9 48 ff ff ff <0f> ff e9 1c ff ff ff 0f ff e9 09 ff ff ff 48 8b 15 98 fb 82
> 00
> [ 5775.034585] ---[ end trace ec372db9e2e7d5b0 ]---
> [ 5775.039606] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x11)
> [ 5775.046094] ata8.00: revalidation failed (errno=-5)
> [ 5780.159379] ata8: hard resetting link
> [ 5785.791685] ata8.00: qc timeout (cmd 0xec)
> [ 5785.796094] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [ 5785.802521] ata8.00: revalidation failed (errno=-5)
> [ 5785.807697] ata8.00: disabled
> [ 5785.810976] ata8: hard resetting link
> [ 5788.247840] ata8: EH complete
> [ 5795.979324] ata15.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5795.986760] ata15.00: failed command: SMART
> [ 5795.991250] ata15.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 24 pio
> 512 in
> [ 5795.991250]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [ 5796.006835] ata15.00: status: { DRDY }
> [ 5796.010873] ata15: hard resetting link
> [ 5801.652456] ata15.00: failed to read native max address (err_mask=0x11)
> [ 5801.659460] ata15.00: HPA support seems broken, skipping HPA handling
> [ 5801.670310] ata15.00: revalidation failed (errno=-5)
> [ 5803.456373] ata15: hard resetting link
> [ 5803.616480] ata15.00: failed to IDENTIFY (I/O error, err_mask=0x11)
> [ 5803.623156] ata15.00: revalidation failed (errno=-5)
> [ 5808.832605] ata15: hard resetting link
> [ 5814.464853] ata15.00: qc timeout (cmd 0xec)
> [ 5814.469342] ata15.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [ 5814.475892] ata15.00: revalidation failed (errno=-5)
> [ 5814.481230] ata15.00: disabled
> [ 5814.484580] ata15: hard resetting link
> [ 5816.920997] ata15: EH complete
> [ 5825.932429] ata16.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5825.939981] ata16.00: failed command: SMART
> [ 5825.944564] ata16.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 15 pio
> 512 in
> [ 5825.944564]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 5825.960313] ata16.00: status: { DRDY }
> [ 5825.964361] ata16: hard resetting link
> [ 5828.377500] ata16.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5828.385382] ata16.00: revalidation failed (errno=-5)
> [ 5833.410669] ata16: hard resetting link
> [ 5833.569754] ata16.00: failed to IDENTIFY (I/O error, err_mask=0x11)
> [ 5833.576381] ata16.00: revalidation failed (errno=-5)
> [ 5839.041900] ata16: hard resetting link
> [ 5844.674146] ata16.00: qc timeout (cmd 0xec)
> [ 5844.678632] ata16.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [ 5844.685143] ata16.00: revalidation failed (errno=-5)
> [ 5844.690394] ata16.00: disabled
> [ 5844.693752] ata16: hard resetting link
> [ 5847.130278] ata16: EH complete
> [ 5854.927126] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5854.927132] ata7.00: failed command: SMART
> [ 5854.927139] ata7.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 3 pio
> 512 in
> [ 5854.927139]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 5854.927140] ata7.00: status: { DRDY }
> [ 5854.927151] ata7: hard resetting link
> [ 5857.306739] ata7.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5857.314511] ata7.00: revalidation failed (errno=-5)
> [ 5862.594911] ata7: hard resetting link
> [ 5868.227188] ata7.00: qc timeout (cmd 0xec)
> [ 5868.231576] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [ 5868.237958] ata7.00: revalidation failed (errno=-5)
> [ 5868.243145] ata7: hard resetting link
> [ 5870.619335] ata7.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5870.627120] ata7.00: revalidation failed (errno=-5)
> [ 5870.632311] ata7.00: disabled
> [ 5870.635567] ata7: EH complete
> [ 5877.966747] ata13.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5877.974206] ata13.00: failed command: SMART
> [ 5877.978694] ata13.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 9 pio
> 512 in
> [ 5877.978694]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 5877.994119] ata13.00: status: { DRDY }
> [ 5877.998137] ata13: hard resetting link
> [ 5880.411725] ata13.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5880.419599] ata13.00: revalidation failed (errno=-5)
> [ 5885.636928] ata13: hard resetting link
> [ 5891.268165] ata13.00: qc timeout (cmd 0xec)
> [ 5891.272637] ata13.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [ 5891.279084] ata13.00: revalidation failed (errno=-5)
> [ 5891.284309] ata13: hard resetting link
> [ 5893.660334] ata13.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5893.668329] ata13.00: revalidation failed (errno=-5)
> [ 5893.673644] ata13.00: disabled
> [ 5893.677028] ata13: EH complete
> [ 5894.787053] sd 9:0:0:0: [sdn] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5894.796256] sd 9:0:0:0: [sdn] tag#1 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 e5 00
> [ 5894.807618] sd 9:0:0:0: [sdn] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5894.816799] sd 9:0:0:0: [sdn] tag#1 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 98 00
> [ 5894.878574] sd 8:0:7:0: [sdm] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5894.887772] sd 8:0:7:0: [sdm] tag#1 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 e5 00
> [ 5894.899008] sd 8:0:7:0: [sdm] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5894.908209] sd 8:0:7:0: [sdm] tag#1 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 98 00
> [ 5900.943631] ata18.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5900.951175] ata18.00: failed command: SMART
> [ 5900.955723] ata18.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 4 pio
> 512 in
> [ 5900.955723]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 5900.971235] ata18.00: status: { DRDY }
> [ 5900.975288] ata18: hard resetting link
> [ 5903.388738] ata18.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5903.396732] ata18.00: revalidation failed (errno=-5)
> [ 5908.676895] ata18: hard resetting link
> [ 5914.309158] ata18.00: qc timeout (cmd 0xec)
> [ 5914.313628] ata18.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [ 5914.320092] ata18.00: revalidation failed (errno=-5)
> [ 5914.325334] ata18: hard resetting link
> [ 5916.701307] ata18.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
> err_mask=0x80)
> [ 5916.709333] ata18.00: revalidation failed (errno=-5)
> [ 5916.714627] ata18.00: disabled
> [ 5916.718028] ata18: EH complete
> [ 5916.721479] sd 9:0:3:0: [sdq] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.730871] sd 9:0:3:0: [sdq] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 e5 00
> [ 5916.742313] sd 9:0:3:0: [sdq] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.751613] sd 9:0:3:0: [sdq] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 98 00
> [ 5916.803122] sd 9:0:1:0: [sdo] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.812292] sd 9:0:1:0: [sdo] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 e5 00
> [ 5916.823577] sd 9:0:1:0: [sdo] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.832834] sd 9:0:1:0: [sdo] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 98 00
> [ 5916.866532] sd 8:0:0:0: [sdf] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.875732] sd 8:0:0:0: [sdf] tag#2 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 e5 00
> [ 5916.887172] sd 8:0:0:0: [sdf] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.896445] sd 8:0:0:0: [sdf] tag#2 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 98 00
> [ 5916.929249] sd 8:0:1:0: [sdg] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.938504] sd 8:0:1:0: [sdg] tag#2 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 e5 00
> [ 5916.949821] sd 8:0:1:0: [sdg] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5916.958984] sd 8:0:1:0: [sdg] tag#2 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 98 00
> [ 5916.990812] sd 8:0:6:0: [sdl] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5917.000119] sd 8:0:6:0: [sdl] tag#2 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 e5 00
> [ 5917.011462] sd 8:0:6:0: [sdl] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5917.020761] sd 8:0:6:0: [sdl] tag#2 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 40 98 00
> [ 5923.924167] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5923.931658] ata10.00: failed command: SMART
> [ 5923.936098] ata10.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 13 pio
> 512 in
> [ 5923.936098]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 5923.951630] ata10.00: status: { DRDY }
> [ 5923.955626] ata10: hard resetting link
> [ 5931.718891] ata10.00: qc timeout (cmd 0x27)
> [ 5931.723382] ata10.00: failed to read native max address (err_mask=0x4)
> [ 5931.730210] ata10.00: HPA support seems broken, skipping HPA handling
> [ 5931.736905] ata10.00: revalidation failed (errno=-5)
> [ 5931.742130] ata10: hard resetting link
> [ 5949.638671] ata10.00: qc timeout (cmd 0xef)
> [ 5949.643160] ata10.00: failed to set xfermode (err_mask=0x4)
> [ 5949.649069] ata10.00: limiting speed to UDMA/133:PIO3
> [ 5949.654374] ata10: hard resetting link
> [ 5967.047418] ata10.00: qc timeout (cmd 0xef)
> [ 5967.051965] ata10.00: failed to set xfermode (err_mask=0x4)
> [ 5967.057817] ata10.00: disabled
> [ 5967.061150] ata10: hard resetting link
> [ 5969.439554] ata10: EH complete
> [ 5969.443140] sd 8:0:3:0: [sdi] Read Capacity(16) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5969.453446] sd 8:0:3:0: [sdi] Sense not available.
> [ 5969.458546] sd 8:0:3:0: [sdi] Read Capacity(10) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5969.468837] sd 8:0:3:0: [sdi] Sense not available.
> [ 5969.473915] sd 8:0:3:0: [sdi] 0 512-byte logical blocks: (0 B/0 B)
> [ 5969.480406] sd 8:0:3:0: [sdi] 4096-byte physical blocks
> [ 5969.489804] sd 8:0:3:0: [sdi] Write Protect is on
> [ 5969.495650] sd 8:0:3:0: [sdi] Read Capacity(16) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5969.506008] sd 8:0:3:0: [sdi] Sense not available.
> [ 5969.511136] sd 8:0:3:0: [sdi] Read Capacity(10) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 5969.521534] sd 8:0:3:0: [sdi] Sense not available.
> [ 5969.526978] sd 8:0:3:0: [sdi] Write Protect is off
> [ 5969.532189] sdi: detected capacity change from 4000787030016 to 0
> [ 5977.943709] ata11.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 5977.951236] ata11.00: failed command: SMART
> [ 5977.955733] ata11.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 20 pio
> 512 in
> [ 5977.955733]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 5977.971400] ata11.00: status: { DRDY }
> [ 5977.975455] ata11: hard resetting link
> [ 5983.933270] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
> [ 5983.939948] ata11.00: revalidation failed (errno=-5)
> [ 5985.417196] ata11: hard resetting link
> [ 5985.576314] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x11)
> [ 5985.582935] ata11.00: revalidation failed (errno=-5)
> [ 5990.600428] ata11: hard resetting link
> [ 5996.232665] ata11.00: qc timeout (cmd 0xec)
> [ 5996.237152] ata11.00: failed to IDENTIFY (I/O error, err_mask=0x5)
> [ 5996.243711] ata11.00: revalidation failed (errno=-5)
> [ 5996.248970] ata11.00: disabled
> [ 5996.252323] ata11: hard resetting link
> [ 5998.688795] ata11: EH complete
> [ 6006.933053] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [ 6006.940441] ata9.00: failed command: SMART
> [ 6006.944835] ata9.00: cmd b0/d1:01:00:4f:c2/00:00:00:00:00/00 tag 11 pio
> 512 in
> [ 6006.944835]          res 40/00:00:00:00:00/00:00:00:00:00/40 Emask 0x4
> (timeout)
> [ 6006.960406] ata9.00: status: { DRDY }
> [ 6006.964327] ata9: hard resetting link
> [ 6014.665460] ata9.00: qc timeout (cmd 0x27)
> [ 6014.669872] ata9.00: failed to read native max address (err_mask=0x4)
> [ 6014.676625] ata9.00: HPA support seems broken, skipping HPA handling
> [ 6014.683268] ata9.00: revalidation failed (errno=-5)
> [ 6014.688436] ata9: hard resetting link
> [ 6032.586243] ata9.00: qc timeout (cmd 0xef)
> [ 6032.590651] ata9.00: failed to set xfermode (err_mask=0x4)
> [ 6032.596446] ata9.00: limiting speed to UDMA/133:PIO3
> [ 6032.601684] ata9: hard resetting link
> [ 6049.994981] ata9.00: qc timeout (cmd 0xef)
> [ 6049.999448] ata9.00: failed to set xfermode (err_mask=0x4)
> [ 6050.005325] ata9.00: disabled
> [ 6050.008656] ata9: hard resetting link
> [ 6052.387254] ata9: EH complete
> [ 6052.390685] sd 8:0:2:0: [sdh] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.390780] sd 8:0:2:0: [sdh] Read Capacity(16) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.390783] sd 8:0:2:0: [sdh] Sense not available.
> [ 6052.390818] sd 8:0:2:0: [sdh] Read Capacity(10) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.390819] sd 8:0:2:0: [sdh] Sense not available.
> [ 6052.390848] sd 8:0:2:0: [sdh] 0 512-byte logical blocks: (0 B/0 B)
> [ 6052.390850] sd 8:0:2:0: [sdh] 4096-byte physical blocks
> [ 6052.390916] sdh: detected capacity change from 4000787030016 to 0
> [ 6052.449713] sd 8:0:2:0: [sdh] tag#1 CDB: Read(16) 88 00 00 00 00 01 92 01
> 1c 48 00 00 00 08 00 00
> [ 6052.459195] print_req_error: I/O error, dev sdh, sector 6744513608
> [ 6052.465994] sd 8:0:4:0: [sdj] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.475290] sd 8:0:4:0: [sdj] tag#1 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.484689] print_req_error: I/O error, dev sdj, sector 13488501832
> [ 6052.491297] sd 8:0:6:0: [sdl] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.500566] sd 8:0:6:0: [sdl] tag#2 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.510068] print_req_error: I/O error, dev sdl, sector 13488501832
> [ 6052.516855] sd 9:0:3:0: [sdq] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.526123] sd 9:0:3:0: [sdq] tag#0 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.535552] print_req_error: I/O error, dev sdq, sector 13488501832
> [ 6052.542175] sd 9:0:1:0: [sdo] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.551393] sd 9:0:1:0: [sdo] tag#1 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.560824] print_req_error: I/O error, dev sdo, sector 13488501832
> [ 6052.567369] sd 8:0:1:0: [sdg] tag#3 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.576578] sd 8:0:1:0: [sdg] tag#3 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.585964] print_req_error: I/O error, dev sdg, sector 13488501832
> [ 6052.592623] sd 8:0:0:0: [sdf] tag#4 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.601872] sd 8:0:0:0: [sdf] tag#4 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.611196] print_req_error: I/O error, dev sdf, sector 13488501832
> [ 6052.617993] sd 8:0:4:0: [sdj] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.627270] sd 8:0:4:0: [sdj] tag#1 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.636737] print_req_error: I/O error, dev sdj, sector 13488501832
> [ 6052.643303] sd 8:0:6:0: [sdl] tag#2 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.652601] sd 8:0:6:0: [sdl] tag#2 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.661961] print_req_error: I/O error, dev sdl, sector 13488501832
> [ 6052.668535] sd 9:0:3:0: [sdq] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6052.677783] sd 9:0:3:0: [sdq] tag#0 CDB: Read(16) 88 00 00 00 00 03 23 fa
> 34 48 00 00 00 08 00 00
> [ 6052.687221] print_req_error: I/O error, dev sdq, sector 13488501832
> [ 6052.693936] BTRFS error (device dm-2): bdev /dev/mapper/Cached-Nearline
> errs: wr 0, rd 1, flush 0, corrupt 1386, gen 0
> [ 6052.705383] md: super_written gets error=10
> [ 6052.708173] md: super_written gets error=10
> [ 6052.708177] md/raid:md3: Disk failure on md10, disabling device.
> [ 6052.708177] md/raid:md3: Operation continuing on 8 devices.
> [ 6052.708203] md/raid:md3: Disabling writeback cache for degraded array.
> [ 6052.708227] md: super_written gets error=10
> [ 6052.708283] md: super_written gets error=10
> [ 6052.708286] md/raid:md3: Disk failure on sdj1, disabling device.
> [ 6052.708286] md/raid:md3: Operation continuing on 7 devices.
> [ 6052.708294] md: super_written gets error=10
> [ 6052.708296] md/raid:md3: Disk failure on sdl1, disabling device.
> [ 6052.708296] md/raid:md3: Operation continuing on 6 devices.
> [ 6052.708302] md: super_written gets error=10
> [ 6052.708304] md/raid:md3: Disk failure on sdq1, disabling device.
> [ 6052.708304] md/raid:md3: Operation continuing on 5 devices.
> [ 6052.708310] md: super_written gets error=10
> [ 6052.708311] md/raid:md3: Disk failure on sdo1, disabling device.
> [ 6052.708311] md/raid:md3: Operation continuing on 4 devices.
> [ 6052.708317] md: super_written gets error=10
> [ 6052.708319] md/raid:md3: Disk failure on sdg1, disabling device.
> [ 6052.708319] md/raid:md3: Operation continuing on 3 devices.
> [ 6052.708324] md: super_written gets error=10
> [ 6052.708326] md/raid:md3: Disk failure on sdf1, disabling device.
> [ 6052.708326] md/raid:md3: Operation continuing on 2 devices.
> [ 6052.708330] md: super_written gets error=10
> [ 6052.708333] md: super_written gets error=10
> [ 6052.708336] md: super_written gets error=10
> [ 6052.708339] md: super_written gets error=10
> [ 6052.708342] md: super_written gets error=10
> [ 6052.708345] md: super_written gets error=10
> [ 6052.863797] md/raid:md3: Disk failure on md11, disabling device.
> [ 6052.863797] md/raid:md3: Operation continuing on 1 devices.
> [ 6052.876160] md: super_written gets error=10
> [ 6052.952148] BTRFS error (device dm-2): bdev /dev/mapper/Cached-Nearline
> errs: wr 0, rd 2, flush 0, corrupt 1386, gen 0
> [ 6061.276923] scsi_io_completion: 19 callbacks suppressed
> [ 6061.276931] sd 8:0:0:0: [sdf] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6061.291567] sd 8:0:0:0: [sdf] tag#1 CDB: ATA command pass through(16) 85
> 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6061.302830] sd 8:0:1:0: [sdg] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6061.312038] sd 8:0:1:0: [sdg] tag#1 CDB: ATA command pass through(16) 85
> 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6061.323365] sd 8:0:2:0: [sdh] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6061.332506] sd 8:0:2:0: [sdh] tag#1 CDB: ATA command pass through(16) 85
> 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6061.343694] sd 8:0:3:0: [sdi] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6061.352870] sd 8:0:3:0: [sdi] tag#1 CDB: ATA command pass through(16) 85
> 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6061.364089] sd 8:0:4:0: [sdj] tag#1 FAILED Result: hostbyte=DID_BAD_TA[
> 6177.422414] ata12.00: READ LOG DMA EXT failed, trying                  PIO
> [ 6177.430132] ata12: failed to read log page 10h (errno=-5)
> [ 6177.435874] ata12.00: exception Emask 0x1 SAct 0x100 SErr 0x0 action 0x6
> [ 6177.442888] ata12.00: failed command: WRITE FPDMA QUEUED
> [ 6177.448559] ata12.00: cmd 61/00:00:00:9c:87/04:00:03:00:00/40 tag 8 ncq
> dma 524288 out
> [ 6177.448559]          res 01/04:28:00:90:87/00:00:03:00:00/40 Emask 0x3
> (HSM violation)
> [ 6177.465325] ata12.00: status: { ERR }
> [ 6177.469280] ata12.00: error: { ABRT }
> [ 6177.473241] ata12: hard resetting link
> [ 6177.633798] ata12.00: revalidation failed (errno=-2)
> [ 6183.120702] ata12: hard resetting link
> [ 6183.281507] ata12.00: revalidation failed (errno=-2)
> [ 6188.752946] ata12: hard resetting link
> [ 6188.914274] ata12.00: revalidation failed (errno=-2)
> [ 6188.919573] ata12.00: disabled
> [ 6188.922908] ata12: EH complete
> [ 6188.926300] sd 8:0:5:0: [sdk] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6188.935487] sd 8:0:5:0: [sdk] tag#0 CDB: Write(10) 2a 00 03 87 9c 00 00
> 04 00 00
> [ 6188.943343] print_req_error: 21 callbacks suppressed
> [ 6188.943344] print_req_error: I/O error, dev sdk, sector 59218944
> [ 6188.958210] sd 8:0:5:0: [sdk] Read Capacity(16) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6188.968614] sd 8:0:5:0: [sdk] Sense not available.
> [ 6188.973825] sd 8:0:5:0: [sdk] Read Capacity(10) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6188.984201] sd 8:0:5:0: [sdk] Sense not available.
> [ 6188.989491] sd 8:0:5:0: [sdk] 0 512-byte logical blocks: (0 B/0 B)
> [ 6188.995971] sd 8:0:5:0: [sdk] 4096-byte physical blocks
> [ 6189.003657] sd 8:0:5:0: [sdk] Write Protect is on
> [ 6189.008743] sdk: detected capacity change from 1000204886016 to 0
> [ 6189.020410] sd 8:0:5:0: [sdk] Read Capacity(16) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6189.030785] sd 8:0:5:0: [sdk] Sense not available.
> [ 6189.035992] sd 8:0:5:0: [sdk] Read Capacity(10) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6189.046285] sd 8:0:5:0: [sdk] Sense not available.
> [ 6189.052054] sd 8:0:5:0: [sdk] Write Protect is off
> [ 6189.057189] sd 8:0:5:0: [sdk] Read Capacity(16) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6189.067506] sd 8:0:5:0: [sdk] Sense not available.
> [ 6189.072593] sd 8:0:5:0: [sdk] Read Capacity(10) failed: Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6189.082963] sd 8:0:5:0: [sdk] Sense not available.
> [ 6316.346847] sd 8:0:7:0: [sdm] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6316.356052] sd 8:0:7:0: [sdm] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6316.367499] sd 8:0:1:0: [sdg] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6316.376623] sd 8:0:1:0: [sdg] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6316.547174] sd 9:0:0:0: [sdn] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6316.556374] sd 9:0:0:0: [sdn] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6317.159659] sd 8:0:5:0: [sdk] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6317.168952] sd 8:0:5:0: [sdk] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6317.180446] sd 9:0:1:0: [sdo] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6317.189624] sd 9:0:1:0: [sdo] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6317.545089] sd 8:0:0:0: [sdf] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6317.554330] sd 8:0:0:0: [sdf] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6317.565590] sd 8:0:6:0: [sdl] tag#1 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6317.574766] sd 8:0:6:0: [sdl] tag#1 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6317.664541] sd 9:0:3:0: [sdq] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6317.673745] sd 9:0:3:0: [sdq] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6317.685773] sd 8:0:3:0: [sdi] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6317.695050] sd 8:0:3:0: [sdi] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [ 6318.314910] sd 8:0:4:0: [sdj] tag#0 FAILED Result:
> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> [ 6318.324134] sd 8:0:4:0: [sdj] tag#0 CDB: ATA command pass through(16) 85
> 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> 
