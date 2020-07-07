Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C53C433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2102206E2
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 13:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGGNeS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:34:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58560 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgGGNeR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jul 2020 09:34:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 38CC8AC43;
        Tue,  7 Jul 2020 13:34:16 +0000 (UTC)
Date:   Tue, 7 Jul 2020 15:34:15 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-kernel@vger.kernel.org
Subject: lfpc: kernel BUG at arch/x86/mm/physaddr.c:28!
Message-ID: <20200707133415.z4lvfnzraku7bioj@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

While trying to debug something in qla2xxx I enabled KASAN. As it turns out,
KASAN finds something in lpfc (and not qla2xxx so far).

I was able to reproduce this with v5.8-rc4 and the current mkp/queue
branch. Almost all memory debug options are enabled. Not sure which
one is able to trigger this:

 ------------[ cut here ]------------
 kernel BUG at arch/x86/mm/physaddr.c:28!
 invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
 CPU: 0 PID: 1083 Comm: kworker/0:4 Tainted: G            E     5.8.0-rc4-default+ #59
 Hardware name: HP ProLiant DL580 Gen9/ProLiant DL580 Gen9, BIOS U17 07/21/2019
 Workqueue: events work_for_cpu_fn
 RIP: 0010:__phys_addr+0x59/0x80
 Code: 4c 39 e3 72 25 48 c7 c7 55 85 e7 87 e8 00 8d 39 00 0f b6 0d 6e e7 1a 02 4c 89 e0 48 d3 e8 48 85 c0 75 07 4c 89 e$
 RSP: 0018:ffff88842b9ff990 EFLAGS: 00010202
 RAX: 0000000000000001 RBX: ffffc90086598000 RCX: 000000000000002e
 RDX: 1ffffffff0fcf0aa RSI: 0000000000000001 RDI: ffffffff87e78555
 RBP: ffffc90006598000 R08: ffffffffc109fb97 R09: 0000000000000000
 R10: 0000000000000003 R11: ffffed108573ff0c R12: 0000408006598000
 R13: 0000000000000001 R14: ffff88842baac000 R15: ffff88843bc43800
 FS:  0000000000000000(0000) GS:ffff888812800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f5a28f8a4b6 CR3: 00000019b240e001 CR4: 00000000001606f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  set_memory_wc+0x1d/0x90
  lpfc_wq_create+0x67e/0x920 [lpfc]
  lpfc_create_wq_cq+0xde/0x240 [lpfc]
  lpfc_sli4_queue_setup+0x489/0xc70 [lpfc]
  lpfc_sli4_hba_setup+0xf4c/0x26d0 [lpfc]
  ? kernfs_add_one+0x1b1/0x210
  ? __kernfs_create_file+0xe3/0x120
  ? lpfc_sli_read_link_ste+0x550/0x550 [lpfc]
  ? lpfc_cpu_affinity_check.isra.0+0x5e3/0xa00 [lpfc]
  ? lpfc_pci_probe_one_s4.isra.0+0x3b4/0x540 [lpfc]
  lpfc_pci_probe_one_s4.isra.0+0x3b4/0x540 [lpfc]
  ? lpfc_pci_probe_one_s4.isra.0+0x540/0x540 [lpfc]
  lpfc_pci_probe_one+0xbb/0xd0 [lpfc]
  ? lpfc_pci_probe_one_s4.isra.0+0x540/0x540 [lpfc]
  ? __pm_runtime_resume+0x42/0x70
  local_pci_probe+0x74/0xc0
  ? pci_device_shutdown+0x80/0x80
  work_for_cpu_fn+0x29/0x40
  process_one_work+0x483/0x7e0
  worker_thread+0x465/0x690
  ? process_one_work+0x7e0/0x7e0
  kthread+0x19f/0x1f0
  ? kthread_parkme+0x40/0x40
  ret_from_fork+0x22/0x30
 Modules linked in: mgag200(E+) drm_vram_helper(E) lpfc(E+) drm_kms_helper(E) sd_mod(E) nvmet_fc(E) syscopyarea(E) sysf$
 ---[ end trace 404edaadb5917ff2 ]---

Thanks,
Daniel
