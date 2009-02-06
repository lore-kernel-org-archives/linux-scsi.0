From: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: scsi: used kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Fri, 06 Feb 2009 11:04:53 +0800
Message-ID: <498BA8D5.2000606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZBFDE7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2009 22:04:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>

Used kmem_cache_zalloc instead of kmem_cache_alloc/memset.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 drivers/scsi/scsi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index cbcd3f6..fbe6672 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -169,12 +169,10 @@ scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
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
-- 
1.5.3.8



