Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F622C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 13:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E9CD222C7
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 13:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfKSNc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 08:32:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:46122 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725280AbfKSNc4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 08:32:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 996C5B3EE;
        Tue, 19 Nov 2019 13:32:53 +0000 (UTC)
Date:   Tue, 19 Nov 2019 14:32:53 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Move work items to a stack list
Message-ID: <20191119133253.r3uhiitehhc4o5qw@beryllium.lan>
References: <20191105080855.16881-1-dwagner@suse.de>
 <yq1h838pivf.fsf@oracle.com>
 <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 19, 2019 at 02:28:54PM +0100, Daniel Wagner wrote:
> On Tue, Nov 12, 2019 at 10:15:00PM -0500, Martin K. Petersen wrote:
> > > While trying to understand what's going on in the Oops below I figured
> > > that it could be the result of the invalid pointer access. The patch
> > > still needs testing by our customer but indepent of this I think the
> > > patch fixes a real bug.
> 
> I was able to reproduce the same stack trace with this patch
> applied... That is obviously bad. The good news, I have access to this
> machine, so maybe I able to figure out what's the root cause of this
> crash.

Forgot to append the KASAN trace which points at the same place. Don't
know if this is the same thing or not.


[  329.217804] ==================================================================
[  329.280494] BUG: KASAN: slab-out-of-bounds in lpfc_sli4_io_xri_aborted+0x29c/0x3c0 [lpfc]
[  329.351654] Read of size 8 at addr ffff88984f160000 by task kworker/77:1/488
[  329.396559] nvme nvme3: Removing ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery"
[  329.412326] 
[  329.412335] CPU: 77 PID: 488 Comm: kworker/77:1 Kdump: loaded Tainted: G            E     5.4.0-rc1-default+ #3
[  329.412338] Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 07/21/2019
[  329.412414] Workqueue: lpfc_wq lpfc_sli4_hba_process_cq [lpfc]
[  329.428650] nvme nvme0: Removing ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery"
[  329.765863] Call Trace:
[  329.765888]  dump_stack+0x71/0xab
[  329.765967]  ? lpfc_sli4_io_xri_aborted+0x29c/0x3c0 [lpfc]
[  329.765981]  print_address_description.constprop.6+0x1b/0x2f0
[  329.912961]  ? lpfc_sli4_io_xri_aborted+0x29c/0x3c0 [lpfc]
[  329.913001]  ? lpfc_sli4_io_xri_aborted+0x29c/0x3c0 [lpfc]
[  330.009190]  __kasan_report+0x14e/0x192
[  330.009255]  ? lpfc_sli4_io_xri_aborted+0x29c/0x3c0 [lpfc]
[  330.009261]  kasan_report+0xe/0x20
[  330.120620]  lpfc_sli4_io_xri_aborted+0x29c/0x3c0 [lpfc]
[  330.120660]  lpfc_sli4_sp_handle_abort_xri_wcqe.isra.55+0x59/0x280 [lpfc]
[  330.226013]  ? __update_load_avg_cfs_rq+0x244/0x470
[  330.226052]  ? lpfc_sli4_fp_handle_cqe+0x127/0x8e0 [lpfc]
[  330.226089]  lpfc_sli4_fp_handle_cqe+0x127/0x8e0 [lpfc]
[  330.358896]  ? lpfc_sli4_sp_handle_abort_xri_wcqe.isra.55+0x280/0x280 [lpfc]
[  330.358907]  ? __switch_to_asm+0x40/0x70
[  330.452995]  ? __switch_to_asm+0x34/0x70
[  330.452998]  ? __switch_to_asm+0x40/0x70
[  330.453000]  ? __switch_to_asm+0x34/0x70
[  330.453002]  ? __switch_to_asm+0x40/0x70
[  330.453005]  ? __switch_to_asm+0x34/0x70
[  330.453041]  __lpfc_sli4_process_cq+0x1e1/0x470 [lpfc]
[  330.453078]  ? lpfc_sli4_sp_handle_abort_xri_wcqe.isra.55+0x280/0x280 [lpfc]
[  330.728428]  ? __switch_to_asm+0x40/0x70
[  330.728466]  __lpfc_sli4_hba_process_cq+0x88/0x1d0 [lpfc]
[  330.728503]  ? lpfc_sli4_fp_handle_cqe+0x8e0/0x8e0 [lpfc]
[  330.855605]  process_one_work+0x46e/0x7f0
[  330.855610]  worker_thread+0x69/0x6b0
[  330.855615]  ? process_one_work+0x7f0/0x7f0
[  330.855620]  kthread+0x1b3/0x1d0
[  330.855624]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[  330.855627]  ret_from_fork+0x35/0x40
[  330.855631] 
[  330.855634] Allocated by task 5171:
[  330.855644]  save_stack+0x19/0x80
[  330.855650]  __kasan_kmalloc.constprop.9+0xa0/0xd0
[  331.175452]  __kmalloc+0xfb/0x5d0
[  331.175461]  alloc_pipe_info+0xff/0x210
[  331.175464]  create_pipe_files+0x66/0x2e0
[  331.175467]  __do_pipe_flags+0x2c/0x100
[  331.175470]  do_pipe2+0x80/0x130
[  331.175472]  __x64_sys_pipe2+0x2b/0x30
[  331.175486]  do_syscall_64+0x73/0x230
[  331.395309]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  331.395310] 
[  331.395312] Freed by task 5171:
[  331.395317]  save_stack+0x19/0x80
[  331.395319]  __kasan_slab_free+0x105/0x150
[  331.395321]  kfree+0xa6/0x150
[  331.395324]  free_pipe_info+0x106/0x120
[  331.395327]  pipe_release+0xcb/0xf0
[  331.395335]  __fput+0x11d/0x330
[  331.395338]  task_work_run+0xc6/0xf0
[  331.395344]  exit_to_usermode_loop+0x11d/0x120
[  331.730019]  do_syscall_64+0x203/0x230
[  331.730023]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  331.730023] 
[  331.730027] The buggy address belongs to the object at ffff88984f160040
[  331.730027]  which belongs to the cache kmalloc-1k of size 1024
[  331.730030] The buggy address is located 64 bytes to the left of
[  331.730030]  1024-byte region [ffff88984f160040, ffff88984f160440)
[  331.730031] The buggy address belongs to the page:
[  331.730036] page:ffffea00613c5800 refcount:1 mapcount:0 mapping:ffff888107c00700 index:0x0 compound_mapcount: 0
[  331.730042] flags: 0x97ffffc0010200(slab|head)
[  331.730050] raw: 0097ffffc0010200 ffffea00613c4608 ffffea00613c7f88 ffff888107c00700
[  332.266508] raw: 0000000000000000 ffff88984f160040 0000000100000007 0000000000000000
[  332.266509] page dumped because: kasan: bad access detected
[  332.266510] 
[  332.266511] Memory state around the buggy address:
[  332.266516]  ffff88984f15ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  332.266518]  ffff88984f15ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  332.266521] >ffff88984f160000: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
[  332.266522]                    ^
[  332.266525]  ffff88984f160080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  332.266527]  ffff88984f160100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  332.266528] ==================================================================

The kernel I used to create the above KASAN trace is mkp/queue (clean
without my patch), c0bf9a264e10 ("scsi: iscsi: Don't send data to
unbound connection")
