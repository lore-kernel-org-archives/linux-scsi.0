Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21355C48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 09:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F00C161360
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 09:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhFNJ1s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 05:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbhFNJ1s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 05:27:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B74C061574;
        Mon, 14 Jun 2021 02:25:32 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id i34so8122904pgl.9;
        Mon, 14 Jun 2021 02:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wjN8a0EGeqE9LNcBiuTFm+bgbpIcigjwLa6fsDxcLV4=;
        b=CnuKhxt8AiC4+cIqhYQhbOQmfuFq/3Yd5HMgEzHrYzqrip2wZZBcQbWl4/scIoK5Vt
         UGQWWcVTzNX3YdXrzuM58oaagFI38Lwt1avLa/MuNbOyBJIwToIXaKjjx3Dyr3PfYtFt
         wiwhqVbkbF/wg5xQAU5qgkSNqjK6CMZL4/T8C/Rz0UYYSTT2RRha3LS0J3osNSFfcbTU
         d20GkJFFCLPBJy8QrgchbojKDyESRhC5/Bj1XGxU7iI6TqkBcl2vNQUvv3biHkeszl1+
         L5USA2/hvcc6SQO+cEZlRESHgNgu9cIWXl8GiuzvQ0obUeIiPnPAS2PgdU3Va5ARWDSy
         DI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wjN8a0EGeqE9LNcBiuTFm+bgbpIcigjwLa6fsDxcLV4=;
        b=ue1S/05FBr6Rar7VyIzQs8nexRW0XeJ7W8wQlMcfAv9emfhSct+t3g+zL3EvM+Ivtf
         1xqqFQ6sz9IuCtMHEo/wUxUxAmK4Wv7sodAHCXosSyE18KiTisLu/q5oC6KBLolWb1j3
         wvv1AHLON5P6HxL3xBCW0PqI2Zgoc2f2HLjA9jllgpQ4coxghiJBzHTTBl6MnssCdDVL
         Mm4SI5l5VW4X420FcDj5nK3w5A7xzdyiyANXUW+j2Qt5m1Burz56T1mcRlbWbcWVg8OB
         5CA6R1Pu11XaUB1bDUtWxDyt3+Gy+KAcnjygrifsGBvFwmEGDi7ZfdfukVTZm1cAsUjN
         trQw==
X-Gm-Message-State: AOAM533cQ5D1+prEFErHNkIq4uufoo6OL7jj19ZROxc55KkOJ8I3QaDo
        mtKPiwfLdVgb3+RQdTXSJg==
X-Google-Smtp-Source: ABdhPJw9cggxQ+yyOVAOtHaBjoZfQ+k94q0CKpCDoy8ATpuSO2kYZ0NRi/MDvJ6r78HThiSDM3jFWw==
X-Received: by 2002:a62:5547:0:b029:2ec:8f20:4e2 with SMTP id j68-20020a6255470000b02902ec8f2004e2mr20984033pfb.71.1623662732035;
        Mon, 14 Jun 2021 02:25:32 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id 194sm12109566pfb.139.2021.06.14.02.25.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jun 2021 02:25:31 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     hare@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] scsi: myrs: add a check against null pointer dereference
Date:   Mon, 14 Jun 2021 09:25:04 +0000
Message-Id: <1623662704-10139-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the process of driver loading, the driver may fail at the place of
'myrs_enable_mmio_mbox', resulting in calling the 'myrs_cleanup'
function, but at this time, 'cs->disable' has not been assigned, so a
null pointer dereference is caused.

Fix this by check whether 'cs->disable_intr' is a null pointer.

This log reveals it:

[    2.777884] BUG: kernel NULL pointer dereference, address: 0000000000000000
[    2.778357] #PF: supervisor instruction fetch in kernel mode
[    2.778742] #PF: error_code(0x0010) - not-present page
[    2.779093] PGD 0 P4D 0
[    2.779272] Oops: 0010 [#1] PREEMPT SMP PTI
[    2.779560] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.12.4-g70e7f0549188-dirty #103
[    2.780090] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    2.780885] RIP: 0010:0x0
[    2.781077] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[    2.781538] RSP: 0000:ffffc90000017b60 EFLAGS: 00010293
[    2.781893] RAX: ffff8881001e0000 RBX: ffff888107a7cdb0 RCX: 0000000000000000
[    2.782376] RDX: 0000000000000000 RSI: ffffffff824409c6 RDI: ffff888107a7cdb0
[    2.782803] RBP: ffffc90000017b80 R08: 0000000000000001 R09: 0000000000000001
[    2.782803] R10: 0000000000000000 R11: 0000000000000001 R12: ffff888101c34000
[    2.782803] R13: ffff888007840000 R14: ffffc90000091000 R15: ffffffff82443300
[    2.782803] FS:  0000000000000000(0000) GS:ffff88817bcc0000(0000) knlGS:0000000000000000
[    2.782803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.782803] CR2: ffffffffffffffd6 CR3: 0000000005e2e000 CR4: 00000000000006e0
[    2.782803] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.782803] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    2.782803] Call Trace:
[    2.782803]  myrs_cleanup+0x10f/0x190
[    2.782803]  myrs_probe+0x839/0xa20
[    2.782803]  ? kcov_remote_start+0x17b/0x430
[    2.782803]  ? trace_hardirqs_on+0x55/0x130
[    2.782803]  ? _raw_spin_unlock_irqrestore+0x35/0x5d
[    2.782803]  local_pci_probe+0x4a/0xb0
[    2.782803]  ? local_pci_probe+0x4a/0xb0
[    2.782803]  pci_device_probe+0x126/0x1d0
[    2.782803]  ? pci_device_remove+0x100/0x100
[    2.782803]  really_probe+0x27e/0x650
[    2.782803]  driver_probe_device+0x84/0x1d0
[    2.782803]  ? mutex_lock_nested+0x16/0x20
[    2.782803]  device_driver_attach+0x63/0x70
[    2.782803]  __driver_attach+0x117/0x1a0
[    2.782803]  ? device_driver_attach+0x70/0x70
[    2.782803]  bus_for_each_dev+0xb6/0x110
[    2.782803]  ? rdinit_setup+0x40/0x40
[    2.782803]  driver_attach+0x22/0x30
[    2.782803]  bus_add_driver+0x1e6/0x2a0
[    2.782803]  driver_register+0xa4/0x180
[    2.782803]  __pci_register_driver+0x77/0x80
[    2.782803]  ? myrb_init_module+0x62/0x62
[    2.782803]  myrs_init_module+0x41/0x62
[    2.782803]  do_one_initcall+0x7a/0x3d0
[    2.782803]  ? rdinit_setup+0x40/0x40
[    2.782803]  ? rcu_read_lock_sched_held+0x4a/0x70
[    2.782803]  kernel_init_freeable+0x2a7/0x2f9
[    2.782803]  ? rest_init+0x2c0/0x2c0
[    2.782803]  kernel_init+0x13/0x180
[    2.782803]  ? rest_init+0x2c0/0x2c0
[    2.782803]  ? rest_init+0x2c0/0x2c0
[    2.782803]  ret_from_fork+0x1f/0x30
[    2.782803] Modules linked in:
[    2.782803] Dumping ftrace buffer:
[    2.782803]    (ftrace buffer empty)
[    2.782803] CR2: 0000000000000000
[    2.782803] ---[ end trace c5cb7be94bce994d ]---
[    2.782803] RIP: 0010:0x0
[    2.782803] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[    2.782803] RSP: 0000:ffffc90000017b60 EFLAGS: 00010293
[    2.782803] RAX: ffff8881001e0000 RBX: ffff888107a7cdb0 RCX: 0000000000000000
[    2.782803] RDX: 0000000000000000 RSI: ffffffff824409c6 RDI: ffff888107a7cdb0
[    2.782803] RBP: ffffc90000017b80 R08: 0000000000000001 R09: 0000000000000001
[    2.782803] R10: 0000000000000000 R11: 0000000000000001 R12: ffff888101c34000
[    2.782803] R13: ffff888007840000 R14: ffffc90000091000 R15: ffffffff82443300
[    2.782803] FS:  0000000000000000(0000) GS:ffff88817bcc0000(0000) knlGS:0000000000000000
[    2.782803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.782803] CR2: ffffffffffffffd6 CR3: 0000000005e2e000 CR4: 00000000000006e0
[    2.782803] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    2.782803] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    2.782803] Kernel panic - not syncing: Fatal exception
[    2.782803] Dumping ftrace buffer:
[    2.782803]    (ftrace buffer empty)
[    2.782803] Kernel Offset: disabled
[    2.782803] Rebooting in 1 seconds..

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/scsi/myrs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 3b68c68d1716..875ef60ebdd0 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2268,8 +2268,10 @@ static void myrs_cleanup(struct myrs_hba *cs)
 	/* Free the memory mailbox, status, and related structures */
 	myrs_unmap(cs);
 
-	if (cs->mmio_base) {
+	if (cs->disable_intr)
 		cs->disable_intr(cs);
+
+	if (cs->mmio_base) {
 		iounmap(cs->mmio_base);
 		cs->mmio_base = NULL;
 	}
-- 
2.17.6

