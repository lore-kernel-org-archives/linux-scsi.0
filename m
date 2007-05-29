From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 3/3] zfcp: Don't report device as LUN 0 to SCSI stack
Date: Tue, 29 May 2007 15:29:54 +0200
Message-ID: <200705291529.54785.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:41570 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762690AbXE2N0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 09:26:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schmichr@de.ibm.com

From: Christof Schmitt <schmichr@de.ibm.com>

zfcp reported units to the SCSI stack starting
with number 0. LUN 0 reported to the SCSI stack is usually 
not the FCP LUN 0. When scanning for devices, 
the SCSI stack tried to issue a REPORT LUN command to LUN 0. 
The current design for zfcp does not want the SCSI stack to scan
for devices, since they are configured explicitly via sysfs.
This patch changes the numbering to always start with LUN 1 and therefore
prevent the SCSI stack sending REPORT LUN command.

Signed-off-by: Christof Schmitt <schmichr@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

---

 drivers/s390/scsi/zfcp_aux.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux_jb_patched/drivers/s390/scsi/zfcp_aux.c
===================================================================
--- linux_jb_patched.orig/drivers/s390/scsi/zfcp_aux.c
+++ linux_jb_patched/drivers/s390/scsi/zfcp_aux.c
@@ -864,7 +864,8 @@ zfcp_unit_enqueue(struct zfcp_port *port
 
 	zfcp_unit_get(unit);
 
-	scsi_lun = 0;
+	/* Don't report LUN 0 to prevent the REPORT LUNS command from SCSI. */
+	scsi_lun = 1;
 	found = 0;
 	write_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry(tmp_unit, &port->unit_list_head, list) {
