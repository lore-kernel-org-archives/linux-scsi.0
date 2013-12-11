From: Bart Van Assche <bvanassche@acm.org>
Subject: qla2xxx: kernel oops with ql2xmultique_tag=1
Date: Wed, 11 Dec 2013 13:18:58 +0100
Message-ID: <52A85832.2050701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:38688 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LKMTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2013 07:19:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

Hello,

Apparently trying to load the qla2xxx kernel module with parameter
ql2xmultique_tag=1 triggers a kernel oops. This is 100% reproducible
with at least kernel versions 3.11.8 and 3.13-rc3. Has anybody else
run into this before ?

Thanks,

Bart.

# rmmod qla2xxx; dmesg -c >/dev/null; insmod /lib/modules/3.13.0-rc3+/kernel/drivers/scsi/qla2xxx/qla2xxx.ko ql2xmultique_tag=1; ql2xextended_error_logging=0x40100000; dmesg -c
Segmentation fault

qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.06.00.08-k-debug.
qla2xxx [0000:01:00.0]-0807: : Mem only adapter.
qla2xxx [0000:01:00.0]-0808: : Bars=74.
qla2xxx [0000:01:00.0]-080a: : Memory allocated for ha=ffff8800bf148000.
qla2xxx [0000:01:00.0]-080b: : device_type=0x9c000800 port=1 fw_srisc_address=0x100000.
qla2xxx [0000:01:00.0]-081e: : mbx_count=32, req_length=2048, rsp_length=512, max_loop_id=2047, init_cb_size=5252, gid_list_info_size=8, optrom_size=2097152, nvram_npiv_size=256, max_fibre_devices=2048.
qla2xxx [0000:01:00.0]-081f: : isp_ops=ffffffffa056ca80, flash_conf_off=2147287040, flash_data_off=2146435072, nvram_conf_off=2147418112, nvram_data_off=2147352576.
qla2xxx [0000:01:00.0]-0818: : MQIO Base=ffffc90015080000.
qla2xxx [0000:01:00.0]-001a: : MSI-X vector count: 31.
qla2xxx [0000:01:00.0]-081c: : MSIX Count:6.
qla2xxx [0000:01:00.0]-001d: : Found an ISP2532 irq 16 iobase 0xffffc9000007a000.
qla2xxx [0000:01:00.0]-0820: : 64 Bit addressing is enable.
qla2xxx [0000:01:00.0]-0822: : init_cb=ffff8800877ba000 gid_list=ffff88008dfac000, srb_mempool=ffff88008dffeeb8 s_dma_pool=ffff88008dffe080.
qla2xxx [0000:01:00.0]-0825: : dl_dma_pool=ffff88008dfff2c8 fcp_cmnd_dma_pool=ffff88008dffc820.
qla2xxx [0000:01:00.0]-0827: : ms_iocb=ffff8800872e4000 ct_sns=ffff8800d7b98000.
qla2xxx [0000:01:00.0]-082c: : req=ffff88008dffc208 req->length=2048 req->ring=ffff880087240000 rsp=ffff8800bdcf9b60 rsp->length=512 rsp->ring=ffff88008df70000.
qla2xxx [0000:01:00.0]-0923: : loop_id_map=ffff8800bdcf8ff8.
qla2xxx [0000:01:00.0]-0841:16: Allocated the host=ffff8800d36bb3d8 hw=ffff8800bf148000 vha=ffff8800d36bbd50 dev_name=0000:01:00.0
qla2xxx [0000:01:00.0]-0832:16: can_queue=2176, req=ffff88008dffc208, mgmt_svr_loop_id=10, sg_tablesize=1024.
qla2xxx [0000:01:00.0]-0833:16: max_id=2048 this_id=-1 cmd_per_len=3 unique_id=16 max_cmd_len=16 max_channel=0 max_lun=65535 transportt=ffff8800a971d668, vendor_id=72057594037932151.
qla2xxx 0000:01:00.0: irq 49 for MSI/MSI-X
qla2xxx 0000:01:00.0: irq 50 for MSI/MSI-X
qla2xxx 0000:01:00.0: irq 67 for MSI/MSI-X
qla2xxx 0000:01:00.0: irq 68 for MSI/MSI-X
qla2xxx 0000:01:00.0: irq 69 for MSI/MSI-X
qla2xxx 0000:01:00.0: irq 70 for MSI/MSI-X
general protection fault: 0000 [#1] SMP
Modules linked in: qla2xxx(+) fuse ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables af_packet bridge stp llc rdma_ucm rdma_cm iw_cm ib_addr ib_srp scsi_transport_srp scsi_tgt ib_ipoib ib_cm ib_uverbs ib_umad mlx4_en mlx4_ib ib_sa ib_mad ib_core hid_generic usbhid hid snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec r8169 snd_hwdep snd_pcm x86_pkg_temp_thermal kvm_intel snd_seq kvm mii crc32c_intel snd_timer snd_seq_device i2c_i801 mlx4_core snd lpc_ich sr_mod pcspkr mfd_core microcode soundcore ehci_pci snd_page_alloc sg cdrom acpi_cpufreq ehci_hcd scsi_transport_fc wmi autofs4 ext4 jbd2 mbcache crc16 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid0 raid1 sd_mod crc_t10dif crct10dif_common ahci
  xhci_hcd libahci usbcore usb_common i915 drm_kms_helper drm intel_agp i2c_algo_bit intel_gtt agpgart i2c_core fan thermal video button processor thermal_sys hwmon scsi_dh_alua scsi_dh pata_
 acpi liba
ta scsi_mod [last unloaded: qla2xxx]
CPU: 3 PID: 4173 Comm: insmod Tainted: G        W    3.13.0-rc3+ #1
Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Z68X-UD3H-B3, BIOS U1l 03/08/2013
task: ffff8800a80cb330 ti: ffff880087740000 task.ti: ffff880087740000
RIP: 0010:[<ffffffff812484ad>]  [<ffffffff812484ad>] strnlen+0xd/0x40
RSP: 0018:ffff880087741758  EFLAGS: 00010286
RAX: ffffffff817800c2 RBX: ffff880087741888 RCX: fffffffffffffffe
RDX: 5f78783532616c71 RSI: ffffffffffffffff RDI: 5f78783532616c71
RBP: ffff880087741758 R08: 000000000000ffff R09: 000000000000ffff
R10: 0000000000000000 R11: 0000000000000001 R12: 5f78783532616c71
R13: ffff880087741908 R14: 000000000000ffff R15: 0000000000000000
FS:  00007fdd76627700(0000) GS:ffff88011f380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdd75d5b00f CR3: 00000000bf270000 CR4: 00000000000407e0
Stack:
ffff880087741798 ffffffff81249f0e ffff88011a814000 ffff880087741888
ffff880087741908 ffff880087741830 ffffffff8177d4ab ffffffff8177d4ab
ffff880087741818 ffffffff8124bcf9 0000000000000000 0000000000000000
Call Trace:
[<ffffffff81249f0e>] string.isra.3+0x3e/0xd0
[<ffffffff8124bcf9>] vsnprintf+0x309/0x5f0
[<ffffffff8124c084>] snprintf+0x34/0x40
[<ffffffff810964ed>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff810a4c6d>] register_handler_proc+0xed/0x120
[<ffffffff810a1303>] __setup_irq+0x263/0x540
[<ffffffff810a16b7>] request_threaded_irq+0xd7/0x180
[<ffffffffa0519b2c>] qla2x00_request_irqs+0x28c/0x6d0 [qla2xxx]
[<ffffffffa04f6f09>] qla2x00_probe_one+0xc29/0x22e0 [qla2xxx]
[<ffffffff8131bcce>] ? __pm_runtime_resume+0x4e/0xa0
[<ffffffff8109641d>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[<ffffffff810964ed>] ? trace_hardirqs_on+0xd/0x10
[<ffffffff8127674c>] pci_device_probe+0x9c/0xf0
[<ffffffff8131334b>] driver_probe_device+0x8b/0x390
[<ffffffff813136fb>] __driver_attach+0xab/0xb0
[<ffffffff81313650>] ? driver_probe_device+0x390/0x390
[<ffffffff813112dd>] bus_for_each_dev+0x5d/0xa0
[<ffffffff81312cae>] driver_attach+0x1e/0x20
[<ffffffff813128d7>] bus_add_driver+0x127/0x250
[<ffffffffa08ae000>] ? 0xffffffffa08adfff
[<ffffffff81313ba4>] driver_register+0x64/0xf0
[<ffffffffa08ae000>] ? 0xffffffffa08adfff
[<ffffffff81276024>] __pci_register_driver+0x64/0x70
[<ffffffffa08ae000>] ? 0xffffffffa08adfff
[<ffffffffa08ae1ce>] qla2x00_module_init+0x1ce/0x21d [qla2xxx]
[<ffffffff810002ea>] do_one_initcall+0xda/0x180
[<ffffffff8103da73>] ? set_memory_nx+0x43/0x50
[<ffffffff8148beb2>] ? set_section_ro_nx+0x6d/0x74
[<ffffffff810c00ff>] load_module+0x1caf/0x2750
[<ffffffff810bb840>] ? __unlink_module+0x30/0x30
[<ffffffff81140cdf>] ? might_fault+0x5f/0xb0
[<ffffffff810c0c4e>] SyS_init_module+0xae/0x110
[<ffffffff8149f722>] tracesys+0xd0/0xd5
Code: c0 01 80 38 00 75 f7 48 29 f8 5d c3 31 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 4e ff 48 85 f6 48 89 e5 74 2a <80> 3f 00 74 25 48 89 f8 31 d2 eb 10 0f 1f 80 00 00 00 00 48 83
RIP  [<ffffffff812484ad>] strnlen+0xd/0x40
RSP <ffff880087741758>
---[ end trace 2f850debe173d2e4 ]---
