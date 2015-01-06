From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
Date: Tue,  6 Jan 2015 17:24:12 +0530
Message-ID: <1420545252-35340-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

For any SCSI command, if the driver receives IOC status = SCSI_IOC_TERMINATED and log info = 0x32010081
 then that command will be completed with DID_RESET host status.

The definition of this log info value is "Virtual IO has failed and has to be retried".

Firmware will provide this log info value with IOC Status
"SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume)
is pulled and pushed back within some minimal delay.  With this log info
value, firmware informs the driver to retry the failed IO command
infinite times, so to provide some time for the firmware to discover
the reinserted drive successfully instated of just retrying failed
command for five times( doesn't giving enough time for firmware to
complete the drive discovery) and failing the IO permanently even
though drive came back successfully.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 38acb91..c6bb136 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4574,6 +4574,10 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			goto out;
 		}
+		if (log_info == 0x32010081) {
+			scmd->result = DID_RESET << 16;
+			break;
+		}
 		scmd->result = DID_SOFT_ERROR << 16;
 		break;
 	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
-- 
2.0.2
