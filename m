From: Erwan Velu <erwanaliasr1@gmail.com>
Subject: [PATCH v2] scsi: smartpqi_init: Reporting 'logical unit failure'
Date: Fri,  1 Mar 2019 15:58:32 +0100
Message-ID: <20190301145832.12735-1-e.velu@criteo.com>
References: <20190227163133.26283-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190227163133.26283-1-e.velu@criteo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: elliott@hpe.com
Cc: Erwan Velu <e.velu@criteo.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI
        DRIVER smartpqi" <esc.storagedev@microsemi.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI
        DRIVER smartpqi" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When the HARDWARE_ERROR/0x3e/0x1 case is triggered, the logical volume is offlined.
When reading the kernel log, the reason why the device got offlined isn't reported to the user.
This situation makes difficult for admins to estimate the root cause of the issue they analize.

Reading this part of the code makes clear this is because driver received a HARDWARE_ERROR/0x3e/0x1 which is a 'logical unit failure'.
This patch is just about reporting the reason behind the offlining to ease the analyse.

Signed-off-by: Erwan Velu <e.velu@criteo.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f564af8949e8..dfc4a6813440 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2764,6 +2764,12 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 				sshdr.sense_key == HARDWARE_ERROR &&
 				sshdr.asc == 0x3e &&
 				sshdr.ascq == 0x1) {
+			struct pqi_ctrl_info *ctrl_info = shost_to_hba(scmd->device->host);
+			struct pqi_scsi_dev *device = scmd->device->hostdata;
+
+			dev_err_ratelimited(&ctrl_info->pci_dev->dev, "received 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",
+							ctrl_info->scsi_host->host_no, device->bus,
+							device->target, device->lun);
 			pqi_take_device_offline(scmd->device, "RAID");
 			host_byte = DID_NO_CONNECT;
 		}
-- 
2.20.1
