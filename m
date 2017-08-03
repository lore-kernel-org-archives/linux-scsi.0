From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH v2 5/5] aic7[9x]xx: printk() lines unbroken
Date: Fri, 04 Aug 2017 01:28:10 +0200
Message-ID: <ba7fbf18bb8e216484a6877edec3d00864aa89fe.1501802727.git.mirq-linux@rere.qmqm.pl>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([91.227.64.183]:35152 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751926AbdHCX2O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Aug 2017 19:28:14 -0400
In-Reply-To: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Current code is not SMP-friendly and since now each printk() call
generates a separate line in the log, the output is mostly unreadable.
Make it better formatted.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/scsi/Kconfig                             |   3 +-
 drivers/scsi/aic7xxx/Kconfig                     |   6 +
 drivers/scsi/aic7xxx/Kconfig.aic79xx             |   1 +
 drivers/scsi/aic7xxx/Kconfig.aic7xxx             |   1 +
 drivers/scsi/aic7xxx/Makefile                    |   1 +
 drivers/scsi/aic7xxx/aic79xx.h                   |   7 -
 drivers/scsi/aic7xxx/aic79xx_core.c              | 242 +++++-------
 drivers/scsi/aic7xxx/aic79xx_reg.h_shipped       | 307 +++++++--------
 drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped | 480 +++++++++++------------
 drivers/scsi/aic7xxx/aic7xxx.h                   |   7 -
 drivers/scsi/aic7xxx/aic7xxx_core.c              | 181 ++++-----
 drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped       | 157 ++++----
 drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped | 242 ++++++------
 drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c      |  39 +-
 drivers/scsi/aic7xxx/aiclib.c                    | 103 +++--
 drivers/scsi/aic7xxx/aiclib.h                    |  32 ++
 16 files changed, 871 insertions(+), 938 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f4538d7a3016..b76939b77319 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -452,8 +452,7 @@ config SCSI_AACRAID
 	  will be called aacraid.
 
 
-source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
-source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
+source "drivers/scsi/aic7xxx/Kconfig"
 source "drivers/scsi/aic94xx/Kconfig"
 source "drivers/scsi/hisi_sas/Kconfig"
 source "drivers/scsi/mvsas/Kconfig"
diff --git a/drivers/scsi/aic7xxx/Kconfig b/drivers/scsi/aic7xxx/Kconfig
new file mode 100644
index 000000000000..aeae1ba88281
--- /dev/null
+++ b/drivers/scsi/aic7xxx/Kconfig
@@ -0,0 +1,6 @@
+config SCSI_AICLIB
+	tristate
+	default n
+
+source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
+source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic79xx b/drivers/scsi/aic7xxx/Kconfig.aic79xx
index 3b3d599103f8..7cf29839bc54 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic79xx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic79xx
@@ -6,6 +6,7 @@ config SCSI_AIC79XX
 	tristate "Adaptec AIC79xx U320 support"
 	depends on PCI && SCSI
 	select SCSI_SPI_ATTRS
+	select SCSI_AICLIB
 	help
 	This driver supports all of Adaptec's Ultra 320 PCI-X
 	based SCSI controllers.
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic7xxx b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
index 55ac55ee6068..0d6cea939551 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic7xxx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -6,6 +6,7 @@ config SCSI_AIC7XXX
 	tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
 	depends on (PCI || EISA) && SCSI
 	select SCSI_SPI_ATTRS
+	select SCSI_AICLIB
 	---help---
 	This driver supports all of Adaptec's Fast through Ultra 160 PCI
 	based SCSI controllers as well as the aic7770 based EISA and VLB
diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 1a5509d40f8a..3e7565a9d37a 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -7,6 +7,7 @@
 # Let kbuild descend into aicasm when cleaning
 subdir-				+= aicasm
 
+obj-$(CONFIG_SCSI_AICLIB)	+= aiclib.o
 obj-$(CONFIG_SCSI_AIC7XXX)	+= aic7xxx.o
 obj-$(CONFIG_SCSI_AIC79XX)	+= aic79xx.o
 
diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index d47b527b25dd..f81287db98bb 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -1468,11 +1468,4 @@ extern uint32_t ahd_debug;
 void			ahd_print_devinfo(struct ahd_softc *ahd,
 					  struct ahd_devinfo *devinfo);
 void			ahd_dump_card_state(struct ahd_softc *ahd);
-int			ahd_print_register(const ahd_reg_parse_entry_t *table,
-					   u_int num_entries,
-					   const char *name,
-					   u_int address,
-					   u_int value,
-					   u_int *cur_column,
-					   u_int wrap_point);
 #endif /* _AIC79XX_H_ */
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 95d8f25cbcca..b895c43e9a5d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2672,6 +2672,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat)
 static void
 ahd_handle_transmission_error(struct ahd_softc *ahd)
 {
+	struct aic_dump_buffer buf;
 	struct	scb *scb;
 	u_int	scbid;
 	u_int	lqistat1;
@@ -2680,7 +2681,6 @@ ahd_handle_transmission_error(struct ahd_softc *ahd)
 	u_int	curphase;
 	u_int	lastphase;
 	u_int	perrdiag;
-	u_int	cur_col;
 	int	silent;
 
 	scb = NULL;
@@ -2727,14 +2727,14 @@ ahd_handle_transmission_error(struct ahd_softc *ahd)
 			silent = TRUE;
 	}
 
-	cur_col = 0;
+	aic_printbuf_init(&buf, 60);
 	if (silent == FALSE) {
 		printk("%s: Transmission error detected\n", ahd_name(ahd));
-		ahd_lqistat1_print(lqistat1, &cur_col, 50);
-		ahd_lastphase_print(lastphase, &cur_col, 50);
-		ahd_scsisigi_print(curphase, &cur_col, 50);
-		ahd_perrdiag_print(perrdiag, &cur_col, 50);
-		printk("\n");
+		ahd_lqistat1_print(lqistat1, &buf);
+		ahd_lastphase_print(lastphase, &buf);
+		ahd_scsisigi_print(curphase, &buf);
+		ahd_perrdiag_print(perrdiag, &buf);
+		aic_printbuf_finish(&buf);
 		ahd_dump_card_state(ahd);
 	}
 
@@ -9677,64 +9677,16 @@ ahd_probe_stack_size(struct ahd_softc *ahd)
 	return (last_probe);
 }
 
-int
-ahd_print_register(const ahd_reg_parse_entry_t *table, u_int num_entries,
-		   const char *name, u_int address, u_int value,
-		   u_int *cur_column, u_int wrap_point)
-{
-	int	printed;
-	u_int	printed_mask;
-
-	if (cur_column != NULL && *cur_column >= wrap_point) {
-		printk("\n");
-		*cur_column = 0;
-	}
-	printed = printk("%s[0x%x]", name, value);
-	if (table == NULL) {
-		printed += printk(" ");
-		*cur_column += printed;
-		return (printed);
-	}
-	printed_mask = 0;
-	while (printed_mask != 0xFF) {
-		int entry;
-
-		for (entry = 0; entry < num_entries; entry++) {
-			if (((value & table[entry].mask)
-			  != table[entry].value)
-			 || ((printed_mask & table[entry].mask)
-			  == table[entry].mask))
-				continue;
-
-			printed += printk("%s%s",
-					  printed_mask == 0 ? ":(" : "|",
-					  table[entry].name);
-			printed_mask |= table[entry].mask;
-			
-			break;
-		}
-		if (entry >= num_entries)
-			break;
-	}
-	if (printed_mask != 0)
-		printed += printk(") ");
-	else
-		printed += printk(" ");
-	if (cur_column != NULL)
-		*cur_column += printed;
-	return (printed);
-}
-
 void
 ahd_dump_card_state(struct ahd_softc *ahd)
 {
+	struct aic_dump_buffer buf;
 	struct scb	*scb;
 	ahd_mode_state	 saved_modes;
 	u_int		 dffstat;
 	int		 paused;
 	u_int		 scb_index;
 	u_int		 saved_scb_index;
-	u_int		 cur_col;
 	int		 i;
 
 	if (ahd_is_paused(ahd)) {
@@ -9760,78 +9712,75 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 	/*
 	 * Mode independent registers.
 	 */
-	cur_col = 0;
-	ahd_intstat_print(ahd_inb(ahd, INTSTAT), &cur_col, 50);
-	ahd_seloid_print(ahd_inb(ahd, SELOID), &cur_col, 50);
-	ahd_selid_print(ahd_inb(ahd, SELID), &cur_col, 50);
-	ahd_hs_mailbox_print(ahd_inb(ahd, LOCAL_HS_MAILBOX), &cur_col, 50);
-	ahd_intctl_print(ahd_inb(ahd, INTCTL), &cur_col, 50);
-	ahd_seqintstat_print(ahd_inb(ahd, SEQINTSTAT), &cur_col, 50);
-	ahd_saved_mode_print(ahd_inb(ahd, SAVED_MODE), &cur_col, 50);
-	ahd_dffstat_print(ahd_inb(ahd, DFFSTAT), &cur_col, 50);
-	ahd_scsisigi_print(ahd_inb(ahd, SCSISIGI), &cur_col, 50);
-	ahd_scsiphase_print(ahd_inb(ahd, SCSIPHASE), &cur_col, 50);
-	ahd_scsibus_print(ahd_inb(ahd, SCSIBUS), &cur_col, 50);
-	ahd_lastphase_print(ahd_inb(ahd, LASTPHASE), &cur_col, 50);
-	ahd_scsiseq0_print(ahd_inb(ahd, SCSISEQ0), &cur_col, 50);
-	ahd_scsiseq1_print(ahd_inb(ahd, SCSISEQ1), &cur_col, 50);
-	ahd_seqctl0_print(ahd_inb(ahd, SEQCTL0), &cur_col, 50);
-	ahd_seqintctl_print(ahd_inb(ahd, SEQINTCTL), &cur_col, 50);
-	ahd_seq_flags_print(ahd_inb(ahd, SEQ_FLAGS), &cur_col, 50);
-	ahd_seq_flags2_print(ahd_inb(ahd, SEQ_FLAGS2), &cur_col, 50);
-	ahd_qfreeze_count_print(ahd_inw(ahd, QFREEZE_COUNT), &cur_col, 50);
+	aic_printbuf_init(&buf, 60);
+	ahd_intstat_print(ahd_inb(ahd, INTSTAT), &buf);
+	ahd_seloid_print(ahd_inb(ahd, SELOID), &buf);
+	ahd_selid_print(ahd_inb(ahd, SELID), &buf);
+	ahd_hs_mailbox_print(ahd_inb(ahd, LOCAL_HS_MAILBOX), &buf);
+	ahd_intctl_print(ahd_inb(ahd, INTCTL), &buf);
+	ahd_seqintstat_print(ahd_inb(ahd, SEQINTSTAT), &buf);
+	ahd_saved_mode_print(ahd_inb(ahd, SAVED_MODE), &buf);
+	ahd_dffstat_print(ahd_inb(ahd, DFFSTAT), &buf);
+	ahd_scsisigi_print(ahd_inb(ahd, SCSISIGI), &buf);
+	ahd_scsiphase_print(ahd_inb(ahd, SCSIPHASE), &buf);
+	ahd_scsibus_print(ahd_inb(ahd, SCSIBUS), &buf);
+	ahd_lastphase_print(ahd_inb(ahd, LASTPHASE), &buf);
+	ahd_scsiseq0_print(ahd_inb(ahd, SCSISEQ0), &buf);
+	ahd_scsiseq1_print(ahd_inb(ahd, SCSISEQ1), &buf);
+	ahd_seqctl0_print(ahd_inb(ahd, SEQCTL0), &buf);
+	ahd_seqintctl_print(ahd_inb(ahd, SEQINTCTL), &buf);
+	ahd_seq_flags_print(ahd_inb(ahd, SEQ_FLAGS), &buf);
+	ahd_seq_flags2_print(ahd_inb(ahd, SEQ_FLAGS2), &buf);
+	ahd_qfreeze_count_print(ahd_inw(ahd, QFREEZE_COUNT), &buf);
 	ahd_kernel_qfreeze_count_print(ahd_inw(ahd, KERNEL_QFREEZE_COUNT),
-				       &cur_col, 50);
-	ahd_mk_message_scb_print(ahd_inw(ahd, MK_MESSAGE_SCB), &cur_col, 50);
-	ahd_mk_message_scsiid_print(ahd_inb(ahd, MK_MESSAGE_SCSIID),
-				    &cur_col, 50);
-	ahd_sstat0_print(ahd_inb(ahd, SSTAT0), &cur_col, 50);
-	ahd_sstat1_print(ahd_inb(ahd, SSTAT1), &cur_col, 50);
-	ahd_sstat2_print(ahd_inb(ahd, SSTAT2), &cur_col, 50);
-	ahd_sstat3_print(ahd_inb(ahd, SSTAT3), &cur_col, 50);
-	ahd_perrdiag_print(ahd_inb(ahd, PERRDIAG), &cur_col, 50);
-	ahd_simode1_print(ahd_inb(ahd, SIMODE1), &cur_col, 50);
-	ahd_lqistat0_print(ahd_inb(ahd, LQISTAT0), &cur_col, 50);
-	ahd_lqistat1_print(ahd_inb(ahd, LQISTAT1), &cur_col, 50);
-	ahd_lqistat2_print(ahd_inb(ahd, LQISTAT2), &cur_col, 50);
-	ahd_lqostat0_print(ahd_inb(ahd, LQOSTAT0), &cur_col, 50);
-	ahd_lqostat1_print(ahd_inb(ahd, LQOSTAT1), &cur_col, 50);
-	ahd_lqostat2_print(ahd_inb(ahd, LQOSTAT2), &cur_col, 50);
-	printk("\n");
+				       &buf);
+	ahd_mk_message_scb_print(ahd_inw(ahd, MK_MESSAGE_SCB), &buf);
+	ahd_mk_message_scsiid_print(ahd_inb(ahd, MK_MESSAGE_SCSIID), &buf);
+	ahd_sstat0_print(ahd_inb(ahd, SSTAT0), &buf);
+	ahd_sstat1_print(ahd_inb(ahd, SSTAT1), &buf);
+	ahd_sstat2_print(ahd_inb(ahd, SSTAT2), &buf);
+	ahd_sstat3_print(ahd_inb(ahd, SSTAT3), &buf);
+	ahd_perrdiag_print(ahd_inb(ahd, PERRDIAG), &buf);
+	ahd_simode1_print(ahd_inb(ahd, SIMODE1), &buf);
+	ahd_lqistat0_print(ahd_inb(ahd, LQISTAT0), &buf);
+	ahd_lqistat1_print(ahd_inb(ahd, LQISTAT1), &buf);
+	ahd_lqistat2_print(ahd_inb(ahd, LQISTAT2), &buf);
+	ahd_lqostat0_print(ahd_inb(ahd, LQOSTAT0), &buf);
+	ahd_lqostat1_print(ahd_inb(ahd, LQOSTAT1), &buf);
+	ahd_lqostat2_print(ahd_inb(ahd, LQOSTAT2), &buf);
+	aic_printbuf_finish(&buf);
 	printk("\nSCB Count = %d CMDS_PENDING = %d LASTSCB 0x%x "
 	       "CURRSCB 0x%x NEXTSCB 0x%x\n",
 	       ahd->scb_data.numscbs, ahd_inw(ahd, CMDS_PENDING),
 	       ahd_inw(ahd, LASTSCB), ahd_inw(ahd, CURRSCB),
 	       ahd_inw(ahd, NEXTSCB));
-	cur_col = 0;
 	/* QINFIFO */
 	ahd_search_qinfifo(ahd, CAM_TARGET_WILDCARD, ALL_CHANNELS,
 			   CAM_LUN_WILDCARD, SCB_LIST_NULL,
 			   ROLE_UNKNOWN, /*status*/0, SEARCH_PRINT);
 	saved_scb_index = ahd_get_scbptr(ahd);
-	printk("Pending list:");
+	printk("Pending list:\n");
 	i = 0;
 	LIST_FOREACH(scb, &ahd->pending_scbs, pending_links) {
 		if (i++ > AHD_SCB_MAX)
 			break;
-		cur_col = printk("\n%3d FIFO_USE[0x%x] ", SCB_GET_TAG(scb),
-				 ahd_inb_scbram(ahd, SCB_FIFO_USE_COUNT));
+		aic_printbuf_push(&buf, "%3d FIFO_USE[0x%x] ", SCB_GET_TAG(scb),
+				  ahd_inb_scbram(ahd, SCB_FIFO_USE_COUNT));
 		ahd_set_scbptr(ahd, SCB_GET_TAG(scb));
-		ahd_scb_control_print(ahd_inb_scbram(ahd, SCB_CONTROL),
-				      &cur_col, 60);
-		ahd_scb_scsiid_print(ahd_inb_scbram(ahd, SCB_SCSIID),
-				     &cur_col, 60);
+		ahd_scb_control_print(ahd_inb_scbram(ahd, SCB_CONTROL), &buf);
+		ahd_scb_scsiid_print(ahd_inb_scbram(ahd, SCB_SCSIID), &buf);
+		aic_printbuf_finish(&buf);
 	}
-	printk("\nTotal %d\n", i);
+	printk("Total %d\n", i);
 
-	printk("Kernel Free SCB list: ");
+	aic_printbuf_push(&buf, "Kernel Free SCB list: ");
 	i = 0;
 	TAILQ_FOREACH(scb, &ahd->scb_data.free_scbs, links.tqe) {
 		struct scb *list_scb;
 
 		list_scb = scb;
 		do {
-			printk("%d ", SCB_GET_TAG(list_scb));
+			aic_printbuf_push(&buf, "%d ", SCB_GET_TAG(list_scb));
 			list_scb = LIST_NEXT(list_scb, collision_links);
 		} while (list_scb && i++ < AHD_SCB_MAX);
 	}
@@ -9839,49 +9788,49 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 	LIST_FOREACH(scb, &ahd->scb_data.any_dev_free_scb_list, links.le) {
 		if (i++ > AHD_SCB_MAX)
 			break;
-		printk("%d ", SCB_GET_TAG(scb));
+		aic_printbuf_push(&buf, "%d ", SCB_GET_TAG(scb));
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
-	printk("Sequencer Complete DMA-inprog list: ");
+	aic_printbuf_push(&buf, "Sequencer Complete DMA-inprog list: ");
 	scb_index = ahd_inw(ahd, COMPLETE_SCB_DMAINPROG_HEAD);
 	i = 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printk("%d ", scb_index);
+		aic_printbuf_push(&buf, "%d ", scb_index);
 		scb_index = ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
-	printk("Sequencer Complete list: ");
+	aic_printbuf_push(&buf, "Sequencer Complete list: ");
 	scb_index = ahd_inw(ahd, COMPLETE_SCB_HEAD);
 	i = 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printk("%d ", scb_index);
+		aic_printbuf_push(&buf, "%d ", scb_index);
 		scb_index = ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
 	
-	printk("Sequencer DMA-Up and Complete list: ");
+	aic_printbuf_push(&buf, "Sequencer DMA-Up and Complete list: ");
 	scb_index = ahd_inw(ahd, COMPLETE_DMA_SCB_HEAD);
 	i = 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printk("%d ", scb_index);
+		aic_printbuf_push(&buf, "%d ", scb_index);
 		scb_index = ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printk("\n");
-	printk("Sequencer On QFreeze and Complete list: ");
+	aic_printbuf_finish(&buf);
+	aic_printbuf_push(&buf, "Sequencer On QFreeze and Complete list: ");
 	scb_index = ahd_inw(ahd, COMPLETE_ON_QFREEZE_HEAD);
 	i = 0;
 	while (!SCBID_IS_NULL(scb_index) && i++ < AHD_SCB_MAX) {
 		ahd_set_scbptr(ahd, scb_index);
-		printk("%d ", scb_index);
+		aic_printbuf_push(&buf, "%d ", scb_index);
 		scb_index = ahd_inw_scbram(ahd, SCB_NEXT_COMPLETE);
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 	ahd_set_scbptr(ahd, saved_scb_index);
 	dffstat = ahd_inb(ahd, DFFSTAT);
 	for (i = 0; i < 2; i++) {
@@ -9896,38 +9845,29 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 		       ahd_name(ahd), i,
 		       (dffstat & (FIFO0FREE << i)) ? "Free" : "Active",
 		       ahd_inw(ahd, LONGJMP_ADDR), fifo_scbptr);
-		cur_col = 0;
-		ahd_seqimode_print(ahd_inb(ahd, SEQIMODE), &cur_col, 50);
-		ahd_seqintsrc_print(ahd_inb(ahd, SEQINTSRC), &cur_col, 50);
-		ahd_dfcntrl_print(ahd_inb(ahd, DFCNTRL), &cur_col, 50);
-		ahd_dfstatus_print(ahd_inb(ahd, DFSTATUS), &cur_col, 50);
-		ahd_sg_cache_shadow_print(ahd_inb(ahd, SG_CACHE_SHADOW),
-					  &cur_col, 50);
-		ahd_sg_state_print(ahd_inb(ahd, SG_STATE), &cur_col, 50);
-		ahd_dffsxfrctl_print(ahd_inb(ahd, DFFSXFRCTL), &cur_col, 50);
-		ahd_soffcnt_print(ahd_inb(ahd, SOFFCNT), &cur_col, 50);
-		ahd_mdffstat_print(ahd_inb(ahd, MDFFSTAT), &cur_col, 50);
-		if (cur_col > 50) {
-			printk("\n");
-			cur_col = 0;
-		}
-		cur_col += printk("SHADDR = 0x%x%x, SHCNT = 0x%x ",
+		ahd_seqimode_print(ahd_inb(ahd, SEQIMODE), &buf);
+		ahd_seqintsrc_print(ahd_inb(ahd, SEQINTSRC), &buf);
+		ahd_dfcntrl_print(ahd_inb(ahd, DFCNTRL), &buf);
+		ahd_dfstatus_print(ahd_inb(ahd, DFSTATUS), &buf);
+		ahd_sg_cache_shadow_print(ahd_inb(ahd, SG_CACHE_SHADOW), &buf);
+		ahd_sg_state_print(ahd_inb(ahd, SG_STATE), &buf);
+		ahd_dffsxfrctl_print(ahd_inb(ahd, DFFSXFRCTL), &buf);
+		ahd_soffcnt_print(ahd_inb(ahd, SOFFCNT), &buf);
+		ahd_mdffstat_print(ahd_inb(ahd, MDFFSTAT), &buf);
+		aic_printbuf_push(&buf, "SHADDR = 0x%x%x, SHCNT = 0x%x ",
 				  ahd_inl(ahd, SHADDR+4),
 				  ahd_inl(ahd, SHADDR),
 				  (ahd_inb(ahd, SHCNT)
 				| (ahd_inb(ahd, SHCNT + 1) << 8)
 				| (ahd_inb(ahd, SHCNT + 2) << 16)));
-		if (cur_col > 50) {
-			printk("\n");
-			cur_col = 0;
-		}
-		cur_col += printk("HADDR = 0x%x%x, HCNT = 0x%x ",
+		aic_printbuf_push(&buf, "HADDR = 0x%x%x, HCNT = 0x%x ",
 				  ahd_inl(ahd, HADDR+4),
 				  ahd_inl(ahd, HADDR),
 				  (ahd_inb(ahd, HCNT)
 				| (ahd_inb(ahd, HCNT + 1) << 8)
 				| (ahd_inb(ahd, HCNT + 2) << 16)));
-		ahd_ccsgctl_print(ahd_inb(ahd, CCSGCTL), &cur_col, 50);
+		ahd_ccsgctl_print(ahd_inb(ahd, CCSGCTL), &buf);
+		aic_printbuf_finish(&buf);
 #ifdef AHD_DEBUG
 		if ((ahd_debug & AHD_SHOW_SG) != 0) {
 			fifo_scb = ahd_lookup_scb(ahd, fifo_scbptr);
@@ -9936,10 +9876,10 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 		}
 #endif
 	}
-	printk("\nLQIN: ");
+	aic_printbuf_push(&buf, "\nLQIN: ");
 	for (i = 0; i < 20; i++)
-		printk("0x%x ", ahd_inb(ahd, LQIN + i));
-	printk("\n");
+		aic_printbuf_push(&buf, "0x%x ", ahd_inb(ahd, LQIN + i));
+	aic_printbuf_finish(&buf);
 	ahd_set_modes(ahd, AHD_MODE_CFG, AHD_MODE_CFG);
 	printk("%s: LQISTATE = 0x%x, LQOSTATE = 0x%x, OPTIONMODE = 0x%x\n",
 	       ahd_name(ahd), ahd_inb(ahd, LQISTATE), ahd_inb(ahd, LQOSTATE),
@@ -9950,12 +9890,11 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 	printk("%s: SAVED_SCSIID = 0x%x SAVED_LUN = 0x%x\n",
 	       ahd_name(ahd), ahd_inb(ahd, SAVED_SCSIID),
 	       ahd_inb(ahd, SAVED_LUN));
-	ahd_simode0_print(ahd_inb(ahd, SIMODE0), &cur_col, 50);
-	printk("\n");
+	ahd_simode0_print(ahd_inb(ahd, SIMODE0), &buf);
+	aic_printbuf_finish(&buf);
 	ahd_set_modes(ahd, AHD_MODE_CCHAN, AHD_MODE_CCHAN);
-	cur_col = 0;
-	ahd_ccscbctl_print(ahd_inb(ahd, CCSCBCTL), &cur_col, 50);
-	printk("\n");
+	ahd_ccscbctl_print(ahd_inb(ahd, CCSCBCTL), &buf);
+	aic_printbuf_finish(&buf);
 	ahd_set_modes(ahd, ahd->saved_src_mode, ahd->saved_dst_mode);
 	printk("%s: REG0 == 0x%x, SINDEX = 0x%x, DINDEX = 0x%x\n",
 	       ahd_name(ahd), ahd_inw(ahd, REG0), ahd_inw(ahd, SINDEX),
@@ -9971,17 +9910,18 @@ ahd_dump_card_state(struct ahd_softc *ahd)
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+3),
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+4),
 	       ahd_inb_scbram(ahd, SCB_CDB_STORE+5));
-	printk("STACK:");
+	aic_printbuf_push(&buf, "STACK:");
 	for (i = 0; i < ahd->stack_size; i++) {
 		ahd->saved_stack[i] =
 		    ahd_inb(ahd, STACK)|(ahd_inb(ahd, STACK) << 8);
-		printk(" 0x%x", ahd->saved_stack[i]);
+		aic_printbuf_push(&buf, " 0x%x", ahd->saved_stack[i]);
 	}
 	for (i = ahd->stack_size-1; i >= 0; i--) {
 		ahd_outb(ahd, STACK, ahd->saved_stack[i] & 0xFF);
 		ahd_outb(ahd, STACK, (ahd->saved_stack[i] >> 8) & 0xFF);
 	}
-	printk("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
+	aic_printbuf_finish(&buf);
+	printk("<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
 	ahd_restore_modes(ahd, saved_modes);
 	if (paused == 0)
 		ahd_unpause(ahd);
diff --git a/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped b/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
index ddcd5a7701ac..fef0196f0986 100644
--- a/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
+++ b/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
@@ -5,361 +5,354 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#120 $
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#77 $
  */
-typedef int (ahd_reg_print_t)(u_int, u_int *, u_int);
-typedef struct ahd_reg_parse_entry {
-	char	*name;
-	uint8_t	 value;
-	uint8_t	 mask;
-} ahd_reg_parse_entry_t;
-
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_intstat_print;
+aic_reg_print_t ahd_intstat_print;
 #else
-#define ahd_intstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "INTSTAT", 0x01, regvalue, cur_col, wrap)
+#define ahd_intstat_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "INTSTAT", 0x01, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hs_mailbox_print;
+aic_reg_print_t ahd_hs_mailbox_print;
 #else
-#define ahd_hs_mailbox_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HS_MAILBOX", 0x0b, regvalue, cur_col, wrap)
+#define ahd_hs_mailbox_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "HS_MAILBOX", 0x0b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqintstat_print;
+aic_reg_print_t ahd_seqintstat_print;
 #else
-#define ahd_seqintstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQINTSTAT", 0x0c, regvalue, cur_col, wrap)
+#define ahd_seqintstat_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQINTSTAT", 0x0c, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_intctl_print;
+aic_reg_print_t ahd_intctl_print;
 #else
-#define ahd_intctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "INTCTL", 0x18, regvalue, cur_col, wrap)
+#define ahd_intctl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "INTCTL", 0x18, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfcntrl_print;
+aic_reg_print_t ahd_dfcntrl_print;
 #else
-#define ahd_dfcntrl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFCNTRL", 0x19, regvalue, cur_col, wrap)
+#define ahd_dfcntrl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "DFCNTRL", 0x19, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfstatus_print;
+aic_reg_print_t ahd_dfstatus_print;
 #else
-#define ahd_dfstatus_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFSTATUS", 0x1a, regvalue, cur_col, wrap)
+#define ahd_dfstatus_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "DFSTATUS", 0x1a, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sg_cache_shadow_print;
+aic_reg_print_t ahd_sg_cache_shadow_print;
 #else
-#define ahd_sg_cache_shadow_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SG_CACHE_SHADOW", 0x1b, regvalue, cur_col, wrap)
+#define ahd_sg_cache_shadow_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SG_CACHE_SHADOW", 0x1b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsiseq0_print;
+aic_reg_print_t ahd_scsiseq0_print;
 #else
-#define ahd_scsiseq0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISEQ0", 0x3a, regvalue, cur_col, wrap)
+#define ahd_scsiseq0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSISEQ0", 0x3a, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsiseq1_print;
+aic_reg_print_t ahd_scsiseq1_print;
 #else
-#define ahd_scsiseq1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISEQ1", 0x3b, regvalue, cur_col, wrap)
+#define ahd_scsiseq1_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSISEQ1", 0x3b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dffstat_print;
+aic_reg_print_t ahd_dffstat_print;
 #else
-#define ahd_dffstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFFSTAT", 0x3f, regvalue, cur_col, wrap)
+#define ahd_dffstat_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "DFFSTAT", 0x3f, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsisigi_print;
+aic_reg_print_t ahd_scsisigi_print;
 #else
-#define ahd_scsisigi_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISIGI", 0x41, regvalue, cur_col, wrap)
+#define ahd_scsisigi_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSISIGI", 0x41, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsiphase_print;
+aic_reg_print_t ahd_scsiphase_print;
 #else
-#define ahd_scsiphase_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSIPHASE", 0x42, regvalue, cur_col, wrap)
+#define ahd_scsiphase_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSIPHASE", 0x42, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsibus_print;
+aic_reg_print_t ahd_scsibus_print;
 #else
-#define ahd_scsibus_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSIBUS", 0x46, regvalue, cur_col, wrap)
+#define ahd_scsibus_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSIBUS", 0x46, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_selid_print;
+aic_reg_print_t ahd_selid_print;
 #else
-#define ahd_selid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SELID", 0x49, regvalue, cur_col, wrap)
+#define ahd_selid_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SELID", 0x49, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_simode0_print;
+aic_reg_print_t ahd_simode0_print;
 #else
-#define ahd_simode0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SIMODE0", 0x4b, regvalue, cur_col, wrap)
+#define ahd_simode0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SIMODE0", 0x4b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat0_print;
+aic_reg_print_t ahd_sstat0_print;
 #else
-#define ahd_sstat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT0", 0x4b, regvalue, cur_col, wrap)
+#define ahd_sstat0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT0", 0x4b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat1_print;
+aic_reg_print_t ahd_sstat1_print;
 #else
-#define ahd_sstat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT1", 0x4c, regvalue, cur_col, wrap)
+#define ahd_sstat1_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT1", 0x4c, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat2_print;
+aic_reg_print_t ahd_sstat2_print;
 #else
-#define ahd_sstat2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT2", 0x4d, regvalue, cur_col, wrap)
+#define ahd_sstat2_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT2", 0x4d, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_perrdiag_print;
+aic_reg_print_t ahd_perrdiag_print;
 #else
-#define ahd_perrdiag_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PERRDIAG", 0x4e, regvalue, cur_col, wrap)
+#define ahd_perrdiag_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "PERRDIAG", 0x4e, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_soffcnt_print;
+aic_reg_print_t ahd_soffcnt_print;
 #else
-#define ahd_soffcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SOFFCNT", 0x4f, regvalue, cur_col, wrap)
+#define ahd_soffcnt_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SOFFCNT", 0x4f, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqistat0_print;
+aic_reg_print_t ahd_lqistat0_print;
 #else
-#define ahd_lqistat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQISTAT0", 0x50, regvalue, cur_col, wrap)
+#define ahd_lqistat0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LQISTAT0", 0x50, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqistat1_print;
+aic_reg_print_t ahd_lqistat1_print;
 #else
-#define ahd_lqistat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQISTAT1", 0x51, regvalue, cur_col, wrap)
+#define ahd_lqistat1_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LQISTAT1", 0x51, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqistat2_print;
+aic_reg_print_t ahd_lqistat2_print;
 #else
-#define ahd_lqistat2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQISTAT2", 0x52, regvalue, cur_col, wrap)
+#define ahd_lqistat2_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LQISTAT2", 0x52, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat3_print;
+aic_reg_print_t ahd_sstat3_print;
 #else
-#define ahd_sstat3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT3", 0x53, regvalue, cur_col, wrap)
+#define ahd_sstat3_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT3", 0x53, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqostat0_print;
+aic_reg_print_t ahd_lqostat0_print;
 #else
-#define ahd_lqostat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSTAT0", 0x54, regvalue, cur_col, wrap)
+#define ahd_lqostat0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LQOSTAT0", 0x54, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqostat1_print;
+aic_reg_print_t ahd_lqostat1_print;
 #else
-#define ahd_lqostat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSTAT1", 0x55, regvalue, cur_col, wrap)
+#define ahd_lqostat1_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LQOSTAT1", 0x55, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqostat2_print;
+aic_reg_print_t ahd_lqostat2_print;
 #else
-#define ahd_lqostat2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSTAT2", 0x56, regvalue, cur_col, wrap)
+#define ahd_lqostat2_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LQOSTAT2", 0x56, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_simode1_print;
+aic_reg_print_t ahd_simode1_print;
 #else
-#define ahd_simode1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SIMODE1", 0x57, regvalue, cur_col, wrap)
+#define ahd_simode1_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SIMODE1", 0x57, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dffsxfrctl_print;
+aic_reg_print_t ahd_dffsxfrctl_print;
 #else
-#define ahd_dffsxfrctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFFSXFRCTL", 0x5a, regvalue, cur_col, wrap)
+#define ahd_dffsxfrctl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "DFFSXFRCTL", 0x5a, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqintsrc_print;
+aic_reg_print_t ahd_seqintsrc_print;
 #else
-#define ahd_seqintsrc_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQINTSRC", 0x5b, regvalue, cur_col, wrap)
+#define ahd_seqintsrc_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQINTSRC", 0x5b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqimode_print;
+aic_reg_print_t ahd_seqimode_print;
 #else
-#define ahd_seqimode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQIMODE", 0x5c, regvalue, cur_col, wrap)
+#define ahd_seqimode_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQIMODE", 0x5c, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mdffstat_print;
+aic_reg_print_t ahd_mdffstat_print;
 #else
-#define ahd_mdffstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MDFFSTAT", 0x5d, regvalue, cur_col, wrap)
+#define ahd_mdffstat_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "MDFFSTAT", 0x5d, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seloid_print;
+aic_reg_print_t ahd_seloid_print;
 #else
-#define ahd_seloid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SELOID", 0x6b, regvalue, cur_col, wrap)
+#define ahd_seloid_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SELOID", 0x6b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sg_state_print;
+aic_reg_print_t ahd_sg_state_print;
 #else
-#define ahd_sg_state_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SG_STATE", 0xa6, regvalue, cur_col, wrap)
+#define ahd_sg_state_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SG_STATE", 0xa6, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbctl_print;
+aic_reg_print_t ahd_ccscbctl_print;
 #else
-#define ahd_ccscbctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBCTL", 0xad, regvalue, cur_col, wrap)
+#define ahd_ccscbctl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "CCSCBCTL", 0xad, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccsgctl_print;
+aic_reg_print_t ahd_ccsgctl_print;
 #else
-#define ahd_ccsgctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSGCTL", 0xad, regvalue, cur_col, wrap)
+#define ahd_ccsgctl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "CCSGCTL", 0xad, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqctl0_print;
+aic_reg_print_t ahd_seqctl0_print;
 #else
-#define ahd_seqctl0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQCTL0", 0xd6, regvalue, cur_col, wrap)
+#define ahd_seqctl0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQCTL0", 0xd6, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqintctl_print;
+aic_reg_print_t ahd_seqintctl_print;
 #else
-#define ahd_seqintctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQINTCTL", 0xd9, regvalue, cur_col, wrap)
+#define ahd_seqintctl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQINTCTL", 0xd9, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sram_base_print;
+aic_reg_print_t ahd_sram_base_print;
 #else
-#define ahd_sram_base_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SRAM_BASE", 0x100, regvalue, cur_col, wrap)
+#define ahd_sram_base_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SRAM_BASE", 0x100, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_qfreeze_count_print;
+aic_reg_print_t ahd_qfreeze_count_print;
 #else
-#define ahd_qfreeze_count_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "QFREEZE_COUNT", 0x132, regvalue, cur_col, wrap)
+#define ahd_qfreeze_count_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "QFREEZE_COUNT", 0x132, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_kernel_qfreeze_count_print;
+aic_reg_print_t ahd_kernel_qfreeze_count_print;
 #else
-#define ahd_kernel_qfreeze_count_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT", 0x134, regvalue, cur_col, wrap)
+#define ahd_kernel_qfreeze_count_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT", 0x134, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_saved_mode_print;
+aic_reg_print_t ahd_saved_mode_print;
 #else
-#define ahd_saved_mode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SAVED_MODE", 0x136, regvalue, cur_col, wrap)
+#define ahd_saved_mode_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SAVED_MODE", 0x136, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seq_flags_print;
+aic_reg_print_t ahd_seq_flags_print;
 #else
-#define ahd_seq_flags_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQ_FLAGS", 0x139, regvalue, cur_col, wrap)
+#define ahd_seq_flags_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQ_FLAGS", 0x139, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lastphase_print;
+aic_reg_print_t ahd_lastphase_print;
 #else
-#define ahd_lastphase_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LASTPHASE", 0x13c, regvalue, cur_col, wrap)
+#define ahd_lastphase_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LASTPHASE", 0x13c, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seq_flags2_print;
+aic_reg_print_t ahd_seq_flags2_print;
 #else
-#define ahd_seq_flags2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQ_FLAGS2", 0x14d, regvalue, cur_col, wrap)
+#define ahd_seq_flags2_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQ_FLAGS2", 0x14d, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mk_message_scb_print;
+aic_reg_print_t ahd_mk_message_scb_print;
 #else
-#define ahd_mk_message_scb_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MK_MESSAGE_SCB", 0x160, regvalue, cur_col, wrap)
+#define ahd_mk_message_scb_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "MK_MESSAGE_SCB", 0x160, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mk_message_scsiid_print;
+aic_reg_print_t ahd_mk_message_scsiid_print;
 #else
-#define ahd_mk_message_scsiid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID", 0x162, regvalue, cur_col, wrap)
+#define ahd_mk_message_scsiid_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "MK_MESSAGE_SCSIID", 0x162, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_base_print;
+aic_reg_print_t ahd_scb_base_print;
 #else
-#define ahd_scb_base_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_BASE", 0x180, regvalue, cur_col, wrap)
+#define ahd_scb_base_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_BASE", 0x180, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_control_print;
+aic_reg_print_t ahd_scb_control_print;
 #else
-#define ahd_scb_control_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_CONTROL", 0x192, regvalue, cur_col, wrap)
+#define ahd_scb_control_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_CONTROL", 0x192, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_scsiid_print;
+aic_reg_print_t ahd_scb_scsiid_print;
 #else
-#define ahd_scb_scsiid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_SCSIID", 0x193, regvalue, cur_col, wrap)
+#define ahd_scb_scsiid_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_SCSIID", 0x193, regvalue, buf)
 #endif
 
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped b/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
index 2e0c58905b9e..0f8e47a5169d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
+++ b/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
@@ -8,7 +8,7 @@
 
 #include "aic79xx_osm.h"
 
-static const ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
+static const aic_reg_parse_entry_t INTSTAT_parse_table[] = {
 	{ "SPLTINT",		0x01, 0x01 },
 	{ "CMDCMPLT",		0x02, 0x02 },
 	{ "SEQINT",		0x04, 0x04 },
@@ -20,26 +20,26 @@ static const ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
 	{ "INT_PEND",		0xff, 0xff }
 };
 
-int
-ahd_intstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_intstat_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(INTSTAT_parse_table, 9, "INTSTAT",
-	    0x01, regvalue, cur_col, wrap));
+	aic_print_register(INTSTAT_parse_table, 9, "INTSTAT",
+			   0x01, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
+static const aic_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
 	{ "ENINT_COALESCE",	0x40, 0x40 },
 	{ "HOST_TQINPOS",	0x80, 0x80 }
 };
 
-int
-ahd_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_hs_mailbox_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(HS_MAILBOX_parse_table, 2, "HS_MAILBOX",
-	    0x0b, regvalue, cur_col, wrap));
+	aic_print_register(HS_MAILBOX_parse_table, 2, "HS_MAILBOX",
+			   0x0b, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
+static const aic_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
 	{ "SEQ_SPLTINT",	0x01, 0x01 },
 	{ "SEQ_PCIINT",		0x02, 0x02 },
 	{ "SEQ_SCSIINT",	0x04, 0x04 },
@@ -47,14 +47,14 @@ static const ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
 	{ "SEQ_SWTMRTO",	0x10, 0x10 }
 };
 
-int
-ahd_seqintstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seqintstat_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SEQINTSTAT_parse_table, 5, "SEQINTSTAT",
-	    0x0c, regvalue, cur_col, wrap));
+	aic_print_register(SEQINTSTAT_parse_table, 5, "SEQINTSTAT",
+			   0x0c, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t INTCTL_parse_table[] = {
+static const aic_reg_parse_entry_t INTCTL_parse_table[] = {
 	{ "SPLTINTEN",		0x01, 0x01 },
 	{ "SEQINTEN",		0x02, 0x02 },
 	{ "SCSIINTEN",		0x04, 0x04 },
@@ -65,14 +65,14 @@ static const ahd_reg_parse_entry_t INTCTL_parse_table[] = {
 	{ "SWTMINTMASK",	0x80, 0x80 }
 };
 
-int
-ahd_intctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_intctl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(INTCTL_parse_table, 8, "INTCTL",
-	    0x18, regvalue, cur_col, wrap));
+	aic_print_register(INTCTL_parse_table, 8, "INTCTL",
+			   0x18, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
+static const aic_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "DIRECTIONEN",	0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "FIFOFLUSHACK",	0x02, 0x02 },
@@ -86,14 +86,14 @@ static const ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "PRELOADEN",		0x80, 0x80 }
 };
 
-int
-ahd_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_dfcntrl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(DFCNTRL_parse_table, 11, "DFCNTRL",
-	    0x19, regvalue, cur_col, wrap));
+	aic_print_register(DFCNTRL_parse_table, 11, "DFCNTRL",
+			   0x19, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
+static const aic_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "FIFOEMP",		0x01, 0x01 },
 	{ "FIFOFULL",		0x02, 0x02 },
 	{ "DFTHRESH",		0x04, 0x04 },
@@ -103,28 +103,28 @@ static const ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "PRELOAD_AVAIL",	0x80, 0x80 }
 };
 
-int
-ahd_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_dfstatus_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(DFSTATUS_parse_table, 7, "DFSTATUS",
-	    0x1a, regvalue, cur_col, wrap));
+	aic_print_register(DFSTATUS_parse_table, 7, "DFSTATUS",
+			   0x1a, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
+static const aic_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
 	{ "LAST_SEG_DONE",	0x01, 0x01 },
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "ODD_SEG",		0x04, 0x04 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
 };
 
-int
-ahd_sg_cache_shadow_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_sg_cache_shadow_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SG_CACHE_SHADOW_parse_table, 4, "SG_CACHE_SHADOW",
-	    0x1b, regvalue, cur_col, wrap));
+	aic_print_register(SG_CACHE_SHADOW_parse_table, 4, "SG_CACHE_SHADOW",
+			   0x1b, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SCSISEQ0_parse_table[] = {
+static const aic_reg_parse_entry_t SCSISEQ0_parse_table[] = {
 	{ "SCSIRSTO",		0x01, 0x01 },
 	{ "FORCEBUSFREE",	0x10, 0x10 },
 	{ "ENARBO",		0x20, 0x20 },
@@ -132,14 +132,14 @@ static const ahd_reg_parse_entry_t SCSISEQ0_parse_table[] = {
 	{ "TEMODEO",		0x80, 0x80 }
 };
 
-int
-ahd_scsiseq0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scsiseq0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SCSISEQ0_parse_table, 5, "SCSISEQ0",
-	    0x3a, regvalue, cur_col, wrap));
+	aic_print_register(SCSISEQ0_parse_table, 5, "SCSISEQ0",
+			   0x3a, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
+static const aic_reg_parse_entry_t SCSISEQ1_parse_table[] = {
 	{ "ALTSTIM",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "MANUALP",		0x0c, 0x0c },
@@ -148,14 +148,14 @@ static const ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
 	{ "MANUALCTL",		0x40, 0x40 }
 };
 
-int
-ahd_scsiseq1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scsiseq1_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SCSISEQ1_parse_table, 6, "SCSISEQ1",
-	    0x3b, regvalue, cur_col, wrap));
+	aic_print_register(SCSISEQ1_parse_table, 6, "SCSISEQ1",
+			   0x3b, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t DFFSTAT_parse_table[] = {
+static const aic_reg_parse_entry_t DFFSTAT_parse_table[] = {
 	{ "CURRFIFO_0",		0x00, 0x03 },
 	{ "CURRFIFO_1",		0x01, 0x03 },
 	{ "CURRFIFO_NONE",	0x03, 0x03 },
@@ -164,14 +164,14 @@ static const ahd_reg_parse_entry_t DFFSTAT_parse_table[] = {
 	{ "CURRFIFO",		0x03, 0x03 }
 };
 
-int
-ahd_dffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_dffstat_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(DFFSTAT_parse_table, 6, "DFFSTAT",
-	    0x3f, regvalue, cur_col, wrap));
+	aic_print_register(DFFSTAT_parse_table, 6, "DFFSTAT",
+			   0x3f, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
+static const aic_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
@@ -191,14 +191,14 @@ static const ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "PHASE_MASK",		0xe0, 0xe0 }
 };
 
-int
-ahd_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scsisigi_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
-	    0x41, regvalue, cur_col, wrap));
+	aic_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
+			   0x41, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+static const aic_reg_parse_entry_t SCSIPHASE_parse_table[] = {
 	{ "DATA_OUT_PHASE",	0x01, 0x03 },
 	{ "DATA_IN_PHASE",	0x02, 0x03 },
 	{ "DATA_PHASE_MASK",	0x03, 0x03 },
@@ -208,33 +208,33 @@ static const ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
 	{ "STATUS_PHASE",	0x20, 0x20 }
 };
 
-int
-ahd_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scsiphase_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
-	    0x42, regvalue, cur_col, wrap));
+	aic_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
+			   0x42, regvalue, buf);
 }
 
-int
-ahd_scsibus_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scsibus_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "SCSIBUS",
-	    0x46, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SCSIBUS",
+			   0x46, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SELID_parse_table[] = {
+static const aic_reg_parse_entry_t SELID_parse_table[] = {
 	{ "ONEBIT",		0x08, 0x08 },
 	{ "SELID_MASK",		0xf0, 0xf0 }
 };
 
-int
-ahd_selid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_selid_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SELID_parse_table, 2, "SELID",
-	    0x49, regvalue, cur_col, wrap));
+	aic_print_register(SELID_parse_table, 2, "SELID",
+			   0x49, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
+static const aic_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENARBDO",		0x01, 0x01 },
 	{ "ENSPIORDY",		0x02, 0x02 },
 	{ "ENOVERRUN",		0x04, 0x04 },
@@ -244,14 +244,14 @@ static const ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENSELDO",		0x40, 0x40 }
 };
 
-int
-ahd_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_simode0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SIMODE0_parse_table, 7, "SIMODE0",
-	    0x4b, regvalue, cur_col, wrap));
+	aic_print_register(SIMODE0_parse_table, 7, "SIMODE0",
+			   0x4b, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SSTAT0_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "ARBDO",		0x01, 0x01 },
 	{ "SPIORDY",		0x02, 0x02 },
 	{ "OVERRUN",		0x04, 0x04 },
@@ -262,14 +262,14 @@ static const ahd_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "TARGET",		0x80, 0x80 }
 };
 
-int
-ahd_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_sstat0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SSTAT0_parse_table, 8, "SSTAT0",
-	    0x4b, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT0_parse_table, 8, "SSTAT0",
+			   0x4b, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "STRB2FAST",		0x02, 0x02 },
 	{ "SCSIPERR",		0x04, 0x04 },
@@ -280,14 +280,14 @@ static const ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "SELTO",		0x80, 0x80 }
 };
 
-int
-ahd_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_sstat1_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SSTAT1_parse_table, 8, "SSTAT1",
-	    0x4c, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT1_parse_table, 8, "SSTAT1",
+			   0x4c, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "BUSFREE_LQO",	0x40, 0xc0 },
 	{ "BUSFREE_DFF0",	0x80, 0xc0 },
 	{ "BUSFREE_DFF1",	0xc0, 0xc0 },
@@ -300,14 +300,14 @@ static const ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "BUSFREETIME",	0xc0, 0xc0 }
 };
 
-int
-ahd_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_sstat2_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SSTAT2_parse_table, 10, "SSTAT2",
-	    0x4d, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT2_parse_table, 10, "SSTAT2",
+			   0x4d, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
+static const aic_reg_parse_entry_t PERRDIAG_parse_table[] = {
 	{ "DTERR",		0x01, 0x01 },
 	{ "DGFORMERR",		0x02, 0x02 },
 	{ "CRCERR",		0x04, 0x04 },
@@ -318,21 +318,21 @@ static const ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
 	{ "HIZERO",		0x80, 0x80 }
 };
 
-int
-ahd_perrdiag_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_perrdiag_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(PERRDIAG_parse_table, 8, "PERRDIAG",
-	    0x4e, regvalue, cur_col, wrap));
+	aic_print_register(PERRDIAG_parse_table, 8, "PERRDIAG",
+			   0x4e, regvalue, buf);
 }
 
-int
-ahd_soffcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_soffcnt_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "SOFFCNT",
-	    0x4f, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SOFFCNT",
+			   0x4f, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
+static const aic_reg_parse_entry_t LQISTAT0_parse_table[] = {
 	{ "LQIATNCMD",		0x01, 0x01 },
 	{ "LQIATNLQ",		0x02, 0x02 },
 	{ "LQIBADLQT",		0x04, 0x04 },
@@ -341,14 +341,14 @@ static const ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
 	{ "LQIATNQAS",		0x20, 0x20 }
 };
 
-int
-ahd_lqistat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_lqistat0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(LQISTAT0_parse_table, 6, "LQISTAT0",
-	    0x50, regvalue, cur_col, wrap));
+	aic_print_register(LQISTAT0_parse_table, 6, "LQISTAT0",
+			   0x50, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
+static const aic_reg_parse_entry_t LQISTAT1_parse_table[] = {
 	{ "LQIOVERI_NLQ",	0x01, 0x01 },
 	{ "LQIOVERI_LQ",	0x02, 0x02 },
 	{ "LQIBADLQI",		0x04, 0x04 },
@@ -359,14 +359,14 @@ static const ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
 	{ "LQIPHASE_LQ",	0x80, 0x80 }
 };
 
-int
-ahd_lqistat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_lqistat1_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(LQISTAT1_parse_table, 8, "LQISTAT1",
-	    0x51, regvalue, cur_col, wrap));
+	aic_print_register(LQISTAT1_parse_table, 8, "LQISTAT1",
+			   0x51, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
+static const aic_reg_parse_entry_t LQISTAT2_parse_table[] = {
 	{ "LQIGSAVAIL",		0x01, 0x01 },
 	{ "LQISTOPCMD",		0x02, 0x02 },
 	{ "LQISTOPLQ",		0x04, 0x04 },
@@ -377,26 +377,26 @@ static const ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
 	{ "PACKETIZED",		0x80, 0x80 }
 };
 
-int
-ahd_lqistat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_lqistat2_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(LQISTAT2_parse_table, 8, "LQISTAT2",
-	    0x52, regvalue, cur_col, wrap));
+	aic_print_register(LQISTAT2_parse_table, 8, "LQISTAT2",
+			   0x52, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SSTAT3_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT3_parse_table[] = {
 	{ "OSRAMPERR",		0x01, 0x01 },
 	{ "NTRAMPERR",		0x02, 0x02 }
 };
 
-int
-ahd_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_sstat3_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SSTAT3_parse_table, 2, "SSTAT3",
-	    0x53, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT3_parse_table, 2, "SSTAT3",
+			   0x53, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
+static const aic_reg_parse_entry_t LQOSTAT0_parse_table[] = {
 	{ "LQOTCRC",		0x01, 0x01 },
 	{ "LQOATNPKT",		0x02, 0x02 },
 	{ "LQOATNLQ",		0x04, 0x04 },
@@ -404,14 +404,14 @@ static const ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
 	{ "LQOTARGSCBPERR",	0x10, 0x10 }
 };
 
-int
-ahd_lqostat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_lqostat0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(LQOSTAT0_parse_table, 5, "LQOSTAT0",
-	    0x54, regvalue, cur_col, wrap));
+	aic_print_register(LQOSTAT0_parse_table, 5, "LQOSTAT0",
+			   0x54, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
+static const aic_reg_parse_entry_t LQOSTAT1_parse_table[] = {
 	{ "LQOPHACHGINPKT",	0x01, 0x01 },
 	{ "LQOBUSFREE",		0x02, 0x02 },
 	{ "LQOBADQAS",		0x04, 0x04 },
@@ -419,28 +419,28 @@ static const ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
 	{ "LQOINITSCBPERR",	0x10, 0x10 }
 };
 
-int
-ahd_lqostat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_lqostat1_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(LQOSTAT1_parse_table, 5, "LQOSTAT1",
-	    0x55, regvalue, cur_col, wrap));
+	aic_print_register(LQOSTAT1_parse_table, 5, "LQOSTAT1",
+			   0x55, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
+static const aic_reg_parse_entry_t LQOSTAT2_parse_table[] = {
 	{ "LQOSTOP0",		0x01, 0x01 },
 	{ "LQOPHACHGOUTPKT",	0x02, 0x02 },
 	{ "LQOWAITFIFO",	0x10, 0x10 },
 	{ "LQOPKT",		0xe0, 0xe0 }
 };
 
-int
-ahd_lqostat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_lqostat2_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(LQOSTAT2_parse_table, 4, "LQOSTAT2",
-	    0x56, regvalue, cur_col, wrap));
+	aic_print_register(LQOSTAT2_parse_table, 4, "LQOSTAT2",
+			   0x56, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
+static const aic_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENREQINIT",		0x01, 0x01 },
 	{ "ENSTRB2FAST",	0x02, 0x02 },
 	{ "ENSCSIPERR",		0x04, 0x04 },
@@ -451,28 +451,28 @@ static const ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENSELTIMO",		0x80, 0x80 }
 };
 
-int
-ahd_simode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_simode1_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SIMODE1_parse_table, 8, "SIMODE1",
-	    0x57, regvalue, cur_col, wrap));
+	aic_print_register(SIMODE1_parse_table, 8, "SIMODE1",
+			   0x57, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
+static const aic_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
 	{ "RSTCHN",		0x01, 0x01 },
 	{ "CLRCHN",		0x02, 0x02 },
 	{ "CLRSHCNT",		0x04, 0x04 },
 	{ "DFFBITBUCKET",	0x08, 0x08 }
 };
 
-int
-ahd_dffsxfrctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_dffsxfrctl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(DFFSXFRCTL_parse_table, 4, "DFFSXFRCTL",
-	    0x5a, regvalue, cur_col, wrap));
+	aic_print_register(DFFSXFRCTL_parse_table, 4, "DFFSXFRCTL",
+			   0x5a, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
+static const aic_reg_parse_entry_t SEQINTSRC_parse_table[] = {
 	{ "CFG4TCMD",		0x01, 0x01 },
 	{ "CFG4ICMD",		0x02, 0x02 },
 	{ "CFG4TSTAT",		0x04, 0x04 },
@@ -482,14 +482,14 @@ static const ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
 	{ "CTXTDONE",		0x40, 0x40 }
 };
 
-int
-ahd_seqintsrc_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seqintsrc_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SEQINTSRC_parse_table, 7, "SEQINTSRC",
-	    0x5b, regvalue, cur_col, wrap));
+	aic_print_register(SEQINTSRC_parse_table, 7, "SEQINTSRC",
+			   0x5b, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SEQIMODE_parse_table[] = {
+static const aic_reg_parse_entry_t SEQIMODE_parse_table[] = {
 	{ "ENCFG4TCMD",		0x01, 0x01 },
 	{ "ENCFG4ICMD",		0x02, 0x02 },
 	{ "ENCFG4TSTAT",	0x04, 0x04 },
@@ -499,14 +499,14 @@ static const ahd_reg_parse_entry_t SEQIMODE_parse_table[] = {
 	{ "ENCTXTDONE",		0x40, 0x40 }
 };
 
-int
-ahd_seqimode_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seqimode_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SEQIMODE_parse_table, 7, "SEQIMODE",
-	    0x5c, regvalue, cur_col, wrap));
+	aic_print_register(SEQIMODE_parse_table, 7, "SEQIMODE",
+			   0x5c, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
+static const aic_reg_parse_entry_t MDFFSTAT_parse_table[] = {
 	{ "FIFOFREE",		0x01, 0x01 },
 	{ "DATAINFIFO",		0x02, 0x02 },
 	{ "DLZERO",		0x04, 0x04 },
@@ -516,34 +516,34 @@ static const ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
 	{ "SHCNTNEGATIVE",	0x40, 0x40 }
 };
 
-int
-ahd_mdffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_mdffstat_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(MDFFSTAT_parse_table, 7, "MDFFSTAT",
-	    0x5d, regvalue, cur_col, wrap));
+	aic_print_register(MDFFSTAT_parse_table, 7, "MDFFSTAT",
+			   0x5d, regvalue, buf);
 }
 
-int
-ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seloid_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "SELOID",
-	    0x6b, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SELOID",
+			   0x6b, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
+static const aic_reg_parse_entry_t SG_STATE_parse_table[] = {
 	{ "SEGS_AVAIL",		0x01, 0x01 },
 	{ "LOADING_NEEDED",	0x02, 0x02 },
 	{ "FETCH_INPROG",	0x04, 0x04 }
 };
 
-int
-ahd_sg_state_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_sg_state_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SG_STATE_parse_table, 3, "SG_STATE",
-	    0xa6, regvalue, cur_col, wrap));
+	aic_print_register(SG_STATE_parse_table, 3, "SG_STATE",
+			   0xa6, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
+static const aic_reg_parse_entry_t CCSCBCTL_parse_table[] = {
 	{ "CCSCBRESET",		0x01, 0x01 },
 	{ "CCSCBDIR",		0x04, 0x04 },
 	{ "CCSCBEN",		0x08, 0x08 },
@@ -552,14 +552,14 @@ static const ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
 	{ "CCSCBDONE",		0x80, 0x80 }
 };
 
-int
-ahd_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_ccscbctl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
-	    0xad, regvalue, cur_col, wrap));
+	aic_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
+			   0xad, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
+static const aic_reg_parse_entry_t CCSGCTL_parse_table[] = {
 	{ "CCSGRESET",		0x01, 0x01 },
 	{ "SG_FETCH_REQ",	0x02, 0x02 },
 	{ "CCSGENACK",		0x08, 0x08 },
@@ -568,14 +568,14 @@ static const ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
 	{ "CCSGEN",		0x0c, 0x0c }
 };
 
-int
-ahd_ccsgctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_ccsgctl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(CCSGCTL_parse_table, 6, "CCSGCTL",
-	    0xad, regvalue, cur_col, wrap));
+	aic_print_register(CCSGCTL_parse_table, 6, "CCSGCTL",
+			   0xad, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
+static const aic_reg_parse_entry_t SEQCTL0_parse_table[] = {
 	{ "LOADRAM",		0x01, 0x01 },
 	{ "SEQRESET",		0x02, 0x02 },
 	{ "STEP",		0x04, 0x04 },
@@ -586,14 +586,14 @@ static const ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
 	{ "PERRORDIS",		0x80, 0x80 }
 };
 
-int
-ahd_seqctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seqctl0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SEQCTL0_parse_table, 8, "SEQCTL0",
-	    0xd6, regvalue, cur_col, wrap));
+	aic_print_register(SEQCTL0_parse_table, 8, "SEQCTL0",
+			   0xd6, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
+static const aic_reg_parse_entry_t SEQINTCTL_parse_table[] = {
 	{ "IRET",		0x01, 0x01 },
 	{ "INTMASK1",		0x02, 0x02 },
 	{ "INTMASK2",		0x04, 0x04 },
@@ -603,42 +603,42 @@ static const ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
 	{ "INTVEC1DSL",		0x80, 0x80 }
 };
 
-int
-ahd_seqintctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seqintctl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SEQINTCTL_parse_table, 7, "SEQINTCTL",
-	    0xd9, regvalue, cur_col, wrap));
+	aic_print_register(SEQINTCTL_parse_table, 7, "SEQINTCTL",
+			   0xd9, regvalue, buf);
 }
 
-int
-ahd_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_sram_base_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "SRAM_BASE",
-	    0x100, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SRAM_BASE",
+			   0x100, regvalue, buf);
 }
 
-int
-ahd_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_qfreeze_count_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "QFREEZE_COUNT",
-	    0x132, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "QFREEZE_COUNT",
+			   0x132, regvalue, buf);
 }
 
-int
-ahd_kernel_qfreeze_count_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_kernel_qfreeze_count_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT",
-	    0x134, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "KERNEL_QFREEZE_COUNT",
+			   0x134, regvalue, buf);
 }
 
-int
-ahd_saved_mode_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_saved_mode_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "SAVED_MODE",
-	    0x136, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SAVED_MODE",
+			   0x136, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+static const aic_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NO_DISCONNECT",	0x01, 0x01 },
 	{ "SPHASE_PENDING",	0x02, 0x02 },
 	{ "DPHASE_PENDING",	0x04, 0x04 },
@@ -650,14 +650,14 @@ static const ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NOT_IDENTIFIED",	0x80, 0x80 }
 };
 
-int
-ahd_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seq_flags_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
-	    0x139, regvalue, cur_col, wrap));
+	aic_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
+			   0x139, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
+static const aic_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
@@ -673,48 +673,48 @@ static const ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "PHASE_MASK",		0xe0, 0xe0 }
 };
 
-int
-ahd_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_lastphase_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(LASTPHASE_parse_table, 13, "LASTPHASE",
-	    0x13c, regvalue, cur_col, wrap));
+	aic_print_register(LASTPHASE_parse_table, 13, "LASTPHASE",
+			   0x13c, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+static const aic_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
 	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
 	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
 	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
 };
 
-int
-ahd_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_seq_flags2_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SEQ_FLAGS2_parse_table, 3, "SEQ_FLAGS2",
-	    0x14d, regvalue, cur_col, wrap));
+	aic_print_register(SEQ_FLAGS2_parse_table, 3, "SEQ_FLAGS2",
+			   0x14d, regvalue, buf);
 }
 
-int
-ahd_mk_message_scb_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_mk_message_scb_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCB",
-	    0x160, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "MK_MESSAGE_SCB",
+			   0x160, regvalue, buf);
 }
 
-int
-ahd_mk_message_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_mk_message_scsiid_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "MK_MESSAGE_SCSIID",
-	    0x162, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "MK_MESSAGE_SCSIID",
+			   0x162, regvalue, buf);
 }
 
-int
-ahd_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scb_base_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(NULL, 0, "SCB_BASE",
-	    0x180, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SCB_BASE",
+			   0x180, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+static const aic_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "SCB_TAG_TYPE",	0x03, 0x03 },
 	{ "DISCONNECTED",	0x04, 0x04 },
 	{ "STATUS_RCVD",	0x08, 0x08 },
@@ -724,22 +724,22 @@ static const ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "TARGET_SCB",		0x80, 0x80 }
 };
 
-int
-ahd_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scb_control_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SCB_CONTROL_parse_table, 7, "SCB_CONTROL",
-	    0x192, regvalue, cur_col, wrap));
+	aic_print_register(SCB_CONTROL_parse_table, 7, "SCB_CONTROL",
+			   0x192, regvalue, buf);
 }
 
-static const ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+static const aic_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
 	{ "OID",		0x0f, 0x0f },
 	{ "TID",		0xf0, 0xf0 }
 };
 
-int
-ahd_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahd_scb_scsiid_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahd_print_register(SCB_SCSIID_parse_table, 2, "SCB_SCSIID",
-	    0x193, regvalue, cur_col, wrap));
+	aic_print_register(SCB_SCSIID_parse_table, 2, "SCB_SCSIID",
+			   0x193, regvalue, buf);
 }
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index 4ce4e903a759..bdf902a3b7be 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1270,13 +1270,6 @@ extern uint32_t ahc_debug;
 void			ahc_print_devinfo(struct ahc_softc *ahc,
 					  struct ahc_devinfo *dev);
 void			ahc_dump_card_state(struct ahc_softc *ahc);
-int			ahc_print_register(const ahc_reg_parse_entry_t *table,
-					   u_int num_entries,
-					   const char *name,
-					   u_int address,
-					   u_int value,
-					   u_int *cur_column,
-					   u_int wrap_point);
 /******************************* SEEPROM *************************************/
 int		ahc_acquire_seeprom(struct ahc_softc *ahc,
 				    struct seeprom_descriptor *sd);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 381846164003..b0e66707fef7 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -7116,60 +7116,12 @@ ahc_download_instr(struct ahc_softc *ahc, u_int instrptr, uint8_t *dconsts)
 	}
 }
 
-int
-ahc_print_register(const ahc_reg_parse_entry_t *table, u_int num_entries,
-		   const char *name, u_int address, u_int value,
-		   u_int *cur_column, u_int wrap_point)
-{
-	int	printed;
-	u_int	printed_mask;
-
-	if (cur_column != NULL && *cur_column >= wrap_point) {
-		printk("\n");
-		*cur_column = 0;
-	}
-	printed  = printk("%s[0x%x]", name, value);
-	if (table == NULL) {
-		printed += printk(" ");
-		*cur_column += printed;
-		return (printed);
-	}
-	printed_mask = 0;
-	while (printed_mask != 0xFF) {
-		int entry;
-
-		for (entry = 0; entry < num_entries; entry++) {
-			if (((value & table[entry].mask)
-			  != table[entry].value)
-			 || ((printed_mask & table[entry].mask)
-			  == table[entry].mask))
-				continue;
-
-			printed += printk("%s%s",
-					  printed_mask == 0 ? ":(" : "|",
-					  table[entry].name);
-			printed_mask |= table[entry].mask;
-			
-			break;
-		}
-		if (entry >= num_entries)
-			break;
-	}
-	if (printed_mask != 0)
-		printed += printk(") ");
-	else
-		printed += printk(" ");
-	if (cur_column != NULL)
-		*cur_column += printed;
-	return (printed);
-}
-
 void
 ahc_dump_card_state(struct ahc_softc *ahc)
 {
+	struct aic_dump_buffer buf;
 	struct	scb *scb;
 	struct	scb_tailq *untagged_q;
-	u_int	cur_col;
 	int	paused;
 	int	target;
 	int	maxtarget;
@@ -7201,37 +7153,39 @@ ahc_dump_card_state(struct ahc_softc *ahc)
 	       ahc_inb(ahc, ARG_2));
 	printk("HCNT = 0x%x SCBPTR = 0x%x\n", ahc_inb(ahc, HCNT),
 	       ahc_inb(ahc, SCBPTR));
-	cur_col = 0;
+
+	aic_printbuf_init(&buf, 60);
 	if ((ahc->features & AHC_DT) != 0)
-		ahc_scsiphase_print(ahc_inb(ahc, SCSIPHASE), &cur_col, 50);
-	ahc_scsisigi_print(ahc_inb(ahc, SCSISIGI), &cur_col, 50);
-	ahc_error_print(ahc_inb(ahc, ERROR), &cur_col, 50);
-	ahc_scsibusl_print(ahc_inb(ahc, SCSIBUSL), &cur_col, 50);
-	ahc_lastphase_print(ahc_inb(ahc, LASTPHASE), &cur_col, 50);
-	ahc_scsiseq_print(ahc_inb(ahc, SCSISEQ), &cur_col, 50);
-	ahc_sblkctl_print(ahc_inb(ahc, SBLKCTL), &cur_col, 50);
-	ahc_scsirate_print(ahc_inb(ahc, SCSIRATE), &cur_col, 50);
-	ahc_seqctl_print(ahc_inb(ahc, SEQCTL), &cur_col, 50);
-	ahc_seq_flags_print(ahc_inb(ahc, SEQ_FLAGS), &cur_col, 50);
-	ahc_sstat0_print(ahc_inb(ahc, SSTAT0), &cur_col, 50);
-	ahc_sstat1_print(ahc_inb(ahc, SSTAT1), &cur_col, 50);
-	ahc_sstat2_print(ahc_inb(ahc, SSTAT2), &cur_col, 50);
-	ahc_sstat3_print(ahc_inb(ahc, SSTAT3), &cur_col, 50);
-	ahc_simode0_print(ahc_inb(ahc, SIMODE0), &cur_col, 50);
-	ahc_simode1_print(ahc_inb(ahc, SIMODE1), &cur_col, 50);
-	ahc_sxfrctl0_print(ahc_inb(ahc, SXFRCTL0), &cur_col, 50);
-	ahc_dfcntrl_print(ahc_inb(ahc, DFCNTRL), &cur_col, 50);
-	ahc_dfstatus_print(ahc_inb(ahc, DFSTATUS), &cur_col, 50);
-	if (cur_col != 0)
-		printk("\n");
-	printk("STACK:");
+		ahc_scsiphase_print(ahc_inb(ahc, SCSIPHASE), &buf);
+	ahc_scsisigi_print(ahc_inb(ahc, SCSISIGI), &buf);
+	ahc_error_print(ahc_inb(ahc, ERROR), &buf);
+	ahc_scsibusl_print(ahc_inb(ahc, SCSIBUSL), &buf);
+	ahc_lastphase_print(ahc_inb(ahc, LASTPHASE), &buf);
+	ahc_scsiseq_print(ahc_inb(ahc, SCSISEQ), &buf);
+	ahc_sblkctl_print(ahc_inb(ahc, SBLKCTL), &buf);
+	ahc_scsirate_print(ahc_inb(ahc, SCSIRATE), &buf);
+	ahc_seqctl_print(ahc_inb(ahc, SEQCTL), &buf);
+	ahc_seq_flags_print(ahc_inb(ahc, SEQ_FLAGS), &buf);
+	ahc_sstat0_print(ahc_inb(ahc, SSTAT0), &buf);
+	ahc_sstat1_print(ahc_inb(ahc, SSTAT1), &buf);
+	ahc_sstat2_print(ahc_inb(ahc, SSTAT2), &buf);
+	ahc_sstat3_print(ahc_inb(ahc, SSTAT3), &buf);
+	ahc_simode0_print(ahc_inb(ahc, SIMODE0), &buf);
+	ahc_simode1_print(ahc_inb(ahc, SIMODE1), &buf);
+	ahc_sxfrctl0_print(ahc_inb(ahc, SXFRCTL0), &buf);
+	ahc_dfcntrl_print(ahc_inb(ahc, DFCNTRL), &buf);
+	ahc_dfstatus_print(ahc_inb(ahc, DFSTATUS), &buf);
+	aic_printbuf_finish(&buf);
+	aic_printbuf_push(&buf, "STACK:");
 	for (i = 0; i < STACK_SIZE; i++)
-		printk(" 0x%x", ahc_inb(ahc, STACK)|(ahc_inb(ahc, STACK) << 8));
+		aic_printbuf_push(&buf, " 0x%x",
+				  ahc_inb(ahc, STACK)|(ahc_inb(ahc, STACK) << 8));
+	aic_printbuf_finish(&buf);
 	printk("\nSCB count = %d\n", ahc->scb_data->numscbs);
 	printk("Kernel NEXTQSCB = %d\n", ahc->next_queued_scb->hscb->tag);
 	printk("Card NEXTQSCB = %d\n", ahc_inb(ahc, NEXT_QUEUED_SCB));
 	/* QINFIFO */
-	printk("QINFIFO entries: ");
+	aic_printbuf_push(&buf, "QINFIFO entries: ");
 	if ((ahc->features & AHC_QUEUE_REGS) != 0) {
 		qinpos = ahc_inb(ahc, SNSCB_QOFF);
 		ahc_outb(ahc, SNSCB_QOFF, qinpos);
@@ -7239,105 +7193,104 @@ ahc_dump_card_state(struct ahc_softc *ahc)
 		qinpos = ahc_inb(ahc, QINPOS);
 	qintail = ahc->qinfifonext;
 	while (qinpos != qintail) {
-		printk("%d ", ahc->qinfifo[qinpos]);
+		aic_printbuf_push(&buf, "%d ", ahc->qinfifo[qinpos]);
 		qinpos++;
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
-	printk("Waiting Queue entries: ");
+	aic_printbuf_push(&buf, "Waiting Queue entries: ");
 	scb_index = ahc_inb(ahc, WAITING_SCBH);
 	i = 0;
 	while (scb_index != SCB_LIST_NULL && i++ < 256) {
 		ahc_outb(ahc, SCBPTR, scb_index);
-		printk("%d:%d ", scb_index, ahc_inb(ahc, SCB_TAG));
+		aic_printbuf_push(&buf, "%d:%d ", scb_index,
+				  ahc_inb(ahc, SCB_TAG));
 		scb_index = ahc_inb(ahc, SCB_NEXT);
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
-	printk("Disconnected Queue entries: ");
+	aic_printbuf_push(&buf, "Disconnected Queue entries: ");
 	scb_index = ahc_inb(ahc, DISCONNECTED_SCBH);
 	i = 0;
 	while (scb_index != SCB_LIST_NULL && i++ < 256) {
 		ahc_outb(ahc, SCBPTR, scb_index);
-		printk("%d:%d ", scb_index, ahc_inb(ahc, SCB_TAG));
+		aic_printbuf_push(&buf, "%d:%d ", scb_index, ahc_inb(ahc, SCB_TAG));
 		scb_index = ahc_inb(ahc, SCB_NEXT);
 	}
-	printk("\n");
-		
+	aic_printbuf_finish(&buf);
+
 	ahc_sync_qoutfifo(ahc, BUS_DMASYNC_POSTREAD);
-	printk("QOUTFIFO entries: ");
+	aic_printbuf_push(&buf, "QOUTFIFO entries: ");
 	qoutpos = ahc->qoutfifonext;
 	i = 0;
 	while (ahc->qoutfifo[qoutpos] != SCB_LIST_NULL && i++ < 256) {
-		printk("%d ", ahc->qoutfifo[qoutpos]);
+		aic_printbuf_push(&buf, "%d ", ahc->qoutfifo[qoutpos]);
 		qoutpos++;
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
-	printk("Sequencer Free SCB List: ");
+	aic_printbuf_push(&buf, "Sequencer Free SCB List: ");
 	scb_index = ahc_inb(ahc, FREE_SCBH);
 	i = 0;
 	while (scb_index != SCB_LIST_NULL && i++ < 256) {
 		ahc_outb(ahc, SCBPTR, scb_index);
-		printk("%d ", scb_index);
+		aic_printbuf_push(&buf, "%d ", scb_index);
 		scb_index = ahc_inb(ahc, SCB_NEXT);
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
-	printk("Sequencer SCB Info: ");
+	printk("Sequencer SCB Info:\n");
 	for (i = 0; i < ahc->scb_data->maxhscbs; i++) {
 		ahc_outb(ahc, SCBPTR, i);
-		cur_col  = printk("\n%3d ", i);
-
-		ahc_scb_control_print(ahc_inb(ahc, SCB_CONTROL), &cur_col, 60);
-		ahc_scb_scsiid_print(ahc_inb(ahc, SCB_SCSIID), &cur_col, 60);
-		ahc_scb_lun_print(ahc_inb(ahc, SCB_LUN), &cur_col, 60);
-		ahc_scb_tag_print(ahc_inb(ahc, SCB_TAG), &cur_col, 60);
+		aic_printbuf_push(&buf, "%3d ", i);
+		ahc_scb_control_print(ahc_inb(ahc, SCB_CONTROL), &buf);
+		ahc_scb_scsiid_print(ahc_inb(ahc, SCB_SCSIID), &buf);
+		ahc_scb_lun_print(ahc_inb(ahc, SCB_LUN), &buf);
+		ahc_scb_tag_print(ahc_inb(ahc, SCB_TAG), &buf);
+		aic_printbuf_finish(&buf);
 	}
-	printk("\n");
 
-	printk("Pending list: ");
+	printk("Pending list:\n");
 	i = 0;
 	LIST_FOREACH(scb, &ahc->pending_scbs, pending_links) {
 		if (i++ > 256)
 			break;
-		cur_col  = printk("\n%3d ", scb->hscb->tag);
-		ahc_scb_control_print(scb->hscb->control, &cur_col, 60);
-		ahc_scb_scsiid_print(scb->hscb->scsiid, &cur_col, 60);
-		ahc_scb_lun_print(scb->hscb->lun, &cur_col, 60);
+		aic_printbuf_push(&buf, "%3d ", scb->hscb->tag);
+		ahc_scb_control_print(scb->hscb->control, &buf);
+		ahc_scb_scsiid_print(scb->hscb->scsiid, &buf);
+		ahc_scb_lun_print(scb->hscb->lun, &buf);
 		if ((ahc->flags & AHC_PAGESCBS) == 0) {
 			ahc_outb(ahc, SCBPTR, scb->hscb->tag);
-			printk("(");
-			ahc_scb_control_print(ahc_inb(ahc, SCB_CONTROL),
-					      &cur_col, 60);
-			ahc_scb_tag_print(ahc_inb(ahc, SCB_TAG), &cur_col, 60);
-			printk(")");
+			aic_printbuf_push(&buf, "(");
+			ahc_scb_control_print(ahc_inb(ahc, SCB_CONTROL), &buf);
+			ahc_scb_tag_print(ahc_inb(ahc, SCB_TAG), &buf);
+			aic_printbuf_push(&buf, ")");
 		}
+		aic_printbuf_finish(&buf);
 	}
-	printk("\n");
 
-	printk("Kernel Free SCB list: ");
+	aic_printbuf_push(&buf, "Kernel Free SCB list: ");
 	i = 0;
 	SLIST_FOREACH(scb, &ahc->scb_data->free_scbs, links.sle) {
 		if (i++ > 256)
 			break;
-		printk("%d ", scb->hscb->tag);
+		aic_printbuf_push(&buf, "%d ", scb->hscb->tag);
 	}
-	printk("\n");
+	aic_printbuf_finish(&buf);
 
 	maxtarget = (ahc->features & (AHC_WIDE|AHC_TWIN)) ? 15 : 7;
 	for (target = 0; target <= maxtarget; target++) {
 		untagged_q = &ahc->untagged_queues[target];
 		if (TAILQ_FIRST(untagged_q) == NULL)
 			continue;
-		printk("Untagged Q(%d): ", target);
+		aic_printbuf_push(&buf, "Untagged Q(%d): ", target);
 		i = 0;
 		TAILQ_FOREACH(scb, untagged_q, links.tqe) {
 			if (i++ > 256)
 				break;
-			printk("%d ", scb->hscb->tag);
+			aic_printbuf_push(&buf, "%d ", scb->hscb->tag);
 		}
-		printk("\n");
+		aic_printbuf_finish(&buf);
 	}
 
 	printk("\n<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>\n");
diff --git a/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped b/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
index 473039df0ed5..44902ac70ac5 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
+++ b/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped
@@ -5,186 +5,179 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $
  */
-typedef int (ahc_reg_print_t)(u_int, u_int *, u_int);
-typedef struct ahc_reg_parse_entry {
-	char	*name;
-	uint8_t	 value;
-	uint8_t	 mask;
-} ahc_reg_parse_entry_t;
-
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiseq_print;
+aic_reg_print_t ahc_scsiseq_print;
 #else
-#define ahc_scsiseq_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSISEQ", 0x00, regvalue, cur_col, wrap)
+#define ahc_scsiseq_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSISEQ", 0x00, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sxfrctl0_print;
+aic_reg_print_t ahc_sxfrctl0_print;
 #else
-#define ahc_sxfrctl0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SXFRCTL0", 0x01, regvalue, cur_col, wrap)
+#define ahc_sxfrctl0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SXFRCTL0", 0x01, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsisigi_print;
+aic_reg_print_t ahc_scsisigi_print;
 #else
-#define ahc_scsisigi_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSISIGI", 0x03, regvalue, cur_col, wrap)
+#define ahc_scsisigi_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSISIGI", 0x03, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsirate_print;
+aic_reg_print_t ahc_scsirate_print;
 #else
-#define ahc_scsirate_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIRATE", 0x04, regvalue, cur_col, wrap)
+#define ahc_scsirate_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSIRATE", 0x04, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat0_print;
+aic_reg_print_t ahc_sstat0_print;
 #else
-#define ahc_sstat0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT0", 0x0b, regvalue, cur_col, wrap)
+#define ahc_sstat0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT0", 0x0b, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat1_print;
+aic_reg_print_t ahc_sstat1_print;
 #else
-#define ahc_sstat1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT1", 0x0c, regvalue, cur_col, wrap)
+#define ahc_sstat1_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT1", 0x0c, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat2_print;
+aic_reg_print_t ahc_sstat2_print;
 #else
-#define ahc_sstat2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT2", 0x0d, regvalue, cur_col, wrap)
+#define ahc_sstat2_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT2", 0x0d, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sstat3_print;
+aic_reg_print_t ahc_sstat3_print;
 #else
-#define ahc_sstat3_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SSTAT3", 0x0e, regvalue, cur_col, wrap)
+#define ahc_sstat3_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SSTAT3", 0x0e, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_simode0_print;
+aic_reg_print_t ahc_simode0_print;
 #else
-#define ahc_simode0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SIMODE0", 0x10, regvalue, cur_col, wrap)
+#define ahc_simode0_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SIMODE0", 0x10, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_simode1_print;
+aic_reg_print_t ahc_simode1_print;
 #else
-#define ahc_simode1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SIMODE1", 0x11, regvalue, cur_col, wrap)
+#define ahc_simode1_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SIMODE1", 0x11, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsibusl_print;
+aic_reg_print_t ahc_scsibusl_print;
 #else
-#define ahc_scsibusl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIBUSL", 0x12, regvalue, cur_col, wrap)
+#define ahc_scsibusl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSIBUSL", 0x12, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sblkctl_print;
+aic_reg_print_t ahc_sblkctl_print;
 #else
-#define ahc_sblkctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SBLKCTL", 0x1f, regvalue, cur_col, wrap)
+#define ahc_sblkctl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SBLKCTL", 0x1f, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seq_flags_print;
+aic_reg_print_t ahc_seq_flags_print;
 #else
-#define ahc_seq_flags_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQ_FLAGS", 0x3c, regvalue, cur_col, wrap)
+#define ahc_seq_flags_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQ_FLAGS", 0x3c, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_lastphase_print;
+aic_reg_print_t ahc_lastphase_print;
 #else
-#define ahc_lastphase_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "LASTPHASE", 0x3f, regvalue, cur_col, wrap)
+#define ahc_lastphase_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "LASTPHASE", 0x3f, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqctl_print;
+aic_reg_print_t ahc_seqctl_print;
 #else
-#define ahc_seqctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQCTL", 0x60, regvalue, cur_col, wrap)
+#define ahc_seqctl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SEQCTL", 0x60, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sram_base_print;
+aic_reg_print_t ahc_sram_base_print;
 #else
-#define ahc_sram_base_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SRAM_BASE", 0x70, regvalue, cur_col, wrap)
+#define ahc_sram_base_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SRAM_BASE", 0x70, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_error_print;
+aic_reg_print_t ahc_error_print;
 #else
-#define ahc_error_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ERROR", 0x92, regvalue, cur_col, wrap)
+#define ahc_error_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "ERROR", 0x92, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfcntrl_print;
+aic_reg_print_t ahc_dfcntrl_print;
 #else
-#define ahc_dfcntrl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFCNTRL", 0x93, regvalue, cur_col, wrap)
+#define ahc_dfcntrl_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "DFCNTRL", 0x93, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfstatus_print;
+aic_reg_print_t ahc_dfstatus_print;
 #else
-#define ahc_dfstatus_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFSTATUS", 0x94, regvalue, cur_col, wrap)
+#define ahc_dfstatus_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "DFSTATUS", 0x94, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiphase_print;
+aic_reg_print_t ahc_scsiphase_print;
 #else
-#define ahc_scsiphase_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIPHASE", 0x9e, regvalue, cur_col, wrap)
+#define ahc_scsiphase_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCSIPHASE", 0x9e, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_base_print;
+aic_reg_print_t ahc_scb_base_print;
 #else
-#define ahc_scb_base_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_BASE", 0xa0, regvalue, cur_col, wrap)
+#define ahc_scb_base_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_BASE", 0xa0, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_control_print;
+aic_reg_print_t ahc_scb_control_print;
 #else
-#define ahc_scb_control_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_CONTROL", 0xb8, regvalue, cur_col, wrap)
+#define ahc_scb_control_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_CONTROL", 0xb8, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_scsiid_print;
+aic_reg_print_t ahc_scb_scsiid_print;
 #else
-#define ahc_scb_scsiid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_SCSIID", 0xb9, regvalue, cur_col, wrap)
+#define ahc_scb_scsiid_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_SCSIID", 0xb9, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_lun_print;
+aic_reg_print_t ahc_scb_lun_print;
 #else
-#define ahc_scb_lun_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_LUN", 0xba, regvalue, cur_col, wrap)
+#define ahc_scb_lun_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_LUN", 0xba, regvalue, buf)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scb_tag_print;
+aic_reg_print_t ahc_scb_tag_print;
 #else
-#define ahc_scb_tag_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCB_TAG", 0xbb, regvalue, cur_col, wrap)
+#define ahc_scb_tag_print(regvalue, buf) \
+    aic_print_register(NULL, 0, "SCB_TAG", 0xbb, regvalue, buf)
 #endif
 
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped b/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
index 9f9b88047d0c..7e35960857c5 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
+++ b/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
@@ -8,7 +8,7 @@
 
 #include "aic7xxx_osm.h"
 
-static const ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
+static const aic_reg_parse_entry_t SCSISEQ_parse_table[] = {
 	{ "SCSIRSTO",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
@@ -19,14 +19,14 @@ static const ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
 	{ "TEMODE",		0x80, 0x80 }
 };
 
-int
-ahc_scsiseq_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scsiseq_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SCSISEQ_parse_table, 8, "SCSISEQ",
-	    0x00, regvalue, cur_col, wrap));
+	aic_print_register(SCSISEQ_parse_table, 8, "SCSISEQ",
+			   0x00, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
+static const aic_reg_parse_entry_t SXFRCTL0_parse_table[] = {
 	{ "CLRCHN",		0x02, 0x02 },
 	{ "SCAMEN",		0x04, 0x04 },
 	{ "SPIOEN",		0x08, 0x08 },
@@ -36,14 +36,14 @@ static const ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
 	{ "DFON",		0x80, 0x80 }
 };
 
-int
-ahc_sxfrctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_sxfrctl0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SXFRCTL0_parse_table, 7, "SXFRCTL0",
-	    0x01, regvalue, cur_col, wrap));
+	aic_print_register(SXFRCTL0_parse_table, 7, "SXFRCTL0",
+			   0x01, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
+static const aic_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "ACKI",		0x01, 0x01 },
 	{ "REQI",		0x02, 0x02 },
 	{ "BSYI",		0x04, 0x04 },
@@ -63,14 +63,14 @@ static const ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "P_MESGIN",		0xe0, 0xe0 }
 };
 
-int
-ahc_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scsisigi_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
-	    0x03, regvalue, cur_col, wrap));
+	aic_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
+			   0x03, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
+static const aic_reg_parse_entry_t SCSIRATE_parse_table[] = {
 	{ "SINGLE_EDGE",	0x10, 0x10 },
 	{ "ENABLE_CRC",		0x40, 0x40 },
 	{ "WIDEXFER",		0x80, 0x80 },
@@ -79,14 +79,14 @@ static const ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
 	{ "SXFR",		0x70, 0x70 }
 };
 
-int
-ahc_scsirate_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scsirate_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SCSIRATE_parse_table, 6, "SCSIRATE",
-	    0x04, regvalue, cur_col, wrap));
+	aic_print_register(SCSIRATE_parse_table, 6, "SCSIRATE",
+			   0x04, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "DMADONE",		0x01, 0x01 },
 	{ "SPIORDY",		0x02, 0x02 },
 	{ "SDONE",		0x04, 0x04 },
@@ -98,14 +98,14 @@ static const ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "TARGET",		0x80, 0x80 }
 };
 
-int
-ahc_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_sstat0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SSTAT0_parse_table, 9, "SSTAT0",
-	    0x0b, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT0_parse_table, 9, "SSTAT0",
+			   0x0b, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "PHASECHG",		0x02, 0x02 },
 	{ "SCSIPERR",		0x04, 0x04 },
@@ -116,14 +116,14 @@ static const ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "SELTO",		0x80, 0x80 }
 };
 
-int
-ahc_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_sstat1_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SSTAT1_parse_table, 8, "SSTAT1",
-	    0x0c, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT1_parse_table, 8, "SSTAT1",
+			   0x0c, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "DUAL_EDGE_ERR",	0x01, 0x01 },
 	{ "CRCREQERR",		0x02, 0x02 },
 	{ "CRCENDERR",		0x04, 0x04 },
@@ -134,27 +134,27 @@ static const ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "SFCNT",		0x1f, 0x1f }
 };
 
-int
-ahc_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_sstat2_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SSTAT2_parse_table, 8, "SSTAT2",
-	    0x0d, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT2_parse_table, 8, "SSTAT2",
+			   0x0d, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SSTAT3_parse_table[] = {
+static const aic_reg_parse_entry_t SSTAT3_parse_table[] = {
 	{ "OFFCNT",		0x0f, 0x0f },
 	{ "U2OFFCNT",		0x7f, 0x7f },
 	{ "SCSICNT",		0xf0, 0xf0 }
 };
 
-int
-ahc_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_sstat3_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SSTAT3_parse_table, 3, "SSTAT3",
-	    0x0e, regvalue, cur_col, wrap));
+	aic_print_register(SSTAT3_parse_table, 3, "SSTAT3",
+			   0x0e, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
+static const aic_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENDMADONE",		0x01, 0x01 },
 	{ "ENSPIORDY",		0x02, 0x02 },
 	{ "ENSDONE",		0x04, 0x04 },
@@ -165,14 +165,14 @@ static const ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENSELDO",		0x40, 0x40 }
 };
 
-int
-ahc_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_simode0_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SIMODE0_parse_table, 8, "SIMODE0",
-	    0x10, regvalue, cur_col, wrap));
+	aic_print_register(SIMODE0_parse_table, 8, "SIMODE0",
+			   0x10, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
+static const aic_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENREQINIT",		0x01, 0x01 },
 	{ "ENPHASECHG",		0x02, 0x02 },
 	{ "ENSCSIPERR",		0x04, 0x04 },
@@ -183,21 +183,21 @@ static const ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENSELTIMO",		0x80, 0x80 }
 };
 
-int
-ahc_simode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_simode1_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SIMODE1_parse_table, 8, "SIMODE1",
-	    0x11, regvalue, cur_col, wrap));
+	aic_print_register(SIMODE1_parse_table, 8, "SIMODE1",
+			   0x11, regvalue, buf);
 }
 
-int
-ahc_scsibusl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scsibusl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(NULL, 0, "SCSIBUSL",
-	    0x12, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SCSIBUSL",
+			   0x12, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
+static const aic_reg_parse_entry_t SBLKCTL_parse_table[] = {
 	{ "XCVR",		0x01, 0x01 },
 	{ "SELWIDE",		0x02, 0x02 },
 	{ "ENAB20",		0x04, 0x04 },
@@ -208,14 +208,14 @@ static const ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
 	{ "DIAGLEDEN",		0x80, 0x80 }
 };
 
-int
-ahc_sblkctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_sblkctl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SBLKCTL_parse_table, 8, "SBLKCTL",
-	    0x1f, regvalue, cur_col, wrap));
+	aic_print_register(SBLKCTL_parse_table, 8, "SBLKCTL",
+			   0x1f, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+static const aic_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NO_DISCONNECT",	0x01, 0x01 },
 	{ "SPHASE_PENDING",	0x02, 0x02 },
 	{ "DPHASE_PENDING",	0x04, 0x04 },
@@ -227,14 +227,14 @@ static const ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NOT_IDENTIFIED",	0x80, 0x80 }
 };
 
-int
-ahc_seq_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_seq_flags_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
-	    0x3c, regvalue, cur_col, wrap));
+	aic_print_register(SEQ_FLAGS_parse_table, 9, "SEQ_FLAGS",
+			   0x3c, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
+static const aic_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "MSGI",		0x20, 0x20 },
 	{ "IOI",		0x40, 0x40 },
 	{ "CDI",		0x80, 0x80 },
@@ -248,14 +248,14 @@ static const ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "P_MESGIN",		0xe0, 0xe0 }
 };
 
-int
-ahc_lastphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_lastphase_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(LASTPHASE_parse_table, 11, "LASTPHASE",
-	    0x3f, regvalue, cur_col, wrap));
+	aic_print_register(LASTPHASE_parse_table, 11, "LASTPHASE",
+			   0x3f, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
+static const aic_reg_parse_entry_t SEQCTL_parse_table[] = {
 	{ "LOADRAM",		0x01, 0x01 },
 	{ "SEQRESET",		0x02, 0x02 },
 	{ "STEP",		0x04, 0x04 },
@@ -266,21 +266,21 @@ static const ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
 	{ "PERRORDIS",		0x80, 0x80 }
 };
 
-int
-ahc_seqctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_seqctl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SEQCTL_parse_table, 8, "SEQCTL",
-	    0x60, regvalue, cur_col, wrap));
+	aic_print_register(SEQCTL_parse_table, 8, "SEQCTL",
+			   0x60, regvalue, buf);
 }
 
-int
-ahc_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_sram_base_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(NULL, 0, "SRAM_BASE",
-	    0x70, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SRAM_BASE",
+			   0x70, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t ERROR_parse_table[] = {
+static const aic_reg_parse_entry_t ERROR_parse_table[] = {
 	{ "ILLHADDR",		0x01, 0x01 },
 	{ "ILLSADDR",		0x02, 0x02 },
 	{ "ILLOPCODE",		0x04, 0x04 },
@@ -291,14 +291,14 @@ static const ahc_reg_parse_entry_t ERROR_parse_table[] = {
 	{ "CIOPARERR",		0x80, 0x80 }
 };
 
-int
-ahc_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_error_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(ERROR_parse_table, 8, "ERROR",
-	    0x92, regvalue, cur_col, wrap));
+	aic_print_register(ERROR_parse_table, 8, "ERROR",
+			   0x92, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
+static const aic_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
@@ -311,14 +311,14 @@ static const ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "PRELOADEN",		0x80, 0x80 }
 };
 
-int
-ahc_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_dfcntrl_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(DFCNTRL_parse_table, 10, "DFCNTRL",
-	    0x93, regvalue, cur_col, wrap));
+	aic_print_register(DFCNTRL_parse_table, 10, "DFCNTRL",
+			   0x93, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
+static const aic_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "FIFOEMP",		0x01, 0x01 },
 	{ "FIFOFULL",		0x02, 0x02 },
 	{ "DFTHRESH",		0x04, 0x04 },
@@ -329,14 +329,14 @@ static const ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "PRELOAD_AVAIL",	0x80, 0x80 }
 };
 
-int
-ahc_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_dfstatus_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(DFSTATUS_parse_table, 8, "DFSTATUS",
-	    0x94, regvalue, cur_col, wrap));
+	aic_print_register(DFSTATUS_parse_table, 8, "DFSTATUS",
+			   0x94, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+static const aic_reg_parse_entry_t SCSIPHASE_parse_table[] = {
 	{ "DATA_OUT_PHASE",	0x01, 0x01 },
 	{ "DATA_IN_PHASE",	0x02, 0x02 },
 	{ "MSG_OUT_PHASE",	0x04, 0x04 },
@@ -346,21 +346,21 @@ static const ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
 	{ "DATA_PHASE_MASK",	0x03, 0x03 }
 };
 
-int
-ahc_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scsiphase_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
-	    0x9e, regvalue, cur_col, wrap));
+	aic_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
+			   0x9e, regvalue, buf);
 }
 
-int
-ahc_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scb_base_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(NULL, 0, "SCB_BASE",
-	    0xa0, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SCB_BASE",
+			   0xa0, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+static const aic_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "DISCONNECTED",	0x04, 0x04 },
 	{ "ULTRAENB",		0x08, 0x08 },
 	{ "MK_MESSAGE",		0x10, 0x10 },
@@ -371,43 +371,43 @@ static const ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "SCB_TAG_TYPE",	0x03, 0x03 }
 };
 
-int
-ahc_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scb_control_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SCB_CONTROL_parse_table, 8, "SCB_CONTROL",
-	    0xb8, regvalue, cur_col, wrap));
+	aic_print_register(SCB_CONTROL_parse_table, 8, "SCB_CONTROL",
+			   0xb8, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+static const aic_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
 	{ "TWIN_CHNLB",		0x80, 0x80 },
 	{ "OID",		0x0f, 0x0f },
 	{ "TWIN_TID",		0x70, 0x70 },
 	{ "TID",		0xf0, 0xf0 }
 };
 
-int
-ahc_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scb_scsiid_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SCB_SCSIID_parse_table, 4, "SCB_SCSIID",
-	    0xb9, regvalue, cur_col, wrap));
+	aic_print_register(SCB_SCSIID_parse_table, 4, "SCB_SCSIID",
+			   0xb9, regvalue, buf);
 }
 
-static const ahc_reg_parse_entry_t SCB_LUN_parse_table[] = {
+static const aic_reg_parse_entry_t SCB_LUN_parse_table[] = {
 	{ "SCB_XFERLEN_ODD",	0x80, 0x80 },
 	{ "LID",		0x3f, 0x3f }
 };
 
-int
-ahc_scb_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scb_lun_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(SCB_LUN_parse_table, 2, "SCB_LUN",
-	    0xba, regvalue, cur_col, wrap));
+	aic_print_register(SCB_LUN_parse_table, 2, "SCB_LUN",
+			   0xba, regvalue, buf);
 }
 
-int
-ahc_scb_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
+void
+ahc_scb_tag_print(u_int regvalue, struct aic_dump_buffer *buf)
 {
-	return (ahc_print_register(NULL, 0, "SCB_TAG",
-	    0xbb, regvalue, cur_col, wrap));
+	aic_print_register(NULL, 0, "SCB_TAG",
+			   0xbb, regvalue, buf);
 }
 
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
index 232aff1fe784..207aa6ca6d2e 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c
@@ -52,6 +52,7 @@
 #include <fcntl.h>
 #include <inttypes.h>
 #include <regex.h>
+#include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -353,23 +354,6 @@ aic_print_include(FILE *dfile, char *include_file)
 	fprintf(dfile, "\n#include \"%s\"\n\n", include_file);
 }
 
-void
-aic_print_reg_dump_types(FILE *ofile)
-{
-	if (ofile == NULL)
-		return;
-
-	fprintf(ofile,
-"typedef int (%sreg_print_t)(u_int, u_int *, u_int);\n"
-"typedef struct %sreg_parse_entry {\n"
-"	char	*name;\n"
-"	uint8_t	 value;\n"
-"	uint8_t	 mask;\n"
-"} %sreg_parse_entry_t;\n"
-"\n",
-		prefix, prefix, prefix);
-}
-
 static void
 aic_print_reg_dump_start(FILE *dfile, symbol_node_t *regnode)
 {
@@ -377,8 +361,7 @@ aic_print_reg_dump_start(FILE *dfile, symbol_node_t *regnode)
 		return;
 
 	fprintf(dfile,
-"static const %sreg_parse_entry_t %s_parse_table[] = {\n",
-		prefix,
+"static const aic_reg_parse_entry_t %s_parse_table[] = {\n",
 		regnode->symbol->name);
 }
 
@@ -404,16 +387,15 @@ aic_print_reg_dump_end(FILE *ofile, FILE *dfile,
 "\n");
 
 		fprintf(dfile,
-"int\n"
-"%s%s_print(u_int regvalue, u_int *cur_col, u_int wrap)\n"
+"void\n"
+"%s%s_print(u_int regvalue, struct aic_dump_buffer *buf)\n"
 "{\n"
-"	return (%sprint_register(%s%s, %d, \"%s\",\n"
-"	    0x%02x, regvalue, cur_col, wrap));\n"
+"	aic_print_register(%s%s, %d, \"%s\",\n"
+"			   0x%02x, regvalue, buf);\n"
 "}\n"
 "\n",
 			prefix,
 			lower_name,
-			prefix,
 			num_entries != 0 ? regnode->symbol->name : "NULL",
 			num_entries != 0 ? "_parse_table" : "",
 			num_entries,
@@ -423,18 +405,16 @@ aic_print_reg_dump_end(FILE *ofile, FILE *dfile,
 
 	fprintf(ofile,
 "#if AIC_DEBUG_REGISTERS\n"
-"%sreg_print_t %s%s_print;\n"
+"aic_reg_print_t %s%s_print;\n"
 "#else\n"
-"#define %s%s_print(regvalue, cur_col, wrap) \\\n"
-"    %sprint_register(NULL, 0, \"%s\", 0x%02x, regvalue, cur_col, wrap)\n"
+"#define %s%s_print(regvalue, buf) \\\n"
+"    aic_print_register(NULL, 0, \"%s\", 0x%02x, regvalue, buf)\n"
 "#endif\n"
 "\n",
 		prefix,
-		prefix,
 		lower_name,
 		prefix,
 		lower_name,
-		prefix,
 		regnode->symbol->name,
 		regnode->symbol->info.rinfo->address);
 }
@@ -534,7 +514,6 @@ symtable_dump(FILE *ofile, FILE *dfile)
 
 	/* Register dianostic functions/declarations first. */
 	aic_print_file_prologue(ofile);
-	aic_print_reg_dump_types(ofile);
 	aic_print_file_prologue(dfile);
 	aic_print_include(dfile, stock_include_file);
 	SLIST_FOREACH(curnode, &registers, links) {
diff --git a/drivers/scsi/aic7xxx/aiclib.c b/drivers/scsi/aic7xxx/aiclib.c
index 828ae3d9a510..5869de7a1673 100644
--- a/drivers/scsi/aic7xxx/aiclib.c
+++ b/drivers/scsi/aic7xxx/aiclib.c
@@ -1,34 +1,83 @@
 /*
- * Implementation of Utility functions for all SCSI device types.
+ * Utility functions for AIC driver
  *
- * Copyright (c) 1997, 1998, 1999 Justin T. Gibbs.
- * Copyright (c) 1997, 1998 Kenneth D. Merry.
- * All rights reserved.
+ * Copyright (c) 2017 Michał Mirosław
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification, immediately at the beginning of the file.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
- *
- * $FreeBSD: src/sys/cam/scsi/scsi_all.c,v 1.38 2002/09/23 04:56:35 mjacob Exp $
- * $Id$
+ * License: GPLv2
  */
 
 #include "aiclib.h"
 
+void aic_printbuf_push(struct aic_dump_buffer *buf, const char *fmt, ...)
+{
+	va_list args;
+	char *ptr;
+	int len;
+
+	ptr = buf->buf + buf->cur_col;
+
+	va_start(args, fmt);
+	len = vscnprintf(ptr, sizeof(buf->buf) - buf->cur_col, fmt, args);
+	buf->cur_col += len;
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(aic_printbuf_push);
+
+void aic_printbuf_finish(struct aic_dump_buffer *buf)
+{
+	if (!buf->cur_col)
+		return;
+
+	printk("%s\n", buf->buf);
+	buf->cur_col = 0;
+}
+EXPORT_SYMBOL_GPL(aic_printbuf_finish);
+
+static void aic_printbuf_maybe_break(struct aic_dump_buffer *buf)
+{
+	if (buf->cur_col >= buf->wrap)
+		aic_printbuf_finish(buf);
+}
+
+void aic_print_register(const aic_reg_parse_entry_t *table, u_int num_entries,
+			const char *name, u_int address, u_int value,
+			struct aic_dump_buffer *buf)
+{
+	u_int	printed_mask;
+
+	aic_printbuf_push(buf, "%s[0x%x]", name, value);
+	if (table == NULL) {
+		aic_printbuf_push(buf, " ");
+		aic_printbuf_maybe_break(buf);
+		return;
+	}
+
+	printed_mask = 0;
+	while (printed_mask != 0xFF) {
+		int entry;
+
+		for (entry = 0; entry < num_entries; entry++) {
+			const aic_reg_parse_entry_t *e = &table[entry];
+			if (((value & e->mask) != e->value) ||
+			    ((printed_mask & e->mask) == e->mask))
+				continue;
+
+			aic_printbuf_push(buf, "%s%s",
+					  printed_mask == 0 ? ":(" : "|",
+					  e->name);
+			printed_mask |= e->mask;
+
+			break;
+		}
+
+		if (entry >= num_entries)
+			break;
+	}
+	if (printed_mask != 0)
+		aic_printbuf_push(buf, ") ");
+	else
+		aic_printbuf_push(buf, " ");
+
+	aic_printbuf_maybe_break(buf);
+}
+EXPORT_SYMBOL_GPL(aic_print_register);
diff --git a/drivers/scsi/aic7xxx/aiclib.h b/drivers/scsi/aic7xxx/aiclib.h
index f8fd198aafbc..f94981f9878a 100644
--- a/drivers/scsi/aic7xxx/aiclib.h
+++ b/drivers/scsi/aic7xxx/aiclib.h
@@ -57,6 +57,38 @@
 #ifndef	_AICLIB_H
 #define _AICLIB_H
 
+#include <linux/blkdev.h>
+#include <linux/types.h>
+
+struct aic_dump_buffer
+{
+	unsigned int cur_col;
+	unsigned int wrap;
+	char buf[256];
+};
+
+typedef void (aic_reg_print_t)(uint32_t, struct aic_dump_buffer *);
+
+typedef struct aic_reg_parse_entry {
+	char    *name;
+	uint8_t  value;
+	uint8_t  mask;
+} aic_reg_parse_entry_t;
+
+static inline void
+aic_printbuf_init(struct aic_dump_buffer *buf, unsigned int wrap)
+{
+	buf->cur_col = 0;
+	buf->wrap = wrap;
+}
+
+void __printf(2, 3) aic_printbuf_push(struct aic_dump_buffer *buf,
+				      const char *fmt, ...);
+void aic_printbuf_finish(struct aic_dump_buffer *buf);
+void aic_print_register(const aic_reg_parse_entry_t *table, u_int num_entries,
+			const char *name, u_int address, u_int value,
+			struct aic_dump_buffer *buf);
+
 struct scsi_sense
 {
 	uint8_t opcode;
-- 
2.11.0
