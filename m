From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [1/8]  qla2xxx: PCI posting fixes
Date: Mon, 6 Sep 2004 21:26:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042633.GA29571@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:59270 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267557AbUIGE2W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:28:22 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1871 04/09/04 23:19:51 andrew.vasquez@qlogic.com +3 -0
  PCI posting fixes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_dbg.c  |   15 +++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c |   38 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_sup.c  |    6 +++++-
 3 files changed, 54 insertions(+), 5 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
--- a/drivers/scsi/qla2xxx/qla_dbg.c	2004-09-06 12:06:47 -07:00
+++ b/drivers/scsi/qla2xxx/qla_dbg.c	2004-09-06 12:06:47 -07:00
@@ -86,6 +86,7 @@
 				rval = QLA_FUNCTION_TIMEOUT;
 		}
 	} else {
+		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
 		udelay(10);
 	}
 
@@ -221,6 +222,7 @@
 					WRT_REG_WORD(&reg->semaphore, 0);
 					WRT_REG_WORD(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
 					break;
 				} else if (stat == 0x10 || stat == 0x11) {
 					set_bit(MBX_INTERRUPT,
@@ -231,11 +233,13 @@
 
 					WRT_REG_WORD(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
 					break;
 				}
 
 				/* clear this intr; it wasn't a mailbox intr */
 				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+				RD_REG_WORD(&reg->hccr);
 			}
 			udelay(5);
 		}
@@ -277,6 +281,7 @@
 					WRT_REG_WORD(&reg->semaphore, 0);
 					WRT_REG_WORD(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
 					break;
 				} else if (stat == 0x10 || stat == 0x11) {
 					set_bit(MBX_INTERRUPT,
@@ -287,11 +292,13 @@
 
 					WRT_REG_WORD(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
 					break;
 				}
 
 				/* clear this intr; it wasn't a mailbox intr */
 				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+				RD_REG_WORD(&reg->hccr);
 			}
 			udelay(5);
 		}
@@ -334,6 +341,7 @@
 					WRT_REG_WORD(&reg->semaphore, 0);
 					WRT_REG_WORD(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
 					break;
 				} else if (stat == 0x10 || stat == 0x11) {
 					set_bit(MBX_INTERRUPT,
@@ -344,11 +352,13 @@
 
 					WRT_REG_WORD(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
 					break;
 				}
 
 				/* clear this intr; it wasn't a mailbox intr */
 				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+				RD_REG_WORD(&reg->hccr);
 			}
 			udelay(5);
 		}
@@ -702,6 +712,7 @@
 
 		/* Reset the ISP. */
 		WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
 	}
 
 	for (cnt = 30000; RD_MAILBOX_REG(ha, reg, 0) != 0 &&
@@ -731,9 +742,11 @@
 				WRT_REG_WORD(&reg->mctr, 0xf1);
 			else
 				WRT_REG_WORD(&reg->mctr, 0xf2);
+			RD_REG_WORD(&reg->mctr);	/* PCI Posting. */
 
 			/* Release RISC. */
 			WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
 		}
 	}
 
@@ -761,9 +774,11 @@
 					WRT_REG_WORD(&reg->semaphore, 0);
 					WRT_REG_WORD(&reg->hccr,
 					    HCCR_CLR_RISC_INT);
+					RD_REG_WORD(&reg->hccr);
 					break;
 				}
 				WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+				RD_REG_WORD(&reg->hccr);
 			}
 			udelay(5);
 		}
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:06:47 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:06:47 -07:00
@@ -306,6 +306,7 @@
 
 			/* Select FPM registers. */
 			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x20);
+			RD_REG_WORD(&ha->iobase->ctrl_status);
 
 			/* Get the fb rev level */
 			ha->fb_rev = RD_FB_CMD_REG(ha, ha->iobase);
@@ -315,6 +316,7 @@
 
 			/* Deselect FPM registers. */
 			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x0);
+			RD_REG_WORD(&ha->iobase->ctrl_status);
 
 			/* Release RISC module. */
 			WRT_REG_WORD(&ha->iobase->hccr, HCCR_RELEASE_RISC);
@@ -408,25 +410,32 @@
 				udelay(100);
 			}
 		} else {
+			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
 			udelay(10);
 		}
 
 		/* Select FPM registers. */
 		WRT_REG_WORD(&reg->ctrl_status, 0x20);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
 
 		/* FPM Soft Reset. */
 		WRT_REG_WORD(&reg->fpm_diag_config, 0x100);
+		RD_REG_WORD(&reg->fpm_diag_config);	/* PCI Posting. */
 
 		/* Toggle Fpm Reset. */
-		if (!IS_QLA2200(ha))
+		if (!IS_QLA2200(ha)) {
 			WRT_REG_WORD(&reg->fpm_diag_config, 0x0);
+			RD_REG_WORD(&reg->fpm_diag_config); /* PCI Posting. */
+		}
 
 		/* Select frame buffer registers. */
 		WRT_REG_WORD(&reg->ctrl_status, 0x10);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
 
 		/* Reset frame buffer FIFOs. */
 		if (IS_QLA2200(ha)) {
 			WRT_FB_CMD_REG(ha, reg, 0xa000);
+			RD_FB_CMD_REG(ha, reg);		/* PCI Posting. */
 		} else {
 			WRT_FB_CMD_REG(ha, reg, 0x00fc);
 
@@ -440,19 +449,25 @@
 
 		/* Select RISC module registers. */
 		WRT_REG_WORD(&reg->ctrl_status, 0);
+		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
 
 		/* Reset RISC processor. */
 		WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
 
 		/* Release RISC processor. */
 		WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
 	}
 
 	WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	/* Reset ISP chip. */
 	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	RD_REG_WORD(&reg->ctrl_status);			/* PCI Posting. */
 
 	/* Wait for RISC to recover from reset. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
@@ -473,12 +488,13 @@
 
 	/* Reset RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	WRT_REG_WORD(&reg->semaphore, 0);
 
 	/* Release RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
-	RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
 		for (cnt = 0; cnt < 30000; cnt++) {
@@ -507,8 +523,10 @@
 	pci_write_config_word(ha->pdev, PCI_COMMAND, cmd);
 
 	/* Disable RISC pause on FPM parity error. */
-	if (!IS_QLA2100(ha))
+	if (!IS_QLA2100(ha)) {
 		WRT_REG_WORD(&reg->hccr, HCCR_DISABLE_PARITY_PAUSE);
+		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -539,6 +557,8 @@
 
 	/* Reset ISP chip. */
 	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	RD_REG_WORD(&reg->ctrl_status);			/* PCI Posting. */
+
 	/*
 	 * We need to have a delay here since the card will not respond while
 	 * in reset causing an MCA on some architectures.
@@ -559,7 +579,9 @@
 
 	/* Reset RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	/* Workaround for QLA2312 PCI parity error */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
@@ -863,7 +885,7 @@
  	WRT_REG_WORD(ISP_REQ_Q_OUT(ha, reg), 0);
  	WRT_REG_WORD(ISP_RSP_Q_IN(ha, reg), 0);
  	WRT_REG_WORD(ISP_RSP_Q_OUT(ha, reg), 0);
-	RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));
+	RD_REG_WORD(ISP_RSP_Q_OUT(ha, reg));		/* PCI Posting. */
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -4259,9 +4281,13 @@
 			}
 
 			reg = ha->iobase;
+
 			spin_lock_irqsave(&ha->hardware_lock, flags);
+
 			/* Disable SRAM, Instruction RAM and GP RAM parity. */
 			WRT_REG_WORD(&reg->hccr, (HCCR_ENABLE_PARITY + 0x0));
+			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
+
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	
 			status = qla2x00_setup_chip(ha);
@@ -4277,6 +4303,7 @@
  				/* SRAM, Instruction RAM and GP RAM parity */
  				WRT_REG_WORD(&reg->hccr,
  				    (HCCR_ENABLE_PARITY + 0x7));
+			RD_REG_WORD(&reg->hccr);	/* PCI Posting. */
 
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		}
@@ -4329,9 +4356,12 @@
 
 	ha->flags.online = 0;
 	qla2x00_disable_intrs(ha);
+
 	/* Reset RISC processor. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
diff -Nru a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
--- a/drivers/scsi/qla2xxx/qla_sup.c	2004-09-06 12:06:47 -07:00
+++ b/drivers/scsi/qla2xxx/qla_sup.c	2004-09-06 12:06:47 -07:00
@@ -52,12 +52,14 @@
 
 		/* Lock resource */
 		WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0x1);
+		RD_REG_WORD(&reg->u.isp2300.host_semaphore);
 		udelay(5);
 		data = RD_REG_WORD(&reg->u.isp2300.host_semaphore);
 		while ((data & BIT_0) == 0) {
 			/* Lock failed */
 			udelay(100);
 			WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0x1);
+			RD_REG_WORD(&reg->u.isp2300.host_semaphore);
 			udelay(5);
 			data = RD_REG_WORD(&reg->u.isp2300.host_semaphore);
 		}
@@ -75,8 +77,10 @@
 
 	reg = ha->iobase;
 
-	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha))
+	if (!IS_QLA2100(ha) && !IS_QLA2200(ha) && !IS_QLA2300(ha)) {
 		WRT_REG_WORD(&reg->u.isp2300.host_semaphore, 0);
+		RD_REG_WORD(&reg->u.isp2300.host_semaphore);
+	}
 }
 
 /**
