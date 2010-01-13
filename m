From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/3] zfcp: Fix linebreak in hba trace
Date: Wed, 13 Jan 2010 17:52:37 +0100
Message-ID: <20100113165513.498004000@de.ibm.com>
References: <20100113165235.299592000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:39425 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0AMQzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2010 11:55:15 -0500
Content-Disposition: inline; filename=703-zfcp-trace-linebreak.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Advance the correct pointer when inserting the linebreak for the HBA
trace. It was missing in the output since the pointer to the output
buffer was never advanced, and the linebreak character was overwritten
later.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2010-01-12 11:18:59.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2010-01-12 11:19:00.000000000 +0100
@@ -327,7 +327,7 @@ static void zfcp_dbf_hba_view_response(c
 			break;
 		zfcp_dbf_out(p, "scsi_cmnd", "0x%0Lx", r->u.fcp.cmnd);
 		zfcp_dbf_out(p, "scsi_serial", "0x%016Lx", r->u.fcp.serial);
-		p += sprintf(*p, "\n");
+		*p += sprintf(*p, "\n");
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:

