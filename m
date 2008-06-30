From: christof.schmitt@de.ibm.com
Subject: [patch 02/11] zfcp: Fix error checking for ELS ADISC requests
Date: Mon, 30 Jun 2008 12:52:38 +0200
Message-ID: <20080630110055.677053000@de.ibm.com>
References: <20080630105236.960064000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:48225 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbYF3LA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 07:00:58 -0400
Content-Disposition: inline; filename=fix-els-adisc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Correctly check the status for ELS ADISC requests. 0 means success.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2008-06-27 18:07:26.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-06-27 18:07:43.000000000 +0200
@@ -263,7 +263,7 @@ static void zfcp_fc_adisc_handler(unsign
 	struct zfcp_port *port = adisc->els.port;
 	struct zfcp_ls_adisc_acc *ls_adisc = &adisc->ls_adisc_acc;
 
-	if (!adisc->els.status) {
+	if (adisc->els.status) {
 		/* request rejected or timed out */
 		zfcp_erp_port_forced_reopen(port, 0, 63, NULL);
 		goto out;

-- 
