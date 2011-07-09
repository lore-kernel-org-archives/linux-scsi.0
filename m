From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 13/20] target: Remove transport do_se_mem_map callback
Date: Fri,  8 Jul 2011 18:18:42 -0700
Message-ID: <1310174329-22228-14-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab1GIBTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 21:19:02 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

This callback was only used by the direct ramdisk driver, which is no
longer present.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_transport.c |    8 --------
 include/target/target_core_transport.h |    5 -----
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 29c35ec..9e23dd7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3737,8 +3737,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 
 	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)
 		free_page = 0;
-	if (cmd->se_dev->transport->do_se_mem_map)
-		free_page = 0;
 
 	for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, count) {
 		/*
@@ -3973,12 +3971,6 @@ transport_generic_get_mem(struct se_cmd *cmd)
 	struct page *page;
 	int i = 0;
 
-	/*
-	 * If the device uses memory mapping this is enough.
-	 */
-	if (cmd->se_dev->transport->do_se_mem_map)
-		return 0;
-
 	nents = DIV_ROUND_UP(length, PAGE_SIZE);
 	cmd->t_data_sg = kmalloc(sizeof(struct scatterlist) * nents, GFP_KERNEL);
 	if (!cmd->t_data_sg)
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 7d10fb5..b9f7766 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -340,11 +340,6 @@ struct se_subsystem_api {
 	 */
 	sector_t (*get_blocks)(struct se_device *);
 	/*
-	 * do_se_mem_map():
-	 */
-	int (*do_se_mem_map)(struct se_task *, struct list_head *, void *,
-				struct se_mem *, struct se_mem **, u32 *, u32 *);
-	/*
 	 * get_sense_buffer():
 	 */
 	unsigned char *(*get_sense_buffer)(struct se_task *);
-- 
1.7.1

