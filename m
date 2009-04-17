From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/15] zfcp: remove unit will fail if add unit is not finished
Date: Fri, 17 Apr 2009 15:08:08 +0200
Message-ID: <20090417131122.870131000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46743 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZDQNL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:26 -0400
Content-Disposition: inline; filename=708-zfcp-remove-unit.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin@linux.vnet.ibm.com>

On some hardware it can take some time to add a unit. If
some remove this unit during this process the remove will
fail.

Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_sysfs.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-04-17 15:03:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-04-17 15:03:42.000000000 +0200
@@ -254,12 +254,21 @@ static ssize_t zfcp_sysfs_unit_remove_st
 
 	write_lock_irq(&zfcp_data.config_lock);
 	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	if (unit && (atomic_read(&unit->refcount) == 0)) {
-		zfcp_unit_get(unit);
-		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
-		list_move(&unit->list, &unit_remove_lh);
-	} else
-		unit = NULL;
+	if (unit) {
+		write_unlock_irq(&zfcp_data.config_lock);
+		/* wait for possible timeout during SCSI probe */
+		flush_work(&unit->scsi_work);
+		write_lock_irq(&zfcp_data.config_lock);
+
+		if (atomic_read(&unit->refcount) == 0) {
+			zfcp_unit_get(unit);
+			atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE,
+					&unit->status);
+			list_move(&unit->list, &unit_remove_lh);
+		} else {
+			unit = NULL;
+		}
+	}
 
 	write_unlock_irq(&zfcp_data.config_lock);
 

