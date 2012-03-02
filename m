From: James Smart <james.smart@emulex.com>
Subject: [PATCH 02/21] lpfc 8.3.30: Fix lack of LOGO with vport delete.
Date: Thu, 1 Mar 2012 22:33:52 -0500
Message-ID: <1330659235.18500.29.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38846 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752690Ab2CBDeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:34:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with driver not sending a LOGO with vport delete.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:30.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:35.000000000 -0500
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2012 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -7743,6 +7743,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 			if (pcmd && (*pcmd == ELS_CMD_FLOGI ||
 				*pcmd == ELS_CMD_SCR ||
 				*pcmd == ELS_CMD_FDISC ||
+				*pcmd == ELS_CMD_LOGO ||
 				*pcmd == ELS_CMD_PLOGI)) {
 				bf_set(els_req64_sp, &wqe->els_req, 1);
 				bf_set(els_req64_sid, &wqe->els_req,



