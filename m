Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE26C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 04:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 756A864E86
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 04:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhBSEQE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 23:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhBSEP7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 23:15:59 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3581FC061574;
        Thu, 18 Feb 2021 20:15:19 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id h8so4464992qkk.6;
        Thu, 18 Feb 2021 20:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVCmF3ws8FbqzWQAK+DyZlD4me7/CaLqt7Iz9rmkqMQ=;
        b=jxFyFuPMri4oxjvCz8FlnMQ8bqepISfsmhn7L1iKkO7Pt/3in7f7o1rlGjS9DzO2hg
         d9OOXi/prv5C8r9J88QKaCrJ1nEQ8tFapQcOQku8e0g7+Kw5ICcc5Fy6macQuni32Qzu
         tEIt8SWR3uU3dn03LXjAWQOIVwH9Huwb4PGC80I8TbsmnzVuSFrbFlj+dkirITaVxz1S
         Rmjb3S2TskJz+/+frat7juWTauN2iuVfQP+pKL4XGrMlFX4xCHhaenqM5WZZ2PzuSomV
         Yy4u8v0AkWn7We074Bld29GV0a3kzZkcEEi9ETc6LD7b1FLZNsR0f/E7HcpusIaDACei
         TSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GVCmF3ws8FbqzWQAK+DyZlD4me7/CaLqt7Iz9rmkqMQ=;
        b=Szesnvf2eoNyEpkfT3BeNDVjPyOgXmz+TYxrLDKBElO9e4MwvN/aEzrm3R7uk6hj0q
         sUT2S6B+6WjLAs8945BwOMZXPo0v8GaRAm7u4jDoxS7JM40hyugaHfSw5jDx4BuXaqkh
         lqslX0xi+J9ESJ1StyubLf+CCGR1Bn4equbnODUXqWqZsfumPZzOcq/QG5TrMCuvQXtJ
         40rVl+kppBPkAPwkv9o9ZgF/0EzWBnoSXFXptuWPbxREp4XvwUsE8jlhYwY4e8Ob/hsW
         A8nu2rqN1usuDySXDmYFd6vVqMfx/osyK3BCk6vFFhs4yBmneAsDPYhdJMVhKqCWz4S1
         lh0g==
X-Gm-Message-State: AOAM530eHYi4aCo+uXAwFc2dn0TC4WtgQ14OdiTusnvYAlTS+khDjdIK
        wFhuyJs+DvRIe8N+tsBRrROTqwHZoioP2A==
X-Google-Smtp-Source: ABdhPJxzAZ/4CVvt8nv4VLIxS7KcTqPERQ7WcNpv7/LxciJik9Qz80Bmy7svx9KdTGXfZFgQWxmmyQ==
X-Received: by 2002:a37:59c1:: with SMTP id n184mr8029001qkb.67.1613708118276;
        Thu, 18 Feb 2021 20:15:18 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b099:92c4:d106:c50])
        by smtp.googlemail.com with ESMTPSA id w35sm769192qte.52.2021.02.18.20.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 20:15:17 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        ching Huang <ching2048@areca.com.tw>,
        Lee Jones <lee.jones@linaro.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH] scsi: arcmsr: catch bounds error earlier and dont panic
Date:   Thu, 18 Feb 2021 23:14:53 -0500
Message-Id: <20210219041454.3269603-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

pARCMSR_CDB is calculated from a base address + a value read from
controller with some bit shifting, the value is not checked and could possibly
overflow the buffer and cause panic. The buffer is allocated using
dma_alloc_coherent and the size is acb->uncache_size.
Instead of crashing the system, we can try to catch the bounds error
earlier and return an error.

[   25.820995] BUG: unable to handle page fault for address: ffffed1010383dd3
[   25.821451] #PF: supervisor read access in kernel mode
[   25.821737] #PF: error_code(0x0000) - not-present page
[   25.822023] PGD 17fff1067 P4D 17fff1067 PUD 17fff0067 PMD 0
[   25.822342] Oops: 0000 [#1] SMP KASAN NOPTI
[   25.822578] CPU: 0 PID: 66 Comm: kworker/u2:2 Not tainted 5.11.0 #27
[   25.822931] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-4
[   25.823553] Workqueue: scsi_tmf_6 scmd_eh_abort_handler
[   25.823853] RIP: 0010:__asan_load8+0x3c/0xa0
[   25.824097] Code: 00 00 00 00 00 00 ff 48 39 f8 77 57 48 8d 47 07 48 89 c2 83 e2 07 48 83 fa 07 78
[   25.825123] RSP: 0018:ffff888101ea7d10 EFLAGS: 00010a03
[   25.825417] RAX: 1ffff11010383dd3 RBX: ffff888102a2a8c8 RCX: ffffffffc000ac23
[   25.825813] RDX: dffffc0000000000 RSI: ffffc90004000030 RDI: ffff888081c1ee98
[   25.826210] RBP: ffff888081c1eec0 R08: ffffffffc000a5ea R09: ffffed102054551a
[   25.826606] R10: ffff888102a2a8cb R11: ffffed1020545519 R12: ffff888081c1ee80
[   25.827004] R13: 0000000081c1ee00 R14: ffff888102a28000 R15: ffffc90004000030
[   25.827400] FS:  0000000000000000(0000) GS:ffff88815b400000(0000) knlGS:0000000000000000
[   25.827853] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.828174] CR2: ffffed1010383dd3 CR3: 00000001029ca000 CR4: 00000000000006f0
[   25.828570] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   25.828966] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   25.829362] Call Trace:
[   25.829503]  arcmsr_abort.cold+0xd41/0xf40 [arcmsr]
[   25.829788]  ? __schedule+0x5ae/0xd40
[   25.829999]  scmd_eh_abort_handler+0xbd/0x1a0
[   25.830247]  process_one_work+0x470/0x750
[   25.830476]  worker_thread+0x73/0x690
[   25.830685]  ? process_one_work+0x750/0x750
[   25.830922]  kthread+0x199/0x1f0
[   25.831108]  ? kthread_create_on_node+0xd0/0xd0
[   25.831363]  ret_from_fork+0x1f/0x30
[   25.831571] Modules linked in: arcmsr(+)
[   25.831796] CR2: ffffed1010383dd3
[   25.831984] ---[ end trace 4a558ca3660a5f82 ]---
[   25.832243] RIP: 0010:__asan_load8+0x3c/0xa0
[   25.832485] Code: 00 00 00 00 00 00 ff 48 39 f8 77 57 48 8d 47 07 48 89 c2 83 e2 07 48 83 fa 07 78
[   25.833512] RSP: 0018:ffff888101ea7d10 EFLAGS: 00010a03
[   25.833805] RAX: 1ffff11010383dd3 RBX: ffff888102a2a8c8 RCX: ffffffffc000ac23
[   25.834201] RDX: dffffc0000000000 RSI: ffffc90004000030 RDI: ffff888081c1ee98
[   25.834596] RBP: ffff888081c1eec0 R08: ffffffffc000a5ea R09: ffffed102054551a
[   25.834992] R10: ffff888102a2a8cb R11: ffffed1020545519 R12: ffff888081c1ee80
[   25.835388] R13: 0000000081c1ee00 R14: ffff888102a28000 R15: ffffc90004000030
[   25.835784] FS:  0000000000000000(0000) GS:ffff88815b400000(0000) knlGS:0000000000000000
[   25.836229] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.836547] CR2: ffffed1010383dd3 CR3: 00000001029ca000 CR4: 00000000000006f0
[   25.836940] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   25.837333] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4b79661275c9..e0227bf12ab2 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1482,6 +1482,11 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 		while(((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)
 				&& (i++ < acb->maxOutstanding)) {
 			ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
+			if (ccb_cdb_phy>=acb->uncache_size) {
+				printk(KERN_WARNING "arcmsr%d: ccb_cdb_phy bounds error detected",
+					 acb->host->host_no);
+				break;
+			}
 			if (acb->cdb_phyadd_hipart)
 				ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
 			pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
@@ -2451,6 +2456,11 @@ static void arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 
 	while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
 		cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
+		if (cdb_phy_addr>=acb->uncache_size) {
+			printk(KERN_WARNING "arcmsr%d: cdb_phy_addr bounds error detected",
+				 acb->host->host_no);
+			break;
+		}
 		if (acb->cdb_phyadd_hipart)
 			cdb_phy_addr = cdb_phy_addr | acb->cdb_phyadd_hipart;
 		pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + cdb_phy_addr);
@@ -3503,6 +3513,11 @@ static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
 			}
 		}
 		ccb_cdb_phy = (flag_ccb << 5) & 0xffffffff;
+		if (ccb_cdb_phy>=acb->uncache_size) {
+			printk(KERN_WARNING "arcmsr%d: ccb_cdb_phy bounds error detected",
+				 acb->host->host_no);
+			return FAILED;
+		}
 		if (acb->cdb_phyadd_hipart)
 			ccb_cdb_phy = ccb_cdb_phy | acb->cdb_phyadd_hipart;
 		arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
-- 
2.25.1

