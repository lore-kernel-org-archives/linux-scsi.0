From: Martin Peschke <mp3@de.ibm.com>
Subject: [Patch 1/2] zfcp: fix dismissal of error recovery actions
Date: Thu, 15 Nov 2007 13:57:08 +0100
Message-ID: <1195131428.16786.32.camel@dix>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:2943 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbXKOM5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 07:57:13 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.8/8.13.8) with ESMTP id lAFCv9qq170426
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 12:57:09 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAFCv9KM2318546
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 13:57:09 +0100
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAFCv9dX026928
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 13:57:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

zfcp_erp_action_dismiss() used to ignore any actions in the ready list. This
is a bug. Any action superseded by a stronger action needs to be dismissed.
This patch changes zfcp_erp_action_dismiss() so that it dismisses actions
regardless of their list affiliation. The ERP thread is able to handle this. 
It is important to kick the erp thread only for actions in the running list,
though, as an imbalance of wakeup signals would confuse the erp thread
otherwise.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Acked-by: Swen Schillig <swen@vnet.ibm.com>

---
 drivers/s390/scsi/zfcp_erp.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc2-git5.orig/drivers/s390/scsi/zfcp_erp.c
+++ linux-2.6.24-rc2-git5/drivers/s390/scsi/zfcp_erp.c
@@ -977,7 +977,9 @@ static void zfcp_erp_action_dismiss(stru
 	debug_text_event(adapter->erp_dbf, 2, "a_adis");
 	debug_event(adapter->erp_dbf, 2, &erp_action->action, sizeof (int));
 
-	zfcp_erp_async_handler_nolock(erp_action, ZFCP_STATUS_ERP_DISMISSED);
+	erp_action->status |= ZFCP_STATUS_ERP_DISMISSED;
+	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING)
+		zfcp_erp_action_ready(erp_action);
 }
 
 int


