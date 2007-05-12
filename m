From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/19] ibmvscsi: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:42 +0900 (JST)
Message-ID: <20070512183138K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:44879 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbXELKFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcj@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   36 +-----------------------------------
 1 files changed, 1 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index b10eefe..57acf86 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -452,38 +452,6 @@ static int map_sg_data(struct scsi_cmnd
 }
 
 /**
- * map_single_data: - Maps memory and initializes memory decriptor fields
- * @cmd:	struct scsi_cmnd with the memory to be mapped
- * @srp_cmd:	srp_cmd that contains the memory descriptor
- * @dev:	device for which to map dma memory
- *
- * Called by map_data_for_srp_cmd() when building srp cmd from scsi cmd.
- * Returns 1 on success.
-*/
-static int map_single_data(struct scsi_cmnd *cmd,
-			   struct srp_cmd *srp_cmd, struct device *dev)
-{
-	struct srp_direct_buf *data =
-		(struct srp_direct_buf *) srp_cmd->add_data;
-
-	data->va =
-		dma_map_single(dev, cmd->request_buffer,
-			       cmd->request_bufflen,
-			       DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(data->va)) {
-		printk(KERN_ERR
-		       "ibmvscsi: Unable to map request_buffer for command!\n");
-		return 0;
-	}
-	data->len = cmd->request_bufflen;
-	data->key = 0;
-
-	set_srp_direction(cmd, srp_cmd, 1);
-
-	return 1;
-}
-
-/**
  * map_data_for_srp_cmd: - Calls functions to map data for srp cmds
  * @cmd:	struct scsi_cmnd with the memory to be mapped
  * @srp_cmd:	srp_cmd that contains the memory descriptor
@@ -515,9 +483,7 @@ static int map_data_for_srp_cmd(struct s
 
 	if (!cmd->request_buffer)
 		return 1;
-	if (cmd->use_sg)
-		return map_sg_data(cmd, evt_struct, srp_cmd, dev);
-	return map_single_data(cmd, srp_cmd, dev);
+	return map_sg_data(cmd, evt_struct, srp_cmd, dev);
 }
 
 /* ------------------------------------------------------------
-- 
1.4.3.2

