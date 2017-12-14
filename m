From: Marc MERLIN <marc@merlins.org>
Subject: Re: 4.13.12: frequent AACraid crash with a drive
Date: Wed, 13 Dec 2017 21:24:44 -0800
Message-ID: <20171214052444.z2vkkg3n55jpfcab@merlins.org>
References: <5a2a7bd8.DIb2xBKbe4y+P6We%temnota.am@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35666 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdLNFYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 00:24:51 -0500
Content-Disposition: inline
In-Reply-To: <5a2a7bd8.DIb2xBKbe4y+P6We%temnota.am@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Dec 08, 2017 at 02:47:36PM +0300, Andrey Jr. Melnikov wrote:
> In article <20171127152421.GA5171@merlins.org> you wrote:
> > On Mon, Nov 27, 2017 at 07:21:47AM -0800, Marc MERLIN wrote:
> > > Crash log:
> 
> > I should add that sometimes the reset works ok:
> > aacraid: Host adapter abort request.
> > aacraid: Outstanding commands on (10,1,0,0):
> > aacraid: Host adapter reset request. SCSI hang ?
> > aacraid 0000:02:00.0: outstanding cmd: midlevel-0
> > aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
> > aacraid 0000:02:00.0: outstanding cmd: error handler-1
> > aacraid 0000:02:00.0: outstanding cmd: firmware-0
> > aacraid 0000:02:00.0: outstanding cmd: kernel-0
> > aacraid 0000:02:00.0: Controller reset type is 3
> > aacraid 0000:02:00.0: Issuing IOP reset
> > aacraid 0000:02:00.0: IOP reset succeded
> > aacraid: Comm Interface type2 enabled
> > aacraid 0000:02:00.0: Issuing bus rescan
> > sd 10:1:0:0: [sdd] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
> > sd 10:1:0:0: [sdd] tag#0 CDB: ATA command pass through(16) 85 06 20 00 d8 00 00 00 00 00 4f 00 c2 00 b0 00
> 
> > The drive in question seems ok when I test it directly, but it's hard to tell for sure.
> 
> Use 'arcconf GETLOGS 1 DEVICE' and 'arcconf GETLOGS 1 EVENT' to see what happens.
> And arcconf have 'hidden' command 'arcconf GETLOGS 1 UART' which fetch last 2Mb controller console logs. 
> May be it's help to understand what is wrong.

So, things hung today with 4.13 and the patch you suggested.
-       if (aac->thread->pid != current->pid) {
+       if (aac->aif_thread && aac->thread->pid != current->pid) {

arcconf GETLOGS 1 DEVICE never ran or never completed, I'm not very sure.
Eventually the kernel went into a hard lockup.

[  780.924146] aacraid 0000:02:00.0: outstanding cmd: error handler-1
[  780.942717] aacraid 0000:02:00.0: outstanding cmd: firmware-0
[  780.959965] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[  780.976726] aacraid 0000:02:00.0: Controller reset type is 3
[  780.993741] aacraid 0000:02:00.0: Issuing IOP reset
[  810.364663] aacraid 0000:02:00.0: IOP reset succeded
[  810.403457] aacraid: Comm Interface type2 enabled
[  819.445691] aacraid 0000:02:00.0: Issuing bus rescan
[  829.663308] sd 10:1:2:0: [sde] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[  829.688926] sd 10:1:2:0: [sde] tag#0 CDB: ATA command pass through(16) 85 06 20 00 d8 00 00 00 00 00 4f 00 c2 00 b0 00
[ 3849.880205] aacraid: Host adapter abort request.
[ 3849.880205] aacraid: Outstanding commands on (10,1,2,0):
[ 3849.910020] aacraid: Host adapter reset request. SCSI hang ?
[ 3849.927134] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 3849.944606] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 3849.961941] aacraid 0000:02:00.0: outstanding cmd: error handler-1
[ 3849.980673] aacraid 0000:02:00.0: outstanding cmd: firmware-0
[ 3849.998174] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[ 3850.015095] aacraid 0000:02:00.0: Controller reset type is 3
[ 3850.032219] aacraid 0000:02:00.0: Issuing IOP reset
[ 3878.373788] aacraid 0000:02:00.0: IOP reset succeded
[ 3878.413062] aacraid: Comm Interface type2 enabled
[ 3887.465850] aacraid 0000:02:00.0: Issuing bus rescan
[ 3897.609211] sd 10:1:2:0: [sde] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 3897.634845] sd 10:1:2:0: [sde] tag#0 CDB: ATA command pass through(16) 85 06 20 00 d8 00 00 00 00 00 4f 00 c2 00 b0 00
[ 4763.539277] nf_conntrack: default automatic helper assignment has been turned off for security reasons and CT-based  firewall rule not found. Use the iptables CT target to attach helpers instead.
[ 5431.337215] perf: interrupt took too long (2504 > 2500), lowering kernel.perf_event_max_sample_rate to 79750
[ 6916.866506] aacraid: Host adapter abort request.
[ 6916.866506] aacraid: Outstanding commands on (10,1,2,0):
[ 6916.897314] aacraid: Host adapter reset request. SCSI hang ?
[ 6916.915264] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 6916.933419] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 6916.951388] aacraid 0000:02:00.0: outstanding cmd: error handler-1
[ 6916.970849] aacraid 0000:02:00.0: outstanding cmd: firmware-0
[ 6916.988710] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[ 6917.006110] aacraid 0000:02:00.0: Controller reset type is 3
[ 6917.023850] aacraid 0000:02:00.0: Issuing IOP reset
[ 6945.930659] aacraid 0000:02:00.0: IOP reset succeded
[ 6945.971388] aacraid: Comm Interface type2 enabled
[ 6955.022216] aacraid 0000:02:00.0: Issuing bus rescan
[ 6965.043384] sd 10:1:2:0: [sde] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 6965.069561] sd 10:1:2:0: [sde] tag#0 CDB: ATA command pass through(16) 85 06 20 00 d8 00 00 00 00 00 4f 00 c2 00 b0 00
[ 7583.915855] aacraid: Host adapter abort request.
[ 7583.915855] aacraid: Outstanding commands on (10,1,2,0):
[ 7583.946916] aacraid: Host adapter reset request. SCSI hang ?
[ 7583.964678] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 7583.982846] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 7584.000738] aacraid 0000:02:00.0: outstanding cmd: error handler-1
[ 7584.019938] aacraid 0000:02:00.0: outstanding cmd: firmware-0
[ 7584.037851] aacraid 0000:02:00.0: outstanding cmd: kernel-0
[ 7584.055265] aacraid 0000:02:00.0: Controller reset type is 3
[ 7584.072886] aacraid 0000:02:00.0: Issuing IOP reset
[ 7654.304833] aacraid 0000:02:00.0: IOP reset failed

Looks like getting EVENT hung things more?
gargamel:~# arcconf GETLOGS 1 EVENT
[ 7709.761618] aacraid: Host adapter abort request.
[ 7709.761618] aacraid: Outstanding commands on (10,1,2,0):
[ 7709.793114] aacraid: Host adapter reset request. SCSI hang ?
[ 7709.810694] aacraid 0000:02:00.0: Adapter health - -3
[ 7709.826449] aacraid 0000:02:00.0: outstanding cmd: midlevel-0
[ 7709.844273] aacraid 0000:02:00.0: outstanding cmd: lowlevel-0
[ 7709.862112] aacraid 0000:02:00.0: outstanding cmd: error handler-1
[ 7709.881215] aacraid 0000:02:00.0: outstanding cmd: firmware-0
[ 7709.899024] aacraid 0000:02:00.0: outstanding cmd: kernel-5
[ 7709.916314] aacraid 0000:02:00.0: Controller reset type is 3
[ 7709.933868] aacraid 0000:02:00.0: Issuing IOP reset
[ 7709.949074] BUG: scheduling while atomic: scsi_eh_10/402/0x00000002
[ 7709.968433] Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_cmipci snd_hda_codec snd_mpu401_uart eeepc_wmi snd_opl3_lib asus_wmi snd_hda_core snd_rawmidi sparse_keymap snd_seq_device snd_hwdep rfkill snd_pcm asix h
 wmon snd_timer
[ 7710.185358]  usbnet rc_ati_x10 tpm_infineon wmi_bmof tpm_tis ati_remote parport_pc tpm_tis_core snd rc_core libphy i915 i2c_i801 usbserial mei_me parport pcspkr tpm soundcore wmi battery lpc_ich evdev input_leds e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci xhci_hcd ehci_hcd r8169 aacraid sata_sil24 mii usbcore fan thermal [last unloaded: ftdi_sio]
[ 7710.340683] CPU: 5 PID: 402 Comm: scsi_eh_10 Tainted: G     U          4.13.12-amd64-acraid-sysrq-20171018 #3
[ 7710.371133] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 7710.399228] Call Trace:
[ 7710.407307]  dump_stack+0x61/0x7d
[ 7710.418024]  __schedule_bug+0x5c/0x6a
[ 7710.429813]  __schedule+0x70/0x5c5
[ 7710.440796]  ? __mod_timer+0x1be/0x1e4
[ 7710.452783]  schedule+0x89/0x9a
[ 7710.462951]  schedule_timeout+0xc1/0x101
[ 7710.475454]  ? call_timer_fn+0x140/0x140
[ 7710.487977]  schedule_timeout_uninterruptible+0x1f/0x21
[ 7710.504441]  ? schedule_timeout_uninterruptible+0x1f/0x21
[ 7710.521319]  msleep+0x1b/0x22
[ 7710.530940]  src_sync_cmd+0x13f/0x22f [aacraid]
[ 7710.545277]  ? aac_nark_init+0x26/0x26 [aacraid]
[ 7710.559854]  aac_src_restart_adapter+0x10f/0x29d [aacraid]
[ 7710.577022]  aac_reset_adapter+0x1b3/0x709 [aacraid]
[ 7710.592646]  aac_eh_reset+0x396/0x3aa [aacraid]
[ 7710.606966]  scsi_try_host_reset+0x5d/0xb1
[ 7710.620021]  scsi_send_eh_cmnd+0x296/0x2dc
[ 7710.633067]  ? __call_rcu.constprop.44+0x10d/0x188
[ 7710.648208]  ? schedule_timeout+0xca/0x101
[ 7710.661220]  scsi_eh_try_stu+0x53/0x7a
[ 7710.673209]  scsi_eh_test_devices+0xcd/0x16e
[ 7710.686765]  scsi_eh_ready_devs+0x824/0x8c4
[ 7710.700118]  scsi_error_handler+0x291/0x523
[ 7710.713404]  ? __schedule+0x4f5/0x5c5
[ 7710.725119]  ? scsi_eh_get_sense+0x1a9/0x1a9
[ 7710.738643]  kthread+0xfb/0x100
[ 7710.748797]  ? init_completion+0x24/0x24
[ 7710.761327]  ? do_fast_syscall_32+0xb7/0xfe
[ 7710.774624]  ret_from_fork+0x25/0x30


I never got my shell back after the first arcconf command, and then got this:
[ 7734.334018] INFO: task nfsd:9608 blocked for more than 120 seconds.
[ 7734.354311]       Tainted: G     U  W       4.13.12-amd64-acraid-sysrq-20171018 #3
[ 7734.378095] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7734.402398] nfsd            D    0  9608      2 0x00000080
[ 7734.420088] Call Trace:
[ 7734.428262]  __schedule+0x4bb/0x5c5
[ 7734.439559]  schedule+0x89/0x9a
[ 7734.449732]  io_schedule+0x16/0x38
[ 7734.460653]  wait_on_page_bit_common+0x112/0x19b
[ 7734.475177]  ? file_check_and_advance_wb_err+0xc5/0xc5
[ 7734.491257]  wait_on_page_bit+0x3b/0x3d
[ 7734.503394]  read_extent_buffer_pages+0x1c4/0x224
[ 7734.518132]  ? free_root_pointers+0x64/0x64
[ 7734.531253]  btree_read_extent_buffer_pages+0x5d/0xef
[ 7734.547009]  read_tree_block+0x33/0x4e
[ 7734.558856]  read_block_for_search.isra.20+0x211/0x264
[ 7734.574820]  btrfs_search_slot+0x50a/0x70d
[ 7734.587690]  btrfs_lookup_csum+0x52/0xf7
[ 7734.600008]  __btrfs_lookup_bio_sums+0x20f/0x449
[ 7734.614430]  ? kmem_cache_alloc+0xcc/0x143
[ 7734.627263]  btrfs_lookup_bio_sums+0x16/0x18
[ 7734.640619]  btrfs_submit_bio_hook+0xce/0x149
[ 7734.654232]  submit_one_bio+0x5e/0x84
[ 7734.665797]  submit_extent_page+0xa1/0x1c9
[ 7734.678717]  __do_readpage+0x51a/0x5ac
[ 7734.690521]  ? btrfs_create_repair_bio+0xb9/0xb9
[ 7734.704932]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7734.724283]  __do_contiguous_readpages.constprop.29+0xc8/0xec
[ 7734.742094]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7734.761467]  __extent_readpages.constprop.28+0xea/0xfd
[ 7734.777419]  ? lru_cache_add+0xe/0x10

[ 7734.788962]  extent_readpages+0x139/0x1eb
[ 7734.801544]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7734.820908]  btrfs_readpages+0x1f/0x21
[ 7734.832693]  __do_page_cache_readahead+0x1af/0x27b
[ 7734.847610]  ? wb_congested+0x16/0x26 [bcache]
[ 7734.861514]  ondemand_readahead+0x21e/0x22f
[ 7734.874634]  ? ondemand_readahead+0x21e/0x22f
[ 7734.888255]  page_cache_async_readahead+0x63/0x6c
[ 7734.902935]  generic_file_read_iter+0x225/0x552
[ 7734.917086]  generic_file_splice_read+0xd1/0x140
[ 7734.931509]  do_splice_to+0x7d/0x87
[ 7734.942544]  splice_direct_to_actor+0xcc/0x1bd
[ 7734.956807]  ? commit_metadata+0x44/0x44 [nfsd]
[ 7734.971006]  nfsd_splice_read+0x68/0x92 [nfsd]
[ 7734.984884]  nfsd_read+0x117/0x260 [nfsd]
[ 7734.997459]  nfsd3_proc_read+0xc8/0x113 [nfsd]
[ 7735.011330]  nfsd_dispatch+0xfc/0x1d8 [nfsd]
[ 7735.024690]  svc_process_common+0x2e7/0x4f7 [sunrpc]
[ 7735.040137]  ? nfsd_destroy+0x68/0x68 [nfsd]
[ 7735.053502]  svc_process+0xdb/0x115 [sunrpc]
[ 7735.066852]  nfsd+0x100/0x157 [nfsd]
[ 7735.078413]  kthread+0xfb/0x100
[ 7735.088373]  ? init_completion+0x24/0x24
[ 7735.100667]  ret_from_fork+0x25/0x30
[ 7735.111925] INFO: task nfsd:9610 blocked for more than 120 seconds.
[ 7735.131252]       Tainted: G     U  W       4.13.12-amd64-acraid-sysrq-20171018 #3
[ 7735.154754] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7735.178759] nfsd            D    0  9610      2 0x00000080
[ 7735.195779] Call Trace:
[ 7735.203672]  __schedule+0x4bb/0x5c5
[ 7735.214765]  schedule+0x89/0x9a
[ 7735.224727]  io_schedule+0x16/0x38
[ 7735.235499]  wait_on_page_bit_common+0x112/0x19b
[ 7735.249901]  ? file_check_and_advance_wb_err+0xc5/0xc5
[ 7735.265859]  __lock_page+0x40/0x42
[ 7735.276666]  lock_page+0x19/0x1c
[ 7735.286899]  read_extent_buffer_pages+0x90/0x224
[ 7735.301320]  ? free_root_pointers+0x64/0x64
[ 7735.314403]  btree_read_extent_buffer_pages+0x5d/0xef
[ 7735.330120]  btrfs_read_buffer+0x33/0x35
[ 7735.342764]  read_block_for_search.isra.20+0xa6/0x264
[ 7735.358783]  ? _raw_read_unlock+0xe/0x1e
[ 7735.371138]  btrfs_search_slot+0x50a/0x70d
[ 7735.383975]  btrfs_lookup_csum+0x52/0xf7
[ 7735.396267]  __btrfs_lookup_bio_sums+0x20f/0x449
[ 7735.410988]  ? kmem_cache_alloc+0xcc/0x143
[ 7735.423839]  btrfs_lookup_bio_sums+0x16/0x18
[ 7735.437195]  btrfs_submit_bio_hook+0xce/0x149
[ 7735.450803]  submit_one_bio+0x5e/0x84
[ 7735.462341]  submit_extent_page+0xa1/0x1c9
[ 7735.475436]  __do_readpage+0x51a/0x5ac
[ 7735.487227]  ? btrfs_create_repair_bio+0xb9/0xb9
[ 7735.501597]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7735.520894]  __do_contiguous_readpages.constprop.29+0xc8/0xec
[ 7735.538671]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7735.558299]  __extent_readpages.constprop.28+0xea/0xfd
[ 7735.574267]  ? lru_cache_add+0xe/0x10
[ 7735.585781]  extent_readpages+0x139/0x1eb
[ 7735.598371]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7735.617726]  btrfs_readpages+0x1f/0x21
[ 7735.629542]  __do_page_cache_readahead+0x1af/0x27b
[ 7735.644462]  ondemand_readahead+0x21e/0x22f
[ 7735.657572]  ? ondemand_readahead+0x21e/0x22f
[ 7735.671469]  page_cache_sync_readahead+0x3d/0x3f
[ 7735.685870]  generic_file_read_iter+0x1e9/0x552
[ 7735.700029]  generic_file_splice_read+0xd1/0x140
[ 7735.714496]  do_splice_to+0x7d/0x87
[ 7735.725527]  splice_direct_to_actor+0xcc/0x1bd
[ 7735.739427]  ? commit_metadata+0x44/0x44 [nfsd]
[ 7735.753910]  nfsd_splice_read+0x68/0x92 [nfsd]
[ 7735.768024]  nfsd_read+0x117/0x260 [nfsd]
[ 7735.780650]  nfsd3_proc_read+0xc8/0x113 [nfsd]
[ 7735.794556]  nfsd_dispatch+0xfc/0x1d8 [nfsd]
[ 7735.807934]  svc_process_common+0x2e7/0x4f7 [sunrpc]
[ 7735.823372]  ? nfsd_destroy+0x68/0x68 [nfsd]
[ 7735.836719]  svc_process+0xdb/0x115 [sunrpc]
[ 7735.850052]  nfsd+0x100/0x157 [nfsd]
[ 7735.861318]  kthread+0xfb/0x100
[ 7735.871543]  ? init_completion+0x24/0x24
[ 7735.884112]  ret_from_fork+0x25/0x30
[ 7735.895356] INFO: task nfsd:9611 blocked for more than 120 seconds.
[ 7735.914651]       Tainted: G     U  W       4.13.12-amd64-acraid-sysrq-20171018 #3
[ 7735.937899] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7735.961908] nfsd            D    0  9611      2 0x00000080
[ 7735.978909] Call Trace:
[ 7735.986809]  __schedule+0x4bb/0x5c5
[ 7735.997799]  schedule+0x89/0x9a
[ 7736.007766]  io_schedule+0x16/0x38
[ 7736.018497]  wait_on_page_bit_common+0x112/0x19b
[ 7736.032871]  ? file_check_and_advance_wb_err+0xc5/0xc5
[ 7736.048829]  wait_on_page_bit+0x3b/0x3d
[ 7736.060899]  read_extent_buffer_pages+0x1c4/0x224
[ 7736.075588]  ? free_root_pointers+0x64/0x64
[ 7736.088698]  btree_read_extent_buffer_pages+0x5d/0xef
[ 7736.104393]  read_tree_block+0x33/0x4e
[ 7736.116248]  read_block_for_search.isra.20+0x211/0x264
[ 7736.132516]  btrfs_search_slot+0x50a/0x70d
[ 7736.145685]  btrfs_lookup_csum+0x52/0xf7
[ 7736.158020]  ? free_extent_buffer+0x78/0x7b
[ 7736.171108]  __btrfs_lookup_bio_sums+0x20f/0x449
[ 7736.185550]  btrfs_lookup_bio_sums+0x16/0x18
[ 7736.198979]  btrfs_submit_bio_hook+0xce/0x149
[ 7736.212619]  submit_one_bio+0x5e/0x84
[ 7736.224398]  submit_extent_page+0xa1/0x1c9
[ 7736.237205]  __do_readpage+0x51a/0x5ac
[ 7736.248978]  ? btrfs_create_repair_bio+0xb9/0xb9
[ 7736.263411]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7736.283011]  __do_contiguous_readpages.constprop.29+0xc8/0xec
[ 7736.301074]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7736.320434]  __extent_readpages.constprop.28+0xea/0xfd
[ 7736.336394]  ? lru_cache_add+0xe/0x10
[ 7736.347932]  extent_readpages+0x139/0x1eb
[ 7736.360487]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7736.379853]  btrfs_readpages+0x1f/0x21
[ 7736.391656]  __do_page_cache_readahead+0x1af/0x27b
[ 7736.406679]  ? wb_congested+0x16/0x26 [bcache]
[ 7736.420555]  ondemand_readahead+0x21e/0x22f
[ 7736.433650]  ? ondemand_readahead+0x21e/0x22f
[ 7736.447580]  page_cache_async_readahead+0x63/0x6c
[ 7736.462543]  generic_file_read_iter+0x225/0x552
[ 7736.476703]  generic_file_splice_read+0xd1/0x140
[ 7736.491081]  do_splice_to+0x7d/0x87
[ 7736.502103]  splice_direct_to_actor+0xcc/0x1bd
[ 7736.515984]  ? commit_metadata+0x44/0x44 [nfsd]
[ 7736.530155]  nfsd_splice_read+0x68/0x92 [nfsd]
[ 7736.544032]  nfsd_read+0x117/0x260 [nfsd]
[ 7736.556613]  nfsd3_proc_read+0xc8/0x113 [nfsd]
[ 7736.570521]  nfsd_dispatch+0xfc/0x1d8 [nfsd]
[ 7736.583905]  svc_process_common+0x2e7/0x4f7 [sunrpc]
[ 7736.599369]  ? nfsd_destroy+0x68/0x68 [nfsd]
[ 7736.612992]  svc_process+0xdb/0x115 [sunrpc]
[ 7736.626614]  nfsd+0x100/0x157 [nfsd]
[ 7736.637834]  kthread+0xfb/0x100
[ 7736.647876]  ? init_completion+0x24/0x24
[ 7736.660154]  ret_from_fork+0x25/0x30
[ 7736.671386] INFO: task nfsd:9613 blocked for more than 120 seconds.
[ 7736.690702]       Tainted: G     U  W       4.13.12-amd64-acraid-sysrq-20171018 #3
[ 7736.714248] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7736.738295] nfsd            D    0  9613      2 0x00000080
[ 7736.755304] Call Trace:
[ 7736.763502]  __schedule+0x4bb/0x5c5
[ 7736.774792]  schedule+0x89/0x9a
[ 7736.784760]  io_schedule+0x16/0x38
[ 7736.795520]  wait_on_page_bit_common+0x112/0x19b
[ 7736.809917]  ? file_check_and_advance_wb_err+0xc5/0xc5
[ 7736.825853]  wait_on_page_bit+0x3b/0x3d
[ 7736.837887]  read_extent_buffer_pages+0x1c4/0x224
[ 7736.852834]  ? free_root_pointers+0x64/0x64
[ 7736.865934]  btree_read_extent_buffer_pages+0x5d/0xef
[ 7736.881692]  read_tree_block+0x33/0x4e
[ 7736.893508]  read_block_for_search.isra.20+0x211/0x264
[ 7736.909697]  btrfs_search_slot+0x50a/0x70d
[ 7736.922872]  btrfs_lookup_csum+0x52/0xf7
[ 7736.935519]  __btrfs_lookup_bio_sums+0x20f/0x449
[ 7736.949927]  ? kmem_cache_alloc+0xcc/0x143
[ 7736.962790]  btrfs_lookup_bio_sums+0x16/0x18
[ 7736.976152]  btrfs_submit_bio_hook+0xce/0x149
[ 7736.989845]  submit_one_bio+0x5e/0x84
[ 7737.001621]  submit_extent_page+0xa1/0x1c9
[ 7737.014484]  __do_readpage+0x51a/0x5ac
[ 7737.026276]  ? btrfs_create_repair_bio+0xb9/0xb9
[ 7737.040652]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7737.060002]  __do_contiguous_readpages.constprop.29+0xc8/0xec
[ 7737.077807]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7737.097455]  __extent_readpages.constprop.28+0xea/0xfd
[ 7737.113718]  ? lru_cache_add+0xe/0x10
[ 7737.125258]  extent_readpages+0x139/0x1eb
[ 7737.138117]  ? insert_reserved_file_extent.constprop.38+0x29b/0x29b
[ 7737.157756]  btrfs_readpages+0x1f/0x21
[ 7737.169587]  __do_page_cache_readahead+0x1af/0x27b
[ 7737.184789]  ondemand_readahead+0x21e/0x22f
[ 7737.197914]  ? ondemand_readahead+0x21e/0x22f
[ 7737.211567]  page_cache_sync_readahead+0x3d/0x3f
[ 7737.225997]  generic_file_read_iter+0x1e9/0x552
[ 7737.240149]  generic_file_splice_read+0xd1/0x140
[ 7737.254819]  do_splice_to+0x7d/0x87
[ 7737.266141]  splice_direct_to_actor+0xcc/0x1bd
[ 7737.280279]  ? commit_metadata+0x44/0x44 [nfsd]
[ 7737.294739]  nfsd_splice_read+0x68/0x92 [nfsd]
[ 7737.308895]  nfsd_read+0x117/0x260 [nfsd]
[ 7737.321499]  nfsd3_proc_read+0xc8/0x113 [nfsd]
[ 7737.335417]  nfsd_dispatch+0xfc/0x1d8 [nfsd]
[ 7737.348813]  svc_process_common+0x2e7/0x4f7 [sunrpc]
[ 7737.364279]  ? nfsd_destroy+0x68/0x68 [nfsd]
[ 7737.377661]  svc_process+0xdb/0x115 [sunrpc]
[ 7737.391048]  nfsd+0x100/0x157 [nfsd]
[ 7737.402341]  kthread+0xfb/0x100
[ 7737.412309]  ? init_completion+0x24/0x24
[ 7737.424833]  ret_from_fork+0x25/0x30                                                                      
[ 7785.122658] aacraid 0000:02:00.0: IOP reset failed
[ 7785.137536] aacraid 0000:02:00.0: ARC Reset attempt failed
[ 7807.293052] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
[ 7807.293054] Modules linked in: veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_cmipci snd_hda_codec snd_mpu401_uart eeepc_wmi snd_opl3_lib asus_wmi snd_hda_core snd_rawmidi sparse_keymap snd_seq_device snd_hwdep rfkill snd_pcm asix h
 wmon snd_timer
[ 7807.293072]  usbnet rc_ati_x10 tpm_infineon wmi_bmof tpm_tis ati_remote parport_pc tpm_tis_core snd rc_core libphy i915 i2c_i801 usbserial mei_me parport pcspkr tpm soundcore wmi battery lpc_ich evdev input_leds e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core lrw ablk_helper dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common pcbc aesni_intel aes_x86_64 crypto_simd glue_helper cryptd xhci_pci ehci_pci xhci_hcd ehci_hcd r8169 aacraid sata_sil24 mii usbcore fan thermal [last unloaded: ftdi_sio]
[ 7807.293089] CPU: 4 PID: 402 Comm: scsi_eh_10 Tainted: G     U  W       4.13.12-amd64-acraid-sysrq-20171018 #3
[ 7807.293089] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 7807.293090] task: ffff9cbdf4f441c0 task.stack: ffffb22043870000
[ 7807.293093] RIP: 0010:queued_spin_lock_slowpath+0x76/0x18c
[ 7807.293093] RSP: 0018:ffffb22043873b28 EFLAGS: 00000002
[ 7807.293094] RAX: 0000000000000101 RBX: 0000000000000246 RCX: 0000000000000101
[ 7807.293094] RDX: 0000000000000100 RSI: 0000000000000001 RDI: ffff9cbdf9f88030
[ 7807.293095] RBP: ffffb22043873b28 R08: 0000000000000001 R09: 0000000000000000
[ 7807.293095] R10: ffffb22043873a80 R11: ffffffffba899a20 R12: ffff9cbdf9f88000
[ 7807.293095] R13: 0000000000000000 R14: ffff9cbdf9f88000 R15: 0000000000000003
[ 7807.293096] FS:  0000000000000000(0000) GS:ffff9cbe1e300000(0000) knlGS:0000000000000000
[ 7807.293097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 7807.293097] CR2: 00000000dfb60000 CR3: 00000007aaf7d000 CR4: 00000000001406e0
[ 7807.293098] Call Trace:
[ 7807.293101]  _raw_spin_lock_irqsave+0x3d/0x44
[ 7807.293103]  __scsi_iterate_devices+0x2c/0x77
[ 7807.293105]  scsi_run_host_queues+0x2e/0x37
[ 7807.293106]  scsi_unblock_requests+0x15/0x17
[ 7807.293110]  aac_reset_adapter+0x5aa/0x709 [aacraid]
[ 7807.293112]  aac_eh_reset+0x396/0x3aa [aacraid]
[ 7807.293113]  scsi_try_host_reset+0x5d/0xb1
[ 7807.293114]  scsi_send_eh_cmnd+0x296/0x2dc
[ 7807.293117]  ? __call_rcu.constprop.44+0x10d/0x188
[ 7807.293119]  ? schedule_timeout+0xca/0x101
[ 7807.293120]  scsi_eh_try_stu+0x53/0x7a
[ 7807.293121]  scsi_eh_test_devices+0xcd/0x16e
[ 7807.293122]  scsi_eh_ready_devs+0x824/0x8c4
[ 7807.293123]  scsi_error_handler+0x291/0x523
[ 7807.293124]  ? __schedule+0x4f5/0x5c5
[ 7807.293126]  ? scsi_eh_get_sense+0x1a9/0x1a9
[ 7807.293126]  kthread+0xfb/0x100
[ 7807.293127]  ? init_completion+0x24/0x24
[ 7807.293129]  ? do_fast_syscall_32+0xb7/0xfe
[ 7807.293130]  ret_from_fork+0x25/0x30
[ 7807.293131] Code: 00 00 eb 02 89 c6 f7 c6 00 ff ff ff 75 2f 83 fe 01 89 ca 89 f0 41 0f 45 d0 f0 0f b1 17 39 c6 75 e3 ff ca 0f 84 16 01 00 00 8b 07 <84> c0 74 04 f3 90 eb f6 66 c7 07 01 00 e9 02 01 00 00 48 c7 c2
[ 7807.293141] Kernel panic - not syncing: Hard LOCKUP
[ 7807.293142] CPU: 4 PID: 402 Comm: scsi_eh_10 Tainted: G     U  W       4.13.12-amd64-acraid-sysrq-20171018 #3
[ 7807.293142] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
[ 7807.293142] Call Trace:
[ 7807.293143]  <NMI>
[ 7807.293144]  dump_stack+0x61/0x7d
[ 7807.293147]  panic+0xe7/0x235
[ 7807.293148]  ? 0xffffffffc0199000
[ 7807.293149]  nmi_panic+0x2c/0x37
[ 7807.293151]  watchdog_overflow_callback+0x104/0x119
[ 7807.293153]  __perf_event_overflow+0x78/0xbd
[ 7807.293154]  perf_event_overflow+0x14/0x16
[ 7807.293155]  intel_pmu_handle_irq+0x353/0x405
[ 7807.293158]  ? cycles_2_ns+0x52/0x72
[ 7807.293160]  perf_event_nmi_handler+0x2c/0x47
[ 7807.293161]  ? paravirt_sched_clock+0x9/0xd
[ 7807.293161]  ? sched_clock+0x9/0xb
[ 7807.293163]  ? perf_event_nmi_handler+0x2c/0x47
[ 7807.293165]  nmi_handle+0x55/0x119
[ 7807.293166]  default_do_nmi+0x4b/0xf5
[ 7807.293167]  do_nmi+0x9b/0x115
[ 7807.293168]  end_repeat_nmi+0x1a/0x1e
[ 7807.293169] RIP: 0010:queued_spin_lock_slowpath+0x76/0x18c
[ 7807.293169] RSP: 0018:ffffb22043873b28 EFLAGS: 00000002
[ 7807.293170] RAX: 0000000000000101 RBX: 0000000000000246 RCX: 0000000000000101
[ 7807.293170] RDX: 0000000000000100 RSI: 0000000000000001 RDI: ffff9cbdf9f88030
[ 7807.293171] RBP: ffffb22043873b28 R08: 0000000000000001 R09: 0000000000000000
[ 7807.293171] R10: ffffb22043873a80 R11: ffffffffba899a20 R12: ffff9cbdf9f88000
[ 7807.293171] R13: 0000000000000000 R14: ffff9cbdf9f88000 R15: 0000000000000003
[ 7807.293173]  ? queued_spin_lock_slowpath+0x76/0x18c
[ 7807.293174]  ? queued_spin_lock_slowpath+0x76/0x18c
[ 7807.293174]  </NMI>
[ 7807.293175]  _raw_spin_lock_irqsave+0x3d/0x44
[ 7807.293176]  __scsi_iterate_devices+0x2c/0x77
[ 7807.293177]  scsi_run_host_queues+0x2e/0x37
[ 7807.293178]  scsi_unblock_requests+0x15/0x17
[ 7807.293180]  aac_reset_adapter+0x5aa/0x709 [aacraid]
[ 7807.293182]  aac_eh_reset+0x396/0x3aa [aacraid]
[ 7807.293184]  scsi_try_host_reset+0x5d/0xb1
[ 7807.293185]  scsi_send_eh_cmnd+0x296/0x2dc
[ 7807.293186]  ? __call_rcu.constprop.44+0x10d/0x188
[ 7807.293187]  ? schedule_timeout+0xca/0x101
[ 7807.293188]  scsi_eh_try_stu+0x53/0x7a
[ 7807.293189]  scsi_eh_test_devices+0xcd/0x16e
[ 7807.293190]  scsi_eh_ready_devs+0x824/0x8c4
[ 7807.293191]  scsi_error_handler+0x291/0x523
[ 7807.293192]  ? __schedule+0x4f5/0x5c5
[ 7807.293193]  ? scsi_eh_get_sense+0x1a9/0x1a9
[ 7807.293194]  kthread+0xfb/0x100
[ 7807.293195]  ? init_completion+0x24/0x24
[ 7807.293196]  ? do_fast_syscall_32+0xb7/0xfe
[ 7807.293196]  ret_from_fork+0x25/0x30
[ 7807.293240] Kernel Offset: 0x39000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
