From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes, DirectDrive support sends IO's with LBA bit 31 to IR FW instead of DirectDrive
Date: Tue, 15 Jul 2014 12:02:05 -0400
Message-ID: <yq1fvi2wqyq.fsf@sermon.lab.mkp.net>
References: <20140625103418.GA12939@avagotech.com>
	<yq1oawtxoqv.fsf@sermon.lab.mkp.net>
	<CAK=zhgosXeox35kVvuiTm8EZaD2-e_Lxz79uFFAP0c1cMJNbcg@mail.gmail.com>
	<CAK=zhgq6bXRBapfBy+Nx5uFFLUuj1cH78x0RXCU1Vk8Y9NWheA@mail.gmail.com>
	<yq1fvi3y736.fsf@sermon.lab.mkp.net>
	<CAK=zhgrUWOS-pPjamF+z+AZZvdXz_JxyKgdTv6Zae0oLk=qQog@mail.gmail.com>
	<yq1r41mwwlb.fsf@sermon.lab.mkp.net>
	<CAK=zhgrE0QBgyyLTU0Jdq2cAbKbd=wY4zfMGo2ux9nWz9oBgiQ@mail.gmail.com>
	<CAK=zhgpqcFu5WKLEOD9E=K9DURO9HEtXE8VDVpScLiZK+3JsAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40805 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaGOQCN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2014 12:02:13 -0400
In-Reply-To: <CAK=zhgpqcFu5WKLEOD9E=K9DURO9HEtXE8VDVpScLiZK+3JsAQ@mail.gmail.com>
	(Sreekanth Reddy's message of "Tue, 15 Jul 2014 21:24:52 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Sathya Prakash <sathya.prakash@avagotech.com>, linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> I have tried with this diff. And I still observe the invalid
Sreekanth> LBA (i.e.  0xFFFFFFFF) with scsi_get_lba() API when I used
Sreekanth> the sg_dd with input file specified as /dev/sg0.

Yeah, I now remember that scsi_get_lba() fails for PC commands.

Sreekanth> Also below section of code will overwrite the CDB operation
Sreekanth> code. and the final CDB has the some junk values.

Yep, already fixed that.

Please try the updated patch below.

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5055f925d2cd..11617f6b8c60 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -55,6 +55,8 @@
 #include <linux/raid_class.h>
 #include <linux/slab.h>
 
+#include <asm/unaligned.h>
+
 #include "mpt2sas_base.h"
 
 MODULE_AUTHOR(MPT2SAS_AUTHOR);
@@ -3857,85 +3859,47 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
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
+	v_lba = scsi_get_lba(scmd);
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
