From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: csiostor: fix use after free in csio_hw_use_fwconfig()
Date: Wed, 17 May 2017 20:30:43 +0530
Message-ID: <1495033243-20262-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:33679 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754508AbdEQPBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 11:01:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com, rajesh.kumar@chelsio.com

mbp pointer is passed to csio_hw_validate_caps() so call
mempool_free() after calling csio_hw_validate_caps().

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/csiostor/csio_hw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 5ca4099..c6e1814 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -1780,7 +1780,6 @@ csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
 		goto bye;
 	}
 
-	mempool_free(mbp, hw->mb_mempool);
 	if (finicsum != cfcsum) {
 		csio_warn(hw,
 		      "Config File checksum mismatch: csum=%#x, computed=%#x\n",
@@ -1791,6 +1790,10 @@ csio_hw_use_fwconfig(struct csio_hw *hw, int reset, u32 *fw_cfg_param)
 	rv = csio_hw_validate_caps(hw, mbp);
 	if (rv != 0)
 		goto bye;
+
+	mempool_free(mbp, hw->mb_mempool);
+	mbp = NULL;
+
 	/*
 	 * Note that we're operating with parameters
 	 * not supplied by the driver, rather than from hard-wired
-- 
2.0.2
