From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/6] zfcp: Correctly query end flag in gpn_ft response
Date: Thu, 21 Aug 2008 13:43:33 +0200
Message-ID: <20080821114556.622855000@de.ibm.com>
References: <20080821114331.148204000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59941 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYHULrd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 07:47:33 -0400
Content-Disposition: inline; filename=702-zfcp-gpn_ft.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Petermann <martin@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When the last port entry in the gpn_ft response is already a known
port, the eval function would skip the end flag and try to attach
ports with wwpn 0. Fix this by checking the flag first.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2008-08-20 14:41:08.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2008-08-20 14:41:34.000000000 +0200
@@ -475,7 +475,7 @@ static int zfcp_scan_eval_gpn_ft(struct 
 	struct zfcp_adapter *adapter = ct->port->adapter;
 	struct zfcp_port *port, *tmp;
 	u32 d_id;
-	int ret = 0, x;
+	int ret = 0, x, last = 0;
 
 	if (ct->status)
 		return -EIO;
@@ -492,12 +492,13 @@ static int zfcp_scan_eval_gpn_ft(struct 
 	down(&zfcp_data.config_sema);
 
 	/* first entry is the header */
-	for (x = 1; x < ZFCP_GPN_FT_MAX_ENTRIES; x++) {
+	for (x = 1; x < ZFCP_GPN_FT_MAX_ENTRIES && !last; x++) {
 		if (x % (ZFCP_GPN_FT_ENTRIES + 1))
 			acc++;
 		else
 			acc = sg_virt(++sg);
 
+		last = acc->control & 0x80;
 		d_id = acc->port_id[0] << 16 | acc->port_id[1] << 8 |
 		       acc->port_id[2];
 
@@ -513,8 +514,6 @@ static int zfcp_scan_eval_gpn_ft(struct 
 			ret = PTR_ERR(port);
 		else
 			zfcp_erp_port_reopen(port, 0, 149, NULL);
-		if (acc->control & 0x80) /* last entry */
-			break;
 	}
 
 	zfcp_erp_wait(adapter);

-- 
