From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.19-rc2
Date: Wed, 05 Sep 2018 09:15:02 +0100
Message-ID: <1536135302.3106.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A set of very minor fixes and a couple of reverts to fix a major
problem (the attempt to change the busy count causes a hang when
attempting to change the drive cache type).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      scsi: aacraid: fix a signedness bug

Geert Uytterhoeven (2):
      scsi: libata: Add missing newline at end of file
      scsi: core: Update SCSI_MQ_DEFAULT help text to match default

James Smart (2):
      scsi: lpfc: Correct MDS diag and nvmet configuration
      scsi: lpfc: Default fdmi_on to on

John Pittman (1):
      scsi: documentation: add scsi_mod.use_blk_mq to scsi-parameters

Martin Wilck (1):
      scsi: hpsa: limit transfer length to 1MB, not 512kB

Ming Lei (2):
      Revert "scsi: core: avoid host-wide host_busy counter for scsi_mq"
      Revert "scsi: core: fix scsi_host_queue_ready"

Varun Prakash (3):
      scsi: target: iscsi: cxgbit: use pr_debug() instead of pr_info()
      scsi: csiostor: fix incorrect port capabilities
      scsi: csiostor: add a check for NULL pointer after kmalloc()

And the diffstat:

 Documentation/scsi/scsi-parameters.txt   |  5 +++
 drivers/ata/libata-core.c                |  2 +-
 drivers/scsi/Kconfig                     | 10 ++---
 drivers/scsi/aacraid/aacraid.h           |  2 +-
 drivers/scsi/csiostor/csio_hw.c          | 71 ++++++++++++++++++++++++--------
 drivers/scsi/csiostor/csio_hw.h          |  1 +
 drivers/scsi/csiostor/csio_mb.c          |  6 +--
 drivers/scsi/hosts.c                     | 24 +----------
 drivers/scsi/hpsa.c                      |  2 +-
 drivers/scsi/lpfc/lpfc.h                 |  2 +-
 drivers/scsi/lpfc/lpfc_attr.c            |  8 ++--
 drivers/scsi/scsi_lib.c                  | 21 +++-------
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c |  8 ++--
 13 files changed, 85 insertions(+), 77 deletions(-)

With full diff below.

James

---

diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/scsi/scsi-parameters.txt
index 25a4b4cf04a6..92999d4e0cb8 100644
--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -97,6 +97,11 @@ parameters may be changed at runtime by the command
 			allowing boot to proceed.  none ignores them, expecting
 			user space to do the scan.
 
+	scsi_mod.use_blk_mq=
+			[SCSI] use blk-mq I/O path by default
+			See SCSI_MQ_DEFAULT in drivers/scsi/Kconfig.
+			Format: <y/n>
+
 	sim710=		[SCSI,HW]
 			See header of drivers/scsi/sim710.c.
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 172e32840256..599e01bcdef2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7394,4 +7394,4 @@ EXPORT_SYMBOL_GPL(ata_cable_unknown);
 EXPORT_SYMBOL_GPL(ata_cable_ignore);
 EXPORT_SYMBOL_GPL(ata_cable_sata);
 EXPORT_SYMBOL_GPL(ata_host_get);
-EXPORT_SYMBOL_GPL(ata_host_put);
\ No newline at end of file
+EXPORT_SYMBOL_GPL(ata_host_put);
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 8fc851a9e116..7c097006c54d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -52,12 +52,12 @@ config SCSI_MQ_DEFAULT
 	default y
 	depends on SCSI
 	---help---
-	  This option enables the new blk-mq based I/O path for SCSI
-	  devices by default.  With the option the scsi_mod.use_blk_mq
-	  module/boot option defaults to Y, without it to N, but it can
-	  still be overridden either way.
+	  This option enables the blk-mq based I/O path for SCSI devices by
+	  default.  With this option the scsi_mod.use_blk_mq module/boot
+	  option defaults to Y, without it to N, but it can still be
+	  overridden either way.
 
-	  If unsure say N.
+	  If unsure say Y.
 
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 29bf1e60f542..39eb415987fc 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1346,7 +1346,7 @@ struct fib {
 struct aac_hba_map_info {
 	__le32	rmw_nexus;		/* nexus for native HBA devices */
 	u8		devtype;	/* device type */
-	u8		reset_state;	/* 0 - no reset, 1..x - */
+	s8		reset_state;	/* 0 - no reset, 1..x - */
 					/* after xth TM LUN reset */
 	u16		qd_limit;
 	u32		scan_counter;
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 23d07e9f87d0..e51923886475 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -1602,6 +1602,46 @@ fw_port_cap32_t fwcaps16_to_caps32(fw_port_cap16_t caps16)
 }
 
 /**
+ *	fwcaps32_to_caps16 - convert 32-bit Port Capabilities to 16-bits
+ *	@caps32: a 32-bit Port Capabilities value
+ *
+ *	Returns the equivalent 16-bit Port Capabilities value.  Note that
+ *	not all 32-bit Port Capabilities can be represented in the 16-bit
+ *	Port Capabilities and some fields/values may not make it.
+ */
+fw_port_cap16_t fwcaps32_to_caps16(fw_port_cap32_t caps32)
+{
+	fw_port_cap16_t caps16 = 0;
+
+	#define CAP32_TO_CAP16(__cap) \
+		do { \
+			if (caps32 & FW_PORT_CAP32_##__cap) \
+				caps16 |= FW_PORT_CAP_##__cap; \
+		} while (0)
+
+	CAP32_TO_CAP16(SPEED_100M);
+	CAP32_TO_CAP16(SPEED_1G);
+	CAP32_TO_CAP16(SPEED_10G);
+	CAP32_TO_CAP16(SPEED_25G);
+	CAP32_TO_CAP16(SPEED_40G);
+	CAP32_TO_CAP16(SPEED_100G);
+	CAP32_TO_CAP16(FC_RX);
+	CAP32_TO_CAP16(FC_TX);
+	CAP32_TO_CAP16(802_3_PAUSE);
+	CAP32_TO_CAP16(802_3_ASM_DIR);
+	CAP32_TO_CAP16(ANEG);
+	CAP32_TO_CAP16(FORCE_PAUSE);
+	CAP32_TO_CAP16(MDIAUTO);
+	CAP32_TO_CAP16(MDISTRAIGHT);
+	CAP32_TO_CAP16(FEC_RS);
+	CAP32_TO_CAP16(FEC_BASER_RS);
+
+	#undef CAP32_TO_CAP16
+
+	return caps16;
+}
+
+/**
  *      lstatus_to_fwcap - translate old lstatus to 32-bit Port Capabilities
  *      @lstatus: old FW_PORT_ACTION_GET_PORT_INFO lstatus value
  *
@@ -1759,7 +1799,7 @@ csio_enable_ports(struct csio_hw *hw)
 			val = 1;
 
 			csio_mb_params(hw, mbp, CSIO_MB_DEFAULT_TMO,
-				       hw->pfn, 0, 1, &param, &val, false,
+				       hw->pfn, 0, 1, &param, &val, true,
 				       NULL);
 
 			if (csio_mb_issue(hw, mbp)) {
@@ -1769,16 +1809,9 @@ csio_enable_ports(struct csio_hw *hw)
 				return -EINVAL;
 			}
 
-			csio_mb_process_read_params_rsp(hw, mbp, &retval, 1,
-							&val);
-			if (retval != FW_SUCCESS) {
-				csio_err(hw, "FW_PARAMS_CMD(r) port:%d failed: 0x%x\n",
-					 portid, retval);
-				mempool_free(mbp, hw->mb_mempool);
-				return -EINVAL;
-			}
-
-			fw_caps = val;
+			csio_mb_process_read_params_rsp(hw, mbp, &retval,
+							0, NULL);
+			fw_caps = retval ? FW_CAPS16 : FW_CAPS32;
 		}
 
 		/* Read PORT information */
@@ -2364,8 +2397,8 @@ static int csio_hw_prep_fw(struct csio_hw *hw, struct fw_info *fw_info,
 }
 
 /*
- * Returns -EINVAL if attempts to flash the firmware failed
- * else returns 0,
+ * Returns -EINVAL if attempts to flash the firmware failed,
+ * -ENOMEM if memory allocation failed else returns 0,
  * if flashing was not attempted because the card had the
  * latest firmware ECANCELED is returned
  */
@@ -2393,6 +2426,13 @@ csio_hw_flash_fw(struct csio_hw *hw, int *reset)
 		return -EINVAL;
 	}
 
+	/* allocate memory to read the header of the firmware on the
+	 * card
+	 */
+	card_fw = kmalloc(sizeof(*card_fw), GFP_KERNEL);
+	if (!card_fw)
+		return -ENOMEM;
+
 	if (csio_is_t5(pci_dev->device & CSIO_HW_CHIP_MASK))
 		fw_bin_file = FW_FNAME_T5;
 	else
@@ -2406,11 +2446,6 @@ csio_hw_flash_fw(struct csio_hw *hw, int *reset)
 		fw_size = fw->size;
 	}
 
-	/* allocate memory to read the header of the firmware on the
-	 * card
-	 */
-	card_fw = kmalloc(sizeof(*card_fw), GFP_KERNEL);
-
 	/* upgrade FW logic */
 	ret = csio_hw_prep_fw(hw, fw_info, fw_data, fw_size, card_fw,
 			 hw->fw_state, reset);
diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 9e73ef771eb7..e351af6e7c81 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -639,6 +639,7 @@ int csio_handle_intr_status(struct csio_hw *, unsigned int,
 
 fw_port_cap32_t fwcap_to_fwspeed(fw_port_cap32_t acaps);
 fw_port_cap32_t fwcaps16_to_caps32(fw_port_cap16_t caps16);
+fw_port_cap16_t fwcaps32_to_caps16(fw_port_cap32_t caps32);
 fw_port_cap32_t lstatus_to_fwcap(u32 lstatus);
 
 int csio_hw_start(struct csio_hw *);
diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index c026417269c3..6f13673d6aa0 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -368,7 +368,7 @@ csio_mb_port(struct csio_hw *hw, struct csio_mb *mbp, uint32_t tmo,
 			FW_CMD_LEN16_V(sizeof(*cmdp) / 16));
 
 	if (fw_caps == FW_CAPS16)
-		cmdp->u.l1cfg.rcap = cpu_to_be32(fc);
+		cmdp->u.l1cfg.rcap = cpu_to_be32(fwcaps32_to_caps16(fc));
 	else
 		cmdp->u.l1cfg32.rcap32 = cpu_to_be32(fc);
 }
@@ -395,8 +395,8 @@ csio_mb_process_read_port_rsp(struct csio_hw *hw, struct csio_mb *mbp,
 			*pcaps = fwcaps16_to_caps32(ntohs(rsp->u.info.pcap));
 			*acaps = fwcaps16_to_caps32(ntohs(rsp->u.info.acap));
 		} else {
-			*pcaps = ntohs(rsp->u.info32.pcaps32);
-			*acaps = ntohs(rsp->u.info32.acaps32);
+			*pcaps = be32_to_cpu(rsp->u.info32.pcaps32);
+			*acaps = be32_to_cpu(rsp->u.info32.acaps32);
 		}
 	}
 }
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index f02dcc875a09..ea4b0bb0c1cd 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -563,35 +563,13 @@ struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_host_get);
 
-struct scsi_host_mq_in_flight {
-	int cnt;
-};
-
-static void scsi_host_check_in_flight(struct request *rq, void *data,
-		bool reserved)
-{
-	struct scsi_host_mq_in_flight *in_flight = data;
-
-	if (blk_mq_request_started(rq))
-		in_flight->cnt++;
-}
-
 /**
  * scsi_host_busy - Return the host busy counter
  * @shost:	Pointer to Scsi_Host to inc.
  **/
 int scsi_host_busy(struct Scsi_Host *shost)
 {
-	struct scsi_host_mq_in_flight in_flight = {
-		.cnt = 0,
-	};
-
-	if (!shost->use_blk_mq)
-		return atomic_read(&shost->host_busy);
-
-	blk_mq_tagset_busy_iter(&shost->tag_set, scsi_host_check_in_flight,
-			&in_flight);
-	return in_flight.cnt;
+	return atomic_read(&shost->host_busy);
 }
 EXPORT_SYMBOL(scsi_host_busy);
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 58bb70b886d7..c120929d4ffe 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -976,7 +976,7 @@ static struct scsi_host_template hpsa_driver_template = {
 #endif
 	.sdev_attrs = hpsa_sdev_attrs,
 	.shost_attrs = hpsa_shost_attrs,
-	.max_sectors = 1024,
+	.max_sectors = 2048,
 	.no_write_same = 1,
 };
 
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e0d0da5f43d6..43732e8d1347 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -672,7 +672,7 @@ struct lpfc_hba {
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
 #define LS_IGNORE_ERATT       0x4	/* intr handler should ignore ERATT */
 #define LS_MDS_LINK_DOWN      0x8	/* MDS Diagnostics Link Down */
-#define LS_MDS_LOOPBACK      0x16	/* MDS Diagnostics Link Up (Loopback) */
+#define LS_MDS_LOOPBACK      0x10	/* MDS Diagnostics Link Up (Loopback) */
 
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 5a25553415f8..057a60abe664 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5122,16 +5122,16 @@ LPFC_ATTR_R(enable_SmartSAN, 0, 0, 1, "Enable SmartSAN functionality");
 
 /*
 # lpfc_fdmi_on: Controls FDMI support.
-#       0       No FDMI support (default)
-#       1       Traditional FDMI support
+#       0       No FDMI support
+#       1       Traditional FDMI support (default)
 # Traditional FDMI support means the driver will assume FDMI-2 support;
 # however, if that fails, it will fallback to FDMI-1.
 # If lpfc_enable_SmartSAN is set to 1, the driver ignores lpfc_fdmi_on.
 # If lpfc_enable_SmartSAN is set 0, the driver uses the current value of
 # lpfc_fdmi_on.
-# Value range [0,1]. Default value is 0.
+# Value range [0,1]. Default value is 1.
 */
-LPFC_ATTR_R(fdmi_on, 0, 0, 1, "Enable FDMI support");
+LPFC_ATTR_R(fdmi_on, 1, 0, 1, "Enable FDMI support");
 
 /*
 # Specifies the maximum number of ELS cmds we can have outstanding (for
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0adfb3bce0fd..eb97d2dd3651 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -345,8 +345,7 @@ static void scsi_dec_host_busy(struct Scsi_Host *shost)
 	unsigned long flags;
 
 	rcu_read_lock();
-	if (!shost->use_blk_mq)
-		atomic_dec(&shost->host_busy);
+	atomic_dec(&shost->host_busy);
 	if (unlikely(scsi_host_in_recovery(shost))) {
 		spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->host_failed || shost->host_eh_scheduled)
@@ -445,12 +444,7 @@ static inline bool scsi_target_is_busy(struct scsi_target *starget)
 
 static inline bool scsi_host_is_busy(struct Scsi_Host *shost)
 {
-	/*
-	 * blk-mq can handle host queue busy efficiently via host-wide driver
-	 * tag allocation
-	 */
-
-	if (!shost->use_blk_mq && shost->can_queue > 0 &&
+	if (shost->can_queue > 0 &&
 	    atomic_read(&shost->host_busy) >= shost->can_queue)
 		return true;
 	if (atomic_read(&shost->host_blocked) > 0)
@@ -1606,10 +1600,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 	if (scsi_host_in_recovery(shost))
 		return 0;
 
-	if (!shost->use_blk_mq)
-		busy = atomic_inc_return(&shost->host_busy) - 1;
-	else
-		busy = 0;
+	busy = atomic_inc_return(&shost->host_busy) - 1;
 	if (atomic_read(&shost->host_blocked) > 0) {
 		if (busy)
 			goto starved;
@@ -1625,7 +1616,7 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
 				     "unblocking host at zero depth\n"));
 	}
 
-	if (!shost->use_blk_mq && shost->can_queue > 0 && busy >= shost->can_queue)
+	if (shost->can_queue > 0 && busy >= shost->can_queue)
 		goto starved;
 	if (shost->host_self_blocked)
 		goto starved;
@@ -1711,9 +1702,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	 * with the locks as normal issue path does.
 	 */
 	atomic_inc(&sdev->device_busy);
-
-	if (!shost->use_blk_mq)
-		atomic_inc(&shost->host_busy);
+	atomic_inc(&shost->host_busy);
 	if (starget->can_queue > 0)
 		atomic_inc(&starget->target_busy);
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 768cce0ccb80..76a262674c8d 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -207,8 +207,8 @@ cxgbit_ddp_reserve(struct cxgbit_sock *csk, struct cxgbi_task_tag_info *ttinfo,
 	ret = dma_map_sg(&ppm->pdev->dev, sgl, sgcnt, DMA_FROM_DEVICE);
 	sgl->offset = sg_offset;
 	if (!ret) {
-		pr_info("%s: 0x%x, xfer %u, sgl %u dma mapping err.\n",
-			__func__, 0, xferlen, sgcnt);
+		pr_debug("%s: 0x%x, xfer %u, sgl %u dma mapping err.\n",
+			 __func__, 0, xferlen, sgcnt);
 		goto rel_ppods;
 	}
 
@@ -250,8 +250,8 @@ cxgbit_get_r2t_ttt(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	ret = cxgbit_ddp_reserve(csk, ttinfo, cmd->se_cmd.data_length);
 	if (ret < 0) {
-		pr_info("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n",
-			csk, cmd, cmd->se_cmd.data_length, ttinfo->nents);
+		pr_debug("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n",
+			 csk, cmd, cmd->se_cmd.data_length, ttinfo->nents);
 
 		ttinfo->sgl = NULL;
 		ttinfo->nents = 0;
