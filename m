From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 095/103] target: Remove transport do_se_mem_map callback
Date: Thu, 21 Jul 2011 07:05:27 +0000
Message-ID: <1311231935-24635-96-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51679 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1GUH33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:29 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

This callback was only used by the direct ramdisk driver, which is no
longer present.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    8 --------
 include/target/target_core_transport.h |    5 -----
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ef64052..ceb7ee7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3731,8 +3731,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 
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
index 123df92..169b51e 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -342,11 +342,6 @@ struct se_subsystem_api {
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
1.7.6

