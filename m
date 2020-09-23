Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A60C4741F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 08:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 926982223E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 08:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600850718;
	bh=XiMksB5vz2ze+VmO+JGKzgUGIZoRdpPjoIOpgvM1pXk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=hQXVhQk9SHyUQOsp+j2QwepBROjGuzJ7BUmK/tjibzzUhngSdTTf1yb2fLSarj/VQ
	 3dJfFGKGkN0yjtMXskvBhnbmtpPjejisBcoZwebYQFHfS0tBrAKM04hsVzhXYW+609
	 ryxjdUoEX/qBpDmqjdc4bWoY0Y6NggfCQSBnVy4k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIWIpP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Sep 2020 04:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbgIWIpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Sep 2020 04:45:15 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F35D8221F0;
        Wed, 23 Sep 2020 08:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600850714;
        bh=XiMksB5vz2ze+VmO+JGKzgUGIZoRdpPjoIOpgvM1pXk=;
        h=From:To:Cc:Subject:Date:From;
        b=h2xwP5DQ0bctD7XTG5Z6nKDVDxbn+URT70n7ElGTtzrGj47WkvlDo5ns9tkht1apq
         dCFDwDzfuvFBc64PyzX+Y+Uc7IGyzOZnnDbZ1adriwxnzLOzOFAa0LF3t7EBLJIArg
         VjtTePTWiddXb2CK7kpbY2eiXpzxaP9P/2piwZjk=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: fix slab leak of rpages pointer
Date:   Wed, 23 Sep 2020 01:45:12 -0700
Message-Id: <20200923084512.2947439-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes the below mem leak.

[  130.157600] =============================================================================
[  130.159662] BUG f2fs_page_array_entry-252:16 (Tainted: G        W  O     ): Objects remaining in f2fs_page_array_entry-252:16 on __kmem_cache_shutdown()
[  130.162742] -----------------------------------------------------------------------------
[  130.162742]
[  130.164979] Disabling lock debugging due to kernel taint
[  130.166188] INFO: Slab 0x000000009f5a52d2 objects=22 used=4 fp=0x00000000ba72c3e9 flags=0xfffffc0010200
[  130.168269] CPU: 7 PID: 3560 Comm: umount Tainted: G    B   W  O      5.9.0-rc4+ #35
[  130.170019] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
[  130.171941] Call Trace:
[  130.172528]  dump_stack+0x74/0x9a
[  130.173298]  slab_err+0xb7/0xdc
[  130.174044]  ? kernel_poison_pages+0xc0/0xc0
[  130.175065]  ? on_each_cpu_cond_mask+0x48/0x90
[  130.176096]  __kmem_cache_shutdown.cold+0x34/0x141
[  130.177190]  kmem_cache_destroy+0x59/0x100
[  130.178223]  f2fs_destroy_page_array_cache+0x15/0x20 [f2fs]
[  130.179527]  f2fs_put_super+0x1bc/0x380 [f2fs]
[  130.180538]  generic_shutdown_super+0x72/0x110
[  130.181547]  kill_block_super+0x27/0x50
[  130.182438]  kill_f2fs_super+0x76/0xe0 [f2fs]
[  130.183448]  deactivate_locked_super+0x3b/0x80
[  130.184456]  deactivate_super+0x3e/0x50
[  130.185363]  cleanup_mnt+0x109/0x160
[  130.186179]  __cleanup_mnt+0x12/0x20
[  130.187003]  task_work_run+0x70/0xb0
[  130.187841]  exit_to_user_mode_prepare+0x18f/0x1b0
[  130.188917]  syscall_exit_to_user_mode+0x31/0x170
[  130.189989]  do_syscall_64+0x45/0x90
[  130.190828]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  130.191986] RIP: 0033:0x7faf868ea2eb
[  130.192815] Code: 7b 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 7b 0c 00 f7 d8 64 89 01
[  130.196872] RSP: 002b:00007fffb7edb478 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[  130.198494] RAX: 0000000000000000 RBX: 00007faf86a18204 RCX: 00007faf868ea2eb
[  130.201021] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055971df71c50
[  130.203415] RBP: 000055971df71a40 R08: 0000000000000000 R09: 00007fffb7eda1f0
[  130.205772] R10: 00007faf86a04339 R11: 0000000000000246 R12: 000055971df71c50
[  130.208150] R13: 0000000000000000 R14: 000055971df71b38 R15: 0000000000000000
[  130.210515] INFO: Object 0x00000000a980843a @offset=744
[  130.212476] INFO: Allocated in page_array_alloc+0x3d/0xe0 [f2fs] age=1572 cpu=0 pid=3297
[  130.215030] 	__slab_alloc+0x20/0x40
[  130.216566] 	kmem_cache_alloc+0x2a0/0x2e0
[  130.218217] 	page_array_alloc+0x3d/0xe0 [f2fs]
[  130.219940] 	f2fs_init_compress_ctx+0x1f/0x40 [f2fs]
[  130.221736] 	f2fs_write_cache_pages+0x3db/0x860 [f2fs]
[  130.223591] 	f2fs_write_data_pages+0x2c9/0x300 [f2fs]
[  130.225414] 	do_writepages+0x43/0xd0
[  130.226907] 	__filemap_fdatawrite_range+0xd5/0x110
[  130.228632] 	filemap_write_and_wait_range+0x48/0xb0
[  130.230336] 	__generic_file_write_iter+0x18a/0x1d0
[  130.232035] 	f2fs_file_write_iter+0x226/0x550 [f2fs]
[  130.233737] 	new_sync_write+0x113/0x1a0
[  130.235204] 	vfs_write+0x1a6/0x200
[  130.236579] 	ksys_write+0x67/0xe0
[  130.237898] 	__x64_sys_write+0x1a/0x20
[  130.239309] 	do_syscall_64+0x38/0x90

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/compress.c | 2 +-
 fs/f2fs/data.c     | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 10a9f39b9d6a2..f086ac43ca825 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -159,7 +159,7 @@ struct page *f2fs_compress_control_page(struct page *page)
 
 int f2fs_init_compress_ctx(struct compress_ctx *cc)
 {
-	if (cc->nr_rpages)
+	if (cc->rpages)
 		return 0;
 
 	cc->rpages = page_array_alloc(cc->inode);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index db020a74fd849..ee87407602fa7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3129,6 +3129,8 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
 			retry = 0;
 		}
 	}
+	if (f2fs_compressed_file(inode))
+		f2fs_destroy_compress_ctx(&cc);
 #endif
 	if (retry) {
 		index = 0;
-- 
2.28.0.681.g6f77f65b4e-goog

