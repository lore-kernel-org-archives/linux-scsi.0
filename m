From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 33/36] smartpqi: cleanup list initialization
Date: Wed, 3 May 2017 18:55:37 -0500
Message-ID: <149385573748.11043.5408215889622165060.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:13693
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752310AbdECXzw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:55:52 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Better initialization of linked list heads.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 56c416f..21fbcf3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1591,11 +1591,8 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device;
 	struct pqi_scsi_dev *next;
 	struct pqi_scsi_dev *matching_device;
-	struct list_head add_list;
-	struct list_head delete_list;
-
-	INIT_LIST_HEAD(&add_list);
-	INIT_LIST_HEAD(&delete_list);
+	LIST_HEAD(add_list);
+	LIST_HEAD(delete_list);
 
 	/*
 	 * The idea here is to do as little work as possible while holding the
@@ -1755,7 +1752,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int i;
 	int rc;
-	struct list_head new_device_list_head;
+	LIST_HEAD(new_device_list_head);
 	struct report_phys_lun_extended *physdev_list = NULL;
 	struct report_log_lun_extended *logdev_list = NULL;
 	struct report_phys_lun_extended_entry *phys_lun_ext_entry;
@@ -1773,8 +1770,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	static char *out_of_memory_msg =
 		"failed to allocate memory, device discovery stopped";
 
-	INIT_LIST_HEAD(&new_device_list_head);
-
 	rc = pqi_get_device_lists(ctrl_info, &physdev_list, &logdev_list);
 	if (rc)
 		goto out;
