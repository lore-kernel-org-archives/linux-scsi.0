From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PATCH] SCSI fixes for 2.6.32-rc7
Date: Tue, 17 Nov 2009 10:30:12 -0600
Message-ID: <1258475412.4113.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753067AbZKQQaT@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of miscellaneous (but small) fixes for SCSI.  The only
urgent one is the CVE, but the number of people having the hardware
(gdth population approaching zero) makes it less exploit worthy.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Anil Ravindranath (1):
      pmcraid: Fix ppc64 driver build for using cpu_to_le32 on U8 data type

Ben Hutchings (1):
      bfa: declare MODULE_FIRMWARE

Brian King (1):
      scsi_transport_fc: Fix WARN message for FC passthru failure paths

Dave Jones (1):
      gdth: Prevent negative offsets in ioctl CVE-2009-3080

Martin K. Petersen (1):
      Fix incorrect reporting of host protection capabilities

Roel Kluin (1):
      bfa: fix test in bfad_os_fc_host_init()

Wayne Boyer (1):
      ipr: add workaround for MSI interrupts on P7

jack wang (1):
      libsas: do not set res = 0 in sas_ex_discover_dev()

And the diffstat:

 drivers/scsi/bfa/bfad_fwimg.c      |    2 +
 drivers/scsi/bfa/bfad_im.c         |    2 -
 drivers/scsi/gdth.c                |    2 -
 drivers/scsi/ipr.c                 |   42 +++++++++++++++++++++++++++++--------
 drivers/scsi/ipr.h                 |    1 
 drivers/scsi/libsas/sas_expander.c |    1 
 drivers/scsi/pmcraid.c             |   10 ++++----
 drivers/scsi/scsi_transport_fc.c   |    3 ++
 include/scsi/scsi_host.h           |   29 +++++++++----------------
 9 files changed, 57 insertions(+), 35 deletions(-)

Full diffs below.

James

---

diff --git a/drivers/scsi/bfa/bfad_fwimg.c b/drivers/scsi/bfa/bfad_fwimg.c
index b2f6949..bd34b0d 100644
--- a/drivers/scsi/bfa/bfad_fwimg.c
+++ b/drivers/scsi/bfa/bfad_fwimg.c
@@ -41,6 +41,8 @@ u32 *bfi_image_cb;
 
 #define	BFAD_FW_FILE_CT	"ctfw.bin"
 #define	BFAD_FW_FILE_CB	"cbfw.bin"
+MODULE_FIRMWARE(BFAD_FW_FILE_CT);
+MODULE_FIRMWARE(BFAD_FW_FILE_CB);
 
 u32 *
 bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 158c992..55d012a 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -948,7 +948,7 @@ bfad_os_fc_host_init(struct bfad_im_port_s *im_port)
 	if (bfad_supported_fc4s & (BFA_PORT_ROLE_FCP_IM | BFA_PORT_ROLE_FCP_TM))
 		/* For FCP type 0x08 */
 		fc_host_supported_fc4s(host)[2] = 1;
-	if (bfad_supported_fc4s | BFA_PORT_ROLE_FCP_IPFC)
+	if (bfad_supported_fc4s & BFA_PORT_ROLE_FCP_IPFC)
 		/* For LLC/SNAP type 0x05 */
 		fc_host_supported_fc4s(host)[3] = 0x20;
 	/* For fibre channel services type 0x20 */
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 185e6bc..9e8fce0 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2900,7 +2900,7 @@ static int gdth_read_event(gdth_ha_str *ha, int handle, gdth_evt_str *estr)
         eindex = handle;
     estr->event_source = 0;
 
-    if (eindex >= MAX_EVENTS) {
+    if (eindex < 0 || eindex >= MAX_EVENTS) {
         spin_unlock_irqrestore(&ha->smp_lock, flags);
         return eindex;
     }
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5f04550..76d294f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4189,6 +4189,25 @@ static irqreturn_t ipr_handle_other_interrupt(struct ipr_ioa_cfg *ioa_cfg,
 }
 
 /**
+ * ipr_isr_eh - Interrupt service routine error handler
+ * @ioa_cfg:	ioa config struct
+ * @msg:	message to log
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_isr_eh(struct ipr_ioa_cfg *ioa_cfg, char *msg)
+{
+	ioa_cfg->errors_logged++;
+	dev_err(&ioa_cfg->pdev->dev, "%s\n", msg);
+
+	if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
+		ioa_cfg->sdt_state = GET_DUMP;
+
+	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+}
+
+/**
  * ipr_isr - Interrupt service routine
  * @irq:	irq number
  * @devp:	pointer to ioa config struct
@@ -4203,6 +4222,7 @@ static irqreturn_t ipr_isr(int irq, void *devp)
 	volatile u32 int_reg, int_mask_reg;
 	u32 ioasc;
 	u16 cmd_index;
+	int num_hrrq = 0;
 	struct ipr_cmnd *ipr_cmd;
 	irqreturn_t rc = IRQ_NONE;
 
@@ -4233,13 +4253,7 @@ static irqreturn_t ipr_isr(int irq, void *devp)
 				     IPR_HRRQ_REQ_RESP_HANDLE_MASK) >> IPR_HRRQ_REQ_RESP_HANDLE_SHIFT;
 
 			if (unlikely(cmd_index >= IPR_NUM_CMD_BLKS)) {
-				ioa_cfg->errors_logged++;
-				dev_err(&ioa_cfg->pdev->dev, "Invalid response handle from IOA\n");
-
-				if (WAIT_FOR_DUMP == ioa_cfg->sdt_state)
-					ioa_cfg->sdt_state = GET_DUMP;
-
-				ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+				ipr_isr_eh(ioa_cfg, "Invalid response handle from IOA");
 				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 				return IRQ_HANDLED;
 			}
@@ -4266,8 +4280,18 @@ static irqreturn_t ipr_isr(int irq, void *devp)
 
 		if (ipr_cmd != NULL) {
 			/* Clear the PCI interrupt */
-			writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg);
-			int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
+			do {
+				writel(IPR_PCII_HRRQ_UPDATED, ioa_cfg->regs.clr_interrupt_reg);
+				int_reg = readl(ioa_cfg->regs.sense_interrupt_reg) & ~int_mask_reg;
+			} while (int_reg & IPR_PCII_HRRQ_UPDATED &&
+					num_hrrq++ < IPR_MAX_HRRQ_RETRIES);
+
+			if (int_reg & IPR_PCII_HRRQ_UPDATED) {
+				ipr_isr_eh(ioa_cfg, "Error clearing HRRQ");
+				spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+				return IRQ_HANDLED;
+			}
+
 		} else
 			break;
 	}
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 163245a..19bbcf3 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -144,6 +144,7 @@
 #define IPR_IOA_MAX_SECTORS				32767
 #define IPR_VSET_MAX_SECTORS				512
 #define IPR_MAX_CDB_LEN					16
+#define IPR_MAX_HRRQ_RETRIES				3
 
 #define IPR_DEFAULT_BUS_WIDTH				16
 #define IPR_80MBs_SCSI_RATE		((80 * 10) / (IPR_DEFAULT_BUS_WIDTH / 8))
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b338195..33cf988 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -960,7 +960,6 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
 
 			}
 		}
-		res = 0;
 	}
 
 	return res;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index f7c70e2..0a97bc9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -1071,7 +1071,7 @@ static struct pmcraid_cmd *pmcraid_init_hcam
 
 	ioarcb->data_transfer_length = cpu_to_le32(rcb_size);
 
-	ioadl[0].flags |= cpu_to_le32(IOADL_FLAGS_READ_LAST);
+	ioadl[0].flags |= IOADL_FLAGS_READ_LAST;
 	ioadl[0].data_len = cpu_to_le32(rcb_size);
 	ioadl[0].address = cpu_to_le32(dma);
 
@@ -2251,7 +2251,7 @@ static void pmcraid_request_sense(struct pmcraid_cmd *cmd)
 
 	ioadl->address = cpu_to_le64(cmd->sense_buffer_dma);
 	ioadl->data_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
-	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl->flags = IOADL_FLAGS_LAST_DESC;
 
 	/* request sense might be called as part of error response processing
 	 * which runs in tasklets context. It is possible that mid-layer might
@@ -3017,7 +3017,7 @@ static int pmcraid_build_ioadl(
 		ioadl[i].flags = 0;
 	}
 	/* setup last descriptor */
-	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
 
 	return 0;
 }
@@ -3387,7 +3387,7 @@ static int pmcraid_build_passthrough_ioadls(
 	}
 
 	/* setup the last descriptor */
-	ioadl[i - 1].flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl[i - 1].flags = IOADL_FLAGS_LAST_DESC;
 
 	return 0;
 }
@@ -5314,7 +5314,7 @@ static void pmcraid_querycfg(struct pmcraid_cmd *cmd)
 		cpu_to_le32(sizeof(struct pmcraid_config_table));
 
 	ioadl = &(ioarcb->add_data.u.ioadl[0]);
-	ioadl->flags = cpu_to_le32(IOADL_FLAGS_LAST_DESC);
+	ioadl->flags = IOADL_FLAGS_LAST_DESC;
 	ioadl->address = cpu_to_le64(pinstance->cfg_table_bus_addr);
 	ioadl->data_len = cpu_to_le32(sizeof(struct pmcraid_config_table));
 
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index a67fed1..c6f70da 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3656,6 +3656,7 @@ fc_bsg_host_dispatch(struct request_queue *q, struct Scsi_Host *shost,
 fail_host_msg:
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->reply_payload_rcv_len = 0;
 	job->reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
 	fc_bsg_jobdone(job);
@@ -3741,6 +3742,7 @@ check_bidi:
 fail_rport_msg:
 	/* return the errno failure code as the only status */
 	BUG_ON(job->reply_len < sizeof(uint32_t));
+	job->reply->reply_payload_rcv_len = 0;
 	job->reply->result = ret;
 	job->reply_len = sizeof(uint32_t);
 	fc_bsg_jobdone(job);
@@ -3797,6 +3799,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 		/* check if we have the msgcode value at least */
 		if (job->request_len < sizeof(uint32_t)) {
 			BUG_ON(job->reply_len < sizeof(uint32_t));
+			job->reply->reply_payload_rcv_len = 0;
 			job->reply->result = -ENOMSG;
 			job->reply_len = sizeof(uint32_t);
 			fc_bsg_jobdone(job);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 6e728b1..47941fc 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -797,30 +797,23 @@ static inline unsigned int scsi_host_get_prot(struct Scsi_Host *shost)
 
 static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
-	switch (target_type) {
-	case 1:
-		if (shost->prot_capabilities & SHOST_DIF_TYPE1_PROTECTION)
-			return target_type;
-	case 2:
-		if (shost->prot_capabilities & SHOST_DIF_TYPE2_PROTECTION)
-			return target_type;
-	case 3:
-		if (shost->prot_capabilities & SHOST_DIF_TYPE3_PROTECTION)
-			return target_type;
-	}
+	static unsigned char cap[] = { 0,
+				       SHOST_DIF_TYPE1_PROTECTION,
+				       SHOST_DIF_TYPE2_PROTECTION,
+				       SHOST_DIF_TYPE3_PROTECTION };
 
-	return 0;
+	return shost->prot_capabilities & cap[target_type] ? target_type : 0;
 }
 
 static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
-	switch (target_type) {
-	case 0: return shost->prot_capabilities & SHOST_DIX_TYPE0_PROTECTION;
-	case 1: return shost->prot_capabilities & SHOST_DIX_TYPE1_PROTECTION;
-	case 2: return shost->prot_capabilities & SHOST_DIX_TYPE2_PROTECTION;
-	case 3: return shost->prot_capabilities & SHOST_DIX_TYPE3_PROTECTION;
-	}
+	static unsigned char cap[] = { SHOST_DIX_TYPE0_PROTECTION,
+				       SHOST_DIX_TYPE1_PROTECTION,
+				       SHOST_DIX_TYPE2_PROTECTION,
+				       SHOST_DIX_TYPE3_PROTECTION };
+
+	return shost->prot_capabilities & cap[target_type];
 #endif
 	return 0;
 }
