From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 13:56:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095368210.16820.6.camel@praka>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org>
	 <1095362263.16326.12.camel@praka> <20040916125631.1f25dfdb.pj@sgi.com>
	 <200409161305.02947.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-y1pesy/iAwMCKPRQOubY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:8610 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S268254AbUIPVAZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 17:00:25 -0400
In-Reply-To: <200409161305.02947.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Paul Jackson <pj@sgi.com>, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>


--=-y1pesy/iAwMCKPRQOubY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2004-09-16 at 13:05, Jesse Barnes wrote:
> On Thursday, September 16, 2004 12:56 pm, Paul Jackson wrote:
> > Andrew Vasquez has been looking at this, via private email with just
> > me (no progress yet).  Figured I update the larger list with this much ...
> 
> It seems to be failing on one of the accesses to PCI_COMMAND in config space 
> in qla2x00_reset_chip().  I'm checking now to see if we're accessing the card 
> right after a reset but before the card has finished.  That would cause a 
> master abort, the symptom I'm seeing at least.
> 

Interesting, the only changes in reset_chip() are for PCI posting
issues.  Relevant diff attached.

--
Andrew

--=-y1pesy/iAwMCKPRQOubY
Content-Disposition: attachment; filename=posting.diff
Content-Type: text/x-patch; name=posting.diff; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

diff -Nurdp -X dontdiff 80000b14/qla_init.c 80000b21/qla_init.c
--- 80000b14/qla_init.c	2004-06-23 17:12:33.000000000 -0700
+++ 80000b21/qla_init.c	2004-09-02 13:11:35.000000000 -0700
@@ -315,6 +317,7 @@ qla2x00_pci_config(scsi_qla_host_t *ha)
 
 			/* Select FPM registers. */
 			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x20);
+			RD_REG_WORD(&ha->iobase->ctrl_status);
 
 			/* Get the fb rev level */
 			ha->fb_rev = RD_FB_CMD_REG(ha, ha->iobase);
@@ -324,6 +327,7 @@ qla2x00_pci_config(scsi_qla_host_t *ha)
 
 			/* Deselect FPM registers. */
 			WRT_REG_WORD(&ha->iobase->ctrl_status, 0x0);
+			RD_REG_WORD(&ha->iobase->ctrl_status);
 
 			/* Release RISC module. */
 			WRT_REG_WORD(&ha->iobase->hccr, HCCR_RELEASE_RISC);
@@ -417,25 +421,32 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
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
 
@@ -449,19 +460,25 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 
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
@@ -482,12 +499,13 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 
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
@@ -516,8 +534,10 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 	pci_write_config_word(ha->pdev, PCI_COMMAND, cmd);
 
 	/* Disable RISC pause on FPM parity error. */
-	if (!IS_QLA2100(ha))
+	if (!IS_QLA2100(ha)) {
 		WRT_REG_WORD(&reg->hccr, HCCR_DISABLE_PARITY_PAUSE);
+		RD_REG_WORD(&reg->hccr);		/* PCI Posting. */
+	}
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
@@ -548,6 +568,8 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 
 	/* Reset ISP chip. */
 	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+	RD_REG_WORD(&reg->ctrl_status);			/* PCI Posting. */
+
 	/*
 	 * We need to have a delay here since the card will not respond while
 	 * in reset causing an MCA on some architectures.
@@ -568,7 +590,9 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 
 	/* Reset RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
+	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	/* Workaround for QLA2312 PCI parity error */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {

--=-y1pesy/iAwMCKPRQOubY--

