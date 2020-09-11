Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB933C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 08:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F0C206F4
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 08:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgIKIeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 04:34:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:58506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgIKIeU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 04:34:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F3BB0AEC2;
        Fri, 11 Sep 2020 08:34:33 +0000 (UTC)
Date:   Fri, 11 Sep 2020 10:34:15 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: lockdep warning in lpfc v5.9-rc4
Message-ID: <20200911083415.4k2rjgwbevkdkxis@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I just hit a lockdep warning in lpfc. Not sure if it is a valid complain
or not:

 ================================
 WARNING: inconsistent lock state
 5.9.0-rc4-default #80 Tainted: G            E    
 --------------------------------
 inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
 kworker/2:2/264 [HC0[0]:SC0[0]:HE1:SE1] takes:
 ffff9a726e7cd668 (&lpfc_ncmd->buf_lock){+.?.}-{2:2}, at: lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
 {IN-SOFTIRQ-W} state was registered at:
   lock_acquire+0xb2/0x3a0
   _raw_spin_lock+0x30/0x70
   lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
   lpfc_sli4_fp_handle_fcp_wcqe.isra.29+0xfb/0x390 [lpfc]
   lpfc_sli4_fp_handle_cqe+0x172/0x490 [lpfc]
   __lpfc_sli4_process_cq+0xfd/0x270 [lpfc]
   __lpfc_sli4_hba_process_cq+0x3c/0x110 [lpfc]
   lpfc_cq_poll_hdler+0x16/0x20 [lpfc]
   irq_poll_softirq+0x96/0x150
   __do_softirq+0xd3/0x47b
   asm_call_on_stack+0x12/0x20
   do_softirq_own_stack+0x52/0x60
   irq_exit_rcu+0xea/0xf0
   common_interrupt+0xa9/0x1a0
   asm_common_interrupt+0x1e/0x40
   refresh_cpu_vm_stats+0x20c/0x2a0
   vmstat_update+0xf/0x50
   process_one_work+0x2b7/0x640
   worker_thread+0x39/0x3f0
   kthread+0x139/0x150
   ret_from_fork+0x22/0x30
 irq event stamp: 2621
 hardirqs last  enabled at (2621): [<ffffffff91ff525d>] _raw_spin_unlock_irqrestore+0x2d/0x50
 hardirqs last disabled at (2620): [<ffffffff91ff5a38>] _raw_spin_lock_irqsave+0x88/0x8a
 softirqs last  enabled at (1420): [<ffffffff92200351>] __do_softirq+0x351/0x47b
 softirqs last disabled at (1399): [<ffffffff92001032>] asm_call_on_stack+0x12/0x20
 
 other info that might help us debug this:
  Possible unsafe locking scenario:
 
        CPU0
        ----
   lock(&lpfc_ncmd->buf_lock);
   <Interrupt>
     lock(&lpfc_ncmd->buf_lock);
 
  *** DEADLOCK ***
 
 2 locks held by kworker/2:2/264:
  #0: ffff9a727ccd2d48 ((wq_completion)lpfc_wq#4){+.+.}-{0:0}, at: process_one_work+0x237/0x640
  #1: ffffb73dc0d37e68 ((work_completion)(&queue->irqwork)){+.+.}-{0:0}, at: process_one_work+0x237/0x640
 
 stack backtrace:
 CPU: 2 PID: 264 Comm: kworker/2:2 Tainted: G            E     5.9.0-rc4-default #80
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c89-rebuilt.suse.com 04/01/2014
 Workqueue: lpfc_wq lpfc_sli4_hba_process_cq [lpfc]
 Call Trace:
  dump_stack+0x8d/0xbb
  mark_lock+0x5e5/0x690
  ? print_shortest_lock_dependencies+0x180/0x180
  __lock_acquire+0x2d5/0xbf0
  lock_acquire+0xb2/0x3a0
  ? lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
  ? lock_acquire+0xb2/0x3a0
  _raw_spin_lock+0x30/0x70
  ? lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
  lpfc_scsi_cmd_iocb_cmpl+0x49/0xae0 [lpfc]
  lpfc_sli4_fp_handle_fcp_wcqe.isra.29+0xfb/0x390 [lpfc]
  ? ret_from_fork+0x22/0x30
  ? unwind_next_frame+0x1fc/0x640
  ? create_prof_cpu_mask+0x20/0x20
  ? arch_stack_walk+0x8f/0xf0
  ? ret_from_fork+0x22/0x30
  ? lpfc_handle_fcp_err+0xb00/0xb00 [lpfc]
  ? lpfc_sli4_fp_handle_cqe+0x172/0x490 [lpfc]
  lpfc_sli4_fp_handle_cqe+0x172/0x490 [lpfc]
  __lpfc_sli4_process_cq+0xfd/0x270 [lpfc]
  ? lpfc_sli4_sp_handle_abort_xri_wcqe.isra.54+0x170/0x170 [lpfc]
  __lpfc_sli4_hba_process_cq+0x3c/0x110 [lpfc]
  process_one_work+0x2b7/0x640
  ? find_held_lock+0x34/0xa0
  ? process_one_work+0x640/0x640
  worker_thread+0x39/0x3f0
  ? process_one_work+0x640/0x640
  kthread+0x139/0x150
  ? kthread_park+0x90/0x90
  ret_from_fork+0x22/0x30


Thanks,
Daniel
