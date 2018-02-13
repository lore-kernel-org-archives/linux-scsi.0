From: Hannes Reinecke <hare@suse.de>
Subject: Re: rescan-scsi-bus causes arcmsr death
Date: Tue, 13 Feb 2018 10:38:07 +0100
Message-ID: <98386424-311d-5ccf-4285-9a2de2d5b528@suse.de>
References: <5A7DFD68.6070704@gblabs.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934272AbeBMJiJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Feb 2018 04:38:09 -0500
In-Reply-To: <5A7DFD68.6070704@gblabs.co.uk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Richman <alex.r@gblabs.co.uk>, linux-scsi@vger.kernel.org
Cc: Tom Sheldon <tom@gblabs.co.uk>

On 02/09/2018 08:58 PM, Alex Richman wrote:
> Hi,
> 
> We're seeing an odd rare interaction between rescan-scsi-bus and arcmsr,
> which manifests as these log messages, then a hang/panic:
> Feb  9 18:51:19 Space kernel: [ 2624.283565] arcmsr: abort
> scsi_cmnd(0xffff8807d06cc900), cmnd[0x8a,0x 0,0x 0,0x 0,0x 0,0x 1,0x
> 8,0xc0,0x2b,0xe8,0x 0,0x 0], scsi_id = 0x 0, scsi_lun = 0x 0.
> Feb  9 18:51:19 Space kernel: [ 2624.283604] arcmsr0: to abort
> command(0xffff8807d06cc900), ccb = 0xffff881058b11180
> Feb  9 18:51:21 Space kernel: [ 2625.924838] arcmsr0: abort ccb =
> 0xffff881058b11180 not done yet, do not force aborting command!
> --- Snip many more ---
> 
> On the (seemingly less common) occasion that it panics rather than
> hangs, it looks like this:
> Feb  9 11:55:05 Space kernel: [58801.943419] arcmsr9: abort
> scsi_cmnd(0xffff881027968900), cmnd[0x 0,0x 0,0x 0,0x 0,0x 0,0x 0,0x
> 0,0x 0,0x 0,0x 0,0x 0,0x 0], scsi_id = 0x 0, scsi_lun = 0x 0.
> Feb  9 11:55:05 Space kernel: [58801.943427] arcmsr9: to abort
> command(0xffff881027968900), ccb = 0xffff88085864a580
> Feb  9 11:55:05 Space kernel: [58801.943429] arcmsr9: scsi id = 0 lun =
> 0 ccb = '0xffff88085864a580' polling a done ccb, abort successfully
> Feb  9 11:55:05 Space kernel: [58801.943460] BUG: scheduling while
> atomic: ksoftirqd/19/85/0x00000100
> Feb  9 11:55:05 Space kernel: [58801.943463] Modules linked in: xfs
> libcrc32c mlx4_ib ib_sa ib_mad ib_core ib_addr mlx4_en mlx4_core
> myri10ge bonding target_core_mod configfs ip6table_filter ip6_tables
> iptable_filter ip_tables ebtable_nat ebtables x_tables dm_crypt
> ipmi_ssif x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64
> lrw gf128mul glue_helper ablk_helper cryptd sb_edac microcode edac_core
> lpc_ich ioatdma tpm_tis ipmi_si ipmi_msghandler 8250_fintek mac_hid nfsd
> auth_rpcgss pcspkr nfs_acl nfs lockd grace sunrpc fscache ext2 mlx5_core
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> async_tx xor raid6_pq raid1 raid0 multipath linear vxlan ip6_udp_tunnel
> udp_tunnel bcache hid_generic igb isci usbhid i2c_algo_bit libsas ahci
> dca hid libahci ptp scsi_transport_sas pps_core arcmsr(OE) [last
> unloaded: mlx4_core]
> Feb  9 11:55:05 Space kernel: [58801.943511] CPU: 19 PID: 85 Comm:
> ksoftirqd/19 Tainted: G           OE  3.19.0-21-spacev3 #160915
> Feb  9 11:55:05 Space kernel: [58801.943512] Hardware name: GBLabs
> Space+/X9DRH-7TF/7F/iTF/iF, BIOS 3.2  06/04/2015
> Feb  9 11:55:05 Space kernel: [58801.943514]  ffff88105bd13a08
> ffff88105bd13948 ffffffffaf6e521c 0000000000000000
> Feb  9 11:55:05 Space kernel: [58801.943516]  ffff88107fcf29c0
> ffff88105bd13958 ffffffffaf6dfa07 ffff88105bd139c8
> Feb  9 11:55:05 Space kernel: [58801.943517]  ffffffffaf6e84fc
> ffff88105bcb41a0 00000000000129c0 ffff88105bd13fd8
> Feb  9 11:55:05 Space kernel: [58801.943519] Call Trace:
> Feb  9 11:55:05 Space kernel: [58801.943528]  [<ffffffffaf6e521c>]
> dump_stack+0x45/0x57
> Feb  9 11:55:05 Space kernel: [58801.943533]  [<ffffffffaf6dfa07>]
> __schedule_bug+0x4b/0x59
> Feb  9 11:55:05 Space kernel: [58801.943535]  [<ffffffffaf6e84fc>]
> __schedule+0x75c/0x780
> Feb  9 11:55:05 Space kernel: [58801.943537]  [<ffffffffaf6e8549>]
> schedule+0x29/0x70
> Feb  9 11:55:05 Space kernel: [58801.943540]  [<ffffffffaf6eb45b>]
> schedule_timeout+0x10b/0x210
> Feb  9 11:55:05 Space kernel: [58801.943544]  [<ffffffffaf0b0180>] ?
> internal_add_timer+0x80/0x80
> Feb  9 11:55:05 Space kernel: [58801.943546]  [<ffffffffaf0b14e7>]
> msleep+0x37/0x50
> Feb  9 11:55:05 Space kernel: [58801.943552]  [<ffffffffc0342af2>]
> arcmsr_queue_command+0x82/0xf40 [arcmsr]
> Feb  9 11:55:05 Space kernel: [58801.943553]  [<ffffffffaf6e2637>] ?
> __slab_free+0x101/0x2c1
> Feb  9 11:55:05 Space kernel: [58801.943555]  [<ffffffffaf6e2637>] ?
> __slab_free+0x101/0x2c1
> Feb  9 11:55:05 Space kernel: [58801.943561]  [<ffffffffaf4bae0f>]
> scsi_dispatch_cmd+0xaf/0x310
> Feb  9 11:55:05 Space kernel: [58801.943563]  [<ffffffffaf4bdca0>]
> scsi_request_fn+0x4f0/0x7e0
> Feb  9 11:55:05 Space kernel: [58801.943566]  [<ffffffffaf31ecf7>]
> __blk_run_queue+0x37/0x50
> Feb  9 11:55:05 Space kernel: [58801.943568]  [<ffffffffaf31ed86>]
> blk_run_queue+0x26/0x40
> Feb  9 11:55:05 Space kernel: [58801.943570]  [<ffffffffaf4ba970>]
> scsi_run_queue+0x230/0x2d0
> Feb  9 11:55:05 Space kernel: [58801.943572]  [<ffffffffaf4b311d>] ?
> scsi_put_command+0x7d/0xd0
> Feb  9 11:55:05 Space kernel: [58801.943575]  [<ffffffffaf4bb992>]
> scsi_end_request+0x142/0x1e0
> Feb  9 11:55:05 Space kernel: [58801.943576]  [<ffffffffaf4be119>]
> scsi_io_completion+0x109/0x6b0
> Feb  9 11:55:05 Space kernel: [58801.943578]  [<ffffffffaf4b36ff>]
> scsi_finish_command+0xcf/0x130
> Feb  9 11:55:05 Space kernel: [58801.943580]  [<ffffffffaf4bd787>]
> scsi_softirq_done+0x137/0x160
> Feb  9 11:55:05 Space kernel: [58801.943583]  [<ffffffffaf328f13>]
> blk_done_softirq+0x83/0xa0
> Feb  9 11:55:05 Space kernel: [58801.943587]  [<ffffffffaf060aa4>]
> __do_softirq+0xe4/0x270
> Feb  9 11:55:05 Space kernel: [58801.943588]  [<ffffffffaf060c59>]
> run_ksoftirqd+0x29/0x40
> Feb  9 11:55:05 Space kernel: [58801.943593]  [<ffffffffaf07d7f3>]
> smpboot_thread_fn+0x143/0x1b0
> Feb  9 11:55:05 Space kernel: [58801.943596]  [<ffffffffaf07d6b0>] ?
> SyS_setgroups+0x180/0x180
> Feb  9 11:55:05 Space kernel: [58801.943598]  [<ffffffffaf079a02>]
> kthread+0xd2/0xf0
> Feb  9 11:55:05 Space kernel: [58801.943600]  [<ffffffffaf079930>] ?
> kthread_create_on_node+0x1c0/0x1c0
> Feb  9 11:55:05 Space kernel: [58801.943602]  [<ffffffffaf6ec618>]
> ret_from_fork+0x58/0x90
> Feb  9 11:55:05 Space kernel: [58801.943604]  [<ffffffffaf079930>] ?
> kthread_create_on_node+0x1c0/0x1c0
> 
> We originally saw this in the wild very rarely, but have now replicated
> it fairly reliably on an internal test system.  The basic overview seems
> to be:
> 1) Start an ton of simultaneous rescan-scsi-bus processes in a loop.
> 2) Apply a large load to the block device.  It doesn't seem to matter
> exactly what this load is, but anecdotally the error seems to occur more
> quickly when reading/writing lots of small files rather than a few big
> files.
> 3) ???
> 4) arcmsr shits the bed.
> 
> This has happened on a few different software/hardware flavours out in
> the field, but on this particular test system we're using:
>  - kernel 3.19
>  - arcmsr v1.30.0X.20-20150342 (notably we've also seen this on
> v1.30.0X.27-20170206 in the field)
>  - ARC-1883LP Raid Controller
>  - Supermicro 12G SAS Backplane
>  - 8x Samsung SAS SSDs (MZILS480HCGR/003)
> 
> Other details:
>  - There seems to be about ~30 gap where the entire system hangs just
> before the arcmsr abort errors show up in the logs.
>  - Previously (and out in the field) we have LVM in the storage stack
> (BD -> LVM -> XFS), but we've also replicated this with just XFS (or
> EXT4) directly on the BD.
> 
Please try to reproduce with the current 4.16 kernel.
The arcmsr driver has been modified a bit so it's not that easy to match
the log to the current driver.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
