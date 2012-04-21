From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 3/3] [SCSI] ufs: Process SCSI command for UFS device
Date: Sat, 21 Apr 2012 14:39:19 +0530
Message-ID: <1334999359-3181-3-git-send-email-santoshsy@gmail.com>
References: <1334999359-3181-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64136 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2DUJJj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Apr 2012 05:09:39 -0400
Received: by dake40 with SMTP id e40so13972226dak.11
        for <linux-scsi@vger.kernel.org>; Sat, 21 Apr 2012 02:09:39 -0700 (PDT)
In-Reply-To: <1334999359-3181-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

UFS Spec specifies that the SCSI CDB fields, that are not
supported by UFS should be set to zero. It also mentions
that some of the CDB fields should be set to default
values before issuing the command to a UFS device.
Ex: Mode Select - Page Format bit should be set to 1.

If the fields are not set to values mentioned in UFS spec,
strict CDB checking UFS device may complete the commands
with a check condition.

Signed-off-by: Santosh Y <santoshsy@gmail.com>
Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |  100 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 662d00f..ef416b1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -583,6 +583,104 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
 }
 
 /**
+ * ufshcd_process_scsi_cdb - Process SCSI command for UFS device
+ * @cdb: Pointer to SCSI cdb
+ * @cdb_len: SCSI cdb length
+ */
+static inline void
+ufshcd_process_scsi_cdb(unsigned char *cdb, unsigned short cdb_len)
+{
+	switch (cdb[0]) {
+	case READ_10:
+	case READ_16:
+	case WRITE_10:
+	case WRITE_16:
+
+		/* set RDPROTECT/WRPROTECT bits to 0 */
+		cdb[1] &= 0x1F;
+		break;
+	case START_STOP:
+
+		/* set Power Condition Modifier to 0 */
+		cdb[3] &= 0xF0;
+		break;
+	case MODE_SELECT_10:
+
+		/* set Page Format(PF) bit to 1 */
+		cdb[1] |= 0x10;
+		break;
+	case MODE_SENSE_10:
+
+		/*
+		 * set Long LBA Accepted(LLBAA) bit to 0 and
+		 * Disable Block Descriptors(DBD) bit to 1
+		 */
+		cdb[1] = 0x08;
+		break;
+
+	case READ_CAPACITY:
+
+		/* set Partial Medium Indicator(PMI) bit to 0 */
+		cdb[8] &= ~1;
+
+		/* set Logical Block Address(LBA) to 0 */
+		cdb[2] = 0;
+		cdb[3] = 0;
+		break;
+
+	case SERVICE_ACTION_IN:
+		if ((cdb[1] & 0x1F) == SAI_READ_CAPACITY_16) {
+
+			/* set PMI bit to 0 */
+			cdb[14] &= ~1;
+
+			/* set Logical Block Address(LBA) to 0 */
+			cdb[2] = 0;
+			cdb[3] = 0;
+			cdb[4] = 0;
+			cdb[5] = 0;
+			cdb[6] = 0;
+			cdb[7] = 0;
+			cdb[8] = 0;
+			cdb[9] = 0;
+		}
+		break;
+	case VERIFY:
+
+		/* set VRPROTECT, Disable Page Out(DPO), BYTCHK bits to 0 */
+		cdb[1] &= 0x0C;
+
+		/* set Group Number to 0 */
+		cdb[6] &= 0xF0;
+		break;
+
+	case REQUEST_SENSE:
+
+		/* set Descriptor Format(DESC) bit to 0 */
+		cdb[1] = 0;
+
+		/* device server will transfer upto 18 bytes of data */
+		if (cdb[4] > MAX_SENSE_SIZE)
+			cdb[4] = MAX_SENSE_SIZE;
+		break;
+
+	case SECURITY_PROTOCOL_IN:
+	case SECURITY_PROTOCOL_OUT:
+
+		/*
+		 * set INC_512 to 0, to specify Allocation/Transfer Length
+		 * represent the number of bytes to be transferred
+		 */
+		cdb[4] &= 0x7F;
+		break;
+	}
+
+	/* set control field to 0 */
+	if (cdb_len <= MAX_CDB_SIZE)
+		cdb[cdb_len - 1] = 0;
+}
+
+/**
  * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
  * @lrb - pointer to local reference block
  */
@@ -645,6 +743,8 @@ static void ufshcd_compose_upiu(struct ufshcd_lrb *lrbp)
 		       (min_t(unsigned short,
 			      lrbp->cmd->cmd_len,
 			      MAX_CDB_SIZE)));
+
+		ufshcd_process_scsi_cdb(ucd_cmd_ptr->cdb, lrbp->cmd->cmd_len);
 		break;
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		/* For query function implementation */
-- 
1.7.5.4

