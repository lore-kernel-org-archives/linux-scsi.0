From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for log_info value 0x0x32010081
Date: Thu, 20 Nov 2014 12:35:40 +0530
Message-ID: <1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og126.obsmtp.com ([64.18.2.206]:36184 "EHLO
	exprod7og126.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKTHMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 02:12:01 -0500
Received: by mail-pa0-f45.google.com with SMTP id lj1so1987215pab.32
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2014 23:12:00 -0800 (PST)
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

For any SCSI command, if the driver receives IOC status = SCSI_IOC_TERMINATED and log info = 0x32010081
 then that command will be completed with DID_RESET host status.

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

