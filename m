From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/5] zfcp: No ERP escalation on gpn_ft eval
Date: Wed, 17 Nov 2010 14:23:42 +0100
Message-ID: <20101117132656.065641657@de.ibm.com>
References: <20101117132339.429099463@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:53233 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab0KQN06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 08:26:58 -0500
Content-Disposition: inline; filename=708-zfcp-no-escalation.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

If the evaluation of GPN_FT requests wants to remove an invalid port
from the system the zfcp_erp_port_shutdown function is triggered.
Depending on the system status a superior action (e.g. adapter reopen)
is required. This can lead to an invalid mem access of the port struct
which might be freed at the time since the superior action is not
holding a reference of the port which triggered this ERP action.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-11-17 10:04:26.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-11-17 10:04:26.000000000 +0100
@@ -156,6 +156,8 @@ static int zfcp_erp_required_act(int wan
 		if (!(a_status & ZFCP_STATUS_COMMON_RUNNING) ||
 		      a_status & ZFCP_STATUS_COMMON_ERP_FAILED)
 			return 0;
+		if (p_status & ZFCP_STATUS_COMMON_NOESC)
+			return need;
 		if (!(a_status & ZFCP_STATUS_COMMON_UNBLOCKED))
 			need = ZFCP_ERP_ACTION_REOPEN_ADAPTER;
 		/* fall through */

