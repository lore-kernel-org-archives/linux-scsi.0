From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Subject: [RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes, DirectDrive
 support sends IO's with LBA bit 31 to IR FW instead of DirectDrive
Date: Wed, 25 Jun 2014 16:04:18 +0530
Message-ID: <20140625103418.GA12939@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, sreekanth.reddy@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

There was a down casting of the volume max LBA from a U64 to a U32,
which is taken out and now the max LBA is set appropriately to U64.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

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
+
+			i = (cdb0 < READ_16) ? 2 : 6;
 
 			if (((u64)v_lba + (u64)io_size - 1) <=
-			    (u32)raid_device->max_lba) {
+				raid_device->max_lba) {
 				stripe_sz = raid_device->stripe_sz;
 				stripe_exp = raid_device->stripe_exponent;
 				stripe_off = v_lba & (stripe_sz - 1);
-- 
1.7.1
