From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] [REPOST] mpt2sas: Fix missing reference tag seed with Type 2 devices
Date: Wed, 18 May 2011 00:45:22 -0400
Message-ID: <yq1hb8sfwgt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26447 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1EREpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2011 00:45:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org


Ensure that the initial reference tag is passed on to the HBA firmware
for DIF Type 2 devices.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Kashyap Desai <Kashyap.Desai@lsi.com>

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
