From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 14/20] [SCSI] mpt3sas: Complete the SCSI  command with DID_RESET  status for log_info value 0x0x32010081
Date: Tue, 30 Jun 2015 12:25:00 +0530
Message-ID: <1435647306-36956-15-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

For any SCSI command, if the driver receives
IOC status = SCSI_IOC_TERMINATED and log info = 0x32010081 then
that command will be completed with DID_RESET host status.

The definition of this log info value is
"Virtual IO has failed and has to be retried".

Firmware will provide this log info value with IOC Status
"SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume)
is pulled and pushed back within some minimal delay.
With this log info value, firmware informs the driver to retry the
failed IO command infinite times, so to provide some time for the
firmware to discover the reinserted drive successfully instated of
just retrying failed command for five times(doesn't giving enough
time for firmware to complete the drive discovery) and failing the
IO permanently even though drive came back successfully.

Changes in v1:
   Defined macro VIRTUAL_IO_FAILED_RETRY for magic a value 0x32010081

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4196fbb..3b03639 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -202,6 +202,8 @@
 #define MFG10_GF0_SSD_DATA_SCRUB_DISABLE       (0x00000008)
 #define MFG10_GF0_SINGLE_DRIVE_R0              (0x00000010)
 
+#define VIRTUAL_IO_FAILED_RETRY			(0x32010081)
+
 /* OEM Specific Flags will come from OEM specific header files */
 struct Mpi2ManufacturingPage10_t {
 	MPI2_CONFIG_PAGE_HEADER	Header;		/* 00h */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 64dd90b..49c412b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4241,6 +4241,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 				scmd->device->expecting_cc_ua = 1;
 			}
 			break;
+		} else if (log_info == VIRTUAL_IO_FAILED_RETRY) {
+			scmd->result = DID_RESET << 16;
+			break;
 		}
 		scmd->result = DID_SOFT_ERROR << 16;
 		break;
-- 
2.0.2
