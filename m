From: madhu.iyengar@qlogic.com
Subject: [PATCH 07/10] qla2xxx: Handle MPI timeout indicated by AE8002
Date: Fri,  3 Sep 2010 15:20:54 -0700
Message-ID: <1283552457-4497-8-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39333 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753485Ab0ICW06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:58 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>

In case the MPI times out, the FW issues an async event AE8002
to indicate this to every FCoE function. The FC/FCoE driver is
required to handle this, by doing a soft reset and issuing a
Write MPI register mailbox command to reset the MPI.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    6 ++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    2 +
 drivers/scsi/qla2xxx/qla_init.c |   31 ++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c  |    8 ++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |   61 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d2a4e15..12592cf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -706,6 +706,11 @@ typedef struct {
 #define MBC_SET_PORT_CONFIG		0x122	/* Set port configuration */
 #define MBC_GET_PORT_CONFIG		0x123	/* Get port configuration */
 
+/*
+ * ISP81xx mailbox commands
+ */
+#define MBC_WRITE_MPI_REGISTER		0x01    /* Write MPI Register. */
+
 /* Firmware return data sizes */
 #define FCAL_MAP_SIZE	128
 
@@ -2860,6 +2865,7 @@ typedef struct scsi_qla_host {
 #define NPIV_CONFIG_NEEDED	16
 #define ISP_UNRECOVERABLE	17
 #define FCOE_CTX_RESET_NEEDED	18	/* Initiate FCoE context reset */
+#define MPI_RESET_NEEDED	19	/* Initiate MPI FW reset */
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 967bc92..c33dec8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -352,6 +352,8 @@ qla2x00_read_ram_word(scsi_qla_host_t *, uint32_t, uint32_t *);
 extern int
 qla2x00_write_ram_word(scsi_qla_host_t *, uint32_t, uint32_t);
 
+extern int
+qla81xx_write_mpi_register(scsi_qla_host_t *, uint16_t *);
 extern int qla2x00_get_data_rate(scsi_qla_host_t *);
 extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t,
 	uint16_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 669d58a..3cafbef 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -954,6 +954,19 @@ qla2x00_reset_chip(scsi_qla_host_t *vha)
 }
 
 /**
+ * qla81xx_reset_mpi() - Reset's MPI FW via Write MPI Register MBC.
+ *
+ * Returns 0 on success.
+ */
+int
+qla81xx_reset_mpi(scsi_qla_host_t *vha)
+{
+	uint16_t mb[4] = {0x1010, 0, 1, 0};
+
+	return qla81xx_write_mpi_register(vha, mb);
+}
+
+/**
  * qla24xx_reset_risc() - Perform full reset of ISP24xx RISC.
  * @ha: HA context
  *
@@ -967,6 +980,7 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 	uint32_t cnt, d2;
 	uint16_t wd;
+	static int abts_cnt; /* ISP abort retry counts */
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -1000,6 +1014,23 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 		barrier();
 	}
 
+	/* If required, do an MPI FW reset now */
+	if (test_and_clear_bit(MPI_RESET_NEEDED, &vha->dpc_flags)) {
+		if (qla81xx_reset_mpi(vha) != QLA_SUCCESS) {
+			if (++abts_cnt < 5) {
+				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+				set_bit(MPI_RESET_NEEDED, &vha->dpc_flags);
+			} else {
+				/*
+				 * We exhausted the ISP abort retries. We have to
+				 * set the board offline.
+				 */
+				abts_cnt = 0;
+				vha->flags.online = 0;
+			}
+		}
+	}
+
 	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_RISC_RESET);
 	RD_REG_DWORD(&reg->hccr);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 28f65be..e0e43d9 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -412,8 +412,14 @@ skip_rio:
 				    "Unrecoverable Hardware Error: adapter "
 				    "marked OFFLINE!\n");
 				vha->flags.online = 0;
-			} else
+			} else {
+				/* Check to see if MPI timeout occured */
+				if ((mbx & MBX_3) && (ha->flags.port0))
+					set_bit(MPI_RESET_NEEDED,
+					    &vha->dpc_flags);
+
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+			}
 		} else if (mb[1] == 0) {
 			qla_printk(KERN_INFO, ha,
 			    "Unrecoverable Hardware Error: adapter marked "
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 5823398..effd8a1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3952,6 +3952,67 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 }
 
 int
+qla81xx_write_mpi_register(scsi_qla_host_t *vha, uint16_t *mb)
+{
+	int rval;
+	uint32_t stat, timer;
+	uint16_t mb0 = 0;
+	struct qla_hw_data *ha = vha->hw;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+
+	rval = QLA_SUCCESS;
+
+	DEBUG11(qla_printk(KERN_INFO, ha,
+	    "%s(%ld): entered.\n", __func__, vha->host_no));
+
+	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+
+	/* Write the MBC data to the registers */
+	WRT_REG_WORD(&reg->mailbox0, MBC_WRITE_MPI_REGISTER);
+	WRT_REG_WORD(&reg->mailbox1, mb[0]);
+	WRT_REG_WORD(&reg->mailbox2, mb[1]);
+	WRT_REG_WORD(&reg->mailbox3, mb[2]);
+	WRT_REG_WORD(&reg->mailbox4, mb[3]);
+
+	WRT_REG_DWORD(&reg->hccr, HCCRX_SET_HOST_INT);
+
+	/* Poll for MBC interrupt */
+	for (timer = 6000000; timer; timer--) {
+		/* Check for pending interrupts. */
+		stat = RD_REG_DWORD(&reg->host_status);
+		if (stat & HSRX_RISC_INT) {
+			stat &= 0xff;
+
+			if (stat == 0x1 || stat == 0x2 ||
+			    stat == 0x10 || stat == 0x11) {
+				set_bit(MBX_INTERRUPT,
+				    &ha->mbx_cmd_flags);
+				mb0 = RD_REG_WORD(&reg->mailbox0);
+				WRT_REG_DWORD(&reg->hccr,
+				    HCCRX_CLR_RISC_INT);
+				RD_REG_DWORD(&reg->hccr);
+				break;
+			}
+		}
+		udelay(5);
+	}
+
+	if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags))
+		rval = mb0 & MBS_MASK;
+	else
+		rval = QLA_FUNCTION_FAILED;
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk(KERN_INFO "%s(%ld): failed=%x mb[0]=%x.\n",
+		    __func__, vha->host_no, rval, mb[0]));
+	} else {
+		DEBUG11(printk(KERN_INFO
+		    "%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
+int
 qla2x00_get_data_rate(scsi_qla_host_t *vha)
 {
 	int rval;
-- 
1.6.0.2

