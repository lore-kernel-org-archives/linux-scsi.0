From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 12/25] mpt3sas: Ported WarpDrive product SSS6200 support
Date: Wed, 11 Nov 2015 17:30:28 +0530
Message-ID: <1447243241-10912-13-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Ported below list of Warp drive specific patches
1. 'commit 0bdccdb0a090ad8dc5f851cad5e843244c410ee8
    ("mpt2sas: WarpDrive New product SSS6200 support added")',

2. 'commit 82a452581230b3ffc9d6475dffdb2568497b5fec
   ("mpt2sas: WarpDrive Infinite command retries due to wrong scsi command entry in MPI message")',

3. 'commit ba96bd0b1d4a4e11f23671e1f375a5c8f46b0fe7
   ("mpt2sas: Support for greater than 2TB capacity WarpDrive")',

4. 'commit 4da7af9494b2f98a1503a2634059300c3e4615e6
   ("mpt2sas: Do not retry a timed out direct IO for Warpdrive")',

5. 'commit daeaa9df92bd742f4e6d4d6039d689277a8e31bd
   ("mpt2sas: Avoid type casting for direct I/O commands")'.

Also set the mpt2_ioctl_iocinfo structure's adpter_type to
   MPT3_IOCTL_INTERFACE_SAS3 for Gen3 HBA's
   MPT2_IOCTL_INTERFACE_SAS2_SSS6200 for Warp Drive
   MPT2_IOCTL_INTERFACE_SAS2  for other Gen2 HBA's

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_warpdrive.c | 338 +++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c      |  68 ++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  39 ++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h       |   1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 260 ++++++++++++++++++++----
 6 files changed, 665 insertions(+), 46 deletions(-)
 create mode 100644 drivers/scsi/mpt2sas/mpt2sas_warpdrive.c

diff --git a/drivers/scsi/mpt2sas/mpt2sas_warpdrive.c b/drivers/scsi/mpt2sas/mpt2sas_warpdrive.c
new file mode 100644
index 0000000..c4fcbc2
--- /dev/null
+++ b/drivers/scsi/mpt2sas/mpt2sas_warpdrive.c
@@ -0,0 +1,338 @@
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
+
+/**
+ * _scsih_disable_ddio - Disable direct I/O for all the volumes
+ * @ioc: per adapter object
+ */
+static void
+_scsih_disable_ddio(struct MPT3SAS_ADAPTER *ioc)
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
+		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+		if (raid_device)
+			raid_device->direct_io_enabled = 0;
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+	}
+	return;
+}
+
+
+/**
+ * _scsih_get_num_volumes - Get number of volumes in the ioc
+ * @ioc: per adapter object
+ */
+static u8
+_scsih_get_num_volumes(struct MPT3SAS_ADAPTER *ioc)
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
+ * _scsih_init_warpdrive_properties - Set properties for warpdrive direct I/O.
+ * @ioc: per adapter object
+ * @raid_device: the raid_device object
+ */
+static void
+_scsih_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
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
+	if (_scsih_get_num_volumes(ioc) > 1) {
+		_scsih_disable_ddio(ioc);
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
+ * _scsih_scsi_direct_io_get - returns direct io flag
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns the smid stored scmd pointer.
+ */
+static inline u8
+_scsih_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return ioc->scsi_lookup[smid - 1].direct_io;
+}
+
+/**
+ * _scsih_scsi_direct_io_set - sets direct io flag
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @direct_io: Zero or non-zero value to set in the direct_io flag
+ *
+ * Returns Nothing.
+ */
+static inline void
+_scsih_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io)
+{
+	ioc->scsi_lookup[smid - 1].direct_io = direct_io;
+}
+
+/**
+ * _scsih_setup_direct_io - setup MPI request for WARPDRIVE Direct I/O
+ * @ioc: per adapter object
+ * @scmd: pointer to scsi command object
+ * @raid_device: pointer to raid device data structure
+ * @mpi_request: pointer to the SCSI_IO reqest message frame
+ * @smid: system request message index
+ *
+ * Returns nothing
+ */
+static void
+_scsih_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
+	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
+	u16 smid)
+{
+	sector_t v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
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
+}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b5b1eb2..f7f2ab5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -593,7 +593,8 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 		desc = "Device Status Change";
 		break;
 	case MPI2_EVENT_IR_OPERATION_STATUS:
-		desc = "IR Operation Status";
+		if (!ioc->hide_ir_msg)
+			desc = "IR Operation Status";
 		break;
 	case MPI2_EVENT_SAS_DISCOVERY:
 	{
@@ -624,16 +625,20 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 		desc = "SAS Enclosure Device Status Change";
 		break;
 	case MPI2_EVENT_IR_VOLUME:
-		desc = "IR Volume";
+		if (!ioc->hide_ir_msg)
+			desc = "IR Volume";
 		break;
 	case MPI2_EVENT_IR_PHYSICAL_DISK:
-		desc = "IR Physical Disk";
+		if (!ioc->hide_ir_msg)
+			desc = "IR Physical Disk";
 		break;
 	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
-		desc = "IR Configuration Change List";
+		if (!ioc->hide_ir_msg)
+			desc = "IR Configuration Change List";
 		break;
 	case MPI2_EVENT_LOG_ENTRY_ADDED:
-		desc = "Log Entry Added";
+		if (!ioc->hide_ir_msg)
+			desc = "Log Entry Added";
 		break;
 	case MPI2_EVENT_TEMP_THRESHOLD:
 		desc = "Temperature Threshold";
@@ -689,7 +694,10 @@ _base_sas_log_info(struct MPT3SAS_ADAPTER *ioc , u32 log_info)
 		originator_str = "PL";
 		break;
 	case 2:
-		originator_str = "IR";
+		if (!ioc->hide_ir_msg)
+			originator_str = "IR";
+		else
+			originator_str = "WarpDrive";
 		break;
 	}
 
@@ -1023,6 +1031,12 @@ _base_interrupt(int irq, void *bus_id)
 	}
 
 	wmb();
+	if (ioc->is_warpdrive) {
+		writel(reply_q->reply_post_host_index,
+		ioc->reply_post_host_index[msix_index]);
+		atomic_dec(&reply_q->busy);
+		return IRQ_HANDLED;
+	}
 
 	/* Update Reply Post Host Index.
 	 * For those HBA's which support combined reply queue feature
@@ -2333,6 +2347,7 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 		}
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
+		ioc->scsi_lookup[i].direct_io = 0;
 		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
@@ -2683,10 +2698,12 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	pr_info("), ");
 	pr_info("Capabilities=(");
 
-	if (ioc->facts.IOCCapabilities &
+	if (!ioc->hide_ir_msg) {
+		if (ioc->facts.IOCCapabilities &
 		    MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID) {
 			pr_info("Raid");
 			i++;
+		}
 	}
 
 	if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR) {
@@ -4834,6 +4851,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	u32 reply_address;
 	u16 smid;
 	struct _tr_list *delayed_tr, *delayed_tr_next;
+	u8 hide_flag;
 	struct adapter_reply_queue *reply_q;
 	long reply_post_free;
 	u32 reply_post_free_sz, index = 0;
@@ -4864,6 +4882,7 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].smid = smid;
 		ioc->scsi_lookup[i].scmd = NULL;
+		ioc->scsi_lookup[i].direct_io = 0;
 		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
 		    &ioc->free_list);
 	}
@@ -4966,6 +4985,16 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 
 
 	if (ioc->is_driver_loading) {
+
+		if (ioc->is_warpdrive && ioc->manu_pg10.OEMIdentifier
+		    == 0x80) {
+			hide_flag = (u8) (
+			    le32_to_cpu(ioc->manu_pg10.OEMSpecificFlags0) &
+			    MFG_PAGE10_HIDE_SSDS_MASK);
+			if (hide_flag != MFG_PAGE10_HIDE_SSDS_MASK)
+				ioc->mfg_pg10_hide_flag = hide_flag;
+		}
+
 		ioc->wait_for_discovery_to_complete =
 		    _base_determine_wait_on_discovery(ioc);
 
@@ -5032,12 +5061,33 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		goto out_free_resources;
 	}
 
+	if (ioc->is_warpdrive) {
+		ioc->reply_post_host_index = kcalloc(ioc->cpu_msix_table_sz,
+		    sizeof(resource_size_t *), GFP_KERNEL);
+		if (!ioc->reply_post_host_index) {
+			dfailprintk(ioc, pr_info(MPT3SAS_FMT "allocation "
+				"for cpu_msix_table failed!!!\n", ioc->name));
+			r = -ENOMEM;
+			goto out_free_resources;
+		}
+	}
+
 	ioc->rdpq_array_enable_assigned = 0;
 	ioc->dma_mask = 0;
 	r = mpt3sas_base_map_resources(ioc);
 	if (r)
 		goto out_free_resources;
 
+	if (ioc->is_warpdrive) {
+		ioc->reply_post_host_index[0] = (resource_size_t __iomem *)
+		    &ioc->chip->ReplyPostHostIndex;
+
+		for (i = 1; i < ioc->cpu_msix_table_sz; i++)
+			ioc->reply_post_host_index[i] =
+			(resource_size_t __iomem *)
+			((u8 __iomem *)&ioc->chip->Doorbell + (0x4000 + ((i - 1)
+			* 4)));
+	}
 
 	pci_set_drvdata(ioc->pdev, ioc->shost);
 	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
@@ -5189,6 +5239,8 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	_base_release_memory_pools(ioc);
 	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->cpu_msix_table);
+	if (ioc->is_warpdrive)
+		kfree(ioc->reply_post_host_index);
 	kfree(ioc->pd_handles);
 	kfree(ioc->blocking_handles);
 	kfree(ioc->tm_cmds.reply);
@@ -5228,6 +5280,8 @@ mpt3sas_base_detach(struct MPT3SAS_ADAPTER *ioc)
 	_base_release_memory_pools(ioc);
 	pci_set_drvdata(ioc->pdev, NULL);
 	kfree(ioc->cpu_msix_table);
+	if (ioc->is_warpdrive)
+		kfree(ioc->reply_post_host_index);
 	kfree(ioc->pd_handles);
 	kfree(ioc->blocking_handles);
 	kfree(ioc->pfacts);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a0d1f13..397f8a5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -135,6 +135,16 @@
 #define MPT3SAS_FMT			"%s: "
 
 /*
+ *  WarpDrive Specific Log codes
+ */
+
+#define MPT2_WARPDRIVE_LOGENTRY		(0x8002)
+#define MPT2_WARPDRIVE_LC_SSDT			(0x41)
+#define MPT2_WARPDRIVE_LC_SSDLW		(0x43)
+#define MPT2_WARPDRIVE_LC_SSDLF		(0x44)
+#define MPT2_WARPDRIVE_LC_BRMF			(0x4D)
+
+/*
  * per target private data
  */
 #define MPT_TARGET_FLAGS_RAID_COMPONENT	0x01
@@ -257,6 +267,7 @@ struct Mpi2ManufacturingPage11_t {
  * struct MPT3SAS_TARGET - starget private hostdata
  * @starget: starget object
  * @sas_address: target sas address
+ * @raid_device: raid_device pointer to access volume data
  * @handle: device handle
  * @num_luns: number luns
  * @flags: MPT_TARGET_FLAGS_XXX flags
@@ -266,6 +277,7 @@ struct Mpi2ManufacturingPage11_t {
 struct MPT3SAS_TARGET {
 	struct scsi_target *starget;
 	u64	sas_address;
+	struct _raid_device *raid_device;
 	u16	handle;
 	int	num_luns;
 	u32	flags;
@@ -280,6 +292,11 @@ struct MPT3SAS_TARGET {
 #define MPT_DEVICE_FLAGS_INIT		0x01
 #define MPT_DEVICE_TLR_ON		0x02
 
+#define MFG_PAGE10_HIDE_SSDS_MASK	(0x00000003)
+#define MFG_PAGE10_HIDE_ALL_DISKS	(0x00)
+#define MFG_PAGE10_EXPOSE_ALL_DISKS	(0x01)
+#define MFG_PAGE10_HIDE_IF_VOL_PRESENT	(0x02)
+
 /**
  * struct MPT3SAS_DEVICE - sdev private hostdata
  * @sas_target: starget private hostdata
@@ -381,6 +398,7 @@ struct _sas_device {
  * @sdev: scsi device struct (volumes are single lun)
  * @wwid: unique identifier for the volume
  * @handle: device handle
+ * @block_size: Block size of the volume
  * @id: target id
  * @channel: target channel
  * @volume_type: the raid level
@@ -388,6 +406,13 @@ struct _sas_device {
  * @num_pds: number of hidden raid components
  * @responding: used in _scsih_raid_device_mark_responding
  * @percent_complete: resync percent complete
+ * @direct_io_enabled: Whether direct io to PDs are allowed or not
+ * @stripe_exponent: X where 2powX is the stripe sz in blocks
+ * @block_exponent: X where 2powX is the block sz in bytes
+ * @max_lba: Maximum number of LBA in the volume
+ * @stripe_sz: Stripe Size of the volume
+ * @device_info: Device info of the volume member disk
+ * @pd_handle: Array of handles of the physical drives for direct I/O in le16
  */
 #define MPT_MAX_WARPDRIVE_PDS		8
 struct _raid_device {
@@ -396,13 +421,20 @@ struct _raid_device {
 	struct scsi_device *sdev;
 	u64	wwid;
 	u16	handle;
+	u16	block_sz;
 	int	id;
 	int	channel;
 	u8	volume_type;
 	u8	num_pds;
 	u8	responding;
 	u8	percent_complete;
+	u8	direct_io_enabled;
+	u8	stripe_exponent;
+	u8	block_exponent;
+	u64	max_lba;
+	u32	stripe_sz;
 	u32	device_info;
+	u16	pd_handle[MPT_MAX_WARPDRIVE_PDS];
 };
 
 /**
@@ -511,12 +543,14 @@ struct chain_tracker {
  * @smid: system message id
  * @scmd: scsi request pointer
  * @cb_idx: callback index
+ * @direct_io: To indicate whether I/O is direct (WARPDRIVE)
  * @tracker_list: list of free request (ioc->free_list)
  */
 struct scsiio_tracker {
 	u16	smid;
 	struct scsi_cmnd *scmd;
 	u8	cb_idx;
+	u8	direct_io;
 	struct list_head chain_list;
 	struct list_head tracker_list;
 };
@@ -843,6 +877,7 @@ struct MPT3SAS_ADAPTER {
 	u16		msix_vector_count;
 	u8		*cpu_msix_table;
 	u16		cpu_msix_table_sz;
+	resource_size_t __iomem **reply_post_host_index;
 	u32		ioc_reset_count;
 	MPT3SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 	u32             non_operational_loop;
@@ -1014,6 +1049,10 @@ struct MPT3SAS_ADAPTER {
 	u32		diagnostic_flags[MPI2_DIAG_BUF_TYPE_COUNT];
 	u32		ring_buffer_offset;
 	u32		ring_buffer_sz;
+	u8		is_warpdrive;
+	u8		hide_ir_msg;
+	u8		mfg_pg10_hide_flag;
+	u8		hide_drives;
 	spinlock_t	diag_trigger_lock;
 	u8		diag_trigger_active;
 	struct SL_WH_MASTER_TRIGGER_T diag_trigger_master;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 5c08d31..3f22754 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1030,7 +1030,10 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	strcat(karg.driver_version, "-");
 	switch  (ioc->hba_mpi_version_belonged) {
 	case MPI2_VERSION:
-		karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
+		if (ioc->is_warpdrive)
+			karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2_SSS6200;
+		else
+			karg.adapter_type = MPT2_IOCTL_INTERFACE_SAS2;
 		strcat(karg.driver_version, MPT2SAS_DRIVER_VERSION);
 		break;
 	case MPI25_VERSION:
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index f43e3c2..8940835 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -141,6 +141,7 @@ struct mpt3_ioctl_pci_info {
 #define MPT2_IOCTL_INTERFACE_FC_IP	(0x02)
 #define MPT2_IOCTL_INTERFACE_SAS	(0x03)
 #define MPT2_IOCTL_INTERFACE_SAS2	(0x04)
+#define MPT2_IOCTL_INTERFACE_SAS2_SSS6200	(0x05)
 #define MPT3_IOCTL_INTERFACE_SAS3	(0x06)
 #define MPT2_IOCTL_VERSION_LENGTH	(32)
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2b51a41..dc6b0ba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -54,6 +54,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/raid_class.h>
+#include <asm/unaligned.h>
 
 #include "mpt3sas_base.h"
 
@@ -70,6 +71,21 @@ static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 
 static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 
+#ifdef SCSI_MPT2SAS
+static void _scsih_disable_ddio(struct MPT3SAS_ADAPTER *ioc);
+static u8 _scsih_get_num_volumes(struct MPT3SAS_ADAPTER *ioc);
+static void
+_scsih_init_warpdrive_properties(struct MPT3SAS_ADAPTER *ioc,
+	struct _raid_device *raid_device);
+static inline u8
+_scsih_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid);
+static inline void
+_scsih_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 direct_io);
+static void
+_scsih_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
+	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
+	u16 smid);
+#endif
 
 /* global parameters */
 LIST_HEAD(mpt3sas_ioc_list);
@@ -1144,7 +1160,9 @@ scsih_target_alloc(struct scsi_target *starget)
 			sas_target_priv_data->handle = raid_device->handle;
 			sas_target_priv_data->sas_address = raid_device->wwid;
 			sas_target_priv_data->flags |= MPT_TARGET_FLAGS_VOLUME;
-			raid_device->starget = starget;
+			sas_target_priv_data->raid_device = raid_device;
+			if (ioc->is_warpdrive)
+				raid_device->starget = starget;
 		}
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 		return 0;
@@ -1386,7 +1404,10 @@ int
 scsih_is_raid(struct device *dev)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
 
+	if (ioc->is_warpdrive)
+		return 0;
 	return (sdev->channel == RAID_CHANNEL) ? 1 : 0;
 }
 
@@ -1409,6 +1430,9 @@ scsih_get_resync(struct device *dev)
 
 	percent_complete = 0;
 	handle = 0;
+	if (ioc->is_warpdrive)
+		goto out;
+
 	spin_lock_irqsave(&ioc->raid_device_lock, flags);
 	raid_device = _scsih_raid_device_find_by_id(ioc, sdev->id,
 	    sdev->channel);
@@ -1592,8 +1616,6 @@ _scsih_get_volume_capabilities(struct MPT3SAS_ADAPTER *ioc,
 	return 0;
 }
 
-
-
 /**
  * _scsih_enable_tlr - setting TLR flags
  * @ioc: per adapter object
@@ -1672,6 +1694,12 @@ scsih_slave_configure(struct scsi_device *sdev)
 			return 1;
 		}
 
+#ifdef SCSI_MPT2SAS
+		/*
+		 * WARPDRIVE: Initialize the required data for Direct IO
+		 */
+		_scsih_init_warpdrive_properties(ioc, raid_device);
+#endif
 
 		/* RAID Queue Depth Support
 		 * IS volume = underlying qdepth of drive type, either
@@ -1720,17 +1748,19 @@ scsih_slave_configure(struct scsi_device *sdev)
 			break;
 		}
 
-		sdev_printk(KERN_INFO, sdev,
-			"%s: handle(0x%04x), wwid(0x%016llx), pd_count(%d), type(%s)\n",
-			 r_level, raid_device->handle,
-			 (unsigned long long)raid_device->wwid,
-			 raid_device->num_pds, ds);
-
+		if (!ioc->hide_ir_msg)
+			sdev_printk(KERN_INFO, sdev,
+			   "%s: handle(0x%04x), wwid(0x%016llx),"
+			    " pd_count(%d), type(%s)\n",
+			    r_level, raid_device->handle,
+			    (unsigned long long)raid_device->wwid,
+			    raid_device->num_pds, ds);
 
 		scsih_change_queue_depth(sdev, qdepth);
 
-/* raid transport support */
-		_scsih_set_level(sdev, raid_device->volume_type);
+		/* raid transport support */
+		if (!ioc->is_warpdrive)
+			_scsih_set_level(sdev, raid_device->volume_type);
 		return 0;
 	}
 
@@ -2179,7 +2209,10 @@ _scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
 
 	if (!priv_target)
 		return;
-	device_str = "volume";
+	if (ioc->hide_ir_msg)
+		device_str = "WarpDrive";
+	else
+		device_str = "volume";
 
 	scsi_print_command(scmd);
 	if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
@@ -3368,6 +3401,9 @@ _scsih_check_ir_config_unhide_events(struct MPT3SAS_ADAPTER *ioc,
 	a = 0;
 	b = 0;
 
+	if (ioc->is_warpdrive)
+		return;
+
 	/* Volume Resets for Deleted or Removed */
 	element = (Mpi2EventIrConfigElement_t *)&event_data->ConfigElement[0];
 	for (i = 0; i < event_data->NumElements; i++, element++) {
@@ -3604,6 +3640,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 }
 
 
+
 /**
  * scsih_qcmd - main scsi request entry point
  * @scmd: pointer to scsi command object
@@ -3621,6 +3658,9 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
+#ifdef SCSI_MPT2SAS
+	struct _raid_device *raid_device;
+#endif
 	Mpi2SCSIIORequest_t *mpi_request;
 	u32 mpi_control;
 	u16 smid;
@@ -3677,7 +3717,11 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	/* set tags */
 	mpi_control |= MPI2_SCSIIO_CONTROL_SIMPLEQ;
 
-	if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
+	/* Make sure Device is not raid volume.
+	 * We do not expose raid functionality to upper layer for warpdrive.
+	 */
+	if (!ioc->is_warpdrive && !scsih_is_raid(&scmd->device->sdev_gendev)
+	    && (sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
 	    scmd->cmd_len != 32)
 		mpi_control |= MPI2_SCSIIO_CONTROL_TLR_ON;
 
@@ -3720,6 +3764,13 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	} else
 		ioc->build_zero_len_sge(ioc, &mpi_request->SGL);
 
+#ifdef SCSI_MPT2SAS
+	raid_device = sas_target_priv_data->raid_device;
+	if (raid_device && raid_device->direct_io_enabled)
+		_scsih_setup_direct_io(ioc, scmd, raid_device, mpi_request,
+		    smid);
+#endif
+
 	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)) {
 #ifndef SCSI_MPT2SAS
 		if (sas_target_priv_data->flags & MPT_TARGET_FASTPATH_IO) {
@@ -3728,7 +3779,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 			mpt3sas_base_put_smid_fast_path(ioc, smid, handle);
 		} else
 #endif
-			mpt3sas_base_put_smid_scsi_io(ioc, smid, handle);
+			mpt3sas_base_put_smid_scsi_io(ioc, smid,
+			    le16_to_cpu(mpi_request->DevHandle));
 	} else
 		mpt3sas_base_put_smid_default(ioc, smid);
 	return 0;
@@ -3794,7 +3846,10 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 
 	if (!priv_target)
 		return;
-	device_str = "volume";
+	if (ioc->hide_ir_msg)
+		device_str = "WarpDrive";
+	else
+		device_str = "volume";
 
 	if (log_info == 0x31170000)
 		return;
@@ -4175,6 +4230,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u32 log_info;
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
+#ifdef SCSI_MPT2SAS
+	unsigned long flags;
+#endif
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
@@ -4196,6 +4254,26 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	}
 	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
 
+#ifdef SCSI_MPT2SAS
+	/*
+	 * WARPDRIVE: If direct_io is set then it is directIO,
+	 * the failed direct I/O should be redirected to volume
+	 */
+	if (_scsih_scsi_direct_io_get(ioc, smid) &&
+	     ((ioc_status & MPI2_IOCSTATUS_MASK)
+	      != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+		ioc->scsi_lookup[smid - 1].scmd = scmd;
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+		_scsih_scsi_direct_io_set(ioc, smid, 0);
+		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
+		mpi_request->DevHandle =
+		    cpu_to_le16(sas_device_priv_data->sas_target->handle);
+		mpt3sas_base_put_smid_scsi_io(ioc, smid,
+		    sas_device_priv_data->sas_target->handle);
+		return 0;
+	}
+#endif
 	/* turning off TLR */
 	scsi_state = mpi_reply->SCSIState;
 	if (scsi_state & MPI2_SCSI_STATE_RESPONSE_INFO_VALID)
@@ -4203,7 +4281,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		    le32_to_cpu(mpi_reply->ResponseInfo) & 0xFF;
 	if (!sas_device_priv_data->tlr_snoop_check) {
 		sas_device_priv_data->tlr_snoop_check++;
-		if ((sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
+		if (!ioc->is_warpdrive &&
+		    !scsih_is_raid(&scmd->device->sdev_gendev) &&
+		    (sas_device_priv_data->flags & MPT_DEVICE_TLR_ON) &&
 		    response_code == MPI2_SCSITASKMGMT_RSP_INVALID_FRAME)
 			sas_device_priv_data->flags &=
 			    ~MPT_DEVICE_TLR_ON;
@@ -5110,7 +5190,9 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 		sas_target_priv_data->handle =
 		     MPT3SAS_INVALID_DEVICE_HANDLE;
 	}
-	mpt3sas_transport_port_remove(ioc,
+
+	if (!ioc->hide_drives)
+		mpt3sas_transport_port_remove(ioc,
 		    sas_device->sas_address,
 		    sas_device->sas_address_parent);
 
@@ -6208,7 +6290,8 @@ _scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
 		(Mpi2EventDataIrConfigChangeList_t *)
 		fw_event->event_data;
 
-	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
+	if ((ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) &&
+	     (!ioc->hide_ir_msg))
 		_scsih_sas_ir_config_change_event_debug(ioc, event_data);
 
 	foreign_config = (le32_to_cpu(event_data->Flags) &
@@ -6226,6 +6309,7 @@ _scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
 #endif
 		return;
 	}
+
 	for (i = 0; i < event_data->NumElements; i++, element++) {
 
 		switch (element->ReasonCode) {
@@ -6241,16 +6325,20 @@ _scsih_sas_ir_config_change_event(struct MPT3SAS_ADAPTER *ioc,
 				    le16_to_cpu(element->VolDevHandle));
 			break;
 		case MPI2_EVENT_IR_CHANGE_RC_PD_CREATED:
-			_scsih_sas_pd_hide(ioc, element);
+			if (!ioc->is_warpdrive)
+				_scsih_sas_pd_hide(ioc, element);
 			break;
 		case MPI2_EVENT_IR_CHANGE_RC_PD_DELETED:
-			_scsih_sas_pd_expose(ioc, element);
+			if (!ioc->is_warpdrive)
+				_scsih_sas_pd_expose(ioc, element);
 			break;
 		case MPI2_EVENT_IR_CHANGE_RC_HIDE:
-			_scsih_sas_pd_add(ioc, element);
+			if (!ioc->is_warpdrive)
+				_scsih_sas_pd_add(ioc, element);
 			break;
 		case MPI2_EVENT_IR_CHANGE_RC_UNHIDE:
-			_scsih_sas_pd_delete(ioc, element);
+			if (!ioc->is_warpdrive)
+				_scsih_sas_pd_delete(ioc, element);
 			break;
 		}
 	}
@@ -6285,10 +6373,11 @@ _scsih_sas_ir_volume_event(struct MPT3SAS_ADAPTER *ioc,
 
 	handle = le16_to_cpu(event_data->VolDevHandle);
 	state = le32_to_cpu(event_data->NewValue);
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
-		ioc->name, __func__,  handle,
-	    le32_to_cpu(event_data->PreviousValue), state));
+	if (!ioc->hide_ir_msg)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
+		    ioc->name, __func__,  handle,
+		    le32_to_cpu(event_data->PreviousValue), state));
 	switch (state) {
 	case MPI2_RAID_VOL_STATE_MISSING:
 	case MPI2_RAID_VOL_STATE_FAILED:
@@ -6371,10 +6460,12 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 	handle = le16_to_cpu(event_data->PhysDiskDevHandle);
 	state = le32_to_cpu(event_data->NewValue);
 
-	dewtprintk(ioc, pr_info(MPT3SAS_FMT
-		"%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
-		ioc->name, __func__,  handle,
+	if (!ioc->hide_ir_msg)
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: handle(0x%04x), old(0x%08x), new(0x%08x)\n",
+		    ioc->name, __func__,  handle,
 		    le32_to_cpu(event_data->PreviousValue), state));
+
 	switch (state) {
 	case MPI2_RAID_PD_STATE_ONLINE:
 	case MPI2_RAID_PD_STATE_DEGRADED:
@@ -6382,7 +6473,8 @@ _scsih_sas_ir_physical_disk_event(struct MPT3SAS_ADAPTER *ioc,
 	case MPI2_RAID_PD_STATE_OPTIMAL:
 	case MPI2_RAID_PD_STATE_HOT_SPARE:
 
-		set_bit(handle, ioc->pd_handles);
+		if (!ioc->is_warpdrive)
+			set_bit(handle, ioc->pd_handles);
 		spin_lock_irqsave(&ioc->sas_device_lock, flags);
 		sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -6484,7 +6576,8 @@ _scsih_sas_ir_operation_status_event(struct MPT3SAS_ADAPTER *ioc,
 	unsigned long flags;
 	u16 handle;
 
-	if (ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK)
+	if ((ioc->logging_level & MPT_DEBUG_EVENT_WORK_TASK) &&
+	    (!ioc->hide_ir_msg))
 		_scsih_sas_ir_operation_status_event_debug(ioc,
 		     event_data);
 
@@ -6655,7 +6748,7 @@ static void
 _scsih_mark_responding_raid_device(struct MPT3SAS_ADAPTER *ioc, u64 wwid,
 	u16 handle)
 {
-	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct MPT3SAS_TARGET *sas_target_priv_data = NULL;
 	struct scsi_target *starget;
 	struct _raid_device *raid_device;
 	unsigned long flags;
@@ -6674,6 +6767,15 @@ _scsih_mark_responding_raid_device(struct MPT3SAS_ADAPTER *ioc, u64 wwid,
 			starget_printk(KERN_INFO, raid_device->starget,
 			    "handle(0x%04x), wwid(0x%016llx)\n", handle,
 			    (unsigned long long)raid_device->wwid);
+
+#ifdef SCSI_MPT2SAS
+			/*
+			 * WARPDRIVE: The handles of the PDs might have changed
+			 * across the host reset so re-initialize the
+			 * required data for Direct IO
+			 */
+			_scsih_init_warpdrive_properties(ioc, raid_device);
+#endif
 			spin_lock_irqsave(&ioc->raid_device_lock, flags);
 			if (raid_device->handle == handle) {
 				spin_unlock_irqrestore(&ioc->raid_device_lock,
@@ -6743,6 +6845,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	/* refresh the pd_handles */
+	if (!ioc->is_warpdrive) {
 		phys_disk_num = 0xFF;
 		memset(ioc->pd_handles, 0, ioc->pd_handles_sz);
 		while (!(mpt3sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
@@ -6756,6 +6859,7 @@ _scsih_search_responding_raid_devices(struct MPT3SAS_ADAPTER *ioc)
 			handle = le16_to_cpu(pd_pg0.DevHandle);
 			set_bit(handle, ioc->pd_handles);
 		}
+	}
  out:
 	pr_info(MPT3SAS_FMT "search for responding raid volumes: complete\n",
 		ioc->name);
@@ -7405,7 +7509,53 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		    (Mpi2EventDataIrVolume_t *)
 		    mpi_reply->EventData);
 		break;
+	case MPI2_EVENT_LOG_ENTRY_ADDED:
+	{
+		Mpi2EventDataLogEntryAdded_t *log_entry;
+		u32 *log_code;
+
+		if (!ioc->is_warpdrive)
+			break;
+
+		log_entry = (Mpi2EventDataLogEntryAdded_t *)
+		    mpi_reply->EventData;
+		log_code = (u32 *)log_entry->LogData;
 
+		if (le16_to_cpu(log_entry->LogEntryQualifier)
+		    != MPT2_WARPDRIVE_LOGENTRY)
+			break;
+
+		switch (le32_to_cpu(*log_code)) {
+		case MPT2_WARPDRIVE_LC_SSDT:
+			pr_warn(MPT3SAS_FMT "WarpDrive Warning: "
+			    "IO Throttling has occurred in the WarpDrive "
+			    "subsystem. Check WarpDrive documentation for "
+			    "additional details.\n", ioc->name);
+			break;
+		case MPT2_WARPDRIVE_LC_SSDLW:
+			pr_warn(MPT3SAS_FMT "WarpDrive Warning: "
+			    "Program/Erase Cycles for the WarpDrive subsystem "
+			    "in degraded range. Check WarpDrive documentation "
+			    "for additional details.\n", ioc->name);
+			break;
+		case MPT2_WARPDRIVE_LC_SSDLF:
+			pr_err(MPT3SAS_FMT "WarpDrive Fatal Error: "
+			    "There are no Program/Erase Cycles for the "
+			    "WarpDrive subsystem. The storage device will be "
+			    "in read-only mode. Check WarpDrive documentation "
+			    "for additional details.\n", ioc->name);
+			break;
+		case MPT2_WARPDRIVE_LC_BRMF:
+			pr_err(MPT3SAS_FMT "WarpDrive Fatal Error: "
+			    "The Backup Rail Monitor has failed on the "
+			    "WarpDrive subsystem. Check WarpDrive "
+			    "documentation for additional details.\n",
+			    ioc->name);
+			break;
+		}
+
+		break;
+	}
 	case MPI2_EVENT_SAS_DEVICE_STATUS_CHANGE:
 	case MPI2_EVENT_IR_OPERATION_STATUS:
 	case MPI2_EVENT_SAS_DISCOVERY:
@@ -7535,7 +7685,8 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request->Function = MPI2_FUNCTION_RAID_ACTION;
 	mpi_request->Action = MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED;
 
-	pr_info(MPT3SAS_FMT "IR shutdown (sending)\n", ioc->name);
+	if (!ioc->hide_ir_msg)
+		pr_info(MPT3SAS_FMT "IR shutdown (sending)\n", ioc->name);
 	init_completion(&ioc->scsih_cmds.done);
 	mpt3sas_base_put_smid_default(ioc, smid);
 	wait_for_completion_timeout(&ioc->scsih_cmds.done, 10*HZ);
@@ -7548,10 +7699,11 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
 
 	if (ioc->scsih_cmds.status & MPT3_CMD_REPLY_VALID) {
 		mpi_reply = ioc->scsih_cmds.reply;
-		pr_info(MPT3SAS_FMT
-			"IR shutdown (complete): ioc_status(0x%04x), loginfo(0x%08x)\n",
-		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
-		    le32_to_cpu(mpi_reply->IOCLogInfo));
+		if (!ioc->hide_ir_msg)
+			pr_info(MPT3SAS_FMT "IR shutdown "
+			   "(complete): ioc_status(0x%04x), loginfo(0x%08x)\n",
+			    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
+			    le32_to_cpu(mpi_reply->IOCLogInfo));
 	}
 
  out:
@@ -7716,6 +7868,8 @@ _scsih_probe_boot_devices(struct MPT3SAS_ADAPTER *ioc)
 		list_move_tail(&sas_device->list, &ioc->sas_device_list);
 		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
+		if (ioc->hide_drives)
+			return;
 		if (!mpt3sas_transport_port_add(ioc, handle,
 		    sas_address_parent)) {
 			_scsih_sas_device_remove(ioc, sas_device);
@@ -7769,6 +7923,9 @@ _scsih_probe_sas(struct MPT3SAS_ADAPTER *ioc)
 	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
 	    list) {
 
+		if (ioc->hide_drives)
+			return;
+
 		if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
 		    sas_device->sas_address_parent)) {
 			list_del(&sas_device->list);
@@ -7913,6 +8070,9 @@ void
 _scsih_determine_hba_mpi_version(struct MPT3SAS_ADAPTER *ioc) {
 
 	switch (ioc->pdev->device) {
+	case MPI2_MFGPAGE_DEVID_SSS6200:
+		ioc->is_warpdrive = 1;
+		ioc->hide_ir_msg = 1;
 	case MPI2_MFGPAGE_DEVID_SAS2004:
 	case MPI2_MFGPAGE_DEVID_SAS2008:
 	case MPI2_MFGPAGE_DEVID_SAS2108_1:
@@ -7947,6 +8107,10 @@ _scsih_determine_hba_mpi_version(struct MPT3SAS_ADAPTER *ioc) {
 			ioc->msix96_vector = 1;
 		break;
 	}
+
+	if ((ioc->pdev->device != MPI2_MFGPAGE_DEVID_SSS6200) &&
+	    (ioc->hba_mpi_version_belonged == MPI2_VERSION))
+		ioc->mfg_pg10_hide_flag = MFG_PAGE10_EXPOSE_ALL_DISKS;
 }
 
 /**
@@ -7969,7 +8133,6 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 	list_add_tail(&ioc->list, &mpt3sas_ioc_list);
 	ioc->shost = shost;
 	ioc->id = mpt_ids++;
-
 	ioc->pdev = pdev;
 	ioc->scsi_io_cb_idx = scsi_io_cb_idx;
 	ioc->tm_cb_idx = tm_cb_idx;
@@ -8062,6 +8225,23 @@ scsih_probe(struct pci_dev *pdev, struct Scsi_Host *shost)
 		rv = -ENODEV;
 		goto out_attach_fail;
 	}
+
+#ifdef SCSI_MPT2SAS
+	if (ioc->is_warpdrive) {
+		if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS)
+			ioc->hide_drives = 0;
+		else if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_HIDE_ALL_DISKS)
+			ioc->hide_drives = 1;
+		else {
+			if (_scsih_get_num_volumes(ioc))
+				ioc->hide_drives = 1;
+			else
+				ioc->hide_drives = 0;
+		}
+	} else
+		ioc->hide_drives = 0;
+#endif
+
 	rv = scsi_add_host(shost, &pdev->dev);
 	if (rv) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
@@ -8334,3 +8514,7 @@ scsih_exit(void)
 	raid_class_release(mpt3sas_raid_template);
 	sas_release_transport(mpt3sas_transport_template);
 }
+
+#ifdef SCSI_MPT2SAS
+#include "../mpt2sas/mpt2sas_warpdrive.c"
+#endif
-- 
2.0.2
