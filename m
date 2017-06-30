From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/7] aacraid: split off functions to generate reset FIB
Date: Fri, 30 Jun 2017 19:18:06 +0200
Message-ID: <1498843092-76285-2-git-send-email-hare@suse.de>
References: <1498843092-76285-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59905 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751710AbdF3RTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:19:38 -0400
In-Reply-To: <1498843092-76285-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Split off reset FIB generation into separate functions.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 83 ++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0f277df..9a8a27f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -814,6 +814,52 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 	return ret;
 }
 
+static u8 aac_eh_tmf_lun_reset_fib(struct aac_dev *aac, struct fib *fib,
+				   int bus, int cid, u64 tmf_lun)
+{
+	struct aac_hba_tm_req *tmf;
+	u64 address;
+
+	/* start a HBA_TMF_LUN_RESET TMF request */
+	tmf = (struct aac_hba_tm_req *)fib->hw_fib_va;
+	memset(tmf, 0, sizeof(*tmf));
+	tmf->tmf = HBA_TMF_LUN_RESET;
+	tmf->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
+	int_to_scsilun(tmf_lun, (struct scsi_lun *)tmf->lun);
+
+	address = (u64)fib->hw_error_pa;
+	tmf->error_ptr_hi = cpu_to_le32
+		((u32)(address >> 32));
+	tmf->error_ptr_lo = cpu_to_le32
+		((u32)(address & 0xffffffff));
+	tmf->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
+	fib->hbacmd_size = sizeof(*tmf);
+
+	return HBA_IU_TYPE_SCSI_TM_REQ;
+}
+
+static u8 aac_eh_tmf_hard_reset_fib(struct aac_dev *aac, struct fib *fib,
+				    int bus, int cid)
+{
+	struct aac_hba_reset_req *rst;
+	u64 address;
+
+	/* already tried, start a hard reset now */
+	rst = (struct aac_hba_reset_req *)fib->hw_fib_va;
+	memset(rst, 0, sizeof(*rst));
+	/* reset_type is already zero... */
+	rst->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
+
+	address = (u64)fib->hw_error_pa;
+	rst->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
+	rst->error_ptr_lo = cpu_to_le32
+		((u32)(address & 0xffffffff));
+	rst->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
+	fib->hbacmd_size = sizeof(*rst);
+
+       return HBA_IU_TYPE_SATA_REQ;
+}
+
 /*
  *	aac_eh_reset	- Reset command handling
  *	@scsi_cmd:	SCSI command block causing the reset
@@ -840,7 +886,6 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 		aac->hba_map[bus][cid].devtype == AAC_DEVTYPE_NATIVE_RAW) {
 		struct fib *fib;
 		int status;
-		u64 address;
 		u8 command;
 
 		pr_err("%s: Host adapter reset request. SCSI hang ?\n",
@@ -852,42 +897,14 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 
 
 		if (aac->hba_map[bus][cid].reset_state == 0) {
-			struct aac_hba_tm_req *tmf;
-
 			/* start a HBA_TMF_LUN_RESET TMF request */
-			tmf = (struct aac_hba_tm_req *)fib->hw_fib_va;
-			memset(tmf, 0, sizeof(*tmf));
-			tmf->tmf = HBA_TMF_LUN_RESET;
-			tmf->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
-			tmf->lun[1] = cmd->device->lun;
-
-			address = (u64)fib->hw_error_pa;
-			tmf->error_ptr_hi = cpu_to_le32
-					((u32)(address >> 32));
-			tmf->error_ptr_lo = cpu_to_le32
-					((u32)(address & 0xffffffff));
-			tmf->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
-			fib->hbacmd_size = sizeof(*tmf);
-
-			command = HBA_IU_TYPE_SCSI_TM_REQ;
+			command = aac_eh_tmf_lun_reset_fib(aac, fib,
+							   bus, cid,
+							   cmd->device->lun);
 			aac->hba_map[bus][cid].reset_state++;
 		} else if (aac->hba_map[bus][cid].reset_state >= 1) {
-			struct aac_hba_reset_req *rst;
-
 			/* already tried, start a hard reset now */
-			rst = (struct aac_hba_reset_req *)fib->hw_fib_va;
-			memset(rst, 0, sizeof(*rst));
-			/* reset_type is already zero... */
-			rst->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
-
-			address = (u64)fib->hw_error_pa;
-			rst->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
-			rst->error_ptr_lo = cpu_to_le32
-				((u32)(address & 0xffffffff));
-			rst->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
-			fib->hbacmd_size = sizeof(*rst);
-
-			command = HBA_IU_TYPE_SATA_REQ;
+			command = aac_eh_tmf_hard_reset_fib(aac, fib, bus, cid);
 			aac->hba_map[bus][cid].reset_state = 0;
 		}
 		cmd->SCp.sent_command = 0;
-- 
1.8.5.6
