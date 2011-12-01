From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 02/07] [SCSI] mpt2sas : When IOs are terminated, update
 the result to DID_SOFT_ERROR to avoid infinite resets
Date: Thu, 1 Dec 2011 07:42:40 +0530
Message-ID: <201112010919.pB19J8rU018126@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:55609 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672Ab1LAJTM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:19:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

When IOs are terminated, update the result to DID_SOFT_ERROR 
to avoid infinite resets.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 447a769..1ef05ee 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4481,6 +4481,8 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 			scmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			goto out;
 		}
+		scmd->result = DID_SOFT_ERROR << 16;
+		break;
 	case MPI2_IOCSTATUS_SCSI_TASK_TERMINATED:
 	case MPI2_IOCSTATUS_SCSI_EXT_TERMINATED:
 		scmd->result = DID_RESET << 16;
