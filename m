From: James Smart <james.smart@emulex.com>
Subject: PATCH 03/20] lpfc 8.3.31: Fix bug with driver not supporting the
 get controller attributes command
Date: Wed, 9 May 2012 21:16:24 -0400
Message-ID: <1336612596.1996.32.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27865 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754361Ab2EJBQs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:16:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with driver not supporting the get controller attributes command.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |    3 ++-
 lpfc_bsg.h |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2012-05-06 13:15:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2012-05-07 10:01:00.000000000 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2009-2011 Emulex.  All rights reserved.           *
+ * Copyright (C) 2009-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -3978,6 +3978,7 @@ lpfc_bsg_handle_sli_cfg_mbox(struct lpfc
 		} else if (subsys == SLI_CONFIG_SUBSYS_COMN) {
 			switch (opcode) {
 			case COMN_OPCODE_GET_CNTL_ADDL_ATTRIBUTES:
+			case COMN_OPCODE_GET_CNTL_ATTRIBUTES:
 				lpfc_printf_log(phba, KERN_INFO, LOG_LIBDFC,
 						"3106 Handled SLI_CONFIG "
 						"subsys_comn, opcode:x%x\n",
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	2012-05-06 13:15:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2012-05-07 10:01:00.000000000 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2010 Emulex.  All rights reserved.                *
+ * Copyright (C) 2010-2012 Emulex.  All rights reserved.                *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  *                                                                 *
@@ -249,6 +249,7 @@ struct lpfc_sli_config_emb1_subsys {
 #define COMN_OPCODE_READ_OBJECT_LIST	0xAD
 #define COMN_OPCODE_DELETE_OBJECT	0xAE
 #define COMN_OPCODE_GET_CNTL_ADDL_ATTRIBUTES	0x79
+#define COMN_OPCODE_GET_CNTL_ATTRIBUTES	0x20
 	uint32_t timeout;
 	uint32_t request_length;
 	uint32_t word9;



