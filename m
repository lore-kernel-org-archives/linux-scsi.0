From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 14/20] [SCSI] mpt3sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
Date: Mon, 30 Mar 2015 19:25:17 +0530
Message-ID: <1427723723-12676-15-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

For any SCSI command, if the driver receives IOC status = SCSI_IOC_TERMINATED and log info = 0x32010081 then that command will be completed with DID_RESET host status.

The definition of this log info value is "Virtual IO has failed and has to be retried".

Firmware will provide this log info value with IOC Status "SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume) is pulled and pushed back within some minimal delay.  With this log info value, firmware informs the driver to retry the failed IO command infinite times, so to provide some time for the firmware to discover the reinserted drive successfully instated of just retrying failed command for five times( doesn't giving enough time for firmware to complete the drive discovery) and failing the IO permanently even though drive came back successfully.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index fd00451..55f39f6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4287,6 +4287,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 				scmd->device->expecting_cc_ua = 1;
 			}
 			break;
+		} else if (log_info == 0x32010081) {
+			scmd->result = DID_RESET << 16;
+			break;
 		}
 		scmd->result = DID_SOFT_ERROR << 16;
 		break;
-- 
2.0.2
