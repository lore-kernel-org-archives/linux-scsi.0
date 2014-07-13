From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes, DirectDrive support sends IO's with LBA bit 31 to IR FW instead of DirectDrive
Date: Sun, 13 Jul 2014 11:27:52 -0400
Message-ID: <yq1oawtxoqv.fsf@sermon.lab.mkp.net>
References: <20140625103418.GA12939@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625103418.GA12939@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:04:18 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6ae109b..4a0728a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3865,7 +3865,8 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
 	u16 smid)
 {
-	u32 v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
+	u32 p_lba, stripe_off, stripe_unit, column, io_size;
+	u64 v_lba;
 	u32 stripe_sz, stripe_exp;
 	u8 num_pds, *cdb_ptr, i;
 	u8 cdb0 = scmd->cmnd[0];
@@ -3882,12 +3883,17 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 			| cdb_ptr[5])) {
 			io_size = scsi_bufflen(scmd) >>
 			    raid_device->block_exponent;
-			i = (cdb0 < READ_16) ? 2 : 6;
+
 			/* get virtual lba */
-			v_lba = be32_to_cpu(*(__be32 *)(&cdb_ptr[i]));
+			if (cdb0 < READ_16)
+				v_lba = be32_to_cpu(*(__be32 *)(&cdb_ptr[2]));
+			else
+				v_lba = be64_to_cpu(*(__be64 *)(&cdb_ptr[2]));

Why aren't you using scsi_get_lba() instead of all this nasty CDB
parsing?

+
+			i = (cdb0 < READ_16) ? 2 : 6;

What about WRITE_16?  WRITE_16 > READ_16.

 			if (((u64)v_lba + (u64)io_size - 1) <=
-			    (u32)raid_device->max_lba) {
+				raid_device->max_lba) {
 				stripe_sz = raid_device->stripe_sz;
 				stripe_exp = raid_device->stripe_exponent;
 				stripe_off = v_lba & (stripe_sz - 1);

Also, this is not touched by the patch, but you're then doing:

        (*(__be32 *)(&cdb_ptr[i])) = cpu_to_be32(p_lba);

What if this is a 6-byte READ/WRITE command? You'll end up exceeding the
size of the LBA field.

What if you're using a 16-byte CDB and the target device LBA is > 2TB?

-- 
Martin K. Petersen	Oracle Linux Engineering
