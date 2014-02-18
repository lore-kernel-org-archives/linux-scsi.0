From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: bio-integrity BUG_ON
Date: Tue, 18 Feb 2014 12:29:33 -0800
Message-ID: <1392755373.28946.36.camel@haakon3.risingtidesystems.com>
References: <5303987D.7030109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56410 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaBRU03 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 15:26:29 -0500
In-Reply-To: <5303987D.7030109@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kmo@daterainc.com

On Tue, 2014-02-18 at 19:29 +0200, Sagi Grimberg wrote:
> Hey,
> 
> I stumbled on a nasty crash with 3.14-rc1 when playing with scsi_debug 
> DIF emulation.
> It's late (IL time..), so I thought I'd post this one up and ask if 
> anyone else noticed it before digging into this one.
> 
> it comes from the condition:
> BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);
> 

Mmmm, looks like some immutable bio_vec fallout.. (CC'ing kmo)

Is there a specific workload that is able to reproduce..?

--nab

> trace:
> scsi_debug_init: dif_storep 131072 bytes @ ffffc90016ad8000
> scsi_debug: host protection DIF1 DIX1
> scsi7 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
> scsi 7:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 
> ANSI: 5
> sd 7:0:0:0: Attached scsi generic sg2 type 0
> sd 7:0:0:0: [sdc] Enabling DIF Type 1 protection
> sd 7:0:0:0: [sdc] 16384 512-byte logical blocks: (8.38 MB/8.00 MiB)
> sd 7:0:0:0: [sdc] Write Protect is off
> sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
>   sdc: unknown partition table
> sd 7:0:0:0: [sdc] Enabling DIX T10-DIF-TYPE1-CRC protection
> sd 7:0:0:0: [sdc] DIF application tag size 2
> ------------[ cut here ]------------
> kernel BUG at fs/bio-integrity.c:479!
> invalid opcode: 0000 [#1] SMP
> Modules linked in: scsi_debug(O) netconsole nfsv3 nfs_acl 
> rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs fscache lockd autofs4 sunrpc 
> target_core_iblock target_core_file target_core_pscsi target_core_mod 
> configfs 8021q garp stp llc cpufreq_ondemand rdma_ucm(O) ib_ucm(O) 
> rdma_cm(O) iw_cm(O) ib_ipoib(O) ib_cm(O) ib_uverbs(O) ib_umad(O) 
> mlx5_ib(O) mlx5_core mlx4_en mlx4_ib(O) ib_sa(O) ib_mad(O) ib_core(O) 
> ib_addr(O) ipv6 mlx4_core dm_mirror dm_region_hash dm_log uinput 
> iTCO_wdt iTCO_vendor_support sg(O) microcode pcspkr serio_raw sb_edac 
> edac_core i2c_i801 lpc_ich mfd_core shpchp ioatdma igb dca i2c_algo_bit 
> i2c_core ptp pps_core ipmi_si ipmi_msghandler dm_mod acpi_cpufreq wmi 
> ext3 jbd mbcache sd_mod crc_t10dif crct10dif_common ahci libahci isci 
> libsas scsi_transport_sas [last unloaded: ip_tables]
> CPU: 18 PID: 4029 Comm: kworker/18:1H Tainted: G           O 3.14.0-rc1+ #1
> Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/2013
> Workqueue: kintegrityd bio_integrity_verify_fn
> task: ffff880867954f90 ti: ffff880868ed2000 task.ti: ffff880868ed2000
> RIP: 0010:[<ffffffff811c8a92>]  [<ffffffff811c8a92>] 
> bio_integrity_verify_fn+0x172/0x180
> RSP: 0018:ffff880868ed3d78  EFLAGS: 00010202
> RAX: 0000000000000008 RBX: 0000000000003f80 RCX: ffff88086f2f9940
> RDX: 0000000000000040 RSI: ffff88086f2fbc80 RDI: ffff880868ed3d98
> RBP: ffff880868ed3df8 R08: ffff88086bd04f40 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88086f2f99c8
> R13: ffff880454012720 R14: 0000000000000040 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88087fcc0000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000003e59410060 CR3: 000000086e5c1000 CR4: 00000000000407e0
> Stack:
>   0000000000000001 ffff88086f2f9940 ffff88086bd04f40 ffff88086f2fbcb8
>   ffff88086bd04f40 ffff880862cea000 0000000000003f80 ffff020000001000
>   ffff88045525d40c ffffffff81068092 ffff880868ed3e38 ffff88086e8d3500
> Call Trace:
>   [<ffffffff81068092>] ? worker_set_flags+0x92/0xd0
>   [<ffffffff8106b3c2>] process_one_work+0x182/0x3b0
>   [<ffffffff8106c9b0>] worker_thread+0x120/0x3a0
>   [<ffffffff8106c890>] ? manage_workers+0x160/0x160
>   [<ffffffff8107242e>] kthread+0xce/0xf0
>   [<ffffffff81072360>] ? kthread_freezable_should_stop+0x70/0x70
>   [<ffffffff81577d2c>] ret_from_fork+0x7c/0xb0
>   [<ffffffff81072360>] ? kthread_freezable_should_stop+0x70/0x70
> 
> Sagi.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


