From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 14/20 v1] [SCSI] mpt3sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
Date: Tue, 16 Jun 2015 11:05:24 +0530
Message-ID: <1434432924-40632-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35083 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbFPFfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2015 01:35:41 -0400
Received: by pdbnf5 with SMTP id nf5so6325128pdb.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2015 22:35:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org, jthumshirn@suse.de
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

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

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  | 2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 0ffe763..f3f79be 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -203,6 +203,8 @@
 #define MFG10_GF0_SSD_DATA_SCRUB_DISABLE       (0x00000008)
 #define MFG10_GF0_SINGLE_DRIVE_R0              (0x00000010)
 
+#define VIRTUAL_IO_FAILED_RETRY			(0x32010081)
+
 /* OEM Specific Flags will come from OEM specific header files */
 struct Mpi2ManufacturingPage10_t {
 	MPI2_CONFIG_PAGE_HEADER	Header;		/* 00h */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7060c8b..7587f77 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4302,6 +4302,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
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

