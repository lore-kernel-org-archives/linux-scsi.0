From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 20/25] mpt3sas: Moved Warpdriver specific functions to mpt3sas_warpdrive.c
Date: Wed, 11 Nov 2015 17:30:36 +0530
Message-ID: <1447243241-10912-21-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Change List:
* Moved mpt2sas_warpdrive.c file from mpt2sas to mpt3sas folder
  and renamed it as mpt3sas_warpdrive.c.
* Also renamed the functions in mpt3sas_warpdrive.c file to follow
  current driver function name convention.
* Updated the Makefile to build mpt3sas_warpdrive.o file for these
  warpdrive specific functions.
* Also in function mpt3sas_setup_direct_io(), used sector_div() API
  instead of division operator (which gives compilation errors on
  32 bit machines)

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_warpdrive.c | 338 ------------------------------
 drivers/scsi/mpt3sas/Makefile            |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  16 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  44 ++--
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c | 344 +++++++++++++++++++++++++++++++
 5 files changed, 376 insertions(+), 369 deletions(-)
 delete mode 100644 drivers/scsi/mpt2sas/mpt2sas_warpdrive.c
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c

diff --git a/drivers/scsi/mpt2sas/mpt2sas_warpdrive.c b/drivers/scsi/mpt2sas/mpt2sas_warpdrive.c
deleted file mode 100644
index c4fcbc2..0000000
--- a/drivers/scsi/mpt2sas/mpt2sas_warpdrive.c
+++ /dev/null
@@ -1,338 +0,0 @@
-/*
- * Scsi Host Layer for MPT (Message Passing Technology) based controllers
- *
- * Copyright (C) 2012-2014  LSI Corporation
- * Copyright (C) 2013-2015 Avago Technologies
- *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * NO WARRANTY
- * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
- * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
- * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
- * solely responsible for determining the appropriateness of using and
- * distributing the Program and assumes all risks associated with its
- * exercise of rights under this Agreement, including but not limited to
- * the risks and costs of program errors, damage to or loss of data,
- * programs or equipment, and unavailability or interruption of operations.
-
- * DISCLAIMER OF LIABILITY
- * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
- * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
- * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
- * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
- * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
- * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
-
- * You should have received a copy of the GNU General Public License
- * along with this program.
- */
-
-/**
- * _scsih_disable_ddio - Disable direct I/O for all the volumes
- * @ioc: per adapter object
- */
-static void
-_scsih_disable_ddio(struct MPT3SAS_ADAPTER *ioc)
-{
-	Mpi2RaidVolPage1_t vol_pg1;
-	Mpi2ConfigReply_t mpi_reply;
-	struct _raid_device *raid_device;
-	u16 handle;
-	u16 ioc_status;
-	unsigned long flags;
-
-	handle = 0xFFFF;
-	while (!(mpt3sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
-	    &vol_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
-		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
-		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
-		handle = le16_to_cpu(vol_pg1.DevHandle);
-		spin_lock_irqsave(&ioc->raid_device_lock, flags);
-		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
-		if (raid_device)
-			raid_device->direct_io_enabled = 0;
-		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
-	}
-	return;
-}
-
-
-/**
- * _scsih_get_num_volumes - Get number of volumes in the ioc
- * @ioc: per adapter object
- */
-static u8
-_scsih_get_num_volumes(struct MPT3SAS_ADAPTER *ioc)
-{
-	Mpi2RaidVolPage1_t vol_pg1;
-	Mpi2ConfigReply_t mpi_reply;
-	u16 handle;
-	u8 vol_cnt = 0;
-	u16 ioc_status;
-
-	handle = 0xFFFF;
-	while (!(mpt3sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
-	    &vol_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
-		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
-		    MPI2_IOCSTATUS_MASK;
-		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
-			break;
-		vol_cnt++;
-		handle = le16_to_cpu(vol_pg1.DevHandle);
-	}
-	return vol_cnt;
-}
-
-
-/**
- * _scsih_init_warpdrive_properties - Set properties for warpdrive direct I/O.
- * @ioc: per adapter object
- * @raid_device: the raid_device object
- */
-static void
-_scsih_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
-	struct _raid_device *raid_device)
-{
-	Mpi2RaidVolPage0_t *vol_pg0;
-	Mpi2RaidPhysDiskPage0_t pd_pg0;
-	Mpi2ConfigReply_t mpi_reply;
-	u16 sz;
-	u8 num_pds, count;
-	unsigned long stripe_sz, block_sz;
-	u8 stripe_exp, block_exp;
-	u64 dev_max_lba;
-
-	if (!ioc->is_warpdrive)
-		return;
-
-	if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "globally as drives are exposed\n", ioc->name);
-		return;
-	}
-	if (_scsih_get_num_volumes(ioc) > 1) {
-		_scsih_disable_ddio(ioc);
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "globally as number of drives > 1\n", ioc->name);
-		return;
-	}
-	if ((mpt3sas_config_get_number_pds(ioc, raid_device->handle,
-	    &num_pds)) || !num_pds) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "Failure in computing number of drives\n", ioc->name);
-		return;
-	}
-
-	sz = offsetof(Mpi2RaidVolPage0_t, PhysDisk) + (num_pds *
-	    sizeof(Mpi2RaidVol0PhysDisk_t));
-	vol_pg0 = kzalloc(sz, GFP_KERNEL);
-	if (!vol_pg0) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "Memory allocation failure for RVPG0\n", ioc->name);
-		return;
-	}
-
-	if ((mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, vol_pg0,
-	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, raid_device->handle, sz))) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "Failure in retrieving RVPG0\n", ioc->name);
-		kfree(vol_pg0);
-		return;
-	}
-
-	/*
-	 * WARPDRIVE:If number of physical disks in a volume exceeds the max pds
-	 * assumed for WARPDRIVE, disable direct I/O
-	 */
-	if (num_pds > MPT_MAX_WARPDRIVE_PDS) {
-		pr_warn(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "for the drive with handle(0x%04x): num_mem=%d, "
-		    "max_mem_allowed=%d\n", ioc->name, raid_device->handle,
-		    num_pds, MPT_MAX_WARPDRIVE_PDS);
-		kfree(vol_pg0);
-		return;
-	}
-	for (count = 0; count < num_pds; count++) {
-		if (mpt3sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
-		    &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM,
-		    vol_pg0->PhysDisk[count].PhysDiskNum) ||
-		    pd_pg0.DevHandle == MPT3SAS_INVALID_DEVICE_HANDLE) {
-			pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is "
-			    "disabled for the drive with handle(0x%04x) member"
-			    "handle retrieval failed for member number=%d\n",
-			    ioc->name, raid_device->handle,
-			    vol_pg0->PhysDisk[count].PhysDiskNum);
-			goto out_error;
-		}
-		/* Disable direct I/O if member drive lba exceeds 4 bytes */
-		dev_max_lba = le64_to_cpu(pd_pg0.DeviceMaxLBA);
-		if (dev_max_lba >> 32) {
-			pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is "
-			    "disabled for the drive with handle(0x%04x) member"
-			    " handle (0x%04x) unsupported max lba 0x%016llx\n",
-			    ioc->name, raid_device->handle,
-			    le16_to_cpu(pd_pg0.DevHandle),
-			    (unsigned long long)dev_max_lba);
-			goto out_error;
-		}
-
-		raid_device->pd_handle[count] = le16_to_cpu(pd_pg0.DevHandle);
-	}
-
-	/*
-	 * Assumption for WD: Direct I/O is not supported if the volume is
-	 * not RAID0
-	 */
-	if (raid_device->volume_type != MPI2_RAID_VOL_TYPE_RAID0) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "for the drive with handle(0x%04x): type=%d, "
-		    "s_sz=%uK, blk_size=%u\n", ioc->name,
-		    raid_device->handle, raid_device->volume_type,
-		    (le32_to_cpu(vol_pg0->StripeSize) *
-		    le16_to_cpu(vol_pg0->BlockSize)) / 1024,
-		    le16_to_cpu(vol_pg0->BlockSize));
-		goto out_error;
-	}
-
-	stripe_sz = le32_to_cpu(vol_pg0->StripeSize);
-	stripe_exp = find_first_bit(&stripe_sz, 32);
-	if (stripe_exp == 32) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		"for the drive with handle(0x%04x) invalid stripe sz %uK\n",
-		    ioc->name, raid_device->handle,
-		    (le32_to_cpu(vol_pg0->StripeSize) *
-		    le16_to_cpu(vol_pg0->BlockSize)) / 1024);
-		goto out_error;
-	}
-	raid_device->stripe_exponent = stripe_exp;
-	block_sz = le16_to_cpu(vol_pg0->BlockSize);
-	block_exp = find_first_bit(&block_sz, 16);
-	if (block_exp == 16) {
-		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
-		    "for the drive with handle(0x%04x) invalid block sz %u\n",
-		    ioc->name, raid_device->handle,
-		    le16_to_cpu(vol_pg0->BlockSize));
-		goto out_error;
-	}
-	raid_device->block_exponent = block_exp;
-	raid_device->direct_io_enabled = 1;
-
-	pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is Enabled for the drive"
-	    " with handle(0x%04x)\n", ioc->name, raid_device->handle);
-	/*
-	 * WARPDRIVE: Though the following fields are not used for direct IO,
-	 * stored for future purpose:
-	 */
-	raid_device->max_lba = le64_to_cpu(vol_pg0->MaxLBA);
-	raid_device->stripe_sz = le32_to_cpu(vol_pg0->StripeSize);
-	raid_device->block_sz = le16_to_cpu(vol_pg0->BlockSize);
-
-
-	kfree(vol_pg0);
-	return;
-
-out_error:
-	raid_device->direct_io_enabled = 0;
-	for (count = 0; count < num_pds; count++)
-		raid_device->pd_handle[count] = 0;
-	kfree(vol_pg0);
-	return;
-}
-
-/**
- * _scsih_scsi_direct_io_get - returns direct io flag
- * @ioc: per adapter object
- * @smid: system request message index
- *
- * Returns the smid stored scmd pointer.
- */
-static inline u8
-_scsih_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
-{
-	return ioc->scsi_lookup[smid - 1].direct_io;
-}
-
-/**
- * _scsih_scsi_direct_io_set - sets direct io flag
- * @ioc: per adapter object
- * @smid: system request message index
- * @direct_io: Zero or non-zero value to set in the direct_io flag
- *
- * Returns Nothing.
- */
-static inline void
-_scsih_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io)
-{
-	ioc->scsi_lookup[smid - 1].direct_io = direct_io;
-}
-
-/**
- * _scsih_setup_direct_io - setup MPI request for WARPDRIVE Direct I/O
- * @ioc: per adapter object
- * @scmd: pointer to scsi command object
- * @raid_device: pointer to raid device data structure
- * @mpi_request: pointer to the SCSI_IO reqest message frame
- * @smid: system request message index
- *
- * Returns nothing
- */
-static void
-_scsih_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
-	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
-	u16 smid)
-{
-	sector_t v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
-	u32 stripe_sz, stripe_exp;
-	u8 num_pds, cmd = scmd->cmnd[0];
-
-	if (cmd != READ_10 && cmd != WRITE_10 &&
-	    cmd != READ_16 && cmd != WRITE_16)
-		return;
-
-	if (cmd == READ_10 || cmd == WRITE_10)
-		v_lba = get_unaligned_be32(&mpi_request->CDB.CDB32[2]);
-	else
-		v_lba = get_unaligned_be64(&mpi_request->CDB.CDB32[2]);
-
-	io_size = scsi_bufflen(scmd) >> raid_device->block_exponent;
-
-	if (v_lba + io_size - 1 > raid_device->max_lba)
-		return;
-
-	stripe_sz = raid_device->stripe_sz;
-	stripe_exp = raid_device->stripe_exponent;
-	stripe_off = v_lba & (stripe_sz - 1);
-
-	/* Return unless IO falls within a stripe */
-	if (stripe_off + io_size > stripe_sz)
-		return;
-
-	num_pds = raid_device->num_pds;
-	p_lba = v_lba >> stripe_exp;
-	stripe_unit = p_lba / num_pds;
-	column = p_lba % num_pds;
-	p_lba = (stripe_unit << stripe_exp) + stripe_off;
-	mpi_request->DevHandle = cpu_to_le16(raid_device->pd_handle[column]);
-
-	if (cmd == READ_10 || cmd == WRITE_10)
-		put_unaligned_be32(lower_32_bits(p_lba),
-				   &mpi_request->CDB.CDB32[2]);
-	else
-		put_unaligned_be64(p_lba, &mpi_request->CDB.CDB32[2]);
-
-	_scsih_scsi_direct_io_set(ioc, smid, 1);
-}
diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
index efb0c4c..b7643f5 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -5,4 +5,5 @@ mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_scsih.o      \
 		mpt3sas_transport.o     \
 		mpt3sas_ctl.o	\
-		mpt3sas_trigger_diag.o
+		mpt3sas_trigger_diag.o \
+		mpt3sas_warpdrive.o
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 08bedb6..087586e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1270,6 +1270,8 @@ struct _sas_device *__mpt3sas_get_sdev_by_addr(
 	 struct MPT3SAS_ADAPTER *ioc, u64 sas_address);
 
 void mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc);
+struct _raid_device *
+mpt3sas_raid_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle);
 
 /* config shared API */
 u8 mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
@@ -1403,4 +1405,18 @@ void mpt3sas_trigger_scsi(struct MPT3SAS_ADAPTER *ioc, u8 sense_key,
 	u8 asc, u8 ascq);
 void mpt3sas_trigger_mpi(struct MPT3SAS_ADAPTER *ioc, u16 ioc_status,
 	u32 loginfo);
+
+/* warpdrive APIs */
+u8 mpt3sas_get_num_volumes(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
+	struct _raid_device *raid_device);
+inline u8
+mpt3sas_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid);
+inline void
+mpt3sas_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io);
+void
+mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
+	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
+	u16 smid);
+
 #endif /* MPT3SAS_BASE_H_INCLUDED */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index efbce3f..04570a2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -71,20 +71,6 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 
-static void _scsih_disable_ddio(struct MPT3SAS_ADAPTER *ioc);
-static u8 _scsih_get_num_volumes(struct MPT3SAS_ADAPTER *ioc);
-static void
-_scsih_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
-	struct _raid_device *raid_device);
-static inline u8
-_scsih_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid);
-static inline void
-_scsih_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io);
-static void
-_scsih_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
-	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
-	u16 smid);
-
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
 /* global ioc lock for list operations */
@@ -884,7 +870,7 @@ _scsih_raid_device_find_by_id(struct MPT3SAS_ADAPTER *ioc, int id, int channel)
 }
 
 /**
- * _scsih_raid_device_find_by_handle - raid device search
+ * mpt3sas_raid_device_find_by_handle - raid device search
  * @ioc: per adapter object
  * @handle: sas device handle (assigned by firmware)
  * Context: Calling function should acquire ioc->raid_device_lock
@@ -892,8 +878,8 @@ _scsih_raid_device_find_by_id(struct MPT3SAS_ADAPTER *ioc, int id, int channel)
  * This searches for raid_device based on handle, then return raid_device
  * object.
  */
-static struct _raid_device *
-_scsih_raid_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+struct _raid_device *
+mpt3sas_raid_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct _raid_device *raid_device, *r;
 
@@ -1829,7 +1815,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 	if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME) {
 
 		spin_lock_irqsave(&ioc->raid_device_lock, flags);
-		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+		raid_device = mpt3sas_raid_device_find_by_handle(ioc, handle);
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 		if (!raid_device) {
 			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
@@ -1848,7 +1834,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 		/*
 		 * WARPDRIVE: Initialize the required data for Direct IO
 		 */
-		_scsih_init_warpdrive_properties(ioc, raid_device);
+		mpt3sas_init_warpdrive_properties(ioc, raid_device);
 
 		/* RAID Queue Depth Support
 		 * IS volume = underlying qdepth of drive type, either
@@ -3536,7 +3522,7 @@ _scsih_set_volume_delete_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->raid_device_lock, flags);
-	raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+	raid_device = mpt3sas_raid_device_find_by_handle(ioc, handle);
 	if (raid_device && raid_device->starget &&
 	    raid_device->starget->hostdata) {
 		sas_target_priv_data =
@@ -3960,7 +3946,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 
 	raid_device = sas_target_priv_data->raid_device;
 	if (raid_device && raid_device->direct_io_enabled)
-		_scsih_setup_direct_io(ioc, scmd, raid_device, mpi_request,
+		mpt3sas_setup_direct_io(ioc, scmd, raid_device, mpi_request,
 		    smid);
 
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
@@ -4455,13 +4441,13 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	 * WARPDRIVE: If direct_io is set then it is directIO,
 	 * the failed direct I/O should be redirected to volume
 	 */
-	if (_scsih_scsi_direct_io_get(ioc, smid) &&
+	if (mpt3sas_scsi_direct_io_get(ioc, smid) &&
 	     ((ioc_status & MPI2_IOCSTATUS_MASK)
 	      != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
 		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 		ioc->scsi_lookup[smid - 1].scmd = scmd;
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
-		_scsih_scsi_direct_io_set(ioc, smid, 0);
+		mpt3sas_scsi_direct_io_set(ioc, smid, 0);
 		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 		mpi_request->DevHandle =
 		    cpu_to_le16(sas_device_priv_data->sas_target->handle);
@@ -6204,7 +6190,7 @@ _scsih_sas_volume_delete(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	struct scsi_target *starget = NULL;
 
 	spin_lock_irqsave(&ioc->raid_device_lock, flags);
-	raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+	raid_device = mpt3sas_raid_device_find_by_handle(ioc, handle);
 	if (raid_device) {
 		if (raid_device->starget) {
 			starget = raid_device->starget;
@@ -6582,7 +6568,7 @@ _scsih_sas_ir_volume_event(struct MPT3SAS_ADAPTER *ioc,
 	case MPI2_RAID_VOL_STATE_OPTIMAL:
 
 		spin_lock_irqsave(&ioc->raid_device_lock, flags);
-		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+		raid_device = mpt3sas_raid_device_find_by_handle(ioc, handle);
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 
 		if (raid_device)
@@ -6778,7 +6764,7 @@ _scsih_sas_ir_operation_status_event(struct MPT3SAS_ADAPTER *ioc,
 
 		spin_lock_irqsave(&ioc->raid_device_lock, flags);
 		handle = le16_to_cpu(event_data->VolDevHandle);
-		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+		raid_device = mpt3sas_raid_device_find_by_handle(ioc, handle);
 		if (raid_device)
 			raid_device->percent_complete =
 			    event_data->PercentComplete;
@@ -6965,7 +6951,7 @@ _scsih_mark_responding_raid_device(struct MPT3SAS_ADAPTER *ioc, u64 wwid,
 			 * across the host reset so re-initialize the
 			 * required data for Direct IO
 			 */
-			_scsih_init_warpdrive_properties(ioc, raid_device);
+			mpt3sas_init_warpdrive_properties(ioc, raid_device);
 			spin_lock_irqsave(&ioc->raid_device_lock, flags);
 			if (raid_device->handle == handle) {
 				spin_unlock_irqrestore(&ioc->raid_device_lock,
@@ -8599,7 +8585,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		else if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_HIDE_ALL_DISKS)
 			ioc->hide_drives = 1;
 		else {
-			if (_scsih_get_num_volumes(ioc))
+			if (mpt3sas_get_num_volumes(ioc))
 				ioc->hide_drives = 1;
 			else
 				ioc->hide_drives = 0;
@@ -9031,5 +9017,3 @@ _mpt3sas_exit(void)
 
 module_init(_mpt3sas_init);
 module_exit(_mpt3sas_exit);
-
-#include "mpt2sas_warpdrive.c"
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
new file mode 100644
index 0000000..540bd50
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -0,0 +1,344 @@
+/*
+ * Scsi Host Layer for MPT (Message Passing Technology) based controllers
+ *
+ * Copyright (C) 2012-2014  LSI Corporation
+ * Copyright (C) 2013-2015 Avago Technologies
+ *  (mailto: MPT-FusionLinux.pdl@avagotech.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * NO WARRANTY
+ * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+ * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+ * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+ * solely responsible for determining the appropriateness of using and
+ * distributing the Program and assumes all risks associated with its
+ * exercise of rights under this Agreement, including but not limited to
+ * the risks and costs of program errors, damage to or loss of data,
+ * programs or equipment, and unavailability or interruption of operations.
+
+ * DISCLAIMER OF LIABILITY
+ * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+ * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+ * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+ * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <asm/unaligned.h>
+
+#include "mpt3sas_base.h"
+
+/**
+ * _warpdrive_disable_ddio - Disable direct I/O for all the volumes
+ * @ioc: per adapter object
+ */
+static void
+_warpdrive_disable_ddio(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2RaidVolPage1_t vol_pg1;
+	Mpi2ConfigReply_t mpi_reply;
+	struct _raid_device *raid_device;
+	u16 handle;
+	u16 ioc_status;
+	unsigned long flags;
+
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
+	    &vol_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		handle = le16_to_cpu(vol_pg1.DevHandle);
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		raid_device = mpt3sas_raid_device_find_by_handle(ioc, handle);
+		if (raid_device)
+			raid_device->direct_io_enabled = 0;
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+	}
+	return;
+}
+
+
+/**
+ * mpt3sas_get_num_volumes - Get number of volumes in the ioc
+ * @ioc: per adapter object
+ */
+u8
+mpt3sas_get_num_volumes(struct MPT3SAS_ADAPTER *ioc)
+{
+	Mpi2RaidVolPage1_t vol_pg1;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 handle;
+	u8 vol_cnt = 0;
+	u16 ioc_status;
+
+	handle = 0xFFFF;
+	while (!(mpt3sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
+	    &vol_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
+		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+		    MPI2_IOCSTATUS_MASK;
+		if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+			break;
+		vol_cnt++;
+		handle = le16_to_cpu(vol_pg1.DevHandle);
+	}
+	return vol_cnt;
+}
+
+
+/**
+ * mpt3sas_init_warpdrive_properties - Set properties for warpdrive direct I/O.
+ * @ioc: per adapter object
+ * @raid_device: the raid_device object
+ */
+void
+mpt3sas_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
+	struct _raid_device *raid_device)
+{
+	Mpi2RaidVolPage0_t *vol_pg0;
+	Mpi2RaidPhysDiskPage0_t pd_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 sz;
+	u8 num_pds, count;
+	unsigned long stripe_sz, block_sz;
+	u8 stripe_exp, block_exp;
+	u64 dev_max_lba;
+
+	if (!ioc->is_warpdrive)
+		return;
+
+	if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS) {
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "globally as drives are exposed\n", ioc->name);
+		return;
+	}
+	if (mpt3sas_get_num_volumes(ioc) > 1) {
+		_warpdrive_disable_ddio(ioc);
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "globally as number of drives > 1\n", ioc->name);
+		return;
+	}
+	if ((mpt3sas_config_get_number_pds(ioc, raid_device->handle,
+	    &num_pds)) || !num_pds) {
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "Failure in computing number of drives\n", ioc->name);
+		return;
+	}
+
+	sz = offsetof(Mpi2RaidVolPage0_t, PhysDisk) + (num_pds *
+	    sizeof(Mpi2RaidVol0PhysDisk_t));
+	vol_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!vol_pg0) {
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "Memory allocation failure for RVPG0\n", ioc->name);
+		return;
+	}
+
+	if ((mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, vol_pg0,
+	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, raid_device->handle, sz))) {
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "Failure in retrieving RVPG0\n", ioc->name);
+		kfree(vol_pg0);
+		return;
+	}
+
+	/*
+	 * WARPDRIVE:If number of physical disks in a volume exceeds the max pds
+	 * assumed for WARPDRIVE, disable direct I/O
+	 */
+	if (num_pds > MPT_MAX_WARPDRIVE_PDS) {
+		pr_warn(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "for the drive with handle(0x%04x): num_mem=%d, "
+		    "max_mem_allowed=%d\n", ioc->name, raid_device->handle,
+		    num_pds, MPT_MAX_WARPDRIVE_PDS);
+		kfree(vol_pg0);
+		return;
+	}
+	for (count = 0; count < num_pds; count++) {
+		if (mpt3sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
+		    &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM,
+		    vol_pg0->PhysDisk[count].PhysDiskNum) ||
+		    pd_pg0.DevHandle == MPT3SAS_INVALID_DEVICE_HANDLE) {
+			pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is "
+			    "disabled for the drive with handle(0x%04x) member"
+			    "handle retrieval failed for member number=%d\n",
+			    ioc->name, raid_device->handle,
+			    vol_pg0->PhysDisk[count].PhysDiskNum);
+			goto out_error;
+		}
+		/* Disable direct I/O if member drive lba exceeds 4 bytes */
+		dev_max_lba = le64_to_cpu(pd_pg0.DeviceMaxLBA);
+		if (dev_max_lba >> 32) {
+			pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is "
+			    "disabled for the drive with handle(0x%04x) member"
+			    " handle (0x%04x) unsupported max lba 0x%016llx\n",
+			    ioc->name, raid_device->handle,
+			    le16_to_cpu(pd_pg0.DevHandle),
+			    (unsigned long long)dev_max_lba);
+			goto out_error;
+		}
+
+		raid_device->pd_handle[count] = le16_to_cpu(pd_pg0.DevHandle);
+	}
+
+	/*
+	 * Assumption for WD: Direct I/O is not supported if the volume is
+	 * not RAID0
+	 */
+	if (raid_device->volume_type != MPI2_RAID_VOL_TYPE_RAID0) {
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "for the drive with handle(0x%04x): type=%d, "
+		    "s_sz=%uK, blk_size=%u\n", ioc->name,
+		    raid_device->handle, raid_device->volume_type,
+		    (le32_to_cpu(vol_pg0->StripeSize) *
+		    le16_to_cpu(vol_pg0->BlockSize)) / 1024,
+		    le16_to_cpu(vol_pg0->BlockSize));
+		goto out_error;
+	}
+
+	stripe_sz = le32_to_cpu(vol_pg0->StripeSize);
+	stripe_exp = find_first_bit(&stripe_sz, 32);
+	if (stripe_exp == 32) {
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		"for the drive with handle(0x%04x) invalid stripe sz %uK\n",
+		    ioc->name, raid_device->handle,
+		    (le32_to_cpu(vol_pg0->StripeSize) *
+		    le16_to_cpu(vol_pg0->BlockSize)) / 1024);
+		goto out_error;
+	}
+	raid_device->stripe_exponent = stripe_exp;
+	block_sz = le16_to_cpu(vol_pg0->BlockSize);
+	block_exp = find_first_bit(&block_sz, 16);
+	if (block_exp == 16) {
+		pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is disabled "
+		    "for the drive with handle(0x%04x) invalid block sz %u\n",
+		    ioc->name, raid_device->handle,
+		    le16_to_cpu(vol_pg0->BlockSize));
+		goto out_error;
+	}
+	raid_device->block_exponent = block_exp;
+	raid_device->direct_io_enabled = 1;
+
+	pr_info(MPT3SAS_FMT "WarpDrive : Direct IO is Enabled for the drive"
+	    " with handle(0x%04x)\n", ioc->name, raid_device->handle);
+	/*
+	 * WARPDRIVE: Though the following fields are not used for direct IO,
+	 * stored for future purpose:
+	 */
+	raid_device->max_lba = le64_to_cpu(vol_pg0->MaxLBA);
+	raid_device->stripe_sz = le32_to_cpu(vol_pg0->StripeSize);
+	raid_device->block_sz = le16_to_cpu(vol_pg0->BlockSize);
+
+
+	kfree(vol_pg0);
+	return;
+
+out_error:
+	raid_device->direct_io_enabled = 0;
+	for (count = 0; count < num_pds; count++)
+		raid_device->pd_handle[count] = 0;
+	kfree(vol_pg0);
+	return;
+}
+
+/**
+ * mpt3sas_scsi_direct_io_get - returns direct io flag
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns the smid stored scmd pointer.
+ */
+inline u8
+mpt3sas_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return ioc->scsi_lookup[smid - 1].direct_io;
+}
+
+/**
+ * mpt3sas_scsi_direct_io_set - sets direct io flag
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @direct_io: Zero or non-zero value to set in the direct_io flag
+ *
+ * Returns Nothing.
+ */
+inline void
+mpt3sas_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io)
+{
+	ioc->scsi_lookup[smid - 1].direct_io = direct_io;
+}
+
+/**
+ * mpt3sas_setup_direct_io - setup MPI request for WARPDRIVE Direct I/O
+ * @ioc: per adapter object
+ * @scmd: pointer to scsi command object
+ * @raid_device: pointer to raid device data structure
+ * @mpi_request: pointer to the SCSI_IO reqest message frame
+ * @smid: system request message index
+ *
+ * Returns nothing
+ */
+void
+mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
+	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
+	u16 smid)
+{
+	sector_t v_lba, p_lba, stripe_off, column, io_size;
+	u32 stripe_sz, stripe_exp;
+	u8 num_pds, cmd = scmd->cmnd[0];
+
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
+	column = sector_div(p_lba, num_pds);
+	p_lba = (p_lba << stripe_exp) + stripe_off;
+	mpi_request->DevHandle = cpu_to_le16(raid_device->pd_handle[column]);
+
+	if (cmd == READ_10 || cmd == WRITE_10)
+		put_unaligned_be32(lower_32_bits(p_lba),
+				   &mpi_request->CDB.CDB32[2]);
+	else
+		put_unaligned_be64(p_lba, &mpi_request->CDB.CDB32[2]);
+
+	mpt3sas_scsi_direct_io_set(ioc, smid, 1);
+}
-- 
2.0.2
