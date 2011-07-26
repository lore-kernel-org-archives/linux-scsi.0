From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 2/2] target: Convert to DIV_ROUND_UP_SECTOR_T usage for sectors / dev_max_sectors
Date: Tue, 26 Jul 2011 07:35:43 +0000
Message-ID: <1311665743-20639-2-git-send-email-nab@linux-iscsi.org>
References: <1311665743-20639-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35707 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab1GZH7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 03:59:14 -0400
In-Reply-To: <1311665743-20639-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the new macro usage of include/linux/kernel.h:DIV_ROUND_UP_SECTOR_T
usage to use the new DIV_ROUND_UP_ULL() usage for 32-bit architectures with
the unsigned long long sector_t division in transport_allocate_data_tasks() usage
for target_core_mod v4.1

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a244c90..301d5a0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4054,17 +4054,16 @@ static int transport_allocate_data_tasks(
 	struct se_task *task;
 	struct se_device *dev = cmd->se_dev;
 	unsigned long flags;
-	sector_t sectors;
 	int task_count, i, ret;
-	sector_t dev_max_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
+	sector_t sectors, dev_max_sectors = dev->se_sub_dev->se_dev_attrib.max_sectors;
 	u32 sector_size = dev->se_sub_dev->se_dev_attrib.block_size;
 	struct scatterlist *sg;
 	struct scatterlist *cmd_sg;
 
 	WARN_ON(cmd->data_length % sector_size);
 	sectors = DIV_ROUND_UP(cmd->data_length, sector_size);
-	task_count = DIV_ROUND_UP(sectors, dev_max_sectors);
-
+	task_count = DIV_ROUND_UP_SECTOR_T(sectors, dev_max_sectors);
+	
 	cmd_sg = sgl;
 	for (i = 0; i < task_count; i++) {
 		unsigned int task_size;
-- 
1.7.2.5

