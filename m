From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 051/103] target: Don't pass dma_size to generic_get_mem
Date: Thu, 21 Jul 2011 00:08:03 -0700
Message-ID: <1311232135-6653-52-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm13.access.bullet.mail.sp2.yahoo.com ([98.139.44.140]:26388
	"HELO nm13.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750973Ab1GUHEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:40 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Since the caller is just passing PAGE_SIZE for dma_size, we can just use
PAGE_SIZE in the function (since we're allocating pages) and omit the
parameter.

(hch: Add __GFP_ZERO usage to zero page)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index da6bd74..9bbc626 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -210,8 +210,7 @@ static u32 transport_generic_get_cdb_count(struct se_cmd *cmd,
 		unsigned long long starting_lba, u32 sectors,
 		enum dma_data_direction data_direction,
 		struct list_head *mem_list, int set_counts);
-static int transport_generic_get_mem(struct se_cmd *cmd, u32 length,
-		u32 dma_size);
+static int transport_generic_get_mem(struct se_cmd *cmd, u32 length);
 static int transport_generic_remove(struct se_cmd *cmd,
 		int release_to_pool, int session_reinstatement);
 static int transport_get_sectors(struct se_cmd *cmd);
@@ -2896,7 +2895,7 @@ static int transport_allocate_resources(struct se_cmd *cmd)
 
 	if ((cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
 	    (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB))
-		return transport_generic_get_mem(cmd, length, PAGE_SIZE);
+		return transport_generic_get_mem(cmd, length);
 	else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB)
 		return transport_generic_allocate_buf(cmd, length);
 	else
@@ -4070,9 +4069,8 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 }
 
 static int
-transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
+transport_generic_get_mem(struct se_cmd *cmd, u32 length)
 {
-	unsigned char *buf;
 	struct se_mem *se_mem;
 
 	/*
@@ -4089,22 +4087,14 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 		}
 
 /* #warning FIXME Allocate contigous pages for struct se_mem elements */
-		se_mem->se_page = alloc_pages(GFP_KERNEL, 0);
+		se_mem->se_page = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
 		if (!(se_mem->se_page)) {
 			printk(KERN_ERR "alloc_pages() failed\n");
 			goto out;
 		}
 
-		buf = kmap_atomic(se_mem->se_page, KM_IRQ0);
-		if (!(buf)) {
-			printk(KERN_ERR "kmap_atomic() failed\n");
-			goto out;
-		}
 		INIT_LIST_HEAD(&se_mem->se_list);
-		se_mem->se_len = (length > dma_size) ? dma_size : length;
-		memset(buf, 0, se_mem->se_len);
-		kunmap_atomic(buf, KM_IRQ0);
-
+		se_mem->se_len = min_t(u32, length, PAGE_SIZE);
 		list_add_tail(&se_mem->se_list, &cmd->t_task.t_mem_list);
 		cmd->t_task.t_tasks_se_num++;
 
-- 
1.7.6

