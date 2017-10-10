From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 04/10] mpt3sas: Fix removal and addition of vSES device during host reset
Date: Tue, 10 Oct 2017 18:41:17 +0530
Message-ID: <1507641083-20207-5-git-send-email-Sreekanth.Reddy@broadcom.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:56620 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756268AbdJJNMP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 09:12:15 -0400
Received: by mail-qt0-f170.google.com with SMTP id 34so33851405qtb.13
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 06:12:14 -0700 (PDT)
In-Reply-To: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

For Dev Handles who value is less than hba's phys count number
 driver will return HBA sas address value as a sas address.
So for Virtual SES device also driver was returning HBA sas address instead
 of Virtual SES sas address. So now updated the driver to return
 Virtual SES's sas address for Virtual SES device instead of
 HBA's sas address.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 600e8ef..cc78ce4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -406,11 +406,6 @@ _scsih_get_sas_address(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 	*sas_address = 0;
 
-	if (handle <= ioc->sas_hba.num_phys) {
-		*sas_address = ioc->sas_hba.sas_address;
-		return 0;
-	}
-
 	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
 	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
@@ -420,7 +415,15 @@ _scsih_get_sas_address(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
 	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
-		*sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
+		/* For HBA vSES don't return hba sas address instead return
+		 * vSES's sas address.
+		 */
+		if ((handle <= ioc->sas_hba.num_phys) &&
+		   (!(le32_to_cpu(sas_device_pg0.DeviceInfo) &
+		   MPI2_SAS_DEVICE_INFO_SEP)))
+			*sas_address = ioc->sas_hba.sas_address;
+		else
+			*sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
 		return 0;
 	}
 
-- 
2.4.3
