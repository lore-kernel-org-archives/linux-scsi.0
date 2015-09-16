From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Fix target_sense_desc_format NULL pointer dereference
Date: Wed, 16 Sep 2015 06:31:19 +0000
Message-ID: <1442385079-749-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch allows target_sense_desc_format() to be called without a
valid se_device pointer, which can occur during an early exception
ahead of transport_lookup_cmd_lun() setting up se_cmd->se_device.

This addresses a v4.3-rc1 specific NULL pointer dereference
regression introduced by commit 4e4937e8.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_hba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 9522960..22390e0 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -187,5 +187,5 @@ core_delete_hba(struct se_hba *hba)
 
 bool target_sense_desc_format(struct se_device *dev)
 {
-	return dev->transport->get_blocks(dev) > U32_MAX;
+	return (dev) ? dev->transport->get_blocks(dev) > U32_MAX : false;
 }
-- 
1.9.1
