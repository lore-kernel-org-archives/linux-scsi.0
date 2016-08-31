From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 04/15] smartpqi: enhance drive offline informational
 message
Date: Wed, 31 Aug 2016 14:54:29 -0500
Message-ID: <147267326916.22907.5428047554855988573.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0065.outbound.protection.outlook.com ([104.47.40.65]:58274
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754543AbcHaUKM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 16:10:12 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Made a couple of error messages more verbose.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9922e31..198a7c2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2298,11 +2298,16 @@ static inline void pqi_aio_path_disabled(struct pqi_io_request *io_request)
 static inline void pqi_take_device_offline(struct scsi_device *sdev)
 {
 	struct pqi_ctrl_info *ctrl_info;
+	struct pqi_scsi_dev *device;
 
 	if (scsi_device_online(sdev)) {
 		scsi_device_set_state(sdev, SDEV_OFFLINE);
 		ctrl_info = shost_to_hba(sdev->host);
 		schedule_delayed_work(&ctrl_info->rescan_work, 0);
+		device = sdev->hostdata;
+		dev_err(&ctrl_info->pci_dev->dev, "offlined scsi %d:%d:%d:%d\n",
+			ctrl_info->scsi_host->host_no, device->bus,
+			device->target, device->lun);
 	}
 }
 

