From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [RFC] [PATCH]  qla4xxx: Updated add IPv6 and misc support bugfixes
	cleanup
Date: Tue, 8 May 2007 18:06:11 +0000 (UTC)
Message-ID: <1186362293.5921.25.camel@iscsi-sles10>
References: <1178157870.20898.35.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:35383 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966005AbXEHSFD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 14:05:03 -0400
In-Reply-To: <1178157870.20898.35.camel@iscsi-sles10>
Date: Sun, 05 Aug 2007 18:04:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>

This patch OBSOLETES previous patches 0/5 thru 5/5 titled qla4xxx: Add IPv6 support and misc. It incorporates the feedback received from Mike Christie and others, and encapsulates everything into a single patch. 

The patch contains the following:
	1. clean up and make firmware related structures in ql4_fw.h to confirm to linux coding style.
	2. add support for IPv6 for QLA4032
	3. add support for capturing all AEN types in a ring buffer, to aid troubleshooting.
	4. abstract the functions for sending commands to the HBA (i.e., sending via Request Queue or Mailbox registers) so that the underlying functions can be different in future hardware. Also mailbox commands which are not performance critical may be sent via Request Queues (using mailbox iocbs).
	5. In ql4_init.c fix qla4x00_pci_config()
	6. In ql4_init.c fix in qla4xxx_add_device_dynamically(), so that a new target coming online and existing targets which went offline and then came back online are differentiated.
	7. In ql4_init.c in qla4xxx_build_ddb_list() the firmware ddb entry's state needs to be updated by calling qla4xxx_get_fwddb_entry() after qla4xxx_set_ddb_entry().
	8. remove dead code in ql4_dbg.c and ql4_mbx.c
	9. Since qla4xxx is a multifunction device having one iSCSI and one Ethernet function per physical port, when one of the functions resets the HBA all others need to acknowledge it and wait till the reset is complete and each of them need to re-initialize. A bug in qla4xxx_free_adapter() was resulting in where the resources pertaining to a function were getting released due to module unload, when the function was recovering from reset issued by one of the other functions.
	10. In qla4xxx_free_adapter() memory resources needed to be freed after free_irq() is invoked.
Thanks
David Somayajulu
QLogic Corporation


Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>


---
 drivers/scsi/qla4xxx/ql4_dbg.c     |  174 ---------------
 drivers/scsi/qla4xxx/ql4_def.h     |   83 ++++---
 drivers/scsi/qla4xxx/ql4_fw.h      |  426 +++++++++++++++---------------------
 drivers/scsi/qla4xxx/ql4_glbl.h    |   10 +
 drivers/scsi/qla4xxx/ql4_init.c    |   92 +++++---
 drivers/scsi/qla4xxx/ql4_iocb.c    |    8 +
 drivers/scsi/qla4xxx/ql4_isr.c     |   53 +++-
 drivers/scsi/qla4xxx/ql4_mbx.c     |  276 +++++++++--------------
 drivers/scsi/qla4xxx/ql4_nvram.c   |    3 
 drivers/scsi/qla4xxx/ql4_os.c      |   22 +-
 drivers/scsi/qla4xxx/ql4_version.h |    3 
 11 files changed, 463 insertions(+), 687 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_dbg.c b/drivers/scsi/qla4xxx/ql4_dbg.c
index 6437d02..fcc184c 100644
--- a/drivers/scsi/qla4xxx/ql4_dbg.c
+++ b/drivers/scsi/qla4xxx/ql4_dbg.c
@@ -6,176 +6,9 @@
  */
 
 #include "ql4_def.h"
-#include <scsi/scsi_dbg.h>
-
-#if 0
-
-static void qla4xxx_print_srb_info(struct srb * srb)
-{
-	printk("%s: srb = 0x%p, flags=0x%02x\n", __func__, srb, srb->flags);
-	printk("%s: cmd = 0x%p, saved_dma_handle = 0x%lx\n",
-	       __func__, srb->cmd, (unsigned long) srb->dma_handle);
-	printk("%s: fw_ddb_index = %d, lun = %d\n",
-	       __func__, srb->fw_ddb_index, srb->cmd->device->lun);
-	printk("%s: iocb_tov = %d\n",
-	       __func__, srb->iocb_tov);
-	printk("%s: cc_stat = 0x%x, r_start = 0x%lx, u_start = 0x%lx\n\n",
-	       __func__, srb->cc_stat, srb->r_start, srb->u_start);
-}
-
-void qla4xxx_print_scsi_cmd(struct scsi_cmnd *cmd)
-{
-	printk("SCSI Command = 0x%p, Handle=0x%p\n", cmd, cmd->host_scribble);
-	printk("  b=%d, t=%02xh, l=%02xh, cmd_len = %02xh\n",
-	       cmd->device->channel, cmd->device->id, cmd->device->lun,
-	       cmd->cmd_len);
-	scsi_print_command(cmd);
-	printk("  seg_cnt = %d\n", cmd->use_sg);
-	printk("  request buffer = 0x%p, request buffer len = 0x%x\n",
-	       cmd->request_buffer, cmd->request_bufflen);
-	if (cmd->use_sg) {
-		struct scatterlist *sg;
-		sg = (struct scatterlist *)cmd->request_buffer;
-		printk("  SG buffer: \n");
-		qla4xxx_dump_buffer((caddr_t) sg,
-				    (cmd->use_sg * sizeof(*sg)));
-	}
-	printk("  tag = %d, transfersize = 0x%x \n", cmd->tag,
-	       cmd->transfersize);
-	printk("  Pid = %d, SP = 0x%p\n", (int)cmd->pid, cmd->SCp.ptr);
-	printk("  underflow size = 0x%x, direction=0x%x\n", cmd->underflow,
-	       cmd->sc_data_direction);
-	printk("  Current time (jiffies) = 0x%lx, "
-	       "timeout expires = 0x%lx\n", jiffies, cmd->eh_timeout.expires);
-	qla4xxx_print_srb_info((struct srb *) cmd->SCp.ptr);
-}
-
-void __dump_registers(struct scsi_qla_host *ha)
-{
-	uint8_t i;
-	for (i = 0; i < MBOX_REG_COUNT; i++) {
-		printk(KERN_INFO "0x%02X mailbox[%d]	  = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg, mailbox[i]), i,
-		       readw(&ha->reg->mailbox[i]));
-	}
-	printk(KERN_INFO "0x%02X flash_address	 = 0x%08X\n",
-	       (uint8_t) offsetof(struct isp_reg, flash_address),
-	       readw(&ha->reg->flash_address));
-	printk(KERN_INFO "0x%02X flash_data	 = 0x%08X\n",
-	       (uint8_t) offsetof(struct isp_reg, flash_data),
-	       readw(&ha->reg->flash_data));
-	printk(KERN_INFO "0x%02X ctrl_status	 = 0x%08X\n",
-	       (uint8_t) offsetof(struct isp_reg, ctrl_status),
-	       readw(&ha->reg->ctrl_status));
-	if (is_qla4010(ha)) {
-		printk(KERN_INFO "0x%02X nvram		 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg, u1.isp4010.nvram),
-		       readw(&ha->reg->u1.isp4010.nvram));
-	}
-
-	else if (is_qla4022(ha) | is_qla4032(ha)) {
-		printk(KERN_INFO "0x%02X intr_mask	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u1.isp4022.intr_mask),
-		       readw(&ha->reg->u1.isp4022.intr_mask));
-		printk(KERN_INFO "0x%02X nvram		 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg, u1.isp4022.nvram),
-		       readw(&ha->reg->u1.isp4022.nvram));
-		printk(KERN_INFO "0x%02X semaphore	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u1.isp4022.semaphore),
-		       readw(&ha->reg->u1.isp4022.semaphore));
-	}
-	printk(KERN_INFO "0x%02X req_q_in	 = 0x%08X\n",
-	       (uint8_t) offsetof(struct isp_reg, req_q_in),
-	       readw(&ha->reg->req_q_in));
-	printk(KERN_INFO "0x%02X rsp_q_out	 = 0x%08X\n",
-	       (uint8_t) offsetof(struct isp_reg, rsp_q_out),
-	       readw(&ha->reg->rsp_q_out));
-	if (is_qla4010(ha)) {
-		printk(KERN_INFO "0x%02X ext_hw_conf	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4010.ext_hw_conf),
-		       readw(&ha->reg->u2.isp4010.ext_hw_conf));
-		printk(KERN_INFO "0x%02X port_ctrl	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4010.port_ctrl),
-		       readw(&ha->reg->u2.isp4010.port_ctrl));
-		printk(KERN_INFO "0x%02X port_status	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4010.port_status),
-		       readw(&ha->reg->u2.isp4010.port_status));
-		printk(KERN_INFO "0x%02X req_q_out	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4010.req_q_out),
-		       readw(&ha->reg->u2.isp4010.req_q_out));
-		printk(KERN_INFO "0x%02X gp_out		 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg, u2.isp4010.gp_out),
-		       readw(&ha->reg->u2.isp4010.gp_out));
-		printk(KERN_INFO "0x%02X gp_in		 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg, u2.isp4010.gp_in),
-		       readw(&ha->reg->u2.isp4010.gp_in));
-		printk(KERN_INFO "0x%02X port_err_status = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4010.port_err_status),
-		       readw(&ha->reg->u2.isp4010.port_err_status));
-	}
-
-	else if (is_qla4022(ha) | is_qla4032(ha)) {
-		printk(KERN_INFO "Page 0 Registers:\n");
-		printk(KERN_INFO "0x%02X ext_hw_conf	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4022.p0.ext_hw_conf),
-		       readw(&ha->reg->u2.isp4022.p0.ext_hw_conf));
-		printk(KERN_INFO "0x%02X port_ctrl	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4022.p0.port_ctrl),
-		       readw(&ha->reg->u2.isp4022.p0.port_ctrl));
-		printk(KERN_INFO "0x%02X port_status	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4022.p0.port_status),
-		       readw(&ha->reg->u2.isp4022.p0.port_status));
-		printk(KERN_INFO "0x%02X gp_out		 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4022.p0.gp_out),
-		       readw(&ha->reg->u2.isp4022.p0.gp_out));
-		printk(KERN_INFO "0x%02X gp_in		 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg, u2.isp4022.p0.gp_in),
-		       readw(&ha->reg->u2.isp4022.p0.gp_in));
-		printk(KERN_INFO "0x%02X port_err_status = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4022.p0.port_err_status),
-		       readw(&ha->reg->u2.isp4022.p0.port_err_status));
-		printk(KERN_INFO "Page 1 Registers:\n");
-		writel(HOST_MEM_CFG_PAGE & set_rmask(CSR_SCSI_PAGE_SELECT),
-		       &ha->reg->ctrl_status);
-		printk(KERN_INFO "0x%02X req_q_out	 = 0x%08X\n",
-		       (uint8_t) offsetof(struct isp_reg,
-					  u2.isp4022.p1.req_q_out),
-		       readw(&ha->reg->u2.isp4022.p1.req_q_out));
-		writel(PORT_CTRL_STAT_PAGE & set_rmask(CSR_SCSI_PAGE_SELECT),
-		       &ha->reg->ctrl_status);
-	}
-}
-
-void qla4xxx_dump_mbox_registers(struct scsi_qla_host *ha)
-{
-	unsigned long flags = 0;
-	int i = 0;
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (i = 1; i < MBOX_REG_COUNT; i++)
-		printk(KERN_INFO "  Mailbox[%d] = %08x\n", i,
-		       readw(&ha->reg->mailbox[i]));
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
-
-void qla4xxx_dump_registers(struct scsi_qla_host *ha)
-{
-	unsigned long flags = 0;
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	__dump_registers(ha);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-}
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 void qla4xxx_dump_buffer(void *b, uint32_t size)
 {
@@ -198,4 +31,3 @@ void qla4xxx_dump_buffer(void *b, uint32
 		printk(KERN_DEBUG "\n");
 }
 
-#endif  /*  0  */
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 6f4cf2d..b89ee51 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -122,8 +122,7 @@ #define MAX_REQS_SERVICED_PER_INTR	16
 
 #define ISCSI_IPADDR_SIZE		4	/* IP address size */
 #define ISCSI_ALIAS_SIZE		32	/* ISCSI Alais name size */
-#define ISCSI_NAME_SIZE			255	/* ISCSI Name size -
-						 * usually a string */
+#define ISCSI_NAME_SIZE			0xE0	/* ISCSI Name size */
 
 #define LSDW(x) ((u32)((u64)(x)))
 #define MSDW(x) ((u32)((((u64)(x)) >> 16) >> 16))
@@ -187,9 +186,21 @@ #define SRB_ERR_OTHER	   4
 	u_long u_start;		/* Time when we handed the cmd to F/W */
 };
 
-	/*
-	 * Device Database (DDB) structure
-	 */
+/*
+ * Asynchronous Event Queue structure
+ */
+struct aen {
+        uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
+};
+
+struct ql4_aen_log {
+        int count;
+        struct aen entry[MAX_AEN_ENTRIES];
+};
+
+/*
+ * Device Database (DDB) structure
+ */
 struct ddb_entry {
 	struct list_head list;	/* ddb list */
 	struct scsi_qla_host *ha;
@@ -254,13 +265,6 @@ #define DF_NO_RELOGIN		1	/* Do not relog
 #define DF_ISNS_DISCOVERED	2	/* Device was discovered via iSNS */
 #define DF_FO_MASKED		3
 
-/*
- * Asynchronous Event Queue structure
- */
-struct aen {
-	uint32_t mbox_sts[MBOX_AEN_REG_COUNT];
-};
-
 
 #include "ql4_fw.h"
 #include "ql4_nvram.h"
@@ -270,31 +274,36 @@ #include "ql4_nvram.h"
  */
 struct scsi_qla_host {
 	/* Linux adapter configuration data */
-	struct Scsi_Host *host; /* pointer to host data */
-	uint32_t tot_ddbs;
 	unsigned long flags;
 
-#define AF_ONLINE		      0 /* 0x00000001 */
-#define AF_INIT_DONE		      1 /* 0x00000002 */
-#define AF_MBOX_COMMAND		      2 /* 0x00000004 */
-#define AF_MBOX_COMMAND_DONE	      3 /* 0x00000008 */
-#define AF_INTERRUPTS_ON	      6 /* 0x00000040 Not Used */
-#define AF_GET_CRASH_RECORD	      7 /* 0x00000080 */
-#define AF_LINK_UP		      8 /* 0x00000100 */
-#define AF_IRQ_ATTACHED		     10 /* 0x00000400 */
-#define AF_ISNS_CMD_IN_PROCESS	     12 /* 0x00001000 */
-#define AF_ISNS_CMD_DONE	     13 /* 0x00002000 */
+#define AF_ONLINE			0 /* 0x00000001 */
+#define AF_INIT_DONE			1 /* 0x00000002 */
+#define AF_MBOX_COMMAND			2 /* 0x00000004 */
+#define AF_MBOX_COMMAND_DONE		3 /* 0x00000008 */
+#define AF_INTERRUPTS_ON		6 /* 0x00000040 */
+#define AF_GET_CRASH_RECORD		7 /* 0x00000080 */
+#define AF_LINK_UP			8 /* 0x00000100 */
+#define AF_IRQ_ATTACHED			10 /* 0x00000400 */
+#define AF_DISABLE_ACB_COMPLETE		11 /* 0x00000800 */
 
 	unsigned long dpc_flags;
 
-#define DPC_RESET_HA		      1 /* 0x00000002 */
-#define DPC_RETRY_RESET_HA	      2 /* 0x00000004 */
-#define DPC_RELOGIN_DEVICE	      3 /* 0x00000008 */
-#define DPC_RESET_HA_DESTROY_DDB_LIST 4 /* 0x00000010 */
-#define DPC_RESET_HA_INTR	      5 /* 0x00000020 */
-#define DPC_ISNS_RESTART	      7 /* 0x00000080 */
-#define DPC_AEN			      9 /* 0x00000200 */
-#define DPC_GET_DHCP_IP_ADDR	     15 /* 0x00008000 */
+#define DPC_RESET_HA			1 /* 0x00000002 */
+#define DPC_RETRY_RESET_HA		2 /* 0x00000004 */
+#define DPC_RELOGIN_DEVICE		3 /* 0x00000008 */
+#define DPC_RESET_HA_DESTROY_DDB_LIST	4 /* 0x00000010 */
+#define DPC_RESET_HA_INTR		5 /* 0x00000020 */
+#define DPC_ISNS_RESTART		7 /* 0x00000080 */
+#define DPC_AEN				9 /* 0x00000200 */
+#define DPC_GET_DHCP_IP_ADDR		15 /* 0x00008000 */
+
+	int (*ql4cmd)(struct scsi_qla_host *ha, struct srb * srb);
+	int (*ql4mbx)(struct scsi_qla_host *ha, uint8_t inCount,
+			uint8_t outCount, uint32_t *mbx_cmd,
+			uint32_t *mbx_sts);
+
+	struct Scsi_Host *host; /* pointer to host data */
+	uint32_t tot_ddbs;
 
 	uint16_t	iocb_cnt;
 	uint16_t	iocb_hiwat;
@@ -344,6 +353,7 @@ #define MIN_IOBASE_LEN		0x100
 	uint32_t firmware_version[2];
 	uint32_t patch_number;
 	uint32_t build_number;
+	uint32_t board_id;
 
 	/* --- From Init_FW --- */
 	/* init_cb_t *init_cb; */
@@ -363,7 +373,6 @@ #define MIN_IOBASE_LEN		0x100
 
 	/* --- From GetFwState --- */
 	uint32_t firmware_state;
-	uint32_t board_id;
 	uint32_t addl_fw_state;
 
 	/* Linux kernel thread */
@@ -414,6 +423,8 @@ #define MEM_ALIGN_VALUE \
 	uint16_t aen_out;
 	struct aen aen_q[MAX_AEN_ENTRIES];
 
+	struct ql4_aen_log aen_log;/* tracks all aens */
+
 	/* This mutex protects several threads to do mailbox commands
 	 * concurrently.
 	 */
@@ -585,10 +596,4 @@ #define PROCESS_ALL_AENS	 0
 #define FLUSH_DDB_CHANGED_AENS	 1
 #define RELOGIN_DDB_CHANGED_AENS 2
 
-#include "ql4_version.h"
-#include "ql4_glbl.h"
-#include "ql4_dbg.h"
-#include "ql4_inline.h"
-
-
 #endif	/*_QLA4XXX_H */
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 4eea8c5..9bb3d1d 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -20,143 +20,23 @@ #define MAX_DEV_DB_ENTRIES 512
  *************************************************************************/
 
 struct port_ctrl_stat_regs {
-	__le32 ext_hw_conf;	/*  80 x50  R/W */
-	__le32 intChipConfiguration; /*	 84 x54 */
-	__le32 port_ctrl;	/*  88 x58 */
-	__le32 port_status;	/*  92 x5c */
-	__le32 HostPrimMACHi;	/*  96 x60 */
-	__le32 HostPrimMACLow;	/* 100 x64 */
-	__le32 HostSecMACHi;	/* 104 x68 */
-	__le32 HostSecMACLow;	/* 108 x6c */
-	__le32 EPPrimMACHi;	/* 112 x70 */
-	__le32 EPPrimMACLow;	/* 116 x74 */
-	__le32 EPSecMACHi;	/* 120 x78 */
-	__le32 EPSecMACLow;	/* 124 x7c */
-	__le32 HostPrimIPHi;	/* 128 x80 */
-	__le32 HostPrimIPMidHi; /* 132 x84 */
-	__le32 HostPrimIPMidLow;	/* 136 x88 */
-	__le32 HostPrimIPLow;	/* 140 x8c */
-	__le32 HostSecIPHi;	/* 144 x90 */
-	__le32 HostSecIPMidHi;	/* 148 x94 */
-	__le32 HostSecIPMidLow; /* 152 x98 */
-	__le32 HostSecIPLow;	/* 156 x9c */
-	__le32 EPPrimIPHi;	/* 160 xa0 */
-	__le32 EPPrimIPMidHi;	/* 164 xa4 */
-	__le32 EPPrimIPMidLow;	/* 168 xa8 */
-	__le32 EPPrimIPLow;	/* 172 xac */
-	__le32 EPSecIPHi;	/* 176 xb0 */
-	__le32 EPSecIPMidHi;	/* 180 xb4 */
-	__le32 EPSecIPMidLow;	/* 184 xb8 */
-	__le32 EPSecIPLow;	/* 188 xbc */
-	__le32 IPReassemblyTimeout; /* 192 xc0 */
-	__le32 EthMaxFramePayload; /* 196 xc4 */
-	__le32 TCPMaxWindowSize; /* 200 xc8 */
-	__le32 TCPCurrentTimestampHi; /* 204 xcc */
-	__le32 TCPCurrentTimestampLow; /* 208 xd0 */
-	__le32 LocalRAMAddress; /* 212 xd4 */
-	__le32 LocalRAMData;	/* 216 xd8 */
-	__le32 PCSReserved1;	/* 220 xdc */
-	__le32 gp_out;		/* 224 xe0 */
-	__le32 gp_in;		/* 228 xe4 */
-	__le32 ProbeMuxAddr;	/* 232 xe8 */
-	__le32 ProbeMuxData;	/* 236 xec */
-	__le32 ERMQueueBaseAddr0; /* 240 xf0 */
-	__le32 ERMQueueBaseAddr1; /* 244 xf4 */
-	__le32 MACConfiguration; /* 248 xf8 */
-	__le32 port_err_status; /* 252 xfc  COR */
+	__le32 ext_hw_conf;	/* 0x50  R/W */
+	__le32 rsrvd0;		/* 0x54 */
+	__le32 port_ctrl;	/* 0x58 */
+	__le32 port_status;	/* 0x5c */
+	__le32 rsrvd1[32];	/* 0x60-0xdf */
+	__le32 gp_out;		/* 0xe0 */
+	__le32 gp_in;		/* 0xe4 */
+	__le32 rsrvd2[5];	/* 0xe8-0xfb */
+	__le32 port_err_status; /* 0xfc */
 };
 
 struct host_mem_cfg_regs {
-	__le32 NetRequestQueueOut; /*  80 x50 */
-	__le32 NetRequestQueueOutAddrHi; /*  84 x54 */
-	__le32 NetRequestQueueOutAddrLow; /*  88 x58 */
-	__le32 NetRequestQueueBaseAddrHi; /*  92 x5c */
-	__le32 NetRequestQueueBaseAddrLow; /*  96 x60 */
-	__le32 NetRequestQueueLength; /* 100 x64 */
-	__le32 NetResponseQueueIn; /* 104 x68 */
-	__le32 NetResponseQueueInAddrHi; /* 108 x6c */
-	__le32 NetResponseQueueInAddrLow; /* 112 x70 */
-	__le32 NetResponseQueueBaseAddrHi; /* 116 x74 */
-	__le32 NetResponseQueueBaseAddrLow; /* 120 x78 */
-	__le32 NetResponseQueueLength; /* 124 x7c */
-	__le32 req_q_out;	/* 128 x80 */
-	__le32 RequestQueueOutAddrHi; /* 132 x84 */
-	__le32 RequestQueueOutAddrLow; /* 136 x88 */
-	__le32 RequestQueueBaseAddrHi; /* 140 x8c */
-	__le32 RequestQueueBaseAddrLow; /* 144 x90 */
-	__le32 RequestQueueLength; /* 148 x94 */
-	__le32 ResponseQueueIn; /* 152 x98 */
-	__le32 ResponseQueueInAddrHi; /* 156 x9c */
-	__le32 ResponseQueueInAddrLow; /* 160 xa0 */
-	__le32 ResponseQueueBaseAddrHi; /* 164 xa4 */
-	__le32 ResponseQueueBaseAddrLow; /* 168 xa8 */
-	__le32 ResponseQueueLength; /* 172 xac */
-	__le32 NetRxLargeBufferQueueOut; /* 176 xb0 */
-	__le32 NetRxLargeBufferQueueBaseAddrHi; /* 180 xb4 */
-	__le32 NetRxLargeBufferQueueBaseAddrLow; /* 184 xb8 */
-	__le32 NetRxLargeBufferQueueLength; /* 188 xbc */
-	__le32 NetRxLargeBufferLength; /* 192 xc0 */
-	__le32 NetRxSmallBufferQueueOut; /* 196 xc4 */
-	__le32 NetRxSmallBufferQueueBaseAddrHi; /* 200 xc8 */
-	__le32 NetRxSmallBufferQueueBaseAddrLow; /* 204 xcc */
-	__le32 NetRxSmallBufferQueueLength; /* 208 xd0 */
-	__le32 NetRxSmallBufferLength; /* 212 xd4 */
-	__le32 HMCReserved0[10]; /* 216 xd8 */
+	__le32 rsrvd0[12];	/* 0x50-0x79 */
+	__le32 req_q_out;	/* 0x80 */
+	__le32 rsrvd1[31];	/* 0x84-0xFF */
 };
 
-struct local_ram_cfg_regs {
-	__le32 BufletSize;	/*  80 x50 */
-	__le32 BufletMaxCount;	/*  84 x54 */
-	__le32 BufletCurrCount; /*  88 x58 */
-	__le32 BufletPauseThresholdCount; /*  92 x5c */
-	__le32 BufletTCPWinThresholdHi; /*  96 x60 */
-	__le32 BufletTCPWinThresholdLow; /* 100 x64 */
-	__le32 IPHashTableBaseAddr; /* 104 x68 */
-	__le32 IPHashTableSize; /* 108 x6c */
-	__le32 TCPHashTableBaseAddr; /* 112 x70 */
-	__le32 TCPHashTableSize; /* 116 x74 */
-	__le32 NCBAreaBaseAddr; /* 120 x78 */
-	__le32 NCBMaxCount;	/* 124 x7c */
-	__le32 NCBCurrCount;	/* 128 x80 */
-	__le32 DRBAreaBaseAddr; /* 132 x84 */
-	__le32 DRBMaxCount;	/* 136 x88 */
-	__le32 DRBCurrCount;	/* 140 x8c */
-	__le32 LRCReserved[28]; /* 144 x90 */
-};
-
-struct prot_stat_regs {
-	__le32 MACTxFrameCount; /*  80 x50   R */
-	__le32 MACTxByteCount;	/*  84 x54   R */
-	__le32 MACRxFrameCount; /*  88 x58   R */
-	__le32 MACRxByteCount;	/*  92 x5c   R */
-	__le32 MACCRCErrCount;	/*  96 x60   R */
-	__le32 MACEncErrCount;	/* 100 x64   R */
-	__le32 MACRxLengthErrCount; /* 104 x68	 R */
-	__le32 IPTxPacketCount; /* 108 x6c   R */
-	__le32 IPTxByteCount;	/* 112 x70   R */
-	__le32 IPTxFragmentCount; /* 116 x74   R */
-	__le32 IPRxPacketCount; /* 120 x78   R */
-	__le32 IPRxByteCount;	/* 124 x7c   R */
-	__le32 IPRxFragmentCount; /* 128 x80   R */
-	__le32 IPDatagramReassemblyCount; /* 132 x84   R */
-	__le32 IPV6RxPacketCount; /* 136 x88   R */
-	__le32 IPErrPacketCount; /* 140 x8c   R */
-	__le32 IPReassemblyErrCount; /* 144 x90	  R */
-	__le32 TCPTxSegmentCount; /* 148 x94   R */
-	__le32 TCPTxByteCount;	/* 152 x98   R */
-	__le32 TCPRxSegmentCount; /* 156 x9c   R */
-	__le32 TCPRxByteCount;	/* 160 xa0   R */
-	__le32 TCPTimerExpCount; /* 164 xa4   R */
-	__le32 TCPRxAckCount;	/* 168 xa8   R */
-	__le32 TCPTxAckCount;	/* 172 xac   R */
-	__le32 TCPRxErrOOOCount; /* 176 xb0   R */
-	__le32 PSReserved0;	/* 180 xb4 */
-	__le32 TCPRxWindowProbeUpdateCount; /* 184 xb8	 R */
-	__le32 ECCErrCorrectionCount; /* 188 xbc   R */
-	__le32 PSReserved1[16]; /* 192 xc0 */
-};
-
-
 /*  remote register set (access via PCI memory read/write) */
 struct isp_reg {
 #define MBOX_REG_COUNT 8
@@ -207,11 +87,7 @@ #define MBOX_REG_COUNT 8
 			union {
 				struct port_ctrl_stat_regs p0;
 				struct host_mem_cfg_regs p1;
-				struct local_ram_cfg_regs p2;
-				struct prot_stat_regs p3;
-				__le32 r_union[44];
 			};
-
 		} __attribute__ ((packed)) isp4022;
 	} u2;
 };				/* 256 x100 */
@@ -296,6 +172,7 @@ #define NVR_WRITE_ENABLE			0x00000010	/*
 /*  ISP Semaphore definitions */
 
 /*  ISP General Purpose Output definitions */
+#define GPOR_TOPCAT_RESET			0x00000004
 
 /*  shadow registers (DMA'd from HA to system memory.  read only) */
 struct shadow_regs {
@@ -337,6 +214,7 @@ union external_hw_config_reg {
 
 /*  Mailbox command definitions */
 #define MBOX_CMD_ABOUT_FW			0x0009
+#define MBOX_CMD_PING				0x000B
 #define MBOX_CMD_LUN_RESET			0x0016
 #define MBOX_CMD_GET_MANAGEMENT_DATA		0x001E
 #define MBOX_CMD_GET_FW_STATUS			0x001F
@@ -364,6 +242,17 @@ #define DDB_DS_LOGIN_IN_PROCESS			0x07
 #define MBOX_CMD_GET_FW_STATE			0x0069
 #define MBOX_CMD_GET_INIT_FW_CTRL_BLOCK_DEFAULTS 0x006A
 #define MBOX_CMD_RESTORE_FACTORY_DEFAULTS	0x0087
+#define MBOX_CMD_SET_ACB			0x0088
+#define MBOX_CMD_GET_ACB			0x0089
+#define MBOX_CMD_DISABLE_ACB			0x008A
+#define MBOX_CMD_GET_IPV6_NEIGHBOR_CACHE	0x008B
+#define MBOX_CMD_GET_IPV6_DEST_CACHE		0x008C
+#define MBOX_CMD_GET_IPV6_DEF_ROUTER_LIST	0x008D
+#define MBOX_CMD_GET_IPV6_LCL_PREFIX_LIST	0x008E
+#define MBOX_CMD_SET_IPV6_NEIGHBOR_CACHE	0x0090
+#define MBOX_CMD_GET_IP_ADDR_STATE		0x0091
+#define MBOX_CMD_SEND_IPV6_ROUTER_SOL		0x0092
+#define MBOX_CMD_GET_DB_ENTRY_CURRENT_IP_ADDR	0x0093
 
 /* Mailbox 1 */
 #define FW_STATE_READY				0x0000
@@ -409,6 +298,16 @@ #define MBOX_ASTS_IP_ADDRESS_CHANGED		0x
 #define MBOX_ASTS_DHCP_LEASE_EXPIRED		0x801D
 #define MBOX_ASTS_DHCP_LEASE_ACQUIRED		0x801F
 #define MBOX_ASTS_ISNS_UNSOLICITED_PDU_RECEIVED 0x8021
+#define MBOX_ASTS_DUPLICATE_IP			0x8025
+#define MBOX_ASTS_ARP_COMPLETE			0x8026
+#define MBOX_ASTS_SUBNET_STATE_CHANGE		0x8027
+#define MBOX_ASTS_RESPONSE_QUEUE_FULL		0x8028
+#define MBOX_ASTS_IP_ADDR_STATE_CHANGED		0x8029
+#define MBOX_ASTS_IPV6_PREFIX_EXPIRED		0x802B
+#define MBOX_ASTS_IPV6_ND_PREFIX_IGNORED	0x802C
+#define MBOX_ASTS_IPV6_LCL_PREFIX_IGNORED	0x802D
+#define MBOX_ASTS_ICMPV6_ERROR_MSG_RCVD		0x802E
+
 #define ISNS_EVENT_DATA_RECEIVED		0x0000
 #define ISNS_EVENT_CONNECTION_OPENED		0x0001
 #define ISNS_EVENT_CONNECTION_FAILED		0x0002
@@ -418,137 +317,166 @@ #define MBOX_ASTS_SUBNET_STATE_CHANGE		0
 /*************************************************************************/
 
 /* Host Adapter Initialization Control Block (from host) */
-struct init_fw_ctrl_blk {
-	uint8_t Version;	/* 00 */
-	uint8_t Control;	/* 01 */
+struct addr_ctrl_blk {
+	uint8_t version;	/* 00 */
+	uint8_t control;	/* 01 */
 
-	uint16_t FwOptions;	/* 02-03 */
+	uint16_t fw_options;	/* 02-03 */
 #define	 FWOPT_HEARTBEAT_ENABLE		  0x1000
 #define	 FWOPT_SESSION_MODE		  0x0040
 #define	 FWOPT_INITIATOR_MODE		  0x0020
 #define	 FWOPT_TARGET_MODE		  0x0010
 
-	uint16_t ExecThrottle;	/* 04-05 */
-	uint8_t RetryCount;	/* 06 */
-	uint8_t RetryDelay;	/* 07 */
-	uint16_t MaxEthFrPayloadSize;	/* 08-09 */
-	uint16_t AddFwOptions;	/* 0A-0B */
-
-	uint8_t HeartbeatInterval;	/* 0C */
-	uint8_t InstanceNumber; /* 0D */
-	uint16_t RES2;		/* 0E-0F */
-	uint16_t ReqQConsumerIndex;	/* 10-11 */
-	uint16_t ComplQProducerIndex;	/* 12-13 */
-	uint16_t ReqQLen;	/* 14-15 */
-	uint16_t ComplQLen;	/* 16-17 */
-	uint32_t ReqQAddrLo;	/* 18-1B */
-	uint32_t ReqQAddrHi;	/* 1C-1F */
-	uint32_t ComplQAddrLo;	/* 20-23 */
-	uint32_t ComplQAddrHi;	/* 24-27 */
-	uint32_t ShadowRegBufAddrLo;	/* 28-2B */
-	uint32_t ShadowRegBufAddrHi;	/* 2C-2F */
-
-	uint16_t iSCSIOptions;	/* 30-31 */
-
-	uint16_t TCPOptions;	/* 32-33 */
-
-	uint16_t IPOptions;	/* 34-35 */
-
-	uint16_t MaxPDUSize;	/* 36-37 */
-	uint16_t RcvMarkerInt;	/* 38-39 */
-	uint16_t SndMarkerInt;	/* 3A-3B */
-	uint16_t InitMarkerlessInt;	/* 3C-3D */
-	uint16_t FirstBurstSize;	/* 3E-3F */
-	uint16_t DefaultTime2Wait;	/* 40-41 */
-	uint16_t DefaultTime2Retain;	/* 42-43 */
-	uint16_t MaxOutStndngR2T;	/* 44-45 */
-	uint16_t KeepAliveTimeout;	/* 46-47 */
-	uint16_t PortNumber;	/* 48-49 */
-	uint16_t MaxBurstSize;	/* 4A-4B */
-	uint32_t RES4;		/* 4C-4F */
-	uint8_t IPAddr[4];	/* 50-53 */
-	uint8_t RES5[12];	/* 54-5F */
-	uint8_t SubnetMask[4];	/* 60-63 */
-	uint8_t RES6[12];	/* 64-6F */
-	uint8_t GatewayIPAddr[4];	/* 70-73 */
-	uint8_t RES7[12];	/* 74-7F */
-	uint8_t PriDNSIPAddr[4];	/* 80-83 */
-	uint8_t SecDNSIPAddr[4];	/* 84-87 */
-	uint8_t RES8[8];	/* 88-8F */
-	uint8_t Alias[32];	/* 90-AF */
-	uint8_t TargAddr[8];	/* B0-B7 *//* /FIXME: Remove?? */
-	uint8_t CHAPNameSecretsTable[8];	/* B8-BF */
-	uint8_t EthernetMACAddr[6];	/* C0-C5 */
-	uint16_t TargetPortalGroup;	/* C6-C7 */
-	uint8_t SendScale;	/* C8	 */
-	uint8_t RecvScale;	/* C9	 */
-	uint8_t TypeOfService;	/* CA	 */
-	uint8_t Time2Live;	/* CB	 */
-	uint16_t VLANPriority;	/* CC-CD */
-	uint16_t Reserved8;	/* CE-CF */
-	uint8_t SecIPAddr[4];	/* D0-D3 */
-	uint8_t Reserved9[12];	/* D4-DF */
-	uint8_t iSNSIPAddr[4];	/* E0-E3 */
-	uint16_t iSNSServerPortNumber;	/* E4-E5 */
-	uint8_t Reserved10[10]; /* E6-EF */
-	uint8_t SLPDAIPAddr[4]; /* F0-F3 */
-	uint8_t Reserved11[12]; /* F4-FF */
-	uint8_t iSCSINameString[256];	/* 100-1FF */
+	uint16_t exec_throttle;	/* 04-05 */
+	uint8_t zio_count;	/* 06 */
+	uint8_t res0;	/* 07 */
+	uint16_t eth_mtu_size;	/* 08-09 */
+	uint16_t add_fw_options;	/* 0A-0B */
+
+	uint8_t hb_interval;	/* 0C */
+	uint8_t inst_num; /* 0D */
+	uint16_t res1;		/* 0E-0F */
+	uint16_t rqq_consumer_idx;	/* 10-11 */
+	uint16_t compq_producer_idx;	/* 12-13 */
+	uint16_t rqq_len;	/* 14-15 */
+	uint16_t compq_len;	/* 16-17 */
+	uint32_t rqq_addr_lo;	/* 18-1B */
+	uint32_t rqq_addr_hi;	/* 1C-1F */
+	uint32_t compq_addr_lo;	/* 20-23 */
+	uint32_t compq_addr_hi;	/* 24-27 */
+	uint32_t shdwreg_addr_lo;	/* 28-2B */
+	uint32_t shdwreg_addr_hi;	/* 2C-2F */
+
+	uint16_t iscsi_opts;	/* 30-31 */
+	uint16_t ipv4_tcp_opts;	/* 32-33 */
+	uint16_t ipv4_ip_opts;	/* 34-35 */
+
+	uint16_t iscsi_max_pdu_size;	/* 36-37 */
+	uint8_t ipv4_tos;	/* 38 */
+	uint8_t ipv4_ttl;	/* 39 */
+	uint8_t acb_version;	/* 3A */
+	uint8_t res2;	/* 3B */
+	uint16_t def_timeout;	/* 3C-3D */
+	uint16_t iscsi_fburst_len;	/* 3E-3F */
+	uint16_t iscsi_def_time2wait;	/* 40-41 */
+	uint16_t iscsi_def_time2retain;	/* 42-43 */
+	uint16_t iscsi_max_outstnd_r2t;	/* 44-45 */
+	uint16_t conn_ka_timeout;	/* 46-47 */
+	uint16_t ipv4_port;	/* 48-49 */
+	uint16_t iscsi_max_burst_len;	/* 4A-4B */
+	uint32_t res5;		/* 4C-4F */
+	uint8_t ipv4_addr[4];	/* 50-53 */
+	uint16_t ipv4_vlan_tag;	/* 54-55 */
+	uint8_t ipv4_addr_state;	/* 56 */
+	uint8_t ipv4_cacheid;	/* 57 */
+	uint8_t res6[8];	/* 58-5F */
+	uint8_t ipv4_subnet[4];	/* 60-63 */
+	uint8_t res7[12];	/* 64-6F */
+	uint8_t ipv4_gw_addr[4];	/* 70-73 */
+	uint8_t res8[0xc];	/* 74-7F */
+	uint8_t pri_dns_srvr_ip[4];/* 80-83 */
+	uint8_t sec_dns_srvr_ip[4];/* 84-87 */
+	uint16_t min_eph_port;	/* 88-89 */
+	uint16_t max_eph_port;	/* 8A-8B */
+	uint8_t res9[4];	/* 8C-8F */
+	uint8_t iscsi_alias[32];/* 90-AF */
+	uint8_t res9_1[0x16];	/* B0-C5 */
+	uint16_t tgt_portal_grp;/* C6-C7 */
+	uint8_t abort_timer;	/* C8	 */
+	uint8_t ipv4_tcp_wsf;	/* C9	 */
+	uint8_t res10[6];	/* CA-CF */
+	uint8_t ipv4_sec_ip_addr[4];	/* D0-D3 */
+	uint8_t ipv4_dhcp_vid_len;	/* D4 */
+	uint8_t ipv4_dhcp_vid[11];	/* D5-DF */
+	uint8_t res11[20];	/* E0-F3 */
+	uint8_t ipv4_dhcp_alt_cid_len;	/* F4 */
+	uint8_t ipv4_dhcp_alt_cid[11];	/* F5-FF */
+	uint8_t iscsi_name[224];	/* 100-1DF */
+	uint8_t res12[32];	/* 1E0-1FF */
+	uint32_t cookie;	/* 200-203 */
+	uint16_t ipv6_port;	/* 204-205 */
+	uint16_t ipv6_opts;	/* 206-207 */
+	uint16_t ipv6_addtl_opts;	/* 208-209 */
+	uint16_t ipv6_tcp_opts;	/* 20A-20B */
+	uint8_t ipv6_tcp_wsf;	/* 20C */
+	uint16_t ipv6_flow_lbl;	/* 20D-20F */
+	uint8_t ipv6_gw_addr[16];	/* 210-21F */
+	uint16_t ipv6_vlan_tag;	/* 220-221 */
+	uint8_t ipv6_lnk_lcl_addr_state;/* 222 */
+	uint8_t ipv6_addr0_state;	/* 223 */
+	uint8_t ipv6_addr1_state;	/* 224 */
+	uint8_t ipv6_gw_state;	/* 225 */
+	uint8_t ipv6_traffic_class;	/* 226 */
+	uint8_t ipv6_hop_limit;	/* 227 */
+	uint8_t ipv6_if_id[8];	/* 228-22F */
+	uint8_t ipv6_addr0[16];	/* 230-23F */
+	uint8_t ipv6_addr1[16];	/* 240-24F */
+	uint32_t ipv6_nd_reach_time;	/* 250-253 */
+	uint32_t ipv6_nd_rexmit_timer;	/* 254-257 */
+	uint32_t ipv6_nd_stale_timeout;	/* 258-25B */
+	uint8_t ipv6_dup_addr_detect_count;	/* 25C */
+	uint8_t ipv6_cache_id;	/* 25D */
+	uint8_t res13[18];	/* 25E-26F */
+	uint32_t ipv6_gw_advrt_mtu;	/* 270-273 */
+	uint8_t res14[140];	/* 274-2FF */
+};
+
+struct init_fw_ctrl_blk {
+	struct addr_ctrl_blk pri;
+	struct addr_ctrl_blk sec;
 };
 
 /*************************************************************************/
 
 struct dev_db_entry {
-	uint8_t options;	/* 00 */
+	uint16_t options;	/* 00-01 */
 #define DDB_OPT_DISC_SESSION  0x10
 #define DDB_OPT_TARGET	      0x02 /* device is a target */
 
-	uint8_t control;	/* 01 */
-
-	uint16_t exeThrottle;	/* 02-03 */
-	uint16_t exeCount;	/* 04-05 */
-	uint8_t retryCount;	/* 06	 */
-	uint8_t retryDelay;	/* 07	 */
-	uint16_t iSCSIOptions;	/* 08-09 */
-
-	uint16_t TCPOptions;	/* 0A-0B */
-
-	uint16_t IPOptions;	/* 0C-0D */
-
-	uint16_t maxPDUSize;	/* 0E-0F */
-	uint16_t rcvMarkerInt;	/* 10-11 */
-	uint16_t sndMarkerInt;	/* 12-13 */
-	uint16_t iSCSIMaxSndDataSegLen; /* 14-15 */
-	uint16_t firstBurstSize;	/* 16-17 */
-	uint16_t minTime2Wait;	/* 18-19 : RA :default_time2wait */
-	uint16_t maxTime2Retain;	/* 1A-1B */
-	uint16_t maxOutstndngR2T;	/* 1C-1D */
-	uint16_t keepAliveTimeout;	/* 1E-1F */
-	uint8_t ISID[6];	/* 20-25 big-endian, must be converted
+	uint16_t exec_throttle;	/* 02-03 */
+	uint16_t exec_count;	/* 04-05 */
+	uint16_t res0;	/* 06-07 */
+	uint16_t iscsi_options;	/* 08-09 */
+	uint16_t tcp_options;	/* 0A-0B */
+	uint16_t ip_options;	/* 0C-0D */
+	uint16_t iscsi_max_rcv_data_seg_len;	/* 0E-0F */
+	uint32_t res1;	/* 10-13 */
+	uint16_t iscsi_max_snd_data_seg_len;	/* 14-15 */
+	uint16_t iscsi_first_burst_len;	/* 16-17 */
+	uint16_t iscsi_def_time2wait;	/* 18-19 */
+	uint16_t iscsi_def_time2retain;	/* 1A-1B */
+	uint16_t iscsi_max_outsnd_r2t;	/* 1C-1D */
+	uint16_t ka_timeout;	/* 1E-1F */
+	uint8_t isid[6];	/* 20-25 big-endian, must be converted
 				 * to little-endian */
-	uint16_t TSID;		/* 26-27 */
-	uint16_t portNumber;	/* 28-29 */
-	uint16_t maxBurstSize;	/* 2A-2B */
-	uint16_t taskMngmntTimeout;	/* 2C-2D */
-	uint16_t reserved1;	/* 2E-2F */
-	uint8_t ipAddr[0x10];	/* 30-3F */
-	uint8_t iSCSIAlias[0x20];	/* 40-5F */
-	uint8_t targetAddr[0x20];	/* 60-7F */
-	uint8_t userID[0x20];	/* 80-9F */
-	uint8_t password[0x20]; /* A0-BF */
-	uint8_t iscsiName[0x100];	/* C0-1BF : xxzzy Make this a
+	uint16_t tsid;		/* 26-27 */
+	uint16_t port;	/* 28-29 */
+	uint16_t iscsi_max_burst_len;	/* 2A-2B */
+	uint16_t def_timeout;	/* 2C-2D */
+	uint16_t res2;	/* 2E-2F */
+	uint8_t ip_addr[0x10];	/* 30-3F */
+	uint8_t iscsi_alias[0x20];	/* 40-5F */
+	uint8_t tgt_addr[0x20];	/* 60-7F */
+	uint16_t mss;	/* 80-81 */
+	uint16_t res3;	/* 82-83 */
+	uint16_t lcl_port;	/* 84-85 */
+	uint8_t ipv4_tos;	/* 86 */
+	uint16_t ipv6_flow_lbl;	/* 87-89 */
+	uint8_t res4[0x36];	/* 8A-BF */
+	uint8_t iscsi_name[0xE0];	/* C0-19F : xxzzy Make this a
 					 * pointer to a string so we
 					 * don't have to reserve soooo
 					 * much RAM */
-	uint16_t ddbLink;	/* 1C0-1C1 */
-	uint16_t CHAPTableIndex; /* 1C2-1C3 */
-	uint16_t TargetPortalGroup; /* 1C4-1C5 */
-	uint16_t reserved2[2];	/* 1C6-1C7 */
-	uint32_t statSN;	/* 1C8-1CB */
-	uint32_t expStatSN;	/* 1CC-1CF */
-	uint16_t reserved3[0x2C]; /* 1D0-1FB */
-	uint16_t ddbValidCookie; /* 1FC-1FD */
-	uint16_t ddbValidSize;	/* 1FE-1FF */
+	uint8_t ipv6_addr[0x10];/* 1A0-1AF */
+	uint8_t res5[0x10];	/* 1B0-1BF */
+	uint16_t ddb_link;	/* 1C0-1C1 */
+	uint16_t chap_tbl_idx;	/* 1C2-1C3 */
+	uint16_t tgt_portal_grp; /* 1C4-1C5 */
+	uint8_t tcp_xmt_wsf;	/* 1C6 */
+	uint8_t tcp_rcv_wsf;	/* 1C7 */
+	uint32_t stat_sn;	/* 1C8-1CB */
+	uint32_t exp_stat_sn;	/* 1CC-1CF */
+	uint8_t res6[0x30];	/* 1D0-1FF */
 };
 
 /*************************************************************************/
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index 5b00cb0..5794859 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -8,6 +8,9 @@
 #ifndef __QLA4x_GBL_H
 #define	__QLA4x_GBL_H
 
+struct iscsi_cls_conn;
+
+void qla4xxx_hw_reset(struct scsi_qla_host *ha);
 int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a);
 int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port);
 int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb);
@@ -58,11 +61,16 @@ int qla4xxx_get_fw_version(struct scsi_q
 void qla4xxx_interrupt_service_routine(struct scsi_qla_host * ha,
 				       uint32_t intr_status);
 int qla4xxx_init_rings(struct scsi_qla_host * ha);
-struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha, uint32_t index);
+struct srb * qla4xxx_del_from_active_array(struct scsi_qla_host *ha,
+					uint32_t index);
 void qla4xxx_srb_compl(struct scsi_qla_host *ha, struct srb *srb);
 int qla4xxx_reinitialize_ddb_list(struct scsi_qla_host * ha);
 int qla4xxx_process_ddb_changed(struct scsi_qla_host * ha,
 				uint32_t fw_ddb_index, uint32_t state);
+int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
+			uint8_t outCount, uint32_t *mbx_cmd,
+			uint32_t *mbx_sts);
+void qla4xxx_dump_buffer(void *b, uint32_t size);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 6365df2..b76ba54 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 static struct ddb_entry * qla4xxx_alloc_ddb(struct scsi_qla_host *ha,
 					    uint32_t fw_ddb_index);
@@ -300,12 +303,12 @@ static int qla4xxx_init_firmware(struct 
 	if (!qla4xxx_fw_ready(ha))
 		return status;
 
-	set_bit(AF_ONLINE, &ha->flags);
 	return qla4xxx_get_firmware_status(ha);
 }
 
 static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
-					       uint32_t fw_ddb_index)
+						uint32_t fw_ddb_index,
+						uint32_t *new_tgt)
 {
 	struct dev_db_entry *fw_ddb_entry = NULL;
 	dma_addr_t fw_ddb_entry_dma;
@@ -313,6 +316,7 @@ static struct ddb_entry* qla4xxx_get_ddb
 	int found = 0;
 	uint32_t device_state;
 
+	*new_tgt = 0;
 	/* Make sure the dma buffer is valid */
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev,
 					  sizeof(*fw_ddb_entry),
@@ -337,7 +341,7 @@ static struct ddb_entry* qla4xxx_get_ddb
 	DEBUG2(printk("scsi%ld: %s: Looking for ddb[%d]\n", ha->host_no,
 		      __func__, fw_ddb_index));
 	list_for_each_entry(ddb_entry, &ha->ddb_list, list) {
-		if (memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsiName,
+		if (memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsi_name,
 			   ISCSI_NAME_SIZE) == 0) {
 			found++;
 			break;
@@ -348,6 +352,7 @@ static struct ddb_entry* qla4xxx_get_ddb
 		DEBUG2(printk("scsi%ld: %s: ddb[%d] not found - allocating "
 			      "new ddb\n", ha->host_no, __func__,
 			      fw_ddb_index));
+		*new_tgt = 1;
 		ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
 	}
 
@@ -409,26 +414,26 @@ static int qla4xxx_update_ddb_entry(stru
 	}
 
 	status = QLA_SUCCESS;
-	ddb_entry->target_session_id = le16_to_cpu(fw_ddb_entry->TSID);
+	ddb_entry->target_session_id = le16_to_cpu(fw_ddb_entry->tsid);
 	ddb_entry->task_mgmt_timeout =
-		le16_to_cpu(fw_ddb_entry->taskMngmntTimeout);
+		le16_to_cpu(fw_ddb_entry->def_timeout);
 	ddb_entry->CmdSn = 0;
-	ddb_entry->exe_throttle = le16_to_cpu(fw_ddb_entry->exeThrottle);
+	ddb_entry->exe_throttle = le16_to_cpu(fw_ddb_entry->exec_throttle);
 	ddb_entry->default_relogin_timeout =
-		le16_to_cpu(fw_ddb_entry->taskMngmntTimeout);
-	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->minTime2Wait);
+		le16_to_cpu(fw_ddb_entry->def_timeout);
+	ddb_entry->default_time2wait = le16_to_cpu(fw_ddb_entry->iscsi_def_time2wait);
 
 	/* Update index in case it changed */
 	ddb_entry->fw_ddb_index = fw_ddb_index;
 	ha->fw_ddb_index_map[fw_ddb_index] = ddb_entry;
 
-	ddb_entry->port = le16_to_cpu(fw_ddb_entry->portNumber);
-	ddb_entry->tpgt = le32_to_cpu(fw_ddb_entry->TargetPortalGroup);
-	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsiName[0],
+	ddb_entry->port = le16_to_cpu(fw_ddb_entry->port);
+	ddb_entry->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsi_name[0],
 	       min(sizeof(ddb_entry->iscsi_name),
-		   sizeof(fw_ddb_entry->iscsiName)));
-	memcpy(&ddb_entry->ip_addr[0], &fw_ddb_entry->ipAddr[0],
-	       min(sizeof(ddb_entry->ip_addr), sizeof(fw_ddb_entry->ipAddr)));
+		   sizeof(fw_ddb_entry->iscsi_name)));
+	memcpy(&ddb_entry->ip_addr[0], &fw_ddb_entry->ip_addr[0],
+	       min(sizeof(ddb_entry->ip_addr), sizeof(fw_ddb_entry->ip_addr)));
 
 	DEBUG2(printk("scsi%ld: %s: ddb[%d] - State= %x status= %d.\n",
 		      ha->host_no, __func__, fw_ddb_index,
@@ -495,6 +500,7 @@ static int qla4xxx_build_ddb_list(struct
 	uint32_t ddb_state;
 	uint32_t conn_err, err_code;
 	struct ddb_entry *ddb_entry;
+	uint32_t new_tgt;
 
 	dev_info(&ha->pdev->dev, "Initializing DDBs ...\n");
 	for (fw_ddb_index = 0; fw_ddb_index < MAX_DDB_ENTRIES;
@@ -526,8 +532,19 @@ static int qla4xxx_build_ddb_list(struct
 					      "completed "
 					      "or access denied failure\n",
 					      ha->host_no, __func__));
-			} else
+			} else {
 				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0);
+				if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index,
+					NULL, 0, NULL, &next_fw_ddb_index,
+					&ddb_state, &conn_err, NULL, NULL)
+					== QLA_ERROR) {
+					DEBUG2(printk("scsi%ld: %s:"
+						"get_ddb_entry %d failed\n",
+						ha->host_no,
+						__func__, fw_ddb_index));
+					return QLA_ERROR;
+				}
+			}
 		}
 
 		if (ddb_state != DDB_DS_SESSION_ACTIVE)
@@ -540,7 +557,7 @@ static int qla4xxx_build_ddb_list(struct
 			      ha->host_no, __func__, fw_ddb_index));
 
 		/* Add DDB to internal our ddb list. */
-		ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index);
+		ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index, &new_tgt);
 		if (ddb_entry == NULL) {
 			DEBUG2(printk("scsi%ld: %s: Unable to allocate memory "
 				      "for device at fw_ddb_index %d\n",
@@ -865,21 +882,19 @@ static int qla4xxx_config_nvram(struct s
 
 static void qla4x00_pci_config(struct scsi_qla_host *ha)
 {
-	uint16_t w, mwi;
+	uint16_t w;
 
 	dev_info(&ha->pdev->dev, "Configuring PCI space...\n");
 
 	pci_set_master(ha->pdev);
-	mwi = 0;
-	if (pci_set_mwi(ha->pdev))
-		mwi = PCI_COMMAND_INVALIDATE;
+	pci_set_mwi(ha->pdev);
 	/*
 	 * We want to respect framework's setting of PCI configuration space
 	 * command register and also want to make sure that all bits of
 	 * interest to us are properly set in command register.
 	 */
 	pci_read_config_word(ha->pdev, PCI_COMMAND, &w);
-	w |= mwi | (PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
+	w |= PCI_COMMAND_PARITY | PCI_COMMAND_SERR;
 	w &= ~PCI_COMMAND_INTX_DISABLE;
 	pci_write_config_word(ha->pdev, PCI_COMMAND, w);
 }
@@ -911,6 +926,9 @@ static int qla4xxx_start_firmware_from_f
 		writel(set_rmask(NVR_WRITE_ENABLE),
 		       &ha->reg->u1.isp4022.nvram);
 
+        writel(2, &ha->reg->mailbox[6]);
+        readl(&ha->reg->mailbox[6]);
+
 	writel(set_rmask(CSR_BOOT_ENABLE), &ha->reg->ctrl_status);
 	readl(&ha->reg->ctrl_status);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -958,25 +976,25 @@ static int qla4xxx_start_firmware_from_f
 	return status;
 }
 
-int ql4xxx_lock_drvr_wait(struct scsi_qla_host *ha)
+int ql4xxx_lock_drvr_wait(struct scsi_qla_host *a)
 {
-#define QL4_LOCK_DRVR_WAIT	30
+#define QL4_LOCK_DRVR_WAIT	60
 #define QL4_LOCK_DRVR_SLEEP	1
 
 	int drvr_wait = QL4_LOCK_DRVR_WAIT;
 	while (drvr_wait) {
-		if (ql4xxx_lock_drvr(ha) == 0) {
+		if (ql4xxx_lock_drvr(a) == 0) {
 			ssleep(QL4_LOCK_DRVR_SLEEP);
 			if (drvr_wait) {
 				DEBUG2(printk("scsi%ld: %s: Waiting for "
-					      "Global Init Semaphore(%d)...n",
-					      ha->host_no,
+					      "Global Init Semaphore(%d)...\n",
+					      a->host_no,
 					      __func__, drvr_wait));
 			}
 			drvr_wait -= QL4_LOCK_DRVR_SLEEP;
 		} else {
 			DEBUG2(printk("scsi%ld: %s: Global Init Semaphore "
-				      "acquired.n", ha->host_no, __func__));
+				      "acquired\n", a->host_no, __func__));
 			return QLA_SUCCESS;
 		}
 	}
@@ -1142,8 +1160,10 @@ int qla4xxx_initialize_adapter(struct sc
 	 * the ddb_list and wait for DHCP lease acquired aen to come in
 	 * followed by 0x8014 aen" to trigger the tgt discovery process.
 	 */
-	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS)
+	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS){
+		set_bit(AF_ONLINE, &ha->flags);
 		return status;
+	}
 
 	/* Skip device discovery if ip and subnet is zero */
 	if (memcmp(ha->ip_address, ip_address, IP_ADDR_LEN) == 0 ||
@@ -1177,6 +1197,7 @@ int qla4xxx_initialize_adapter(struct sc
 			      ha->host_no));
 	}
 
+	set_bit(AF_ONLINE, &ha->flags);
  exit_init_hba:
 	return status;
 
@@ -1193,9 +1214,10 @@ static void qla4xxx_add_device_dynamical
 					   uint32_t fw_ddb_index)
 {
 	struct ddb_entry * ddb_entry;
+	uint32_t new_tgt;
 
 	/* First allocate a device structure */
-	ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index);
+	ddb_entry = qla4xxx_get_ddb_entry(ha, fw_ddb_index, &new_tgt);
 	if (ddb_entry == NULL) {
 		DEBUG2(printk(KERN_WARNING
 			      "scsi%ld: Unable to allocate memory to add "
@@ -1203,6 +1225,18 @@ static void qla4xxx_add_device_dynamical
 		return;
 	}
 
+	if (!new_tgt && (ddb_entry->fw_ddb_index != fw_ddb_index)) {
+		/* Target has been bound to a new fw_ddb_index */
+		qla4xxx_free_ddb(ha, ddb_entry);
+		ddb_entry = qla4xxx_alloc_ddb(ha, fw_ddb_index);
+		if (ddb_entry == NULL) {
+			DEBUG2(printk(KERN_WARNING
+		      		"scsi%ld: Unable to allocate memory"
+		      		" to add fw_ddb_index %d\n",
+				ha->host_no, fw_ddb_index));
+			return;
+		}
+	}
 	if (qla4xxx_update_ddb_entry(ha, ddb_entry, fw_ddb_index) ==
 				    QLA_ERROR) {
 		ha->fw_ddb_index_map[fw_ddb_index] =
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index a216a17..6e3c8c8 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -6,6 +6,10 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
+
 
 #include <scsi/scsi_tcq.h>
 
@@ -243,8 +247,8 @@ int qla4xxx_send_command_to_isp(struct s
 		dma_addr_t	req_dma;
 
 		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
-					 cmd->request_bufflen,
-					 cmd->sc_data_direction);
+				 cmd->request_bufflen,
+				 cmd->sc_data_direction);
 		if (dma_mapping_error(req_dma))
 			goto queuing_error;
 
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 35b9e36..946e22b 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 /**
  * qla2x00_process_completed_request() - Process a Fast Post response.
@@ -417,6 +420,7 @@ static void qla4xxx_isr_decode_mailbox(s
 				       uint32_t mbox_status)
 {
 	int i;
+	uint32_t mbox_stat2, mbox_stat3;
 
 	if ((mbox_status == MBOX_STS_BUSY) ||
 	    (mbox_status == MBOX_STS_INTERMEDIATE_COMPLETION) ||
@@ -437,6 +441,12 @@ static void qla4xxx_isr_decode_mailbox(s
 	} else if (mbox_status >> 12 == MBOX_ASYNC_EVENT_STATUS) {
 		/* Immediately process the AENs that don't require much work.
 		 * Only queue the database_changed AENs */
+		if (ha->aen_log.count < MAX_AEN_ENTRIES) {
+			for (i = 0; i < MBOX_AEN_REG_COUNT; i++)
+				ha->aen_log.entry[ha->aen_log.count].mbox_sts[i] =
+					readl(&ha->reg->mailbox[i]);
+			ha->aen_log.count++;
+		}
 		switch (mbox_status) {
 		case MBOX_ASTS_SYSTEM_ERROR:
 			/* Log Mailbox registers */
@@ -493,6 +503,16 @@ static void qla4xxx_isr_decode_mailbox(s
 				      mbox_status));
 			break;
 
+		case MBOX_ASTS_IP_ADDR_STATE_CHANGED:
+			mbox_stat2 = readl(&ha->reg->mailbox[2]);
+			mbox_stat3 = readl(&ha->reg->mailbox[3]);
+
+			if ((mbox_stat3 == 5) && (mbox_stat2 == 3))
+				set_bit(DPC_GET_DHCP_IP_ADDR, &ha->dpc_flags);
+			else if ((mbox_stat3 == 2) && (mbox_stat2 == 5))
+				set_bit(DPC_RESET_HA, &ha->dpc_flags);
+			break;
+
 		case MBOX_ASTS_MAC_ADDRESS_CHANGED:
 		case MBOX_ASTS_DNS:
 			/* No action */
@@ -518,11 +538,6 @@ static void qla4xxx_isr_decode_mailbox(s
 			/* Queue AEN information and process it in the DPC
 			 * routine */
 			if (ha->aen_q_count > 0) {
-				/* advance pointer */
-				if (ha->aen_in == (MAX_AEN_ENTRIES - 1))
-					ha->aen_in = 0;
-				else
-					ha->aen_in++;
 
 				/* decrement available counter */
 				ha->aen_q_count--;
@@ -542,6 +557,10 @@ static void qla4xxx_isr_decode_mailbox(s
 					      ha->aen_q[ha->aen_in].mbox_sts[2],
 					      ha->aen_q[ha->aen_in].mbox_sts[3],
 					      ha->aen_q[ha->aen_in].  mbox_sts[4]));
+				/* advance pointer */
+				ha->aen_in++;
+				if (ha->aen_in == MAX_AEN_ENTRIES)
+					ha->aen_in = 0;
 
 				/* The DPC routine will process the aen */
 				set_bit(DPC_AEN, &ha->dpc_flags);
@@ -724,25 +743,24 @@ void qla4xxx_process_aen(struct scsi_qla
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	while (ha->aen_out != ha->aen_in) {
-		/* Advance pointers for next entry */
-		if (ha->aen_out == (MAX_AEN_ENTRIES - 1))
-			ha->aen_out = 0;
-		else
-			ha->aen_out++;
-
-		ha->aen_q_count++;
 		aen = &ha->aen_q[ha->aen_out];
-
 		/* copy aen information to local structure */
 		for (i = 0; i < MBOX_AEN_REG_COUNT; i++)
 			mbox_sts[i] = aen->mbox_sts[i];
 
+		ha->aen_q_count++;
+		ha->aen_out++;
+
+		if (ha->aen_out == MAX_AEN_ENTRIES)
+			ha->aen_out = 0;
+
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		DEBUG(printk("scsi%ld: AEN[%d] %04x, index [%d] state=%04x "
-			     "mod=%x conerr=%08x \n", ha->host_no, ha->aen_out,
-			     mbox_sts[0], mbox_sts[2], mbox_sts[3],
-			     mbox_sts[1], mbox_sts[4]));
+		DEBUG2(printk("qla4xxx(%ld): AEN[%d]=0x%08x, mbx1=0x%08x mbx2=0x%08x"
+			" mbx3=0x%08x mbx4=0x%08x\n", ha->host_no,
+			(ha->aen_out ? (ha->aen_out-1): (MAX_AEN_ENTRIES-1)),
+			mbox_sts[0], mbox_sts[1], mbox_sts[2],
+			mbox_sts[3], mbox_sts[4]));
 
 		switch (mbox_sts[0]) {
 		case MBOX_ASTS_DATABASE_CHANGED:
@@ -792,6 +810,5 @@ void qla4xxx_process_aen(struct scsi_qla
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index f116ff9..b881d73 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 
 /**
@@ -20,7 +23,7 @@ #include "ql4_def.h"
  * If outCount is 0, this routine completes successfully WITHOUT waiting
  * for the mailbox command to complete.
  **/
-static int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
+int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 				   uint8_t outCount, uint32_t *mbx_cmd,
 				   uint32_t *mbx_sts)
 {
@@ -169,84 +172,6 @@ mbox_exit:
 	return status;
 }
 
-
-#if 0
-
-/**
- * qla4xxx_issue_iocb - issue mailbox iocb command
- * @ha: adapter state pointer.
- * @buffer: buffer pointer.
- * @phys_addr: physical address of buffer.
- * @size: size of buffer.
- *
- * Issues iocbs via mailbox commands.
- * TARGET_QUEUE_LOCK must be released.
- * ADAPTER_STATE_LOCK must be released.
- **/
-int
-qla4xxx_issue_iocb(struct scsi_qla_host * ha, void *buffer,
-		   dma_addr_t phys_addr, size_t size)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-	int status;
-
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_EXECUTE_IOCB_A64;
-	mbox_cmd[1] = 0;
-	mbox_cmd[2] = LSDW(phys_addr);
-	mbox_cmd[3] = MSDW(phys_addr);
-	status = qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]);
-	return status;
-}
-
-int qla4xxx_conn_close_sess_logout(struct scsi_qla_host * ha,
-				   uint16_t fw_ddb_index,
-				   uint16_t connection_id,
-				   uint16_t option)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_CONN_CLOSE_SESS_LOGOUT;
-	mbox_cmd[1] = fw_ddb_index;
-	mbox_cmd[2] = connection_id;
-	mbox_cmd[3] = LOGOUT_OPTION_RELOGIN;
-	if (qla4xxx_mailbox_command(ha, 4, 2, &mbox_cmd[0], &mbox_sts[0]) !=
-	    QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_CONN_CLOSE_SESS_LOGOUT "
-			      "option %04x failed sts %04X %04X",
-			      ha->host_no, __func__,
-			      option, mbox_sts[0], mbox_sts[1]));
-		if (mbox_sts[0] == 0x4005)
-			DEBUG2(printk("%s reason %04X\n", __func__,
-				      mbox_sts[1]));
-	}
-	return QLA_SUCCESS;
-}
-
-int qla4xxx_clear_database_entry(struct scsi_qla_host * ha,
-				 uint16_t fw_ddb_index)
-{
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_CLEAR_DATABASE_ENTRY;
-	mbox_cmd[1] = fw_ddb_index;
-	if (qla4xxx_mailbox_command(ha, 2, 5, &mbox_cmd[0], &mbox_sts[0]) !=
-	    QLA_SUCCESS)
-		return QLA_ERROR;
-
-	return QLA_SUCCESS;
-}
-
-#endif  /*  0  */
-
 /**
  * qla4xxx_initialize_fw_cb - initializes firmware control block.
  * @ha: Pointer to host adapter structure.
@@ -272,10 +197,13 @@ int qla4xxx_initialize_fw_cb(struct scsi
 	/* Get Initialize Firmware Control Block. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK;
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
 	mbox_cmd[3] = MSDW(init_fw_cb_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) !=
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		dma_free_coherent(&ha->pdev->dev,
 				  sizeof(struct init_fw_ctrl_blk),
@@ -287,51 +215,56 @@ int qla4xxx_initialize_fw_cb(struct scsi
 	qla4xxx_init_rings(ha);
 
 	/* Fill in the request and response queue information. */
-	init_fw_cb->ReqQConsumerIndex = cpu_to_le16(ha->request_out);
-	init_fw_cb->ComplQProducerIndex = cpu_to_le16(ha->response_in);
-	init_fw_cb->ReqQLen = __constant_cpu_to_le16(REQUEST_QUEUE_DEPTH);
-	init_fw_cb->ComplQLen = __constant_cpu_to_le16(RESPONSE_QUEUE_DEPTH);
-	init_fw_cb->ReqQAddrLo = cpu_to_le32(LSDW(ha->request_dma));
-	init_fw_cb->ReqQAddrHi = cpu_to_le32(MSDW(ha->request_dma));
-	init_fw_cb->ComplQAddrLo = cpu_to_le32(LSDW(ha->response_dma));
-	init_fw_cb->ComplQAddrHi = cpu_to_le32(MSDW(ha->response_dma));
-	init_fw_cb->ShadowRegBufAddrLo =
+	init_fw_cb->pri.rqq_consumer_idx = cpu_to_le16(ha->request_out);
+	init_fw_cb->pri.compq_producer_idx = cpu_to_le16(ha->response_in);
+	init_fw_cb->pri.rqq_len = __constant_cpu_to_le16(REQUEST_QUEUE_DEPTH);
+	init_fw_cb->pri.compq_len = __constant_cpu_to_le16(RESPONSE_QUEUE_DEPTH);
+	init_fw_cb->pri.rqq_addr_lo = cpu_to_le32(LSDW(ha->request_dma));
+	init_fw_cb->pri.rqq_addr_hi = cpu_to_le32(MSDW(ha->request_dma));
+	init_fw_cb->pri.compq_addr_lo = cpu_to_le32(LSDW(ha->response_dma));
+	init_fw_cb->pri.compq_addr_hi = cpu_to_le32(MSDW(ha->response_dma));
+	init_fw_cb->pri.shdwreg_addr_lo =
 		cpu_to_le32(LSDW(ha->shadow_regs_dma));
-	init_fw_cb->ShadowRegBufAddrHi =
+	init_fw_cb->pri.shdwreg_addr_hi =
 		cpu_to_le32(MSDW(ha->shadow_regs_dma));
 
 	/* Set up required options. */
-	init_fw_cb->FwOptions |=
+	init_fw_cb->pri.fw_options |=
 		__constant_cpu_to_le16(FWOPT_SESSION_MODE |
 				       FWOPT_INITIATOR_MODE);
-	init_fw_cb->FwOptions &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
+	init_fw_cb->pri.fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
 
 	/* Save some info in adapter structure. */
-	ha->firmware_options = le16_to_cpu(init_fw_cb->FwOptions);
-	ha->tcp_options = le16_to_cpu(init_fw_cb->TCPOptions);
-	ha->heartbeat_interval = init_fw_cb->HeartbeatInterval;
-	memcpy(ha->ip_address, init_fw_cb->IPAddr,
-	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->IPAddr)));
-	memcpy(ha->subnet_mask, init_fw_cb->SubnetMask,
-	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->SubnetMask)));
-	memcpy(ha->gateway, init_fw_cb->GatewayIPAddr,
-	       min(sizeof(ha->gateway), sizeof(init_fw_cb->GatewayIPAddr)));
-	memcpy(ha->name_string, init_fw_cb->iSCSINameString,
+	ha->firmware_options = le16_to_cpu(init_fw_cb->pri.fw_options);
+	ha->tcp_options = le16_to_cpu(init_fw_cb->pri.ipv4_tcp_opts);
+	ha->heartbeat_interval = init_fw_cb->pri.hb_interval;
+	memcpy(ha->ip_address, init_fw_cb->pri.ipv4_addr,
+	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->pri.ipv4_addr)));
+	memcpy(ha->subnet_mask, init_fw_cb->pri.ipv4_subnet,
+	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->pri.ipv4_subnet)));
+	memcpy(ha->gateway, init_fw_cb->pri.ipv4_gw_addr,
+	       min(sizeof(ha->gateway), sizeof(init_fw_cb->pri.ipv4_gw_addr)));
+	memcpy(ha->name_string, init_fw_cb->pri.iscsi_name,
 	       min(sizeof(ha->name_string),
-		   sizeof(init_fw_cb->iSCSINameString)));
-	memcpy(ha->alias, init_fw_cb->Alias,
-	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));
+		   sizeof(init_fw_cb->pri.iscsi_name)));
+	/*memcpy(ha->alias, init_fw_cb->Alias,
+	       min(sizeof(ha->alias), sizeof(init_fw_cb->Alias)));*/
 
 	/* Save Command Line Paramater info */
-	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->KeepAliveTimeout);
+	ha->port_down_retry_count = le16_to_cpu(init_fw_cb->pri.conn_ka_timeout);
 	ha->discovery_wait = ql4xdiscoverywait;
 
 	/* Send Initialize Firmware Control Block. */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_INITIALIZE_FIRMWARE;
 	mbox_cmd[1] = 0;
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
 	mbox_cmd[3] = MSDW(init_fw_cb_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) ==
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) ==
 	    QLA_SUCCESS)
 		status = QLA_SUCCESS;
 	 else {
@@ -368,12 +301,14 @@ int qla4xxx_get_dhcp_ip_address(struct s
 	/* Get Initialize Firmware Control Block. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	memset(init_fw_cb, 0, sizeof(struct init_fw_ctrl_blk));
 	mbox_cmd[0] = MBOX_CMD_GET_INIT_FW_CTRL_BLOCK;
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
 	mbox_cmd[3] = MSDW(init_fw_cb_dma);
+	mbox_cmd[4] = sizeof(struct init_fw_ctrl_blk);
 
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) !=
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: Failed to get init_fw_ctrl_blk\n",
 			      ha->host_no, __func__));
@@ -384,12 +319,12 @@ int qla4xxx_get_dhcp_ip_address(struct s
 	}
 
 	/* Save IP Address. */
-	memcpy(ha->ip_address, init_fw_cb->IPAddr,
-	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->IPAddr)));
-	memcpy(ha->subnet_mask, init_fw_cb->SubnetMask,
-	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->SubnetMask)));
-	memcpy(ha->gateway, init_fw_cb->GatewayIPAddr,
-	       min(sizeof(ha->gateway), sizeof(init_fw_cb->GatewayIPAddr)));
+	memcpy(ha->ip_address, init_fw_cb->pri.ipv4_addr,
+	       min(sizeof(ha->ip_address), sizeof(init_fw_cb->pri.ipv4_addr)));
+	memcpy(ha->subnet_mask, init_fw_cb->pri.ipv4_subnet,
+	       min(sizeof(ha->subnet_mask), sizeof(init_fw_cb->pri.ipv4_subnet)));
+	memcpy(ha->gateway, init_fw_cb->pri.ipv4_gw_addr,
+	       min(sizeof(ha->gateway), sizeof(init_fw_cb->pri.ipv4_gw_addr)));
 
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct init_fw_ctrl_blk),
 			  init_fw_cb, init_fw_cb_dma);
@@ -409,8 +344,10 @@ int qla4xxx_get_firmware_state(struct sc
 	/* Get firmware version */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_FW_STATE;
-	if (qla4xxx_mailbox_command(ha, 1, 4, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 4, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_FW_STATE failed w/ "
 			      "status %04X\n", ha->host_no, __func__,
@@ -438,8 +375,10 @@ int qla4xxx_get_firmware_status(struct s
 	/* Get firmware version */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_FW_STATUS;
-	if (qla4xxx_mailbox_command(ha, 1, 3, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 3, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_FW_STATUS failed w/ "
 			      "status %04X\n", ha->host_no, __func__,
@@ -491,11 +430,14 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 	}
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_GET_DATABASE_ENTRY;
 	mbox_cmd[1] = (uint32_t) fw_ddb_index;
 	mbox_cmd[2] = LSDW(fw_ddb_entry_dma);
 	mbox_cmd[3] = MSDW(fw_ddb_entry_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 7, &mbox_cmd[0], &mbox_sts[0]) ==
+	mbox_cmd[4] = sizeof(struct dev_db_entry);
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 7, &mbox_cmd[0], &mbox_sts[0]) ==
 	    QLA_ERROR) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_GET_DATABASE_ENTRY failed"
 			      " with status 0x%04X\n", ha->host_no, __func__,
@@ -512,11 +454,11 @@ int qla4xxx_get_fwddb_entry(struct scsi_
 		dev_info(&ha->pdev->dev, "DDB[%d] MB0 %04x Tot %d Next %d "
 			   "State %04x ConnErr %08x %d.%d.%d.%d:%04d \"%s\"\n",
 			   fw_ddb_index, mbox_sts[0], mbox_sts[2], mbox_sts[3],
-			   mbox_sts[4], mbox_sts[5], fw_ddb_entry->ipAddr[0],
-			   fw_ddb_entry->ipAddr[1], fw_ddb_entry->ipAddr[2],
-			   fw_ddb_entry->ipAddr[3],
-			   le16_to_cpu(fw_ddb_entry->portNumber),
-			   fw_ddb_entry->iscsiName);
+			   mbox_sts[4], mbox_sts[5], fw_ddb_entry->ip_addr[0],
+			   fw_ddb_entry->ip_addr[1], fw_ddb_entry->ip_addr[2],
+			   fw_ddb_entry->ip_addr[3],
+			   le16_to_cpu(fw_ddb_entry->port),
+			   fw_ddb_entry->iscsi_name);
 	}
 	if (num_valid_ddb_entries)
 		*num_valid_ddb_entries = mbox_sts[2];
@@ -571,35 +513,10 @@ int qla4xxx_set_ddb_entry(struct scsi_ql
 	mbox_cmd[1] = (uint32_t) fw_ddb_index;
 	mbox_cmd[2] = LSDW(fw_ddb_entry_dma);
 	mbox_cmd[3] = MSDW(fw_ddb_entry_dma);
-	return qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]);
-}
+	mbox_cmd[4] = sizeof(struct dev_db_entry);
 
-#if 0
-int qla4xxx_conn_open_session_login(struct scsi_qla_host * ha,
-				    uint16_t fw_ddb_index)
-{
-	int status = QLA_ERROR;
-	uint32_t mbox_cmd[MBOX_REG_COUNT];
-	uint32_t mbox_sts[MBOX_REG_COUNT];
-
-	/* Do not wait for completion. The firmware will send us an
-	 * ASTS_DATABASE_CHANGED (0x8014) to notify us of the login status.
-	 */
-	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
-	memset(&mbox_sts, 0, sizeof(mbox_sts));
-	mbox_cmd[0] = MBOX_CMD_CONN_OPEN_SESS_LOGIN;
-	mbox_cmd[1] = (uint32_t) fw_ddb_index;
-	mbox_cmd[2] = 0;
-	mbox_cmd[3] = 0;
-	mbox_cmd[4] = 0;
-	status = qla4xxx_mailbox_command(ha, 4, 0, &mbox_cmd[0], &mbox_sts[0]);
-	DEBUG2(printk("%s fw_ddb_index=%d status=%d mbx0_1=0x%x :0x%x\n",
-		      __func__, fw_ddb_index, status, mbox_sts[0],
-		      mbox_sts[1]);)
-
-		return status;
+	return qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
 }
-#endif  /*  0  */
 
 /**
  * qla4xxx_get_crash_record - retrieves crash record.
@@ -614,12 +531,14 @@ void qla4xxx_get_crash_record(struct scs
 	struct crash_record *crash_record = NULL;
 	dma_addr_t crash_record_dma = 0;
 	uint32_t crash_record_size = 0;
+
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_cmd));
 
 	/* Get size of crash record. */
 	mbox_cmd[0] = MBOX_CMD_GET_CRASH_RECORD;
-	if (qla4xxx_mailbox_command(ha, 5, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: ERROR: Unable to retrieve size!\n",
 			      ha->host_no, __func__));
@@ -639,11 +558,15 @@ void qla4xxx_get_crash_record(struct scs
 		goto exit_get_crash_record;
 
 	/* Get Crash Record. */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_cmd));
+
 	mbox_cmd[0] = MBOX_CMD_GET_CRASH_RECORD;
 	mbox_cmd[2] = LSDW(crash_record_dma);
 	mbox_cmd[3] = MSDW(crash_record_dma);
 	mbox_cmd[4] = crash_record_size;
-	if (qla4xxx_mailbox_command(ha, 5, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS)
 		goto exit_get_crash_record;
 
@@ -655,7 +578,6 @@ exit_get_crash_record:
 				  crash_record, crash_record_dma);
 }
 
-#if 0
 /**
  * qla4xxx_get_conn_event_log - retrieves connection event log
  * @ha: Pointer to host adapter structure.
@@ -678,7 +600,8 @@ void qla4xxx_get_conn_event_log(struct s
 
 	/* Get size of crash record. */
 	mbox_cmd[0] = MBOX_CMD_GET_CONN_EVENT_LOG;
-	if (qla4xxx_mailbox_command(ha, 4, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS)
 		goto exit_get_event_log;
 
@@ -693,10 +616,14 @@ void qla4xxx_get_conn_event_log(struct s
 		goto exit_get_event_log;
 
 	/* Get Crash Record. */
+	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
+	memset(&mbox_sts, 0, sizeof(mbox_cmd));
+
 	mbox_cmd[0] = MBOX_CMD_GET_CONN_EVENT_LOG;
 	mbox_cmd[2] = LSDW(event_log_dma);
 	mbox_cmd[3] = MSDW(event_log_dma);
-	if (qla4xxx_mailbox_command(ha, 4, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: ERROR: Unable to retrieve event "
 			      "log!\n", ha->host_no, __func__));
@@ -745,7 +672,6 @@ exit_get_event_log:
 		dma_free_coherent(&ha->pdev->dev, event_log_size, event_log,
 				  event_log_dma);
 }
-#endif  /*  0  */
 
 /**
  * qla4xxx_reset_lun - issues LUN Reset
@@ -773,11 +699,13 @@ int qla4xxx_reset_lun(struct scsi_qla_ho
 	 */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_LUN_RESET;
 	mbox_cmd[1] = ddb_entry->fw_ddb_index;
 	mbox_cmd[2] = lun << 8;
 	mbox_cmd[5] = 0x01;	/* Immediate Command Enable */
-	qla4xxx_mailbox_command(ha, 6, 1, &mbox_cmd[0], &mbox_sts[0]);
+
+	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
 	if (mbox_sts[0] != MBOX_STS_COMMAND_COMPLETE &&
 	    mbox_sts[0] != MBOX_STS_COMMAND_ERROR)
 		status = QLA_ERROR;
@@ -794,12 +722,14 @@ int qla4xxx_get_flash(struct scsi_qla_ho
 
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_READ_FLASH;
 	mbox_cmd[1] = LSDW(dma_addr);
 	mbox_cmd[2] = MSDW(dma_addr);
 	mbox_cmd[3] = offset;
 	mbox_cmd[4] = len;
-	if (qla4xxx_mailbox_command(ha, 5, 2, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 2, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_READ_FLASH, failed w/ "
 		    "status %04X %04X, offset %08x, len %08x\n", ha->host_no,
@@ -825,8 +755,10 @@ int qla4xxx_get_fw_version(struct scsi_q
 	/* Get firmware version. */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+
 	mbox_cmd[0] = MBOX_CMD_ABOUT_FW;
-	if (qla4xxx_mailbox_command(ha, 4, 5, &mbox_cmd[0], &mbox_sts[0]) !=
+
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 5, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: MBOX_CMD_ABOUT_FW failed w/ "
 		    "status %04X\n", ha->host_no, __func__, mbox_sts[0]));
@@ -855,7 +787,7 @@ static int qla4xxx_get_default_ddb(struc
 	mbox_cmd[2] = LSDW(dma_addr);
 	mbox_cmd[3] = MSDW(dma_addr);
 
-	if (qla4xxx_mailbox_command(ha, 4, 1, &mbox_cmd[0], &mbox_sts[0]) !=
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		DEBUG2(printk("scsi%ld: %s: failed status %04X\n",
 		     ha->host_no, __func__, mbox_sts[0]));
@@ -875,7 +807,7 @@ static int qla4xxx_req_ddb_entry(struct 
 	mbox_cmd[0] = MBOX_CMD_REQUEST_DATABASE_ENTRY;
 	mbox_cmd[1] = MAX_PRST_DEV_DB_ENTRIES;
 
-	if (qla4xxx_mailbox_command(ha, 2, 3, &mbox_cmd[0], &mbox_sts[0]) !=
+	if (qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 3, &mbox_cmd[0], &mbox_sts[0]) !=
 	    QLA_SUCCESS) {
 		if (mbox_sts[0] == MBOX_STS_COMMAND_ERROR) {
 			*ddb_index = mbox_sts[2];
@@ -918,23 +850,23 @@ int qla4xxx_send_tgts(struct scsi_qla_ho
 	if (ret_val != QLA_SUCCESS)
 		goto qla4xxx_send_tgts_exit;
 
-	memset((void *)fw_ddb_entry->iSCSIAlias, 0,
-	       sizeof(fw_ddb_entry->iSCSIAlias));
+	memset(fw_ddb_entry->iscsi_alias, 0,
+	       sizeof(fw_ddb_entry->iscsi_alias));
 
-	memset((void *)fw_ddb_entry->iscsiName, 0,
-	       sizeof(fw_ddb_entry->iscsiName));
+	memset(fw_ddb_entry->iscsi_name, 0,
+	       sizeof(fw_ddb_entry->iscsi_name));
 
-	memset((void *)fw_ddb_entry->ipAddr, 0, sizeof(fw_ddb_entry->ipAddr));
-	memset((void *)fw_ddb_entry->targetAddr, 0,
-	       sizeof(fw_ddb_entry->targetAddr));
+	memset(fw_ddb_entry->ip_addr, 0, sizeof(fw_ddb_entry->ip_addr));
+	memset(fw_ddb_entry->tgt_addr, 0,
+	       sizeof(fw_ddb_entry->tgt_addr));
 
 	fw_ddb_entry->options = (DDB_OPT_DISC_SESSION | DDB_OPT_TARGET);
-	fw_ddb_entry->portNumber = cpu_to_le16(ntohs(port));
+	fw_ddb_entry->port = cpu_to_le16(ntohs(port));
 
-	fw_ddb_entry->ipAddr[0] = *ip;
-	fw_ddb_entry->ipAddr[1] = *(ip + 1);
-	fw_ddb_entry->ipAddr[2] = *(ip + 2);
-	fw_ddb_entry->ipAddr[3] = *(ip + 3);
+	fw_ddb_entry->ip_addr[0] = *ip;
+	fw_ddb_entry->ip_addr[1] = *(ip + 1);
+	fw_ddb_entry->ip_addr[2] = *(ip + 2);
+	fw_ddb_entry->ip_addr[3] = *(ip + 3);
 
 	ret_val = qla4xxx_set_ddb_entry(ha, ddb_index, fw_ddb_entry_dma);
 
diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index 58afd13..7fe0482 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -6,6 +6,9 @@
  */
 
 #include "ql4_def.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 static inline void eeprom_cmd(uint32_t cmd, struct scsi_qla_host *ha)
 {
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index da21f5f..c9ffbe5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -10,6 +10,10 @@ #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 
 #include "ql4_def.h"
+#include "ql4_version.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 /*
  * Driver version
@@ -282,6 +286,7 @@ int qla4xxx_add_sess(struct ddb_entry *d
 	}
 
 	ddb_entry->sess->recovery_tmo = ddb_entry->ha->port_down_retry_count;
+
 	iscsi_if_create_session_done(ddb_entry->conn);
 	return 0;
 }
@@ -387,7 +392,6 @@ void qla4xxx_srb_compl(struct scsi_qla_h
 	struct scsi_cmnd *cmd = srb->cmd;
 
 	qla4xxx_srb_free_dma(ha, srb);
-
 	mempool_free(srb, ha->srb_mempool);
 
 	cmd->scsi_done(cmd);
@@ -711,7 +715,7 @@ static int qla4xxx_cmd_wait(struct scsi_
 	return stat;
 }
 
-static void qla4xxx_hw_reset(struct scsi_qla_host *ha)
+void qla4xxx_hw_reset(struct scsi_qla_host *ha)
 {
 	uint32_t ctrl_status;
 	unsigned long flags = 0;
@@ -1081,13 +1085,13 @@ static void qla4xxx_free_adapter(struct 
 	if (ha->timer_active)
 		qla4xxx_stop_timer(ha);
 
-	/* free extra memory */
-	qla4xxx_mem_free(ha);
-
 	/* Detach interrupts */
 	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
 		free_irq(ha->pdev->irq, ha);
 
+	/* free extra memory */
+	qla4xxx_mem_free(ha);
+
 	pci_disable_device(ha->pdev);
 
 }
@@ -1196,6 +1200,9 @@ static int __devinit qla4xxx_probe_adapt
 	ha->host = host;
 	ha->host_no = host->host_no;
 
+	ha->ql4mbx = qla4xxx_mailbox_command;
+	ha->ql4cmd = qla4xxx_send_command_to_isp;
+
 	/* Configure PCI I/O space. */
 	ret = qla4xxx_iospace_config(ha);
 	if (ret)
@@ -1332,6 +1339,11 @@ static void __devexit qla4xxx_remove_ada
 
 	ha = pci_get_drvdata(pdev);
 
+	qla4xxx_disable_intrs(ha);
+
+	while (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
+		ssleep(1);
+
 	/* remove devs from iscsi_sessions to scsi_devices */
 	qla4xxx_free_ddb_list(ha);
 
diff --git a/drivers/scsi/qla4xxx/ql4_version.h b/drivers/scsi/qla4xxx/ql4_version.h
index e5183a6..2149069 100644
--- a/drivers/scsi/qla4xxx/ql4_version.h
+++ b/drivers/scsi/qla4xxx/ql4_version.h
@@ -5,4 +5,5 @@
  * See LICENSE.qla4xxx for copyright and licensing details.
  */
 
-#define QLA4XXX_DRIVER_VERSION	"5.00.07-k1"
+#define QLA4XXX_DRIVER_VERSION	"5.01.00-k7"
+
-- 
1.4.2.3


