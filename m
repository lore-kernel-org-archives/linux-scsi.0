From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] [SCSI] mpt2sas: Avoid type casting for direct I/O commands
Date: Wed, 16 Jul 2014 13:17:20 -0400
Message-ID: <yq1zjg9rzof.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33984 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209AbaGPRR1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2014 13:17:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>


A type casting error caused the max volume LBA to be truncated from 64
to 32 bits. The virtual LBA would also get truncated to 32 bits in the
case of a 16-byte READ/WRITE command.
    
Rewrite entire function to get rid of code duplication and type casts.
Use get/put_unaligned wrappers to extract and replace the LBA field in
the MPI request CDB.
    
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5055f925d2cd..24855251ee14 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -55,6 +55,8 @@
 #include <linux/raid_class.h>
 #include <linux/slab.h>
 
+#include <asm/unaligned.h>
+
 #include "mpt2sas_base.h"
 
 MODULE_AUTHOR(MPT2SAS_AUTHOR);
@@ -3857,85 +3859,46 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
 	u16 smid)
 {
-	u32 v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
+	sector_t v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
 	u32 stripe_sz, stripe_exp;
-	u8 num_pds, *cdb_ptr, i;
-	u8 cdb0 = scmd->cmnd[0];
-	u64 v_llba;
+	u8 num_pds, cmd = scmd->cmnd[0];
 
-	/*
-	 * Try Direct I/O to RAID memeber disks
-	 */
-	if (cdb0 == READ_16 || cdb0 == READ_10 ||
-	    cdb0 == WRITE_16 || cdb0 == WRITE_10) {
-		cdb_ptr = mpi_request->CDB.CDB32;
-
-		if ((cdb0 < READ_16) || !(cdb_ptr[2] | cdb_ptr[3] | cdb_ptr[4]
-			| cdb_ptr[5])) {
-			io_size = scsi_bufflen(scmd) >>
-			    raid_device->block_exponent;
-			i = (cdb0 < READ_16) ? 2 : 6;
-			/* get virtual lba */
-			v_lba = be32_to_cpu(*(__be32 *)(&cdb_ptr[i]));
-
-			if (((u64)v_lba + (u64)io_size - 1) <=
-			    (u32)raid_device->max_lba) {
-				stripe_sz = raid_device->stripe_sz;
-				stripe_exp = raid_device->stripe_exponent;
-				stripe_off = v_lba & (stripe_sz - 1);
-
-				/* Check whether IO falls within a stripe */
-				if ((stripe_off + io_size) <= stripe_sz) {
-					num_pds = raid_device->num_pds;
-					p_lba = v_lba >> stripe_exp;
-					stripe_unit = p_lba / num_pds;
-					column = p_lba % num_pds;
-					p_lba = (stripe_unit << stripe_exp) +
-					    stripe_off;
-					mpi_request->DevHandle =
-						cpu_to_le16(raid_device->
-						    pd_handle[column]);
-					(*(__be32 *)(&cdb_ptr[i])) =
-						cpu_to_be32(p_lba);
-					/*
-					* WD: To indicate this I/O is directI/O
-					*/
-					_scsih_scsi_direct_io_set(ioc, smid, 1);
-				}
-			}
-		} else {
-			io_size = scsi_bufflen(scmd) >>
-			    raid_device->block_exponent;
-			/* get virtual lba */
-			v_llba = be64_to_cpu(*(__be64 *)(&cdb_ptr[2]));
-
-			if ((v_llba + (u64)io_size - 1) <=
-			    raid_device->max_lba) {
-				stripe_sz = raid_device->stripe_sz;
-				stripe_exp = raid_device->stripe_exponent;
-				stripe_off = (u32) (v_llba & (stripe_sz - 1));
-
-				/* Check whether IO falls within a stripe */
-				if ((stripe_off + io_size) <= stripe_sz) {
-					num_pds = raid_device->num_pds;
-					p_lba = (u32)(v_llba >> stripe_exp);
-					stripe_unit = p_lba / num_pds;
-					column = p_lba % num_pds;
-					p_lba = (stripe_unit << stripe_exp) +
-					    stripe_off;
-					mpi_request->DevHandle =
-						cpu_to_le16(raid_device->
-						    pd_handle[column]);
-					(*(__be64 *)(&cdb_ptr[2])) =
-					    cpu_to_be64((u64)p_lba);
-					/*
-					* WD: To indicate this I/O is directI/O
-					*/
-					_scsih_scsi_direct_io_set(ioc, smid, 1);
-				}
-			}
-		}
-	}
+	if (cmd != READ_10 && cmd != WRITE_10 &&
+	    cmd != READ_16 && cmd != WRITE_16)
+		return;
+
+	if (cmd == READ_10 || cmd == WRITE_10)
+		v_lba = get_unaligned_be32(&mpi_request->CDB.CDB32[2]);
+	else
+		v_lba = get_unaligned_be64(&mpi_request->CDB.CDB32[2]);
+
+	io_size = scsi_bufflen(scmd) >> raid_device->block_exponent;
+
+	if (v_lba + io_size - 1 > raid_device->max_lba)
+		return;
+
+	stripe_sz = raid_device->stripe_sz;
+	stripe_exp = raid_device->stripe_exponent;
+	stripe_off = v_lba & (stripe_sz - 1);
+
+	/* Return unless IO falls within a stripe */
+	if (stripe_off + io_size > stripe_sz)
+		return;
+
+	num_pds = raid_device->num_pds;
+	p_lba = v_lba >> stripe_exp;
+	stripe_unit = p_lba / num_pds;
+	column = p_lba % num_pds;
+	p_lba = (stripe_unit << stripe_exp) + stripe_off;
+	mpi_request->DevHandle = cpu_to_le16(raid_device->pd_handle[column]);
+
+	if (cmd == READ_10 || cmd == WRITE_10)
+		put_unaligned_be32(lower_32_bits(p_lba),
+				   &mpi_request->CDB.CDB32[2]);
+	else
+		put_unaligned_be64(p_lba, &mpi_request->CDB.CDB32[2]);
+
+	_scsih_scsi_direct_io_set(ioc, smid, 1);
 }
 
 /**
