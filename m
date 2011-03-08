From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] mpt2sas: Fix missing reference tag seed with Type 2 devices
Date: Tue, 08 Mar 2011 01:59:44 -0500
Message-ID: <yq162rudrmn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:44219 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1CHG7x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 01:59:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Kashyap.Desai@lsi.com, Eric.Moore@lsi.com


Ensure that the initial reference tag is passed on to the HBA firmware
for DIF Type 2 devices.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..f423fe9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3230,6 +3230,7 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
 
 	switch (prot_type) {
 	case SCSI_PROT_DIF_TYPE1:
+	case SCSI_PROT_DIF_TYPE2:
 
 		/*
 		* enable ref/guard checking
@@ -3242,13 +3243,6 @@ _scsih_setup_eedp(struct scsi_cmnd *scmd, Mpi2SCSIIORequest_t *mpi_request)
 		    cpu_to_be32(scsi_get_lba(scmd));
 		break;
 
-	case SCSI_PROT_DIF_TYPE2:
-
-		eedp_flags |= MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
-		    MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
-		break;
-
 	case SCSI_PROT_DIF_TYPE3:
 
 		/*
