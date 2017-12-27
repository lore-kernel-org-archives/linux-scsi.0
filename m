From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 29/30] scsi: aacraid: Remove AAC_HIDE_DISK check in queue command
Date: Tue, 26 Dec 2017 20:34:50 -0800
Message-ID: <20171227043451.27813-30-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0077.outbound.protection.outlook.com ([104.47.37.77]:27328
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751822AbdL0Ef3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:29 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Earlier driver would scan throgh all supported buses and targets and add
devices that responded. It would add devices that were _hidden_ by the fw.
Driver would invalidate commands sent to _hidden_ devices via the
AAC_HIDE_DISK check.

Since the driver now adds only the devices that are supposed to be
exposed, this code can be removed.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aachba.c  | 10 ----------
 drivers/scsi/aacraid/aacraid.h |  3 ---
 2 files changed, 13 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index f498bed..a2bdd79 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1994,8 +1994,6 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev)
 		if (bus >= AAC_MAX_BUSES || target >= AAC_MAX_TARGETS)
 			continue;
 
-		dev->hba_map[bus][target].expose = expose_flag;
-
 		if (expose_flag != 0) {
 			devtype = AAC_DEVTYPE_RAID_MEMBER;
 			goto update_devtype;
@@ -2913,14 +2911,6 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			}
 		} else {  /* check for physical non-dasd devices */
 			bus = aac_logical_to_phys(scmd_channel(scsicmd));
-			if (bus < AAC_MAX_BUSES && cid < AAC_MAX_TARGETS &&
-				(dev->hba_map[bus][cid].expose
-						== AAC_HIDE_DISK)){
-				if (scsicmd->cmnd[0] == INQUIRY) {
-					scsicmd->result = DID_NO_CONNECT << 16;
-					goto scsi_done_ret;
-				}
-			}
 
 			if (bus < AAC_MAX_BUSES && cid < AAC_MAX_TARGETS &&
 				dev->hba_map[bus][cid].devtype
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3e8a44c..4d3536d 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1339,8 +1339,6 @@ struct fib {
 #define AAC_DEVTYPE_RAID_MEMBER	1
 #define AAC_DEVTYPE_ARC_RAW		2
 #define AAC_DEVTYPE_NATIVE_RAW		3
-#define AAC_EXPOSE_DISK		0
-#define AAC_HIDE_DISK			3
 
 #define AAC_SAFW_RESCAN_DELAY  10
 
@@ -1350,7 +1348,6 @@ struct aac_hba_map_info {
 	u8		reset_state;	/* 0 - no reset, 1..x - */
 					/* after xth TM LUN reset */
 	u16		qd_limit;
-	u8		expose;		/*checks if to expose or not*/
 	u32		scan_counter;
 	struct aac_ciss_identify_pd  *safw_identify_resp;
 };
-- 
2.9.4
