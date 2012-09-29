From: <sreekanth.reddy@lsi.com>
Subject: [RESEND][PATCH 14/20][SCSI] mpt3sas: Code related to Scsi Host Layer
 for MPT based controllers. This patch is part 1 of mpt3sas_scsih.c
Date: Sat, 29 Sep 2012 19:50:50 +0530
Message-ID: <20120929142050.GA20829@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:42576 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab2I2Udj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2012 16:33:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com
Cc: Sathya.Prakash@lsi.com

This patch contains code related to Scsi Host Layer for
MPT (Message Passing Technology) based controllers
This patch is part 1 of mpt3sas_scsih.c


Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Reviewed-by: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
new file mode 100644
index 0000000..26781ea
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -0,0 +1,2770 @@
+/*
+ * Scsi Host Layer for MPT (Message Passing Technology) based controllers
+ *
+ * This code is based on drivers/scsi/mpt3sas/mpt3sas_scsih.c
+ * Copyright (C) 2012  LSI Corporation
+ *  (mailto:DL-MPTFusionLinux@lsi.com)
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
+ * USA.
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/blkdev.h>
+#include <linux/sched.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/aer.h>
+#include <linux/raid_class.h>
+
+#include "mpt3sas_base.h"
+
+MODULE_AUTHOR(MPT3SAS_AUTHOR);
+MODULE_DESCRIPTION(MPT3SAS_DESCRIPTION);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(MPT3SAS_DRIVER_VERSION);
+
+#define RAID_CHANNEL 1
+/* forward proto's */
+static void _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_node *sas_expander);
+static void _firmware_event_work(struct work_struct *work);
+
+static void _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_device *sas_device);
+static int _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16 handle,
+	u8 retry_count, u8 is_pd);
+
+static u8 _scsih_check_for_pending_tm(struct MPT3SAS_ADAPTER *ioc, u16 smid);
+
+static void _scsih_scan_start(struct Scsi_Host *shost);
+static int _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
+
+/* global parameters */
+LIST_HEAD(mpt3sas_ioc_list);
+
+/* local parameters */
+static u8 scsi_io_cb_idx = -1;
+static u8 tm_cb_idx = -1;
+static u8 ctl_cb_idx = -1;
+static u8 base_cb_idx = -1;
+static u8 port_enable_cb_idx = -1;
+static u8 transport_cb_idx = -1;
+static u8 scsih_cb_idx = -1;
+static u8 config_cb_idx = -1;
+static int mpt_ids;
+
+static u8 tm_tr_cb_idx = -1 ;
+static u8 tm_tr_volume_cb_idx = -1 ;
+static u8 tm_sas_control_cb_idx = -1;
+
+/* command line options */
+static u32 logging_level;
+MODULE_PARM_DESC(logging_level,
+	" bits for enabling additional logging info (default=0)");
+
+
+static ushort max_sectors = 0xFFFF;
+module_param(max_sectors, ushort, 0);
+MODULE_PARM_DESC(max_sectors, "max sectors, range 64 to 32767  default=32767");
+
+
+static int missing_delay[2] = {-1, -1};
+module_param_array(missing_delay, int, NULL, 0);
+MODULE_PARM_DESC(missing_delay, " device missing delay , io missing delay");
+
+/* scsi-mid layer global parmeter is max_report_luns, which is 511 */
+#define MPT3SAS_MAX_LUN (16895)
+static int max_lun = MPT3SAS_MAX_LUN;
+module_param(max_lun, int, 0);
+MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
+
+
+
+
+/* diag_buffer_enable is bitwise
+ * bit 0 set = TRACE
+ * bit 1 set = SNAPSHOT
+ * bit 2 set = EXTENDED
+ *
+ * Either bit can be set, or both
+ */
+static int diag_buffer_enable = -1;
+module_param(diag_buffer_enable, int, 0);
+MODULE_PARM_DESC(diag_buffer_enable,
+	" post diag buffers (TRACE=1/SNAPSHOT=2/EXTENDED=4/default=0)");
+static int disable_discovery = -1;
+module_param(disable_discovery, int, 0);
+MODULE_PARM_DESC(disable_discovery, " disable discovery ");
+
+
+/* permit overriding the host protection capabilities mask (EEDP/T10 PI) */
+static int prot_mask = -1;
+module_param(prot_mask, int, 0);
+MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
+
+
+/* raid transport support */
+
+static struct raid_template *mpt3sas_raid_template;
+
+
+/**
+ * struct sense_info - common structure for obtaining sense keys
+ * @skey: sense key
+ * @asc: additional sense code
+ * @ascq: additional sense code qualifier
+ */
+struct sense_info {
+	u8 skey;
+	u8 asc;
+	u8 ascq;
+};
+
+#define MPT3SAS_PROCESS_TRIGGER_DIAG (0xFFFB)
+#define MPT3SAS_TURN_ON_FAULT_LED (0xFFFC)
+#define MPT3SAS_PORT_ENABLE_COMPLETE (0xFFFD)
+#define MPT3SAS_ABRT_TASK_SET (0xFFFE)
+#define MPT3SAS_REMOVE_UNRESPONDING_DEVICES (0xFFFF)
+/**
+ * struct fw_event_work - firmware event struct
+ * @list: link list framework
+ * @work: work object (ioc->fault_reset_work_q)
+ * @cancel_pending_work: flag set during reset handling
+ * @ioc: per adapter object
+ * @device_handle: device handle
+ * @VF_ID: virtual function id
+ * @VP_ID: virtual port id
+ * @ignore: flag meaning this event has been marked to ignore
+ * @event: firmware event MPI2_EVENT_XXX defined in mpt2_ioc.h
+ * @event_data: reply event data payload follows
+ *
+ * This object stored on ioc->fw_event_list.
+ */
+struct fw_event_work {
+	struct list_head	list;
+	struct work_struct	work;
+	u8			cancel_pending_work;
+	struct delayed_work	delayed_work;
+
+	struct MPT3SAS_ADAPTER *ioc;
+	u16			device_handle;
+	u8			VF_ID;
+	u8			VP_ID;
+	u8			ignore;
+	u16			event;
+	void			*event_data;
+};
+
+/* raid transport support */
+static struct raid_template *mpt3sas_raid_template;
+
+/**
+ * struct _scsi_io_transfer - scsi io transfer
+ * @handle: sas device handle (assigned by firmware)
+ * @is_raid: flag set for hidden raid components
+ * @dir: DMA_TO_DEVICE, DMA_FROM_DEVICE,
+ * @data_length: data transfer length
+ * @data_dma: dma pointer to data
+ * @sense: sense data
+ * @lun: lun number
+ * @cdb_length: cdb length
+ * @cdb: cdb contents
+ * @timeout: timeout for this command
+ * @VF_ID: virtual function id
+ * @VP_ID: virtual port id
+ * @valid_reply: flag set for reply message
+ * @sense_length: sense length
+ * @ioc_status: ioc status
+ * @scsi_state: scsi state
+ * @scsi_status: scsi staus
+ * @log_info: log information
+ * @transfer_length: data length transfer when there is a reply message
+ *
+ * Used for sending internal scsi commands to devices within this module.
+ * Refer to _scsi_send_scsi_io().
+ */
+struct _scsi_io_transfer {
+	u16	handle;
+	u8	is_raid;
+	enum dma_data_direction dir;
+	u32	data_length;
+	dma_addr_t data_dma;
+	u8	sense[SCSI_SENSE_BUFFERSIZE];
+	u32	lun;
+	u8	cdb_length;
+	u8	cdb[32];
+	u8	timeout;
+	u8	VF_ID;
+	u8	VP_ID;
+	u8	valid_reply;
+  /* the following bits are only valid when 'valid_reply = 1' */
+	u32	sense_length;
+	u16	ioc_status;
+	u8	scsi_state;
+	u8	scsi_status;
+	u32	log_info;
+	u32	transfer_length;
+};
+
+/*
+ * The pci device ids are defined in mpi/mpi2_cnfg.h.
+ */
+static DEFINE_PCI_DEVICE_TABLE(scsih_pci_table) = {
+	/* Fury ~ 3004 and 3008 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3004,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3008,
+		PCI_ANY_ID, PCI_ANY_ID },
+	/* Invader ~ 3108 */
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_1,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_2,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_5,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI25_MFGPAGE_DEVID_SAS3108_6,
+		PCI_ANY_ID, PCI_ANY_ID },
+	{0}	/* Terminating entry */
+};
+MODULE_DEVICE_TABLE(pci, scsih_pci_table);
+
+/**
+ * _scsih_set_debug_level - global setting of ioc->logging_level.
+ *
+ * Note: The logging levels are defined in mpt3sas_debug.h.
+ */
+static int
+_scsih_set_debug_level(const char *val, struct kernel_param *kp)
+{
+	int ret = param_set_int(val, kp);
+	struct MPT3SAS_ADAPTER *ioc;
+
+	if (ret)
+		return ret;
+
+	pr_info("setting logging_level(0x%08x)\n", logging_level);
+	list_for_each_entry(ioc, &mpt3sas_ioc_list, list)
+		ioc->logging_level = logging_level;
+	return 0;
+}
+module_param_call(logging_level, _scsih_set_debug_level, param_get_int,
+	&logging_level, 0644);
+
+/**
+ * _scsih_srch_boot_sas_address - search based on sas_address
+ * @sas_address: sas address
+ * @boot_device: boot device object from bios page 2
+ *
+ * Returns 1 when there's a match, 0 means no match.
+ */
+static inline int
+_scsih_srch_boot_sas_address(u64 sas_address,
+	Mpi2BootDeviceSasWwid_t *boot_device)
+{
+	return (sas_address == le64_to_cpu(boot_device->SASAddress)) ?  1 : 0;
+}
+
+/**
+ * _scsih_srch_boot_device_name - search based on device name
+ * @device_name: device name specified in INDENTIFY fram
+ * @boot_device: boot device object from bios page 2
+ *
+ * Returns 1 when there's a match, 0 means no match.
+ */
+static inline int
+_scsih_srch_boot_device_name(u64 device_name,
+	Mpi2BootDeviceDeviceName_t *boot_device)
+{
+	return (device_name == le64_to_cpu(boot_device->DeviceName)) ? 1 : 0;
+}
+
+/**
+ * _scsih_srch_boot_encl_slot - search based on enclosure_logical_id/slot
+ * @enclosure_logical_id: enclosure logical id
+ * @slot_number: slot number
+ * @boot_device: boot device object from bios page 2
+ *
+ * Returns 1 when there's a match, 0 means no match.
+ */
+static inline int
+_scsih_srch_boot_encl_slot(u64 enclosure_logical_id, u16 slot_number,
+	Mpi2BootDeviceEnclosureSlot_t *boot_device)
+{
+	return (enclosure_logical_id == le64_to_cpu(boot_device->
+	    EnclosureLogicalID) && slot_number == le16_to_cpu(boot_device->
+	    SlotNumber)) ? 1 : 0;
+}
+
+/**
+ * _scsih_is_boot_device - search for matching boot device.
+ * @sas_address: sas address
+ * @device_name: device name specified in INDENTIFY fram
+ * @enclosure_logical_id: enclosure logical id
+ * @slot_number: slot number
+ * @form: specifies boot device form
+ * @boot_device: boot device object from bios page 2
+ *
+ * Returns 1 when there's a match, 0 means no match.
+ */
+static int
+_scsih_is_boot_device(u64 sas_address, u64 device_name,
+	u64 enclosure_logical_id, u16 slot, u8 form,
+	Mpi2BiosPage2BootDevice_t *boot_device)
+{
+	int rc = 0;
+
+	switch (form) {
+	case MPI2_BIOSPAGE2_FORM_SAS_WWID:
+		if (!sas_address)
+			break;
+		rc = _scsih_srch_boot_sas_address(
+		    sas_address, &boot_device->SasWwid);
+		break;
+	case MPI2_BIOSPAGE2_FORM_ENCLOSURE_SLOT:
+		if (!enclosure_logical_id)
+			break;
+		rc = _scsih_srch_boot_encl_slot(
+		    enclosure_logical_id,
+		    slot, &boot_device->EnclosureSlot);
+		break;
+	case MPI2_BIOSPAGE2_FORM_DEVICE_NAME:
+		if (!device_name)
+			break;
+		rc = _scsih_srch_boot_device_name(
+		    device_name, &boot_device->DeviceName);
+		break;
+	case MPI2_BIOSPAGE2_FORM_NO_DEVICE_SPECIFIED:
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * _scsih_get_sas_address - set the sas_address for given device handle
+ * @handle: device handle
+ * @sas_address: sas address
+ *
+ * Returns 0 success, non-zero when failure
+ */
+static int
+_scsih_get_sas_address(struct MPT3SAS_ADAPTER *ioc, u16 handle,
+	u64 *sas_address)
+{
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u32 ioc_status;
+
+	*sas_address = 0;
+
+	if (handle <= ioc->sas_hba.num_phys) {
+		*sas_address = ioc->sas_hba.sas_address;
+		return 0;
+	}
+
+	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
+		__FILE__, __LINE__, __func__);
+		return -ENXIO;
+	}
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) & MPI2_IOCSTATUS_MASK;
+	if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
+		*sas_address = le64_to_cpu(sas_device_pg0.SASAddress);
+		return 0;
+	}
+
+	/* we hit this becuase the given parent handle doesn't exist */
+	if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
+		return -ENXIO;
+
+	/* else error case */
+	pr_err(MPT3SAS_FMT
+		"handle(0x%04x), ioc_status(0x%04x), failure at %s:%d/%s()!\n",
+		ioc->name, handle, ioc_status,
+	     __FILE__, __LINE__, __func__);
+	return -EIO;
+}
+
+/**
+ * _scsih_determine_boot_device - determine boot device.
+ * @ioc: per adapter object
+ * @device: either sas_device or raid_device object
+ * @is_raid: [flag] 1 = raid object, 0 = sas object
+ *
+ * Determines whether this device should be first reported device to
+ * to scsi-ml or sas transport, this purpose is for persistent boot device.
+ * There are primary, alternate, and current entries in bios page 2. The order
+ * priority is primary, alternate, then current.  This routine saves
+ * the corresponding device object and is_raid flag in the ioc object.
+ * The saved data to be used later in _scsih_probe_boot_devices().
+ */
+static void
+_scsih_determine_boot_device(struct MPT3SAS_ADAPTER *ioc,
+	void *device, u8 is_raid)
+{
+	struct _sas_device *sas_device;
+	struct _raid_device *raid_device;
+	u64 sas_address;
+	u64 device_name;
+	u64 enclosure_logical_id;
+	u16 slot;
+
+	 /* only process this function when driver loads */
+	if (!ioc->is_driver_loading)
+		return;
+
+	 /* no Bios, return immediately */
+	if (!ioc->bios_pg3.BiosVersion)
+		return;
+
+	if (!is_raid) {
+		sas_device = device;
+		sas_address = sas_device->sas_address;
+		device_name = sas_device->device_name;
+		enclosure_logical_id = sas_device->enclosure_logical_id;
+		slot = sas_device->slot;
+	} else {
+		raid_device = device;
+		sas_address = raid_device->wwid;
+		device_name = 0;
+		enclosure_logical_id = 0;
+		slot = 0;
+	}
+
+	if (!ioc->req_boot_device.device) {
+		if (_scsih_is_boot_device(sas_address, device_name,
+		    enclosure_logical_id, slot,
+		    (ioc->bios_pg2.ReqBootDeviceForm &
+		    MPI2_BIOSPAGE2_FORM_MASK),
+		    &ioc->bios_pg2.RequestedBootDevice)) {
+			dinitprintk(ioc, pr_info(MPT3SAS_FMT
+			   "%s: req_boot_device(0x%016llx)\n",
+			    ioc->name, __func__,
+			    (unsigned long long)sas_address));
+			ioc->req_boot_device.device = device;
+			ioc->req_boot_device.is_raid = is_raid;
+		}
+	}
+
+	if (!ioc->req_alt_boot_device.device) {
+		if (_scsih_is_boot_device(sas_address, device_name,
+		    enclosure_logical_id, slot,
+		    (ioc->bios_pg2.ReqAltBootDeviceForm &
+		    MPI2_BIOSPAGE2_FORM_MASK),
+		    &ioc->bios_pg2.RequestedAltBootDevice)) {
+			dinitprintk(ioc, pr_info(MPT3SAS_FMT
+			   "%s: req_alt_boot_device(0x%016llx)\n",
+			    ioc->name, __func__,
+			    (unsigned long long)sas_address));
+			ioc->req_alt_boot_device.device = device;
+			ioc->req_alt_boot_device.is_raid = is_raid;
+		}
+	}
+
+	if (!ioc->current_boot_device.device) {
+		if (_scsih_is_boot_device(sas_address, device_name,
+		    enclosure_logical_id, slot,
+		    (ioc->bios_pg2.CurrentBootDeviceForm &
+		    MPI2_BIOSPAGE2_FORM_MASK),
+		    &ioc->bios_pg2.CurrentBootDevice)) {
+			dinitprintk(ioc, pr_info(MPT3SAS_FMT
+			   "%s: current_boot_device(0x%016llx)\n",
+			    ioc->name, __func__,
+			    (unsigned long long)sas_address));
+			ioc->current_boot_device.device = device;
+			ioc->current_boot_device.is_raid = is_raid;
+		}
+	}
+}
+
+/**
+ * mpt3sas_scsih_sas_device_find_by_sas_address - sas device search
+ * @ioc: per adapter object
+ * @sas_address: sas address
+ * Context: Calling function should acquire ioc->sas_device_lock
+ *
+ * This searches for sas_device based on sas_address, then return sas_device
+ * object.
+ */
+struct _sas_device *
+mpt3sas_scsih_sas_device_find_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
+	u64 sas_address)
+{
+	struct _sas_device *sas_device;
+
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
+		if (sas_device->sas_address == sas_address)
+			return sas_device;
+
+	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
+		if (sas_device->sas_address == sas_address)
+			return sas_device;
+
+	return NULL;
+}
+
+/**
+ * _scsih_sas_device_find_by_handle - sas device search
+ * @ioc: per adapter object
+ * @handle: sas device handle (assigned by firmware)
+ * Context: Calling function should acquire ioc->sas_device_lock
+ *
+ * This searches for sas_device based on sas_address, then return sas_device
+ * object.
+ */
+static struct _sas_device *
+_scsih_sas_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _sas_device *sas_device;
+
+	list_for_each_entry(sas_device, &ioc->sas_device_list, list)
+		if (sas_device->handle == handle)
+			return sas_device;
+
+	list_for_each_entry(sas_device, &ioc->sas_device_init_list, list)
+		if (sas_device->handle == handle)
+			return sas_device;
+
+	return NULL;
+}
+
+/**
+ * _scsih_sas_device_remove - remove sas_device from list.
+ * @ioc: per adapter object
+ * @sas_device: the sas_device object
+ * Context: This function will acquire ioc->sas_device_lock.
+ *
+ * Removing object and freeing associated memory from the ioc->sas_device_list.
+ */
+static void
+_scsih_sas_device_remove(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_device *sas_device)
+{
+	unsigned long flags;
+
+	if (!sas_device)
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	list_del(&sas_device->list);
+	kfree(sas_device);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+}
+
+/**
+ * _scsih_device_remove_by_handle - removing device object by handle
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * Return nothing.
+ */
+static void
+_scsih_device_remove_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _sas_device *sas_device;
+	unsigned long flags;
+
+	if (ioc->shost_recovery)
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (sas_device)
+		list_del(&sas_device->list);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (sas_device)
+		_scsih_remove_device(ioc, sas_device);
+}
+
+/**
+ * mpt3sas_device_remove_by_sas_address - removing device object by sas address
+ * @ioc: per adapter object
+ * @sas_address: device sas_address
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_device_remove_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
+	u64 sas_address)
+{
+	struct _sas_device *sas_device;
+	unsigned long flags;
+
+	if (ioc->shost_recovery)
+		return;
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	    sas_address);
+	if (sas_device)
+		list_del(&sas_device->list);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (sas_device)
+		_scsih_remove_device(ioc, sas_device);
+}
+
+/**
+ * _scsih_sas_device_add - insert sas_device to the list.
+ * @ioc: per adapter object
+ * @sas_device: the sas_device object
+ * Context: This function will acquire ioc->sas_device_lock.
+ *
+ * Adding new object to the ioc->sas_device_list.
+ */
+static void
+_scsih_sas_device_add(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_device *sas_device)
+{
+	unsigned long flags;
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: handle(0x%04x), sas_addr(0x%016llx)\n",
+		ioc->name, __func__, sas_device->handle,
+		(unsigned long long)sas_device->sas_address));
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	list_add_tail(&sas_device->list, &ioc->sas_device_list);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (!mpt3sas_transport_port_add(ioc, sas_device->handle,
+	     sas_device->sas_address_parent)) {
+		_scsih_sas_device_remove(ioc, sas_device);
+	} else if (!sas_device->starget) {
+		/*
+		 * When asyn scanning is enabled, its not possible to remove
+		 * devices while scanning is turned on due to an oops in
+		 * scsi_sysfs_add_sdev()->add_device()->sysfs_addrm_start()
+		 */
+		if (!ioc->is_driver_loading)
+			mpt3sas_transport_port_remove(ioc,
+			    sas_device->sas_address,
+			    sas_device->sas_address_parent);
+		_scsih_sas_device_remove(ioc, sas_device);
+	}
+}
+
+/**
+ * _scsih_sas_device_init_add - insert sas_device to the list.
+ * @ioc: per adapter object
+ * @sas_device: the sas_device object
+ * Context: This function will acquire ioc->sas_device_lock.
+ *
+ * Adding new object at driver load time to the ioc->sas_device_init_list.
+ */
+static void
+_scsih_sas_device_init_add(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_device *sas_device)
+{
+	unsigned long flags;
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: handle(0x%04x), sas_addr(0x%016llx)\n", ioc->name,
+		__func__, sas_device->handle,
+		(unsigned long long)sas_device->sas_address));
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	list_add_tail(&sas_device->list, &ioc->sas_device_init_list);
+	_scsih_determine_boot_device(ioc, sas_device, 0);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+}
+
+/**
+ * _scsih_raid_device_find_by_id - raid device search
+ * @ioc: per adapter object
+ * @id: sas device target id
+ * @channel: sas device channel
+ * Context: Calling function should acquire ioc->raid_device_lock
+ *
+ * This searches for raid_device based on target id, then return raid_device
+ * object.
+ */
+static struct _raid_device *
+_scsih_raid_device_find_by_id(struct MPT3SAS_ADAPTER *ioc, int id, int channel)
+{
+	struct _raid_device *raid_device, *r;
+
+	r = NULL;
+	list_for_each_entry(raid_device, &ioc->raid_device_list, list) {
+		if (raid_device->id == id && raid_device->channel == channel) {
+			r = raid_device;
+			goto out;
+		}
+	}
+
+ out:
+	return r;
+}
+
+/**
+ * _scsih_raid_device_find_by_handle - raid device search
+ * @ioc: per adapter object
+ * @handle: sas device handle (assigned by firmware)
+ * Context: Calling function should acquire ioc->raid_device_lock
+ *
+ * This searches for raid_device based on handle, then return raid_device
+ * object.
+ */
+static struct _raid_device *
+_scsih_raid_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _raid_device *raid_device, *r;
+
+	r = NULL;
+	list_for_each_entry(raid_device, &ioc->raid_device_list, list) {
+		if (raid_device->handle != handle)
+			continue;
+		r = raid_device;
+		goto out;
+	}
+
+ out:
+	return r;
+}
+
+/**
+ * _scsih_raid_device_find_by_wwid - raid device search
+ * @ioc: per adapter object
+ * @handle: sas device handle (assigned by firmware)
+ * Context: Calling function should acquire ioc->raid_device_lock
+ *
+ * This searches for raid_device based on wwid, then return raid_device
+ * object.
+ */
+static struct _raid_device *
+_scsih_raid_device_find_by_wwid(struct MPT3SAS_ADAPTER *ioc, u64 wwid)
+{
+	struct _raid_device *raid_device, *r;
+
+	r = NULL;
+	list_for_each_entry(raid_device, &ioc->raid_device_list, list) {
+		if (raid_device->wwid != wwid)
+			continue;
+		r = raid_device;
+		goto out;
+	}
+
+ out:
+	return r;
+}
+
+/**
+ * _scsih_raid_device_add - add raid_device object
+ * @ioc: per adapter object
+ * @raid_device: raid_device object
+ *
+ * This is added to the raid_device_list link list.
+ */
+static void
+_scsih_raid_device_add(struct MPT3SAS_ADAPTER *ioc,
+	struct _raid_device *raid_device)
+{
+	unsigned long flags;
+
+	dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		"%s: handle(0x%04x), wwid(0x%016llx)\n", ioc->name, __func__,
+	    raid_device->handle, (unsigned long long)raid_device->wwid));
+
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	list_add_tail(&raid_device->list, &ioc->raid_device_list);
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+}
+
+/**
+ * _scsih_raid_device_remove - delete raid_device object
+ * @ioc: per adapter object
+ * @raid_device: raid_device object
+ *
+ */
+static void
+_scsih_raid_device_remove(struct MPT3SAS_ADAPTER *ioc,
+	struct _raid_device *raid_device)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	list_del(&raid_device->list);
+	kfree(raid_device);
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+}
+
+/**
+ * mpt3sas_scsih_expander_find_by_handle - expander device search
+ * @ioc: per adapter object
+ * @handle: expander handle (assigned by firmware)
+ * Context: Calling function should acquire ioc->sas_device_lock
+ *
+ * This searches for expander device based on handle, then returns the
+ * sas_node object.
+ */
+struct _sas_node *
+mpt3sas_scsih_expander_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct _sas_node *sas_expander, *r;
+
+	r = NULL;
+	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
+		if (sas_expander->handle != handle)
+			continue;
+		r = sas_expander;
+		goto out;
+	}
+ out:
+	return r;
+}
+
+/**
+ * mpt3sas_scsih_expander_find_by_sas_address - expander device search
+ * @ioc: per adapter object
+ * @sas_address: sas address
+ * Context: Calling function should acquire ioc->sas_node_lock.
+ *
+ * This searches for expander device based on sas_address, then returns the
+ * sas_node object.
+ */
+struct _sas_node *
+mpt3sas_scsih_expander_find_by_sas_address(struct MPT3SAS_ADAPTER *ioc,
+	u64 sas_address)
+{
+	struct _sas_node *sas_expander, *r;
+
+	r = NULL;
+	list_for_each_entry(sas_expander, &ioc->sas_expander_list, list) {
+		if (sas_expander->sas_address != sas_address)
+			continue;
+		r = sas_expander;
+		goto out;
+	}
+ out:
+	return r;
+}
+
+/**
+ * _scsih_expander_node_add - insert expander device to the list.
+ * @ioc: per adapter object
+ * @sas_expander: the sas_device object
+ * Context: This function will acquire ioc->sas_node_lock.
+ *
+ * Adding new object to the ioc->sas_expander_list.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_expander_node_add(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_node *sas_expander)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->sas_node_lock, flags);
+	list_add_tail(&sas_expander->list, &ioc->sas_expander_list);
+	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+}
+
+/**
+ * _scsih_is_end_device - determines if device is an end device
+ * @device_info: bitfield providing information about the device.
+ * Context: none
+ *
+ * Returns 1 if end device.
+ */
+static int
+_scsih_is_end_device(u32 device_info)
+{
+	if (device_info & MPI2_SAS_DEVICE_INFO_END_DEVICE &&
+		((device_info & MPI2_SAS_DEVICE_INFO_SSP_TARGET) |
+		(device_info & MPI2_SAS_DEVICE_INFO_STP_TARGET) |
+		(device_info & MPI2_SAS_DEVICE_INFO_SATA_DEVICE)))
+		return 1;
+	else
+		return 0;
+}
+
+/**
+ * _scsih_scsi_lookup_get - returns scmd entry
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns the smid stored scmd pointer.
+ */
+static struct scsi_cmnd *
+_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return ioc->scsi_lookup[smid - 1].scmd;
+}
+
+/**
+ * _scsih_scsi_lookup_get_clear - returns scmd entry
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns the smid stored scmd pointer.
+ * Then will derefrence the stored scmd pointer.
+ */
+static inline struct scsi_cmnd *
+_scsih_scsi_lookup_get_clear(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	unsigned long flags;
+	struct scsi_cmnd *scmd;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	scmd = ioc->scsi_lookup[smid - 1].scmd;
+	ioc->scsi_lookup[smid - 1].scmd = NULL;
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	return scmd;
+}
+
+/**
+ * _scsih_scsi_lookup_find_by_scmd - scmd lookup
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @scmd: pointer to scsi command object
+ * Context: This function will acquire ioc->scsi_lookup_lock.
+ *
+ * This will search for a scmd pointer in the scsi_lookup array,
+ * returning the revelent smid.  A returned value of zero means invalid.
+ */
+static u16
+_scsih_scsi_lookup_find_by_scmd(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd
+	*scmd)
+{
+	u16 smid;
+	unsigned long	flags;
+	int i;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	smid = 0;
+	for (i = 0; i < ioc->scsiio_depth; i++) {
+		if (ioc->scsi_lookup[i].scmd == scmd) {
+			smid = ioc->scsi_lookup[i].smid;
+			goto out;
+		}
+	}
+ out:
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return smid;
+}
+
+/**
+ * _scsih_scsi_lookup_find_by_target - search for matching channel:id
+ * @ioc: per adapter object
+ * @id: target id
+ * @channel: channel
+ * Context: This function will acquire ioc->scsi_lookup_lock.
+ *
+ * This will search for a matching channel:id in the scsi_lookup array,
+ * returning 1 if found.
+ */
+static u8
+_scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
+	int channel)
+{
+	u8 found;
+	unsigned long	flags;
+	int i;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	found = 0;
+	for (i = 0 ; i < ioc->scsiio_depth; i++) {
+		if (ioc->scsi_lookup[i].scmd &&
+		    (ioc->scsi_lookup[i].scmd->device->id == id &&
+		    ioc->scsi_lookup[i].scmd->device->channel == channel)) {
+			found = 1;
+			goto out;
+		}
+	}
+ out:
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return found;
+}
+
+/**
+ * _scsih_scsi_lookup_find_by_lun - search for matching channel:id:lun
+ * @ioc: per adapter object
+ * @id: target id
+ * @lun: lun number
+ * @channel: channel
+ * Context: This function will acquire ioc->scsi_lookup_lock.
+ *
+ * This will search for a matching channel:id:lun in the scsi_lookup array,
+ * returning 1 if found.
+ */
+static u8
+_scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
+	unsigned int lun, int channel)
+{
+	u8 found;
+	unsigned long	flags;
+	int i;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	found = 0;
+	for (i = 0 ; i < ioc->scsiio_depth; i++) {
+		if (ioc->scsi_lookup[i].scmd &&
+		    (ioc->scsi_lookup[i].scmd->device->id == id &&
+		    ioc->scsi_lookup[i].scmd->device->channel == channel &&
+		    ioc->scsi_lookup[i].scmd->device->lun == lun)) {
+			found = 1;
+			goto out;
+		}
+	}
+ out:
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return found;
+}
+
+
+static void
+_scsih_adjust_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	struct Scsi_Host *shost = sdev->host;
+	int max_depth;
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+
+	max_depth = shost->can_queue;
+
+	/* limit max device queue for SATA to 32 */
+	sas_device_priv_data = sdev->hostdata;
+	if (!sas_device_priv_data)
+		goto not_sata;
+	sas_target_priv_data = sas_device_priv_data->sas_target;
+	if (!sas_target_priv_data)
+		goto not_sata;
+	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))
+		goto not_sata;
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	   sas_device_priv_data->sas_target->sas_address);
+	if (sas_device && sas_device->device_info &
+	    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
+		max_depth = MPT3SAS_SATA_QUEUE_DEPTH;
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+ not_sata:
+
+	if (!sdev->tagged_supported)
+		max_depth = 1;
+	if (qdepth > max_depth)
+		qdepth = max_depth;
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+}
+
+/**
+ * _scsih_change_queue_depth - setting device queue depth
+ * @sdev: scsi device struct
+ * @qdepth: requested queue depth
+ * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
+ * (see include/scsi/scsi_host.h for definition)
+ *
+ * Returns queue depth.
+ */
+static int
+_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
+{
+	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP)
+		_scsih_adjust_queue_depth(sdev, qdepth);
+	else if (reason == SCSI_QDEPTH_QFULL)
+		scsi_track_queue_full(sdev, qdepth);
+	else
+		return -EOPNOTSUPP;
+
+	if (sdev->inquiry_len > 7)
+		sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), " \
+		"simple(%d), ordered(%d), scsi_level(%d), cmd_que(%d)\n",
+		sdev->queue_depth, sdev->tagged_supported, sdev->simple_tags,
+		sdev->ordered_tags, sdev->scsi_level,
+		(sdev->inquiry[7] & 2) >> 1);
+
+	return sdev->queue_depth;
+}
+
+/**
+ * _scsih_change_queue_type - changing device queue tag type
+ * @sdev: scsi device struct
+ * @tag_type: requested tag type
+ *
+ * Returns queue tag type.
+ */
+static int
+_scsih_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+
+
+/**
+ * _scsih_target_alloc - target add routine
+ * @starget: scsi target struct
+ *
+ * Returns 0 if ok. Any other return is assumed to be an error and
+ * the device is ignored.
+ */
+static int
+_scsih_target_alloc(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct _sas_device *sas_device;
+	struct _raid_device *raid_device;
+	unsigned long flags;
+	struct sas_rphy *rphy;
+
+	sas_target_priv_data = kzalloc(sizeof(struct scsi_target), GFP_KERNEL);
+	if (!sas_target_priv_data)
+		return -ENOMEM;
+
+	starget->hostdata = sas_target_priv_data;
+	sas_target_priv_data->starget = starget;
+	sas_target_priv_data->handle = MPT3SAS_INVALID_DEVICE_HANDLE;
+
+	/* RAID volumes */
+	if (starget->channel == RAID_CHANNEL) {
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		raid_device = _scsih_raid_device_find_by_id(ioc, starget->id,
+		    starget->channel);
+		if (raid_device) {
+			sas_target_priv_data->handle = raid_device->handle;
+			sas_target_priv_data->sas_address = raid_device->wwid;
+			sas_target_priv_data->flags |= MPT_TARGET_FLAGS_VOLUME;
+			raid_device->starget = starget;
+		}
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+		return 0;
+	}
+
+	/* sas/sata devices */
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	rphy = dev_to_rphy(starget->dev.parent);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	   rphy->identify.sas_address);
+
+	if (sas_device) {
+		sas_target_priv_data->handle = sas_device->handle;
+		sas_target_priv_data->sas_address = sas_device->sas_address;
+		sas_device->starget = starget;
+		sas_device->id = starget->id;
+		sas_device->channel = starget->channel;
+		if (test_bit(sas_device->handle, ioc->pd_handles))
+			sas_target_priv_data->flags |=
+			    MPT_TARGET_FLAGS_RAID_COMPONENT;
+		if (sas_device->fast_path)
+			sas_target_priv_data->flags |= MPT_TARGET_FASTPATH_IO;
+	}
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	return 0;
+}
+
+/**
+ * _scsih_target_destroy - target destroy routine
+ * @starget: scsi target struct
+ *
+ * Returns nothing.
+ */
+static void
+_scsih_target_destroy(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct _sas_device *sas_device;
+	struct _raid_device *raid_device;
+	unsigned long flags;
+	struct sas_rphy *rphy;
+
+	sas_target_priv_data = starget->hostdata;
+	if (!sas_target_priv_data)
+		return;
+
+	if (starget->channel == RAID_CHANNEL) {
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		raid_device = _scsih_raid_device_find_by_id(ioc, starget->id,
+		    starget->channel);
+		if (raid_device) {
+			raid_device->starget = NULL;
+			raid_device->sdev = NULL;
+		}
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+		goto out;
+	}
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	rphy = dev_to_rphy(starget->dev.parent);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	   rphy->identify.sas_address);
+	if (sas_device && (sas_device->starget == starget) &&
+	    (sas_device->id == starget->id) &&
+	    (sas_device->channel == starget->channel))
+		sas_device->starget = NULL;
+
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+ out:
+	kfree(sas_target_priv_data);
+	starget->hostdata = NULL;
+}
+
+/**
+ * _scsih_slave_alloc - device add routine
+ * @sdev: scsi device struct
+ *
+ * Returns 0 if ok. Any other return is assumed to be an error and
+ * the device is ignored.
+ */
+static int
+_scsih_slave_alloc(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_target *starget;
+	struct _raid_device *raid_device;
+	unsigned long flags;
+
+	sas_device_priv_data = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (!sas_device_priv_data)
+		return -ENOMEM;
+
+	sas_device_priv_data->lun = sdev->lun;
+	sas_device_priv_data->flags = MPT_DEVICE_FLAGS_INIT;
+
+	starget = scsi_target(sdev);
+	sas_target_priv_data = starget->hostdata;
+	sas_target_priv_data->num_luns++;
+	sas_device_priv_data->sas_target = sas_target_priv_data;
+	sdev->hostdata = sas_device_priv_data;
+	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT))
+		sdev->no_uld_attach = 1;
+
+	shost = dev_to_shost(&starget->dev);
+	ioc = shost_priv(shost);
+	if (starget->channel == RAID_CHANNEL) {
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		raid_device = _scsih_raid_device_find_by_id(ioc,
+		    starget->id, starget->channel);
+		if (raid_device)
+			raid_device->sdev = sdev; /* raid is single lun */
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+	}
+
+	return 0;
+}
+
+/**
+ * _scsih_slave_destroy - device destroy routine
+ * @sdev: scsi device struct
+ *
+ * Returns nothing.
+ */
+static void
+_scsih_slave_destroy(struct scsi_device *sdev)
+{
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct scsi_target *starget;
+	struct Scsi_Host *shost;
+	struct MPT3SAS_ADAPTER *ioc;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+
+	if (!sdev->hostdata)
+		return;
+
+	starget = scsi_target(sdev);
+	sas_target_priv_data = starget->hostdata;
+	sas_target_priv_data->num_luns--;
+
+	shost = dev_to_shost(&starget->dev);
+	ioc = shost_priv(shost);
+
+	if (!(sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME)) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+		   sas_target_priv_data->sas_address);
+		if (sas_device && !sas_target_priv_data->num_luns)
+			sas_device->starget = NULL;
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+
+	kfree(sdev->hostdata);
+	sdev->hostdata = NULL;
+}
+
+/**
+ * _scsih_display_sata_capabilities - sata capabilities
+ * @ioc: per adapter object
+ * @handle: device handle
+ * @sdev: scsi device struct
+ */
+static void
+_scsih_display_sata_capabilities(struct MPT3SAS_ADAPTER *ioc,
+	u16 handle, struct scsi_device *sdev)
+{
+	Mpi2ConfigReply_t mpi_reply;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	u32 ioc_status;
+	u16 flags;
+	u32 device_info;
+
+	if ((mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply, &sas_device_pg0,
+	    MPI2_SAS_DEVICE_PGAD_FORM_HANDLE, handle))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		return;
+	}
+
+	flags = le16_to_cpu(sas_device_pg0.Flags);
+	device_info = le32_to_cpu(sas_device_pg0.DeviceInfo);
+
+	sdev_printk(KERN_INFO, sdev,
+	    "atapi(%s), ncq(%s), asyn_notify(%s), smart(%s), fua(%s), "
+	    "sw_preserve(%s)\n",
+	    (device_info & MPI2_SAS_DEVICE_INFO_ATAPI_DEVICE) ? "y" : "n",
+	    (flags & MPI2_SAS_DEVICE0_FLAGS_SATA_NCQ_SUPPORTED) ? "y" : "n",
+	    (flags & MPI2_SAS_DEVICE0_FLAGS_SATA_ASYNCHRONOUS_NOTIFY) ? "y" :
+	    "n",
+	    (flags & MPI2_SAS_DEVICE0_FLAGS_SATA_SMART_SUPPORTED) ? "y" : "n",
+	    (flags & MPI2_SAS_DEVICE0_FLAGS_SATA_FUA_SUPPORTED) ? "y" : "n",
+	    (flags & MPI2_SAS_DEVICE0_FLAGS_SATA_SW_PRESERVE) ? "y" : "n");
+}
+
+/*
+ * raid transport support -
+ * Enabled for SLES11 and newer, in older kernels the driver will panic when
+ * unloading the driver followed by a load - I beleive that the subroutine
+ * raid_class_release() is not cleaning up properly.
+ */
+
+/**
+ * _scsih_is_raid - return boolean indicating device is raid volume
+ * @dev the device struct object
+ */
+static int
+_scsih_is_raid(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return (sdev->channel == RAID_CHANNEL) ? 1 : 0;
+}
+
+/**
+ * _scsih_get_resync - get raid volume resync percent complete
+ * @dev the device struct object
+ */
+static void
+_scsih_get_resync(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
+	static struct _raid_device *raid_device;
+	unsigned long flags;
+	Mpi2RaidVolPage0_t vol_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u32 volume_status_flags;
+	u8 percent_complete;
+	u16 handle;
+
+	percent_complete = 0;
+	handle = 0;
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	raid_device = _scsih_raid_device_find_by_id(ioc, sdev->id,
+	    sdev->channel);
+	if (raid_device) {
+		handle = raid_device->handle;
+		percent_complete = raid_device->percent_complete;
+	}
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+
+	if (!handle)
+		goto out;
+
+	if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, &vol_pg0,
+	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
+	     sizeof(Mpi2RaidVolPage0_t))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		percent_complete = 0;
+		goto out;
+	}
+
+	volume_status_flags = le32_to_cpu(vol_pg0.VolumeStatusFlags);
+	if (!(volume_status_flags &
+	    MPI2_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS))
+		percent_complete = 0;
+
+ out:
+	raid_set_resync(mpt3sas_raid_template, dev, percent_complete);
+}
+
+/**
+ * _scsih_get_state - get raid volume level
+ * @dev the device struct object
+ */
+static void
+_scsih_get_state(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
+	static struct _raid_device *raid_device;
+	unsigned long flags;
+	Mpi2RaidVolPage0_t vol_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u32 volstate;
+	enum raid_state state = RAID_STATE_UNKNOWN;
+	u16 handle = 0;
+
+	spin_lock_irqsave(&ioc->raid_device_lock, flags);
+	raid_device = _scsih_raid_device_find_by_id(ioc, sdev->id,
+	    sdev->channel);
+	if (raid_device)
+		handle = raid_device->handle;
+	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+
+	if (!raid_device)
+		goto out;
+
+	if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, &vol_pg0,
+	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
+	     sizeof(Mpi2RaidVolPage0_t))) {
+		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		goto out;
+	}
+
+	volstate = le32_to_cpu(vol_pg0.VolumeStatusFlags);
+	if (volstate & MPI2_RAIDVOL0_STATUS_FLAG_RESYNC_IN_PROGRESS) {
+		state = RAID_STATE_RESYNCING;
+		goto out;
+	}
+
+	switch (vol_pg0.VolumeState) {
+	case MPI2_RAID_VOL_STATE_OPTIMAL:
+	case MPI2_RAID_VOL_STATE_ONLINE:
+		state = RAID_STATE_ACTIVE;
+		break;
+	case  MPI2_RAID_VOL_STATE_DEGRADED:
+		state = RAID_STATE_DEGRADED;
+		break;
+	case MPI2_RAID_VOL_STATE_FAILED:
+	case MPI2_RAID_VOL_STATE_MISSING:
+		state = RAID_STATE_OFFLINE;
+		break;
+	}
+ out:
+	raid_set_state(mpt3sas_raid_template, dev, state);
+}
+
+/**
+ * _scsih_set_level - set raid level
+ * @sdev: scsi device struct
+ * @volume_type: volume type
+ */
+static void
+_scsih_set_level(struct scsi_device *sdev, u8 volume_type)
+{
+	enum raid_level level = RAID_LEVEL_UNKNOWN;
+
+	switch (volume_type) {
+	case MPI2_RAID_VOL_TYPE_RAID0:
+		level = RAID_LEVEL_0;
+		break;
+	case MPI2_RAID_VOL_TYPE_RAID10:
+		level = RAID_LEVEL_10;
+		break;
+	case MPI2_RAID_VOL_TYPE_RAID1E:
+		level = RAID_LEVEL_1E;
+		break;
+	case MPI2_RAID_VOL_TYPE_RAID1:
+		level = RAID_LEVEL_1;
+		break;
+	}
+
+	raid_set_level(mpt3sas_raid_template, &sdev->sdev_gendev, level);
+}
+
+
+/**
+ * _scsih_get_volume_capabilities - volume capabilities
+ * @ioc: per adapter object
+ * @sas_device: the raid_device object
+ *
+ * Returns 0 for success, else 1
+ */
+static int
+_scsih_get_volume_capabilities(struct MPT3SAS_ADAPTER *ioc,
+	struct _raid_device *raid_device)
+{
+	Mpi2RaidVolPage0_t *vol_pg0;
+	Mpi2RaidPhysDiskPage0_t pd_pg0;
+	Mpi2SasDevicePage0_t sas_device_pg0;
+	Mpi2ConfigReply_t mpi_reply;
+	u16 sz;
+	u8 num_pds;
+
+	if ((mpt3sas_config_get_number_pds(ioc, raid_device->handle,
+	    &num_pds)) || !num_pds) {
+		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
+		return 1;
+	}
+
+	raid_device->num_pds = num_pds;
+	sz = offsetof(Mpi2RaidVolPage0_t, PhysDisk) + (num_pds *
+	    sizeof(Mpi2RaidVol0PhysDisk_t));
+	vol_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!vol_pg0) {
+		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
+		return 1;
+	}
+
+	if ((mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply, vol_pg0,
+	     MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, raid_device->handle, sz))) {
+		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
+		kfree(vol_pg0);
+		return 1;
+	}
+
+	raid_device->volume_type = vol_pg0->VolumeType;
+
+	/* figure out what the underlying devices are by
+	 * obtaining the device_info bits for the 1st device
+	 */
+	if (!(mpt3sas_config_get_phys_disk_pg0(ioc, &mpi_reply,
+	    &pd_pg0, MPI2_PHYSDISK_PGAD_FORM_PHYSDISKNUM,
+	    vol_pg0->PhysDisk[0].PhysDiskNum))) {
+		if (!(mpt3sas_config_get_sas_device_pg0(ioc, &mpi_reply,
+		    &sas_device_pg0, MPI2_SAS_DEVICE_PGAD_FORM_HANDLE,
+		    le16_to_cpu(pd_pg0.DevHandle)))) {
+			raid_device->device_info =
+			    le32_to_cpu(sas_device_pg0.DeviceInfo);
+		}
+	}
+
+	kfree(vol_pg0);
+	return 0;
+}
+
+
+
+/**
+ * _scsih_enable_tlr - setting TLR flags
+ * @ioc: per adapter object
+ * @sdev: scsi device struct
+ *
+ * Enabling Transaction Layer Retries for tape devices when
+ * vpd page 0x90 is present
+ *
+ */
+static void
+_scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
+{
+
+	/* only for TAPE */
+	if (sdev->type != TYPE_TAPE)
+		return;
+
+	if (!(ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR))
+		return;
+
+	sas_enable_tlr(sdev);
+	sdev_printk(KERN_INFO, sdev, "TLR %s\n",
+	    sas_is_tlr_enabled(sdev) ? "Enabled" : "Disabled");
+	return;
+
+}
+
+/**
+ * _scsih_slave_configure - device configure routine.
+ * @sdev: scsi device struct
+ *
+ * Returns 0 if ok. Any other return is assumed to be an error and
+ * the device is ignored.
+ */
+static int
+_scsih_slave_configure(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	struct _sas_device *sas_device;
+	struct _raid_device *raid_device;
+	unsigned long flags;
+	int qdepth;
+	u8 ssp_target = 0;
+	char *ds = "";
+	char *r_level = "";
+	u16 handle, volume_handle = 0;
+	u64 volume_wwid = 0;
+
+	qdepth = 1;
+	sas_device_priv_data = sdev->hostdata;
+	sas_device_priv_data->configured_lun = 1;
+	sas_device_priv_data->flags &= ~MPT_DEVICE_FLAGS_INIT;
+	sas_target_priv_data = sas_device_priv_data->sas_target;
+	handle = sas_target_priv_data->handle;
+
+	/* raid volume handling */
+	if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME) {
+
+		spin_lock_irqsave(&ioc->raid_device_lock, flags);
+		raid_device = _scsih_raid_device_find_by_handle(ioc, handle);
+		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
+		if (!raid_device) {
+			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name, __FILE__,
+			    __LINE__, __func__));
+			return 1;
+		}
+
+		if (_scsih_get_volume_capabilities(ioc, raid_device)) {
+			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name, __FILE__,
+			    __LINE__, __func__));
+			return 1;
+		}
+
+
+		/* RAID Queue Depth Support
+		 * IS volume = underlying qdepth of drive type, either
+		 *    MPT3SAS_SAS_QUEUE_DEPTH or MPT3SAS_SATA_QUEUE_DEPTH
+		 * IM/IME/R10 = 128 (MPT3SAS_RAID_QUEUE_DEPTH)
+		 */
+		if (raid_device->device_info &
+		    MPI2_SAS_DEVICE_INFO_SSP_TARGET) {
+			qdepth = MPT3SAS_SAS_QUEUE_DEPTH;
+			ds = "SSP";
+		} else {
+			qdepth = MPT3SAS_SATA_QUEUE_DEPTH;
+			 if (raid_device->device_info &
+			    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
+				ds = "SATA";
+			else
+				ds = "STP";
+		}
+
+		switch (raid_device->volume_type) {
+		case MPI2_RAID_VOL_TYPE_RAID0:
+			r_level = "RAID0";
+			break;
+		case MPI2_RAID_VOL_TYPE_RAID1E:
+			qdepth = MPT3SAS_RAID_QUEUE_DEPTH;
+			if (ioc->manu_pg10.OEMIdentifier &&
+			    (le32_to_cpu(ioc->manu_pg10.GenericFlags0) &
+			    MFG10_GF0_R10_DISPLAY) &&
+			    !(raid_device->num_pds % 2))
+				r_level = "RAID10";
+			else
+				r_level = "RAID1E";
+			break;
+		case MPI2_RAID_VOL_TYPE_RAID1:
+			qdepth = MPT3SAS_RAID_QUEUE_DEPTH;
+			r_level = "RAID1";
+			break;
+		case MPI2_RAID_VOL_TYPE_RAID10:
+			qdepth = MPT3SAS_RAID_QUEUE_DEPTH;
+			r_level = "RAID10";
+			break;
+		case MPI2_RAID_VOL_TYPE_UNKNOWN:
+		default:
+			qdepth = MPT3SAS_RAID_QUEUE_DEPTH;
+			r_level = "RAIDX";
+			break;
+		}
+
+		sdev_printk(KERN_INFO, sdev,
+			"%s: handle(0x%04x), wwid(0x%016llx), pd_count(%d), type(%s)\n",
+			 r_level, raid_device->handle,
+			 (unsigned long long)raid_device->wwid,
+			 raid_device->num_pds, ds);
+
+
+		_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
+
+/* raid transport support */
+		_scsih_set_level(sdev, raid_device->volume_type);
+		return 0;
+	}
+
+	/* non-raid handling */
+	if (sas_target_priv_data->flags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
+		if (mpt3sas_config_get_volume_handle(ioc, handle,
+		    &volume_handle)) {
+			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name,
+			    __FILE__, __LINE__, __func__));
+			return 1;
+		}
+		if (volume_handle && mpt3sas_config_get_volume_wwid(ioc,
+		    volume_handle, &volume_wwid)) {
+			dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+			    "failure at %s:%d/%s()!\n", ioc->name,
+			    __FILE__, __LINE__, __func__));
+			return 1;
+		}
+	}
+
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+	   sas_device_priv_data->sas_target->sas_address);
+	if (!sas_device) {
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		dfailprintk(ioc, pr_warn(MPT3SAS_FMT
+		    "failure at %s:%d/%s()!\n", ioc->name, __FILE__, __LINE__,
+		    __func__));
+		return 1;
+	}
+
+	sas_device->volume_handle = volume_handle;
+	sas_device->volume_wwid = volume_wwid;
+	if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_SSP_TARGET) {
+		qdepth = MPT3SAS_SAS_QUEUE_DEPTH;
+		ssp_target = 1;
+		ds = "SSP";
+	} else {
+		qdepth = MPT3SAS_SATA_QUEUE_DEPTH;
+		if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_STP_TARGET)
+			ds = "STP";
+		else if (sas_device->device_info &
+		    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
+			ds = "SATA";
+	}
+
+	sdev_printk(KERN_INFO, sdev, "%s: handle(0x%04x), " \
+	    "sas_addr(0x%016llx), phy(%d), device_name(0x%016llx)\n",
+	    ds, handle, (unsigned long long)sas_device->sas_address,
+	    sas_device->phy, (unsigned long long)sas_device->device_name);
+	sdev_printk(KERN_INFO, sdev,
+		"%s: enclosure_logical_id(0x%016llx), slot(%d)\n",
+		ds, (unsigned long long)
+	    sas_device->enclosure_logical_id, sas_device->slot);
+
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+
+	if (!ssp_target)
+		_scsih_display_sata_capabilities(ioc, handle, sdev);
+
+
+	_scsih_change_queue_depth(sdev, qdepth, SCSI_QDEPTH_DEFAULT);
+
+	if (ssp_target) {
+		sas_read_port_mode_page(sdev);
+		_scsih_enable_tlr(ioc, sdev);
+	}
+
+	return 0;
+}
+
+/**
+ * _scsih_bios_param - fetch head, sector, cylinder info for a disk
+ * @sdev: scsi device struct
+ * @bdev: pointer to block device context
+ * @capacity: device size (in 512 byte sectors)
+ * @params: three element array to place output:
+ *              params[0] number of heads (max 255)
+ *              params[1] number of sectors (max 63)
+ *              params[2] number of cylinders
+ *
+ * Return nothing.
+ */
+static int
+_scsih_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+	sector_t capacity, int params[])
+{
+	int		heads;
+	int		sectors;
+	sector_t	cylinders;
+	ulong		dummy;
+
+	heads = 64;
+	sectors = 32;
+
+	dummy = heads * sectors;
+	cylinders = capacity;
+	sector_div(cylinders, dummy);
+
+	/*
+	 * Handle extended translation size for logical drives
+	 * > 1Gb
+	 */
+	if ((ulong)capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+		dummy = heads * sectors;
+		cylinders = capacity;
+		sector_div(cylinders, dummy);
+	}
+
+	/* return result */
+	params[0] = heads;
+	params[1] = sectors;
+	params[2] = cylinders;
+
+	return 0;
+}
+
+/**
+ * _scsih_response_code - translation of device response code
+ * @ioc: per adapter object
+ * @response_code: response code returned by the device
+ *
+ * Return nothing.
+ */
+static void
+_scsih_response_code(struct MPT3SAS_ADAPTER *ioc, u8 response_code)
+{
+	char *desc;
+
+	switch (response_code) {
+	case MPI2_SCSITASKMGMT_RSP_TM_COMPLETE:
+		desc = "task management request completed";
+		break;
+	case MPI2_SCSITASKMGMT_RSP_INVALID_FRAME:
+		desc = "invalid frame";
+		break;
+	case MPI2_SCSITASKMGMT_RSP_TM_NOT_SUPPORTED:
+		desc = "task management request not supported";
+		break;
+	case MPI2_SCSITASKMGMT_RSP_TM_FAILED:
+		desc = "task management request failed";
+		break;
+	case MPI2_SCSITASKMGMT_RSP_TM_SUCCEEDED:
+		desc = "task management request succeeded";
+		break;
+	case MPI2_SCSITASKMGMT_RSP_TM_INVALID_LUN:
+		desc = "invalid lun";
+		break;
+	case 0xA:
+		desc = "overlapped tag attempted";
+		break;
+	case MPI2_SCSITASKMGMT_RSP_IO_QUEUED_ON_IOC:
+		desc = "task queued, however not sent to target";
+		break;
+	default:
+		desc = "unknown";
+		break;
+	}
+	pr_warn(MPT3SAS_FMT "response_code(0x%01x): %s\n",
+		ioc->name, response_code, desc);
+}
+
+/**
+ * _scsih_tm_done - tm completion routine
+ * @ioc: per adapter object
+ * @smid: system request message index
+ * @msix_index: MSIX table index supplied by the OS
+ * @reply: reply message frame(lower 32bit addr)
+ * Context: none.
+ *
+ * The callback handler when using scsih_issue_tm.
+ *
+ * Return 1 meaning mf should be freed from _base_interrupt
+ *        0 means the mf is freed from this function.
+ */
+static u8
+_scsih_tm_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
+{
+	MPI2DefaultReply_t *mpi_reply;
+
+	if (ioc->tm_cmds.status == MPT3_CMD_NOT_USED)
+		return 1;
+	if (ioc->tm_cmds.smid != smid)
+		return 1;
+	mpt3sas_base_flush_reply_queues(ioc);
+	ioc->tm_cmds.status |= MPT3_CMD_COMPLETE;
+	mpi_reply =  mpt3sas_base_get_reply_virt_addr(ioc, reply);
+	if (mpi_reply) {
+		memcpy(ioc->tm_cmds.reply, mpi_reply, mpi_reply->MsgLength*4);
+		ioc->tm_cmds.status |= MPT3_CMD_REPLY_VALID;
+	}
+	ioc->tm_cmds.status &= ~MPT3_CMD_PENDING;
+	complete(&ioc->tm_cmds.done);
+	return 1;
+}
+
+/**
+ * mpt3sas_scsih_set_tm_flag - set per target tm_busy
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * During taskmangement request, we need to freeze the device queue.
+ */
+void
+mpt3sas_scsih_set_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+	u8 skip = 0;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		if (skip)
+			continue;
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->sas_target->handle == handle) {
+			sas_device_priv_data->sas_target->tm_busy = 1;
+			skip = 1;
+			ioc->ignore_loginfos = 1;
+		}
+	}
+}
+
+/**
+ * mpt3sas_scsih_clear_tm_flag - clear per target tm_busy
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * During taskmangement request, we need to freeze the device queue.
+ */
+void
+mpt3sas_scsih_clear_tm_flag(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+	u8 skip = 0;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		if (skip)
+			continue;
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->sas_target->handle == handle) {
+			sas_device_priv_data->sas_target->tm_busy = 0;
+			skip = 1;
+			ioc->ignore_loginfos = 0;
+		}
+	}
+}
+
+/**
+ * mpt3sas_scsih_issue_tm - main routine for sending tm requests
+ * @ioc: per adapter struct
+ * @device_handle: device handle
+ * @channel: the channel assigned by the OS
+ * @id: the id assigned by the OS
+ * @lun: lun number
+ * @type: MPI2_SCSITASKMGMT_TASKTYPE__XXX (defined in mpi2_init.h)
+ * @smid_task: smid assigned to the task
+ * @timeout: timeout in seconds
+ * @serial_number: the serial_number from scmd
+ * @m_type: TM_MUTEX_ON or TM_MUTEX_OFF
+ * Context: user
+ *
+ * A generic API for sending task management requests to firmware.
+ *
+ * The callback index is set inside `ioc->tm_cb_idx`.
+ *
+ * Return SUCCESS or FAILED.
+ */
+int
+mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
+	uint id, uint lun, u8 type, u16 smid_task, ulong timeout,
+	unsigned long serial_number, enum mutex_type m_type)
+{
+	Mpi2SCSITaskManagementRequest_t *mpi_request;
+	Mpi2SCSITaskManagementReply_t *mpi_reply;
+	u16 smid = 0;
+	u32 ioc_state;
+	unsigned long timeleft;
+	struct scsiio_tracker *scsi_lookup = NULL;
+	int rc;
+
+	if (m_type == TM_MUTEX_ON)
+		mutex_lock(&ioc->tm_cmds.mutex);
+	if (ioc->tm_cmds.status != MPT3_CMD_NOT_USED) {
+		pr_info(MPT3SAS_FMT "%s: tm_cmd busy!!!\n",
+		    __func__, ioc->name);
+		rc = FAILED;
+		goto err_out;
+	}
+
+	if (ioc->shost_recovery || ioc->remove_host ||
+	    ioc->pci_error_recovery) {
+		pr_info(MPT3SAS_FMT "%s: host reset in progress!\n",
+		    __func__, ioc->name);
+		rc = FAILED;
+		goto err_out;
+	}
+
+	ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
+	if (ioc_state & MPI2_DOORBELL_USED) {
+		dhsprintk(ioc, pr_info(MPT3SAS_FMT
+			"unexpected doorbell active!\n", ioc->name));
+		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		    FORCE_BIG_HAMMER);
+		rc = (!rc) ? SUCCESS : FAILED;
+		goto err_out;
+	}
+
+	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
+		mpt3sas_base_fault_info(ioc, ioc_state &
+		    MPI2_DOORBELL_DATA_MASK);
+		rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+		    FORCE_BIG_HAMMER);
+		rc = (!rc) ? SUCCESS : FAILED;
+		goto err_out;
+	}
+
+	smid = mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
+	if (!smid) {
+		pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
+		    ioc->name, __func__);
+		rc = FAILED;
+		goto err_out;
+	}
+
+	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
+		scsi_lookup = &ioc->scsi_lookup[smid_task - 1];
+
+	dtmprintk(ioc, pr_info(MPT3SAS_FMT
+		"sending tm: handle(0x%04x), task_type(0x%02x), smid(%d)\n",
+		ioc->name, handle, type, smid_task));
+	ioc->tm_cmds.status = MPT3_CMD_PENDING;
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+	ioc->tm_cmds.smid = smid;
+	memset(mpi_request, 0, sizeof(Mpi2SCSITaskManagementRequest_t));
+	memset(ioc->tm_cmds.reply, 0, sizeof(Mpi2SCSITaskManagementReply_t));
+	mpi_request->Function = MPI2_FUNCTION_SCSI_TASK_MGMT;
+	mpi_request->DevHandle = cpu_to_le16(handle);
+	mpi_request->TaskType = type;
+	mpi_request->TaskMID = cpu_to_le16(smid_task);
+	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
+	mpt3sas_scsih_set_tm_flag(ioc, handle);
+	init_completion(&ioc->tm_cmds.done);
+	mpt3sas_base_put_smid_hi_priority(ioc, smid);
+	timeleft = wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
+	if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
+		pr_err(MPT3SAS_FMT "%s: timeout\n",
+		    ioc->name, __func__);
+		_debug_dump_mf(mpi_request,
+		    sizeof(Mpi2SCSITaskManagementRequest_t)/4);
+		if (!(ioc->tm_cmds.status & MPT3_CMD_RESET)) {
+			rc = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+			    FORCE_BIG_HAMMER);
+			rc = (!rc) ? SUCCESS : FAILED;
+			ioc->tm_cmds.status = MPT3_CMD_NOT_USED;
+			mpt3sas_scsih_clear_tm_flag(ioc, handle);
+			goto err_out;
+		}
+	}
+
+	if (ioc->tm_cmds.status & MPT3_CMD_REPLY_VALID) {
+		mpt3sas_trigger_master(ioc, MASTER_TRIGGER_TASK_MANAGMENT);
+		mpi_reply = ioc->tm_cmds.reply;
+		dtmprintk(ioc, pr_info(MPT3SAS_FMT "complete tm: " \
+		    "ioc_status(0x%04x), loginfo(0x%08x), term_count(0x%08x)\n",
+		    ioc->name, le16_to_cpu(mpi_reply->IOCStatus),
+		    le32_to_cpu(mpi_reply->IOCLogInfo),
+		    le32_to_cpu(mpi_reply->TerminationCount)));
+		if (ioc->logging_level & MPT_DEBUG_TM) {
+			_scsih_response_code(ioc, mpi_reply->ResponseCode);
+			if (mpi_reply->IOCStatus)
+				_debug_dump_mf(mpi_request,
+				    sizeof(Mpi2SCSITaskManagementRequest_t)/4);
+		}
+	}
+
+	switch (type) {
+	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
+		rc = SUCCESS;
+		if (scsi_lookup->scmd == NULL)
+			break;
+		rc = FAILED;
+		break;
+
+	case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
+		if (_scsih_scsi_lookup_find_by_target(ioc, id, channel))
+			rc = FAILED;
+		else
+			rc = SUCCESS;
+		break;
+	case MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET:
+	case MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET:
+		if (_scsih_scsi_lookup_find_by_lun(ioc, id, lun, channel))
+			rc = FAILED;
+		else
+			rc = SUCCESS;
+		break;
+	case MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK:
+		rc = SUCCESS;
+		break;
+	default:
+		rc = FAILED;
+		break;
+	}
+
+	mpt3sas_scsih_clear_tm_flag(ioc, handle);
+	ioc->tm_cmds.status = MPT3_CMD_NOT_USED;
+	if (m_type == TM_MUTEX_ON)
+		mutex_unlock(&ioc->tm_cmds.mutex);
+
+	return rc;
+
+ err_out:
+	if (m_type == TM_MUTEX_ON)
+		mutex_unlock(&ioc->tm_cmds.mutex);
+	return rc;
+}
+
+/**
+ * _scsih_tm_display_info - displays info about the device
+ * @ioc: per adapter struct
+ * @scmd: pointer to scsi command object
+ *
+ * Called by task management callback handlers.
+ */
+static void
+_scsih_tm_display_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd)
+{
+	struct scsi_target *starget = scmd->device->sdev_target;
+	struct MPT3SAS_TARGET *priv_target = starget->hostdata;
+	struct _sas_device *sas_device = NULL;
+	unsigned long flags;
+	char *device_str = NULL;
+
+	if (!priv_target)
+		return;
+	device_str = "volume";
+
+	scsi_print_command(scmd);
+	if (priv_target->flags & MPT_TARGET_FLAGS_VOLUME) {
+		starget_printk(KERN_INFO, starget,
+			"%s handle(0x%04x), %s wwid(0x%016llx)\n",
+			device_str, priv_target->handle,
+		    device_str, (unsigned long long)priv_target->sas_address);
+	} else {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+		    priv_target->sas_address);
+		if (sas_device) {
+			if (priv_target->flags &
+			    MPT_TARGET_FLAGS_RAID_COMPONENT) {
+				starget_printk(KERN_INFO, starget,
+				    "volume handle(0x%04x), "
+				    "volume wwid(0x%016llx)\n",
+				    sas_device->volume_handle,
+				   (unsigned long long)sas_device->volume_wwid);
+			}
+			starget_printk(KERN_INFO, starget,
+			    "handle(0x%04x), sas_address(0x%016llx), phy(%d)\n",
+			    sas_device->handle,
+			    (unsigned long long)sas_device->sas_address,
+			    sas_device->phy);
+			starget_printk(KERN_INFO, starget,
+			    "enclosure_logical_id(0x%016llx), slot(%d)\n",
+			   (unsigned long long)sas_device->enclosure_logical_id,
+			    sas_device->slot);
+		}
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	}
+}
+
+/**
+ * _scsih_abort - eh threads main abort routine
+ * @scmd: pointer to scsi command object
+ *
+ * Returns SUCCESS if command aborted else FAILED
+ */
+static int
+_scsih_abort(struct scsi_cmnd *scmd)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	u16 smid;
+	u16 handle;
+	int r;
+
+	sdev_printk(KERN_INFO, scmd->device,
+		"attempting task abort! scmd(%p)\n", scmd);
+	_scsih_tm_display_info(ioc, scmd);
+
+	sas_device_priv_data = scmd->device->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+		sdev_printk(KERN_INFO, scmd->device,
+			"device been deleted! scmd(%p)\n", scmd);
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = SUCCESS;
+		goto out;
+	}
+
+	/* search for the command */
+	smid = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
+	if (!smid) {
+		scmd->result = DID_RESET << 16;
+		r = SUCCESS;
+		goto out;
+	}
+
+	/* for hidden raid components and volumes this is not supported */
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_RAID_COMPONENT ||
+	    sas_device_priv_data->sas_target->flags & MPT_TARGET_FLAGS_VOLUME) {
+		scmd->result = DID_RESET << 16;
+		r = FAILED;
+		goto out;
+	}
+
+	mpt3sas_halt_firmware(ioc);
+
+	handle = sas_device_priv_data->sas_target->handle;
+	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
+	    scmd->device->id, scmd->device->lun,
+	    MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK, smid, 30,
+	    scmd->serial_number, TM_MUTEX_ON);
+
+ out:
+	sdev_printk(KERN_INFO, scmd->device, "task abort: %s scmd(%p)\n",
+	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	return r;
+}
+
+/**
+ * _scsih_dev_reset - eh threads main device reset routine
+ * @scmd: pointer to scsi command object
+ *
+ * Returns SUCCESS if command aborted else FAILED
+ */
+static int
+_scsih_dev_reset(struct scsi_cmnd *scmd)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	u16	handle;
+	int r;
+
+	sdev_printk(KERN_INFO, scmd->device,
+		"attempting device reset! scmd(%p)\n", scmd);
+	_scsih_tm_display_info(ioc, scmd);
+
+	sas_device_priv_data = scmd->device->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+		sdev_printk(KERN_INFO, scmd->device,
+			"device been deleted! scmd(%p)\n", scmd);
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = SUCCESS;
+		goto out;
+	}
+
+	/* for hidden raid components obtain the volume_handle */
+	handle = 0;
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = _scsih_sas_device_find_by_handle(ioc,
+		   sas_device_priv_data->sas_target->handle);
+		if (sas_device)
+			handle = sas_device->volume_handle;
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	} else
+		handle = sas_device_priv_data->sas_target->handle;
+
+	if (!handle) {
+		scmd->result = DID_RESET << 16;
+		r = FAILED;
+		goto out;
+	}
+
+	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
+	    scmd->device->id, scmd->device->lun,
+	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30, 0,
+	    TM_MUTEX_ON);
+
+ out:
+	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
+	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	return r;
+}
+
+/**
+ * _scsih_target_reset - eh threads main target reset routine
+ * @scmd: pointer to scsi command object
+ *
+ * Returns SUCCESS if command aborted else FAILED
+ */
+static int
+_scsih_target_reset(struct scsi_cmnd *scmd)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct _sas_device *sas_device;
+	unsigned long flags;
+	u16	handle;
+	int r;
+	struct scsi_target *starget = scmd->device->sdev_target;
+
+	starget_printk(KERN_INFO, starget, "attempting target reset! scmd(%p)\n",
+		scmd);
+	_scsih_tm_display_info(ioc, scmd);
+
+	sas_device_priv_data = scmd->device->hostdata;
+	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
+		starget_printk(KERN_INFO, starget, "target been deleted! scmd(%p)\n",
+			scmd);
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		r = SUCCESS;
+		goto out;
+	}
+
+	/* for hidden raid components obtain the volume_handle */
+	handle = 0;
+	if (sas_device_priv_data->sas_target->flags &
+	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		sas_device = _scsih_sas_device_find_by_handle(ioc,
+		   sas_device_priv_data->sas_target->handle);
+		if (sas_device)
+			handle = sas_device->volume_handle;
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	} else
+		handle = sas_device_priv_data->sas_target->handle;
+
+	if (!handle) {
+		scmd->result = DID_RESET << 16;
+		r = FAILED;
+		goto out;
+	}
+
+	r = mpt3sas_scsih_issue_tm(ioc, handle, scmd->device->channel,
+	    scmd->device->id, 0, MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0,
+	    30, 0, TM_MUTEX_ON);
+
+ out:
+	starget_printk(KERN_INFO, starget, "target reset: %s scmd(%p)\n",
+	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	return r;
+}
+
+
+/**
+ * _scsih_host_reset - eh threads main host reset routine
+ * @scmd: pointer to scsi command object
+ *
+ * Returns SUCCESS if command aborted else FAILED
+ */
+static int
+_scsih_host_reset(struct scsi_cmnd *scmd)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	int r, retval;
+
+	pr_info(MPT3SAS_FMT "attempting host reset! scmd(%p)\n",
+	    ioc->name, scmd);
+	scsi_print_command(scmd);
+
+	retval = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
+	    FORCE_BIG_HAMMER);
+	r = (retval < 0) ? FAILED : SUCCESS;
+	pr_info(MPT3SAS_FMT "host reset: %s scmd(%p)\n",
+	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+
+	return r;
+}
+
+/**
+ * _scsih_fw_event_add - insert and queue up fw_event
+ * @ioc: per adapter object
+ * @fw_event: object describing the event
+ * Context: This function will acquire ioc->fw_event_lock.
+ *
+ * This adds the firmware event object into link list, then queues it up to
+ * be processed from user context.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_fw_event_add(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
+{
+	unsigned long flags;
+
+	if (ioc->firmware_event_thread == NULL)
+		return;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	INIT_LIST_HEAD(&fw_event->list);
+	list_add_tail(&fw_event->list, &ioc->fw_event_list);
+	INIT_WORK(&fw_event->work, _firmware_event_work);
+	queue_work(ioc->firmware_event_thread, &fw_event->work);
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
+/**
+ * _scsih_fw_event_free - delete fw_event
+ * @ioc: per adapter object
+ * @fw_event: object describing the event
+ * Context: This function will acquire ioc->fw_event_lock.
+ *
+ * This removes firmware event object from link list, frees associated memory.
+ *
+ * Return nothing.
+ */
+static void
+_scsih_fw_event_free(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work
+	*fw_event)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ioc->fw_event_lock, flags);
+	list_del(&fw_event->list);
+	kfree(fw_event->event_data);
+	kfree(fw_event);
+	spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
+}
+
+
+ /**
+ * mpt3sas_send_trigger_data_event - send event for processing trigger data
+ * @ioc: per adapter object
+ * @event_data: trigger event data
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_send_trigger_data_event(struct MPT3SAS_ADAPTER *ioc,
+	struct SL_WH_TRIGGERS_EVENT_DATA_T *event_data)
+{
+	struct fw_event_work *fw_event;
+
+	if (ioc->is_driver_loading)
+		return;
+	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event)
+		return;
+	fw_event->event_data = kzalloc(sizeof(*event_data), GFP_ATOMIC);
+	if (!fw_event->event_data)
+		return;
+	fw_event->event = MPT3SAS_PROCESS_TRIGGER_DIAG;
+	fw_event->ioc = ioc;
+	memcpy(fw_event->event_data, event_data, sizeof(*event_data));
+	_scsih_fw_event_add(ioc, fw_event);
+}
+
+/**
+ * _scsih_error_recovery_delete_devices - remove devices not responding
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_scsih_error_recovery_delete_devices(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct fw_event_work *fw_event;
+
+	if (ioc->is_driver_loading)
+		return;
+	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event)
+		return;
+	fw_event->event = MPT3SAS_REMOVE_UNRESPONDING_DEVICES;
+	fw_event->ioc = ioc;
+	_scsih_fw_event_add(ioc, fw_event);
+}
+
+/**
+ * mpt3sas_port_enable_complete - port enable completed (fake event)
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+void
+mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct fw_event_work *fw_event;
+
+	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event)
+		return;
+	fw_event->event = MPT3SAS_PORT_ENABLE_COMPLETE;
+	fw_event->ioc = ioc;
+	_scsih_fw_event_add(ioc, fw_event);
+}
+
+/**
+ * _scsih_fw_event_cleanup_queue - cleanup event queue
+ * @ioc: per adapter object
+ *
+ * Walk the firmware event queue, either killing timers, or waiting
+ * for outstanding events to complete
+ *
+ * Return nothing.
+ */
+static void
+_scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct fw_event_work *fw_event, *next;
+
+	if (list_empty(&ioc->fw_event_list) ||
+	     !ioc->firmware_event_thread || in_interrupt())
+		return;
+
+	list_for_each_entry_safe(fw_event, next, &ioc->fw_event_list, list) {
+		if (cancel_delayed_work(&fw_event->delayed_work)) {
+			_scsih_fw_event_free(ioc, fw_event);
+			continue;
+		}
+		fw_event->cancel_pending_work = 1;
+	}
+}
+
+/**
+ * _scsih_ublock_io_all_device - unblock every device
+ * @ioc: per adapter object
+ *
+ * change the device state from block to running
+ */
+static void
+_scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (!sas_device_priv_data->block)
+			continue;
+
+		sas_device_priv_data->block = 0;
+		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev,
+			"device_running, handle(0x%04x)\n",
+		    sas_device_priv_data->sas_target->handle));
+		scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+	}
+}
+
+
+/**
+ * _scsih_ublock_io_device - prepare device to be deleted
+ * @ioc: per adapter object
+ * @sas_addr: sas address
+ *
+ * unblock then put device in offline state
+ */
+static void
+_scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->sas_target->sas_address
+		    != sas_address)
+			continue;
+		if (sas_device_priv_data->block) {
+			sas_device_priv_data->block = 0;
+			scsi_internal_device_unblock(sdev, SDEV_RUNNING);
+		}
+	}
+}
+
+/**
+ * _scsih_block_io_all_device - set the device state to SDEV_BLOCK
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * During device pull we need to appropiately set the sdev state.
+ */
+static void
+_scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->block)
+			continue;
+		sas_device_priv_data->block = 1;
+		scsi_internal_device_block(sdev);
+		sdev_printk(KERN_INFO, sdev, "device_blocked, handle(0x%04x)\n",
+		    sas_device_priv_data->sas_target->handle);
+	}
+}
+
+/**
+ * _scsih_block_io_device - set the device state to SDEV_BLOCK
+ * @ioc: per adapter object
+ * @handle: device handle
+ *
+ * During device pull we need to appropiately set the sdev state.
+ */
+static void
+_scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+{
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, ioc->shost) {
+		sas_device_priv_data = sdev->hostdata;
+		if (!sas_device_priv_data)
+			continue;
+		if (sas_device_priv_data->sas_target->handle != handle)
+			continue;
+		if (sas_device_priv_data->block)
+			continue;
+		sas_device_priv_data->block = 1;
+		scsi_internal_device_block(sdev);
+		sdev_printk(KERN_INFO, sdev,
+			"device_blocked, handle(0x%04x)\n", handle);
+	}
+}
+
+/**
+ * _scsih_block_io_to_children_attached_to_ex
+ * @ioc: per adapter object
+ * @sas_expander: the sas_device object
+ *
+ * This routine set sdev state to SDEV_BLOCK for all devices
+ * attached to this expander. This function called when expander is
+ * pulled.
+ */
+static void
+_scsih_block_io_to_children_attached_to_ex(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_node *sas_expander)
+{
+	struct _sas_port *mpt3sas_port;
+	struct _sas_device *sas_device;
+	struct _sas_node *expander_sibling;
+	unsigned long flags;
+
+	if (!sas_expander)
+		return;
+
+	list_for_each_entry(mpt3sas_port,
+	   &sas_expander->sas_port_list, port_list) {
+		if (mpt3sas_port->remote_identify.device_type ==
+		    SAS_END_DEVICE) {
+			spin_lock_irqsave(&ioc->sas_device_lock, flags);
+			sas_device =
+			    mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
+			   mpt3sas_port->remote_identify.sas_address);
+			if (sas_device)
+				set_bit(sas_device->handle,
+				    ioc->blocking_handles);
+			spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+		}
+	}
+
+	list_for_each_entry(mpt3sas_port,
+	   &sas_expander->sas_port_list, port_list) {
+
+		if (mpt3sas_port->remote_identify.device_type ==
+		    SAS_EDGE_EXPANDER_DEVICE ||
+		    mpt3sas_port->remote_identify.device_type ==
+		    SAS_FANOUT_EXPANDER_DEVICE) {
+			expander_sibling =
+			    mpt3sas_scsih_expander_find_by_sas_address(
+			    ioc, mpt3sas_port->remote_identify.sas_address);
+			_scsih_block_io_to_children_attached_to_ex(ioc,
+			    expander_sibling);
+		}
+	}
+}
+
+/**
+ * _scsih_block_io_to_children_attached_directly
+ * @ioc: per adapter object
+ * @event_data: topology change event data
+ *
+ * This routine set sdev state to SDEV_BLOCK for all devices
+ * direct attached during device pull.
+ */
+static void
+_scsih_block_io_to_children_attached_directly(struct MPT3SAS_ADAPTER *ioc,
+	Mpi2EventDataSasTopologyChangeList_t *event_data)
+{
+	int i;
+	u16 handle;
+	u16 reason_code;
+	u8 phy_number;
+
+	for (i = 0; i < event_data->NumEntries; i++) {
+		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
+		if (!handle)
+			continue;
+		phy_number = event_data->StartPhyNum + i;
+		reason_code = event_data->PHY[i].PhyStatus &
+		    MPI2_EVENT_SAS_TOPO_RC_MASK;
+		if (reason_code == MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING)
+			_scsih_block_io_device(ioc, handle);
+	}
+}
