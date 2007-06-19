From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 19 Jun 2007 10:25:30 +0200
Message-ID: <200706191025.30986.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:48253 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXFSIV4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 04:21:56 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, christof.schmitt@de.ibm.com

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When reporting SCSI devices to the SCSI midlayer, use the FCP LUN as
LUN reported to the SCSI layer. With this approach, zfcp does not have
to create unique LUNS, and this code can be removed.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

---

 drivers/s390/scsi/zfcp_aux.c |   22 ++++------------------
 drivers/scsi/scsi_scan.c     |    3 ++-
 include/scsi/scsi_device.h   |    1 +
 3 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 821cde6..c631cf7 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -815,9 +815,7 @@ zfcp_get_adapter_by_busid(char *bus_id)
 struct zfcp_unit *
 zfcp_unit_enqueue(struct zfcp_port *port, fcp_lun_t fcp_lun)
 {
-	struct zfcp_unit *unit, *tmp_unit;
-	unsigned int scsi_lun;
-	int found;
+	struct zfcp_unit *unit;

 	/*
 	 * check that there is no unit with this FCP_LUN already in list
@@ -863,22 +861,10 @@ zfcp_unit_enqueue(struct zfcp_port *port, fcp_lun_t fcp_lun)
 	}

 	zfcp_unit_get(unit);
-
-	scsi_lun = 0;
-	found = 0;
+	unit->scsi_lun = scsilun_to_int((struct scsi_lun *)&unit->fcp_lun);
+	
 	write_lock_irq(&zfcp_data.config_lock);
-	list_for_each_entry(tmp_unit, &port->unit_list_head, list) {
-		if (tmp_unit->scsi_lun != scsi_lun) {
-			found = 1;
-			break;
-		}
-		scsi_lun++;
-	}
-	unit->scsi_lun = scsi_lun;
-	if (found)
-		list_add_tail(&unit->list, &tmp_unit->list);
-	else
-		list_add_tail(&unit->list, &port->unit_list_head);
+	list_add_tail(&unit->list, &port->unit_list_head);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
 	write_unlock_irq(&zfcp_data.config_lock);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 662577f..cf95ad9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1213,7 +1213,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
  *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
  *     the integer: 0x0b030a04
  **/
-static int scsilun_to_int(struct scsi_lun *scsilun)
+int scsilun_to_int(struct scsi_lun *scsilun)
 {
 	int i;
 	unsigned int lun;
@@ -1224,6 +1224,7 @@ static int scsilun_to_int(struct scsi_lun *scsilun)
 			      scsilun->scsi_lun[i + 1]) << (i * 8));
 	return lun;
 }
+EXPORT_SYMBOL(scsilun_to_int);

 /**
  * int_to_scsilun: reverts an int into a scsi_lun
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2f3c5b8..6fe1cf6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -287,6 +287,7 @@ extern void scsi_target_block(struct device *);
 extern void scsi_target_unblock(struct device *);
 extern void scsi_remove_target(struct device *);
 extern void int_to_scsilun(unsigned int, struct scsi_lun *);
+extern int scsilun_to_int(struct scsi_lun *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);



