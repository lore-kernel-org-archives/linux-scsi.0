From: Grzegorz Nosek <root@localdomain.pl>
Subject: smartctl on aic94xx causes a kernel warning in libata
Date: Fri, 23 Jan 2009 20:44:10 +0100
Message-ID: <20090123194410.GA8639@megiteam.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e208.rev.megiteam.pl ([77.79.226.8]:44434 "EHLO
	vadmin.megiteam.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752186AbZAWUMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2009 15:12:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

This is a trivially reproducible (in my setup at least) WARN_ON that
triggers whenever I run smartctl on a SATA disk connected via an aic94xx
controller (Adaptec AIC-9410W SAS (Razor ASIC RAID)=20 (rev 09)).

The kernel is (as far as device drivers are concerned) vanilla
2.6.27.12.

Other than the warning and the fact that smartctl requires '-T
permissive' to show the disk status, I can't see any negative effects.

(please keep cc'd)

Best regards,
 Grzegorz Nosek

*** smartctl -a /dev/sdb (without -T permissive) ***

smartctl version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST3500630NS
Serial Number:    9QG93FV5
Firmware Version: 3.AEK
User Capacity:    500,107,862,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Jan 23 20:17:30 2009 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Values from ATA status return descriptor are:
 00     09 0c 00 00 00 00 00 00  00 00 00 00 00 00
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.

*** the code in question ***

void ata_qc_issue(struct ata_queued_cmd *qc)
{
        struct ata_port *ap = qc->ap;
        struct ata_link *link = qc->dev->link;
        u8 prot = qc->tf.protocol;

        /* Make sure only one non-NCQ command is outstanding.  The
         * check is skipped for old EH because it reuses active qc to
         * request ATAPI sense.
         */
        WARN_ON(ap->ops->error_handler && ata_tag_valid(link->active_tag));

        if (ata_is_ncq(prot)) {
                WARN_ON(link->sactive & (1 << qc->tag));

                if (!link->sactive)
                        ap->nr_active_links++;
                link->sactive |= 1 << qc->tag;
        } else {
                WARN_ON(link->sactive);       /* <-- this is line 4867 */

                ap->nr_active_links++;
                link->active_tag = qc->tag;
        }

*** and the warning itself ***

[251374.059375] ------------[ cut here ]------------
[251374.064287] WARNING: at drivers/ata/libata-core.c:4867 ata_qc_issue+0xe1/0x2ba()
[251374.067805] Modules linked in: drbd i2c_i801 xt_owner ipt_account ipt_MASQUERADE xt_multiport ipt_REJECT xt_comment xt_state xt_hashlimit iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_filter ip_t
ables tg3 libphy psmouse e1000e
[251374.067805] Pid: 9450, comm: smartctl Tainted: G        W 2.6.27.12 #12
[251374.067805]
[251374.067805] Call Trace:
[251374.067805]  [<ffffffff81031103>] warn_on_slowpath+0x58/0x7f
[251374.067805]  [<ffffffff8107c8d0>] ? mempool_alloc_slab+0x11/0x13
[251374.067805]  [<ffffffff8107c9da>] ? mempool_alloc+0x48/0xf9
[251374.067805]  [<ffffffff81247015>] ? scsi_sg_alloc+0x43/0x45
[251374.067805]  [<ffffffff811bb301>] ? __sg_alloc_table+0x78/0xfa
[251374.067805]  [<ffffffff81272adc>] ata_qc_issue+0xe1/0x2ba
[251374.067805]  [<ffffffff812423fd>] ? scsi_done+0x0/0x21
[251374.067805]  [<ffffffff8127a015>] ? ata_scsi_pass_thru+0x0/0x24b
[251374.067805]  [<ffffffff8127756a>] ata_scsi_translate+0x11f/0x155
[251374.067805]  [<ffffffff812423fd>] ? scsi_done+0x0/0x21
[251374.067805]  [<ffffffff812780fc>] ata_sas_queuecmd+0x186/0x1a5
[251374.067805]  [<ffffffff812575f1>] sas_queuecommand+0x82/0x27b
[251374.067805]  [<ffffffff81242b66>] scsi_dispatch_cmd+0x196/0x1ea
[251374.067805]  [<ffffffff812482be>] scsi_request_fn+0x28a/0x35f
[251374.067805]  [<ffffffff811a4776>] elv_insert+0x7f/0x18e
[251374.067805]  [<ffffffff811a4915>] __elv_add_request+0x90/0x98
[251374.067805]  [<ffffffff811a8d0f>] blk_execute_rq_nowait+0x65/0x8e
[251374.067805]  [<ffffffff811a8dd8>] blk_execute_rq+0xa0/0xcc
[251374.067805]  [<ffffffff811a5076>] ? blk_rq_bio_prep+0x3a/0x108
[251374.067805]  [<ffffffff811a8962>] ? blk_rq_append_bio+0x19/0x49
[251374.067805]  [<ffffffff811a8aa6>] ? blk_rq_map_user+0x114/0x1bb
[251374.067805]  [<ffffffff811abbb6>] sg_io+0x263/0x373
[251374.067805]  [<ffffffff811ac326>] scsi_cmd_ioctl+0x1d3/0x3a9
[251374.067805]  [<ffffffff810482b5>] ? sched_clock_cpu+0x134/0x140
[251374.067805]  [<ffffffff81026edb>] ? task_rq_lock+0x40/0x79
[251374.067805]  [<ffffffff8126a5b9>] sd_ioctl+0x7c/0xa1
[251374.067805]  [<ffffffff811a9cbf>] blkdev_driver_ioctl+0x63/0x78
[251374.067805]  [<ffffffff811aa3a5>] blkdev_ioctl+0x6d1/0x6fc
[251374.067805]  [<ffffffff8120062c>] ? n_tty_receive_buf+0xe1a/0xe5a
[251374.067805]  [<ffffffff810821c7>] ? mark_page_accessed+0x20/0x34
[251374.067805]  [<ffffffff8107c696>] ? filemap_fault+0x1c9/0x32b
[251374.067805]  [<ffffffff810c9a08>] block_ioctl+0x1b/0x1f
[251374.067805]  [<ffffffff810af72e>] vfs_ioctl+0x2a/0x77
[251374.067805]  [<ffffffff810af9b0>] do_vfs_ioctl+0x235/0x246
[251374.067805]  [<ffffffff810afa03>] sys_ioctl+0x42/0x67
[251374.067805]  [<ffffffff81026e8e>] ? __wake_up+0x43/0x50
[251374.067805]  [<ffffffff810d4edb>] sg_ioctl_trans+0x1e0/0x248
[251374.067805]  [<ffffffff810d3929>] compat_sys_ioctl+0x2d2/0x316
[251374.067805]  [<ffffffff810a313f>] ? vfs_write+0x122/0x157
[251374.067805]  [<ffffffff81023326>] sysenter_dispatch+0x7/0x27
[251374.067805]
[251374.067805] ---[ end trace 5c5fec5d7ca0c598 ]---

