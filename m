From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm_loop: Enable 32-byte CDB support in virtual SCSI LLD
Date: Thu, 16 Sep 2010 22:35:03 -0700
Message-ID: <1284701703-18389-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Mi
Cc: Hannes Reinecke <hare@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Douglas Gilbert <dgilbert@interlog.com>, Joe Eykholt <jeykholt@cisco.com>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes tcm_loop_core.h:TL_SCSI_MAX_CMD_LEN=32 to enable the support of
> 16 byte CDB within the TCM_Loop virtual SCSI fabric module.  This value is used in
tcm_loop_fabric_scsi.c:tcm_loop_driver_probe() for struct Scsi_Host->max_cmd_len to
signal Linux/SCSI of the maximum sized CDBs the LLD is capable of handling.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_loop/tcm_loop_core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_loop/tcm_loop_core.h b/drivers/target/tcm_loop/tcm_loop_core.h
index 36859bd..5e218a7 100644
--- a/drivers/target/tcm_loop/tcm_loop_core.h
+++ b/drivers/target/tcm_loop/tcm_loop_core.h
@@ -14,7 +14,7 @@
 /*
  * Used in tcm_loop_driver_probe() for struct Scsi_Host->max_cmd_len
  */
-#define TL_SCSI_MAX_CMD_LEN		16
+#define TL_SCSI_MAX_CMD_LEN		32
 
 #ifdef TCM_LOOP_CDB_DEBUG
 # define TL_CDB_DEBUG(x...)		printk(KERN_INFO x)
-- 
1.5.6.5
