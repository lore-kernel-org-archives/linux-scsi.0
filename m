From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 34/37] smartpqi: cleanup list initialization
Date: Tue, 25 Apr 2017 14:49:19 -0500
Message-ID: <149314975984.13903.15688443193901349399.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0045.outbound.protection.outlook.com ([104.47.40.45]:52648
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1430733AbdDYTtj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:49:39 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
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
index 8b285ad..13d3ed5 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1597,11 +1597,8 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
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
@@ -1761,7 +1758,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 {
 	int i;
 	int rc;
-	struct list_head new_device_list_head;
+	LIST_HEAD(new_device_list_head);
 	struct report_phys_lun_extended *physdev_list = NULL;
 	struct report_log_lun_extended *logdev_list = NULL;
 	struct report_phys_lun_extended_entry *phys_lun_ext_entry;
@@ -1779,8 +1776,6 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 	static char *out_of_memory_msg =
 		"failed to allocate memory, device discovery stopped";
 
-	INIT_LIST_HEAD(&new_device_list_head);
-
 	rc = pqi_get_device_lists(ctrl_info, &physdev_list, &logdev_list);
 	if (rc)
 		goto out;
