From: akpm@linux-foundation.org
Subject: [patch 10/15] scsi: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Wed, 04 Mar 2009 12:06:13 -0800
Message-ID: <200903042006.n24K6Djm029287@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbZCDUWp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 15:22:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, yjwei@cn.fujitsu.com

From: Wei Yongjun <yjwei@cn.fujitsu.com>

Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/scsi/scsi.c~scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset
+++ a/drivers/scsi/scsi.c
@@ -169,12 +169,10 @@ scsi_pool_alloc_command(struct scsi_host
 {
 	struct scsi_cmnd *cmd;
 
-	cmd = kmem_cache_alloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
+	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
 	if (!cmd)
 		return NULL;
 
-	memset(cmd, 0, sizeof(*cmd));
-
 	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
 					     gfp_mask | pool->gfp_mask);
 	if (!cmd->sense_buffer) {
_
