From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 05/10] mpt3sas: Fix IO error occurs on pulling out a drive from RAID1 volume created on two SATA drive
Date: Tue, 10 Oct 2017 18:41:18 +0530
Message-ID: <1507641083-20207-6-git-send-email-Sreekanth.Reddy@broadcom.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Whenever IO for raid volume fails with IOCStatus
 "MPI2_IOCSTATUS_SCSI_IOC_TERMINATED"and SCSIStatus equal to
 "(MPI2_SCSI_STATE_TERMINATED | MPI2_SCSI_STATE_NO_SCSI_STATUS)"
 then return the IO to SML with "DID_RESET"
 (i.e. retry the IO infinite times) host bytes.

Earlier driver is returning the IO with "DID_SOFT_ERROR"
 that reties the IO quickly for five times but still
 firmware needed some more time and hence IOs were failing.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index cc78ce4..fa948ab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4807,6 +4807,11 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		} else if (log_info == VIRTUAL_IO_FAILED_RETRY) {
 			scmd->result = DID_RESET << 16;
 			break;
+		} else if ((scmd->device->channel == RAID_CHANNEL) &&
+		   (scsi_state == (MPI2_SCSI_STATE_TERMINATED |
+		   MPI2_SCSI_STATE_NO_SCSI_STATUS))) {
+			scmd->result = DID_RESET << 16;
+			break;
 		}
 		scmd->result = DID_SOFT_ERROR << 16;
 		break;
-- 
2.4.3
