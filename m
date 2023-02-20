Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECED0C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Feb 2023 02:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBTCHE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Feb 2023 21:07:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTCHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Feb 2023 21:07:03 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC9BC646
        for <linux-scsi@vger.kernel.org>; Sun, 19 Feb 2023 18:07:01 -0800 (PST)
Received: from dggpemm500014.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PKlzQ00jLzJrFB;
        Mon, 20 Feb 2023 10:02:09 +0800 (CST)
Received: from [10.174.178.78] (10.174.178.78) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 20 Feb 2023 10:06:58 +0800
Message-ID: <93fce633-b96d-3206-b98d-72a0996d8f6e@huawei.com>
Date:   Mon, 20 Feb 2023 10:06:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
To:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <michael.christie@oracle.com>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>, <haowenchao2@huawei.com>
From:   "wangzhiqiang (Q)" <wangzhiqiang95@huawei.com>
Subject: [bug report]iscsi target: kernel crashed with stack in
 iscsi_target_mod
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.78]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We are using targetcli to simulate iscsi target with linux kernel 4.18,
BUG_ON stack is triggered in following steps:

on iscsi server: using targetcli to simulate iscsi target

on iscsi client:
1. discovery iscsi target simulated by targetcli
2. read/write the iscsi disks, login/logout the iscsi nodes as following scripts

The stack is like following:

[20638.429859] kernel BUG at mm/usercopy.c:103!
[20638.430247] invalid opcode: 0000 [#1] SMP PTI
[20638.430609] CPU: 0 PID: 224776 Comm: iscsi_trx Kdump: loaded Tainted: G W O --------- - - 4.18.0-147.5.2.19.h1140.x86_64 #1
[20638.431695] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58-20211121_093514-szxrtosci10000 04/01/2014
[20638.432681] RIP: 0010:usercopy_abort+0x69/0x80
[20638.433047] Code: 44 d0 53 48 c7 c0 d5 e9 4a 91 51 48 c7 c6 75 b3 49 91 41 53 48 89 f9 48 0f 45 f0 4c 89 d2 48 c7 c7 a0 ea 4a 91 e8 50 3e e5 ff <0f> 0b 49 c7 c1 c3 0c 4c 91 4d 89 cb 4d 89 c8 eb a5 66 0f 1f 44 00
[20638.434544] RSP: 0018:ffffb1be0d137b50 EFLAGS: 00010282
[20638.434974] RAX: 0000000000000065 RBX: 0000000000000800 RCX: 0000000000000000
[20638.435550] RDX: 0000000000000000 RSI: ffff8dedb6c16a08 RDI: ffff8dedb6c16a08
[20638.436157] RBP: 0000000000000800 R08: 0000000000000000 R09: ffffffff9165c260
[20638.436735] R10: ffffffff914e9c9e R11: ffffffff91e7ffcd R12: 0000000000000001
[20638.437345] R13: ffff8dec83381c00 R14: 0000000000000000 R15: 0000000000001c00
[20638.437930] FS: 0000000000000000(0000) GS:ffff8dedb6c00000(0000) knlGS:0000000000000000
[20638.438663] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[20638.439130] CR2: 00007fa37a724426 CR3: 000000016960a003 CR4: 0000000000360ef0
[20638.439779] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[20638.440360] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[20638.440948] Call Trace:
[20638.441163] __check_heap_object+0xe5/0x110
[20638.441509] __check_object_size+0xd4/0x1a0
[20638.441862] simple_copy_to_iter+0x25/0x40
[20638.442204] __skb_datagram_iter+0x197/0x2e0
[20638.442560] ? skb_kill_datagram+0x70/0x70
[20638.442901] skb_copy_datagram_iter+0x3b/0x90
[20638.443260] tcp_recvmsg+0x286/0xc60
[20638.443562] inet_recvmsg+0x5b/0xd0
[20638.443866] iscsit_do_rx_data+0x9a/0x120 [iscsi_target_mod]
[20638.444334] rx_data+0x68/0x90 [iscsi_target_mod]
[20638.444752] iscsit_get_rx_pdu+0xbb8/0xfa0 [iscsi_target_mod]
[20638.445222] ? __switch_to_asm+0x35/0x70
[20638.445546] ? __switch_to_asm+0x41/0x70
[20638.445885] ? wait_for_completion_interruptible+0x5c/0x1e0
[20638.446346] ? iscsi_target_tx_thread+0x1f0/0x1f0 [iscsi_target_mod]
[20638.446875] ? iscsi_target_rx_thread+0xb8/0xf0 [iscsi_target_mod]
[20638.447383] iscsi_target_rx_thread+0xb8/0xf0 [iscsi_target_mod]
[20638.447886] kthread+0x10d/0x130
[20638.448156] ? kthread_flush_work_fn+0x10/0x10
[20638.448523] ret_from_fork+0x35/0x40
