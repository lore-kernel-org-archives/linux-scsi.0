From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] pcmraid: fix endianness problems
Date: Tue, 03 Nov 2009 11:15:14 -0600
Message-ID: <1257268514.9427.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58381 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbZKCRPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 12:15:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org

There's a compile problem with pcmraid on BE platforms because the flags
machine mailbox register is only 8 bits wide:

drivers/scsi/pmcraid.c: In function 'pmcraid_request_sense':
drivers/scsi/pmcraid.c:2259: warning: large integer implicitly truncated to unsigned type
drivers/scsi/pmcraid.c: In function 'pmcraid_build_ioadl':
drivers/scsi/pmcraid.c:3025: warning: large integer implicitly truncated to unsigned type
drivers/scsi/pmcraid.c: In function 'pmcraid_build_passthrough_ioadls':
drivers/scsi/pmcraid.c:3395: warning: large integer implicitly truncated to unsigned type
drivers/scsi/pmcraid.c: In function 'pmcraid_querycfg':
drivers/scsi/pmcraid.c:5322: warning: large integer implicitly truncated to unsigned type

The fix, I think, is just to remove the spurious cpu_to_le32 wrappers

James

---

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 86d158e..ef4102e 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2256,7 +2256,7 @@ static void pmcraid_request_sense(struct pmcraid_cmd *cmd)
 
 	ioadl->address = cpu_to_le64(cmd->sense_buffer_dma);
 	ioadl->data_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
-	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl->flags = IOADL_FLAGS_LAST_DESC;
 
 	/* request sense might be called as part of error response processing
 	 * which runs in tasklets context. It is possible that mid-layer might
@@ -3022,7 +3022,7 @@ static int pmcraid_build_ioadl(
 		ioadl[i].flags = 0;
 	}
 	/* setup last descriptor */
-	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
 
 	return 0;
 }
@@ -3392,7 +3392,7 @@ static int pmcraid_build_passthrough_ioadls(
 	}
 
 	/* setup the last descriptor */
-	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
 
 	return 0;
 }
@@ -5319,7 +5319,7 @@ static void pmcraid_querycfg(struct pmcraid_cmd *cmd)
 		cpu_to_le32(sizeof(struct pmcraid_config_table));
 
 	ioadl = &(ioarcb->add_data.u.ioadl[0]);
-	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl->flags = IOADL_FLAGS_LAST_DESC;
 	ioadl->address = cpu_to_le64(pinstance->cfg_table_bus_addr);
 	ioadl->data_len = cpu_to_le32(sizeof(struct pmcraid_config_table));
 


