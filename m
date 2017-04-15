From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH] scsi: storvsc: Allow only one remove lun work item to be issued per lun
Date: Sat, 15 Apr 2017 09:43:10 -0400
Message-ID: <1492263790-11378-1-git-send-email-cavery@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752804AbdDONnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Apr 2017 09:43:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kys@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: sthemmin@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

When running multipath on a VM if all available paths go down
the driver can schedule large amounts of storvsc_remove_lun
work items to the same lun. In response to the failing paths
typically storvsc responds by taking host->scan_mutex and issuing
a TUR per lun. If there has been heavy IO to the failed device
all the failed IOs are returned from the host. A remove lun work
item is issued per failed IO. If the outstanding TURs have not been
completed in a timely manner the scan_mutex is never released or
released too late. Consequently the many remove lun work items are
not completed as scsi_remove_device also tries to take host->scan_mutex.
This results in dragging the VM down and sometimes completely.

This patch only allows one remove lun to be issued to a particular
lun while it is an instantiated member of the scsi stack.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 drivers/scsi/storvsc_drv.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 016639d..9dbb5bf 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -478,6 +478,10 @@ struct storvsc_device {
 	u64 port_name;
 };
 
+struct storvsc_dev_hostdata {
+	atomic_t req_remove_lun;
+};
+
 struct hv_host_device {
 	struct hv_device *dev;
 	unsigned int port;
@@ -918,6 +922,8 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 				u8 asc, u8 ascq)
 {
 	struct storvsc_scan_work *wrk;
+	struct storvsc_dev_hostdata *hostdata;
+	struct scsi_device *sdev;
 	void (*process_err_fn)(struct work_struct *work);
 	bool do_work = false;
 
@@ -953,8 +959,17 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		}
 		break;
 	case SRB_STATUS_INVALID_LUN:
-		do_work = true;
-		process_err_fn = storvsc_remove_lun;
+		sdev = scsi_device_lookup(host, 0, vm_srb->target_id,
+					  vm_srb->lun);
+		if (sdev) {
+			hostdata = sdev->hostdata;
+			if (hostdata &&
+			    !atomic_cmpxchg(&hostdata->req_remove_lun, 0, 1)) {
+				do_work = true;
+				process_err_fn = storvsc_remove_lun;
+			}
+			scsi_device_put(sdev);
+		}
 		break;
 	case SRB_STATUS_ABORTED:
 		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID &&
@@ -1426,9 +1441,22 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 			sdevice->no_write_same = 0;
 	}
 
+	sdevice->hostdata = kzalloc(sizeof(struct storvsc_dev_hostdata),
+				    GFP_ATOMIC);
+	if (!sdevice->hostdata)
+		return -ENOMEM;
+
 	return 0;
 }
 
+static void storvsc_device_destroy(struct scsi_device *sdevice)
+{
+	if (sdevice->hostdata) {
+		kfree(sdevice->hostdata);
+		sdevice->hostdata = NULL;
+	}
+}
+
 static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 			   sector_t capacity, int *info)
 {
@@ -1669,6 +1697,7 @@ static struct scsi_host_template scsi_driver = {
 	.eh_timed_out =		storvsc_eh_timed_out,
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_configure =	storvsc_device_configure,
+	.slave_destroy =	storvsc_device_destroy,
 	.cmd_per_lun =		255,
 	.this_id =		-1,
 	.use_clustering =	ENABLE_CLUSTERING,
-- 
2.5.0
