From: Juergen Gross <jgross@suse.com>
Subject: Re: Oops in scsi_put_host_cmd_pool
Date: Fri, 01 Aug 2014 08:02:14 +0200
Message-ID: <53DB2D66.4020903@suse.com>
References: <53DB2898.10103@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbaHAGCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2014 02:02:17 -0400
In-Reply-To: <53DB2898.10103@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/01/2014 07:41 AM, Juergen Gross wrote:
> During test of Xen pvSCSI frontend module I found the following issue:
>
> When unplugging a passed-through SCSI-device the SCSI Host is removed.
> When calling the final scsi_host_put() from the driver an Oops is
> happening:
>
> [  219.816292] (file=drivers/scsi/xen-scsifront.c, line=808)
> scsifront_remove: device/vscsi/1 removed
> [  219.816371] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000010
> [  219.816380] IP: [<ffffffff805fdcf8>] scsi_put_host_cmd_pool+0x38/0xb0
> [  219.816390] PGD 3bd60067 PUD 3d353067 PMD 0
> [  219.816396] Oops: 0000 [#1] SMP
> [  219.816400] Modules linked in: nls_utf8 sr_mod cdrom xen_scsifront
> xt_pkttype xt_LOG xt_limit af_packet ip6t_REJECT xt_tcpudp
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw
> xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables
> x86_pkg_temp_thermal thermal_sys coretemp hwmon crc32_pclmul
> crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw
> gf128mul glue_helper aes_x86_64 microcode pcspkr sg dm_mod autofs4
> scsi_dh_alua scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh xen_blkfront
> xen_netfront
> [  219.816458] CPU: 0 PID: 23 Comm: xenwatch Not tainted
> 3.16.0-rc6-11-xen+ #66
> [  219.816463] task: ffff88003da985d0 ti: ffff88003da9c000 task.ti:
> ffff88003da9c000
> [  219.816467] RIP: e030:[<ffffffff805fdcf8>]  [<ffffffff805fdcf8>]
> scsi_put_host_cmd_pool+0x38/0xb0
> [  219.816474] RSP: e02b:ffff88003da9fc20  EFLAGS: 00010202
> [  219.816477] RAX: ffffffffa01a50c0 RBX: 0000000000000000 RCX:
> 0000000000000003
> [  219.816481] RDX: 0000000000000240 RSI: ffff88003d242b80 RDI:
> ffffffff80c708c0
> [  219.816485] RBP: ffff88003da9fc38 R08: 4f7e974a31ed0290 R09:
> 0000000000000000
> [  219.816488] R10: 0000000000007ff0 R11: 0000000000000001 R12:
> ffff8800038f8000
> [  219.816491] R13: ffffffffa01a50c0 R14: 0000000000000000 R15:
> 0000000000000000
> [  219.816498] FS:  00007fe2e2eeb700(0000) GS:ffff88003f800000(0000)
> knlGS:0000000000000000
> [  219.816502] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  219.816505] CR2: 0000000000000010 CR3: 000000003d20c000 CR4:
> 0000000000042660
> [  219.816509] Stack:
> [  219.816511]  ffff8800038f8000 ffff8800038f8030 ffff880003ae3400
> ffff88003da9fc58
> [  219.816516]  ffffffff805fe78b ffff8800038f8000 ffff88003bb82c40
> ffff88003da9fc80
> [  219.816521]  ffffffff805ff587 ffff8800038f81a0 ffff8800038f8190
> ffff880003ae3400
> [  219.816527] Call Trace:
> [  219.816533]  [<ffffffff805fe78b>]
> scsi_destroy_command_freelist+0x5b/0x60
> [  219.816538]  [<ffffffff805ff587>] scsi_host_dev_release+0x97/0xe0
> [  219.816543]  [<ffffffff805dd71d>] device_release+0x2d/0xa0
> [  219.816548]  [<ffffffff804dbec7>] kobject_cleanup+0x77/0x1b0
> [  219.816553]  [<ffffffff804dbd70>] kobject_put+0x30/0x60
> [  219.816556]  [<ffffffff805dd9e2>] put_device+0x12/0x20
> [  219.816560]  [<ffffffff805ff490>] scsi_host_put+0x10/0x20
> [  219.816565]  [<ffffffffa01a2042>] scsifront_free+0x42/0x90
> [xen_scsifront]
> [  219.816569]  [<ffffffffa01a20ad>] scsifront_remove+0x1d/0x50
> [xen_scsifront]
> [  219.816576]  [<ffffffff805a4ee0>] xenbus_dev_remove+0x50/0xa0
> [  219.816580]  [<ffffffff805e1a8a>] __device_release_driver+0x7a/0xf0
> [  219.816584]  [<ffffffff805e1b1e>] device_release_driver+0x1e/0x30
> [  219.816588]  [<ffffffff805e1440>] bus_remove_device+0x100/0x180
> [  219.816593]  [<ffffffff805ddef1>] device_del+0x121/0x1b0
> [  219.816596]  [<ffffffff805ddf99>] device_unregister+0x19/0x60
> [  219.816601]  [<ffffffff805a56be>] xenbus_dev_changed+0x9e/0x1e0
> [  219.816606]  [<ffffffff8079d695>] ?
> _raw_spin_unlock_irqrestore+0x25/0x50
> [  219.816611]  [<ffffffff805a41d0>] ? unregister_xenbus_watch+0x200/0x200
> [  219.816615]  [<ffffffff805a7420>] frontend_changed+0x20/0x50
> [  219.816619]  [<ffffffff805a426f>] xenwatch_thread+0x9f/0x160
> [  219.816624]  [<ffffffff802a50f0>] ? prepare_to_wait_event+0xf0/0xf0
> [  219.816628]  [<ffffffff8028485d>] kthread+0xcd/0xf0
> [  219.816633]  [<ffffffff80284790>] ? kthread_create_on_node+0x170/0x170
> [  219.816638]  [<ffffffff8079dcbc>] ret_from_fork+0x7c/0xb0
> [  219.816642]  [<ffffffff80284790>] ? kthread_create_on_node+0x170/0x170
> [  219.816645] Code: 8b af c0 00 00 00 48 c7 c7 c0 08 c7 80 e8 d1 e0 19
> 00 49 8b 84 24 c0 00 00 00 8b 90 48 01 00 00 85 d2 74 2f 48 8b 98 50 01
> 00 00 <8b> 43 10 85 c0 74 68 83 e8 01 85 c0 89 43 10 74 37 48 c7 c7 c0
> [  219.816732] RIP  [<ffffffff805fdcf8>] scsi_put_host_cmd_pool+0x38/0xb0
> [  219.816747]  RSP <ffff88003da9fc20>
> [  219.816750] CR2: 0000000000000010
> [  219.816753] ---[ end trace c6915ea21a3d05f7 ]---
>
> I should mention I've specified .cmd_len in the scsi_host_template. The
> only other driver doing this seems to be virtio_scsi.c, so I assume the
> same problem could occur with passed-through SCSI devices under KVM...

After looking into the code the reason seems to be rather obvious:

scsi_find_host_cmd_pool() returns shost->hostt->cmd_pool if .cmd_size is
set. But shost->hostt->cmd_pool is never set. The following patch should
solve the issue (after testing it I'll send an official patch):

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..da769f9 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -380,6 +380,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
                 pool->slab_flags |= SLAB_CACHE_DMA;
                 pool->gfp_mask = __GFP_DMA;
         }
+
+       if (shost->hostt->cmd_size)
+               shost->hostt->cmd_pool = pool;
+
         return pool;
  }


Juergen

