Return-Path: <SRS0=T0eU=YJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADB5FA372B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Oct 2019 19:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E48221925
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Oct 2019 19:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="hOK40AHG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394379AbfJPTgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Oct 2019 15:36:16 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45373 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389320AbfJPTgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2019 15:36:15 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so37825815qtj.12
        for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2019 12:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=XhqMtTtPjnVHf4MRHyu9Wk/DTVhF7/1js0A5sMaNbck=;
        b=hOK40AHG6hoyWk6NBAz2XfgAPBqvAp13pna631Lkde03m88/78GnIofVEDcr1P/ucp
         G6oBH+OmrTAjAl2iYjxAQOlyc009wVkN4HEj5R8fdvcUfQsHebq2sGXGo5Llb5rQuc2L
         4UptALhBX8nbkyGFxrjfHL+daCAmRkuAEcGMIfSaQ+1g2bqEslI1ffIAeJK0t1BZ7Awx
         g78NJxGcLcfDyh9BskoPPEx6mYsrZK4nKCquIKMiWvP6YFxIBTgeLC5u6gmM4nfmG/w0
         m9DwEMqjt5OFen4Qgh+s0+dC6XQJo61xS4hg9aEImR/El7ASEy258i+I/9hQL4u+3y62
         GQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XhqMtTtPjnVHf4MRHyu9Wk/DTVhF7/1js0A5sMaNbck=;
        b=SQEBSxSg9ja/W7kK4iiols+q6bfggnALU4dhs6gAtuaITZOMdZumPNXfAE5SVoMa7m
         jmok3qLe4KTbXUZAKlSAoaeU1nUq3NZFav7DCDbuuxdgJwH3N9jkPvXrpmW2Z58+W8mI
         QgxysfxD3jg7eMJXTKiKiKrmkg1+T4dbZdmgiJZi27SL7ReLGepfsmIuI245IYOa3bO8
         yM0RlCGFk7G+CX46CjWX8pNS+ayyM8UUl4Y2B6EkOI3QjKkVLj14R7zEshP5G2uc7lDC
         rCmsIZ27PDQmcC3BMqijwiZWjvyc9KUTJT8WP7kXzic9fDAPHdMXc55zEmJ6FnJ89Pj4
         Uapg==
X-Gm-Message-State: APjAAAVqPYk8Qg8hqOhw+Q+jhuQRPmnPe3zpM4WLr21kERo/OSJOctBM
        9AYkeNInRQx4wFyvODtQEDOzHQ==
X-Google-Smtp-Source: APXvYqzExMDPAiqvQe8gflBCuAA9bzOOm0S0zX93+2/lQbsLQM0TdLICSfJFn1e4q54HbgnVQgxgVw==
X-Received: by 2002:a0c:8731:: with SMTP id 46mr44133352qvh.141.1571254574271;
        Wed, 16 Oct 2019 12:36:14 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 139sm12852406qkf.14.2019.10.16.12.36.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 12:36:13 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     jroedel@suse.de
Cc:     iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        don.brace@microsemi.com, esc.storagedev@microsemi.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, Qian Cai <cai@lca.pw>
Subject: [PATCH -next] iommu/amd: fix a warning in increase_address_space
Date:   Wed, 16 Oct 2019 15:35:42 -0400
Message-Id: <1571254542-13998-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After the commit 754265bcab78 ("iommu/amd: Fix race in
increase_address_space()"), it could still possible trigger a race
condition under some heavy memory pressure below. The race to trigger a
warning is,

CPU0:				CPU1:
in alloc_pte():		in increase_address_space():
while (address > PM_LEVEL_SIZE(domain->mode)) [1]

				spin_lock_irqsave(&domain->lock
				domain->mode    += 1;
				spin_unlock_irqrestore(&domain->lock

in increase_address_space():
spin_lock_irqsave(&domain->lock
if (WARN_ON_ONCE(domain->mode == PAGE_MODE_6_LEVEL))

[1] domain->mode = 5

It is unclear the triggering of the warning is the root cause of the
smartpqi offline yet, but let's fix it first by lifting the locking.

WARNING: CPU: 57 PID: 124314 at drivers/iommu/amd_iommu.c:1474
iommu_map_page+0x718/0x7e0
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec0000 flags=0x0010]
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec1000 flags=0x0010]
CPU: 57 PID: 124314 Comm: oom01 Tainted: G           O
Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40
07/10/2019
RIP: 0010:iommu_map_page+0x718/0x7e0
Code: 88 a5 70 ff ff ff e9 5d fa ff ff 48 8b b5 70 ff ff ff 4c 89 ef e8
08 32 2f 00 41 80 fc 01 0f 87 b7 3d 00 00 41 83 e4 01 eb be <0f> 0b 48
8b b5 70 ff ff ff 4c 89 ef e8 e7 31 2f 00 eb dd 0f 0b 48
RSP: 0018:ffff888da4816cb8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8885fe689000 RCX: ffffffff96f4a6c4
RDX: 0000000000000007 RSI: dffffc0000000000 RDI: ffff8885fe689124
RBP: ffff888da4816da8 R08: ffffed10bfcd120e R09: ffffed10bfcd120e
R10: ffffed10bfcd120d R11: ffff8885fe68906b R12: 0000000000000000
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec1a00 flags=0x0010]
R13: ffff8885fe689068 R14: ffff8885fe689124 R15: 0000000000000000
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec1e00 flags=0x0010]
FS:  00007f29722ba700(0000) GS:ffff88902f880000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f27f82d8000 CR3: 000000102ed9c000 CR4: 00000000003406e0
Call Trace:
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec2000 flags=0x0010]
 map_sg+0x1ce/0x2f0
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec2400 flags=0x0010]
 scsi_dma_map+0xd7/0x160
 pqi_raid_submit_scsi_cmd_with_io_request+0x1b8/0x420 [smartpqi]
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec2800 flags=0x0010]
 pqi_scsi_queue_command+0x8ab/0xe00 [smartpqi]
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec2c00 flags=0x0010]
 scsi_queue_rq+0xd19/0x1360
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec3000 flags=0x0010]
 __blk_mq_try_issue_directly+0x295/0x3f0
smartpqi 0000:23:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0000
address=0xffffffffffec3400 flags=0x0010]
AMD-Vi: Event logged [IO_PAGE_FAULT device=23:00.0 domain=0x0000
address=0xffffffffffec3800 flags=0x0010]
 blk_mq_request_issue_directly+0xb5/0x100
AMD-Vi: Event logged [IO_PAGE_FAULT device=23:00.0 domain=0x0000
address=0xffffffffffec3c00 flags=0x0010]
 blk_mq_try_issue_list_directly+0xa9/0x160
 blk_mq_sched_insert_requests+0x228/0x380
 blk_mq_flush_plug_list+0x448/0x7e0
 blk_flush_plug_list+0x1eb/0x230
 blk_finish_plug+0x43/0x5d
 shrink_node_memcg+0x9c5/0x1550
smartpqi 0000:23:00.0: controller is offline: status code 0x14803
smartpqi 0000:23:00.0: controller offline

Fixes: 754265bcab78 ("iommu/amd: Fix race in increase_address_space()")
Signed-off-by: Qian Cai <cai@lca.pw>
---

BTW, Joerg, this line from the commit "iommu/amd: Remove domain->updated" looks
suspicious. Not sure what the purpose of it.

*updated = increase_address_space(domain, gfp) || *updated;

 drivers/iommu/amd_iommu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 2369b8af81f3..a5754068aa29 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1465,12 +1465,9 @@ static void free_pagetable(struct protection_domain *domain)
 static bool increase_address_space(struct protection_domain *domain,
 				   gfp_t gfp)
 {
-	unsigned long flags;
 	bool ret = false;
 	u64 *pte;
 
-	spin_lock_irqsave(&domain->lock, flags);
-
 	if (WARN_ON_ONCE(domain->mode == PAGE_MODE_6_LEVEL))
 		/* address space already 64 bit large */
 		goto out;
@@ -1487,8 +1484,6 @@ static bool increase_address_space(struct protection_domain *domain,
 	ret = true;
 
 out:
-	spin_unlock_irqrestore(&domain->lock, flags);
-
 	return ret;
 }
 
@@ -1499,14 +1494,19 @@ static u64 *alloc_pte(struct protection_domain *domain,
 		      gfp_t gfp,
 		      bool *updated)
 {
+	unsigned long flags;
 	int level, end_lvl;
 	u64 *pte, *page;
 
 	BUG_ON(!is_power_of_2(page_size));
 
+	spin_lock_irqsave(&domain->lock, flags);
+
 	while (address > PM_LEVEL_SIZE(domain->mode))
 		*updated = increase_address_space(domain, gfp) || *updated;
 
+	spin_unlock_irqrestore(&domain->lock, flags);
+
 	level   = domain->mode - 1;
 	pte     = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 	address = PAGE_SIZE_ALIGN(address, page_size);
-- 
1.8.3.1

