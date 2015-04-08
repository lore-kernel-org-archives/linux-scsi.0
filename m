From: Andy Lutomirski <luto@amacapital.net>
Subject: smp_processor_id warning in megasas driver on 3.19.3
Date: Wed, 8 Apr 2015 10:59:36 -0700
Message-ID: <CALCETrXUZ=qbQmaEdiKAn+HgU7Vmx3arwGF_zyYJwTShqGcx_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35580 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbbDHR76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 13:59:58 -0400
Received: by lbbuc2 with SMTP id uc2so69644667lbb.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2015 10:59:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, Linux SCSI List <linux-scsi@vger.kernel.org>

This is a regression somewhere between 3.15 and 3.19.3.  Let me know
if more diagnostics would be helpful.

[58635.050733] BUG: using smp_processor_id() in preemptible [00000000]
code: apt-check/13293
[58635.059861] caller is debug_smp_processor_id+0x17/0x20
[58635.059863] CPU: 0 PID: 13293 Comm: apt-check Not tainted 3.19.3-ama+ #44
[58635.059864] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS
1.2.6 05/10/2012
[58635.059865]  ffffffff81810777 ffff88041bbbb898 ffffffff815d6ae5
0000000000000002
[58635.059867]  0000000000000000 ffff88041bbbb8c8 ffffffff81307945
0000000000005000
[58635.059869]  ffff880035745e00 0000000000000000 ffff88040dc67780
ffff88041bbbb8d8
[58635.059871] Call Trace:
[58635.059874]  [<ffffffff815d6ae5>] dump_stack+0x4f/0x7b
[58635.059877]  [<ffffffff81307945>] check_preemption_disabled+0xe5/0x100
[58635.059879]  [<ffffffff81307977>] debug_smp_processor_id+0x17/0x20
[58635.059884]  [<ffffffffa003d079>]
megasas_build_ldio_fusion+0x259/0x450 [megaraid_sas]
[58635.059887]  [<ffffffffa003d312>]
megasas_build_io_fusion+0xa2/0x590 [megaraid_sas]
[58635.059890]  [<ffffffff815de2e2>] ? _raw_spin_unlock_irqrestore+0x22/0x40
[58635.059893]  [<ffffffffa003d8b6>]
megasas_build_and_issue_cmd_fusion+0x66/0x$00 [megaraid_sas]
[58635.059896]  [<ffffffffa00310dc>] megasas_queue_command+0x12c/0x170
[megarai$_sas]
[58635.059898]  [<ffffffff8141d45b>] ? scsi_prep_fn+0xdb/0x180
[58635.059901]  [<ffffffff8141c2ae>] scsi_dispatch_cmd+0xee/0x340
[58635.059902]  [<ffffffff8141f019>] scsi_request_fn+0x4b9/0x6c0
[58635.059904]  [<ffffffff815de215>] ? _raw_spin_lock_irqsave+0x25/0x30
[58635.059906]  [<ffffffff812c9077>] __blk_run_queue+0x37/0x50
[58635.059908]  [<ffffffff812ec639>] cfq_insert_request+0x2a9/0x600
[58635.059910]  [<ffffffff812c618c>] __elv_add_request+0x1bc/0x300
[58635.059912]  [<ffffffff812ccd28>] blk_flush_plug_list+0x1b8/0x210
[58635.059914]  [<ffffffff812cd118>] blk_finish_plug+0x18/0x50
[58635.059916]  [<ffffffff81154543>] __do_page_cache_readahead+0x1d3/0x250
[58635.059919]  [<ffffffff81154708>] ondemand_readahead+0x148/0x2a0
[58635.059921]  [<ffffffff8114880c>] ? pagecache_get_page+0x2c/0x1d0
[58635.059923]  [<ffffffff811549e1>] page_cache_sync_readahead+0x31/0x50
[58635.059924]  [<ffffffff81149bf9>] generic_file_read_iter+0x449/0x630
[58635.059926]  [<ffffffff811acede>] new_sync_read+0x7e/0xb0
[58635.059928]  [<ffffffff811ae0c8>] __vfs_read+0x18/0x50
[58635.059930]  [<ffffffff811ae186>] vfs_read+0x86/0x140
[58635.059932]  [<ffffffff811ae289>] SyS_read+0x49/0xb0
[58635.059933]  [<ffffffff81045dac>] ? do_page_fault+0xc/0x10
[58635.059935]  [<ffffffff815dea72>] system_call_fastpath+0x12/0x17

Thanks,
Andy
