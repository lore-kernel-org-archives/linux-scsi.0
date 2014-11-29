From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 7/7] scsi: misc: Print single-character strings with seq_putc
Date: Sat, 29 Nov 2014 01:34:18 +0100
Message-ID: <1417221258-4937-8-git-send-email-linux@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37038 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaK2Af0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Nov 2014 19:35:26 -0500
Received: by mail-lb0-f176.google.com with SMTP id p9so6093136lbv.7
        for <linux-scsi@vger.kernel.org>; Fri, 28 Nov 2014 16:35:24 -0800 (PST)
In-Reply-To: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Using seq_putc to print a single character saves at least a strlen()
call and a memory access, and may also give a small .text reduction.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/NCR5380.c              |  2 +-
 drivers/scsi/advansys.c             | 34 +++++++++++++++++-----------------
 drivers/scsi/aha152x.c              |  2 +-
 drivers/scsi/aic7xxx/aic79xx_proc.c | 10 +++++-----
 drivers/scsi/aic7xxx/aic7xxx_proc.c | 10 +++++-----
 drivers/scsi/atari_NCR5380.c        |  2 +-
 drivers/scsi/dc395x.c               |  4 ++--
 drivers/scsi/esas2r/esas2r_main.c   |  2 +-
 drivers/scsi/g_NCR5380.c            |  6 +++---
 drivers/scsi/in2000.c               |  2 +-
 drivers/scsi/ips.c                  |  2 +-
 drivers/scsi/nsp32.c                |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c        |  4 ++--
 drivers/scsi/qla2xxx/qla_dfs.c      |  2 +-
 drivers/scsi/scsi_proc.c            | 10 +++++-----
 drivers/scsi/scsi_trace.c           |  2 +-
 drivers/scsi/sun3_NCR5380.c         |  2 +-
 drivers/scsi/wd33c93.c              |  2 +-
 18 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index a2ed965..50cfa9a 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -771,7 +771,7 @@ static void lprint_command(unsigned char *command, struct seq_file *m)
 	lprint_opcode(command[0], m);
 	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
 		seq_printf(m, "%02x ", command[i]);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void lprint_opcode(int opcode, struct seq_file *m)
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 76e7610..5f2e4ce 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3089,7 +3089,7 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	for (i = 0; i <= ASC_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (ep->init_sdtr & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 #ifdef CONFIG_ISA
 	if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
@@ -3204,7 +3204,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	seq_puts(m, " Target ID:           ");
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %X", i);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->disc_enable;
@@ -3217,7 +3217,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->tagqng_able;
@@ -3230,7 +3230,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		word = ep_3550->start_motor;
@@ -3243,7 +3243,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
 		seq_puts(m, " Synchronous Transfer:");
@@ -3251,7 +3251,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 			seq_printf(m, " %c",
 				   (ep_3550->sdtr_able & ADV_TID_TO_TIDMASK(i)) ?
 				   'Y' : 'N');
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
@@ -3260,7 +3260,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 			seq_printf(m, " %c",
 				   (ep_3550->ultra_able & ADV_TID_TO_TIDMASK(i))
 				   ? 'Y' : 'N');
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC3550) {
@@ -3274,7 +3274,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 	for (i = 0; i <= ADV_MAX_TID; i++)
 		seq_printf(m, " %c",
 			   (word & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	if (adv_dvc_varp->chip_type == ADV_CHIP_ASC38C0800 ||
 	    adv_dvc_varp->chip_type == ADV_CHIP_ASC38C1600) {
@@ -3319,7 +3319,7 @@ static void asc_prt_adv_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
 				seq_puts(m, "\n  ");
 			sdtr_speed >>= 4;
 		}
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
 }
 
@@ -3449,7 +3449,7 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (v->sdtr_done & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		uchar syn_period_ix;
@@ -3484,7 +3484,7 @@ static void asc_prt_asc_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			seq_puts(m, "*\n");
 			renegotiate = 1;
 		} else {
-			seq_puts(m, "\n");
+			seq_putc(m, '\n');
 		}
 	}
 
@@ -3572,7 +3572,7 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 
 		seq_printf(m, " %X:%d", i, lrambyte);
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	AdvReadWordLram(iop_base, ASC_MC_WDTR_ABLE, wdtr_able);
 	seq_puts(m, " Wide Enabled:");
@@ -3586,7 +3586,7 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (wdtr_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	AdvReadWordLram(iop_base, ASC_MC_WDTR_DONE, wdtr_done);
 	seq_puts(m, " Transfer Bit Width:");
@@ -3605,11 +3605,11 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 
 		if ((wdtr_able & ADV_TID_TO_TIDMASK(i)) &&
 		    (wdtr_done & ADV_TID_TO_TIDMASK(i)) == 0) {
-			seq_puts(m, "*");
+			seq_putc(m, '*');
 			renegotiate = 1;
 		}
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	AdvReadWordLram(iop_base, ASC_MC_SDTR_ABLE, sdtr_able);
 	seq_puts(m, " Synchronous Enabled:");
@@ -3623,7 +3623,7 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			   i,
 			   (sdtr_able & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	AdvReadWordLram(iop_base, ASC_MC_SDTR_DONE, sdtr_done);
 	for (i = 0; i <= ADV_MAX_TID; i++) {
@@ -3672,7 +3672,7 @@ static void asc_prt_adv_board_info(struct seq_file *m, struct Scsi_Host *shost)
 			seq_puts(m, "*\n");
 			renegotiate = 1;
 		} else {
-			seq_puts(m, "\n");
+			seq_putc(m, '\n');
 		}
 	}
 
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 05cad58..bf13ebf 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3360,7 +3360,7 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 	PDEBUG(debug_locking, "locks");
 	PDEBUG(debug_phases, "phases");
 
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 #endif
 
 	seq_puts(m, "\nqueue status:\n");
diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx/aic79xx_proc.c
index e095598..add2da5 100644
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -148,9 +148,9 @@ ahd_format_transinfo(struct seq_file *m, struct ahd_transinfo *tinfo)
 		}
 		seq_printf(m, "%dbit)", 8 * (0x01 << tinfo->width));
 	} else if (freq != 0) {
-		seq_puts(m, ")");
+		seq_putc(m, ')');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void
@@ -294,14 +294,14 @@ ahd_linux_show_info(struct seq_file *m, struct Scsi_Host *shost)
 		seq_puts(m, "Serial EEPROM:\n");
 		for (i = 0; i < sizeof(*ahd->seep_config)/2; i++) {
 			if (((i % 8) == 0) && (i != 0)) {
-				seq_puts(m, "\n");
+				seq_putc(m, '\n');
 			}
 			seq_printf(m, "0x%.4x ",
 				  ((uint16_t*)ahd->seep_config)[i]);
 		}
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	if ((ahd->features & AHD_WIDE) == 0)
 		max_targ = 8;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_proc.c b/drivers/scsi/aic7xxx/aic7xxx_proc.c
index 25511ca..1845960 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -125,9 +125,9 @@ ahc_format_transinfo(struct seq_file *m, struct ahc_transinfo *tinfo)
 		}
 		seq_printf(m, "%dbit)", 8 * (0x01 << tinfo->width));
 	} else if (freq != 0) {
-		seq_puts(m, ")");
+		seq_putc(m, ')');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static void
@@ -308,14 +308,14 @@ ahc_linux_show_info(struct seq_file *m, struct Scsi_Host *shost)
 		seq_puts(m, "Serial EEPROM:\n");
 		for (i = 0; i < sizeof(*ahc->seep_config)/2; i++) {
 			if (((i % 8) == 0) && (i != 0)) {
-				seq_puts(m, "\n");
+				seq_putc(m, '\n');
 			}
 			seq_printf(m, "0x%.4x ",
 				  ((uint16_t*)ahc->seep_config)[i]);
 		}
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	max_targ = 16;
 	if ((ahc->features & (AHC_WIDE|AHC_TWIN)) == 0)
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 0b5344c..76cdd1b 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -769,7 +769,7 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
 	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
 	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
 		seq_printf(m, " %02x", command[i]);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static int NCR5380_show_info(struct seq_file *m, struct Scsi_Host *instance)
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index baff2d9..6877314 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4691,7 +4691,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 	if (timer_pending(&acb->waiting_timer))
 		seq_puts(m, "Waiting queue timer running\n");
 	else
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		struct ScsiReqBlk *srb;
@@ -4708,7 +4708,7 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 		list_for_each_entry(srb, &dcb->srb_going_list, list)
 			seq_printf(m, " %p", srb->cmd);
 		if (!list_empty(&dcb->srb_waiting_list) || !list_empty(&dcb->srb_going_list))
-			seq_puts(m, "\n");
+			seq_putc(m, '\n');
 	}
 
 	if (debug_enabled(DBG_1)) {
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 6504a19..facf069 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -752,7 +752,7 @@ int esas2r_show_info(struct seq_file *m, struct Scsi_Host *sh)
 	if (dev_count == 0)
 		seq_puts(m, "none\n");
 
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 	return 0;
 
 }
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 36e8145..01f7b6f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -752,7 +752,7 @@ static void sprint_command(struct seq_file *m, unsigned char *command)
 	sprint_opcode(m, command[0]);
 	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
 		seq_printf(m, "%02x ", command[i]);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 }
 
 /**
@@ -829,7 +829,7 @@ static int generic_NCR5380_show_info(struct seq_file *m, struct Scsi_Host *scsi_
 	if (hostdata->pendingw)
 		seq_printf(m, "  %d pending writes", hostdata->pendingw);
 	if (hostdata->pendingr || hostdata->pendingw)
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	shost_for_each_device(dev, scsi_ptr) {
 		unsigned long br = hostdata->bytes_read[dev->id];
 		unsigned long bw = hostdata->bytes_write[dev->id];
@@ -857,7 +857,7 @@ static int generic_NCR5380_show_info(struct seq_file *m, struct Scsi_Host *scsi_
 		seq_printf(m, "\n%10ld kb written in %5ld secs", bw / 1024, tw);
 		if (tw)
 			seq_printf(m, " @ %5ld bps", bw / tw);
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
 #endif
 
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index a73395e..3882d9f 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -2273,7 +2273,7 @@ static int in2000_show_info(struct seq_file *m, struct Scsi_Host *instance)
 	if (hd->proc & PR_TEST) {
 		;		/* insert your own custom function here */
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 	spin_unlock_irqrestore(instance->host_lock, flags);
 #endif				/* PROC_INTERFACE */
 	return 0;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 06b9d0c..903f845 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2137,7 +2137,7 @@ ips_host_info(ips_ha_t *ha, struct seq_file *m)
 	seq_printf(m, "\tCurrent Active PT Commands        : %d\n",
 		  ha->num_ioctl);
 
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 8f6b1b4..c6077ce 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1509,7 +1509,7 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
 				data->target[id].offset
 				);
 		}
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
 	return 0;
 }
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index b0c8643..105a139 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1398,7 +1398,7 @@ static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
 		seq_puts(m, "???");
 		break;
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 
 
 	spin_lock_irqsave(&(data->Lock), flags);
@@ -1439,7 +1439,7 @@ static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
 				data->Sync[id].SyncOffset
 				);
 		}
-		seq_puts(m, "\n");
+		seq_putc(m, '\n');
 	}
 	return 0;
 }
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index c837ba3..15cf074 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -38,7 +38,7 @@ qla2x00_dfs_fce_show(struct seq_file *s, void *unused)
 			seq_printf(s, "\n%llx: ",
 			    (unsigned long long)((cnt * 4) + fce_start));
 		else
-			seq_puts(s, " ");
+			seq_putc(s, ' ');
 		seq_printf(s, "%08x", *fce++);
 	}
 
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 581de8f..251598e 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -191,7 +191,7 @@ static int proc_print_scsidevice(struct device *dev, void *data)
 		if (sdev->vendor[i] >= 0x20)
 			seq_putc(s, sdev->vendor[i]);
 		else
-			seq_puts(s, " ");
+			seq_putc(s, ' ');
 	}
 
 	seq_puts(s, " Model: ");
@@ -199,7 +199,7 @@ static int proc_print_scsidevice(struct device *dev, void *data)
 		if (sdev->model[i] >= 0x20)
 			seq_putc(s, sdev->model[i]);
 		else
-			seq_puts(s, " ");
+			seq_putc(s, ' ');
 	}
 
 	seq_puts(s, " Rev: ");
@@ -207,10 +207,10 @@ static int proc_print_scsidevice(struct device *dev, void *data)
 		if (sdev->rev[i] >= 0x20)
 			seq_putc(s, sdev->rev[i]);
 		else
-			seq_puts(s, " ");
+			seq_putc(s, ' ');
 	}
 
-	seq_puts(s, "\n");
+	seq_putc(s, '\n');
 
 	seq_printf(s, "  Type:   %s ", scsi_device_type(sdev->type));
 	seq_printf(s, "               ANSI  SCSI revision: %02x",
@@ -218,7 +218,7 @@ static int proc_print_scsidevice(struct device *dev, void *data)
 	if (sdev->scsi_level == 2)
 		seq_puts(s, " CCS\n");
 	else
-		seq_puts(s, "\n");
+		seq_putc(s, '\n');
 
 out:
 	return 0;
diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index e4e122b..5cc386c 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -249,7 +249,7 @@ scsi_trace_misc(struct trace_seq *p, unsigned char *cdb, int len)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
 
-	trace_seq_puts(p, "-");
+	trace_seq_putc(p, '-');
 	trace_seq_putc(p, 0);
 
 	return ret;
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 3011df8..23ede8e 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -715,7 +715,7 @@ static void show_Scsi_Cmnd(Scsi_Cmnd *cmd, struct seq_file *m)
 	seq_printf(m, "%2d (0x%02x)", command[0], command[0]);
 	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
 		seq_printf(m, " %02x", command[i]);
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 }
 
 static int NCR5380_show_info(struct seq_file *m, struct Scsi_Host *instance)
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 6e041a7..9e09da4 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -2192,7 +2192,7 @@ wd33c93_show_info(struct seq_file *m, struct Scsi_Host *instance)
 			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 	}
-	seq_puts(m, "\n");
+	seq_putc(m, '\n');
 	spin_unlock_irq(&hd->lock);
 #endif				/* PROC_INTERFACE */
 	return 0;
-- 
2.0.4

