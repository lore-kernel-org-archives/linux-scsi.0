From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 03/11] megaraid_sas: EEDP Escape Mode Support for SAS3.5 Generic Megaraid Controllers
Date: Fri,  2 Dec 2016 09:07:20 -0500
Message-ID: <1480687648-36380-4-git-send-email-sasikumar.pc@broadcom.com>
References: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:36700 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761731AbcLBOIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2016 09:08:00 -0500
Received: by mail-qt0-f170.google.com with SMTP id w33so252133179qtc.3
        for <linux-scsi@vger.kernel.org>; Fri, 02 Dec 2016 06:07:59 -0800 (PST)
In-Reply-To: <1480687648-36380-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, sumit.saxena@broadcom.com, thenzl@redhat.com, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>

An UNMAP command on a PI formatted device will leave the Logical Block Application
Tag and Logical Block Reference Tag as all F's (for those LBAs that are unmapped).
To avoid IO errors if those LBAs are subsequently read before they are written with
valid tag fields, the MPI SCSI IO requests need to set the EEDPFlags element EEDP
Escape Mode field, Bits [7:6] appropriately.  A value of 2 should be set to disable
all PI checks if the Logical Block Application Tag is 0xFFFF for PI types 1 and 2.
A value of 3 should be set to disable all PI checks if the Logical Block Application
Tag is 0xFFFF and the Logical Block Reference Tag is 0xFFFFFFFF for PI type 3.

This patch is depending on patch 2

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 9de9e66..7f26b14 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1589,6 +1589,7 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 				MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
 				MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP |
 				MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG |
+				MPI25_SCSIIO_EEDPFLAGS_DO_NOT_DISABLE_MODE |
 				MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD);
 		} else {
 			io_request->EEDPFlags = cpu_to_le16(
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index e3bee04..9d22ade 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -175,6 +175,8 @@ enum REGION_TYPE {
 #define MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG          (0x0200)
 #define MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD           (0x0100)
 #define MPI2_SCSIIO_EEDPFLAGS_INSERT_OP             (0x0004)
+/* EEDP escape mode */
+#define MPI25_SCSIIO_EEDPFLAGS_DO_NOT_DISABLE_MODE  (0x0040)
 #define MPI2_FUNCTION_SCSI_IO_REQUEST               (0x00) /* SCSI IO */
 #define MPI2_FUNCTION_SCSI_TASK_MGMT                (0x01)
 #define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY       (0x03)
-- 
1.8.3.1

