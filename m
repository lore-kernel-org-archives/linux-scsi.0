From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/4] scsi: megaraid_sas - add the ld list to driver
Date: Sun, 6 Dec 2009 08:30:19 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B7EAC2C9@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3B7EAC2C7@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:56540 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933823AbZLFPaX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Dec 2009 10:30:23 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3B7EAC2C7@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>

Driver issue the get ld list to fw to get the logic drive list.  Driver will keep the logic drive list for the internal use after driver load.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
megaraid_sas.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 megaraid_sas.h |   30 ++++++++++++++++++
 2 files changed, 125 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2009-12-04 05:34:47.000000000 -0500
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2009-12-06 03:50:19.000000000 -0500
@@ -875,6 +875,12 @@ megasas_build_dcdb(struct megasas_instan
 		pthru->sge_count = megasas_make_sgl32(instance, scp,
 						      &pthru->sgl);
 
+	if (pthru->sge_count > instance->max_num_sge) {
+		printk(KERN_ERR "megasas: DCDB two many SGE NUM=%x\n",
+			pthru->sge_count);
+		return 0;
+	}
+
 	/*
 	 * Sense info specific
 	 */
@@ -1001,6 +1007,12 @@ megasas_build_ldio(struct megasas_instan
 	} else
 		ldio->sge_count = megasas_make_sgl32(instance, scp, &ldio->sgl);
 
+	if (ldio->sge_count > instance->max_num_sge) {
+		printk(KERN_ERR "megasas: build_ld_io: sge_count = %x\n",
+			ldio->sge_count);
+		return 0;
+	}
+
 	/*
 	 * Sense info specific
 	 */
@@ -2296,6 +2308,86 @@ megasas_get_pd_list(struct megasas_insta
 	return ret;
 }
 
+/*
+ * megasas_get_ld_list_info -	Returns FW's ld_list structure
+ * @instance:				Adapter soft state
+ * @ld_list:				ld_list structure
+ *
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+static int
+megasas_get_ld_list(struct megasas_instance *instance)
+{
+	int ret = 0, ld_index = 0, ids = 0;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct MR_LD_LIST *ci;
+	dma_addr_t ci_h = 0;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas_get_ld_list: Failed to get cmd\n");
+		return -ENOMEM;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	ci = pci_alloc_consistent(instance->pdev,
+				sizeof(struct MR_LD_LIST),
+				&ci_h);
+
+	if (!ci) {
+		printk(KERN_DEBUG "Failed to alloc mem in get_ld_list\n");
+		megasas_return_cmd(instance, cmd);
+		return -ENOMEM;
+	}
+
+	memset(ci, 0, sizeof(*ci));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_READ;
+	dcmd->timeout = 0;
+	dcmd->data_xfer_len = sizeof(struct MR_LD_LIST);
+	dcmd->opcode = MR_DCMD_LD_GET_LIST;
+	dcmd->sgl.sge32[0].phys_addr = ci_h;
+	dcmd->sgl.sge32[0].length = sizeof(struct MR_LD_LIST);
+	dcmd->pad_0  = 0;
+
+	if (!megasas_issue_polled(instance, cmd)) {
+		ret = 0;
+	} else {
+		ret = -1;
+	}
+
+	/* the following function will get the instance PD LIST */
+
+	if ((ret == 0) && (ci->ldCount < MAX_LOGICAL_DRIVES)) {
+		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
+
+		for (ld_index = 0; ld_index < ci->ldCount; ld_index++) {
+			if (ci->ldList[ld_index].state != 0) {
+				ids = ci->ldList[ld_index].ref.targetId;
+				instance->ld_ids[ids] =
+					ci->ldList[ld_index].ref.targetId;
+			}
+		}
+	}
+
+	pci_free_consistent(instance->pdev,
+				sizeof(struct MR_LD_LIST),
+				ci,
+				ci_h);
+
+	megasas_return_cmd(instance, cmd);
+	return ret;
+}
+
 /**
  * megasas_get_controller_info -	Returns FW's controller structure
  * @instance:				Adapter soft state
@@ -2591,6 +2683,9 @@ static int megasas_init_mfi(struct megas
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	megasas_get_pd_list(instance);
 
+	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
+	megasas_get_ld_list(instance);
+
 	ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);
 
 	/*
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2009-12-04 05:34:47.000000000 -0500
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2009-12-05 21:54:40.000000000 -0500
@@ -117,6 +117,7 @@
 #define MFI_CMD_STP				0x08
 
 #define MR_DCMD_CTRL_GET_INFO			0x01010000
+#define MR_DCMD_LD_GET_LIST			0x03010000
 
 #define MR_DCMD_CTRL_CACHE_FLUSH		0x01101000
 #define MR_FLUSH_CTRL_CACHE			0x01
@@ -349,6 +350,32 @@ struct megasas_pd_list {
 	u8             driveState;
 } __packed;
 
+ /*
+ * defines the logical drive reference structure
+ */
+union  MR_LD_REF {
+	struct {
+		u8      targetId;
+		u8      reserved;
+		u16     seqNum;
+	};
+	u32     ref;
+} __packed;
+
+/*
+ * defines the logical drive list structure
+ */
+struct MR_LD_LIST {
+	u32     ldCount;
+	u32     reserved;
+	struct {
+		union MR_LD_REF   ref;
+		u8          state;
+		u8          reserved[3];
+		u64         size;
+	} ldList[MAX_LOGICAL_DRIVES];
+} __packed;
+
 /*
  * SAS controller properties
  */
@@ -637,6 +664,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_MAX_LD				64
 #define MEGASAS_MAX_PD                          (MEGASAS_MAX_PD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
+#define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
+						MEGASAS_MAX_DEV_PER_CHANNEL)
 
 #define MEGASAS_DBG_LVL				1
 
@@ -1187,6 +1216,7 @@ struct megasas_instance {
 	struct megasas_register_set __iomem *reg_set;
 
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
+	u8     ld_ids[MEGASAS_MAX_LD_IDS];
 	s8 init_id;
 
 	u16 max_num_sge;
