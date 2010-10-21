From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] mpt2sas: Fix missing reference tag seed with Type 2 devices
Date: Thu, 21 Oct 2010 14:19:27 -0400
Message-ID: <yq17hhbquhc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:24982 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab0JUSUB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2010 14:20:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com, James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org


Eric,

I just pulled 2.6.36 and discovered Type 2 devices were not
working. Turns out you tweaked my mpt2sas Type 2 patch a bit before
submitting it to James. Your change left the initial reference tag unset
in the Type 2 case, causing all I/O to fail. The following patch fixes
things up.


[PATCH] mpt2sas: Fix missing reference tag seed with Type 2 devices

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
