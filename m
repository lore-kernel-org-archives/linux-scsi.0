From: Praveen Madhavan <praveenm@chelsio.com>
Subject: [PATCH 1/1] csiostor:Don't ignore the newly alloced lnode
Date: Fri,  4 Sep 2015 19:29:45 +0530
Message-ID: <1441375185-9630-1-git-send-email-praveenm@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:22058 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759243AbbIDN76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2015 09:59:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: praveenm@chelsio.com, varun@chelsio.com, anish@chelsio.com, hariprasad@chelsio.com

In case of  multiple FCFs, the newly allocated lnode by
csio_lnode_alloc() is completely ignored during link up event. Fix it.
This patch also fixes mbox memory reference after free.

Signed-off-by: Praveen Madhavan <praveenm@chelsio.com>
---
 drivers/scsi/csiostor/csio_hw.c    | 2 +-
 drivers/scsi/csiostor/csio_lnode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 622bdab..d920267 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -1769,7 +1769,6 @@ csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
 		goto bye;
 	}
 
-	mempool_free(mbp, hw->mb_mempool);
 	if (finicsum != cfcsum) {
 		csio_warn(hw,
 		      "Config File checksum mismatch: csum=%#x, computed=%#x\n",
@@ -1805,6 +1804,7 @@ csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
 	csio_info(hw, "Successfully configure using Firmware "
 		  "Configuration File %s, version %#x, computed checksum %#x\n",
 		  config_name, finiver, cfcsum);
+	mempool_free(mbp, hw->mb_mempool);
 	return 0;
 
 	/*
diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index c00b2ff..3b02188 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -873,7 +873,7 @@ csio_handle_link_up(struct csio_hw *hw, uint8_t portid, uint32_t fcfi,
 		if (ln->vnp_flowid != CSIO_INVALID_IDX) {
 			/* New VN-Port */
 			spin_unlock_irq(&hw->lock);
-			csio_lnode_alloc(hw);
+			ln = csio_lnode_alloc(hw);
 			spin_lock_irq(&hw->lock);
 			if (!ln) {
 				csio_err(hw,
-- 
2.0.2

