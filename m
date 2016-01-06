From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH] add driver for DesignWare UFS Host Controller
Date: Wed,  6 Jan 2016 17:27:59 +0000
Message-ID: <c6de799a23c6626b95ccdcb89ba0b2341b441fa0.1450293353.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:53419 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbcAFR2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 12:28:07 -0500
Received: from dc8secmta1.synopsys.com (dc8secmta1.synopsys.com [10.13.218.200])
	by smtprelay.synopsys.com (Postfix) with ESMTP id A4AD110C04C3
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2016 09:28:06 -0800 (PST)
Received: from dc8secmta1.internal.synopsys.com (dc8secmta1.internal.synopsys.com [127.0.0.1])
	by dc8secmta1.internal.synopsys.com (Service) with ESMTP id A0E5527113
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2016 09:28:06 -0800 (PST)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
	by dc8secmta1.internal.synopsys.com (Service) with ESMTP id 1D3B327102
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jan 2016 09:28:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: CARLOS.PALMINHA@synopsys.com, Joao Pinto <Joao.Pinto@synopsys.com>

This driver patch includes a core driver and glue drivers for pci and p=
latform
for the DesignWare UFS Host IP.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
 .../devicetree/bindings/ufs/dwc_ufshcd-pltfm.txt   |   17 +
 MAINTAINERS                                        |    7 +
 drivers/scsi/Makefile                              |    1 +
 drivers/scsi/ufs/Kconfig                           |    3 +
 drivers/scsi/ufs/dwufs/Kconfig                     |   53 +
 drivers/scsi/ufs/dwufs/Makefile                    |    3 +
 drivers/scsi/ufs/dwufs/dwc_ufshcd-core.c           | 4000 ++++++++++++=
++++++++
 drivers/scsi/ufs/dwufs/dwc_ufshcd-core.h           |   61 +
 drivers/scsi/ufs/dwufs/dwc_ufshcd-hci.h            |  958 +++++
 drivers/scsi/ufs/dwufs/dwc_ufshcd-mphy.h           |   55 +
 drivers/scsi/ufs/dwufs/dwc_ufshcd-pci.c            |  280 ++
 drivers/scsi/ufs/dwufs/dwc_ufshcd-pltfm.c          |  168 +
 drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.c           |  780 ++++
 drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.h           |   29 +
 drivers/scsi/ufs/dwufs/dwc_ufshcd-ufs.h            |  457 +++
 drivers/scsi/ufs/dwufs/dwc_ufshcd-unipro.h         |   40 +
 16 files changed, 6912 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/dwc_ufshcd-pl=
tfm.txt
 create mode 100644 drivers/scsi/ufs/dwufs/Kconfig
 create mode 100644 drivers/scsi/ufs/dwufs/Makefile
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-core.c
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-core.h
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-hci.h
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-mphy.h
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-pltfm.c
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.c
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.h
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-ufs.h
 create mode 100644 drivers/scsi/ufs/dwufs/dwc_ufshcd-unipro.h

diff --git a/Documentation/devicetree/bindings/ufs/dwc_ufshcd-pltfm.txt=
 b/Documentation/devicetree/bindings/ufs/dwc_ufshcd-pltfm.txt
new file mode 100644
index 0000000..cd387e4
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/dwc_ufshcd-pltfm.txt
@@ -0,0 +1,17 @@
+* Universal Flash Storage (UFS) DesignWare Host Controller
+
+DWC_UFSHC nodes are defined to describe on-chip UFS host controllers.
+Each UFS controller instance should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "snps,dwc_ufshcd"
+- reg               : <registers mapping>
+- interrupts        : <interrupt mapping for UFS host controller IRQ>
+
+Example:
+	dwc_ufshcd@0xD0000000 {
+		compatible =3D "synopsys,dwc_ufshcd";
+		reg =3D < 0xD0000000 0x10000 >;
+		interrupts =3D < 24 >;
+	};
+
diff --git a/MAINTAINERS b/MAINTAINERS
index 2d3d55c..a83a5d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10534,6 +10534,13 @@ S:	Supported
 F:	Documentation/scsi/ufs.txt
 F:	drivers/scsi/ufs/
=20
+DESIGNWARE UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
+M:	Joao Pinto <Joao.Pinto@synopsys.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	Documentation/scsi/ufs.txt
+F:	drivers/scsi/ufs/dwufs/
+
 UNSORTED BLOCK IMAGES (UBI)
 M:	Artem Bityutskiy <dedekind1@gmail.com>
 M:	Richard Weinberger <richard@nod.at>
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 91209e3..eddfddc 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -108,6 +108,7 @@ obj-$(CONFIG_MEGARAID_SAS)	+=3D megaraid/
 obj-$(CONFIG_SCSI_MPT2SAS)	+=3D mpt2sas/
 obj-$(CONFIG_SCSI_MPT3SAS)	+=3D mpt3sas/
 obj-$(CONFIG_SCSI_UFSHCD)	+=3D ufs/
+obj-$(CONFIG_SCSI_DWC_UFS_HOST)	+=3D ufs/dwufs/
 obj-$(CONFIG_SCSI_ACARD)	+=3D atp870u.o
 obj-$(CONFIG_SCSI_SUNESP)	+=3D esp_scsi.o	sun_esp.o
 obj-$(CONFIG_SCSI_GDTH)		+=3D gdth.o
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e945383..9eac4be 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -83,3 +83,6 @@ config SCSI_UFS_QCOM
=20
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
+
+source "drivers/scsi/ufs/dwufs/Kconfig"
+
diff --git a/drivers/scsi/ufs/dwufs/Kconfig b/drivers/scsi/ufs/dwufs/Kc=
onfig
new file mode 100644
index 0000000..747578f
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/Kconfig
@@ -0,0 +1,53 @@
+#
+# UFS Host driver for Synopsys Designware Core
+#
+# Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+#
+# Authors: Joao Pinto <jpinto@synopsys.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+config SCSI_DWC_UFS_HOST
+	bool "Designware UFS Host Controller"
+	depends on SCSI
+
+config SCSI_DWC_UFS_PCI
+	tristate "PCI bus based Designware UFS Controller support"
+	depends on SCSI_DWC_UFS_HOST && PCI
+
+config SCSI_DWC_UFS_64BIT
+	bool "Use 64-bit addressing"
+	depends on SCSI_DWC_UFS_PCI
+	---help---
+	Enables 64-bit addressing support if available; otherwise reverts to
+	 32-bit addressing mode.
+
+config SCSI_DWC_UFS_PLATFORM
+	tristate "Platform bus based Designware UFS Controller support"
+	depends on SCSI_DWC_UFS_HOST
+
+config SCSI_DWC_UFS_MPHY_TC
+	bool "Synopsys MPHY testchip as physical interface"
+	depends on SCSI_DWC_UFS_HOST
+	---help---
+	Enables the driver to use Synopsys MPHY testchip as physical interfac=
e.
+	 Without this option, it assumes TMPI interface as the underlying PHY
+	 interface.
+
+config SCSI_DWC_UFS_MPHY_TC_GEN2
+	bool "Synopsys MPHY testchip Gen2 as physical interface"
+	depends on SCSI_DWC_UFS_MPHY_TC
+	---help---
+	Enables the driver to work with Synopsys MPHY Test Chips on both host
+	 and device side.
+
+config SCSI_DWC_UFS_40BIT_RMMI
+	bool "40-bit RMMI interface"
+	depends on SCSI_DWC_UFS_MPHY_TC
+	---help---
+	Enables the driver to use 40-bit RMMI interface.
+
+
diff --git a/drivers/scsi/ufs/dwufs/Makefile b/drivers/scsi/ufs/dwufs/M=
akefile
new file mode 100644
index 0000000..31aeedd
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SCSI_DWC_UFS_HOST) +=3D dwc_ufshcd-scsi.o dwc_ufshcd-core=
=2Eo
+obj-$(CONFIG_SCSI_DWC_UFS_PCI) +=3D dwc_ufshcd-pci.o
+obj-$(CONFIG_SCSI_DWC_UFS_PLATFORM) +=3D dwc_ufshcd-pltfm.o
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-core.c b/drivers/scsi/uf=
s/dwufs/dwc_ufshcd-core.c
new file mode 100644
index 0000000..1a21f1a
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-core.c
@@ -0,0 +1,4000 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Manjunath Bettegowda <manjumb@synopsys.com>,
+ *	    Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>	/* Linux delays */
+
+#include <asm/byteorder.h>	/* cpu_to_bexx(), cpu_to_lexx()*/
+#include <scsi/scsi_host.h>	/* Linux Scsi Subsytem */
+#include <scsi/scsi_tcq.h>	/* Linux scsi_init_shared_tag_map() */
+
+#include "dwc_ufshcd-ufs.h"
+#include "dwc_ufshcd-hci.h"
+#include "dwc_ufshcd-scsi.h"
+#include "dwc_ufshcd-core.h"
+#include "dwc_ufshcd-unipro.h"
+#include "dwc_ufshcd-mphy.h"
+
+#define dwc_ufs_hostname(x)	(dev_name((x)->gdev))
+
+static struct dwc_ufs_hba *static_ufs_hba;
+
+/**
+ * dwc_ufs_readl
+ * The Low level function to read long or double word (32 bit value).
+ * @param[in] Base address pointer
+ * @param[in] Offset from the base
+ * \return  Returns the double word value from provided address
+ */
+static inline u32 dwc_ufs_readl(void *ioaddr, u32 offset)
+{
+	return readl(ioaddr + offset);
+}
+
+/**
+ * dwc_ufs_writel
+ * The Low level function to write a double word or long (32 bit value=
).
+ * @param[in] Byte data to be written
+ * @param[in] Base address pointer
+ * @param[in] Offset from the base
+ */
+static inline void dwc_ufs_writel(u32 data, void *ioaddr, u32 offset)
+{
+	writel(data, (ioaddr + offset));
+}
+
+/**
+ * dwc_ufshcd_get_utrd_ocs()
+ * Get the OCS value from utrd
+ * @lrb: pointer to local command reference block containing
+ * required UTRD
+ *
+ * Returns the OCS field in the UTRD
+ */
+static inline u8 dwc_ufshcd_get_utrd_ocs(struct dwc_ufs_hcd_lrb *lrb)
+{
+	return lrb->utrd->ocs;
+}
+
+/**
+ * dwc_ufshcd_get_xfer_req_free_slot()
+ * This function returns the first (lower index) free slot available t=
o issue
+ * Device management command.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns nutrs number if all slots or full else returns the index lo=
wer free
+ * slot on if available
+ */
+static inline int dwc_ufshcd_get_xfer_req_free_slot(struct dwc_ufs_hba=
 *hba)
+{
+	return find_first_zero_bit(&hba->outstanding_dm_requests, hba->nutrs)=
;
+}
+
+/**
+ * dwc_ufshcd_send_dm_req_command()
+ * Send Device management command by setting the door bell for appropi=
rate
+ * slot.
+ * Note: This driver architectures treats DM command outside data tran=
sfer
+ * command. Dvice management command is supposed to be sent when there=
 is
+ * no data transfer commands are pending; If this is not taken care of
+ * result/behavior of the driver is undefined.
+ * @hba: Pointer to drivers structure
+ * @free_slot: index of free slot in transfer req list
+ *
+ */
+static inline void dwc_ufshcd_send_dm_req_command(struct dwc_ufs_hba *=
hba,
+					 unsigned int free_slot)
+{
+	set_bit(free_slot, &hba->outstanding_dm_requests);
+	dwc_ufs_writel((1 << free_slot), hba->mmio_base, DWC_UFS_REG_UTRLDBR)=
;
+}
+
+/**
+ * dwc_ufshcd_send_tm_req_command()
+ * Send TM Request command by setting the door bell for appropirate
+ * slot in UTMR doorbell register.
+ * @hba: Pointer to drivers structure
+ * @free_slot: index of free slot in TM Req Queue
+ *
+ */
+static inline void dwc_ufshcd_send_tm_req_command(struct dwc_ufs_hba *=
hba,
+					 unsigned int free_slot)
+{
+	set_bit(free_slot, &hba->outstanding_tm_tasks);
+	dwc_ufs_writel((1 << free_slot), hba->mmio_base, DWC_UFS_REG_UTMRLDBR=
);
+}
+
+/**
+ * dwc_ufshcd_get_tm_free_slot
+ * This function returns the first (lower index) free slot available t=
o issue
+ * task management command.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns nutmrs number if all slots or full else returns the index l=
ower free
+ * slot on if available
+ */
+static inline int dwc_ufshcd_get_tm_free_slot(struct dwc_ufs_hba *hba)
+{
+	return find_first_zero_bit(&hba->outstanding_tm_tasks, hba->nutmrs);
+}
+
+/**
+ * dwc_ufshcd_send_xfer_req_command()
+ * Send SCSI/Native UFS Commands (not device management command) by se=
tting
+ * the door bell for appropriate slot
+ * Note: This driver architectures treats DM command outside data tran=
sfer
+ * command. Dvice management command is supposed to be sent when there=
 is
+ * no data transfer commands are pending; If this is not taken care of
+ * result/behavior of the driver is undefined.
+ * @hba: Pointer to drivers structure
+ * @task_tag: Task tag of the command; used as slot index
+ *
+ */
+void dwc_ufshcd_send_xfer_req_command(struct dwc_ufs_hba *hba,
+					 unsigned int task_tag)
+{
+	set_bit(task_tag, &hba->outstanding_xfer_reqs);
+	dwc_ufs_writel((1 << task_tag), hba->mmio_base, DWC_UFS_REG_UTRLDBR);
+}
+
+/**
+ * dwc_ufshcd_get_hba_handle()
+ * This function returns the handle to hba.
+ * The need for this approach of maintining the static reference to hb=
a
+ * arises to support debugging.
+ *
+ * Returns reference to drivers private structure
+ */
+struct dwc_ufs_hba *dwc_ufshcd_get_hba_handle(void)
+{
+	return static_ufs_hba;
+}
+
+/**
+ * dwc_ufshcd_prepare_xfer_cmd_upiu()
+ * Prepare UFS Protocol Information Unit(UPIU)
+ * Generally this function is called by adaptation layers such as SCSI=
=2E
+ * This function still knows about the scsi information.
+ * This function
+ * Updates the UTRD with:
+ *  - command type and flags
+ *  - ocs is programmed to invalid status
+ * Updates the UPIU with:
+ *  - transaction type
+ *  - flags
+ *  - lun
+ *  - task_tag(For SCSI Midlayer provides the unique tag)
+ *  - command set type
+ *  - expected transfer length
+ * Copies the CDB to cmd_upiu->cdb
+ * @lrb - pointer to local reference block
+ *
+ */
+void dwc_ufshcd_prepare_xfer_cmd_upiu(struct dwc_ufs_hcd_lrb *lrb)
+{
+	struct dwc_ufs_utrd *utrd;
+	struct dwc_ufs_cmd_upiu	*cmd_upiu;
+
+	cmd_upiu =3D lrb->cmd_upiu;
+
+	utrd =3D lrb->utrd;
+
+	switch (lrb->command_type) {
+	case DWC_UTRD_CMD_TYPE_SCSI:
+	case DWC_UTRD_CMD_TYPE_UFS_STORAGE:
+		/* Set Command Type and Flags */
+		utrd->ct_and_flags =3D lrb->data_direction |
+					lrb->command_type;
+
+		/* Set OCS to invalid value */
+		utrd->ocs =3D OCS_INVALID_COMMAND_STATUS;
+
+		/* UPIU Command formation */
+		memset(cmd_upiu, 0, sizeof(struct dwc_ufs_cmd_upiu));
+		cmd_upiu->trans_type =3D UPIU_TRANS_CODE_CMD;
+		cmd_upiu->flags =3D lrb->read_write_flags;
+		cmd_upiu->lun =3D lrb->lun;
+		cmd_upiu->task_tag =3D lrb->task_tag;
+
+		cmd_upiu->cmd_set_type =3D UPIU_CMD_SET_TYPE_SCSI;
+
+		/* Total EHS length and Data segment length will be
+		 * zero
+		 */
+		cmd_upiu->tot_ehs_len =3D 0;
+		cmd_upiu->data_seg_len =3D 0;
+
+		/* Data Transfer Length is given by scsi command */
+		cmd_upiu->exp_data_xfer_len =3D
+					cpu_to_be32(lrb->transfer_size);
+		/* Copy the CDB */
+		dwc_ufshcd_copy_cdb(cmd_upiu->cdb, lrb);
+
+		/* As per JESD220 ModeSense10 DBD should be '1' */
+		if (cmd_upiu->cdb[0]  =3D=3D 0x5a)
+			cmd_upiu->cdb[1] |=3D 0x08; /* Set DBD to =E2=80=981=E2=80=99 */
+			break;
+	default:
+		break;
+	}
+}
+
+/**
+ * dwc_ufshcd_clear_xfer_req()
+ * This function is to abort the pending task by clearing the UTP  Tra=
nsfer
+ * Request list clear register forcibly.
+ * @hba: Pointer to drivers structure
+ * @slot_index: slot_index to be cleared
+ *
+ */
+void dwc_ufshcd_clear_xfre_req(struct dwc_ufs_hba *hba, u32 slot_index=
)
+{
+	dwc_ufs_writel(~(1 << slot_index), hba->mmio_base,
+				DWC_UFS_REG_UTRLCLR);
+}
+
+/**
+ * dwc_ufshcd_clear_tm_task_req()
+ * This function is to abort the pending task by clearing the UTP Task
+ * management request list celar register forcibly.
+ * @hba: Pointer to drivers structure
+ * @slot_index: slot_index to be cleared
+ */
+void dwc_ufshcd_clear_tm_task_req(struct dwc_ufs_hba *hba, u32 slot_in=
dex)
+{
+	dwc_ufs_writel(~(1 << slot_index), hba->mmio_base,
+				DWC_UFS_REG_UTMRLCLR);
+}
+
+/**
+ * dwc_ufshcd_tm_req_completion_handler()
+ * This function handles task management request completion. The funct=
ion
+ * executes when wait queue is woken up from ISR or timeout happens.
+ * it clears
+ *  - the outstanding request and the condition for the slot in questi=
on
+ *  - updates the result value based on OCS and response
+ * @hba: Pointer to drivers structure
+ * @tm_slot: index of the completed request
+ *
+ * Returns zero on success or non zero value on failure
+ */
+int dwc_ufshcd_tm_req_completion_handler(struct dwc_ufs_hba *hba, u32 =
tm_slot)
+{
+	int result =3D SUCCESS;
+	struct dwc_ufs_utmrd *utmrd;
+	struct dwc_ufs_tm_resp_upiu *tm_resp_upiu;
+	struct dwc_ufs_tm_desc_hdr *tm_desc_hdr;
+	unsigned long flags_irq;
+	u8 ocs;
+	u8 response =3D 0;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Clear completed tasks from outstanding_tasks */
+	clear_bit(tm_slot, &hba->outstanding_tm_tasks);
+	clear_bit(tm_slot, &hba->dwc_ufshcd_tm_condition);
+
+	utmrd =3D hba->utmrl_base_addr;
+	tm_desc_hdr =3D &(utmrd->tm_desc_hdr);
+	ocs =3D tm_desc_hdr->ocs;
+
+	if (ocs =3D=3D OCS_SUCCESS) {
+		tm_resp_upiu =3D	&(utmrd[tm_slot].tm_resp_upiu);
+		response =3D tm_resp_upiu->response;
+
+		if ((response !=3D UPIU_TM_FUNC_COMPL) ||
+				(response =3D=3D UPIU_TM_FUNC_SUCCEEDED)) {
+			result =3D FAILED;
+		}
+	} else {
+		result =3D FAILED;
+	}
+
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+	return result;
+}
+
+/**
+ * dwc_ufshcd_issue_tm_cmd
+ * Issues task management commands to controller
+ * This function calls the function to set task managemetn request
+ * descriptor doorbell after
+ *  - setting up task management request descriptor for the slot
+ *  - preparing the task management request upiu
+ * After sending the command, the control waits on wait queue
+ * Once control resumes, dwc_ufshcd_tm_req_completion_handler() functi=
on is
+ * called. Return value from the handler function is returned as is it=
 to the
+ * caller.
+ * @hba: Pointer to drivers structure
+ * @lrb: pointer to local reference block
+ * @tm_fn: task management function to be issued
+ *
+ * Note: Not to be called when blocking is not allowed (e.g: ISR)
+ *
+ * Returns 0 on success, non zero value on failure
+ */
+int dwc_ufshcd_issue_tm_cmd(struct dwc_ufs_hba *hba,
+				struct dwc_ufs_hcd_lrb *lrb, u8 tm_fn)
+{
+	int result =3D 0;
+	int free_tm_slot =3D 0;
+	struct dwc_ufs_utmrd *utmrd;
+	struct dwc_ufs_tm_req_upiu *tm_req_upiu;
+	struct dwc_ufs_tm_desc_hdr *tm_desc_hdr;
+	struct Scsi_Host *shost;
+	unsigned long flags_irq;
+
+	shost =3D hba->shost;
+
+	spin_lock_irqsave(shost->host_lock, flags_irq);
+
+	/* If task management queue is full */
+	free_tm_slot =3D dwc_ufshcd_get_tm_free_slot(hba);
+	if (free_tm_slot >=3D hba->nutmrs) {
+		spin_unlock_irqrestore(shost->host_lock, flags_irq);
+		pr_err("TM queue is full\n");
+		result =3D FAILED;
+		goto err_tm_queue_is_full;
+	}
+
+	/* Get the base address of TM Req list base address */
+	utmrd =3D hba->utmrl_base_addr;
+	/* Get the descriptor at the free slot */
+	utmrd +=3D free_tm_slot;
+
+	/* Configure task management request descriptor */
+	tm_desc_hdr =3D &(utmrd->tm_desc_hdr);
+	tm_desc_hdr->intr_flag =3D DWC_UTMRD_INTR;
+	tm_desc_hdr->ocs =3D OCS_INVALID_COMMAND_STATUS;
+
+	/* Configure task management request UPIU */
+	tm_req_upiu =3D &(utmrd->tm_req_upiu);
+	tm_req_upiu->trans_type =3D UPIU_TRANS_CODE_TASK_REQ;
+	tm_req_upiu->flags =3D 0;
+	tm_req_upiu->lun =3D lrb->lun;
+	tm_req_upiu->task_tag =3D lrb->task_tag;
+	tm_req_upiu->tm_fn =3D tm_fn;
+	tm_req_upiu->tot_ehs_len =3D 0;
+	tm_req_upiu->input_param_1[3] =3D lrb->lun;
+	tm_req_upiu->input_param_2[3] =3D lrb->task_tag;
+
+	/* send command to the controller */
+	dwc_ufshcd_send_tm_req_command(hba, free_tm_slot);
+
+	spin_unlock_irqrestore(shost->host_lock, flags_irq);
+
+	/* wait until the task management command is completed */
+	/*TODO: Is this architecture can blocks multiple tm requests? */
+	result =3D
+		wait_event_interruptible_timeout(hba->dwc_ufshcd_tm_wait_queue,
+				(test_bit(free_tm_slot,
+					  &hba->dwc_ufshcd_tm_condition) !=3D 0),
+				DWC_UFS_TM_TIMEOUT);
+
+	if (result =3D=3D 0) {
+		pr_err("Task Management Req Timed-out\n");
+
+		/* Clear TM request, Condition, doorbell */
+		clear_bit(free_tm_slot, &hba->dwc_ufshcd_tm_condition);
+		clear_bit(free_tm_slot, &hba->outstanding_tm_tasks);
+		dwc_ufshcd_clear_tm_task_req(hba, free_tm_slot);
+
+		result =3D FAILED;
+		goto err_tm_req_timeout;
+	} else
+		result =3D
+			dwc_ufshcd_tm_req_completion_handler(hba, free_tm_slot);
+
+err_tm_req_timeout:
+err_tm_queue_is_full:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_reset_hba()
+ * This is generally called by higher layer e.g scsi to abort all
+ * outstanding commands and do the host controller reset and reinitial=
ization
+ * This function
+ *  - Blocks the higher layer requests (scsi here)
+ *  - driver state is changed to reset state
+ *  - stop the host by clearing the enable bit in HCE
+ *  - Abort all outstanding transfers
+ *  - starts initialization be enabling the HC
+ *  - program the clock divider
+ *  - Reinitialize the descriptor pointers to HC registers
+ *  - Initiate link startup
+ *  - Do connection setup
+ *  - Kick start HBA
+ *  - Initialize ufs device
+ *  - kick start stack
+ * @hba: Pointer to drivers structure
+ *
+ * Returns Zero on success, non zero value on failure
+ */
+int dwc_ufshcd_reset_hba(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+	int link_startup_retries =3D 0;
+	struct dwc_ufs_hcd_lrb *lrb;
+	unsigned long flags_irq;
+	int tag;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+	dwc_ufshcd_set_hcd_state(hba, DWC_UFSHCD_STATE_RESET);
+
+	/* send controller to reset state */
+	dwc_ufshcd_stop_host(hba);
+
+	/* This is delay is used as stop host doesnot wait until
+	 * HCE bit is zero */
+	mdelay(100);
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* Clear any interrupts if any*/
+	dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_IS);
+
+	/* FOR UFS2.0 above Host controllers, the interrupt status is Write
+	 * to Clear
+	 */
+	if (hba->dwc_ufs_version =3D=3D DWC_UFS_HC_VERSION_2_0)
+		dwc_ufs_writel(0xffffffff, hba->mmio_base, DWC_UFS_REG_IS);
+
+	/* abort outstanding commands */
+	for (tag =3D 0; tag < hba->nutrs; tag++) {
+		if (test_bit(tag, &hba->outstanding_xfer_reqs)) {
+			lrb =3D &hba->lrb[tag];
+			dwc_ufshcd_unmap_dma(lrb);
+			lrb->scmd->result =3D DID_RESET << 16;
+			lrb->scmd->scsi_done(lrb->scmd);
+			lrb->scmd =3D NULL;
+		}
+	}
+
+	/*TODO: is scanning over outstanding tm tasks required? */
+	/* clear outstanding request/task bit maps */
+	hba->outstanding_xfer_reqs =3D 0;
+	hba->outstanding_dm_requests =3D 0;
+	hba->outstanding_tm_tasks =3D 0;
+
+	for (link_startup_retries =3D 0;
+			link_startup_retries < DWC_UFS_RETRY_COUNT_LINKSTARTUP;
+			link_startup_retries++) {
+
+		/* start the initialization process */
+		if (dwc_ufshcd_host_enable(hba))
+			return FAILED;
+
+		/* Program Clock Divider Value */
+		dwc_ufshcd_program_clk_div(hba, DWC_UFSHCD_CLK_DIV_125);
+
+		if (dwc_ufshcd_initialize_hba_desc_pointers(hba)) {
+			pr_err("Desc Base-Address Initialization Failed\n");
+			return FAILED;
+		}
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC
+		/* Initiate Synopsys MPHY */
+		result =3D dwc_ufs_dme_setup_snps_mphy(hba,
+						DWC_UFS_HCD_DME_INTR_DISABLE);
+		if (result !=3D 0)
+			goto err_dme_setup_snps_mphy;
+
+		pr_info("SNPS Mphy Setup Successful\n");
+#endif
+		/* Initiate Unipro Link Startup Procedure */
+		result =3D dwc_ufs_dme_linkstartup(hba,
+						DWC_UFS_HCD_DME_INTR_ENABLE);
+		if (result !=3D 0)
+			pr_info("Link Startup Failed %d times\n",
+					link_startup_retries+1);
+
+		/* IF the UIC is busy no point in retrying */
+		if (result =3D=3D -EIO)
+			goto err_dme_link_startup_cmd_sending;
+		else if (result =3D=3D 0) {
+			result =3D dwc_ufshcd_get_dme_command_results(hba);
+			if (result =3D=3D 0) {
+
+				dwc_ufs_dme_get(hba, UFS_LINK_STATUS, 0,
+						DWC_UFS_HCD_DME_INTR_DISABLE);
+
+				dwc_ufshcd_get_dme_command_results(hba);
+				if (hba->active_dme_cmd.argument3 !=3D 2)
+					goto err_dme_link_startup;
+
+				break;
+			}
+		}
+	}
+
+	if (link_startup_retries =3D=3D DWC_UFS_RETRY_COUNT_LINKSTARTUP) {
+		pr_info("LinkStartup Failed after %d attempts\n",
+			DWC_UFS_RETRY_COUNT_LINKSTARTUP);
+		goto err_dme_link_startup;
+	}
+
+	/* Update the Link information */
+	pr_debug("Updating the Link Informatin\n");
+	result =3D dwc_ufs_update_link_info(hba, DWC_UFS_HCD_DME_INTR_DISABLE=
);
+
+	/* Do the connection setup on both Host and Device
+	 * This may be redundant operation with any UFS device, but executing
+	 * this is no harm */
+	result =3D dwc_ufs_do_dme_connection_setup(hba,
+						DWC_UFS_HCD_DME_INTR_DISABLE);
+	if (result !=3D 0)
+		goto err_dme_connection_setup;
+
+	/* Kick start host bus adapter for data transfer operation */
+	if (dwc_ufshcd_kick_start_hba(hba) !=3D 0) {
+		pr_err("Hba is not operational\n");
+		goto err_ufs_kick_start_hba;
+	}
+
+	/* Initialize the device */
+	result =3D dwc_ufs_initialize_ufs_device(hba);
+
+	if (result !=3D 0)
+		goto err_ufs_initialize_device;
+
+	/* Set the state of the hba as operational */
+	dwc_ufshcd_set_hcd_state(hba, DWC_UFSHCD_STATE_OPERATIONAL);
+
+	goto successful_return;
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC
+err_dme_setup_snps_mphy:
+#endif
+err_dme_link_startup:
+err_dme_link_startup_cmd_sending:
+err_ufs_kick_start_hba:
+err_ufs_initialize_device:
+err_dme_connection_setup:
+	dwc_ufshcd_set_hcd_state(hba, DWC_UFSHCD_STATE_ERROR);
+successful_return:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_read_caps()
+ * Read DWC UFS controller capabilities.
+ * the driver's private element are updated with supported number of t=
ransfer
+ * request and task management slots.
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_read_caps(struct dwc_ufs_hba *hba)
+{
+	hba->caps =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_CAP);
+
+	/* Update number of UTP Task management Request Slots(NUTMRS) */
+	hba->nutrs  =3D (hba->caps & DWC_UFS_NUTRS_MASK) + 1;
+
+	/* Update number of of UTP Transfer Request Slots (NUTRS) */
+	hba->nprtts =3D ((hba->caps & DWC_UFS_NUTRS_MASK) >>
+			DWC_UFS_NPRTTS_SHIFT) + 1;
+
+	/* Update number of of UTP Transfer Request Slots (NUTMRS) */
+	hba->nutmrs =3D ((hba->caps & DWC_UFS_NUTMRS_MASK) >>
+			DWC_UFS_NUTMRS_SHIFT) + 1;
+
+	/* Update Auto Hibernate Support */
+	hba->autoh8 =3D ((hba->caps & DWC_UFS_AUTOH8) >> DWC_UFS_AUTOH8_SHIFT=
);
+
+	/* Update 64 bit Addressing Support */
+	hba->as64   =3D ((hba->caps & DWC_UFS_64AS) >> DWC_UFS_64AS_SHIFT);
+
+	/* Update Out Of Order Data Delivery Support */
+	hba->oodds  =3D ((hba->caps & DWC_UFS_OODDS) >> DWC_UFS_OODDS_SHIFT);
+
+	/* UIC DME TEST MODE support */
+	hba->uicdmetms =3D ((hba->caps & DWC_UFS_UICDMETMS) >>
+						DWC_UFS_UICDMETMS_SHIFT);
+}
+
+/**
+ * dwc_ufshcd_get_dwc_ufs_version()
+ * Gets the UFS version supported by the Host controller
+ * @hba: Pointer to drivers structure
+ *
+ * Returns DWC UFS HC version
+ */
+u32 dwc_ufshcd_get_dwc_ufs_version(struct dwc_ufs_hba *hba)
+{
+	return dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_VER);
+}
+
+/**
+ * dwc_ufshcd_configure_interface_memory()
+ * This function configures interface memory
+ * -  For every UTRD,
+ * - initializes the Command UPIU base address (Lo and High)
+ *	- response upiu length and offset
+ *	- prdt offset
+ * - Some key fields are updated in respective lrbs
+ *	- utrd addresses
+ *	- command upiu addresses
+ *	- response upiu addresses
+ *	- prdt base address
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_configure_interface_memory(struct dwc_ufs_hba *hba)
+{
+	int req;
+	struct dwc_ufs_utrd *utrl;	/* Pointer to UTR List */
+	struct dwc_ufs_ucd *ucdl;	/* Pointer to UCD List */
+	dma_addr_t ucdl_dma_addr;
+	dma_addr_t ucd_dma_addr;
+	u32 response_upiu_length;
+	u32 response_upiu_offset;
+	u32 prdt_offset;
+	u32 ucd_size;
+
+	utrl =3D hba->utrl_base_addr;
+	ucdl =3D hba->ucdl_base_addr;
+
+	/* Response offset and prdt offset are common for all the
+	 * UTP Transfer Request
+	 */
+	response_upiu_offset =3D offsetof(struct dwc_ufs_ucd, resp_upiu);
+	response_upiu_length =3D DWC_UCD_ALIGN;
+	prdt_offset =3D offsetof(struct dwc_ufs_ucd, prdt);
+
+	ucd_size =3D sizeof(struct dwc_ufs_ucd);
+	ucdl_dma_addr =3D hba->ucdl_dma_addr;	/* UCD list Base address */
+
+	/* For as many UTP Transfer Requests in the list */
+	for (req =3D 0; req < hba->nutrs; req++) {
+
+		/* Configure UTRD with UCD base address */
+		ucd_dma_addr =3D ucdl_dma_addr + (ucd_size * req);
+		utrl[req].ucdba =3D cpu_to_le32(lower_32_bits(ucd_dma_addr));
+		utrl[req].ucdbau =3D cpu_to_le32(upper_32_bits(ucd_dma_addr));
+
+		/* Configure Response UPIU offset and length */
+		/* These fields are in Dword format */
+		utrl[req].resp_upiu_offset =3D
+					cpu_to_le16(response_upiu_offset >> 2);
+		utrl[req].resp_upiu_length =3D
+					cpu_to_le16(response_upiu_length >> 2);
+
+		/* Configure prdt length and offset */
+		utrl[req].prdt_offset =3D cpu_to_le16(prdt_offset >> 2);
+		utrl[req].prdt_length =3D cpu_to_le16(0);
+
+		/* Update LRB */
+		hba->lrb[req].utrd =3D (utrl + req);
+		hba->lrb[req].cmd_upiu =3D
+			(struct dwc_ufs_cmd_upiu *)(ucdl + req);
+		hba->lrb[req].resp_upiu =3D
+			(struct dwc_ufs_resp_upiu *)(ucdl[req].resp_upiu);
+		hba->lrb[req].prdt =3D
+			(struct dwc_ufs_prd *) (ucdl[req].prdt);
+	}
+
+	pr_debug("Interface memory Configured\n");
+}
+
+/**
+ * dwc_ufshcd_free_interface_memory()
+ * Frees the allocated interface memory
+ *  - Free DMA'able memory allocated for UTP command tables
+ *  - Free DMA'able memory allocated for
+ *     - UTP transfer descriptors
+ *     - UTP task management descriptors
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_free_interface_memory(struct dwc_ufs_hba *hba)
+{
+	size_t utrl_size, utmrl_size, ucdl_size;
+
+	/* Unconditionally free the LRB memory */
+	kfree(hba->lrb);
+
+	/* Free UCD memory list/block */
+	if (hba->ucdl_base_addr !=3D NULL) {
+		ucdl_size =3D (sizeof(struct dwc_ufs_ucd) * hba->nutrs);
+		dma_free_coherent(hba->gdev, ucdl_size, hba->ucdl_base_addr,
+				 hba->ucdl_dma_addr);
+	}
+
+	/* Free UTRDL memory */
+	if (hba->utrl_base_addr !=3D NULL) {
+		utrl_size =3D (sizeof(struct dwc_ufs_utrd) * hba->nutrs);
+		dma_free_coherent(hba->gdev, utrl_size, hba->utrl_base_addr,
+				 hba->utrl_dma_addr);
+	}
+
+	/* Free UTMRDL memory */
+	if (hba->utmrl_base_addr !=3D NULL) {
+		utmrl_size =3D (sizeof(struct dwc_ufs_utmrd) * hba->nutrs);
+		dma_free_coherent(hba->gdev, utmrl_size, hba->utmrl_base_addr,
+				 hba->utmrl_dma_addr);
+	}
+}
+
+/**
+ * dwc_ufshcd_alloc_interface_memory()
+ * Allocate memory for Host controller interface.
+ * Following are the memories allocation by this function.
+ * - DMA'able memory for UTP transfer request descriptor list
+ * - DMA'able memory for UTP task management request list
+ * - DMA'able memory for command table
+ *    - Command UPIU's
+ *    - Response UPIU's
+ *    - PRD tables
+ * - Non-DMA'able memory for local reference blocks; House keeping
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 for success, non-zero in case of failure
+ */
+int dwc_ufshcd_alloc_interface_memory(struct dwc_ufs_hba *hba)
+{
+	size_t utrl_size, utmrl_size, ucdl_size;
+
+	/*
+	 * Allocate Dma'able memory for UTP Transfer Request List
+	 * UFS spec constraints: Base of List shoudl be aligned to 1024 byte
+	 * (1K boundary)
+	 */
+	utrl_size =3D (sizeof(struct dwc_ufs_utrd) * hba->nutrs);
+	hba->utrl_base_addr =3D dma_alloc_coherent(hba->gdev, utrl_size,
+				 &hba->utrl_dma_addr, GFP_KERNEL);
+
+	if (hba->utrl_base_addr =3D=3D NULL) {
+		pr_warn("UTRL Memory Allocation Failed\n");
+		goto err_utrl_alloc;
+	}
+
+	/* Allocate Dma'able memory for UTP Task management Request list
+	 * UFS spec constraints: base of list should be aligned to 1024 bytes
+	 * (1K boundary)
+	 */
+	utmrl_size =3D (sizeof(struct dwc_ufs_utmrd) * hba->nutmrs);
+	hba->utmrl_base_addr =3D dma_alloc_coherent(hba->gdev, utmrl_size,
+				&hba->utmrl_dma_addr, GFP_KERNEL);
+
+	if (hba->utmrl_base_addr =3D=3D NULL) {
+		pr_warn("UTMRL Memory Allocation Failed\n");
+		goto err_utmrl_alloc;
+	}
+
+	/* Allocate Dma'able memory for UTP Command Descriptor structures (UC=
Ds)
+	 * Every Command Descriptor block should be aligned to 128 bytes
+	 * (6:0 being) reserved
+	 */
+	ucdl_size =3D (sizeof(struct dwc_ufs_ucd) * hba->nutrs);
+	hba->ucdl_base_addr =3D dma_alloc_coherent(hba->gdev, ucdl_size,
+				&hba->ucdl_dma_addr, GFP_KERNEL);
+
+	if (hba->ucdl_base_addr =3D=3D NULL) {
+		pr_warn("UCD Memory Allocation Failed\n");
+		goto err_ucdl_alloc;
+	}
+
+	/* Allocate memory for local reference block */
+	hba->lrb =3D kcalloc(hba->nutrs, sizeof(struct dwc_ufs_hcd_lrb),
+								GFP_KERNEL);
+
+	if (hba->lrb =3D=3D NULL) {
+		pr_err("LRB Memory Allocation Failed\n");
+		goto err_lrb_alloc;
+	}
+
+	return 0;
+
+err_ucdl_alloc:
+err_utrl_alloc:
+err_utmrl_alloc:
+err_lrb_alloc:
+	dwc_ufshcd_free_interface_memory(hba);
+	return -ENOMEM;
+}
+
+/**
+ * dwc_ufshcd_is_device_present()
+ * This function returns '1' if device is present (link is up)
+ * '0' if device is not present (link is down)
+ *
+ * Returns bool value of device present status
+ */
+bool dwc_ufshcd_is_device_present(u32 hcs)
+{
+	return(hcs & DWC_UFS_DP);
+}
+
+/**
+ * dwc_ufshcd_is_utrl_ready()
+ * This function returns '1' if UTP transfer list is ready
+ * '0' if UTP transfer list is not ready
+ *
+ * Returns bool value of UTP transfer list status
+ */
+bool dwc_ufshcd_is_utrl_ready(u32 hcs)
+{
+	return(hcs & DWC_UFS_UTRL_READY);
+}
+
+/**
+ * dwc_ufshcd_is_utmrl_ready()
+ * This function returns '1' if UTP task management list is ready
+ * '0' if UTP task management list is not ready
+ *
+ * Returns bool value of UTP task management list status
+ */
+bool dwc_ufshcd_is_utmrl_ready(u32 hcs)
+{
+	return(hcs & DWC_UFS_UTMRL_READY);
+}
+
+/**
+ * dwc_ufshcd_is_dme_sap_ready()
+ * Returns true if DME is ready to accept uio command
+ *
+ * Returns bool value of DME command acceptance status
+ */
+bool dwc_ufshcd_is_dme_sap_ready(u32 hcs)
+{
+	return(hcs & DWC_UFS_UIC_CMD_READY);
+}
+
+/**
+ * dwc_ufshcd_is_host_controller_ready()
+ * This function returns the status of
+ * - device present status
+ * - UTP transfer list status
+ * - UTP task management list status
+ * - dme sap status
+ *
+ * Returns '0' if all the above are true, else negative error number
+ */
+int dwc_ufshcd_is_host_controller_ready(struct dwc_ufs_hba *hba)
+{
+	u32 hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+
+	/* Check if Device Present */
+	if (dwc_ufshcd_is_device_present(hcs) =3D=3D false) {
+		pr_err("Device is not attached to DWC UFS HC\n");
+		return -ENXIO;
+	}
+
+	/* Check if UTR List Ready */
+	if (dwc_ufshcd_is_utrl_ready(hcs) =3D=3D false) {
+		pr_err("UTRDL is not ready\n");
+		return -EIO;
+	}
+
+	/* Check if UTMR List Ready */
+	if (dwc_ufshcd_is_utmrl_ready(hcs) =3D=3D false) {
+		pr_err("UTMRL is not ready\n");
+		return -EIO;
+	}
+
+	/* Check if UTR List Ready */
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("DME Sap not ready\n");
+		return -EIO;
+	}
+
+	pr_debug("DWC UFS HC is ready\n");
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_configure_interrupt()
+ * This function configures host controller Interrupt enable register
+ * with the value programmed in the intr_enable_mask in drivers privat=
e data
+ * @hba: Pointer to drivers structure
+ * @option: enable or disable interrupts
+ *
+ */
+void dwc_ufshcd_configure_interrupt(struct dwc_ufs_hba *hba, u32 optio=
n)
+{
+	switch (option) {
+	case DWC_UFS_HCD_INTR_ENABLE:
+		dwc_ufs_writel(hba->intr_enable_mask,
+				hba->mmio_base, DWC_UFS_REG_IE);
+		break;
+	case DWC_UFS_HCD_INTR_DISABLE:
+		dwc_ufs_writel(0x0000,
+				hba->mmio_base, DWC_UFS_REG_IE);
+		break;
+	}
+}
+
+/**
+ * dwc_ufshcd_config_intr_aggregation()
+ * Configures UTP transfer request interrupt aggregation control regis=
ter.
+ * Aggregation is programmed using the intr_aggr_cntr_thr for threshol=
d and
+ * intr_aggr_timeout_val for time out programmed in drivers private da=
ta
+ * structure.
+ * @hba: Pointer to drivers structure
+ * @option: Interrupt aggregation option either to enable or disable
+ *
+ */
+static inline void dwc_ufshcd_config_intr_aggregation(struct dwc_ufs_h=
ba *hba,
+							int option)
+{
+	switch (option) {
+	case INTR_AGGR_RESET:
+		dwc_ufs_writel((DWC_UFS_IAEN | DWC_UFS_CTR),
+				hba->mmio_base, DWC_UFS_REG_UTRIACR);
+		break;
+	case INTR_AGGR_CONFIG:
+		dwc_ufs_writel((DWC_UFS_IAEN | DWC_UFS_IAPWEN |
+			(((u32)(hba->intr_aggr_cntr_thr) << DWC_UFS_IACTH_SH) &
+			DWC_UFS_IACTH_MASK) | (u32)(hba->intr_aggr_timout_val)),
+			hba->mmio_base, DWC_UFS_REG_UTRIACR);
+		break;
+	}
+}
+
+/**
+ * dwc_ufshcd_enable_xfer_list_processing()
+ * This function enables the host controller to start processing UTP t=
ransfer
+ * request descriptor. This function programs the UTP transfer request
+ * list run stop register.
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_enable_xfer_list_processing(struct dwc_ufs_hba *hba)
+{
+	dwc_ufs_writel(0x01, hba->mmio_base, DWC_UFS_REG_UTRLRSR);
+}
+
+/**
+ * dwc_ufshcd_enable_tm_list_processing()
+ * This function enables the host controller to start processing UTP T=
M
+ * request descriptor.This function programs the UTP task management r=
equest
+ * list run stop register.
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_enable_tm_list_processing(struct dwc_ufs_hba *hba)
+{
+	dwc_ufs_writel(0x01, hba->mmio_base, DWC_UFS_REG_UTMRLRSR);
+}
+
+/**
+ * dwc_ufshcd_kick_start_stack()
+ * Kick start stack for device scanning and command sending.
+ * This function unblocks the applicatin requests (eg: Scsi) if alread=
y
+ * blocked. Sets the hcd state to operational and starts scanning for
+ * devices attached to HC.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int dwc_ufshcd_kick_start_stack(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+
+	/* If the hba state is in reset unblock the scsi requests */
+	if (hba->dwc_ufshcd_state =3D=3D DWC_UFSHCD_STATE_RESET)
+		scsi_unblock_requests(hba->shost);
+
+	dwc_ufshcd_set_hcd_state(hba, DWC_UFSHCD_STATE_OPERATIONAL);
+
+	/* scan all the devices attached to this host */
+	dwc_ufshcd_scan_scsi_devices_attached_to_host(hba);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_set_hcd_state()
+ * Sets the state of host controller driver.
+ * @hba: Pointer to drivers structure
+ * @state: state of the driver to be programmed
+ *
+ */
+void dwc_ufshcd_set_hcd_state(struct dwc_ufs_hba *hba, u32 state)
+{
+	hba->dwc_ufshcd_state =3D state;
+}
+
+/**
+ * dwc_ufshcd_kick_start_hba()
+ * Kick start DWC UFS controller.
+ * After checking the HC is ready for operation (Device Present, UTRL =
ready,
+ * UTMRL ready, UIC ready), this function performs
+ *  -  Enables the Transfer list processing by setting Run Stop bit
+ *  -  Enables the Task Management list processing by setting Run Stop=
 bit
+ *  -  Sets the interrupt mask in driver private structure
+ *  -  Configure the interrupts in HC
+ *  -  Configures the interrupt aggregation
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int dwc_ufshcd_kick_start_hba(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+
+	/* Checking if Device Present */
+	result =3D dwc_ufshcd_is_host_controller_ready(hba);
+
+	if (result !=3D 0)
+		goto err_host_controller_ready;
+
+	/* Enable the Xfer and TM lists */
+	dwc_ufshcd_enable_xfer_list_processing(hba);
+	dwc_ufshcd_enable_tm_list_processing(hba);
+
+	/* Enable required interrupts */
+	hba->intr_enable_mask |=3D (DWC_UFS_UTRCE	| DWC_UFS_UEE | DWC_UFS_UTM=
RCE |
+				 DWC_UFS_DFEE | DWC_UFS_HCFEE | DWC_UFS_SBFEE);
+	/* Configure HC for programmed interrupts */
+	dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+
+	/* Configure interrupt aggregation */
+	hba->intr_aggr_cntr_thr =3D DWC_INTR_AGGR_COUNTER_THRESHOLD_VALUE;
+	hba->intr_aggr_timout_val =3D DWC_INTR_AGGR_TIMEOUT_VALUE;
+	dwc_ufshcd_config_intr_aggregation(hba, INTR_AGGR_CONFIG);
+
+err_host_controller_ready:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_update_dme_cmd_results()
+ * This function updates the active_dme_cmd fields from the uio regist=
ers
+ * Along with this it also update the cmd_active field to zero. Last a=
ction
+ * acts as command completion flat to wake up the wait queue.
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_update_dme_cmd_results(struct dwc_ufs_hba *hba)
+{
+	hba->active_dme_cmd.command =3D dwc_ufs_readl(hba->mmio_base,
+							DWC_UFS_REG_UICCMDR);
+
+	hba->active_dme_cmd.argument1 =3D dwc_ufs_readl(hba->mmio_base,
+							DWC_UFS_REG_UCMDARG1);
+
+	hba->active_dme_cmd.argument2 =3D dwc_ufs_readl(hba->mmio_base,
+							DWC_UFS_REG_UCMDARG2);
+
+	hba->active_dme_cmd.argument3 =3D dwc_ufs_readl(hba->mmio_base,
+							DWC_UFS_REG_UCMDARG3);
+
+	hba->active_dme_cmd.cmd_active =3D 0;
+}
+
+/**
+ * dwc_ufshcd_dme_sap_work()
+ * The work to be performed after sending UIO command through UIO_SAP
+ * At present only commannd status is updated for link startup command
+ * For other commands function does nothing.
+ * @work: pointer to a work queue structure
+ *
+ */
+static void dwc_ufshcd_dme_sap_work(struct work_struct *work)
+{
+	int result;
+	struct dwc_ufs_hba *hba;
+
+	hba =3D container_of(work, struct dwc_ufs_hba, dme_sap_workq);
+
+	if (hba->active_dme_cmd.command =3D=3D DWC_UFS_DME_LINKSTARTUP) {
+		dwc_ufshcd_update_dme_cmd_results(hba);
+		result =3D dwc_ufshcd_get_dme_command_results(hba);
+	}
+}
+
+/**
+ * dwc_ufshcd_dme_sap_work()
+ * The work to be performed on seeing fatal erros as reported by HC
+ * TODO: yet to be implemented
+ * @work: pointer to a work queue structure
+ *
+ */
+static void dwc_ufshcd_fatal_error_handler_work(struct work_struct *wo=
rk)
+{
+	struct dwc_ufs_hba *hba;
+	int result =3D 0;
+
+	hba =3D container_of(work, struct dwc_ufs_hba, fatal_error_handler_wo=
rkq);
+
+	/* set the state to error state */
+	dwc_ufshcd_set_hcd_state(hba, DWC_UFSHCD_STATE_ERROR);
+
+	/* check if reset is already in progress */
+	if (hba->dwc_ufshcd_state !=3D DWC_UFSHCD_STATE_RESET)
+		result =3D dwc_ufshcd_reset_hba(hba);
+}
+
+#ifdef CONFIG_PM
+/**
+ * dwc_ufshcd_suspend()
+ * This function will be called from OS issues the suspend
+ * TODO: To be implemented and comeup with scheme to verify the flow
+ * @pdev: pointer to PCI device handle
+ *
+ * Returns -ENOSYS
+ */
+int dwc_ufshcd_suspend(struct dwc_ufs_hba *hba)
+{
+	/*
+	 * 1. Block SCSI requests from SCSI midlayer
+	 * 2. Change the internal driver state to non operational
+	 * 3. Set UTRLRSR and UTMRLRSR bits to zero
+	 * 4. Wait until outstanding commands are completed
+	 * 5. Set HCE to zero to send the UFS host controller to reset state
+	 */
+
+	return -ENOSYS;
+}
+
+/**
+ * dwc_ufshcd_resume()
+ * Resumes the DWC UFS HC from suspend
+ * TODO: To be implemented and comeup with scheme to verify the flow
+ * @pdev: pointer to PCI device handle
+ *
+ * Returns -ENOSYS
+ */
+int dwc_ufshcd_resume(struct dwc_ufs_hba *hba)
+{
+	/*
+	 * 1. Set HCE to 1, to start the UFS host controller
+	 * initialization process
+	 * 2. Set UTRLRSR and UTMRLRSR bits to 1
+	 * 3. Change the internal driver state to operational
+	 * 4. Unblock SCSI requests from SCSI midlayer
+	 */
+
+	return -ENOSYS;
+}
+#endif /* CONFIG_PM */
+
+/**
+ * dwc_ufshcd_get_xfer_cmd_status()
+ * Get the command status from the response upiu.
+ * @resp_upiu: Pointer to response UPIU
+ *
+ * Returns the response_upiu->status.
+ */
+static inline int
+dwc_ufshcd_get_xfer_cmd_status(struct dwc_ufs_resp_upiu *resp_upiu) {
+	return resp_upiu->status;
+}
+
+/**
+ * dwc_ufshcd_xfer_resp_status()
+ * This populates the ocs and xfer_command_status field of lrb
+ * from utrd->ocs and response_upiu->status
+ * @hba: Pointer to drivers structure
+ * @lrb: pointer to local reference block of completed command
+ *
+ */
+void dwc_ufshcd_xfer_resp_status(struct dwc_ufs_hba *hba,
+					 struct dwc_ufs_hcd_lrb *lrb) {
+
+	/* overall command status of utrd */
+	lrb->ocs =3D dwc_ufshcd_get_utrd_ocs(lrb);
+
+	/* Update transfer command status */
+	lrb->xfer_command_status =3D
+				dwc_ufshcd_get_xfer_cmd_status(lrb->resp_upiu);
+}
+
+/**
+ * dwc_ufshcd_dm_command_completion_handler()
+ * This function handles device management request completion. The fun=
ction
+ * wakes up the the wait queue.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success or non zero value on failure
+ */
+int dwc_ufshcd_dm_command_completion_handler(struct dwc_ufs_hba *hba)
+{
+	u32 dm_req_doorbell;
+	unsigned long host_completed_dm_requests;
+	int result =3D 0;
+
+	/* Get all the outstanding TM tasks with Host controller */
+	dm_req_doorbell =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UTRLDBR=
);
+	host_completed_dm_requests =3D dm_req_doorbell ^
+						hba->outstanding_dm_requests;
+
+	hba->dwc_ufshcd_dm_condition =3D host_completed_dm_requests;
+
+	if (hba->dm_completion_handler_type =3D=3D
+					DWC_UFS_HANDLER_WAIT_QUEUE_TYPE) {
+		pr_debug("Waking up DM wait queue\n");
+		wake_up_interruptible(&hba->dwc_ufshcd_dm_wait_queue);
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_xfer_req_completion_handler()
+ * This function handles the application commands (eg:scsi) completion=
=2E
+ * The function
+ *  - Scans through all the slots to identify the completed commands
+ *  - Updates the transfer response status
+ *  - calls appropriate application specific functions
+ *      - unmapping the dma (scsi)
+ *      - invokes scsi completion handler
+ * Note: This function will run in interrupt context. Modification to =
this
+ * routine and any other function called from this routine should not =
block.
+ * @hba: Pointer to drivers structure
+ *
+ */
+static void dwc_ufshcd_xfer_req_completion_handler(struct dwc_ufs_hba =
*hba)
+{
+	struct dwc_ufs_hcd_lrb *lrb;
+	unsigned long host_completed_reqs;
+	u32 xfer_req_doorbell;
+	int nutr;
+
+	lrb =3D hba->lrb;
+	xfer_req_doorbell =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UTRLD=
BR);
+	host_completed_reqs =3D xfer_req_doorbell ^ hba->outstanding_xfer_req=
s;
+
+	/* Handle all completed UTRDs one by one */
+	for (nutr =3D 0; nutr < hba->nutrs; nutr++) {
+		if (test_bit(nutr, &host_completed_reqs)) {
+			dwc_ufshcd_xfer_resp_status(hba, &lrb[nutr]);
+
+			if (lrb[nutr].command_type =3D=3D DWC_UTRD_CMD_TYPE_SCSI ||
+		lrb[nutr].command_type =3D=3D DWC_UTRD_CMD_TYPE_UFS_STORAGE) {
+
+				if (lrb[nutr].scmd !=3D NULL) {
+
+					/* Free DMA mapping for this
+					 * cmd's SG list
+					 */
+					dwc_ufshcd_unmap_dma(&lrb[nutr]);
+
+					/* Get result based on SCSI status
+					 * response
+					 */
+					dwc_ufshcd_do_scsi_completion_with_results(&lrb[nutr]);
+				}
+			}
+		}
+	}
+
+	/* clear corresponding bits of completed commands */
+	hba->outstanding_xfer_reqs ^=3D host_completed_reqs;
+
+	/* Reset interrupt aggregation counters */
+	dwc_ufshcd_config_intr_aggregation(hba, INTR_AGGR_RESET);
+}
+
+/**
+ * dwc_ufshcd_dme_completion_handler()
+ * This function implements the completion handler for dme commands.
+ * First it will update the command resulst in the active dme command
+ * structure in drivers private data.
+ * Then it will
+ *  - schedule the work; if work queue is implemented or
+ *  - wakes up the wait queue
+ * @hba: Pointer to drivers structure
+ *
+ */
+static void dwc_ufshcd_dme_completion_handler(struct dwc_ufs_hba *hba)
+{
+	dwc_ufshcd_update_dme_cmd_results(hba);
+
+	/* if waitqueue implementation */
+	if (hba->dme_completion_handler_type =3D=3D
+			DWC_UFS_HANDLER_WAIT_QUEUE_TYPE) {
+		pr_debug("Waking up the dme wait queue\n");
+		wake_up_interruptible(&hba->dwc_ufshcd_dme_wait_queue);
+	}
+	/* if work implementation */
+	else if (hba->dme_completion_handler_type =3D=3D
+			DWC_UFS_HANDLER_WORK_QUEUE_TYPE) {
+		schedule_work(&hba->dme_sap_workq);
+	}
+
+	/* After completing one request unmaslk the interrupt enable bit */
+	hba->intr_enable_mask &=3D ~DWC_UFS_UCCE;
+	dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+}
+
+/**
+ * dwc_ufshcd_tm_completion_handler()
+ * This function handles task management function completion.
+ * After setting the condition variable for respective slot,
+ * it wakes up the wait queue for further processing
+ * @hba: Pointer to drivers structure
+ *
+ */
+static void dwc_ufshcd_tm_completion_handler(struct dwc_ufs_hba *hba)
+{
+	u32 tm_tasks_doorbell;
+	unsigned long host_completed_tm_tasks;
+
+	/* Get all the outstanding TM tasks with Host controller */
+	tm_tasks_doorbell =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UTMRL=
DBR);
+	host_completed_tm_tasks =3D tm_tasks_doorbell ^ hba->outstanding_tm_t=
asks;
+
+	hba->dwc_ufshcd_tm_condition =3D host_completed_tm_tasks;
+
+	/* TODO: It seems the wait queue implementaion can handle only one.
+	 * review and implement a different scheme if needed */
+	if (hba->tm_completion_handler_type =3D=3D DWC_UFS_HANDLER_WAIT_QUEUE=
_TYPE)
+		wake_up_interruptible(&hba->dwc_ufshcd_tm_wait_queue);
+}
+
+void dwc_ufshcd_error_handler(struct dwc_ufs_hba *hba)
+{
+	u32 reg;
+
+	/* If fatal Errors; Handle them first at highest priority */
+	if (hba->dwc_ufshcd_interrupts & DWC_UFS_ENABLED_FE_ERROR_MASK)
+		goto handle_fatal_errors;
+
+	if (hba->dwc_ufshcd_interrupts & DWC_UFS_UEE) {
+		reg =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UECPA);
+		pr_info("DWC_UFS_REG_UECPA : %08x\n", reg);
+		reg =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UECDL);
+		pr_info("DWC_UFS_REG_UECDL : %08x\n", reg);
+		reg =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UECN);
+		pr_info("DWC_UFS_REG_UECN  : %08x\n", reg);
+		reg =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UECT);
+		pr_info("DWC_UFS_REG_UECT  : %08x\n", reg);
+		reg =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UECDME);
+		pr_info("DWC_UFS_REG_UECDME: %08x\n", reg);
+	}
+
+	/* Handle Hibernate Entry Exit Or Powermode Change */
+	if (hba->dwc_ufshcd_interrupts & (DWC_UFS_UHES | DWC_UFS_UHXS |
+								DWC_UFS_UPMS)) {
+		reg =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_AHIT);
+		pr_info("DWC_UFS_REG_AHIT : %08x\n", reg);
+		reg =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+		pr_info("DWC_UFS_REG_HCS : %08x\n", reg);
+	}
+
+	return;
+
+handle_fatal_errors:
+	if (hba->fatal_error_handler_type =3D=3D DWC_UFS_HANDLER_WORK_QUEUE_T=
YPE) {
+		dwc_ufshcd_set_hcd_state(hba, DWC_UFSHCD_STATE_ERROR);
+		schedule_work(&hba->fatal_error_handler_workq);
+	}
+}
+
+static void dwc_ufshcd_handle_interrupt_in_debug_mode(struct dwc_ufs_h=
ba *hba)
+{
+	getnstimeofday(&hba->pstats.end_time);
+	hba->pstats.state =3D DWC_UFS_STATS_DISABLED;
+	hba->debug_mode =3D 0;
+}
+
+/**
+ * dwc_ufshcd_handle_interrupts()
+ * This is invoked from the top half to handle interrupts
+ * This function inturn calls appropriate handlers
+ * - errored interrupts are handled at most priority
+ *
+ * @hba: Pointer to drivers structure
+ * @intr_status: Interrupt status register value
+ *
+ */
+static void dwc_ufshcd_handle_interrupts(struct dwc_ufs_hba *hba,
+							u32 intr_status)
+{
+	/* Handle Errors at High Priority */
+	if (((intr_status & hba->intr_enable_mask) &
+			DWC_UFS_ENABLED_ERROR_MASK) !=3D 0)
+		dwc_ufshcd_error_handler(hba);
+
+	/* DME/UIC Command complete interrupt */
+	if (((intr_status & hba->intr_enable_mask) & DWC_UFS_UCCS) !=3D 0)
+		dwc_ufshcd_dme_completion_handler(hba);
+
+	/* UTP Task Management Request Completion interrupt */
+	if (((intr_status & hba->intr_enable_mask) & DWC_UFS_UTMRCS) !=3D 0)
+		dwc_ufshcd_tm_completion_handler(hba);
+
+	/* UTP Transfer Request Completion interrupt */
+	if (((intr_status & hba->intr_enable_mask) & DWC_UFS_UTRCS) !=3D 0) {
+		if (hba->outstanding_dm_requests !=3D 0)
+			dwc_ufshcd_dm_command_completion_handler(hba);
+
+		dwc_ufshcd_xfer_req_completion_handler(hba);
+	}
+}
+
+/**
+ * dwc_ufshcd_isr()
+ * Main/top half of interrupt service routine
+ * This function inturn invokes the individual handlers
+ * @irq: irq number
+ * @dwc_ufs_hcd_data: pointer to driver's private data
+ *
+ * Returns IRQ_HANDLED - If interrupt is valid
+ *	   IRQ_NONE - If invalid interrupt
+ */
+static irqreturn_t dwc_ufshcd_isr(int irq, void *dwc_ufs_hcd_data)
+{
+	u32 intr_status;
+	irqreturn_t irq_ret =3D IRQ_NONE;
+	struct dwc_ufs_hba *hba =3D dwc_ufs_hcd_data;
+
+	spin_lock(hba->shost->host_lock);
+	intr_status =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_IS);
+
+	/* FOR UFS2.0 above Hostcontrollers, the interrupt status is Write to
+	 * Clear
+	 */
+	if (hba->dwc_ufs_version =3D=3D DWC_UFS_HC_VERSION_2_0)
+		dwc_ufs_writel(intr_status, hba->mmio_base, DWC_UFS_REG_IS);
+
+	/* If Debug mode is on the interrupt is due to request through debug
+	 * access. Handle this without going through stack
+	 */
+	if (hba->debug_mode =3D=3D 1) {
+		if (dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_UTRLDBR) =3D=3D 0x0)
+			dwc_ufshcd_handle_interrupt_in_debug_mode(hba);
+	} else if (intr_status !=3D 0) {
+
+		if ((hba->pstats.state =3D=3D DWC_UFS_STATS_RUNNING) &&
+			(intr_status & DWC_UFS_UTRCE))
+			getnstimeofday(&hba->pstats.end_time);
+
+		hba->dwc_ufshcd_interrupts =3D intr_status;
+		dwc_ufshcd_handle_interrupts(hba, intr_status);
+		irq_ret =3D IRQ_HANDLED;
+	}
+
+	spin_unlock(hba->shost->host_lock);
+
+	return irq_ret;
+}
+
+/**
+ * dwc_ufshcd_drv_exit()
+ * PCI/Platform independent exit routine for driver
+ * This function
+ *  - Disables the interrupt of DWC UFS HC
+ *  - free's the irq
+ *  - Stops/Disables the DWC UFS HC
+ *  - Frees up all the memory allocated to interface with HC
+ *  - removes the scsi host structure registered with scsi mid layer
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_drv_exit(struct dwc_ufs_hba *hba)
+{
+	/* Remove the scsi host from the scsi mid layer */
+	dwc_ufshcd_scsi_remove_host(hba);
+	mdelay(100);
+
+	/* disable interrupts */
+	dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_DISABLE);
+	free_irq(hba->irq, hba);
+
+	dwc_ufshcd_stop_host(hba);
+	mdelay(100);
+
+	/* TODO: Validate the following assumptions
+	 * 1. there is nothing on the waitqueues
+	 * 2. No pending work in workqueue
+	 */
+	dwc_ufshcd_free_interface_memory(hba);
+}
+
+/**
+ * dwc_ufshcd_drv_init()
+
+ * PCI/Platform independent initialization routine for driver.
+ * The action performed here are
+ *  - Do scsi adaptation by allocating scsi host structure
+ *  - Populates private structure with
+ *	- generic device pointer
+ *	- irq no
+ *	- mmio_base
+ *  - Reads the DWC UFS HC's capability and populates it in priv struc=
ture
+ *  - Allocates interface memory required
+ *  - Initializes static_hba static variable needed for debug infrastr=
ucture
+ *  - Updates the scsi attributes with HC's capabilities
+ *  - Initializes different interrupt completion handlers
+ *  - Registers the ISR to the irq no
+ *  - does scsi tag mapping; tags to be shared among many LUNs
+ *  - Add DWC UFS HC to scsi mid layer *
+ * @ptr_to_hba: double pointer driver's private data
+ * @gdev: generic device pointer
+ * @irq_no: irq line, the host controller interrupts are mapped to
+ * @mmio_base: Host controller's memory/IO base address
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int dwc_ufshcd_drv_init(struct dwc_ufs_hba **ptr_to_hba, struct device=
 *gdev,
+			int irq_no, void __iomem *mmio_base)
+{
+	int result =3D 0;
+	struct dwc_ufs_hba *hba;
+
+	/* Function below does the scsi adaptation for UFS
+	 * This function adds scsi_host_template to scsi subystem
+	 * (Mid level). In addition this allocates the memory required
+	 * for our-host's/driver's private data
+	 */
+	hba =3D dwc_ufshcd_alloc_scsi_host();
+
+	if (hba =3D=3D NULL) {
+		pr_err("SCSI Host Allocation Failed\n");
+		result =3D -ENOMEM;
+		goto err_scsi_host_alloc;
+	}
+
+	/* Populate required private fields */
+	hba->gdev  =3D gdev;
+	hba->irq   =3D irq_no;
+	hba->mmio_base =3D mmio_base;
+	*ptr_to_hba =3D hba;
+
+	/* Read host Controller Capabilities */
+	dwc_ufshcd_read_caps(hba);
+
+	hba->dwc_ufs_version =3D dwc_ufshcd_get_dwc_ufs_version(hba);
+
+	/* Allocate memory required to interface with host */
+	result =3D dwc_ufshcd_alloc_interface_memory(hba);
+
+	/* Update the static hba pointer for user space access */
+	static_ufs_hba =3D hba;
+
+	if (result !=3D 0) {
+		pr_err("Error Allocating the required memory to"/
+						"interface DWC UFS HC\n");
+		goto err_alloc_ufshcd_interface_memory;
+	}
+
+	/* Configure the HC memory with required information and the LRB */
+	dwc_ufshcd_configure_interface_memory(hba);
+
+	/* Disable debug mode and stop capturing statistics */
+	hba->debug_mode =3D 0;
+	hba->pstats.state =3D DWC_UFS_STATS_DISABLED;
+
+	/* Update Scsi related attributes/parameters */
+	dwc_ufshcd_update_scsi_attributes(hba);
+
+	/* Initailize wait queue for task management, Device Management,
+	 * Dme-Access
+	 */
+	hba->dme_completion_handler_type =3D DWC_UFS_HANDLER_WAIT_QUEUE_TYPE;
+	hba->tm_completion_handler_type =3D DWC_UFS_HANDLER_WAIT_QUEUE_TYPE;
+	hba->dm_completion_handler_type =3D DWC_UFS_HANDLER_WAIT_QUEUE_TYPE;
+	hba->fatal_error_handler_type =3D DWC_UFS_HANDLER_WORK_QUEUE_TYPE;
+
+	if (hba->tm_completion_handler_type =3D=3D
+					DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)
+		init_waitqueue_head(&hba->dwc_ufshcd_tm_wait_queue);
+
+	if (hba->dm_completion_handler_type =3D=3D
+					DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)
+		init_waitqueue_head(&hba->dwc_ufshcd_dm_wait_queue);
+
+	if (hba->dme_completion_handler_type =3D=3D
+					DWC_UFS_HANDLER_WORK_QUEUE_TYPE)
+		INIT_WORK(&hba->dme_sap_workq, dwc_ufshcd_dme_sap_work);
+	else if (hba->dme_completion_handler_type =3D=3D
+					DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)
+		init_waitqueue_head(&hba->dwc_ufshcd_dme_wait_queue);
+
+	if (hba->fatal_error_handler_type =3D=3D DWC_UFS_HANDLER_WORK_QUEUE_T=
YPE)
+		INIT_WORK(&hba->fatal_error_handler_workq,
+					dwc_ufshcd_fatal_error_handler_work);
+
+	/* ISR registration */
+	result =3D request_irq(hba->irq, dwc_ufshcd_isr, IRQF_SHARED,
+			 dwc_ufs_hostname(hba), hba);
+
+	if (result !=3D 0) {
+		pr_err("ISR Registration Failed\n");
+		goto err_request_irq;
+	}
+
+	/* Enable SCSI tag mapping: to use unique tags for all LUNs
+	 * That will manage a joint tag space for N queues without driver
+	 * having to partition it arbitrarily
+	 */
+	result =3D dwc_ufshcd_do_scsi_tag_mapping(hba);
+	if (result !=3D 0) {
+		pr_err("Tag to Queue Mapping Failed\n");
+		goto err_scsi_init_shared_tag_map;
+	}
+
+	/* Add our adapted scsi_host structure to SCSI subsystem */
+	result =3D dwc_ufshcd_scsi_add_host(hba);
+	if (result !=3D 0) {
+		pr_err("Adding Scsi host Failed\n");
+		goto err_scsi_add_host;
+	}
+
+	return 0;
+
+err_scsi_add_host:
+err_scsi_init_shared_tag_map:
+	free_irq(hba->irq, hba);
+err_request_irq:
+	dwc_ufshcd_free_interface_memory(hba);
+err_alloc_ufshcd_interface_memory:
+err_scsi_host_alloc:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_stop_host()
+ * Resets/Stops the Host controller by writing HCE register bit 0 with
+ * a value of '0'
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_stop_host(struct dwc_ufs_hba *hba)
+{
+	dwc_ufs_writel(DWC_UFS_DISABLE, hba->mmio_base, DWC_UFS_REG_HCE);
+}
+
+/**
+ * dwc_ufshcd_is_hba_active
+ * Get UFS controller state
+ * @hba: Pointer to drivers structure
+ *
+ * Returns TRUE if controller is active, FALSE otherwise
+ */
+bool dwc_ufshcd_is_hba_active(struct dwc_ufs_hba *hba)
+{
+	return (dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCE) & 0x1) ?
+		true : false;
+}
+
+/**
+ * dwc_ufshcd_reset_host()
+ * Resets/Stops the Host controller
+ * Writing HCE register bit 0 with value of 1 initiates the reset to t=
he HC.
+ * Note that this function returns immediately. it is the responsibili=
ty of
+ * the caller to ensure the reset/initialization is successful
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_reset_host(struct dwc_ufs_hba *hba)
+{
+	dwc_ufs_writel(DWC_UFS_ENABLE, hba->mmio_base, DWC_UFS_REG_HCE);
+}
+
+/**
+ * dwc_ufshcd_program_clk_div()
+ * This function programs the clk divider value. this value is needed =
to
+ * provide 1 microsecond tick to unipro layer.
+ * @hba: Pointer to drivers structure
+ * @divider_val: clock divider value to be programmed
+ *
+ */
+void dwc_ufshcd_program_clk_div(struct dwc_ufs_hba *hba, u32 divider_v=
al)
+{
+	dwc_ufs_writel(divider_val, hba->mmio_base, DWC_UFS_REG_HCLKDIV);
+}
+
+/**
+ * dwc_ufshcd_host_enable()
+ * Enables the DWC UFS HC for operation
+ * This function starts the contorller intialization procedure (By Set=
ting
+ * the HCE bit 0). The initialization might take some time as it invol=
vs
+ * initializing local UIC layer (dme_reset and dme_enable).
+ * This function implements busy wait loop till the host controller be=
comes
+ * ready for operation
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int dwc_ufshcd_host_enable(struct dwc_ufs_hba *hba)
+{
+	int retry_count;
+	int result =3D 0;
+
+	/* Start host controller initialization sequence */
+	pr_debug("Stopping the DWC UFS HC\n");
+	dwc_ufshcd_stop_host(hba);
+	mdelay(10);
+
+	pr_debug("Enabling the DWC UFS HC\n");
+	dwc_ufshcd_reset_host(hba);
+
+	mdelay(10);
+
+	/* Wait till host controller initialization completes */
+	retry_count =3D DWC_UFS_RETRY_COUNT_GENERIC;
+	while ((dwc_ufshcd_is_hba_active(hba) =3D=3D false) && (retry_count !=
=3D 0)) {
+		retry_count--;
+		mdelay(10);
+	}
+
+	if (retry_count =3D=3D 0) {
+		pr_err("Failed to enable the Host Controller\n");
+		result =3D -EIO;
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_get_dme_command_results()
+ * This function gets the UIO command results from the
+ * driver's private structure's active dme command.
+ * It is callers responsibility to ensure the results are updated
+ * before invoking this function.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns dme result code
+ */
+u8 dwc_ufshcd_get_dme_command_results(struct dwc_ufs_hba *hba)
+{
+	return ((hba->active_dme_cmd.argument2) &
+		DWC_UFS_DME_RESULT_CODE_MASK);
+}
+
+/**
+ * dwc_ufshcd_send_dme_command()
+ * This function issues the uio command. it uses the programmed
+ * values available in active_dme_command structure in drivers private
+ * data.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 - success
+ */
+int dwc_ufshcd_send_dme_command(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+
+	/* Argument registers to be written first */
+	dwc_ufs_writel(hba->active_dme_cmd.argument1,
+			hba->mmio_base, DWC_UFS_REG_UCMDARG1);
+
+	dwc_ufs_writel(hba->active_dme_cmd.argument2,
+			hba->mmio_base, DWC_UFS_REG_UCMDARG2);
+
+	dwc_ufs_writel(hba->active_dme_cmd.argument3,
+			hba->mmio_base, DWC_UFS_REG_UCMDARG3);
+
+	hba->active_dme_cmd.cmd_active =3D 1;
+
+	/* Write UIC/DME Cmd */
+	dwc_ufs_writel(hba->active_dme_cmd.command,
+			hba->mmio_base, DWC_UFS_REG_UICCMDR);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_handle_dme_command_completion_wo_intr()
+ * This function is called when the dme command is sent without
+ * enabling the interrupt.
+ * This function polls the Interrupt status register for Uio command
+ * completion status for programmed number of retries
+ * Then independent of interrupt is set or not, it updates the dme_res=
ults
+ * Its the responsibility of the caller to interpret the data and
+ * take a call on success or failure.
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_handle_dme_command_completion_wo_intr(struct dwc_ufs_h=
ba *hba)
+{
+	u32 retry_count =3D DWC_UFS_RETRY_COUNT_GENERIC;
+	u32 intr_status =3D 0;
+
+	do {
+		intr_status =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_IS);
+		mdelay(1);
+
+		if (retry_count-- =3D=3D 0)
+			break;
+	} while ((intr_status & DWC_UFS_UCCS) =3D=3D 0);
+
+	/* FOR UFS2.0 above Hostcontrollers, the interrupt status is Write
+	 * to Clear
+	 */
+	if (hba->dwc_ufs_version =3D=3D DWC_UFS_HC_VERSION_2_0)
+		dwc_ufs_writel(DWC_UFS_UCCS, hba->mmio_base, DWC_UFS_REG_IS);
+
+	/* At present for polling mode only dme registers are dumped out */
+	dwc_ufshcd_update_dme_cmd_results(hba);
+}
+
+/**
+ * dwc_ufs_dme_get()
+ * The function to get the local unipor attribute
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * until the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @attr_id: unipro attribure id
+ * @sttr_set_type: local or static
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_get(struct dwc_ufs_hba *hba, u32 attr_id, u32 attr_set=
_type,
+								u32 intr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_get command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_GET;
+	hba->active_dme_cmd.argument1 =3D attr_id << 16;
+	hba->active_dme_cmd.argument2 =3D 0;
+
+	if (attr_set_type =3D=3D DWC_UFS_DME_ATTR_SET_TYPE_STATIC)
+		hba->active_dme_cmd.argument2 =3D
+					DWC_UFS_DME_ATTR_SET_TYPE_STATIC << 16;
+
+	hba->active_dme_cmd.argument3 =3D 0;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_set()
+ * The function to set the local unipro attribute
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @attr_id: unipro attribure id
+ * @gen_sel_index: selector
+ * @attr_val: attribute value
+ * @sttr_set_type: local or static
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_set(struct dwc_ufs_hba *hba, u32 attr_id, u32 gen_sel_=
index,
+			u32 attr_val, u32 attr_set_type, u32 intr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_set command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_SET;
+	hba->active_dme_cmd.argument1 =3D ((attr_id << 16) | gen_sel_index);
+	hba->active_dme_cmd.argument2 =3D 0;
+	if (attr_set_type =3D=3D DWC_UFS_DME_ATTR_SET_TYPE_STATIC)
+		hba->active_dme_cmd.argument2 =3D
+					DWC_UFS_DME_ATTR_SET_TYPE_STATIC << 16;
+	hba->active_dme_cmd.argument3 =3D attr_val;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_peer_get()
+ * The function to gett the peer unipro attribute
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @attr_id: unipro attribure id
+ * @sttr_set_type: local or static
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_peer_get(struct dwc_ufs_hba *hba, u32 attr_id,
+				u32 attr_set_type, u32 intr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_peer_get command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_PEER_GET;
+	hba->active_dme_cmd.argument1 =3D attr_id << 16;
+	hba->active_dme_cmd.argument2 =3D 0;
+
+	if (attr_set_type =3D=3D DWC_UFS_DME_ATTR_SET_TYPE_STATIC)
+		hba->active_dme_cmd.argument2 =3D
+					DWC_UFS_DME_ATTR_SET_TYPE_STATIC << 16;
+
+	hba->active_dme_cmd.argument3 =3D 0;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_peer_set()
+ * The function to set the peer side unipro attribute
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @attr_id: unipro attribure id
+ * @gen_sel_index: selector
+ * @attr_val: attribute value
+ * @sttr_set_type: local or static
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_peer_set(struct dwc_ufs_hba *hba, u32 attr_id,
+	u32 gen_sel_index, u32 attr_val, u32 attr_set_type, u32 intr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_set command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_PEER_SET;
+	hba->active_dme_cmd.argument1 =3D ((attr_id << 16) | gen_sel_index);
+	hba->active_dme_cmd.argument2 =3D 0;
+
+	if (attr_set_type =3D=3D DWC_UFS_DME_ATTR_SET_TYPE_STATIC)
+		hba->active_dme_cmd.argument2 =3D
+					DWC_UFS_DME_ATTR_SET_TYPE_STATIC << 16;
+
+	hba->active_dme_cmd.argument3 =3D attr_val;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_enable()
+ * The function to perform the dme_enable operation
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or
+ *	- times-out
+ * @hba: Pointer to drivers structure
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_enable(struct dwc_ufs_hba *hba, u32 intr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_enable command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_ENABLE;
+	hba->active_dme_cmd.argument1 =3D 0;
+	hba->active_dme_cmd.argument2 =3D 0;
+	hba->active_dme_cmd.argument3 =3D 0;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_reset()
+ * The function to reset unipro stack
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @reset_level: Warm reset or cold reset
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_reset(struct dwc_ufs_hba *hba, u32 reset_level, u32 in=
tr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_reset command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_RESET;
+	if (reset_level =3D=3D DWC_UFS_DME_RESET_LEVEL_WARM)
+		hba->active_dme_cmd.argument1 =3D DWC_UFS_DME_RESET_LEVEL_WARM;
+	else if (reset_level =3D=3D DWC_UFS_DME_RESET_LEVEL_COLD)
+		hba->active_dme_cmd.argument1 =3D DWC_UFS_DME_RESET_LEVEL_COLD;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_endpointreset()
+ * The function to reset the endpoint
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_endpointreset(struct dwc_ufs_hba *hba, u32 intr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_endpointreset command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_ENDPOINTRESET;
+	hba->active_dme_cmd.argument1 =3D 0;
+	hba->active_dme_cmd.argument2 =3D 0;
+	hba->active_dme_cmd.argument3 =3D 0;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_hibernate_enter()
+ * The function to put the unipro to hibernate stste
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_hibernate_enter(struct dwc_ufs_hba *hba, u32 intr_mode=
)
+{
+	int result =3D 0;
+	unsigned long flags_irq;
+	u32 hcs;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_hibernate_enter command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_HIBERNATE_ENTER;
+	hba->active_dme_cmd.argument1 =3D 0;
+	hba->active_dme_cmd.argument2 =3D 0;
+	hba->active_dme_cmd.argument3 =3D 0;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_hibernate_exit()
+ * The function to exit the hibernate state for unipro
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @intr_mode: interrupt to be enabled or not
+ *
+ * Returns 0 for success and non-zero value for failure
+ */
+int dwc_ufs_dme_hibernate_exit(struct dwc_ufs_hba *hba, u32 intr_mode)
+{
+	int result =3D 0;
+	unsigned long flags_irq;
+	u32 hcs;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the dme_hibernate_exit command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_HIBERNATE_EXIT;
+	hba->active_dme_cmd.argument1 =3D 0;
+	hba->active_dme_cmd.argument2 =3D 0;
+	hba->active_dme_cmd.argument3 =3D 0;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+		(hba->dme_completion_handler_type =3D=3D
+		 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufs_dme_link_startup()
+ * This function initiate the Unipro Link startup procedure.
+ * It is caller's responsibility ensure HC is enabled before invoking =
this
+ * function.
+ * If intr_mode indicates that interrupt is not required, the functin =
blocks
+ * untile the command completes.
+ * If intr_mode indicates that interrupt is required, and the interrup=
t
+ * handling is wait queue type
+ *	- execution thread waits on the wait queue until one of the followi=
ng
+ *	occurs
+ *	- woken up by ISR after receiving the interrupt or times-out
+ * @hba: Pointer to drivers structure
+ * @intr_mode: indicates whether interrupt to be enabled or not
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+int dwc_ufs_dme_linkstartup(struct dwc_ufs_hba *hba, u32 intr_mode)
+{
+	unsigned long flags_irq;
+	u32 hcs;
+	int result =3D 0;
+
+	/* Check if DWC HC is ready to accept DME commands */
+	hcs =3D dwc_ufs_readl(hba->mmio_base, DWC_UFS_REG_HCS);
+	if (dwc_ufshcd_is_dme_sap_ready(hcs) =3D=3D false) {
+		pr_err("Hardware (DME) Busy\n");
+		return -EIO;
+	}
+
+	/* Only One DME command at a time */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* Prepare the link_startup command */
+	hba->active_dme_cmd.command =3D DWC_UFS_DME_LINKSTARTUP;
+	hba->active_dme_cmd.argument1 =3D 0;
+	hba->active_dme_cmd.argument2 =3D 0;
+	hba->active_dme_cmd.argument3 =3D 0;
+
+	/* Enable UIC Interrupt if required */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) {
+		hba->intr_enable_mask |=3D DWC_UFS_UCCE;
+		dwc_ufshcd_configure_interrupt(hba, DWC_UFS_HCD_INTR_ENABLE);
+	}
+
+	/* Send UIC Command */
+	dwc_ufshcd_send_dme_command(hba);
+
+	/* if Interrupt is not enabled use polling mode */
+	if (intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_DISABLE)
+		dwc_ufshcd_handle_dme_command_completion_wo_intr(hba);
+
+	/* With this lock held is DME access atomic on SMP? */
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* If interrupt is enabled and the handler type is wait queue, block
+	 * here till interrupt wakes it up */
+	if ((intr_mode =3D=3D DWC_UFS_HCD_DME_INTR_ENABLE) &&
+			(hba->dme_completion_handler_type =3D=3D
+			 DWC_UFS_HANDLER_WAIT_QUEUE_TYPE)) {
+		result =3D wait_event_interruptible_timeout(hba->dwc_ufshcd_dme_wait=
_queue,
+				(hba->active_dme_cmd.cmd_active =3D=3D 0),
+				DWC_UFS_DME_TIMEOUT);
+
+		if (result =3D=3D 0) {
+			pr_err("DME Command Timed-out\n");
+			result =3D FAILED;
+		} else {
+			dwc_ufshcd_update_dme_cmd_results(hba);
+			result =3D 0;
+		}
+	}
+
+	return result;
+}
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC
+/**
+ * dwc_ufs_dme_setup_snps_mphy()
+ * This function configures Local (host) Synopsys MPHY specific
+ * attributes
+ * @hba: Pointer to drivers structure
+ * @intr_mode: indicates whether interrupt to be enabled or not
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+int dwc_ufs_dme_setup_snps_mphy(struct dwc_ufs_hba *hba, u32 intr_mode=
)
+{
+	int result =3D 0;
+
+	/* Before doing mphy attribute programming; understand about
+	 * the available lanes
+	 */
+	dwc_ufs_dme_get(hba, UNIPRO_TX_LANES, 0, intr_mode);
+	hba->linfo.pa_ava_tx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+	dwc_ufs_dme_get(hba, UNIPRO_RX_LANES, 0, intr_mode);
+	hba->linfo.pa_ava_rx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+
+	/* Synopsys MPHY Configuration */
+#ifdef CONFIG_SCSI_DWC_UFS_40BIT_RMMI
+	/******************** Common Block *******************/
+
+	/* Common block Tx Global Hibernate Exit */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_GLOBAL_HIBERNATE,
+				SEL_INDEX_LANE0_TX, 0x00, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common block Reference Clock Mode 26MHzt */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_REF_CLOCK,
+				SEL_INDEX_LANE0_TX, 0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common block DCO Target Frequency MAX PWM G1:7Mpbs */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_TARGET_FREQ,
+				SEL_INDEX_LANE0_TX, 0x80, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common block TX and RX Div Factor is 4 7Mbps/40 =3D 175KHz */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_CLK_DIV_RATIO,
+				SEL_INDEX_LANE0_TX, 0x08, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common Block */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_DCO_CTRL_5,
+				SEL_INDEX_LANE0_TX, 0x64, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common Block */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_PRG_TUNNING,
+				SEL_INDEX_LANE0_TX, 0x09, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common Block Real Time Observe Select; For debugging */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_REAL_TIME_OBS,
+				SEL_INDEX_LANE0_TX, 0x00, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+
+	/********************** Lane 0 *******************/
+
+	/* Tx0 Reference Clock 26MHz */
+	if (dwc_ufs_dme_set(hba, MPHY_TARGET_REF_CLK, SEL_INDEX_LANE0_TX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* TX0 Configuration Clock Frequency Val; Divider setting */
+	if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV, SEL_INDEX_LANE0_TX,
+				0x19, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* TX0 40bit RMMI Interface */
+	if (dwc_ufs_dme_set(hba, MPHY_SEV_CTRL_PARM, SEL_INDEX_LANE0_TX,
+				0x14, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* TX0  */
+	if (dwc_ufs_dme_set(hba, MPHY_TX_INT_EXT_DIFF, SEL_INDEX_LANE0_TX,
+				0xd6, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Rx0 Reference Clock 26MHz */
+	if (dwc_ufs_dme_set(hba, MPHY_TARGET_REF_CLK, SEL_INDEX_LANE0_RX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RX0 Configuration Clock Frequency Val; Divider setting */
+	if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV, SEL_INDEX_LANE0_RX,
+				0x19, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RX0 40bit RMMI Interface */
+	if (dwc_ufs_dme_set(hba, MPHY_SEV_CTRL_PARM, SEL_INDEX_LANE0_RX,
+				4, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RX0 Squelch Detector output is routed to RX hibernate Exit
+	 * Type1 signal
+	 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_HIBERN8, SEL_INDEX_LANE0_RX,
+				0x80, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* DIRECTCTRL10 */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_DIRECTCTRL10,
+				SEL_INDEX_LANE0_TX, 0x04, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* DIRECTCTRL19 */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_DIRECTCTRL19,
+				SEL_INDEX_LANE0_TX, 0x02, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* ENARXDIRECTCFG4 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG4, SEL_INDEX_LANE0_RX,
+				0x03, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CFGRXOVR8 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CFG_OVER8, SEL_INDEX_LANE0_RX,
+				0x16, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RXDIRECTCTRL2 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_DIRECT_CTRL2, SEL_INDEX_LANE0_RX,
+				0x42, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* ENARXDIRECTCFG3 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG3, SEL_INDEX_LANE0_RX,
+				0xa4, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RXCALCTRL */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CAL_CTRL, SEL_INDEX_LANE0_RX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* ENARXDIRECTCFG2 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG2, SEL_INDEX_LANE0_RX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CFGOVR4 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CFGRXOVR4, SEL_INDEX_LANE0_RX,
+				0x28, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RXSQCTRL */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_RXSQCTRL, SEL_INDEX_LANE0_RX,
+				0x1E, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CFGOVR6 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CFGRXOVR6, SEL_INDEX_LANE0_RX,
+				0x2f, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CBPRGPLL2 */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_CFG_PRG_PLL2,
+				SEL_INDEX_LANE0_TX, 0x00, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+#else
+
+	/******************** Common Block *******************/
+
+	/* Common block Tx Global Hibernate Exit */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_GLOBAL_HIBERNATE,
+				SEL_INDEX_LANE0_TX, 0x00, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common block Reference Clokc Mode 26MHzt */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_REF_CLOCK,
+				SEL_INDEX_LANE0_TX, 0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common block DCO Target Frequency MAX PWM G1:9Mpbs */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_TARGET_FREQ,
+				SEL_INDEX_LANE0_TX, 0xc0, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+
+	/* Common block TX and RX Div Factor is 4 7Mbps/20 =3D 350KHz */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_CLK_DIV_RATIO,
+				SEL_INDEX_LANE0_TX, 0x44, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common Block  */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_DCO_CTRL_5,
+				SEL_INDEX_LANE0_TX, 0x64, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common Block */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_PRG_TUNNING,
+				SEL_INDEX_LANE0_TX, 0x09, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Common Block Real Time Observe Select; For debugging */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_REAL_TIME_OBS,
+				SEL_INDEX_LANE0_TX, 0x00, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+
+	/********************** Lane 0 *******************/
+
+	/* Tx0 Reference Clock 26MHz */
+	if (dwc_ufs_dme_set(hba, MPHY_TARGET_REF_CLK, SEL_INDEX_LANE0_TX,
+				0x0d, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC_GEN2
+	/* TX0 Configuration Clock Frequency Val; Divider setting */
+	if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV, SEL_INDEX_LANE0_TX,
+				0x19, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RX0 Configuration Clock Frequency Val; Divider setting */
+	if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV, SEL_INDEX_LANE0_RX,
+				0x19, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+#else
+	/* TX0 Configuration Clock Frequency Val; Divider setting */
+	if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV, SEL_INDEX_LANE0_TX,
+				0x1b, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RX0 Configuration Clock Frequency Val; Divider setting */
+	if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV, SEL_INDEX_LANE0_RX,
+				0x1b, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+#endif
+
+	/* TX0 20bit RMMI Interface */
+	if (dwc_ufs_dme_set(hba, MPHY_SEV_CTRL_PARM, SEL_INDEX_LANE0_TX,
+				0x12, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* TX0  */
+	if (dwc_ufs_dme_set(hba, MPHY_TX_INT_EXT_DIFF, SEL_INDEX_LANE0_TX,
+				0xd6, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Rx0 Reference Clock 26MHz */
+	if (dwc_ufs_dme_set(hba, MPHY_TARGET_REF_CLK, SEL_INDEX_LANE0_RX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RX0 20bit RMMI Interface */
+	if (dwc_ufs_dme_set(hba, MPHY_SEV_CTRL_PARM, SEL_INDEX_LANE0_RX,
+				2, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RX0 Squelch Detector output is routed to RX hibernate Exit
+	 * Type1 signal
+	 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_HIBERN8, SEL_INDEX_LANE0_RX,
+				0x80, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC_GEN2
+	/* DIRECTCTRL10 */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_DIRECTCTRL10,
+				SEL_INDEX_LANE0_TX, 0x04, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* DIRECTCTRL19 */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_DIRECTCTRL19,
+				SEL_INDEX_LANE0_TX, 0x02, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* ENARXDIRECTCFG4 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG4, SEL_INDEX_LANE0_RX,
+				0x03, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CFGRXOVR8 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CFG_OVER8, SEL_INDEX_LANE0_RX,
+				0x16, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RXDIRECTCTRL2 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_DIRECT_CTRL2, SEL_INDEX_LANE0_RX,
+				0x42, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* ENARXDIRECTCFG3 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG3, SEL_INDEX_LANE0_RX,
+				0xa4, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RXCALCTRL */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CAL_CTRL, SEL_INDEX_LANE0_RX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* ENARXDIRECTCFG2 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG2, SEL_INDEX_LANE0_RX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CFGOVR4 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CFGRXOVR4, SEL_INDEX_LANE0_RX,
+				0x28, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* RXSQCTRL */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_RXSQCTRL, SEL_INDEX_LANE0_RX,
+				0x1E, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CFGOVR6 */
+	if (dwc_ufs_dme_set(hba, MPHY_RX_CFGRXOVR6, SEL_INDEX_LANE0_RX,
+				0x2f, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* CBPRGPLL2 */
+	if (dwc_ufs_dme_set(hba, UNIPRO_COMMON_BLK|MPHY_CB_CFG_PRG_PLL2,
+				SEL_INDEX_LANE0_TX, 0x00, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+#endif
+
+	/********************** Lane 1 *******************/
+
+	if (hba->linfo.pa_ava_tx_data_lanes_local =3D=3D 2) {
+		/* Tx1 Reference Clock 26MHz */
+		if (dwc_ufs_dme_set(hba, MPHY_TARGET_REF_CLK,
+				SEL_INDEX_LANE1_TX, 0x0d, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC_GEN2
+		/* TX1 Configuration Clock Frequency Val; Divider setting */
+		if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV,
+				SEL_INDEX_LANE1_TX, 0x19, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+#else
+		/* TX1 Configuration Clock Frequency Val; Divider setting */
+		if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV,
+				SEL_INDEX_LANE1_TX, 0x1b, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+#endif
+
+		/* TX1 20bit RMMI Interface */
+		if (dwc_ufs_dme_set(hba, MPHY_SEV_CTRL_PARM, SEL_INDEX_LANE1_TX,
+				0x12, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* TX1  */
+		if (dwc_ufs_dme_set(hba, MPHY_TX_INT_EXT_DIFF,
+				SEL_INDEX_LANE1_TX, 0xd6, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+	}
+
+	if (hba->linfo.pa_ava_rx_data_lanes_local =3D=3D 2) {
+		/* Rx1 Reference Clock 26MHz */
+		if (dwc_ufs_dme_set(hba, MPHY_TARGET_REF_CLK,
+				SEL_INDEX_LANE1_RX, 0x01, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC_GEN2
+		/* RX1 Configuration Clock Frequency Val; Divider setting */
+		if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV,
+				SEL_INDEX_LANE1_RX, 0x19, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+#else
+		/* RX1 Configuration Clock Frequency Val; Divider setting */
+		if (dwc_ufs_dme_set(hba, MPHY_SETS_INTERNAL_DIV,
+				SEL_INDEX_LANE1_RX, 0x1b, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+#endif
+
+		/* RX1 20bit RMMI Interface */
+		if (dwc_ufs_dme_set(hba, MPHY_SEV_CTRL_PARM, SEL_INDEX_LANE1_RX,
+				2, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* RX1 Squelch Detector output is routed to RX hibernate Exit
+		 * Type1 signal
+		 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_HIBERN8, SEL_INDEX_LANE1_RX,
+				0x80, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC_GEN2
+
+		/* ENARXDIRECTCFG4 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG4,
+				SEL_INDEX_LANE1_RX, 0x03, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* CFGRXOVR8 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_CFG_OVER8, SEL_INDEX_LANE1_RX,
+				0x16, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* RXDIRECTCTRL2 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_DIRECT_CTRL2,
+				SEL_INDEX_LANE1_RX, 0x42, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* ENARXDIRECTCFG3 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG3,
+				SEL_INDEX_LANE1_RX, 0xa4, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* RXCALCTRL */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_CAL_CTRL, SEL_INDEX_LANE1_RX,
+				0x01, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* ENARXDIRECTCFG2 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_SEV_CDR_CFG2,
+				SEL_INDEX_LANE1_RX, 0x01, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* CFGOVR4 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_CFGRXOVR4, SEL_INDEX_LANE1_RX,
+				0x28, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* RXSQCTRL */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_RXSQCTRL, SEL_INDEX_LANE1_RX,
+				0x1E, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+
+		/* CFGOVR6 */
+		if (dwc_ufs_dme_set(hba, MPHY_RX_CFGRXOVR6, SEL_INDEX_LANE1_RX,
+				0x2f, 0, intr_mode) !=3D 0)
+			goto err_dme_set;
+		if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+			goto err_dme_set;
+#endif
+	}
+
+#endif
+	/* To write Shadow register bank to effective configuration block */
+	if (dwc_ufs_dme_set(hba, UNIPRO_CFG_UPDATE, SEL_INDEX_LANE0_TX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* To configure Debug OMC */
+	if (dwc_ufs_dme_set(hba, UNIPRO_DBG_OMC, SEL_INDEX_LANE0_TX,
+				0x01, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	pr_info("Mphy Setup completed\n");
+
+	return result;
+
+err_dme_set:
+	result =3D FAILED;
+	return result;
+}
+#endif
+
+/**
+ * dwc_ufs_do_dme_connection_setup()
+ * This function configures both the local side (host) and the peer si=
de
+ * (device) unipro attributes to establish the connection to applicati=
on/
+ * cport.
+ * This function is not required if the hardware is properly configure=
d to
+ * have this connection setup on reset. But invoking this function doe=
s no
+ * harm and should be fine even working with any ufs device.
+ * The Unipro attributes programmed here are in line with the JEDEC sp=
ecs.
+ * This function inturn invokes series of dme_set functions set unipro
+ * attributes.
+ * @hba: Pointer to drivers structure
+ * @intr_mode: indicates whether interrupt to be enabled or not
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+int dwc_ufs_do_dme_connection_setup(struct dwc_ufs_hba *hba, u32 intr_=
mode)
+{
+	int result =3D 0;
+
+	/* Local side Configuration */
+	/* Before setting other attributes connection state to be set to 0 */
+	if (dwc_ufs_dme_set(hba, UNIPRO_CPORT_CON_STAT, SEL_INDEX_LANE0_TX,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_LOCAL_DEV_ID, SEL_INDEX_LANE0_TX,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_LOCAL_DEV_ID_VAL, SEL_INDEX_LANE0_TX,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_PEER_DEV_ID, SEL_INDEX_LANE0_TX,
+				1, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_PEER_CPORT_ID, SEL_INDEX_LANE0_TX,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_TRAFFIC_CLASS, SEL_INDEX_LANE0_TX,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_CPORT_FLAGS, SEL_INDEX_LANE0_TX,
+				0x6, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_CPORT_MODE, SEL_INDEX_LANE0_TX,
+				1, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_set(hba, UNIPRO_CPORT_CON_STAT, SEL_INDEX_LANE0_TX,
+				1, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	/* Peer side Configuration */
+	/* Before setting other attributes connection state to be set to 0 */
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_CPORT_CON_STAT, SEL_INDEX_LANE0_=
TX,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_LOCAL_DEV_ID, SEL_INDEX_LANE0_TX=
,
+				1, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_LOCAL_DEV_ID_VAL,
+				SEL_INDEX_LANE0_TX, 1, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_PEER_DEV_ID, SEL_INDEX_LANE0_TX,
+				1, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_PEER_CPORT_ID, SEL_INDEX_LANE0_T=
X,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_TRAFFIC_CLASS, SEL_INDEX_LANE0_T=
X,
+				0, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_CPORT_FLAGS, SEL_INDEX_LANE0_TX,
+				0x6, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_CPORT_MODE, SEL_INDEX_LANE0_TX,
+				1, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	if (dwc_ufs_dme_peer_set(hba, UNIPRO_CPORT_CON_STAT, SEL_INDEX_LANE0_=
TX,
+				1, 0, intr_mode) !=3D 0)
+		goto err_dme_peer_set;
+	if (dwc_ufshcd_get_dme_command_results(hba) !=3D 0)
+		goto err_dme_set;
+
+	pr_info("Connection has been established\n");
+
+	return result;
+
+err_dme_set:
+err_dme_peer_set:
+	result =3D FAILED;
+	return result;
+}
+
+/**
+ * dwc_ufs_update_link_info()
+ * This function doesnot check for errors.
+ * We always expect this function works without errors. And this is a =
valid
+ * assumption to make as the link is in pwm gear and we are just readi=
ng
+ * attributes.
+ *
+ */
+int dwc_ufs_update_link_info(struct dwc_ufs_hba *hba, u32 intr_mode)
+{
+	int result =3D 0;
+
+	dwc_ufs_dme_get(hba, UNIPRO_RX_LANES, 0, intr_mode);
+	hba->linfo.pa_ava_tx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_RX_LANES, 0, intr_mode);
+	hba->linfo.pa_ava_tx_data_lanes_peer =3D hba->active_dme_cmd.argument=
3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_TX_LANES, 0, intr_mode);
+	hba->linfo.pa_ava_rx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_TX_LANES, 0, intr_mode);
+
+	hba->linfo.pa_ava_rx_data_lanes_peer =3D hba->active_dme_cmd.argument=
3;
+	dwc_ufs_dme_get(hba, UNIPRO_CON_TX_LANES, 0, intr_mode);
+	hba->linfo.pa_con_tx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_CON_TX_LANES, 0, intr_mode);
+	hba->linfo.pa_con_tx_data_lanes_peer =3D hba->active_dme_cmd.argument=
3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_CON_RX_LANES, 0, intr_mode);
+	hba->linfo.pa_con_rx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_CON_RX_LANES, 0, intr_mode);
+	hba->linfo.pa_con_rx_data_lanes_peer =3D hba->active_dme_cmd.argument=
3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_ACTIVE_TX_LANES, 0, intr_mode);
+	hba->linfo.pa_act_tx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_ACTIVE_TX_LANES, 0, intr_mode);
+	hba->linfo.pa_act_tx_data_lanes_peer =3D hba->active_dme_cmd.argument=
3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_ACTIVE_RX_LANES, 0, intr_mode);
+	hba->linfo.pa_act_rx_data_lanes_local =3D hba->active_dme_cmd.argumen=
t3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_ACTIVE_RX_LANES, 0, intr_mode);
+	hba->linfo.pa_act_rx_data_lanes_peer =3D hba->active_dme_cmd.argument=
3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_RX_MAX_PWM_GEAR, 0, intr_mode);
+	hba->linfo.pa_max_rx_pwm_gear_local =3D hba->active_dme_cmd.argument3=
;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_RX_MAX_PWM_GEAR, 0, intr_mode);
+	hba->linfo.pa_max_rx_pwm_gear_peer =3D hba->active_dme_cmd.argument3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_RX_MAX_HS_GEAR, 0, intr_mode);
+	hba->linfo.pa_max_rx_hs_gear_local =3D hba->active_dme_cmd.argument3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_RX_MAX_HS_GEAR, 0, intr_mode);
+	hba->linfo.pa_max_rx_hs_gear_peer =3D hba->active_dme_cmd.argument3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_HS_SERIES, 0, intr_mode);
+	hba->linfo.pa_hs_series_local =3D hba->active_dme_cmd.argument3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_HS_SERIES, 0, intr_mode);
+	hba->linfo.pa_hs_series_peer =3D hba->active_dme_cmd.argument3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_PWR_MODE, 0, intr_mode);
+	hba->linfo.pa_pwr_mode_local =3D hba->active_dme_cmd.argument3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_PWR_MODE, 0, intr_mode);
+	hba->linfo.pa_pwr_mode_peer =3D hba->active_dme_cmd.argument3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_TX_PWR_STATUS, 0, intr_mode);
+	hba->linfo.pa_tx_pwr_status_local =3D hba->active_dme_cmd.argument3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_TX_PWR_STATUS, 0, intr_mode);
+	hba->linfo.pa_tx_pwr_status_peer =3D hba->active_dme_cmd.argument3;
+
+	dwc_ufs_dme_get(hba, UNIPRO_RX_PWR_STATUS, 0, intr_mode);
+	hba->linfo.pa_rx_pwr_status_local =3D hba->active_dme_cmd.argument3;
+	dwc_ufs_dme_peer_get(hba, UNIPRO_RX_PWR_STATUS, 0, intr_mode);
+	hba->linfo.pa_rx_pwr_status_peer =3D hba->active_dme_cmd.argument3;
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_update_dm_results()
+ * This function does the post processing for the sent device manageme=
nt
+ * command.
+ * Only Nopout and flag operations are supported as of now
+ * TODO: Update for other query commands if required
+ */
+int dwc_ufshcd_update_dm_results(struct dwc_ufs_hba *hba, u32 slot_ind=
ex)
+{
+	int result =3D 0;
+	struct dwc_ufs_nopin_upiu *nopin_upiu =3D NULL;
+	struct dwc_ufs_query_resp_upiu *query_resp_upiu =3D NULL;
+	unsigned long flags_irq;
+
+	clear_bit(slot_index, &hba->outstanding_dm_requests);
+	clear_bit(slot_index, &hba->dwc_ufshcd_dm_condition);
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	switch (hba->dm_lrb.trans_type) {
+	case UPIU_TRANS_CODE_NOP_OUT:
+		nopin_upiu =3D (struct dwc_ufs_nopin_upiu *)
+			(hba->ucdl_base_addr + slot_index)->resp_upiu;
+
+		if (nopin_upiu->trans_type =3D=3D UPIU_TRANS_CODE_NOP_IN)
+			hba->dm_lrb.dm_cmd_results =3D 0;
+		break;
+	case UPIU_TRANS_CODE_QUERY_REQ:
+		query_resp_upiu =3D (struct dwc_ufs_query_resp_upiu *)
+			(hba->ucdl_base_addr + slot_index)->resp_upiu;
+
+		if (query_resp_upiu->txn_specific_flds_1[0] =3D=3D
+					UPIU_QUERY_OPCODE_READ_FLAG) {
+			hba->dm_lrb.dm_cmd_results =3D
+				query_resp_upiu->txn_specific_flds_3[3];
+		} else if (query_resp_upiu->txn_specific_flds_1[0] =3D=3D
+						UPIU_QUERY_OPCODE_SET_FLAG) {
+			/*TODO: Fix this once clarified by JEDEC
+			 * FLAG VALUE after setting is not clear:
+			 * whether it shoudl be new updated value
+			 * or the old value?
+			 */
+			hba->dm_lrb.dm_cmd_results =3D
+				DWC_UFS_SET_FLAG_RESULT_EXPECTED;
+		} else
+			pr_err("Not implemented opcode code:%x\n",
+			query_resp_upiu->txn_specific_flds_1[0]);
+
+		break;
+
+	default:
+		pr_err("Unknown transaction code:%x\n",
+				hba->dm_lrb.trans_type);
+	}
+
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_prepare_and_send_dm_cmd_upiu()
+ * This function prepares and send the dm command
+ * Pre-requisite to this function invocation is to popoulate dm_lrb
+ * structure of drivers private data with appropriate data using the
+ * helper function provided.
+ * This function
+ *  - gets the free slot for dm command sending
+ *  - populates the required elements of
+ *    - utrd
+ *    - cmd upiu
+ *  - invokes the send command function
+ *  - Blocks itself on a wait queue
+ *  - inovkes the function to update dm command results
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success, non-zero value on failure
+ */
+int dwc_ufshcd_prepare_and_send_dm_cmd_upiu(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+	int free_slot =3D 0;
+	struct dwc_ufs_utrd *utrd;
+	struct dwc_ufs_query_req_upiu *query_req_upiu =3D NULL;
+	struct dwc_ufs_nopout_upiu *nopout_upiu =3D NULL;
+	unsigned long flags_irq;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+
+	/* If task management queue is full */
+	free_slot =3D dwc_ufshcd_get_xfer_req_free_slot(hba);
+	if (free_slot >=3D hba->nutmrs) {
+		spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+		pr_err("Xfer Req queue is full\n");
+		result =3D FAILED;
+		goto err_dm_req_queue_is_full;
+	}
+
+	/* Get the base address of Xfer Req list base address */
+	utrd =3D hba->utrl_base_addr;
+
+	/* Get the xfer descriptor of the free slot */
+	utrd +=3D free_slot;
+
+	/* Configure xfer request descriptor */
+	/* Updating to ensure backward compatibility with older host
+	 * controllers
+	 */
+	if (hba->dwc_ufs_version =3D=3D DWC_UFS_HC_VERSION_2_0)
+		utrd->ct_and_flags =3D DWC_UTRD_CMD_TYPE_UFS_STORAGE |
+							DWC_UTRD_INTR_CMD;
+	else
+		utrd->ct_and_flags =3D DWC_UTRD_CMD_TYPE_DEV_MANAGE_FN |
+							DWC_UTRD_INTR_CMD;
+
+	utrd->ocs =3D OCS_INVALID_COMMAND_STATUS;
+
+	switch (hba->dm_lrb.trans_type) {
+	case UPIU_TRANS_CODE_NOP_OUT:
+		nopout_upiu =3D (struct dwc_ufs_nopout_upiu *)
+			(hba->ucdl_base_addr + free_slot)->cmd_upiu;
+		memset(nopout_upiu, 0, DWC_UCD_ALIGN * 2);
+		nopout_upiu->trans_type =3D hba->dm_lrb.trans_type;
+		nopout_upiu->flags	=3D hba->dm_lrb.flags;
+
+		/* TODO: the task tag may conflict with transport
+		 * layer commands task_tag
+		 */
+		nopout_upiu->task_tag   =3D free_slot;
+		break;
+	case UPIU_TRANS_CODE_QUERY_REQ:
+		/* For UFS native command implementation */
+		/* UPIU Command formation */
+		query_req_upiu =3D (struct dwc_ufs_query_req_upiu *)
+			(hba->ucdl_base_addr + free_slot)->cmd_upiu;
+		memset(query_req_upiu, 0, DWC_UCD_ALIGN * 2);
+		query_req_upiu->trans_type =3D hba->dm_lrb.trans_type;
+		query_req_upiu->flags	   =3D hba->dm_lrb.flags;
+
+		/* TODO: the task tag may conflict with transport
+		 * layer commands task_tag */
+		query_req_upiu->task_tag   =3D free_slot;
+		query_req_upiu->query_fn =3D hba->dm_lrb.query_fn;
+		query_req_upiu->tot_ehs_len =3D 0;
+		query_req_upiu->data_seg_len =3D cpu_to_be16(0);
+		memcpy(query_req_upiu->txn_specific_flds_1,
+				hba->dm_lrb.tsf, DWC_UFS_TSF_SIZE);
+		break;
+	default:
+		break;
+	}
+
+	/* send command to the controller */
+	dwc_ufshcd_send_dm_req_command(hba, free_slot);
+
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	/* wait until the task management command is completed */
+	result =3D
+		wait_event_interruptible_timeout(hba->dwc_ufshcd_dm_wait_queue,
+		(test_bit(free_slot, &hba->dwc_ufshcd_dm_condition) !=3D 0),
+				DWC_UFS_DM_TIMEOUT);
+	if (result =3D=3D 0) {
+		pr_err("Device Management Req Timed-out\n");
+		clear_bit(free_slot, &hba->dwc_ufshcd_dm_condition);
+		clear_bit(free_slot, &hba->outstanding_dm_requests);
+
+		/* Force Clear the Doorbell */
+		dwc_ufshcd_clear_xfre_req(hba, free_slot);
+		result =3D FAILED;
+		goto err_dm_req_timeout;
+	} else
+		result =3D dwc_ufshcd_update_dm_results(hba, free_slot);
+
+err_dm_req_timeout:
+err_dm_req_queue_is_full:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_prepare_nopout_cmd()
+ * Helper function to prepare the nopout command
+ * @hba: Pointer to drivers structure
+ *
+ * Return zero on success; Non zero value on failure
+ */
+int dwc_ufshcd_prepare_nopout_cmd(struct dwc_ufs_hba *hba)
+{
+	unsigned long flags_irq;
+	int result =3D 0;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+	memset(&hba->dm_lrb, 0, sizeof(struct dwc_ufshcd_dm_lrb));
+
+	hba->dm_lrb.trans_type =3D UPIU_TRANS_CODE_NOP_OUT;
+	hba->dm_lrb.flags =3D 0;
+	hba->dm_lrb.lun =3D 0;
+	hba->dm_lrb.dm_cmd_results =3D -1;
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_prepare_read_flag_cmd()
+ * Helper function to prepare the read_flag command
+ * @hba: Pointer to drivers structure
+ * @flag_type: flag types as per JEDEC spec
+ *
+ * Return zero on success; Non zero value on failure
+ */
+int dwc_ufshcd_prepare_read_flag_cmd(struct dwc_ufs_hba *hba, u8 flag_=
type)
+{
+	unsigned long flags_irq;
+	int result =3D 0;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+	memset(&hba->dm_lrb, 0, sizeof(struct dwc_ufshcd_dm_lrb));
+
+	hba->dm_lrb.trans_type =3D UPIU_TRANS_CODE_QUERY_REQ;
+	hba->dm_lrb.flags =3D 0;
+	hba->dm_lrb.query_fn =3D UPIU_QUERY_STD_READ_REQUEST;
+	hba->dm_lrb.tsf[0] =3D UPIU_QUERY_OPCODE_READ_FLAG;
+	hba->dm_lrb.tsf[1] =3D flag_type;
+
+	hba->dm_lrb.dm_cmd_results =3D -1;
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_prepare_set_flag_cmd()
+ * Helper function to prepare the set_flag command
+ * @hba: Pointer to drivers structure
+ * @flag_type: flag types as per JEDEC spec
+ *
+ * Return zero on success; Non zero value on failure
+ */
+int dwc_ufshcd_prepare_set_flag_cmd(struct dwc_ufs_hba *hba, u8 flag_t=
ype)
+{
+	unsigned long flags_irq;
+	int result =3D 0;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+	memset(&hba->dm_lrb, 0, sizeof(struct dwc_ufshcd_dm_lrb));
+
+	hba->dm_lrb.trans_type =3D UPIU_TRANS_CODE_QUERY_REQ;
+	hba->dm_lrb.flags =3D 0;
+	hba->dm_lrb.query_fn =3D UPIU_QUERY_STD_WRITE_REQUEST;
+	hba->dm_lrb.tsf[0] =3D UPIU_QUERY_OPCODE_SET_FLAG;
+	hba->dm_lrb.tsf[1] =3D flag_type;
+
+	hba->dm_lrb.dm_cmd_results =3D -1;
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_prepare_clear_flag_cmd()
+ * Helper function to prepare the clear_flag command
+ * @hba: Pointer to drivers structure
+ * @flag_type: flag types as per JEDEC spec
+ *
+ * Return zero on success; Non zero value on failure
+ */
+int dwc_ufshcd_prepare_clear_flag_cmd(struct dwc_ufs_hba *hba, u8 flag=
_type)
+{
+	unsigned long flags_irq;
+	int result =3D 0;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+	memset(&hba->dm_lrb, 0, sizeof(struct dwc_ufshcd_dm_lrb));
+
+	hba->dm_lrb.trans_type =3D UPIU_TRANS_CODE_QUERY_REQ;
+	hba->dm_lrb.flags =3D 0;
+	hba->dm_lrb.query_fn =3D UPIU_QUERY_STD_WRITE_REQUEST;
+	hba->dm_lrb.tsf[0] =3D UPIU_QUERY_OPCODE_CLEAR_FLAG;
+	hba->dm_lrb.tsf[1] =3D flag_type;
+
+	hba->dm_lrb.dm_cmd_results =3D -1;
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_prepare_toggle_flag_cmd()
+ * Helper function to prepare the toggle_flag command
+ * @hba: Pointer to drivers structure
+ * @flag_type: flag types as per JEDEC spec
+ *
+ * Return zero on success; Non zero value on failure
+ */
+int dwc_ufshcd_prepare_toggle_flag_cmd(struct dwc_ufs_hba *hba, u8 fla=
g_type)
+{
+	unsigned long flags_irq;
+	int result =3D 0;
+
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+	memset(&hba->dm_lrb, 0, sizeof(struct dwc_ufshcd_dm_lrb));
+	hba->dm_lrb.trans_type =3D UPIU_TRANS_CODE_QUERY_REQ;
+	hba->dm_lrb.flags =3D 0;
+	hba->dm_lrb.query_fn =3D UPIU_QUERY_STD_WRITE_REQUEST;
+	hba->dm_lrb.tsf[0] =3D UPIU_QUERY_OPCODE_TOGGLE_FLAG;
+	hba->dm_lrb.tsf[1] =3D flag_type;
+
+	hba->dm_lrb.dm_cmd_results =3D -1;
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+	return result;
+}
+
+/**
+ * dwc_ufs_initialize_ufs_device()
+ * This function performs the device initialization as per JEDEC spec.
+ * As part of this initialization
+ *  - It prepares and sends nopout command till
+ *     - it receives the nopin response from device or
+ *     - programmed retries exhaust
+ *  - It prepares and sends set_flag command for fdeviceInit
+ *  - It reads and checks fDeviceInit flag till
+ *     - the flag is clear/reset
+ *     - programmed retries exhaust
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int dwc_ufs_initialize_ufs_device(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+	int retry_count =3D DWC_UFS_RETRY_COUNT_NOPOUT;
+
+	/* As Per JEDEC220 Device initialization starts with nopout */
+	do {
+		pr_debug("Sending Nopout command\n");
+		dwc_ufshcd_prepare_nopout_cmd(hba);
+		dwc_ufshcd_prepare_and_send_dm_cmd_upiu(hba);
+		retry_count--;
+	} while ((hba->dm_lrb.dm_cmd_results !=3D 0) && (retry_count !=3D 0))=
;
+
+	if (retry_count =3D=3D 0) {
+		result =3D FAILED;
+		goto err_nopout;
+	}
+
+	pr_debug("Nopout sent successfully\n");
+
+	/* Only upon successful reception of nopin proceed further */
+
+	/* Prepare and send fDeviceInit flag */
+	pr_debug("Sending set flag for fDeviceInit\n");
+	dwc_ufshcd_prepare_set_flag_cmd(hba, UPIU_QUERY_FLAG_FDEVICEINIT);
+	dwc_ufshcd_prepare_and_send_dm_cmd_upiu(hba);
+
+	if (hba->dm_lrb.dm_cmd_results !=3D DWC_UFS_SET_FLAG_RESULT_EXPECTED)=
 {
+		result =3D FAILED;
+		goto err_set_fdevice_init;
+	}
+	pr_debug("fDeviceInit flag set successfully\n");
+
+	/* Check for fDeviceInit flag by reading back the flag */
+	retry_count =3D DWC_UFS_RETRY_COUNT_FLAGS;
+
+	do {
+		pr_debug("Sending Read flag for fDeviceInit\n");
+		dwc_ufshcd_prepare_read_flag_cmd(hba,
+						UPIU_QUERY_FLAG_FDEVICEINIT);
+		dwc_ufshcd_prepare_and_send_dm_cmd_upiu(hba);
+		retry_count--;
+	} while ((hba->dm_lrb.dm_cmd_results !=3D 0) && (retry_count !=3D 0))=
;
+
+	if (retry_count =3D=3D 0) {
+		pr_err("fDeviceInit is still set:%d\n",
+						hba->dm_lrb.dm_cmd_results);
+		result =3D FAILED;
+		goto err_read_fdevice_init;
+	}
+
+	pr_debug("fDeviceInit flag read successfully\n");
+
+	/* This completes the device initialization */
+
+err_read_fdevice_init:
+err_set_fdevice_init:
+err_nopout:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_initialize_hba_desc_pointers()
+ * This function performs the initialization of DWC UFS HC descriptors
+ * with memory base addresses
+ * Before updating the descriptor addresses, it checks host controller=
 is
+ * enabled. If not returns error. If enabled, both transfer descriptor
+ * pointers and tm descriptor pointers are programmed from the drivers
+ * private structure
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int dwc_ufshcd_initialize_hba_desc_pointers(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+
+	/* If the Host Controller is not active, return error */
+	if (dwc_ufshcd_is_hba_active(hba) =3D=3D false)
+		return -EIO;
+
+	/* Configure UTRL and UTMRL base address registers */
+	dwc_ufs_writel(lower_32_bits(hba->utrl_dma_addr), hba->mmio_base,
+							DWC_UFS_REG_UTRLBA);
+
+	dwc_ufs_writel(upper_32_bits(hba->utrl_dma_addr), hba->mmio_base,
+							DWC_UFS_REG_UTRLBAU);
+
+	dwc_ufs_writel(lower_32_bits(hba->utmrl_dma_addr), hba->mmio_base,
+							DWC_UFS_REG_UTMRLBA);
+
+	dwc_ufs_writel(upper_32_bits(hba->utmrl_dma_addr), hba->mmio_base,
+							DWC_UFS_REG_UTMRLBAU);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_connect()
+ * This function performs the host enable, phy configuration, link sta=
rtup
+ * and connection setup
+ * @hba: Pointer to drivers structure
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int dwc_ufshcd_connect(struct dwc_ufs_hba *hba)
+{
+	int link_startup_retries =3D 0;
+	int result =3D 0;
+
+	for (link_startup_retries =3D 0;
+			link_startup_retries < DWC_UFS_RETRY_COUNT_LINKSTARTUP;
+			link_startup_retries++) {
+
+		/* Enable Host Controller */
+		dwc_ufshcd_host_enable(hba);
+
+		/* Program Clock Divider Value */
+		dwc_ufshcd_program_clk_div(hba, DWC_UFSHCD_CLK_DIV_125);
+
+		/* Provide some delay: TODO: How to quantify this delay */
+		mdelay(10);
+
+		/* Initialization routine */
+		result =3D dwc_ufshcd_initialize_hba_desc_pointers(hba);
+
+		if (result !=3D 0) {
+			pr_err("UFSHCD Initialization Failed\n");
+			goto err_hcd_init;
+		}
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC
+		/* Initiate Synopsys MPHY */
+		result =3D dwc_ufs_dme_setup_snps_mphy(hba,
+						DWC_UFS_HCD_DME_INTR_DISABLE);
+		if (result !=3D 0)
+			goto err_dme_setup_snps_mphy;
+
+		pr_info("SNPS Mphy Setup Successful\n");
+#endif
+
+		result =3D dwc_ufs_dme_linkstartup(hba,
+						DWC_UFS_HCD_DME_INTR_ENABLE);
+
+		if (result !=3D 0)
+			pr_info("Link Startup Failed %d times\n",
+						link_startup_retries+1);
+
+		/* IF the UIC is busy no point in retrying */
+		if (result =3D=3D -EIO)
+			goto err_dme_link_startup_cmd_sending;
+		if (result =3D=3D 0) {
+			result =3D dwc_ufshcd_get_dme_command_results(hba);
+			if (result =3D=3D 0) {
+
+				dwc_ufs_dme_get(hba, UFS_LINK_STATUS, 0,
+						DWC_UFS_HCD_DME_INTR_DISABLE);
+
+				dwc_ufshcd_get_dme_command_results(hba);
+
+				if (hba->active_dme_cmd.argument3 !=3D 2) {
+					pr_err("Link is not up on %d iteration\n",
+						link_startup_retries + 1);
+					goto err_dme_link_startup;
+				}
+
+				break;
+			} else
+				result =3D 0;
+		}
+	}
+
+	if (link_startup_retries =3D=3D DWC_UFS_RETRY_COUNT_LINKSTARTUP) {
+		pr_info("LinkStartup Failed after %d attempts\n",
+			DWC_UFS_RETRY_COUNT_LINKSTARTUP);
+		goto err_dme_link_startup;
+	}
+
+	/* Update the Link information */
+	pr_debug("Updating the Link information\n");
+	result =3D dwc_ufs_update_link_info(hba, DWC_UFS_HCD_DME_INTR_DISABLE=
);
+
+	/* Do the connection setup on both Host and Device
+	 * This may be redundant operation with any UFS device, but executing
+	 * this is no harm */
+	result =3D dwc_ufs_do_dme_connection_setup(hba,
+						DWC_UFS_HCD_DME_INTR_DISABLE);
+	if (result !=3D 0)
+		goto err_dme_connection_setup;
+
+	pr_info("Connection Setup Successful\n");
+
+	/* Kick start host bus adapter for data transfer operation */
+	if (dwc_ufshcd_kick_start_hba(hba) !=3D 0) {
+		pr_err("Hba is not operational\n");
+		goto err_ufs_kick_start_hba;
+	}
+
+	/* Initialize the device */
+	result =3D dwc_ufs_initialize_ufs_device(hba);
+	if (result !=3D 0)
+		goto err_ufs_initialize_device;
+
+	/* Kick start host bus adapter for data transfer operation */
+	if (dwc_ufshcd_kick_start_stack(hba) !=3D 0) {
+		pr_err("Stack is not operational\n");
+		goto err_ufs_kick_start_stack;
+	}
+
+	goto successful_return;
+
+#ifdef CONFIG_SCSI_DWC_UFS_MPHY_TC
+err_dme_setup_snps_mphy:
+#endif
+err_dme_link_startup:
+err_dme_link_startup_cmd_sending:
+err_ufs_kick_start_stack:
+err_ufs_kick_start_hba:
+err_ufs_initialize_device:
+err_dme_connection_setup:
+	/* Failing due to above reasons is not fatal; Lets continue
+	 * as if everyting is fine */
+	goto unsuccessful_but_not_fatal_return;
+err_hcd_init:
+	dwc_ufshcd_drv_exit(hba);
+
+unsuccessful_but_not_fatal_return:
+successful_return:
+	return result;
+}
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-core.h b/drivers/scsi/uf=
s/dwufs/dwc_ufshcd-core.h
new file mode 100644
index 0000000..a85ab88
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-core.h
@@ -0,0 +1,61 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __DWC_UFSHCD_CORE_H__
+#define __DWC_UFSHCD_CORE_H__
+
+struct dwc_ufs_hba *dwc_ufshcd_get_hba_handle(void);
+void dwc_ufshcd_read_caps(struct dwc_ufs_hba *);
+int dwc_ufshcd_drv_init(struct dwc_ufs_hba **, struct device *,
+							 int, void __iomem *);
+void dwc_ufshcd_drv_exit(struct dwc_ufs_hba *);
+int dwc_ufshcd_host_enable(struct dwc_ufs_hba *);
+void dwc_ufshcd_program_clk_div(struct dwc_ufs_hba *, u32);
+int dwc_ufshcd_initialize_hba_desc_pointers(struct dwc_ufs_hba *);
+void dwc_ufshcd_start_init(struct dwc_ufs_hba *);
+bool dwc_ufshcd_is_hba_active(struct dwc_ufs_hba *);
+void dwc_ufshcd_reset_host(struct dwc_ufs_hba *);
+void dwc_ufshcd_stop_host(struct dwc_ufs_hba *);
+void dwc_ufshcd_host_start_init(struct dwc_ufs_hba *);
+int dwc_ufshcd_enable_host(struct dwc_ufs_hba *);
+int dwc_ufshcd_kick_start_hba(struct dwc_ufs_hba *);
+int dwc_ufshcd_kick_start_stack(struct dwc_ufs_hba *);
+void dwc_ufshcd_set_hcd_state(struct dwc_ufs_hba *, u32);
+bool dwc_ufshcd_is_dme_sap_ready(u32);
+bool dwc_ufshcd_is_utrl_ready(u32);
+bool dwc_ufshcd_is_utmrl_ready(u32);
+bool dwc_ufshcd_is_device_present(u32);
+void dwc_ufshcd_configure_interrupt(struct dwc_ufs_hba *, u32);
+void dwc_ufshcd_configure_intr_aggregation(struct dwc_ufs_hba *, u32);
+
+/* DME Access Functions */
+int dwc_ufs_dme_get(struct dwc_ufs_hba *, u32, u32, u32);
+int dwc_ufs_dme_set(struct dwc_ufs_hba *, u32, u32, u32, u32, u32);
+int dwc_ufs_update_link_info(struct dwc_ufs_hba *, u32);
+int dwc_ufs_switch_speed_gear(struct dwc_ufs_hba *);
+
+u8 dwc_ufshcd_get_dme_command_results(struct dwc_ufs_hba *);
+int dwc_ufs_dme_linkstartup(struct dwc_ufs_hba *, u32);
+int dwc_ufs_dme_setup_snps_mphy(struct dwc_ufs_hba *, u32);
+int dwc_ufs_do_dme_connection_setup(struct dwc_ufs_hba *, u32);
+int dwc_ufs_initialize_ufs_device(struct dwc_ufs_hba *);
+
+/* Power Management Functions */
+int dwc_ufshcd_suspend(struct dwc_ufs_hba *);
+int dwc_ufshcd_resume(struct dwc_ufs_hba *);
+void dwc_ufshcd_prepare_xfer_cmd_upiu(struct dwc_ufs_hcd_lrb *);
+void dwc_ufshcd_send_xfer_req_command(struct dwc_ufs_hba *,
+					 unsigned int);
+int dwc_ufshcd_issue_tm_cmd(struct dwc_ufs_hba *,
+						struct dwc_ufs_hcd_lrb *, u8);
+void dwc_ufshcd_clear_xfre_req(struct dwc_ufs_hba *, u32);
+int dwc_ufshcd_reset_hba(struct dwc_ufs_hba *);
+int dwc_ufshcd_connect(struct dwc_ufs_hba *);
+#endif
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-hci.h b/drivers/scsi/ufs=
/dwufs/dwc_ufshcd-hci.h
new file mode 100644
index 0000000..ce6f251
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-hci.h
@@ -0,0 +1,958 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __DWC_UFSHCD_HCI_H__
+#define __DWC_UFSHCD_HCI_H__
+
+/* Different retry Counts */
+#define DWC_UFS_RETRY_COUNT_GENERIC		100
+#define DWC_UFS_RETRY_COUNT_NOPOUT		5
+#define DWC_UFS_RETRY_COUNT_FLAGS		5
+#define DWC_UFS_RETRY_COUNT_LINKSTARTUP		3
+
+#define DWC_UFS_READ_ONLY_LUN			0x00
+#define DWC_UFS_WRITE_ONLY_LUN			0x06
+#define DWC_UFS_LOOPBACK_LUN			0x07
+
+/* Host Controller Versions */
+#define DWC_UFS_HC_VERSION_1_1			0x00010100
+#define DWC_UFS_HC_VERSION_2_0			0x00000200
+
+/* Different Timeouts in Seconds */
+#define DWC_UFS_TM_TIMEOUT	(1 * HZ)
+#define DWC_UFS_DM_TIMEOUT	(1 * HZ)
+#define DWC_UFS_DME_TIMEOUT	(1 * HZ)
+
+enum {
+	DWC_UFS_HANDLER_WAIT_QUEUE_TYPE     =3D 0,
+	DWC_UFS_HANDLER_WORK_QUEUE_TYPE     =3D 1,
+};
+
+/* DME Command Specific enums */
+enum {
+	DWC_UFS_HCD_DME_INTR_ENABLE         =3D 1,
+	DWC_UFS_HCD_DME_INTR_DISABLE        =3D 0,
+};
+
+/* Interrupt aggregation options */
+enum {
+	INTR_AGGR_RESET,
+	INTR_AGGR_CONFIG,
+};
+
+/* Interrupt configuration options */
+enum {
+	DWC_UFS_HCD_INTR_DISABLE	=3D 0,
+	DWC_UFS_HCD_INTR_ENABLE		=3D 1,
+};
+
+/* UFSHCD states */
+enum {
+	DWC_UFSHCD_STATE_ERROR		=3D -1,
+	DWC_UFSHCD_STATE_RESET		=3D 0,
+	DWC_UFSHCD_STATE_OPERATIONAL	=3D 1,
+};
+
+enum {
+	DWC_UFSHCD_MAX_CHANNEL		=3D 0,
+	DWC_UFSHCD_MAX_ID		=3D 1,
+	DWC_UFSHCD_MAX_LUNS		=3D 8,
+	DWC_UFSHCD_CMDS_PER_LUN		=3D 32,
+	DWC_UFSHCD_CAN_QUEUE		=3D 32,
+};
+
+/* Data structure sizes in bytes */
+enum {
+	DWC_UFS_BASIC_UPIU_SIZE		=3D 32,
+	DWC_UFS_UTRD_SIZE		=3D 32,
+	DWC_UFS_TSF_SIZE		=3D 16,
+	DWC_UFS_PRD_SIZE		=3D 16,
+	DWC_UFSHCD_MAX_PRD_SIZE		=3D 128,  /* 128 (Linux) */
+	DWC_MAX_QUERY_DATA		=3D 256,
+	DWC_UFS_CDB_SIZE		=3D 16,
+	DWC_UFS_SENSE_DATA_SIZE		=3D 18,
+	DWC_UFS_UTMRD_HDR_SIZE		=3D 16,
+};
+
+#define DWC_INTR_AGGR_COUNTER_THRESHOLD_VALUE	(0x1F)
+#define DWC_INTR_AGGR_TIMEOUT_VALUE		(0x02)
+/* HCE register bit 0 value to reset/stop the core */
+#define DWC_UFS_ENABLE 1
+/* HCE register bit 0 value to initiate the core reset */
+#define DWC_UFS_DISABLE 0
+
+/**
+ * struct uic_command - UIC command structure
+ * @command: UIC command
+ * @argument1: UIC command argument 1
+ * @argument2: UIC command argument 2
+ * @argument3: UIC command argument 3
+ * @cmd_active: Indicate if UIC command is outstanding. the same varia=
ble
+ * as condition variable to wake up dme wait queue
+ */
+struct dwc_ufs_dme_sap_cmd {
+	u32 command;
+	u32 argument1;
+	u32 argument2;
+	u32 argument3;
+	int cmd_active;
+};
+
+/**
+ * struct dwc_ufshcd_link_info
+ * @pa_con_tx_data_lanes_local: Physically connected lanes at host
+ * @pa_con_tx_data_lanes_peer: Physically connected lanes at device
+ *
+ */
+struct dwc_ufshcd_link_info {
+	u8 pa_ava_tx_data_lanes_local;	/* Attr: 1540 */
+	u8 pa_ava_tx_data_lanes_peer;	/* Attr: 1540 */
+	u8 pa_ava_rx_data_lanes_local;	/* Attr: 1520 */
+	u8 pa_ava_rx_data_lanes_peer;	/* Attr: 1520 */
+	u8 pa_con_tx_data_lanes_local;	/* Attr: 1561 */
+	u8 pa_con_tx_data_lanes_peer;	/* Attr: 1561 */
+	u8 pa_con_rx_data_lanes_local;	/* Attr: 1581 */
+	u8 pa_con_rx_data_lanes_peer;	/* Attr: 1581 */
+	u8 pa_act_tx_data_lanes_local;	/* Attr: 1560 */
+	u8 pa_act_tx_data_lanes_peer;	/* Attr: 1560 */
+	u8 pa_act_rx_data_lanes_local;	/* Attr: 1580 */
+	u8 pa_act_rx_data_lanes_peer;	/* Attr: 1580 */
+	u8 pa_max_rx_pwm_gear_local;	/* Attr: 1586 */
+	u8 pa_max_rx_pwm_gear_peer;	/* Attr: 1586 */
+	u8 pa_max_rx_hs_gear_local;	/* Attr: 1587 */
+	u8 pa_max_rx_hs_gear_peer;	/* Attr: 1587 */
+	u8 pa_hs_series_local;		/* Attr: 156a */
+	u8 pa_hs_series_peer;		/* Attr: 156a */
+	u8 pa_pwr_mode_local;		/* Attr: 1571 */
+	u8 pa_pwr_mode_peer;		/* Attr: 1571 */
+	u8 pa_tx_pwr_status_local;	/* Attr: 1567 */
+	u8 pa_tx_pwr_status_peer;	/* Attr: 1567 */
+	u8 pa_rx_pwr_status_local;	/* Attr: 1582 */
+	u8 pa_rx_pwr_status_peer;	/* Attr: 1582 */
+};
+
+/**
+ * struct dwc_ufsufs_hba
+ * @1total_read_bytes: Total number bytes read during testing
+ * @1total_write_bytes: Total number bytes written during testing
+ * Structure to time and event and calculate performance numbers
+ * @total_no_of_prds: Total number of PRDs used for testing
+ * @total_cmd_read16: Total number of read16 commnads used during test=
ing
+ * @total_cmd_read10: Total number of read10 commnads used during test=
ing
+ * @1total_cmd_write16: Total number of write16 commnads used during t=
esting
+ * @1total_cmd_write10: Total number of write10 commnads used during t=
esting
+ * @1total_cmd_write6: Total number of write6 commnads used during tes=
ting
+ * @1total_cmd_others: Total number of any other commnads used during =
testing
+ * @start_time: Start time of any event (read/write)
+ * @enc_time: End time of started event (read/write)
+ * @state: state of the statistic counters
+ *
+ */
+struct dwc_ufshcd_pstats {
+
+	u64 total_read_bytes;
+	u64 total_write_bytes;
+	u32 total_no_of_prds;
+	u32 total_cmd_read16;
+	u32 total_cmd_read10;
+	u32 total_cmd_read6;
+	u32 total_cmd_write16;
+	u32 total_cmd_write10;
+	u32 total_cmd_write6;
+	u32 total_cmd_others;
+
+	struct timespec start_time;
+	struct timespec end_time;
+
+	s32 state;
+#define DWC_UFS_STATS_DISABLED	-1 /* should be -1 for debug access */
+#define DWC_UFS_STATS_STOP	-1
+#define DWC_UFS_STATS_START	0
+#define DWC_UFS_STATS_RUNNING	1
+};
+
+/**
+ * struct dwc_ufs_hcd_lrb
+ * Local Reference Block for application commands (eg:scsi)
+ * Maintained for every utrd slot
+ * @command_type: Maintained to abstract the application layer out of =
core
+ * @data_direction: whether command is a read/write or no-data command
+ * @ocs: ocs from utrd is read and kept here for future analysis
+ * @xfer_command_status: holds the response from response-upiu(eg: Scs=
i status)
+ * @transfer_size: total size of transfer in bytes
+ * @task_tag: task_tag
+ * @lun: lun
+ * @scmd: scsi command; should be null if its not a scsi command
+ * @utrd: transfer descriptor address pointer
+ * @cmd_upiu: address of command upiu
+ * @resp_upiu: address of response upiu
+ * @prdt: base address of prd table
+ * @sense_buffer_len: sense buffer length in bytes
+ * @snese_buffer: pointer to sense buffer for the command
+ */
+struct dwc_ufs_hcd_lrb {
+	/* Understood */
+	u8 command_type;	/* UFS, SCSI or Device Management */
+	u8 data_direction;
+	u8 read_write_flags;
+	u8 ocs;
+	u8 xfer_command_status;
+
+	u32 transfer_size;
+	u32 task_tag;
+	u32 lun;
+
+	struct scsi_cmnd *scmd;
+	struct dwc_ufs_utrd *utrd;
+	struct dwc_ufs_cmd_upiu	*cmd_upiu;
+	struct dwc_ufs_resp_upiu *resp_upiu;
+	struct dwc_ufs_prd *prdt;
+
+	u16 sense_buffer_len;
+	u8 *sense_buffer;
+};
+
+/**
+ * struct dwc_ufshcd_dm_lrb
+ * Local Reference Block for Device management commands (eg: nopout, q=
uery ..)
+ * Maintained one per driver instance
+ * @trans_type: Transaction Type (query/nopout ..)
+ * @flags:flags indicating Read/Write
+ * @lun: lun to be addressed through this command
+ * @query_fn: query_function
+ * @tot_ehs_len: total ehs length
+ * @data_seg_len: data segment length for this command
+ * @tsf: transaction specific field for this command
+ * @dm_cmd_results: Device management function result updated after
+ * post processing
+ */
+struct dwc_ufshcd_dm_lrb {
+	u8 trans_type;
+	u8 flags;
+	u8 lun;
+	u8 query_fn;
+	u8 tot_ehs_len;
+	u16 data_seg_len;
+	u8 tsf[DWC_UFS_TSF_SIZE];
+	s32 dm_cmd_results;
+};
+
+/**
+ * struct dwc_ufs_hba
+ * Private structure of the host bus adapter
+ * @mmio_base: DWC UFS HCI base register address
+ * @irq: Irq no to be used for ISR registration
+ * @gdev: Generic device structure for pci/platform device abstraction
+ * @shost: scsi host structure for scsi mid layer
+ * @caps: DWC UFS HC capabilities stored here for reference
+ * @ufs_version: UFS version read adn kept here
+ * @nutrs: Transfer Request Queue depth supported by DWC UFS HC
+ * @nutmrs: Task Management Queue depth supported by DWC UFS HC
+ * @utrl_base_addr: UTP Transfer Request Descriptor List base address =
(virtual)
+ * @utmrl_base_addr: UTP Task Management Descriptor List base address =
(virtual)
+ * @ucdl_base_addr: UFS Command Descriptor List Base Address (virtual)
+ * @utrl_dma_addr: UTRDL DMA address List Base Address (DMA/Physical)
+ * @utmrl_dma_addr: UTMRDL DMA address List Base Address (DMA/Physical=
)
+ * @ucdl_dma_addr: UFS Command Descriptor List Base Address (DMA/Physi=
cal)
+ * @lrb: pointer to local reference block list
+ * @dm_lrb: local reference block device management commands
+ * @dme_completion_handler_type: work queue type or wait queue type
+ * @tm_completion_handler_type: work queue type or wait queue type
+ * @dm_completion_handler_type: work queue type or wait queue type
+ * @fatal_error_handler_type: work queue type or wait queue type
+ * @dme_sap_workq: work quue for DME/UIO commands
+ * @active_dme_cmd: Active dme command is kept in this structure
+ * @intr_enable_mask: Enable mask for the interrupts
+ * @intr_aggr_cntr_thr: Interrupt aggregatin counter threshold
+ * @intr_aggr_timout_val: Interrupt aggregation timeout value
+ * @outstanding_xfer_reqs: outstanding transfer requests to be process=
ed
+ * @outstanding_dm_requests: outstanding DM requests to be processes
+ * (Only One as of now)
+ * @outstanding_tm_tasks: outstanding TM tasks to be processed
+ * @dwc_ufshcd_tm_wait_queue: wait queue head to keep tm task commands
+ * @dwc_ufshcd_dm_wait_queue: wait queue head to keep dm commands
+ * @dwc_ufshcd_dme_wait_queue: wait queue head to keep dme commands
+ * @dwc_ufshcd_tm_condition: condition variable to wake up tm wait que=
ue
+ * @dwc_ufshcd_dm_condition: condition variable to wake up dm wait que=
ue
+ * @fatal_error_handler_workq: work queue for handling Fatal errors
+ * @dwc_ufshcd_state: state of the driver/hardware
+ * @dwc_ufshcd_interrupts: keeps the snapshot of interrupt status regi=
ster
+ */
+struct dwc_ufs_hba {
+
+	void __iomem *mmio_base;
+	int irq;
+
+	struct device *gdev;
+	struct Scsi_Host *shost;
+
+	u32 caps;
+	u32 dwc_ufs_version;
+
+	u8 nutrs;
+	u8 nprtts;
+	u8 nutmrs;
+	u8 autoh8;
+	u8 as64;
+	u8 oodds;
+	u8 uicdmetms;
+
+	/* Virtual memory reference for driver */
+	struct dwc_ufs_utrd *utrl_base_addr;
+	struct dwc_ufs_utmrd *utmrl_base_addr;
+	struct dwc_ufs_ucd  *ucdl_base_addr;
+
+	/* DMA memory reference for above mentioned virtual memory
+	 * for Host Controller reference */
+	dma_addr_t utrl_dma_addr;
+	dma_addr_t utmrl_dma_addr;
+	dma_addr_t ucdl_dma_addr;
+
+	struct dwc_ufs_hcd_lrb *lrb;
+	struct dwc_ufshcd_dm_lrb dm_lrb;
+
+	u32 dme_completion_handler_type;
+	u32 tm_completion_handler_type;
+	u32 dm_completion_handler_type;
+	u32 fatal_error_handler_type;
+
+	/* Work to handle dme operation */
+	struct work_struct dme_sap_workq;
+	struct dwc_ufs_dme_sap_cmd active_dme_cmd;
+
+	/* Interrupt aggregation parameters */
+	u32 intr_enable_mask;
+	u8 intr_aggr_cntr_thr;
+	u8 intr_aggr_timout_val;
+
+	/* Outstanding requests Xfer: 32 Max, dm: 1, tm:8 */
+	unsigned long outstanding_xfer_reqs;
+	unsigned long outstanding_dm_requests;
+	unsigned long outstanding_tm_tasks;
+
+	wait_queue_head_t dwc_ufshcd_tm_wait_queue;
+	wait_queue_head_t dwc_ufshcd_dm_wait_queue;
+	wait_queue_head_t dwc_ufshcd_dme_wait_queue;
+
+	unsigned long dwc_ufshcd_tm_condition;
+	unsigned long dwc_ufshcd_dm_condition;
+
+	struct work_struct fatal_error_handler_workq;
+
+	/* DWC UFS HC state */
+	u32 dwc_ufshcd_state;
+
+	/* HBA interrupts */
+	u32 dwc_ufshcd_interrupts;
+
+	/* Read Write Statistics */
+	u32 debug_mode;
+	struct dwc_ufshcd_pstats pstats;
+	struct dwc_ufshcd_link_info linfo;
+};
+
+/* Clock Divider Values: Hex equivalent of frequency in MHz */
+enum {
+	DWC_UFSHCD_CLK_DIV_62_5	=3D 0x3e,
+	DWC_UFSHCD_CLK_DIV_125	=3D 0x7d,
+	DWC_UFSHCD_CLK_DIV_200	=3D 0xc8,
+};
+
+/* Alignment Requirement in bytes */
+enum {
+	DWC_UTRL_BASE_ALIGN	=3D 1024,
+	DWC_UCD_ALIGN		=3D 512,
+};
+
+/* Command Type : UTRD - 8bits */
+enum {
+	DWC_UTRD_CMD_TYPE_SCSI		=3D 0x00,
+	DWC_UTRD_CMD_TYPE_UFS		=3D 0x10,
+	DWC_UTRD_CMD_TYPE_DEV_MANAGE_FN	=3D 0x20,
+};
+
+/*  To accommodate UFS2.0 required Command type */
+enum {
+	DWC_UTRD_CMD_TYPE_UFS_STORAGE	=3D 0x10,
+};
+
+/* Interrupt or Regula Command : UTRD (DD)-8bits */
+enum {
+	DWC_UTRD_REG_CMD		=3D 0x00,
+	DWC_UTRD_INTR_CMD		=3D 0x01,
+};
+
+/* Data Direction : UTRD (DD)-8bits */
+enum {
+	DWC_UTRD_NO_DATA_TRANSFER	=3D 0x00,
+	DWC_UTRD_HOST_TO_DEVICE		=3D 0x02,
+	DWC_UTRD_DEVICE_TO_HOST		=3D 0x04,
+};
+
+/* Interrupt or no Interrupt for TM func: UTMRD (I)-8bits */
+enum {
+	DWC_UTMRD_INTR			=3D 0x01,
+};
+
+/* Overall command status values */
+enum {
+	OCS_SUCCESS			=3D 0x00,
+	OCS_INVALID_CMD_TABLE_ATTR	=3D 0x01,
+	OCS_INVALID_PRDT_ATTR		=3D 0x02,
+	OCS_MISMATCH_DATA_BUF_SIZE	=3D 0x03,
+	OCS_MISMATCH_RESP_UPIU_SIZE	=3D 0x04,
+	OCS_PEER_COMM_FAILURE		=3D 0x05,
+	OCS_ABORTED			=3D 0x06,
+	OCS_FATAL_ERROR			=3D 0x07,
+	OCS_INVALID_COMMAND_STATUS	=3D 0x0F,
+	OCS_MASK			=3D 0x0F,
+};
+
+/**
+ * UFS Host controller Registers
+ * All the registers are laid out on a 32bit wide memory space
+ */
+enum {
+	DWC_UFS_REG_CAP			=3D 0x00,
+	DWC_UFS_REG_VER			=3D 0x08,
+	DWC_UFS_REG_HCDDID		=3D 0x10,
+	DWC_UFS_REG_HCPMID		=3D 0x14,
+	DWC_UFS_REG_AHIT		=3D 0x18, /* UFS2.0 Specific*/
+	DWC_UFS_REG_IS			=3D 0x20,
+	DWC_UFS_REG_IE			=3D 0x24,
+	DWC_UFS_REG_HCS			=3D 0x30,
+	DWC_UFS_REG_HCE			=3D 0x34,
+	DWC_UFS_REG_UECPA		=3D 0x38,
+	DWC_UFS_REG_UECDL		=3D 0x3c,
+	DWC_UFS_REG_UECN		=3D 0x40,
+	DWC_UFS_REG_UECT		=3D 0x44,
+	DWC_UFS_REG_UECDME		=3D 0x48,
+	DWC_UFS_REG_UTRIACR		=3D 0x4c,
+	DWC_UFS_REG_UTRLBA		=3D 0x50,
+	DWC_UFS_REG_UTRLBAU		=3D 0x54,
+	DWC_UFS_REG_UTRLDBR		=3D 0x58,
+	DWC_UFS_REG_UTRLCLR		=3D 0x5c,
+	DWC_UFS_REG_UTRLRSR		=3D 0x60,
+	DWC_UFS_REG_UTMRLBA		=3D 0x70,
+	DWC_UFS_REG_UTMRLBAU		=3D 0x74,
+	DWC_UFS_REG_UTMRLDBR		=3D 0x78,
+	DWC_UFS_REG_UTMRLCLR		=3D 0x7c,
+	DWC_UFS_REG_UTMRLRSR		=3D 0x80,
+	DWC_UFS_REG_UICCMDR		=3D 0x90,
+	DWC_UFS_REG_UCMDARG1		=3D 0x94,
+	DWC_UFS_REG_UCMDARG2		=3D 0x98,
+	DWC_UFS_REG_UCMDARG3		=3D 0x9c,
+
+	/* DWC UFS HC specific Registers */
+	DWC_UFS_REG_OCPTHRTL		=3D 0xc0,
+	DWC_UFS_REG_OOCPR		=3D 0xc4,
+	DWC_UFS_REG_CDACFG		=3D 0xd0,
+	DWC_UFS_REG_CDATX1		=3D 0xd4,
+	DWC_UFS_REG_CDATX2		=3D 0xd8,
+	DWC_UFS_REG_CDARX1		=3D 0xdc,
+	DWC_UFS_REG_CDARX2		=3D 0xe0,
+	DWC_UFS_REG_CDASTA		=3D 0xe4,
+	DWC_UFS_REG_LBMCFG		=3D 0xf0,
+	DWC_UFS_REG_LBMSTA		=3D 0xf4,
+	DWC_UFS_REG_UFSMODE		=3D 0xf8,
+	DWC_UFS_REG_HCLKDIV		=3D 0xfc,
+};
+
+/* Host Controller CPORT Direct Access Flags */
+#define DWC_UFS_C_PORT_DIRECT_ACCESS_EN		0x10000000
+#define DWC_UFS_C_PORT_TX_BUSY			0x00080000
+#define DWC_UFS_C_PORT_TX_EOM			0x00010000
+#define DWC_UFS_C_PORT_RX_DATA_VALID		0x00040000
+#define DWC_UFS_C_PORT_RX_EOM			0x00020000
+#define DWC_UFS_C_PORT_RX_SOM			0x00010000
+#define DWC_UFS_C_PORT_BYTE_EN			0x0000ff00
+#define DWC_UFS_C_PORT_BYTE0_EN			0x00008000
+
+/* Host Controller Status DWC_UFS_REG_HCS */
+#define DWC_UFS_DP				0x00000001
+#define DWC_UFS_UTRL_READY			0x00000002
+#define DWC_UFS_UTMRL_READY			0x00000004
+#define DWC_UFS_UIC_CMD_READY			0x00000008
+#define DWC_UFS_UPMCRS_MASK			0x00000700
+
+#define DWC_UFS_UPMCRS_PWR_OK			0x00000000
+#define DWC_UFS_UPMCRS_PWR_LOCAL		0x00000100
+#define DWC_UFS_UPMCRS_PWR_REMOTE		0x00000200
+#define DWC_UFS_UPMCRS_PWR_BUSY			0x00000300
+#define DWC_UFS_UPMCRS_PWR_ERROR_CAP		0x00000400
+#define DWC_UFS_UPMCRS_PWR_FATAL_ERROR		0x00000500
+
+/* DWC_UFS_REG_IS Bitfields */
+#define DWC_UFS_UTRCS				0x00000001
+#define DWC_UFS_UDEPRI				0x00000002
+#define DWC_UFS_UES				0x00000004
+#define DWC_UFS_UTMS				0x00000008
+#define DWC_UFS_UPMS				0x00000010
+#define DWC_UFS_UHXS				0x00000020
+#define DWC_UFS_UHES				0x00000040
+#define DWC_UFS_ULLS				0x00000080
+#define DWC_UFS_ULSS				0x00000100
+#define DWC_UFS_UTMRCS				0x00000200
+#define DWC_UFS_UCCS				0x00000400
+#define DWC_UFS_DFES				0x00000800
+#define DWC_UFS_UTPES				0x00001000
+#define DWC_UFS_HCFES				0x00010000
+#define DWC_UFS_SBFES				0x00020000
+
+/* DWC_UFS_REG_IE Bitfields */
+#define DWC_UFS_UTRCE			0x00000001
+#define DWC_UFS_UDEPRIE			0x00000002
+#define DWC_UFS_UEE			0x00000004
+#define DWC_UFS_UTMSE			0x00000008
+#define DWC_UFS_UPMSE			0x00000010
+#define DWC_UFS_UHXSE			0x00000020
+#define DWC_UFS_UHESE			0x00000040
+#define DWC_UFS_ULLSE			0x00000080
+#define DWC_UFS_ULSSE			0x00000100
+#define DWC_UFS_UTMRCE			0x00000200
+#define DWC_UFS_UCCE			0x00000400
+#define DWC_UFS_DFEE			0x00000800
+#define DWC_UFS_UTPEE			0x00001000
+#define DWC_UFS_HCFEE			0x00010000
+#define DWC_UFS_SBFEE			0x00020000
+
+#define DWC_UFS_ENABLED_ERROR_MASK	(DWC_UFS_UEE |\
+					DWC_UFS_DFEE |\
+					DWC_UFS_HCFEE |\
+					DWC_UFS_SBFEE)
+
+#define DWC_UFS_ENABLED_FE_ERROR_MASK	(DWC_UFS_DFEE |\
+					DWC_UFS_HCFEE |\
+					DWC_UFS_SBFEE)
+
+/* DWC_UFS_REG_UTRIACR Bitfields and masks and shift value */
+#define DWC_UFS_IAEN			0x80000000
+#define DWC_UFS_IAPWEN			0x01000000
+#define DWC_UFS_IASB			0x00100000
+#define DWC_UFS_CTR			0x00010000
+#define DWC_UFS_IACTH_MASK		0x00001f00
+#define DWC_UFS_IACTH_SH		8
+#define DWC_UFS_IATOVAL_MASK		0x000000ff
+
+/* Controller capability masks and shift value */
+#define DWC_UFS_NUTRS_MASK		0x0000001f
+#define DWC_UFS_NPRTTS_MASK		0x0000ff00
+#define DWC_UFS_NPRTTS_SHIFT		8
+#define DWC_UFS_NUTMRS_MASK		0x00070000
+#define DWC_UFS_NUTMRS_SHIFT		16
+#define DWC_UFS_AUTOH8			0x00800000
+#define DWC_UFS_AUTOH8_SHIFT		23
+#define DWC_UFS_64AS			0x01000000
+#define DWC_UFS_64AS_SHIFT		24
+#define DWC_UFS_OODDS			0x02000000
+#define DWC_UFS_OODDS_SHIFT		25
+#define DWC_UFS_UICDMETMS		0x04000000
+#define DWC_UFS_UICDMETMS_SHIFT		26
+
+/* Auto Hibernate Feature */
+/* Auto Hibernate IDLE Timer Scale Value */
+#define DWC_UFS_AHIT_1US		0x00000000
+#define DWC_UFS_AHIT_10US		0x00000400
+#define DWC_UFS_AHIT_100US		0x00000800
+#define DWC_UFS_AHIT_1MS		0x00000c00
+#define DWC_UFS_AHIT_10MS		0x00001000
+#define DWC_UFS_AHIT_100MS		0x00001400
+
+/* Auto Hibernate IDLE Timer Value */
+#define DWC_UFS_AHIT_IDLE_TIME_MASK	0x000003ff
+
+/**
+ * struct dwc_ufs_utrd
+ * UTP Transfer request descriptor structure
+ * Size of this descriptor is 32 bytes.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in LITTLE ENDIAN Format.
+ */
+struct dwc_ufs_utrd {
+	u8 reserved_1[3];
+	u8 ct_and_flags;
+	u8 reserved_2[4];
+	u8 ocs;
+	u8 reserved_3[3];
+	u8 reserved_4[4];
+	u32 ucdba;
+	u32 ucdbau;
+	u16 resp_upiu_length;
+	u16 resp_upiu_offset;
+	u16 prdt_length;
+	u16 prdt_offset;
+};
+
+/**
+ * dwc_ufs_prd
+ * This is Physical Region Description for data Scatter Gather buffers
+ * The structure is of 32 bytes.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in LITTLE ENDIAN Format.
+ */
+struct dwc_ufs_prd {
+	u32 base_addr_lo;
+	u32 base_addr_hi;
+	u8 reserved_1[4];
+	u32 byte_count;
+};
+
+/**
+ * dwc_ufs_ucd
+ * UTP Command Descriptor (UCD) structure.
+ * Every UTRD contains a pointer for this data structure
+ * This structure logically consists of 3 parts
+ *	1. "Transfer Request" or "Command UPIU" (SCSI, Native UFS & DM)
+ *	2. "Transfer Response" or "Response UPIU"
+ *	3. "Physical Region Description Table"(PRDT).
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * "Transfer Request" and "Transfer Response" are in BIG ENDIAN Format
+ * "PRDT" is in LITTLE ENDIAN Format
+ */
+struct dwc_ufs_ucd {
+	u8 cmd_upiu[DWC_UCD_ALIGN];
+	u8 resp_upiu[DWC_UCD_ALIGN];
+	struct dwc_ufs_prd prdt[DWC_UFSHCD_MAX_PRD_SIZE];
+};
+
+/**
+ * dwc_ufs_upiu
+ * structure conaining the UFS Basic Upiu. This structure is defined s=
uch that
+ * it can accommodate any type of upiu defined in UFS specifications
+ * The allocation is DWC_UCD_ALIGN bytes
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * The Structure is in BIG ENDIAN FORMAT
+ */
+struct dwc_ufs_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 lun;
+	u8 task_tag;
+	u8 cmd_set_type;
+	u8 reserved_1[3];
+	u8 tot_ehs_len;
+	u8 reserved_2;
+	u16 data_seg_len;
+	u32 exp_data_xfer_len;
+	u8 data[DWC_UCD_ALIGN -	DWC_UFS_BASIC_UPIU_SIZE];
+};
+
+/**
+ * dwc_ufs_cmd_upiu
+ * structure for UFS transfer request command upiu.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN FORMAT
+ */
+struct dwc_ufs_cmd_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 lun;
+	u8 task_tag;
+	u8 cmd_set_type;
+	u8 reserved_1[3];
+	u8 tot_ehs_len;
+	u8 reserved_2;
+	u16 data_seg_len;
+	u32 exp_data_xfer_len;
+	u8 cdb[DWC_UFS_CDB_SIZE];
+};
+
+/**
+ * dwc_ufs_resp_upiu
+ * This structure is to hold the Response UPIU from device. Host contr=
oller
+ * stores all the relevant response information that has been sent by =
device.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_resp_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 lun;
+	u8 task_tag;
+	u8 cmd_set_type;
+	u8 reserved_1;
+	u8 response;
+	u8 status;
+	u8 tot_ehs_len;
+	u8 device_info;
+	u16 data_seg_len;
+	u32 residual_xfer_count;
+	u8 reserved_2[4];
+	u8 reserved_3[4];
+	u8 reserved_4[4];
+	u8 reserved_5[4];
+	u16 sense_data_len;
+	u8 sense_data[DWC_UFS_SENSE_DATA_SIZE];
+};
+
+/**
+ * dwc_ufs_nopout_upiu
+ * This structure is for nopout upiu from host.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_nopout_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 reserved_1;
+	u8 task_tag;
+	u8 reserved_2[4];
+	u8 tot_ehs_len;
+	u8 reserved_3;
+	u16 data_seg_len;
+	u8 reserved_4[4];
+	u8 reserved_5[4];
+	u8 reserved_6[4];
+	u8 reserved_7[4];
+	u8 reserved_8[4];
+};
+
+/**
+ * dwc_ufs_nopin_upiu
+ * This structure is for nopin upiu (response to nopout) from device.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_nopin_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 reserved_1;
+	u8 task_tag;
+	u8 reserved_2[4];
+	u8 tot_ehs_len;
+	u8 reserved_3;
+	u16 data_seg_len;
+	u8 reserved_4[4];
+	u8 reserved_5[4];
+	u8 reserved_6[4];
+	u8 reserved_7[4];
+	u8 reserved_8[4];
+};
+
+/**
+ * dwc_ufs_query_req_upiu
+ * This structure is for query_request_upiu (DM) from host.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_query_req_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 reserved_1;
+	u8 task_tag;
+	u8 reserved_2;
+	u8 query_fn;
+	u8 reserved_3[2];
+	u8 tot_ehs_len;
+	u8 reserved_4;
+	u16 data_seg_len;
+	u8 txn_specific_flds_1[4];
+	u8 txn_specific_flds_2[4];
+	u8 txn_specific_flds_3[4];
+	u8 txn_specific_flds_4[4];
+	u8 reserved_5[4];
+	u8 data[DWC_MAX_QUERY_DATA];
+};
+
+/**
+ * dwc_ufs_query_resp_upiu
+ * This structure is for query_response_upiu (DM) from device.
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_query_resp_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 reserved_1;
+	u8 task_tag;
+	u8 reserved_2;
+	u8 query_fn;
+	u8 query_resp;
+	u8 reserved_3;
+	u8 tot_ehs_len;
+	u8 reserved_4;
+	u16 data_seg_len;
+	u8 txn_specific_flds_1[4];
+	u8 txn_specific_flds_2[4];
+	u8 txn_specific_flds_3[4];
+	u8 txn_specific_flds_4[4];
+	u8 reserved_5[4];
+	u8 data[DWC_MAX_QUERY_DATA];
+};
+
+/**
+ * dwc_ufs_reject_upiu is sent by the device
+ * The Device shall send this upius if it receives and UPIU with
+ * invalid transaction type
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_reject_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 lun;
+	u8 task_tag;
+	u8 reserved_1[2];
+	u8 resp;
+	u8 reserved_2;
+	u8 tot_ehs_len;
+	u8 device_info;
+	u8 basic_hdr_status;
+	u8 reserved_3;
+	u8 e_to_e_status;
+	u8 reserved;
+	u8 reserved_4[4];
+	u8 reserved_5[4];
+	u8 reserved_6[4];
+	u8 reserved_7[4];
+	u8 reserved_8[4];
+};
+
+/**
+ * struct dwc_ufs_tm_desc_hdr
+ * The HC specification does not clearly differentiate this field.
+ * Every entry in Task management Request List has this structure
+ * (4 dword) preceding the tm_req_upiu.
+ * This Structure is in Little ENDIAN Format
+ */
+struct dwc_ufs_tm_desc_hdr {
+	u8 reserved_1[3];
+	u8 intr_flag;
+	u8 reserved_2[4];
+	u8 ocs;
+	u8 reserved_3[3];
+	u8 reserved_4[4];
+};
+
+/**
+ * dwc_ufs_tm_req_upiu
+ * Task Management Request UPIU structure
+ * Size of this structure is 32 bytes
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_tm_req_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 lun;
+	u8 task_tag;
+	u8 reserved_1;
+	u8 tm_fn;
+	u8 reserved_2[2];
+	u8 tot_ehs_len;
+	u8 reserved_3;
+	u16 data_seg_len;
+	u8 input_param_1[4];
+	u8 input_param_2[4];
+	u8 input_param_3[4];
+	u8 reserved_4[4];
+	u8 reserved_5[4];
+};
+
+/**
+ * dwc_ufs_tm_resp_upiu
+ * Task Management Response UPIU structure
+ * Size of this structure is 32 bytes
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * This structure is in BIG ENDIAN Format
+ */
+struct dwc_ufs_tm_resp_upiu {
+	u8 trans_type;
+	u8 flags;
+	u8 lun;
+	u8 task_tag;
+	u8 reserved_1[2];
+	u8 response;
+	u8 reserved_2;
+	u8 tot_ehs_len;
+	u8 reserved_3;
+	u16 data_seg_len;
+	u32 output_param_1;
+	u32 output_param_2;
+	u8 reserved_4[4];
+	u8 reserved_5[4];
+	u8 reserved_6[4];
+};
+
+/**
+ * struct dwc_ufs_utmrd
+ * UTP Task Management Request Descriptor structure
+ * Size of this descriptor is 80 byte [8 Bytes of Task Managemetn Desc=
riptor
+ * Header + 36 Bytes of Request UPIU + 36 Bytes of Response UPIU]
+ * The data structure should support 32 bit or 64 bit memory buffer ad=
dress
+ * space.
+ * The Task Management Descriptor header portion is in LITTLE ENDIAN F=
ormat
+ * But, task management request upiu and task management response upiu=
 are
+ * in BIG ENDIAN Format
+ */
+struct dwc_ufs_utmrd {
+	struct dwc_ufs_tm_desc_hdr tm_desc_hdr;
+	struct dwc_ufs_tm_req_upiu tm_req_upiu;
+	struct dwc_ufs_tm_resp_upiu tm_resp_upiu;
+};
+
+/* DME Commands */
+enum {
+	DWC_UFS_DME_GET			=3D 0x01,
+	DWC_UFS_DME_SET			=3D 0x02,
+	DWC_UFS_DME_PEER_GET		=3D 0x03,
+	DWC_UFS_DME_PEER_SET		=3D 0x04,
+	DWC_UFS_DME_POWERON		=3D 0x10,
+	DWC_UFS_DME_POWEROFF		=3D 0x11,
+	DWC_UFS_DME_ENABLE		=3D 0x12,
+	DWC_UFS_DME_RESET		=3D 0x14,
+	DWC_UFS_DME_ENDPOINTRESET	=3D 0x15,
+	DWC_UFS_DME_LINKSTARTUP		=3D 0x16,
+	DWC_UFS_DME_HIBERNATE_ENTER	=3D 0x17,
+	DWC_UFS_DME_HIBERNATE_EXIT	=3D 0x18,
+	DWC_UFS_DME_TEST_MODE		=3D 0x1A,
+};
+
+/* DME Result Codes */
+enum {
+	DWC_UFS_DME_SUCCESS		=3D 0x00,
+	DWC_UFS_DME_INV_MIB_ATTR	=3D 0x01,
+	DWC_UFS_DME_INV_MIB_ATTR_VAL	=3D 0x02,
+	DWC_UFS_DME_READ_ONLY_MIB_ATTR	=3D 0x03,
+	DWC_UFS_DME_WRITE_ONLY_MIB_ATTR	=3D 0x04,
+	DWC_UFS_DME_BAD_INDEX		=3D 0x05,
+	DWC_UFS_DME_LOCKED_MIB_ATTR	=3D 0x06,
+	DWC_UFS_DME_BAD_TEST_FEAT_INDEX	=3D 0x07,
+	DWC_UFS_DME_PEER_COMM_FAILURE	=3D 0x08,
+	DWC_UFS_DME_BUSY		=3D 0x09,
+	DWC_UFS_DME_FAILURE		=3D 0x0a,
+	DWC_UFS_DME_RESULT_CODE_MASK	=3D 0xff,
+};
+
+/* DME Reset type */
+enum {
+	DWC_UFS_DME_RESET_LEVEL_COLD	=3D 0,
+	DWC_UFS_DME_RESET_LEVEL_WARM	=3D 1,
+};
+
+/* DME attribute whether normal or static */
+enum {
+	DWC_UFS_DME_ATTR_SET_TYPE_NORMAL =3D 0,
+	DWC_UFS_DME_ATTR_SET_TYPE_STATIC =3D 1,
+};
+#endif
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-mphy.h b/drivers/scsi/uf=
s/dwufs/dwc_ufshcd-mphy.h
new file mode 100644
index 0000000..6519369
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-mphy.h
@@ -0,0 +1,55 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DWC_MPHY_H_
+#define _DWC_MPHY_H_
+
+/* MPHY Selected Index */
+
+#define SEL_INDEX_LANE0_TX 0x00
+#define SEL_INDEX_LANE1_TX 0x01
+#define SEL_INDEX_LANE0_RX 0x04
+#define SEL_INDEX_LANE1_RX 0x05
+
+/* MPHY Attributes */
+
+/* Common Block*/
+#define MPHY_CB_GLOBAL_HIBERNATE	0x002b
+#define MPHY_CB_REF_CLOCK		0x00bf
+#define MPHY_CB_DIRECTCTRL19		0x00cd
+#define MPHY_CB_DIRECTCTRL10		0x00e6
+#define MPHY_CB_TARGET_FREQ		0x00ea
+#define MPHY_CB_REAL_TIME_OBS		0x00f0
+#define MPHY_CB_CLK_DIV_RATIO		0x00f1
+#define MPHY_CB_DCO_CTRL_5		0x00f3
+#define MPHY_CB_CFG_PRG_PLL2		0x00f8
+#define MPHY_CB_PRG_TUNNING		0x00fb
+
+/* RX */
+#define MPHY_RX_CAL_CTRL		0x00b4
+#define MPHY_RX_RXSQCTRL		0x00b5
+#define MPHY_RX_HIBERN8			0x00ba
+#define MPHY_RX_CFG_OVER8		0x00bd
+#define MPHY_RX_CFGRXOVR6		0x00bf
+#define MPHY_RX_DIRECT_CTRL2		0x00c7
+#define MPHY_RX_CFGRXOVR4		0x00e9
+#define MPHY_RX_SEV_CDR_CFG4		0x00f2
+#define MPHY_RX_SEV_CDR_CFG3		0x00f3
+#define MPHY_RX_SEV_CDR_CFG2		0x00f4
+
+/* TX */
+#define MPHY_TX_INT_EXT_DIFF		0x00f1
+
+/* RX/TX*/
+#define MPHY_TARGET_REF_CLK		0x00eb
+#define MPHY_SETS_INTERNAL_DIV		0x00ec
+#define MPHY_SEV_CTRL_PARM		0x00f0
+
+#endif /* _DWC_MPHY_H_ */
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-pci.c b/drivers/scsi/ufs=
/dwufs/dwc_ufshcd-pci.c
new file mode 100644
index 0000000..5ed90fa
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-pci.c
@@ -0,0 +1,280 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Manjunath Bettegowda <manjumb@synopsys.com>,
+ *	    Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/version.h>
+
+#include "dwc_ufshcd-ufs.h"
+#include "dwc_ufshcd-hci.h"
+#include "dwc_ufshcd-core.h"
+
+#define BAR0 0
+#define DWC_UFS_BAR    BAR0
+
+u8 dwc_ufshcd_pci_driver_name[] =3D "dwc_ufshcd_pci";
+
+/**
+ * dwc_ufshcd_pci_set_dma_mask()
+ * Set dma mask based on the controller addressing capability
+ * @pdev: pointer to pci device
+ *
+ * Returns 0 for success, non-zero for failure
+ */
+static int dwc_ufshcd_pci_set_dma_mask(struct pci_dev *pdev)
+{
+	int result =3D 0;
+	u64 dma_mask;
+
+#ifdef CONFIG_SCSI_DWC_UFS_64BIT
+	/*
+	 * If controller supports 64 bit addressing mode, then set the DMA
+	 * mask to 64-bit, else set the DMA mask to 32-bit
+	 */
+	dma_mask =3D DMA_BIT_MASK(64);
+	result =3D pci_set_dma_mask(pdev, dma_mask);
+	if (result !=3D 0) {
+		pr_info("The device %s doesnot support DAC", pci_name(pdev));
+		dma_mask =3D DMA_BIT_MASK(32);
+		result =3D pci_set_dma_mask(pdev, dma_mask);
+	}
+#else
+	/* DWC UFS HC Cannot do 64 bit addressing */
+	dma_mask =3D DMA_BIT_MASK(32);
+	result =3D pci_set_dma_mask(pdev, dma_mask);
+
+	if (result !=3D 0) {
+		pr_err("The device %s doesnt have DMA Capability",
+								pci_name(pdev));
+		return result;
+	}
+#endif
+	pr_info("DMA MASK is set to %llx\n", dma_mask);
+	result =3D pci_set_consistent_dma_mask(pdev, dma_mask);
+	return result;
+}
+
+/**
+ * dwc_ufshcd_pci_probe()
+ * Probe routine of the pci driver
+ * In Linux, probing function gets called for all PCI devices (during
+ * execution of pci_register_driver()), which match the dwc_ufshcd_pci=
_id
+ * entries and are not owned by other driver yet. The function passed =
a
+ * "struct pci_dev *" for each device whose entry in the ID table matc=
hes
+ * the device's ID.
+ * @pdev: pointer to PCI device handle
+ * @entries: PCI device id table
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int dwc_ufshcd_pci_probe(struct pci_dev *pdev,
+				  const struct pci_device_id *entries) {
+
+	int result =3D 0;
+	struct dwc_ufs_hba *uninitialized_var(hba);
+	void __iomem *mmio_base =3D NULL;
+
+	/* Enable the device for both IO and MEMORY */
+	result =3D pci_enable_device(pdev);
+	if (result !=3D 0) {
+		pr_err("Failed to Enable %s device\n", pci_name(pdev));
+		goto err_pci_enable;
+	}
+
+	/* Enable Bus mastering for the Pci Device */
+	pci_set_master(pdev);
+
+	/*
+	 * Request MMIO/IO resources. This reserves all the IO and
+	 * Memory resources of our pci device
+	 **/
+	result =3D pci_request_regions(pdev, dwc_ufshcd_pci_driver_name);
+	if (result !=3D 0) {
+		pr_err("Failed to get PCI Regions for %s device\n",
+								pci_name(pdev));
+		result =3D -ENODEV;
+		goto err_request_regions_failed;
+	}
+
+	/* Obtain the Virtual Address mapping for required BAR's
+	 * Physical Address
+	 */
+	mmio_base =3D pci_ioremap_bar(pdev, DWC_UFS_BAR);
+	if (mmio_base =3D=3D NULL) {
+		pr_err("Memory/IO map failed for %s device\n", pci_name(pdev));
+		result =3D -ENOMEM;
+		goto err_ioremap;
+	}
+
+	result =3D dwc_ufshcd_pci_set_dma_mask(pdev);
+	if (result !=3D 0) {
+		pr_err("Setting Dma Mask failed for %s device", pci_name(pdev));
+		goto err_pci_set_dma_mask;
+	}
+
+	result =3D dwc_ufshcd_drv_init(&hba, &pdev->dev, pdev->irq, mmio_base=
);
+	if (result !=3D 0) {
+		pr_err("Driver Initialization Failed\n");
+		goto err_drv_init;
+	}
+
+	/* The hba structure is the private data for pci device */
+	pci_set_drvdata(pdev, hba);
+
+	/* do the link startup, phy setup and connection establishment */
+	result =3D dwc_ufshcd_connect(hba);
+
+	goto successful_return;
+
+err_drv_init:
+err_pci_set_dma_mask:
+	pr_debug("Unmapping the base address\n");
+	iounmap(hba->mmio_base);
+err_ioremap:
+	pr_debug("Calling pci_release_regions\n");
+	pci_release_regions(pdev);
+err_request_regions_failed:
+	pr_debug("Calling pci_clear_master\n");
+	pci_clear_master(pdev);
+	pr_debug("Calling pci_disable_device\n");
+	pci_disable_device(pdev);
+err_pci_enable:
+
+successful_return:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_pci_remove()
+ * remove function of Linux pci driver.
+ *  - Calls the DWC UFS HC driver's exit routine
+ *  - unmaps the pci memory resources
+ *  - Clears the Master capability of the pci device
+ *  - Releases the locked regions of pci
+ *  - Disable the pci device
+ * @pdev: pointer to PCI device handle
+ *
+ */
+static void dwc_ufshcd_pci_remove(struct pci_dev *pdev)
+{
+	struct dwc_ufs_hba *hba =3D pci_get_drvdata(pdev);
+
+	dwc_ufshcd_drv_exit(hba);
+	iounmap(hba->mmio_base);
+	pci_set_drvdata(pdev, NULL);
+	pci_clear_master(pdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+#define PCI_VENDOR_ID_SNPS		0x16c3	/* Snps Vendor Id PCI-SIG */
+#define PCI_DEVICE_ID_SNPS_HAPS_UFS	0x101a	/* Snps UFS Device ID */
+
+static const struct pci_device_id dwc_ufshcd_pci_id[] =3D {
+	{
+		PCI_DEVICE(PCI_VENDOR_ID_SNPS, PCI_DEVICE_ID_SNPS_HAPS_UFS),
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
+
+#ifdef CONFIG_PM
+/**
+ * dwc_ufshcd_generic_suspend()
+ * generic suspend function common to both pci and platform arcthitect=
ure
+ * @dev: pointer to generic device structure
+ *
+ */
+static int dwc_ufshcd_generic_suspend(struct device *dev)
+{
+	int result;
+	struct pci_dev *pdev =3D to_pci_dev(dev);
+	struct dwc_ufs_hba *hba =3D pci_get_drvdata(pdev);
+
+	result =3D dwc_ufshcd_suspend(hba);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_generic_resume()
+ * generic resume function common to both pci and platform arcthitectu=
re
+ * @dev: pointer to generic device structure
+ *
+ */
+static int dwc_ufshcd_generic_resume(struct device *dev)
+{
+	int result;
+	struct pci_dev *pdev =3D to_pci_dev(dev);
+	struct dwc_ufs_hba *hba =3D pci_get_drvdata(pdev);
+
+	result =3D dwc_ufshcd_resume(hba);
+	return result;
+}
+#else
+#define dwc_ufshcd_generic_suspend	NULL
+#define dwc_ufshcd_generic_resume	NULL
+#endif /* CONFIG_PM */
+
+static SIMPLE_DEV_PM_OPS(dwc_ufshcd_generic_pmops,
+			 dwc_ufshcd_generic_suspend,
+			 dwc_ufshcd_generic_resume);
+
+
+static struct pci_driver dwc_ufshcd_pci_driver =3D {
+	.name		=3D "dwc_ufshcd-pci",
+	.id_table	=3D dwc_ufshcd_pci_id,
+	.probe		=3D dwc_ufshcd_pci_probe,
+	.remove		=3D dwc_ufshcd_pci_remove,
+	.driver		=3D	{
+		.pm =3D   &dwc_ufshcd_generic_pmops
+	},
+};
+
+/**
+ * dwc_ufshcd_pci_driver_init()
+ * Entry point for the pci driver
+ * This function is the entry point for the pci driver.The
+ * function registers the dwc_ufshcd_pci_driver structure with the ker=
nel.
+ * Once registered, kernel is free to call the driver's probe function=
=2E
+ *
+ * Returns Negative value on error
+ */
+int __init dwc_ufshcd_pci_driver_init(void)
+{
+	return pci_register_driver(&dwc_ufshcd_pci_driver);
+}
+
+/**
+ * dwc_ufshcd_pci_driver_exit()
+ * Cleanup routine for the pci driver
+ * Description: Majority of the cleanup activity is handled by the dri=
ver's
+ * remove function. when this function is invoked, the driver unregist=
ers the
+ * already registered dwc_ufshcd_pci_driver from the kernel. Kernel, i=
nturn
+ * calls the driver's remove function before unregistering. this funct=
ion is
+ * suppose to execute without any errors.
+ *
+ */
+void __exit dwc_ufshcd_pci_driver_exit(void)
+{
+	pci_unregister_driver(&dwc_ufshcd_pci_driver);
+}
+
+module_init(dwc_ufshcd_pci_driver_init);
+module_exit(dwc_ufshcd_pci_driver_exit);
+
+MODULE_AUTHOR("Manjunath M B <manjumb@synopsys.com>");
+MODULE_DESCRIPTION("DesignWare UFS PCI Glue Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-pltfm.c b/drivers/scsi/u=
fs/dwufs/dwc_ufshcd-pltfm.c
new file mode 100644
index 0000000..4b68ce7
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-pltfm.c
@@ -0,0 +1,168 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Manjunath Bettegowda <manjumb@synopsys.com>,
+ *	    Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/version.h>
+#include <linux/io.h>
+
+#include "dwc_ufshcd-ufs.h"
+#include "dwc_ufshcd-hci.h"
+#include "dwc_ufshcd-core.h"
+
+/**
+ * dwc_ufshcd_probe()
+ *
+ * @pdev: pointer to platform device structure
+ *
+ * This routine creates the driver components required to control the =
device
+ * and initializes the device.
+ */
+static int dwc_ufshcd_probe(struct platform_device *pdev)
+{
+	int irq, result =3D 0;
+	void __iomem *mmio_base =3D NULL;
+	struct resource *mem_res =3D NULL;
+	struct dwc_ufs_hba *uninitialized_var(hba);
+
+	mem_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		dev_err(&pdev->dev,
+				"No memory resource for platform device!\n");
+		return -ENODEV;
+	}
+
+	mmio_base =3D devm_ioremap_resource(&pdev->dev, mem_res);
+
+	if (!mmio_base) {
+		dev_err(&pdev->dev, "Memory mapping failed\n");
+		return -ENOMEM;
+	}
+
+	dev_dbg(&pdev->dev, "memory start=3D0x%08x\n", (unsigned)mem_res->sta=
rt);
+	dev_dbg(&pdev->dev,
+		"memory size=3D0x%08x\n", (unsigned)resource_size(mem_res));
+
+	irq =3D platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "IRQ resource not available\n");
+		return -ENODEV;
+	}
+
+	result =3D dwc_ufshcd_drv_init(&hba, &pdev->dev, irq, mmio_base);
+	if (result !=3D 0) {
+		pr_err("Driver Initialization Failed\n");
+		goto err_drv_init;
+	}
+
+	platform_set_drvdata(pdev, hba);
+
+	/* do the link startup, phy setup and connection establishment */
+	result =3D dwc_ufshcd_connect(hba);
+
+	goto successful_return;
+
+err_drv_init:
+	pr_debug("Unmapping the base address\n");
+	iounmap(hba->mmio_base);
+
+successful_return:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_remove()
+ *
+ * @pdev: pointer to platform device structure
+ *
+ * This routine is called, for example, when the rmmod command is exec=
uted. The
+ * device may or may not be electrically present. If it is present, th=
e driver
+ * stops device processing. Any resources used on behalf of this devic=
e are
+ * freed.
+ */
+static int dwc_ufshcd_remove(struct platform_device *pdev)
+{
+	struct dwc_ufs_hba *hba =3D platform_get_drvdata(pdev);
+
+	dwc_ufshcd_drv_exit(hba);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+/**
+ * dwc_ufshcd_generic_suspend()
+ * generic suspend function common to both pci and platform arcthitect=
ure
+ * @pdev: pointer to platform device structure
+ *
+ */
+static int dwc_ufshcd_generic_suspend(struct device *dev)
+{
+	struct dwc_ufs_hba *hba =3D dev_get_drvdata(dev);
+
+	int result =3D dwc_ufshcd_suspend(hba);
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_generic_resume()
+ * generic resume function common to both pci and platform arcthitectu=
re
+ * @pdev: pointer to generic device structure
+ *
+ */
+static int dwc_ufshcd_generic_resume(struct device *dev)
+{
+	struct dwc_ufs_hba *hba =3D dev_get_drvdata(dev);
+
+	int result =3D dwc_ufshcd_resume(hba);
+
+	return result;
+}
+#else
+#define dwc_ufshcd_generic_suspend	NULL
+#define dwc_ufshcd_generic_resume	NULL
+#endif /* CONFIG_PM */
+
+static SIMPLE_DEV_PM_OPS(dwc_ufshcd_generic_pmops,
+			 dwc_ufshcd_generic_suspend,
+			 dwc_ufshcd_generic_resume);
+
+#ifdef CONFIG_OF
+static const struct of_device_id dwc_ufshcd_match[] =3D {
+	{
+		.compatible =3D "snps,dwc_ufshcd"
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, dwc_ufshcd_match);
+#endif
+
+static struct platform_driver dwc_ufshcd_driver =3D {
+	.probe		=3D dwc_ufshcd_probe,
+	.remove		=3D dwc_ufshcd_remove,
+	.driver		=3D {
+		.name	=3D "dwc_ufshcd_pltfm",
+		.of_match_table	=3D of_match_ptr(dwc_ufshcd_match),
+		.pm =3D   &dwc_ufshcd_generic_pmops,
+	},
+};
+
+module_platform_driver(dwc_ufshcd_driver);
+
+MODULE_ALIAS("platform:dwc_ufshcd_pltfm");
+MODULE_DESCRIPTION("DESIGNWARE UFS Host platform glue driver");
+MODULE_AUTHOR("Joao Pinto <Joao.Pinto@synopsys.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.c b/drivers/scsi/uf=
s/dwufs/dwc_ufshcd-scsi.c
new file mode 100644
index 0000000..0218827
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.c
@@ -0,0 +1,780 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Manjunath Bettegowda <manjumb@synopsys.com>,
+ *	    Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <scsi/scsi_host.h>		/* Linux Scsi Subsytem */
+#include <scsi/scsi_tcq.h>		/* Linux scsi_init_shared_tag_map() */
+
+#include "dwc_ufshcd-hci.h"
+#include "dwc_ufshcd-ufs.h"
+#include "dwc_ufshcd-core.h"
+#include "dwc_ufshcd-scsi.h"
+
+/**
+ * dwc_ufshcd_cp_scsi_sense_data()
+ * Copy sense data from the response upiu to applications/ operating s=
ystems
+ * sense data
+ * @lrb: pointer to local reference block
+ *
+ */
+static inline void dwc_ufshcd_cp_scsi_sense_data(struct dwc_ufs_hcd_lr=
b *lrb)
+{
+	int sense_buffer_len;
+
+	if (lrb->sense_buffer !=3D NULL) {
+		sense_buffer_len =3D be16_to_cpu(lrb->resp_upiu->sense_data_len);
+		memcpy(lrb->sense_buffer,
+			lrb->resp_upiu->sense_data,
+			min_t(int, sense_buffer_len, SCSI_SENSE_BUFFERSIZE));
+	}
+}
+
+static inline void dwc_ufshcd_program_lun_q_depth(struct scsi_device *=
sdev,
+								int depth) {
+	scsi_change_queue_depth(sdev, depth);
+}
+
+static inline void dwc_ufshcd_adjust_lun_q_depth(struct dwc_ufs_hcd_lr=
b *lrb)
+{
+	int nutrs;
+	struct dwc_ufs_hba *hba;
+	int lun_qdepth =3D 0;
+
+	hba =3D shost_priv(lrb->scmd->device->host);
+
+	/*
+	 * LUN queue depth can be obtained by counting outstanding commands
+	 * on the LUN.
+	 */
+	for (nutrs =3D 0; nutrs < hba->nutrs; nutrs++) {
+		if (test_bit(nutrs, &hba->outstanding_xfer_reqs)) {
+
+			/*
+			 * Check if the outstanding command belongs
+			 * to the LUN which reported SAM_STAT_TASK_SET_FULL.
+			 */
+			if (lrb->scmd->device->lun =3D=3D hba->lrb[nutrs].lun)
+				lun_qdepth++;
+		}
+	}
+
+	/*
+	 * LUN queue depth will be total outstanding commands, except the
+	 * command for which the LUN reported SAM_STAT_TASK_SET_FULL.
+	 */
+	scsi_change_queue_depth(lrb->scmd->device, lun_qdepth - 1);
+}
+
+/**
+ * dwc_ufshcd_get_xfer_size_and_map_scsi()
+ * It updates the transfer_size of lrb with the total length of the tr=
ansfer.
+ * In addition, it map scatter-gather of scsi command to prdt
+ * @lrb: pointer to local reference block
+ *
+ * Returns 0 in case of success, non-zero value in case of failure
+ */
+int dwc_ufshcd_get_xfer_size_and_map_scsi(struct dwc_ufs_hcd_lrb *lrb)
+{
+	struct dwc_ufs_prd *prdt;
+	struct scatterlist *sg;
+	struct scsi_cmnd *scmd;
+	int nr_sg_segments;
+	int seg;
+
+	/* Get the Scsi command from lrb */
+	scmd =3D lrb->scmd;
+
+	/* Perform the DMA mapping */
+	nr_sg_segments =3D scsi_dma_map(scmd);
+
+	/* if scsi_dma_map returns negative number its an error */
+	if (nr_sg_segments < 0)
+		return nr_sg_segments;
+
+	if (nr_sg_segments !=3D 0) {
+
+		/* update prdt length in the utrd */
+		lrb->utrd->prdt_length =3D cpu_to_le16((u16)(nr_sg_segments));
+
+		/* Get the prdt base pointer */
+		prdt =3D (struct dwc_ufs_prd *)lrb->prdt;
+
+		/* for every sg-element */
+		scsi_for_each_sg(scmd, sg, nr_sg_segments, seg) {
+			prdt[seg].byte_count =3D
+				cpu_to_le32(((u32) sg_dma_len(sg))-1);
+
+			/* Update the transfer size in lrb */
+			lrb->transfer_size +=3D sg_dma_len(sg);
+
+			prdt[seg].base_addr_lo =3D
+				cpu_to_le32(lower_32_bits(sg->dma_address));
+			prdt[seg].base_addr_hi =3D
+				cpu_to_le32(upper_32_bits(sg->dma_address));
+		}
+	} else {
+		lrb->utrd->prdt_length =3D 0;
+
+		/* Update the transfer size to zero */
+		lrb->transfer_size =3D 0;
+	}
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_scsi_queuecommand()
+ * Entry point for SCSI requests
+ * This function gets the elements from the scsi command and
+ * update the local reference block for ufs driver layer. The importan=
t
+ * elements are
+ *  - tag
+ *  - sense_buffer_len
+ *  - sense_buffer
+ *  - lun
+ *  - direction
+ * in addition, it invokes the helper function to
+ *  - get the transfer size
+ *  - map the sg list to prdt
+ * It invokes the upiu preparation function
+ * Then finally invokes the function to send the command
+ * @host: host structure registered with scsi
+ * @scmd: Scsi command from SCSI Midlayer
+ *
+ * Returns 0 for success, non-zero in case of failure
+ */
+static int dwc_ufshcd_scsi_queuecommand(struct Scsi_Host *host,
+						struct scsi_cmnd *scmd)
+{
+	struct dwc_ufs_hcd_lrb *lrb;
+	struct dwc_ufs_hba *hba;
+	unsigned long flags_irq;
+	int result =3D 0;
+	int tag;
+	u32 scsi_command =3D 0;
+
+	scsi_command =3D scmd->cmnd[0];
+
+	if (scsi_command =3D=3D 0x35) {
+		scmd->scsi_done(scmd);
+		return 0;
+	}
+
+	/* setting the FUA bit for read/write (10)(16) */
+	if (scsi_command =3D=3D 0x28 || scsi_command =3D=3D 0x88 || scsi_comm=
and =3D=3D 0x2a
+							|| scsi_command =3D=3D 0x8a)
+		scmd->cmnd[1] =3D scmd->cmnd[1] | 0x08;
+
+	/* get the private structure from SCSI host */
+	hba =3D shost_priv(host);
+
+	/* Get the tag from the request */
+	tag =3D scmd->request->tag;
+
+	if (hba->dwc_ufshcd_state !=3D DWC_UFSHCD_STATE_OPERATIONAL) {
+		result =3D SCSI_MLQUEUE_HOST_BUSY;
+		scmd->result |=3D DID_ERROR << 16;
+		goto err_dwc_ufshcd_not_operational;
+	}
+
+	/* tag and xfer request association */
+	lrb =3D &hba->lrb[tag];
+
+	/* Updating to ensure backward compatibility with older
+	 * host controllers
+	 */
+	if (hba->dwc_ufs_version =3D=3D DWC_UFS_HC_VERSION_2_0)
+		lrb->command_type =3D DWC_UTRD_CMD_TYPE_UFS_STORAGE;
+	else
+		lrb->command_type =3D DWC_UTRD_CMD_TYPE_SCSI;
+
+	lrb->scmd =3D scmd;
+	lrb->sense_buffer_len =3D SCSI_SENSE_BUFFERSIZE;
+	lrb->sense_buffer =3D scmd->sense_buffer;
+	lrb->task_tag =3D tag;
+
+	/* UFS Specific Hacks
+	 * 1. if REPORT LUNS command UFS uses */
+
+	if (scsi_command =3D=3D 0xa0)
+		lrb->lun =3D WELL_KNOWN_LUN_REPORT_LUNS;
+	else
+		lrb->lun =3D scmd->device->lun;
+
+	/* Initialize ocs and status to zero*/
+	lrb->xfer_command_status =3D 0;
+	lrb->ocs =3D 0;
+
+	/* Initialize the transfer size */
+	lrb->transfer_size =3D 0;
+
+	/* Update the data direction and upiu flags needed */
+	if (scmd->sc_data_direction =3D=3D DMA_FROM_DEVICE) {
+		lrb->data_direction =3D DWC_UTRD_DEVICE_TO_HOST;
+		lrb->read_write_flags =3D UPIU_CMD_FLAGS_READ;
+	} else if (scmd->sc_data_direction =3D=3D DMA_TO_DEVICE) {
+		lrb->data_direction =3D DWC_UTRD_HOST_TO_DEVICE;
+		lrb->read_write_flags =3D UPIU_CMD_FLAGS_WRITE;
+	} else {
+		lrb->data_direction =3D DWC_UTRD_NO_DATA_TRANSFER;
+		lrb->read_write_flags =3D UPIU_CMD_FLAGS_NONE;
+	}
+
+	result =3D dwc_ufshcd_get_xfer_size_and_map_scsi(lrb);
+
+	if (result !=3D 0)
+		goto err_dwc_ufshcd_map_scsi_sg_to_prdt;
+
+	/* form UPIU before issuing the command */
+	dwc_ufshcd_prepare_xfer_cmd_upiu(lrb);
+
+	if (hba->pstats.state =3D=3D DWC_UFS_STATS_START) {
+		hba->pstats.state =3D DWC_UFS_STATS_RUNNING;
+		getnstimeofday(&hba->pstats.start_time);
+	}
+
+	if (hba->pstats.state =3D=3D DWC_UFS_STATS_RUNNING) {
+		if (scsi_command =3D=3D 0x08) { /* Read6*/
+			hba->pstats.total_read_bytes +=3D lrb->transfer_size;
+			hba->pstats.total_cmd_read6++;
+			hba->pstats.total_no_of_prds +=3D scsi_sg_count(scmd);
+		} else if (scsi_command =3D=3D 0x28) { /* Read10 */
+			hba->pstats.total_read_bytes +=3D lrb->transfer_size;
+			hba->pstats.total_cmd_read10++;
+			hba->pstats.total_no_of_prds +=3D scsi_sg_count(scmd);
+		} else if (scsi_command =3D=3D 0x88) { /* Read16*/
+			hba->pstats.total_read_bytes +=3D lrb->transfer_size;
+			hba->pstats.total_cmd_read16++;
+			hba->pstats.total_no_of_prds +=3D scsi_sg_count(scmd);
+		} else if (scsi_command =3D=3D 0x0a) { /* write6*/
+			hba->pstats.total_write_bytes +=3D lrb->transfer_size;
+			hba->pstats.total_cmd_write6++;
+			hba->pstats.total_no_of_prds +=3D scsi_sg_count(scmd);
+		} else if (scsi_command =3D=3D 0x2a) { /* write10 */
+			hba->pstats.total_write_bytes +=3D lrb->transfer_size;
+			hba->pstats.total_cmd_write10++;
+			hba->pstats.total_no_of_prds +=3D scsi_sg_count(scmd);
+		} else if (scsi_command =3D=3D 0x8a) { /* write16*/
+			hba->pstats.total_write_bytes +=3D lrb->transfer_size;
+			hba->pstats.total_cmd_write16++;
+			hba->pstats.total_no_of_prds +=3D scsi_sg_count(scmd);
+		} else {
+			hba->pstats.total_cmd_others++;
+			hba->pstats.total_no_of_prds +=3D scsi_sg_count(scmd);
+			if (scmd->sc_data_direction =3D=3D DMA_FROM_DEVICE)
+				hba->pstats.total_read_bytes +=3D
+							lrb->transfer_size;
+			else
+				hba->pstats.total_read_bytes +=3D
+							lrb->transfer_size;
+		}
+	}
+
+	/* issue command to the controller */
+	spin_lock_irqsave(hba->shost->host_lock, flags_irq);
+	dwc_ufshcd_send_xfer_req_command(hba, tag);
+	spin_unlock_irqrestore(hba->shost->host_lock, flags_irq);
+
+err_dwc_ufshcd_map_scsi_sg_to_prdt:
+err_dwc_ufshcd_not_operational:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_copy_cdb()
+ * This function copies the cdb information available in the scsi comm=
and
+ * embedded in local reference block
+ * @cdb: buffer to hold cdb
+ * @lrb: local reference block
+ *
+ */
+void dwc_ufshcd_copy_cdb(u8 *cdb, struct dwc_ufs_hcd_lrb *lrb)
+{
+	memcpy(cdb, lrb->scmd->cmnd,
+		min_t(u16, lrb->scmd->cmd_len, UFS_MAX_CDB_SIZE));
+}
+
+/**
+ * dwc_ufshcd_scsi_slave_alloc()
+ * Handle initial SCSI device configurations
+ * @sdev: pointer to SCSI device
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+static int dwc_ufshcd_scsi_slave_alloc(struct scsi_device *sdev)
+{
+	struct dwc_ufs_hba *hba;
+
+	/* Get driver's private structure */
+	hba =3D shost_priv(sdev->host);
+	sdev->tagged_supported =3D 1;
+
+	/* Mode sense(6) is not supported by UFS, so use Mode sense(10) */
+	sdev->use_10_for_ms =3D 1;
+
+	scsi_change_queue_depth(sdev, hba->nutrs);
+
+	dwc_ufshcd_program_lun_q_depth(sdev, 8);
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_scsi_slave_destroy()
+ * Remove SCSI device configurations
+ * @sdev: pointer to SCSI device
+ *
+ */
+static void dwc_ufshcd_scsi_slave_destroy(struct scsi_device *sdev)
+{
+	struct dwc_ufs_hba *hba;
+
+	hba =3D shost_priv(sdev->host);
+}
+
+/**
+ * dwc_ufshcd_scsi_abort_handler()
+ * Abort a specific command
+ * @scmd: SCSI command pointer
+ *
+ * Returns 0 on success non zero value on error
+ */
+static int dwc_ufshcd_scsi_abort_handler(struct scsi_cmnd *scmd)
+{
+	struct Scsi_Host *shost;
+	struct dwc_ufs_hba *hba;
+	unsigned long flags_irq;
+	unsigned int tag;
+	int result =3D 0;
+
+	shost =3D scmd->device->host;
+	hba =3D shost_priv(shost);
+	tag =3D scmd->request->tag;
+
+	spin_lock_irqsave(shost->host_lock, flags_irq);
+
+	/* check if command is still pending */
+	if (!(test_bit(tag, &hba->outstanding_xfer_reqs))) {
+
+		result =3D FAILED;
+		pr_err("Slot %d is not empty, Cannot abort\n", tag);
+		spin_unlock_irqrestore(shost->host_lock, flags_irq);
+
+		/* Xfer req has been completed. No need to send abort cmd */
+		goto err_outstanding_xfer_reqs_complete;
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags_irq);
+
+	/* Issue task management command to device to ABORT the task */
+	result =3D dwc_ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_ABORT_TAS=
K);
+
+	if (result !=3D SUCCESS) {
+		pr_err("Task management command to %dth slot failed\n", tag);
+		result =3D FAILED;
+	}
+
+	/* Since the command has been aborted, unmap the prdt */
+	scsi_dma_unmap(scmd);
+
+	spin_lock_irqsave(shost->host_lock, flags_irq);
+
+	/* clear the respective Xfer Req Doorbell along with Outstanding
+	 * Xfer req bit
+	 */
+	dwc_ufshcd_clear_xfre_req(hba, tag);
+	clear_bit(tag, &hba->outstanding_xfer_reqs);
+
+	hba->lrb[tag].scmd =3D NULL;
+	spin_unlock_irqrestore(shost->host_lock, flags_irq);
+
+err_outstanding_xfer_reqs_complete:
+	return result;
+}
+
+/**
+ * dwc_ufshcd_scsi_lun_reset_handler()
+ * Reset the scsi device and abort all the pending commands
+ * @scmd: SCSI command pointer
+ *
+ * Returns zero on success, non-zero value on failure
+ */
+static int dwc_ufshcd_scsi_lun_reset_handler(struct scsi_cmnd *scmd)
+{
+	int index;
+	struct Scsi_Host *shost;
+	struct dwc_ufs_hba *hba;
+	unsigned int tag;
+	int result =3D 0;
+
+	shost =3D scmd->device->host;
+	hba =3D shost_priv(shost);
+	tag =3D scmd->request->tag;
+
+	/* Issue task management command to reset the device */
+	result =3D dwc_ufshcd_issue_tm_cmd(hba, &hba->lrb[tag], UFS_LUN_RESET=
);
+
+	if (result !=3D 0)
+		goto err_issue_tm_cmd;
+
+	/* Now device(here it is lun) is reset, clear pending xfer requests *=
/
+	for (index =3D 0; index < hba->nutrs; index++) {
+		/* Any match to scmd->lun is pending command for the same lun */
+		if (test_bit(index, &hba->outstanding_xfer_reqs) &&
+				(hba->lrb[tag].lun =3D=3D hba->lrb[index].lun)) {
+
+			/* clear the respective UTRLCLR register bit */
+			dwc_ufshcd_clear_xfre_req(hba, index);
+			clear_bit(index, &hba->outstanding_xfer_reqs);
+
+			if (hba->lrb[index].scmd !=3D NULL) {
+				scsi_dma_unmap(hba->lrb[index].scmd);
+				hba->lrb[index].scmd->result =3D
+					DID_ABORT << 16;
+				hba->lrb[index].scmd->scsi_done(scmd);
+				hba->lrb[index].scmd =3D NULL;
+			}
+		}
+	}
+
+err_issue_tm_cmd:
+	result =3D 0;
+	return result;
+}
+
+/**
+ * dwc_ufshcd_host_reset_handler()
+ * Main host reset function registered with scsi layer
+ * @scmd: SCSI command pointer
+ *
+ * Returns zero on success, non zero value on failure
+ */
+static int dwc_ufshcd_host_reset_handler(struct scsi_cmnd *scmd)
+{
+	int result =3D 0;
+	int scsi_cmd_result =3D 0;
+	struct dwc_ufs_hba *hba;
+
+	hba =3D shost_priv(scmd->device->host);
+
+	/* If host controller is already in reset state nothing to do */
+	if (hba->dwc_ufshcd_state =3D=3D DWC_UFSHCD_STATE_RESET)
+		return SUCCESS;
+
+	if (dwc_ufshcd_reset_hba(hba) =3D=3D 0) {
+		scsi_cmd_result |=3D DID_OK << 16 | COMMAND_COMPLETE << 8 |
+								SAM_STAT_GOOD;
+		scmd->result =3D scsi_cmd_result;
+		result =3D SUCCESS;
+	} else {
+		scsi_cmd_result |=3D DID_ERROR << 16;
+		result =3D FAILED;
+	}
+
+	return result;
+}
+
+static struct scsi_host_template dwc_ufshcd_scsi_host_template =3D {
+	.module				=3D THIS_MODULE,
+	.name				=3D DWC_UFSHCD,
+	.proc_name			=3D DWC_UFSHCD,
+	.queuecommand			=3D dwc_ufshcd_scsi_queuecommand,
+	.slave_alloc			=3D dwc_ufshcd_scsi_slave_alloc,
+	.slave_destroy			=3D dwc_ufshcd_scsi_slave_destroy,
+	.eh_abort_handler		=3D dwc_ufshcd_scsi_abort_handler,
+	.eh_device_reset_handler	=3D dwc_ufshcd_scsi_lun_reset_handler,
+	.eh_host_reset_handler		=3D dwc_ufshcd_host_reset_handler,
+	.this_id			=3D -1,
+	.sg_tablesize			=3D DWC_UFSHCD_MAX_PRD_SIZE,
+	.cmd_per_lun			=3D DWC_UFSHCD_CMDS_PER_LUN,
+	.can_queue			=3D DWC_UFSHCD_CAN_QUEUE,
+};
+
+/**
+ * dwc_ufshcd_alloc_scsi_host()
+ * This allocates the scshi host structure.
+ * While allocating, template containing scsi helper functions and att=
ributes
+ * are passed to scsi (scsi_alloc_host) layer. After successful alloca=
tion,
+ * scsi_alloc_host function allocates required memory for driver's pri=
vate
+ * structure and returns the pointer to the same.
+ * Driver's private strucuture is updated with scsi host reference bef=
ore
+ * returning.
+ *
+ * Returns the pointer to host's private structure on success, NULL va=
lue
+ * on failure
+ */
+struct dwc_ufs_hba *dwc_ufshcd_alloc_scsi_host(void)
+{
+	struct Scsi_Host *shost;
+	struct dwc_ufs_hba *hba;
+
+	shost =3D scsi_host_alloc(&dwc_ufshcd_scsi_host_template,
+						sizeof(struct dwc_ufs_hba));
+	if (shost =3D=3D NULL) {
+		pr_err("SCSI Host Allocation Failed\n");
+		goto err_scsi_host_alloc;
+	}
+
+	/* Get the driver's private data embedded in scsi_host structure */
+	hba =3D shost_priv(shost);
+
+	hba->shost =3D shost;
+
+	return hba;
+
+err_scsi_host_alloc:
+	scsi_host_put(shost);
+	return NULL;
+}
+
+/**
+ * dwc_ufshcd_update_scsi_attributes()
+ * Following attributes are updated to scsi midlayer.
+ * Some of the attributes are obtained from the DWC UFS HC capability =
register
+ * and some are defined as required from JEDEC specifications
+ * - Supported number of transfer request slots
+ * - Supported number of task management task slots
+ * - Maximum number of LUNs supported by Host/Device
+ * - Maximum CDB size supported for scsi commands by Host/Device
+ * @hba: Pointer to drivers structure
+ *
+ */
+void dwc_ufshcd_update_scsi_attributes(struct dwc_ufs_hba *hba)
+{
+	struct Scsi_Host *shost;
+
+	shost =3D hba->shost;
+
+	if (shost =3D=3D NULL)
+		return;
+
+	shost->can_queue =3D hba->nutrs;
+	shost->cmd_per_lun =3D hba->nutrs;
+	shost->max_id =3D DWC_UFSHCD_MAX_ID;
+	shost->max_lun =3D DWC_UFSHCD_MAX_LUNS;
+	shost->max_channel =3D DWC_UFSHCD_MAX_CHANNEL;
+	shost->unique_id =3D shost->host_no;
+	shost->max_cmd_len =3D UFS_MAX_CDB_SIZE;
+}
+
+/**
+ * dwc_ufshcd_do_scsi_tag_mapping()
+ * This function enable SCSI tag mapping: to use unique tags for all L=
UNs
+ * By doing this Scsi midlayer will manage a joint tag space for N que=
ues
+ * without driver having to partition it arbitrarily.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+int dwc_ufshcd_do_scsi_tag_mapping(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+
+	result =3D scsi_init_shared_tag_map(hba->shost, hba->shost->can_queue=
);
+
+	if (result !=3D 0)
+		pr_err("Init Shared Queue Failed\n");
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_scsi_add_host()
+ * This function adds the populated scsi host structure to the scsi mi=
dlayer
+ * By doing this, enables the scsi midlayer to start using the helper
+ * functions to work with UFS device.
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+int dwc_ufshcd_scsi_add_host(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+
+	result =3D scsi_add_host(hba->shost, hba->gdev);
+	if (result !=3D 0)
+		pr_err("scsi_add_host Failed\n");
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_scsi_remove_host()
+ * This function reverses the action performed by dwc_ufshcd_scsi_add_=
host()
+ * In addition to this it also decrements the scsi host's reference co=
unt
+ * by calling scsi_host_put()
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+int dwc_ufshcd_scsi_remove_host(struct dwc_ufs_hba *hba)
+{
+	int result =3D 0;
+
+	if (hba->shost =3D=3D NULL)
+		return result;
+
+	scsi_remove_host(hba->shost);
+	scsi_host_put(hba->shost);
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_scan_scsi_devices_attached_to_host()
+ * scsi adaptation function to do the scanning of devices attached to
+ * host controller
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+int dwc_ufshcd_scan_scsi_devices_attached_to_host(struct dwc_ufs_hba *=
hba)
+{
+	if (hba->shost =3D=3D NULL)
+		return -1;
+
+	scsi_scan_host(hba->shost);
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_block_scsi_requests()
+ * scsi adaptation function to block the requests from stack to
+ * host controller driver
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+int dwc_ufshcd_block_scsi_requests(struct dwc_ufs_hba *hba)
+{
+	if (hba->shost =3D=3D NULL)
+		return -1;
+
+	scsi_block_requests(hba->shost);
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_unblock_scsi_requests()
+ * scsi adaptation function to un-block the request from stack to
+ * host controller driver
+ * @hba: Pointer to drivers structure
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+int dwc_ufshcd_unblock_scsi_requests(struct dwc_ufs_hba *hba)
+{
+	if (hba->shost =3D=3D NULL)
+		return -1;
+
+	scsi_unblock_requests(hba->shost);
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_unmap_dma()
+ * scsi adaptation function to perform the sg unmapping.
+ * @lrb: pointer to local reference block
+ *
+ * Returns zero on success; non-zero value on failure
+ */
+int dwc_ufshcd_unmap_dma(struct dwc_ufs_hcd_lrb *lrb)
+{
+	if (lrb->scmd =3D=3D NULL)
+		return -1;
+
+	scsi_dma_unmap(lrb->scmd);
+
+	return 0;
+}
+
+/**
+ * dwc_ufshcd_get_cmd_status_with_sense_data()
+ * compute the SCSI command result based on the transfer status and
+ * ocs value stored in lrb
+ * @lrb: pointer to local reference block of completed command
+ *
+ * Returns value base on SCSI command status
+ */
+int dwc_ufshcd_get_cmd_status_with_sense_data(struct dwc_ufs_hcd_lrb *=
lrb)
+{
+	int result =3D 0;
+
+	u8 ocs =3D lrb->ocs;
+	u8 xfer_command_status =3D lrb->xfer_command_status;
+
+	if (ocs =3D=3D OCS_SUCCESS)
+		result =3D 0;
+	else if (ocs =3D=3D OCS_ABORTED)
+		result |=3D DID_ABORT << 16;
+	else
+		result |=3D DID_ERROR << 16;
+
+	switch (xfer_command_status) {
+	case SAM_STAT_GOOD:
+		/* No Sense data with this status*/
+		result |=3D DID_OK << 16 |
+			  COMMAND_COMPLETE << 8 |
+			  SAM_STAT_GOOD;
+		break;
+	case SAM_STAT_CHECK_CONDITION:
+		/* Contains sense data to SCSI command */
+		result |=3D DID_OK << 16 |
+			  COMMAND_COMPLETE << 8 |
+			  SAM_STAT_CHECK_CONDITION;
+		dwc_ufshcd_cp_scsi_sense_data(lrb);
+		break;
+	case SAM_STAT_BUSY:
+		/* May Contains sense data to SCSI command */
+		result |=3D SAM_STAT_BUSY;
+		dwc_ufshcd_cp_scsi_sense_data(lrb);
+		break;
+	case SAM_STAT_TASK_SET_FULL:
+		result |=3D SAM_STAT_TASK_SET_FULL;
+		dwc_ufshcd_adjust_lun_q_depth(lrb);
+		break;
+	case SAM_STAT_TASK_ABORTED:
+		result |=3D SAM_STAT_TASK_ABORTED;
+		break;
+	default:
+		result |=3D DID_ERROR << 16;
+		break;
+	}
+
+	return result;
+}
+
+/**
+ * dwc_ufshcd_do_scsi_completion_with_results()
+ * completion handler for scsi transfer command.
+ * @lrb: pointer to local reference block of completed command
+ *
+ * Returns value base on SCSI command status
+ */
+void dwc_ufshcd_do_scsi_completion_with_results(struct dwc_ufs_hcd_lrb=
 *lrb)
+{
+	int scsi_cmd_result =3D 0;
+
+	scsi_cmd_result =3D dwc_ufshcd_get_cmd_status_with_sense_data(lrb);
+
+	lrb->scmd->result =3D scsi_cmd_result;
+
+	/* Command is handed over to SCSI layer */
+	lrb->scmd->scsi_done(lrb->scmd);
+
+	/* Mark completed command as NULL in LRB */
+	lrb->scmd =3D NULL;
+}
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.h b/drivers/scsi/uf=
s/dwufs/dwc_ufshcd-scsi.h
new file mode 100644
index 0000000..a1b72fd
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-scsi.h
@@ -0,0 +1,29 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __DWC_UFSHCD_SCSI_H__
+#define __DWC_UFSHCD_SCSI_H__
+
+#define DWC_UFSHCD "dwc_ufshcd"
+
+int dwc_ufshcd_scsi_add_host(struct dwc_ufs_hba *);
+int dwc_ufshcd_block_scsi_requests(struct dwc_ufs_hba *);
+int dwc_ufshcd_unblock_scsi_requests(struct dwc_ufs_hba *);
+int dwc_ufshcd_unmap_dma(struct dwc_ufs_hcd_lrb *);
+int dwc_ufshcd_scan_scsi_devices_attached_to_host(struct dwc_ufs_hba *=
);
+int dwc_ufshcd_scsi_remove_host(struct dwc_ufs_hba *);
+void dwc_ufshcd_copy_cdb(u8 *, struct dwc_ufs_hcd_lrb *);
+void dwc_ufshcd_do_scsi_completion_with_results(struct dwc_ufs_hcd_lrb=
 *);
+struct dwc_ufs_hba *dwc_ufshcd_alloc_scsi_host(void);
+void dwc_ufshcd_update_scsi_attributes(struct dwc_ufs_hba *);
+int dwc_ufshcd_do_scsi_tag_mapping(struct dwc_ufs_hba *);
+
+#endif
+
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-ufs.h b/drivers/scsi/ufs=
/dwufs/dwc_ufshcd-ufs.h
new file mode 100644
index 0000000..1ea3a31
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-ufs.h
@@ -0,0 +1,457 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __DWC_UFSHCD_UFS_H__
+#define __DWC_UFSHCD_UFS_H__
+
+#define UFS_MAX_NUTRS_ALLOWED	32
+#define UFS_MAX_NUTMRS_ALLOWED	8
+#define UFS_MAX_CDB_SIZE	16
+#define UFS_MAX_LU		8
+
+#define DWC_UFSHCD_STUFF_BYTES_SIZE	196
+#define DWC_UFSHCD_MAC_KEY_LEN		32
+#define DWC_UFSHCD_RPMB_DATA_SIZE	256
+#define DWC_UFSHCD_NONCE_SIZE		16
+
+/* UFS Registers */
+#define UFS_LINK_STATUS 0xd083
+
+/* Some Expected Results from UFS Device or Device Model */
+#define DWC_UFS_SET_FLAG_RESULT_EXPECTED 0
+
+/* UFS Device Spec Versions */
+enum {
+	UFS_DEV_SPEC_VERSION_1_1	=3D 0x0110,
+	UFS_DEV_SPEC_VERSION_2_0	=3D 0x0200,
+
+};
+
+/* Well Known LUNs */
+enum {
+	WELL_KNOWN_LUN_REPORT_LUNS	=3D 0x81,
+	WELL_KNOWN_LUN_UFS_DEVICE	=3D 0xd0,
+	WELL_KNOWN_LUN_BOOT		=3D 0xb0,
+	WELL_KNOWN_LUN_RPMB		=3D 0xc4,
+};
+
+/**
+ * Every UPIU data structure contains a Transaction Code. This code de=
fines
+ * the content and implied function of use of the UPIU data structure.=
 The
+ * Transaction code fills in the lower 6 bits of Transaction Type file=
d of
+ * UPIU header
+ */
+enum {
+	UPIU_TRANS_CODE_NOP_OUT		=3D 0x00,
+	UPIU_TRANS_CODE_CMD		=3D 0x01,
+	UPIU_TRANS_CODE_DATA_OUT	=3D 0x02,
+	UPIU_TRANS_CODE_TASK_REQ	=3D 0x04,
+	UPIU_TRANS_CODE_QUERY_REQ	=3D 0x16,
+};
+
+/* UTP UPIU Transaction Codes Target to Initiator */
+enum {
+	UPIU_TRANS_CODE_NOP_IN		=3D 0x20,
+	UPIU_TRANS_CODE_RSP		=3D 0x21,
+	UPIU_TRANS_CODE_DATA_IN		=3D 0x22,
+	UPIU_TRANS_CODE_TM_RSP		=3D 0x24,
+	UPIU_TRANS_CODE_RTT		=3D 0x31,
+	UPIU_TRANS_CODE_QUERY_RESP	=3D 0x36,
+	UPIU_TRANS_CODE_REJECT_UPIU	=3D 0x3f,
+};
+
+/**
+ * UPIU Command Flags:
+ * The Response UPIU Flags enum are handled separtely
+ * Bit 5 =3D> Write Flag
+ * Bit 6 =3D> Read Flag
+ * Bits [1:0] indicate the Task Attributes
+ */
+/* Read/Write Flags: UPIU - 8bits */
+enum {
+	UPIU_CMD_FLAGS_NONE		=3D 0x00,
+	UPIU_CMD_FLAGS_WRITE		=3D 0x20,
+	UPIU_CMD_FLAGS_READ		=3D 0x40,
+};
+
+/* UPIU Task Attributes */
+enum {
+	UPIU_TASK_ATTR_SIMPLE		=3D 0x00,
+	UPIU_TASK_ATTR_ORDERED		=3D 0x01,
+	UPIU_TASK_ATTR_HEADQ		=3D 0x02,
+	UPIU_TASK_ATTR_ACA		=3D 0x03,
+};
+
+/**
+ * Response field
+ * One byte field indicating Success or Failure
+ * of requested function
+ */
+enum {
+	UPIU_RESP_TARGET_SUCCESS	=3D 0x00,
+	UPIU_RESP_TARGET_FAILURE	=3D 0x01,
+};
+
+/**
+ * UPIU Command Set Type
+ * Lower 4 bits of this byte indicates the Encapsulated Commnad for th=
is UPIU
+ */
+enum {
+	UPIU_CMD_SET_TYPE_SCSI	=3D 0x0,
+	UPIU_CMD_SET_TYPE_UFS	=3D 0x1,
+};
+
+/* Task management response codes */
+enum {
+	UPIU_TM_FUNC_COMPL		=3D 0x00,
+	UPIU_TM_FUNC_NOT_SUPPORTED	=3D 0x04,
+	UPIU_TM_FUNC_FAILED		=3D 0x05,
+	UPIU_TM_FUNC_SUCCEEDED		=3D 0x08,
+	UPIU_TM_INCORRECT_LUN		=3D 0x09,
+};
+
+/**
+ * UPIU Query Function, functions
+ * Query Function is valid when UPIU transaction code indicates it's a
+ * Query Request UPIU.
+ * One byte field used in case query functions such as QUERY_REQUEST &
+ * QUERY_RESPONSE UPIU's and task management functions such as
+ * TASK_MANAGEMENT_REQUEST & TAK_MANAGEMENT_RESPONSE UPIU's
+ *
+ **/
+enum {
+	UPIU_QUERY_RESERVED		=3D 0x00,
+	UPIU_QUERY_STD_READ_REQUEST	=3D 0x01,
+	UPIU_QUERY_STD_WRITE_REQUEST	=3D 0x81,
+};
+
+/**
+ * UTP Transaction Specific OpCode for QUERY Functions
+ * One byte Opcode indicating transaction specific operations for Stan=
dard
+ * QUERY Functions
+ */
+enum {
+	UPIU_QUERY_OPCODE_NOP		=3D 0x00,
+	UPIU_QUERY_OPCODE_READ_DESC	=3D 0x01,
+	UPIU_QUERY_OPCODE_WRITE_DESC	=3D 0x02,
+	UPIU_QUERY_OPCODE_READ_ATTR	=3D 0x03,
+	UPIU_QUERY_OPCODE_WRITE_ATTR	=3D 0x04,
+	UPIU_QUERY_OPCODE_READ_FLAG	=3D 0x05,
+	UPIU_QUERY_OPCODE_SET_FLAG	=3D 0x06,
+	UPIU_QUERY_OPCODE_CLEAR_FLAG	=3D 0x07,
+	UPIU_QUERY_OPCODE_TOGGLE_FLAG	=3D 0x08,
+};
+
+/* Descriptor Type Identifiers */
+enum {
+	UFS_DEVICE_DESCRIPTOR_TYPE		=3D 0x00,
+	UFS_CONFIG_DESCRIPTOR_TYPE		=3D 0x01,
+	UFS_UNIT_DESCRIPTOR_TYPE		=3D 0x02,
+	UFS_INTERCONNECT_DESCRIPTOR_TYPE	=3D 0x04,
+	UFS_STRING_DESCRIPTOR_TYPE		=3D 0x05,
+	UFS_GEOMETRY_DESCRIPTOR_TYPE		=3D 0x07,
+	UFS_POWER_DESCRIPTOR_TYPE		=3D 0x08,
+};
+
+/* Descriptor Lenghts */
+enum {
+	UFS_DEVICE_DESCRIPTOR_LENGTH		=3D 0x1f,
+	UFS_DEVICE_DESCRIPTOR_LENGTH_2_0	=3D 0x40,
+	UFS_CONFIG_DESCRIPTOR_LENGTH		=3D 0x90,
+	UFS_GEOMETRY_DESCRIPTOR_LENGTH		=3D 0x44,
+	UFS_UNIT_DESCRIPTOR_LENGTH		=3D 0x23,
+	UFS_RPMB_UNIT_DESCRIPTOR_LENGTH		=3D 0x23,
+	UFS_POWER_DESCRIPTOR_LENGTH		=3D 0x62,
+	UFS_INTERCONNECT_DESCRIPTOR_LENGTH	=3D 0x06,
+	UFS_STRING_DESCRIPTOR_LENGTH		=3D 0xfe,
+};
+
+/* Query FLAGS definition */
+enum {
+	UPIU_QUERY_FLAG_FDEVICEINIT			=3D 0x01,
+	UPIU_QUERY_FLAG_FPERMANENTWPEN			=3D 0x02,
+	UPIU_QUERY_FLAG_FPOWERONWPEN			=3D 0x03,
+	UPIU_QUERY_FLAG_FBACKGROUNDOPSEN		=3D 0x04,
+	UPIU_QUERY_FLAG_FPURGEENABLE			=3D 0x06,
+	UPIU_QUERY_FLAG_FPHYRESOURCEREMOVAL		=3D 0x08,
+	UPIU_QUERY_FLAG_FBUSYRTC			=3D 0x09,
+	UPIU_QUERY_FLAG_FPERMANENTLYDISALBLEFWUPDATE	=3D 0x0b,
+};
+
+/**
+ * UTP Query Response to QUERY_REQUEST_UPIU
+ * One byte field indicaing the Completion code for QUERY REQUEST UPIU
+ * Transaction code
+ */
+enum {
+	UPIU_QUERY_RESPONSE_PARAM_NOT_READABLE		=3D 0xf6,
+	UPIU_QUERY_RESPONSE_PARAM_NOT_WRITABLE		=3D 0xf7,
+	UPIU_QUERY_RESPONSE_PARAM_ALREADY_WRITTEN	=3D 0xf8,
+	UPIU_QUERY_RESPONSE_INVALID_LENGTH		=3D 0xf9,
+	UPIU_QUERY_RESPONSE_INVALID_VALUE		=3D 0xfa,
+	UPIU_QUERY_RESPONSE_INVALID_SELECTOR		=3D 0xfb,
+	UPIU_QUERY_RESPONSE_INVALID_IDN			=3D 0xfc,
+	UPIU_QUERY_RESPONSE_INVALID_OPCODE		=3D 0xfd,
+	UPIU_QUERY_RESPONSE_GENERAL_FAILURE		=3D 0xff,
+};
+
+/**
+ * Valid Failures when the UPIU transaction for target initiated REJEC=
T UPIU
+ * one of the field is set in Basic Header status when target is not a=
ble to
+ * interpret and/or execute an UPIU due to wrong values in some of its=
 fields
+ *
+ */
+enum {
+	UPIU_REJECT_HDRSTATUS_GENERAL_FAILURE		=3D 0x00,
+	UPIU_REJECT_HDRSTATUS_INV_TRANS_TYPE		=3D 0x01,
+	UPIU_REJECT_HDRSTATUS_INV_FLAGS			=3D 0x02,
+	UPIU_REJECT_HDRSTATUS_INV_LUN			=3D 0x03,
+	UPIU_REJECT_HDRSTATUS_INV_TASK_TAG		=3D 0x04,
+	UPIU_REJECT_HDRSTATUS_INV_CMD_SET_TYPE		=3D 0x05,
+	UPIU_REJECT_HDRSTATUS_INV_QUERY_FN		=3D 0x06,
+	UPIU_REJECT_HDRSTATUS_INV_TM_FN			=3D 0x06,
+	UPIU_REJECT_HDRSTATUS_INV_TOT_EHS_LEN		=3D 0x07,
+	UPIU_REJECT_HDRSTATUS_INV_DAT_SEG_LEN		=3D 0x08,
+};
+
+/**
+ * Following are the UFS Task Managemetn Functions
+ * Are valid when the transaction code field is UPIU_TRANSACTION_TASK_=
REQ
+ * These task management tasks are borrwoed from SAM-5 model of SCSI
+ */
+enum {
+	UFS_ABORT_TASK		=3D 0x01,
+	UFS_ABORT_TASK_SET	=3D 0x02,
+	UFS_CLEAR_TASK_SET	=3D 0x04,
+	UFS_LUN_RESET		=3D 0x08,
+	UFS_QUERY_TASK		=3D 0x80,
+	UFS_QUERY_TASK_SET	=3D 0x81,
+};
+
+struct ufs_device_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 bDevice;
+	u8 bDeviceClass;
+	u8 bDeviceSubClass;
+	u8 bProtocol;
+	u8 bNumberLU;
+	u8 bNumberWLU;
+	u8 bBootEnable;
+	u8 bDescrAccessEnable;
+	u8 bInitPowerMode;
+	u8 bHighPriorityLUN;
+	u8 bSecureRemovalType;
+	u8 bSecurityLU;
+
+	/* u8 reserved_1; */
+	u8 bBackgroundOpsTermLat; /* UFS 2.0 */
+
+	u8 bInitActiveICCLevel;
+	u8 wSpecVersion[2];
+	u8 wManufactureDate[2];
+	u8 iManufacturerName;
+	u8 iProductName;
+	u8 iSerialNumber;
+	u8 iOemID;
+	u8 wmanufacturerID[2];
+	u8 bUD0BaseOffset;
+	u8 bUDConfigPLength;
+	u8 bDeviceRTTCap;
+	u8 wPeriodicRTCUpdate[2];
+
+	 u8 reserved_2[17];
+	 u8 reserved_3[16];
+} ufs_device_descriptor;
+
+struct ufs_unit_descriptor_config_param_t {
+
+	u8 bLuEnable;
+	u8 bBootLunID;
+	u8 bLuWriteProtect;
+	u8 bMemoryType;
+	u8 dNumAllocUnits[4];
+	u8 bDataReliability;
+	u8 bLogicalBlockSize;
+	u8 bProvisioningType;
+	u8 wContextCapabilities[2];
+	u8 reserved_1[3];
+} ufs_unit_descriptor_config_param;
+
+struct configuration_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 bNumberLU;
+	u8 bBootEnable;
+	u8 bDescrAccessEnable;
+	u8 bInitPowerMode;
+	u8 bHighPriorityLUN;
+	u8 bSecureRemovalType;
+	u8 bInitActiveICCLevel;
+	u8 wPeriodicRTCUpdate[2];
+	u8 reserved_1[5];
+
+	struct ufs_unit_descriptor_config_param lu_config_params[UFS_MAX_LU];
+} ufs_configuration_descriptor;
+
+struct ufs_geometry_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 bMediaTechnology;
+	u8 reserved_1;
+	u8 bTotalRawDeviceCapacity[8];
+	u8 reserved_2;
+	u8 dSegmentSize[4];
+	u8 bAllocationUnitSize;
+	u8 bMinAddrBlockSize;
+	u8 bOptimalReadBlockSize;
+	u8 bOptimalWriteBlockSize;
+	u8 bMaxInBufferSize;
+	u8 bMaxOutBufferSize;
+	u8 bRPMB_ReadWriteSize;
+	u8 reserved_3;
+	u8 bDataOrdering;
+	u8 bMaxContextIDNumber;
+	u8 bSysDataTagUnitSize;
+	u8 bSysDataTagResSize;
+	u8 bSupportedSecRTypes;
+	u8 wSupportedMemoryTypes[2];
+	u8 dSystemCodeMaxNAllocU[4];
+	u8 wSystemCodeCapAdjFac[2];
+	u8 dNonPersistMaxNAllocU[4];
+	u8 wNonPersistCapAdjFac[2];
+	u8 dEnhanced1MaxNAllocU[4];
+	u8 wEnhanced1CapAdjFac[2];
+	u8 dEnhanced2MaxNAllocU[4];
+	u8 wEnhanced2CapAdjFac[2];
+	u8 dEnhanced3MaxNAllocU[4];
+	u8 wEnhanced3CapAdjFac[2];
+	u8 dEnhanced4MaxNAllocU[4];
+	u8 wEnhanced4CapAdjFac[2];
+} ufs_geometry_descriptor;
+
+struct unit_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 bUnitIndex;
+	u8 bLuEnable;
+	u8 bBootLunID;
+	u8 bLUWriteProtect;
+	u8 bLUQueueDepth;
+	u8 reserved_1;
+	u8 bMemoryType;
+	u8 bDataReliability;
+	u8 bLogicalBlockSize;
+	u8 qLogicalBlockCount[8];
+	u8 dEraseBlockSize[4];
+	u8 bProvisioningType;
+	u8 qPhyMemResourceCount[8];
+	u8 wContextCapabilities[2];
+	u8 bLargeUnitSize_M1;
+} ufs_unit_descriptor;
+
+struct rpmb_unit_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 bUnitIndex;
+	u8 bLuEnable;
+	u8 bBootLunID;
+	u8 bLUWriteProtect;
+	u8 bLUQueueDepth;
+	u8 reserved_1;
+	u8 bMemoryType;
+	u8 reserved_2;
+	u8 bLogicalBlockSize;
+	u8 qLogicalBlockCount[8];
+	u8 dEraseBlockSize[4];
+	u8 bProvisioningType;
+	u8 qPhyMemResourceCount[8];
+	u8 reserved_3[3];
+} ufs_rpmb_unit_descriptor;
+
+struct power_parameters_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 bActiveConsumptionVCC15_0[32];
+	u8 bActiveConsumptionVCCQ15_0[32];
+	u8 bActiveConsumptionVCCQ215_0[32];
+} ufs_power_parameters_descriptor;
+
+struct ufs_interconnect_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 bcdUniproVersion[2];
+	u8 bcdMphyVersion[2];
+} ufs_interconnect_descriptor;
+
+struct string_descriptor_t {
+
+	u8 bLength;
+	u8 bDescriptorType;
+	u8 uc_string[252];
+} ufs_string_descriptor;
+
+/* RPMB Related */
+/* RPMB frame : Big Endian Format */
+
+struct rpmb_frame {
+
+	u8 stuff_bytes[DWC_UFSHCD_STUFF_BYTES_SIZE]; /* 196 */
+	u8 mac_key[DWC_UFSHCD_MAC_KEY_LEN]; /* 32*/
+	u8 data[DWC_UFSHCD_RPMB_DATA_SIZE]; /* 256 */
+	u8 nonce[DWC_UFSHCD_NONCE_SIZE]; /* 16 */
+	u32 write_counter;
+	u16 address;
+	u16 block_count;
+	u16 result;
+	u16 request_response;
+};
+
+enum {
+	AUTH_KEY_PROG_REQ		=3D 0x0001,
+	READ_WR_COUNTER_VAL_REQ		=3D 0x0002,
+	AUTH_DATA_WRITE_REQ		=3D 0x0003,
+	AUTH_DATA_READ_REQ		=3D 0x0004,
+	RESULT_READ_REQ			=3D 0x0005,
+};
+
+enum {
+	AUTH_KEY_PROG_RESP		=3D 0x0100,
+	READ_WR_COUNTER_VAL_RESP	=3D 0x0200,
+	AUTH_DATA_WRITE_RESP		=3D 0x0300,
+	AUTH_DATA_READ_RESP		=3D 0x0400,
+};
+
+enum {
+	RPMB_OPERATION_OK		=3D 0x00,
+	RPMB_GENERAL_FAILURE		=3D 0x01,
+	RPMB_AUTHENTICATION_FAILURE	=3D 0x02,
+	RPMB_COUNTER_FAILURE		=3D 0x03,
+	RPMB_ADDRESS_FAILURE		=3D 0x04,
+	RPMB_WRITE_FAILURE		=3D 0x05,
+	RPMB_READ_FILURE		=3D 0x06,
+	RPMB_AUTH_KEY_NOT_PROGRAMMED	=3D 0x07,
+	RPMB_OPERATION_OK_WCE		=3D 0x80,
+	RPMB_GENERAL_FAILURE_WCE	=3D 0x81,
+	RPMB_AUTHENTICATION_FAILURE_WCE	=3D 0x82,
+	RPMB_COUNTER_FAILURE_WCE	=3D 0x83,
+	RPMB_ADDRESS_FAILURE_WCE	=3D 0x84,
+	RPMB_WRITE_FAILURE_WCE		=3D 0x85,
+	RPMB_READ_FILURE_WCE		=3D 0x86,
+};
+
+#endif
diff --git a/drivers/scsi/ufs/dwufs/dwc_ufshcd-unipro.h b/drivers/scsi/=
ufs/dwufs/dwc_ufshcd-unipro.h
new file mode 100644
index 0000000..5cc533b
--- /dev/null
+++ b/drivers/scsi/ufs/dwufs/dwc_ufshcd-unipro.h
@@ -0,0 +1,40 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DWC_UNIPRO_H_
+#define _DWC_UNIPRO_H_
+
+/* UNIPRO Attributes */
+#define UNIPRO_TX_LANES		0x1520
+#define UNIPRO_RX_LANES		0x1540
+#define UNIPRO_ACTIVE_TX_LANES	0x1560
+#define UNIPRO_CON_TX_LANES	0x1561
+#define UNIPRO_TX_PWR_STATUS	0x1567
+#define UNIPRO_HS_SERIES	0x156a
+#define UNIPRO_PWR_MODE		0x1571
+#define UNIPRO_ACTIVE_RX_LANES	0x1580
+#define UNIPRO_CON_RX_LANES	0x1581
+#define UNIPRO_RX_MAX_PWM_GEAR	0x1586
+#define UNIPRO_RX_MAX_HS_GEAR	0x1587
+#define UNIPRO_RX_PWR_STATUS	0x1582
+#define UNIPRO_LOCAL_DEV_ID	0x3000
+#define UNIPRO_LOCAL_DEV_ID_VAL	0x3001
+#define UNIPRO_CPORT_CON_STAT	0x4020
+#define UNIPRO_PEER_DEV_ID	0x4021
+#define UNIPRO_PEER_CPORT_ID	0x4022
+#define UNIPRO_TRAFFIC_CLASS	0x4023
+#define UNIPRO_CPORT_FLAGS	0x4025
+#define UNIPRO_CPORT_MODE	0x402b
+#define UNIPRO_CFG_UPDATE	0xd085
+#define UNIPRO_DBG_OMC		0xd09e
+
+#define UNIPRO_COMMON_BLK	0x8000 /* Common Block Offset*/
+
+#endif /* _DWC_UNIPRO_H_ */
--=20
1.8.1.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
