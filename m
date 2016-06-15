From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 120371] New: UBSAN splat in drivers/scsi/scsi_devinfo.c:458:21
Date: Wed, 15 Jun 2016 12:33:36 +0000
Message-ID: <bug-120371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57108 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129AbcFOMdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 08:33:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6F223202AE
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 12:33:38 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AD2AD20279
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 12:33:36 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=120371

            Bug ID: 120371
           Summary: UBSAN splat in drivers/scsi/scsi_devinfo.c:458:21
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.7.0-rc3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: linux-kernel@lebenslange-mailadresse.de
        Regression: No

Created attachment 220111
  --> https://bugzilla.kernel.org/attachment.cgi?id=220111&action=edit
.config

While booting, UBSAN reports an index out of range use in
drivers/scsi/scsi_devinfo.c:458:21:

[    2.226941]
================================================================================
[    2.226944] UBSAN: Undefined behaviour in
/usr/local/src/kernel/linux-git/drivers/scsi/scsi_devinfo.c:458:21
[    2.226945] index 8 is out of range for type 'char [8]'
[    2.226948] CPU: 3 PID: 6 Comm: kworker/u16:0 Not tainted
4.7.0-rc3-00002-g44c5afa #1
[    2.226948] Hardware name: Apple Inc. MacBookPro8,2/Mac-94245A3940C91C80,
BIOS    MBP81.88Z.0047.B27.1201241646 01/24/12
[    2.226955] Workqueue: events_unbound async_run_entry_fn
[    2.226958]  000000000000000e ffff88026614fa50 ffffffff815c8665
ffffffff81190e52
[    2.226961]  ffff88026614fa78 0000000000000008 ffff88026614fa68
ffffffff8163e77d
[    2.226963]  ffffffff8263a560 ffff88026614fac0 ffffffff8163ee95
0000000000000286
[    2.226963] Call Trace:
[    2.226968]  [<ffffffff815c8665>] dump_stack+0x68/0xa3
[    2.226971]  [<ffffffff81190e52>] ? down_trylock+0x32/0x60
[    2.226975]  [<ffffffff8163e77d>] ubsan_epilogue+0xd/0x40
[    2.226978]  [<ffffffff8163ee95>] __ubsan_handle_out_of_bounds+0x75/0xa0
[    2.226980]  [<ffffffff8119758d>] ? trace_hardirqs_on+0xd/0x10
[    2.226984]  [<ffffffff817ccf49>] scsi_dev_info_list_find+0x279/0x2b0
[    2.226986]  [<ffffffff817cd49c>] scsi_get_device_flags_keyed+0x1c/0x80
[    2.226989]  [<ffffffff817cd50b>] scsi_get_device_flags+0xb/0x10
[    2.226991]  [<ffffffff817c6a79>] scsi_probe_and_add_lun+0x4b9/0x1200
[    2.226993]  [<ffffffff817c7fdb>] __scsi_add_device+0x11b/0x140
[    2.226996]  [<ffffffff817f920b>] ata_scsi_scan_host+0x10b/0x200
[    2.226999]  [<ffffffff817eefb5>] async_port_probe+0x45/0x80
[    2.227001]  [<ffffffff8114b052>] async_run_entry_fn+0x52/0x220
[    2.227003]  [<ffffffff8113b4a3>] process_one_work+0x273/0x8d0
[    2.227005]  [<ffffffff8113b43f>] ? process_one_work+0x20f/0x8d0
[    2.227007]  [<ffffffff8113bd0d>] worker_thread+0x20d/0x7e0
[    2.227009]  [<ffffffff8113bb00>] ? process_one_work+0x8d0/0x8d0
[    2.227011]  [<ffffffff81146dfd>] kthread+0x13d/0x1a0
[    2.227016]  [<ffffffff81b3232f>] ret_from_fork+0x1f/0x40
[    2.227018]  [<ffffffff81146cc0>] ? kthread_create_on_node+0x260/0x260
[    2.227019]
================================================================================

-- 
You are receiving this mail because:
You are the assignee for the bug.
