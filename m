Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81517C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jan 2022 14:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353852AbiALOBY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jan 2022 09:01:24 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:52642 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353851AbiALOBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jan 2022 09:01:21 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 044F01F3BB;
        Wed, 12 Jan 2022 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641996080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=/i9uVuUZGTOuLja57DPzC6tRbTBoUugZkJuAdC9146Y=;
        b=uCMwrEWItMtj900Dq2lfFuesUtHG3cG5ChFlb40VYWj4mbNloVFIeiEReoyFCk0i88awcs
        mSYnn1jMhbYwS0wHBKrG7r9+rpWG4tuwRVwuUIJRa6hOlOK/ioBtGYSbS3AaB+vw019wn8
        89udbCCgFocg1rn5AWuBQeUZrBoGBCA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A13731402B;
        Wed, 12 Jan 2022 14:01:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eSQCJS/f3mHAbQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 12 Jan 2022 14:01:19 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: mpt3sas: avoid watchdog issue while releasing chain buffers
Date:   Wed, 12 Jan 2022 15:01:13 +0100
Message-Id: <20220112140113.26560-1-mwilck@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

I observe the watchdog timer being triggered while unloading the
mpt3sas driver:

Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: mpt3sas_base_detach
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: mpt3sas_base_free_resources
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: mpt3sas_base_make_ioc_ready
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: sending message unit reset !!
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: message unit reset: SUCCESS
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: mpt3sas_base_unmap_resources
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: _base_release_memory_pools
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: request_pool(0x00000000144b1531): free
Jan 12 12:25:51 tegmen kernel: mpt2sas_cm0: sense_pool(0x000000009665c238): free
Jan 12 12:25:52 tegmen kernel: mpt2sas_cm0: reply_pool(0x000000005c5e0fa5): free
Jan 12 12:25:52 tegmen kernel: mpt2sas_cm0: reply_free_pool(0x000000006f897f6c): free
Jan 12 12:25:52 tegmen kernel: mpt2sas_cm0: reply_post_free_pool(0x00000000d1edc4aa): free
Jan 12 12:25:52 tegmen kernel: mpt2sas_cm0: config_page(0x000000009f651842): free
Jan 12 12:26:23 tegmen kernel: watchdog: BUG: soft lockup - CPU#27 stuck for 26s! [rmmod:2594]
Jan 12 12:26:23 tegmen kernel: Hardware name: HP ProLiant DL560 Gen8, BIOS P77 05/24/2019
Jan 12 12:26:23 tegmen kernel: RIP: 0010:_raw_spin_unlock_irqrestore+0x26/0x2e
Jan 12 12:26:23 tegmen kernel: Code: 1f 44 00 00 0f 1f 44 00 00 c6 07 00 0f 1f 40 00 f7 c6 00 02 00 00 75 0b 65 ff 0d 05 ce a1 5f 74 0>
Jan 12 12:26:23 tegmen kernel: RSP: 0018:ffffab1546bdfcc8 EFLAGS: 00000206
Jan 12 12:26:23 tegmen kernel: RAX: 0000000000000c80 RBX: ffff8d82b0f16700 RCX: 0000000000000d00
Jan 12 12:26:23 tegmen kernel: RDX: 0000000453642d00 RSI: 0000000000000282 RDI: ffff8d8292075f90
Jan 12 12:26:23 tegmen kernel: RBP: ffff8d8292075f80 R08: 0000000000000000 R09: 0000000000000001
Jan 12 12:26:23 tegmen kernel: R10: 0000000000000003 R11: ffff8d8284256a00 R12: ffff8d8293642d00
Jan 12 12:26:23 tegmen kernel: R13: ffff8d8292075f90 R14: 0000000000000282 R15: 0000000000000d00
Jan 12 12:26:23 tegmen kernel: FS:  00007fbd96388740(0000) GS:ffff8d8e7f6c0000(0000) knlGS:0000000000000000
Jan 12 12:26:23 tegmen kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 12 12:26:23 tegmen kernel: CR2: 000055bbd50f9918 CR3: 0000000c80b0c001 CR4: 00000000000606e0
Jan 12 12:26:23 tegmen kernel: Call Trace:
Jan 12 12:26:23 tegmen kernel:  <TASK>
Jan 12 12:26:23 tegmen kernel:  dma_pool_free+0xc1/0x100
Jan 12 12:26:23 tegmen kernel:  _base_release_memory_pools+0x343/0x4c0 [mpt3sas 6ff0715b1f6f07c16051cb2772836069b2821b01]
Jan 12 12:26:23 tegmen kernel:  mpt3sas_base_detach+0x2e/0x130 [mpt3sas 6ff0715b1f6f07c16051cb2772836069b2821b01]

When the driver is unloaded during system shutdown, this may actually cause a
kernel panic triggered by the watchdog.

The problem is that with the hardware in question, the driver allocates a very
large number of DMA buffers for chain lookup (scsiio_depth = 29868,
chains_needed_per_io = 15, total number of buffers = 448020). The loop that
frees all DMA buffers takes ~30s to execute. By adding a cond_resched() in the
loop, the watchdog is avoided.

Note: This is the 2nd issue I saw with this controller and the reported can_queue
value after https://lore.kernel.org/linux-scsi/Ydug9nWg4loEVkJw@T590/T/

Fixes: 93204b782a88 ("scsi: mpt3sas: Lockless access for chain buffers.")
Signed-off-by: Martin Wilck <mwilck@suse.com>
CC: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 81dab9b82f79..943ea7e0fef0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5715,6 +5715,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 						ct->chain_buffer_dma);
 			}
 			kfree(ioc->chain_lookup[i].chains_per_smid);
+			cond_resched();
 		}
 		dma_pool_destroy(ioc->chain_dma_pool);
 		kfree(ioc->chain_lookup);
-- 
2.34.1

