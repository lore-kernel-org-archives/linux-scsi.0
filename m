From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 1/6] scsi: Remove SPRINTF macro
Date: Wed,  3 Dec 2014 00:10:49 +0100
Message-ID: <1417561854-17188-2-git-send-email-linux@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
 <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417561854-17188-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Finn Thain <fthain@telegraphics.com.au>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-scsi@vger.kernel.org

The macro SPRINTF doesn't save a lot of typing or make the code more
readable, and depending on a specific identifier (m) in the
surrounding scope is generally frowned upon. Nuke it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/NCR5380.c       |  20 ++-
 drivers/scsi/aha152x.c       | 295 +++++++++++++++++++++----------------------
 drivers/scsi/dc395x.c        |  78 ++++++------
 drivers/scsi/nsp32.c         |  41 +++---
 drivers/scsi/pcmcia/nsp_cs.c |  50 ++++----
 drivers/scsi/wd7000.c        |  41 +++---
 6 files changed, 252 insertions(+), 273 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 36244d6..aca181e 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -716,8 +716,6 @@ static int __maybe_unused NCR5380_write_info(struct Scsi_Host *instance,
 }
 #endif
 
-#undef SPRINTF
-#define SPRINTF(args...) seq_printf(m, ## args)
 static
 void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m);
 static
@@ -734,19 +732,19 @@ static int __maybe_unused NCR5380_show_info(struct seq_file *m,
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
 #ifdef PSEUDO_DMA
-	SPRINTF("Highwater I/O busy spin counts: write %d, read %d\n",
+	seq_printf(m, "Highwater I/O busy spin counts: write %d, read %d\n",
 	        hostdata->spin_max_w, hostdata->spin_max_r);
 #endif
 	spin_lock_irq(instance->host_lock);
 	if (!hostdata->connected)
-		SPRINTF("scsi%d: no currently connected command\n", instance->host_no);
+		seq_printf(m, "scsi%d: no currently connected command\n", instance->host_no);
 	else
 		lprint_Scsi_Cmnd((struct scsi_cmnd *) hostdata->connected, m);
-	SPRINTF("scsi%d: issue_queue\n", instance->host_no);
+	seq_printf(m, "scsi%d: issue_queue\n", instance->host_no);
 	for (ptr = (struct scsi_cmnd *) hostdata->issue_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		lprint_Scsi_Cmnd(ptr, m);
 
-	SPRINTF("scsi%d: disconnected_queue\n", instance->host_no);
+	seq_printf(m, "scsi%d: disconnected_queue\n", instance->host_no);
 	for (ptr = (struct scsi_cmnd *) hostdata->disconnected_queue; ptr; ptr = (struct scsi_cmnd *) ptr->host_scribble)
 		lprint_Scsi_Cmnd(ptr, m);
 	spin_unlock_irq(instance->host_lock);
@@ -755,8 +753,8 @@ static int __maybe_unused NCR5380_show_info(struct seq_file *m,
 
 static void lprint_Scsi_Cmnd(struct scsi_cmnd *cmd, struct seq_file *m)
 {
-	SPRINTF("scsi%d : destination target %d, lun %llu\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
-	SPRINTF("        command = ");
+	seq_printf(m, "scsi%d : destination target %d, lun %llu\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
+	seq_printf(m, "        command = ");
 	lprint_command(cmd->cmnd, m);
 }
 
@@ -765,13 +763,13 @@ static void lprint_command(unsigned char *command, struct seq_file *m)
 	int i, s;
 	lprint_opcode(command[0], m);
 	for (i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i)
-		SPRINTF("%02x ", command[i]);
-	SPRINTF("\n");
+		seq_printf(m, "%02x ", command[i]);
+	seq_printf(m, "\n");
 }
 
 static void lprint_opcode(int opcode, struct seq_file *m)
 {
-	SPRINTF("%2d (0x%02x)", opcode, opcode);
+	seq_printf(m, "%2d (0x%02x)", opcode, opcode);
 }
 
 
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 2b960b3..f14ad8a 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2490,299 +2490,296 @@ static void show_queues(struct Scsi_Host *shpnt)
 	disp_enintr(shpnt);
 }
 
-#undef SPRINTF
-#define SPRINTF(args...) seq_printf(m, ##args)
-
 static void get_command(struct seq_file *m, Scsi_Cmnd * ptr)
 {
 	int i;
 
-	SPRINTF("%p: target=%d; lun=%d; cmnd=( ",
+	seq_printf(m, "%p: target=%d; lun=%d; cmnd=( ",
 		ptr, ptr->device->id, (u8)ptr->device->lun);
 
 	for (i = 0; i < COMMAND_SIZE(ptr->cmnd[0]); i++)
-		SPRINTF("0x%02x ", ptr->cmnd[i]);
+		seq_printf(m, "0x%02x ", ptr->cmnd[i]);
 
-	SPRINTF("); resid=%d; residual=%d; buffers=%d; phase |",
+	seq_printf(m, "); resid=%d; residual=%d; buffers=%d; phase |",
 		scsi_get_resid(ptr), ptr->SCp.this_residual,
 		ptr->SCp.buffers_residual);
 
 	if (ptr->SCp.phase & not_issued)
-		SPRINTF("not issued|");
+		seq_printf(m, "not issued|");
 	if (ptr->SCp.phase & selecting)
-		SPRINTF("selecting|");
+		seq_printf(m, "selecting|");
 	if (ptr->SCp.phase & disconnected)
-		SPRINTF("disconnected|");
+		seq_printf(m, "disconnected|");
 	if (ptr->SCp.phase & aborted)
-		SPRINTF("aborted|");
+		seq_printf(m, "aborted|");
 	if (ptr->SCp.phase & identified)
-		SPRINTF("identified|");
+		seq_printf(m, "identified|");
 	if (ptr->SCp.phase & completed)
-		SPRINTF("completed|");
+		seq_printf(m, "completed|");
 	if (ptr->SCp.phase & spiordy)
-		SPRINTF("spiordy|");
+		seq_printf(m, "spiordy|");
 	if (ptr->SCp.phase & syncneg)
-		SPRINTF("syncneg|");
-	SPRINTF("; next=0x%p\n", SCNEXT(ptr));
+		seq_printf(m, "syncneg|");
+	seq_printf(m, "; next=0x%p\n", SCNEXT(ptr));
 }
 
 static void get_ports(struct seq_file *m, struct Scsi_Host *shpnt)
 {
 	int s;
 
-	SPRINTF("\n%s: %s(%s) ", CURRENT_SC ? "on bus" : "waiting", states[STATE].name, states[PREVSTATE].name);
+	seq_printf(m, "\n%s: %s(%s) ", CURRENT_SC ? "on bus" : "waiting", states[STATE].name, states[PREVSTATE].name);
 
 	s = GETPORT(SCSISEQ);
-	SPRINTF("SCSISEQ( ");
+	seq_printf(m, "SCSISEQ( ");
 	if (s & TEMODEO)
-		SPRINTF("TARGET MODE ");
+		seq_printf(m, "TARGET MODE ");
 	if (s & ENSELO)
-		SPRINTF("SELO ");
+		seq_printf(m, "SELO ");
 	if (s & ENSELI)
-		SPRINTF("SELI ");
+		seq_printf(m, "SELI ");
 	if (s & ENRESELI)
-		SPRINTF("RESELI ");
+		seq_printf(m, "RESELI ");
 	if (s & ENAUTOATNO)
-		SPRINTF("AUTOATNO ");
+		seq_printf(m, "AUTOATNO ");
 	if (s & ENAUTOATNI)
-		SPRINTF("AUTOATNI ");
+		seq_printf(m, "AUTOATNI ");
 	if (s & ENAUTOATNP)
-		SPRINTF("AUTOATNP ");
+		seq_printf(m, "AUTOATNP ");
 	if (s & SCSIRSTO)
-		SPRINTF("SCSIRSTO ");
-	SPRINTF(");");
+		seq_printf(m, "SCSIRSTO ");
+	seq_printf(m, ");");
 
-	SPRINTF(" SCSISIG(");
+	seq_printf(m, " SCSISIG(");
 	s = GETPORT(SCSISIG);
 	switch (s & P_MASK) {
 	case P_DATAO:
-		SPRINTF("DATA OUT");
+		seq_printf(m, "DATA OUT");
 		break;
 	case P_DATAI:
-		SPRINTF("DATA IN");
+		seq_printf(m, "DATA IN");
 		break;
 	case P_CMD:
-		SPRINTF("COMMAND");
+		seq_printf(m, "COMMAND");
 		break;
 	case P_STATUS:
-		SPRINTF("STATUS");
+		seq_printf(m, "STATUS");
 		break;
 	case P_MSGO:
-		SPRINTF("MESSAGE OUT");
+		seq_printf(m, "MESSAGE OUT");
 		break;
 	case P_MSGI:
-		SPRINTF("MESSAGE IN");
+		seq_printf(m, "MESSAGE IN");
 		break;
 	default:
-		SPRINTF("*invalid*");
+		seq_printf(m, "*invalid*");
 		break;
 	}
 
-	SPRINTF("); ");
+	seq_printf(m, "); ");
 
-	SPRINTF("INTSTAT (%s); ", TESTHI(DMASTAT, INTSTAT) ? "hi" : "lo");
+	seq_printf(m, "INTSTAT (%s); ", TESTHI(DMASTAT, INTSTAT) ? "hi" : "lo");
 
-	SPRINTF("SSTAT( ");
+	seq_printf(m, "SSTAT( ");
 	s = GETPORT(SSTAT0);
 	if (s & TARGET)
-		SPRINTF("TARGET ");
+		seq_printf(m, "TARGET ");
 	if (s & SELDO)
-		SPRINTF("SELDO ");
+		seq_printf(m, "SELDO ");
 	if (s & SELDI)
-		SPRINTF("SELDI ");
+		seq_printf(m, "SELDI ");
 	if (s & SELINGO)
-		SPRINTF("SELINGO ");
+		seq_printf(m, "SELINGO ");
 	if (s & SWRAP)
-		SPRINTF("SWRAP ");
+		seq_printf(m, "SWRAP ");
 	if (s & SDONE)
-		SPRINTF("SDONE ");
+		seq_printf(m, "SDONE ");
 	if (s & SPIORDY)
-		SPRINTF("SPIORDY ");
+		seq_printf(m, "SPIORDY ");
 	if (s & DMADONE)
-		SPRINTF("DMADONE ");
+		seq_printf(m, "DMADONE ");
 
 	s = GETPORT(SSTAT1);
 	if (s & SELTO)
-		SPRINTF("SELTO ");
+		seq_printf(m, "SELTO ");
 	if (s & ATNTARG)
-		SPRINTF("ATNTARG ");
+		seq_printf(m, "ATNTARG ");
 	if (s & SCSIRSTI)
-		SPRINTF("SCSIRSTI ");
+		seq_printf(m, "SCSIRSTI ");
 	if (s & PHASEMIS)
-		SPRINTF("PHASEMIS ");
+		seq_printf(m, "PHASEMIS ");
 	if (s & BUSFREE)
-		SPRINTF("BUSFREE ");
+		seq_printf(m, "BUSFREE ");
 	if (s & SCSIPERR)
-		SPRINTF("SCSIPERR ");
+		seq_printf(m, "SCSIPERR ");
 	if (s & PHASECHG)
-		SPRINTF("PHASECHG ");
+		seq_printf(m, "PHASECHG ");
 	if (s & REQINIT)
-		SPRINTF("REQINIT ");
-	SPRINTF("); ");
+		seq_printf(m, "REQINIT ");
+	seq_printf(m, "); ");
 
 
-	SPRINTF("SSTAT( ");
+	seq_printf(m, "SSTAT( ");
 
 	s = GETPORT(SSTAT0) & GETPORT(SIMODE0);
 
 	if (s & TARGET)
-		SPRINTF("TARGET ");
+		seq_printf(m, "TARGET ");
 	if (s & SELDO)
-		SPRINTF("SELDO ");
+		seq_printf(m, "SELDO ");
 	if (s & SELDI)
-		SPRINTF("SELDI ");
+		seq_printf(m, "SELDI ");
 	if (s & SELINGO)
-		SPRINTF("SELINGO ");
+		seq_printf(m, "SELINGO ");
 	if (s & SWRAP)
-		SPRINTF("SWRAP ");
+		seq_printf(m, "SWRAP ");
 	if (s & SDONE)
-		SPRINTF("SDONE ");
+		seq_printf(m, "SDONE ");
 	if (s & SPIORDY)
-		SPRINTF("SPIORDY ");
+		seq_printf(m, "SPIORDY ");
 	if (s & DMADONE)
-		SPRINTF("DMADONE ");
+		seq_printf(m, "DMADONE ");
 
 	s = GETPORT(SSTAT1) & GETPORT(SIMODE1);
 
 	if (s & SELTO)
-		SPRINTF("SELTO ");
+		seq_printf(m, "SELTO ");
 	if (s & ATNTARG)
-		SPRINTF("ATNTARG ");
+		seq_printf(m, "ATNTARG ");
 	if (s & SCSIRSTI)
-		SPRINTF("SCSIRSTI ");
+		seq_printf(m, "SCSIRSTI ");
 	if (s & PHASEMIS)
-		SPRINTF("PHASEMIS ");
+		seq_printf(m, "PHASEMIS ");
 	if (s & BUSFREE)
-		SPRINTF("BUSFREE ");
+		seq_printf(m, "BUSFREE ");
 	if (s & SCSIPERR)
-		SPRINTF("SCSIPERR ");
+		seq_printf(m, "SCSIPERR ");
 	if (s & PHASECHG)
-		SPRINTF("PHASECHG ");
+		seq_printf(m, "PHASECHG ");
 	if (s & REQINIT)
-		SPRINTF("REQINIT ");
-	SPRINTF("); ");
+		seq_printf(m, "REQINIT ");
+	seq_printf(m, "); ");
 
-	SPRINTF("SXFRCTL0( ");
+	seq_printf(m, "SXFRCTL0( ");
 
 	s = GETPORT(SXFRCTL0);
 	if (s & SCSIEN)
-		SPRINTF("SCSIEN ");
+		seq_printf(m, "SCSIEN ");
 	if (s & DMAEN)
-		SPRINTF("DMAEN ");
+		seq_printf(m, "DMAEN ");
 	if (s & CH1)
-		SPRINTF("CH1 ");
+		seq_printf(m, "CH1 ");
 	if (s & CLRSTCNT)
-		SPRINTF("CLRSTCNT ");
+		seq_printf(m, "CLRSTCNT ");
 	if (s & SPIOEN)
-		SPRINTF("SPIOEN ");
+		seq_printf(m, "SPIOEN ");
 	if (s & CLRCH1)
-		SPRINTF("CLRCH1 ");
-	SPRINTF("); ");
+		seq_printf(m, "CLRCH1 ");
+	seq_printf(m, "); ");
 
-	SPRINTF("SIGNAL( ");
+	seq_printf(m, "SIGNAL( ");
 
 	s = GETPORT(SCSISIG);
 	if (s & SIG_ATNI)
-		SPRINTF("ATNI ");
+		seq_printf(m, "ATNI ");
 	if (s & SIG_SELI)
-		SPRINTF("SELI ");
+		seq_printf(m, "SELI ");
 	if (s & SIG_BSYI)
-		SPRINTF("BSYI ");
+		seq_printf(m, "BSYI ");
 	if (s & SIG_REQI)
-		SPRINTF("REQI ");
+		seq_printf(m, "REQI ");
 	if (s & SIG_ACKI)
-		SPRINTF("ACKI ");
-	SPRINTF("); ");
+		seq_printf(m, "ACKI ");
+	seq_printf(m, "); ");
 
-	SPRINTF("SELID(%02x), ", GETPORT(SELID));
+	seq_printf(m, "SELID(%02x), ", GETPORT(SELID));
 
-	SPRINTF("STCNT(%d), ", GETSTCNT());
+	seq_printf(m, "STCNT(%d), ", GETSTCNT());
 
-	SPRINTF("SSTAT2( ");
+	seq_printf(m, "SSTAT2( ");
 
 	s = GETPORT(SSTAT2);
 	if (s & SOFFSET)
-		SPRINTF("SOFFSET ");
+		seq_printf(m, "SOFFSET ");
 	if (s & SEMPTY)
-		SPRINTF("SEMPTY ");
+		seq_printf(m, "SEMPTY ");
 	if (s & SFULL)
-		SPRINTF("SFULL ");
-	SPRINTF("); SFCNT (%d); ", s & (SFULL | SFCNT));
+		seq_printf(m, "SFULL ");
+	seq_printf(m, "); SFCNT (%d); ", s & (SFULL | SFCNT));
 
 	s = GETPORT(SSTAT3);
-	SPRINTF("SCSICNT (%d), OFFCNT(%d), ", (s & 0xf0) >> 4, s & 0x0f);
+	seq_printf(m, "SCSICNT (%d), OFFCNT(%d), ", (s & 0xf0) >> 4, s & 0x0f);
 
-	SPRINTF("SSTAT4( ");
+	seq_printf(m, "SSTAT4( ");
 	s = GETPORT(SSTAT4);
 	if (s & SYNCERR)
-		SPRINTF("SYNCERR ");
+		seq_printf(m, "SYNCERR ");
 	if (s & FWERR)
-		SPRINTF("FWERR ");
+		seq_printf(m, "FWERR ");
 	if (s & FRERR)
-		SPRINTF("FRERR ");
-	SPRINTF("); ");
+		seq_printf(m, "FRERR ");
+	seq_printf(m, "); ");
 
-	SPRINTF("DMACNTRL0( ");
+	seq_printf(m, "DMACNTRL0( ");
 	s = GETPORT(DMACNTRL0);
-	SPRINTF("%s ", s & _8BIT ? "8BIT" : "16BIT");
-	SPRINTF("%s ", s & DMA ? "DMA" : "PIO");
-	SPRINTF("%s ", s & WRITE_READ ? "WRITE" : "READ");
+	seq_printf(m, "%s ", s & _8BIT ? "8BIT" : "16BIT");
+	seq_printf(m, "%s ", s & DMA ? "DMA" : "PIO");
+	seq_printf(m, "%s ", s & WRITE_READ ? "WRITE" : "READ");
 	if (s & ENDMA)
-		SPRINTF("ENDMA ");
+		seq_printf(m, "ENDMA ");
 	if (s & INTEN)
-		SPRINTF("INTEN ");
+		seq_printf(m, "INTEN ");
 	if (s & RSTFIFO)
-		SPRINTF("RSTFIFO ");
+		seq_printf(m, "RSTFIFO ");
 	if (s & SWINT)
-		SPRINTF("SWINT ");
-	SPRINTF("); ");
+		seq_printf(m, "SWINT ");
+	seq_printf(m, "); ");
 
-	SPRINTF("DMASTAT( ");
+	seq_printf(m, "DMASTAT( ");
 	s = GETPORT(DMASTAT);
 	if (s & ATDONE)
-		SPRINTF("ATDONE ");
+		seq_printf(m, "ATDONE ");
 	if (s & WORDRDY)
-		SPRINTF("WORDRDY ");
+		seq_printf(m, "WORDRDY ");
 	if (s & DFIFOFULL)
-		SPRINTF("DFIFOFULL ");
+		seq_printf(m, "DFIFOFULL ");
 	if (s & DFIFOEMP)
-		SPRINTF("DFIFOEMP ");
-	SPRINTF(")\n");
+		seq_printf(m, "DFIFOEMP ");
+	seq_printf(m, ")\n");
 
-	SPRINTF("enabled interrupts( ");
+	seq_printf(m, "enabled interrupts( ");
 
 	s = GETPORT(SIMODE0);
 	if (s & ENSELDO)
-		SPRINTF("ENSELDO ");
+		seq_printf(m, "ENSELDO ");
 	if (s & ENSELDI)
-		SPRINTF("ENSELDI ");
+		seq_printf(m, "ENSELDI ");
 	if (s & ENSELINGO)
-		SPRINTF("ENSELINGO ");
+		seq_printf(m, "ENSELINGO ");
 	if (s & ENSWRAP)
-		SPRINTF("ENSWRAP ");
+		seq_printf(m, "ENSWRAP ");
 	if (s & ENSDONE)
-		SPRINTF("ENSDONE ");
+		seq_printf(m, "ENSDONE ");
 	if (s & ENSPIORDY)
-		SPRINTF("ENSPIORDY ");
+		seq_printf(m, "ENSPIORDY ");
 	if (s & ENDMADONE)
-		SPRINTF("ENDMADONE ");
+		seq_printf(m, "ENDMADONE ");
 
 	s = GETPORT(SIMODE1);
 	if (s & ENSELTIMO)
-		SPRINTF("ENSELTIMO ");
+		seq_printf(m, "ENSELTIMO ");
 	if (s & ENATNTARG)
-		SPRINTF("ENATNTARG ");
+		seq_printf(m, "ENATNTARG ");
 	if (s & ENPHASEMIS)
-		SPRINTF("ENPHASEMIS ");
+		seq_printf(m, "ENPHASEMIS ");
 	if (s & ENBUSFREE)
-		SPRINTF("ENBUSFREE ");
+		seq_printf(m, "ENBUSFREE ");
 	if (s & ENSCSIPERR)
-		SPRINTF("ENSCSIPERR ");
+		seq_printf(m, "ENSCSIPERR ");
 	if (s & ENPHASECHG)
-		SPRINTF("ENPHASECHG ");
+		seq_printf(m, "ENPHASECHG ");
 	if (s & ENREQINIT)
-		SPRINTF("ENREQINIT ");
-	SPRINTF(")\n");
+		seq_printf(m, "ENREQINIT ");
+	seq_printf(m, ")\n");
 }
 
 static int aha152x_set_info(struct Scsi_Host *shpnt, char *buffer, int length)
@@ -2825,56 +2822,56 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 
-	SPRINTF(AHA152X_REVID "\n");
+	seq_printf(m, AHA152X_REVID "\n");
 
-	SPRINTF("ioports 0x%04lx to 0x%04lx\n",
+	seq_printf(m, "ioports 0x%04lx to 0x%04lx\n",
 		shpnt->io_port, shpnt->io_port + shpnt->n_io_port - 1);
-	SPRINTF("interrupt 0x%02x\n", shpnt->irq);
-	SPRINTF("disconnection/reconnection %s\n",
+	seq_printf(m, "interrupt 0x%02x\n", shpnt->irq);
+	seq_printf(m, "disconnection/reconnection %s\n",
 		RECONNECT ? "enabled" : "disabled");
-	SPRINTF("parity checking %s\n",
+	seq_printf(m, "parity checking %s\n",
 		PARITY ? "enabled" : "disabled");
-	SPRINTF("synchronous transfers %s\n",
+	seq_printf(m, "synchronous transfers %s\n",
 		SYNCHRONOUS ? "enabled" : "disabled");
-	SPRINTF("%d commands currently queued\n", HOSTDATA(shpnt)->commands);
+	seq_printf(m, "%d commands currently queued\n", HOSTDATA(shpnt)->commands);
 
 	if(SYNCHRONOUS) {
-		SPRINTF("synchronously operating targets (tick=50 ns):\n");
+		seq_printf(m, "synchronously operating targets (tick=50 ns):\n");
 		for (i = 0; i < 8; i++)
 			if (HOSTDATA(shpnt)->syncrate[i] & 0x7f)
-				SPRINTF("target %d: period %dT/%dns; req/ack offset %d\n",
+				seq_printf(m, "target %d: period %dT/%dns; req/ack offset %d\n",
 					i,
 					(((HOSTDATA(shpnt)->syncrate[i] & 0x70) >> 4) + 2),
 					(((HOSTDATA(shpnt)->syncrate[i] & 0x70) >> 4) + 2) * 50,
 				    HOSTDATA(shpnt)->syncrate[i] & 0x0f);
 	}
-	SPRINTF("\nqueue status:\n");
+	seq_printf(m, "\nqueue status:\n");
 	DO_LOCK(flags);
 	if (ISSUE_SC) {
-		SPRINTF("not yet issued commands:\n");
+		seq_printf(m, "not yet issued commands:\n");
 		for (ptr = ISSUE_SC; ptr; ptr = SCNEXT(ptr))
 			get_command(m, ptr);
 	} else
-		SPRINTF("no not yet issued commands\n");
+		seq_printf(m, "no not yet issued commands\n");
 	DO_UNLOCK(flags);
 
 	if (CURRENT_SC) {
-		SPRINTF("current command:\n");
+		seq_printf(m, "current command:\n");
 		get_command(m, CURRENT_SC);
 	} else
-		SPRINTF("no current command\n");
+		seq_printf(m, "no current command\n");
 
 	if (DISCONNECTED_SC) {
-		SPRINTF("disconnected commands:\n");
+		seq_printf(m, "disconnected commands:\n");
 		for (ptr = DISCONNECTED_SC; ptr; ptr = SCNEXT(ptr))
 			get_command(m, ptr);
 	} else
-		SPRINTF("no disconnected commands\n");
+		seq_printf(m, "no disconnected commands\n");
 
 	get_ports(m, shpnt);
 
 #if defined(AHA152X_STAT)
-	SPRINTF("statistics:\n"
+	seq_printf(m, "statistics:\n"
 		"total commands:               %d\n"
 		"disconnections:               %d\n"
 		"busfree with check condition: %d\n"
@@ -2894,7 +2891,7 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 		HOSTDATA(shpnt)->busfree_without_done_command,
 		HOSTDATA(shpnt)->busfree_without_any_action);
 	for(i=0; i<maxstate; i++) {
-		SPRINTF("%-10s %-12d %-12d %-12ld\n",
+		seq_printf(m, "%-10s %-12d %-12d %-12ld\n",
 			states[i].name,
 			HOSTDATA(shpnt)->count_trans[i],
 			HOSTDATA(shpnt)->count[i],
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 0c6be0a..0a1ed50 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4610,13 +4610,10 @@ static void adapter_uninit(struct AdapterCtlBlk *acb)
 }
 
 
-#undef SPRINTF
-#define SPRINTF(args...) seq_printf(m,##args)
-
 #undef YESNO
 #define YESNO(YN) \
- if (YN) SPRINTF(" Yes ");\
- else SPRINTF(" No  ")
+ if (YN) seq_printf(m, " Yes ");\
+ else seq_printf(m, " No  ")
 
 static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
@@ -4626,47 +4623,44 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 	unsigned long flags;
 	int dev;
 
-	SPRINTF(DC395X_BANNER " PCI SCSI Host Adapter\n");
-	SPRINTF(" Driver Version " DC395X_VERSION "\n");
+	seq_printf(m, DC395X_BANNER " PCI SCSI Host Adapter\n");
+	seq_printf(m, " Driver Version " DC395X_VERSION "\n");
 
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 
-	SPRINTF("SCSI Host Nr %i, ", host->host_no);
-	SPRINTF("DC395U/UW/F DC315/U %s\n",
+	seq_printf(m, "SCSI Host Nr %i, ", host->host_no);
+	seq_printf(m, "DC395U/UW/F DC315/U %s\n",
 		(acb->config & HCC_WIDE_CARD) ? "Wide" : "");
-	SPRINTF("io_port_base 0x%04lx, ", acb->io_port_base);
-	SPRINTF("irq_level 0x%04x, ", acb->irq_level);
-	SPRINTF(" SelTimeout %ims\n", (1638 * acb->sel_timeout) / 1000);
+	seq_printf(m, "io_port_base 0x%04lx, ", acb->io_port_base);
+	seq_printf(m, "irq_level 0x%04x, ", acb->irq_level);
+	seq_printf(m, " SelTimeout %ims\n", (1638 * acb->sel_timeout) / 1000);
 
-	SPRINTF("MaxID %i, MaxLUN %llu, ", host->max_id, host->max_lun);
-	SPRINTF("AdapterID %i\n", host->this_id);
+	seq_printf(m, "MaxID %i, MaxLUN %llu, ", host->max_id, host->max_lun);
+	seq_printf(m, "AdapterID %i\n", host->this_id);
 
-	SPRINTF("tag_max_num %i", acb->tag_max_num);
-	/*SPRINTF(", DMA_Status %i\n", DC395x_read8(acb, TRM_S1040_DMA_STATUS)); */
-	SPRINTF(", FilterCfg 0x%02x",
+	seq_printf(m, "tag_max_num %i", acb->tag_max_num);
+	/*seq_printf(m, ", DMA_Status %i\n", DC395x_read8(acb, TRM_S1040_DMA_STATUS)); */
+	seq_printf(m, ", FilterCfg 0x%02x",
 		DC395x_read8(acb, TRM_S1040_SCSI_CONFIG1));
-	SPRINTF(", DelayReset %is\n", acb->eeprom.delay_time);
-	/*SPRINTF("\n"); */
+	seq_printf(m, ", DelayReset %is\n", acb->eeprom.delay_time);
+	/*seq_printf(m, "\n"); */
 
-	SPRINTF("Nr of DCBs: %i\n", list_size(&acb->dcb_list));
-	SPRINTF
-	    ("Map of attached LUNs: %02x %02x %02x %02x %02x %02x %02x %02x\n",
+	seq_printf(m, "Nr of DCBs: %i\n", list_size(&acb->dcb_list));
+	seq_printf(m, "Map of attached LUNs: %02x %02x %02x %02x %02x %02x %02x %02x\n",
 	     acb->dcb_map[0], acb->dcb_map[1], acb->dcb_map[2],
 	     acb->dcb_map[3], acb->dcb_map[4], acb->dcb_map[5],
 	     acb->dcb_map[6], acb->dcb_map[7]);
-	SPRINTF
-	    ("                      %02x %02x %02x %02x %02x %02x %02x %02x\n",
+	seq_printf(m, "                      %02x %02x %02x %02x %02x %02x %02x %02x\n",
 	     acb->dcb_map[8], acb->dcb_map[9], acb->dcb_map[10],
 	     acb->dcb_map[11], acb->dcb_map[12], acb->dcb_map[13],
 	     acb->dcb_map[14], acb->dcb_map[15]);
 
-	SPRINTF
-	    ("Un ID LUN Prty Sync Wide DsCn SndS TagQ nego_period SyncFreq SyncOffs MaxCmd\n");
+	seq_printf(m, "Un ID LUN Prty Sync Wide DsCn SndS TagQ nego_period SyncFreq SyncOffs MaxCmd\n");
 
 	dev = 0;
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		int nego_period;
-		SPRINTF("%02i %02i  %02i ", dev, dcb->target_id,
+		seq_printf(m, "%02i %02i  %02i ", dev, dcb->target_id,
 			dcb->target_lun);
 		YESNO(dcb->dev_mode & NTC_DO_PARITY_CHK);
 		YESNO(dcb->sync_offset);
@@ -4676,53 +4670,53 @@ static int dc395x_show_info(struct seq_file *m, struct Scsi_Host *host)
 		YESNO(dcb->sync_mode & EN_TAG_QUEUEING);
 		nego_period = clock_period[dcb->sync_period & 0x07] << 2;
 		if (dcb->sync_offset)
-			SPRINTF("  %03i ns ", nego_period);
+			seq_printf(m, "  %03i ns ", nego_period);
 		else
-			SPRINTF(" (%03i ns)", (dcb->min_nego_period << 2));
+			seq_printf(m, " (%03i ns)", (dcb->min_nego_period << 2));
 
 		if (dcb->sync_offset & 0x0f) {
 			spd = 1000 / (nego_period);
 			spd1 = 1000 % (nego_period);
 			spd1 = (spd1 * 10 + nego_period / 2) / (nego_period);
-			SPRINTF("   %2i.%1i M     %02i ", spd, spd1,
+			seq_printf(m, "   %2i.%1i M     %02i ", spd, spd1,
 				(dcb->sync_offset & 0x0f));
 		} else
-			SPRINTF("                 ");
+			seq_printf(m, "                 ");
 
 		/* Add more info ... */
-		SPRINTF("     %02i\n", dcb->max_command);
+		seq_printf(m, "     %02i\n", dcb->max_command);
 		dev++;
 	}
 
 	if (timer_pending(&acb->waiting_timer))
-		SPRINTF("Waiting queue timer running\n");
+		seq_printf(m, "Waiting queue timer running\n");
 	else
-		SPRINTF("\n");
+		seq_printf(m, "\n");
 
 	list_for_each_entry(dcb, &acb->dcb_list, list) {
 		struct ScsiReqBlk *srb;
 		if (!list_empty(&dcb->srb_waiting_list))
-			SPRINTF("DCB (%02i-%i): Waiting: %i:",
+			seq_printf(m, "DCB (%02i-%i): Waiting: %i:",
 				dcb->target_id, dcb->target_lun,
 				list_size(&dcb->srb_waiting_list));
                 list_for_each_entry(srb, &dcb->srb_waiting_list, list)
-			SPRINTF(" %p", srb->cmd);
+			seq_printf(m, " %p", srb->cmd);
 		if (!list_empty(&dcb->srb_going_list))
-			SPRINTF("\nDCB (%02i-%i): Going  : %i:",
+			seq_printf(m, "\nDCB (%02i-%i): Going  : %i:",
 				dcb->target_id, dcb->target_lun,
 				list_size(&dcb->srb_going_list));
 		list_for_each_entry(srb, &dcb->srb_going_list, list)
-			SPRINTF(" %p", srb->cmd);
+			seq_printf(m, " %p", srb->cmd);
 		if (!list_empty(&dcb->srb_waiting_list) || !list_empty(&dcb->srb_going_list))
-			SPRINTF("\n");
+			seq_printf(m, "\n");
 	}
 
 	if (debug_enabled(DBG_1)) {
-		SPRINTF("DCB list for ACB %p:\n", acb);
+		seq_printf(m, "DCB list for ACB %p:\n", acb);
 		list_for_each_entry(dcb, &acb->dcb_list, list) {
-			SPRINTF("%p -> ", dcb);
+			seq_printf(m, "%p -> ", dcb);
 		}
-		SPRINTF("END\n");
+		seq_printf(m, "END\n");
 	}
 
 	DC395x_UNLOCK_IO(acb->scsi_host, flags);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 90abb03..3e77551 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1441,8 +1441,6 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
-#undef SPRINTF
-#define SPRINTF(args...) seq_printf(m, ##args)
 
 static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
@@ -1458,64 +1456,63 @@ static int nsp32_show_info(struct seq_file *m, struct Scsi_Host *host)
 	data = (nsp32_hw_data *)host->hostdata;
 	base = host->io_port;
 
-	SPRINTF("NinjaSCSI-32 status\n\n");
-	SPRINTF("Driver version:        %s, $Revision: 1.33 $\n", nsp32_release_version);
-	SPRINTF("SCSI host No.:         %d\n",		hostno);
-	SPRINTF("IRQ:                   %d\n",		host->irq);
-	SPRINTF("IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
-	SPRINTF("MMIO(virtual address): 0x%lx-0x%lx\n",	host->base, host->base + data->MmioLength - 1);
-	SPRINTF("sg_tablesize:          %d\n",		host->sg_tablesize);
-	SPRINTF("Chip revision:         0x%x\n",       	(nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
+	seq_printf(m, "NinjaSCSI-32 status\n\n");
+	seq_printf(m, "Driver version:        %s, $Revision: 1.33 $\n", nsp32_release_version);
+	seq_printf(m, "SCSI host No.:         %d\n",		hostno);
+	seq_printf(m, "IRQ:                   %d\n",		host->irq);
+	seq_printf(m, "IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
+	seq_printf(m, "MMIO(virtual address): 0x%lx-0x%lx\n",	host->base, host->base + data->MmioLength - 1);
+	seq_printf(m, "sg_tablesize:          %d\n",		host->sg_tablesize);
+	seq_printf(m, "Chip revision:         0x%x\n",		(nsp32_read2(base, INDEX_REG) >> 8) & 0xff);
 
 	mode_reg = nsp32_index_read1(base, CHIP_MODE);
 	model    = data->pci_devid->driver_data;
 
 #ifdef CONFIG_PM
-	SPRINTF("Power Management:      %s\n",          (mode_reg & OPTF) ? "yes" : "no");
+	seq_printf(m, "Power Management:      %s\n",          (mode_reg & OPTF) ? "yes" : "no");
 #endif
-	SPRINTF("OEM:                   %ld, %s\n",     (mode_reg & (OEM0|OEM1)), nsp32_model[model]);
+	seq_printf(m, "OEM:                   %ld, %s\n",     (mode_reg & (OEM0|OEM1)), nsp32_model[model]);
 
 	spin_lock_irqsave(&(data->Lock), flags);
-	SPRINTF("CurrentSC:             0x%p\n\n",      data->CurrentSC);
+	seq_printf(m, "CurrentSC:             0x%p\n\n",      data->CurrentSC);
 	spin_unlock_irqrestore(&(data->Lock), flags);
 
 
-	SPRINTF("SDTR status\n");
+	seq_printf(m, "SDTR status\n");
 	for (id = 0; id < ARRAY_SIZE(data->target); id++) {
 
-                SPRINTF("id %d: ", id);
+		seq_printf(m, "id %d: ", id);
 
 		if (id == host->this_id) {
-			SPRINTF("----- NinjaSCSI-32 host adapter\n");
+			seq_printf(m, "----- NinjaSCSI-32 host adapter\n");
 			continue;
 		}
 
 		if (data->target[id].sync_flag == SDTR_DONE) {
 			if (data->target[id].period == 0            &&
 			    data->target[id].offset == ASYNC_OFFSET ) {
-				SPRINTF("async");
+				seq_printf(m, "async");
 			} else {
-				SPRINTF(" sync");
+				seq_printf(m, " sync");
 			}
 		} else {
-			SPRINTF(" none");
+			seq_printf(m, " none");
 		}
 
 		if (data->target[id].period != 0) {
 
 			speed = 1000000 / (data->target[id].period * 4);
 
-			SPRINTF(" transfer %d.%dMB/s, offset %d",
+			seq_printf(m, " transfer %d.%dMB/s, offset %d",
 				speed / 1000,
 				speed % 1000,
 				data->target[id].offset
 				);
 		}
-		SPRINTF("\n");
+		seq_printf(m, "\n");
 	}
 	return 0;
 }
-#undef SPRINTF
 
 
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 34aad32..83db942 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1364,9 +1364,6 @@ static const char *nsp_info(struct Scsi_Host *shpnt)
 	return data->nspinfo;
 }
 
-#undef SPRINTF
-#define SPRINTF(args...) seq_printf(m, ##args)
-
 static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
 	int id;
@@ -1378,75 +1375,74 @@ static int nsp_show_info(struct seq_file *m, struct Scsi_Host *host)
 	hostno = host->host_no;
 	data = (nsp_hw_data *)host->hostdata;
 
-	SPRINTF("NinjaSCSI status\n\n");
-	SPRINTF("Driver version:        $Revision: 1.23 $\n");
-	SPRINTF("SCSI host No.:         %d\n",          hostno);
-	SPRINTF("IRQ:                   %d\n",          host->irq);
-	SPRINTF("IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
-	SPRINTF("MMIO(virtual address): 0x%lx-0x%lx\n", host->base, host->base + data->MmioLength - 1);
-	SPRINTF("sg_tablesize:          %d\n",          host->sg_tablesize);
+	seq_printf(m, "NinjaSCSI status\n\n");
+	seq_printf(m, "Driver version:        $Revision: 1.23 $\n");
+	seq_printf(m, "SCSI host No.:         %d\n",          hostno);
+	seq_printf(m, "IRQ:                   %d\n",          host->irq);
+	seq_printf(m, "IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
+	seq_printf(m, "MMIO(virtual address): 0x%lx-0x%lx\n", host->base, host->base + data->MmioLength - 1);
+	seq_printf(m, "sg_tablesize:          %d\n",          host->sg_tablesize);
 
-	SPRINTF("burst transfer mode:   ");
+	seq_printf(m, "burst transfer mode:   ");
 	switch (nsp_burst_mode) {
 	case BURST_IO8:
-		SPRINTF("io8");
+		seq_printf(m, "io8");
 		break;
 	case BURST_IO32:
-		SPRINTF("io32");
+		seq_printf(m, "io32");
 		break;
 	case BURST_MEM32:
-		SPRINTF("mem32");
+		seq_printf(m, "mem32");
 		break;
 	default:
-		SPRINTF("???");
+		seq_printf(m, "???");
 		break;
 	}
-	SPRINTF("\n");
+	seq_printf(m, "\n");
 
 
 	spin_lock_irqsave(&(data->Lock), flags);
-	SPRINTF("CurrentSC:             0x%p\n\n",      data->CurrentSC);
+	seq_printf(m, "CurrentSC:             0x%p\n\n",      data->CurrentSC);
 	spin_unlock_irqrestore(&(data->Lock), flags);
 
-	SPRINTF("SDTR status\n");
+	seq_printf(m, "SDTR status\n");
 	for(id = 0; id < ARRAY_SIZE(data->Sync); id++) {
 
-		SPRINTF("id %d: ", id);
+		seq_printf(m, "id %d: ", id);
 
 		if (id == host->this_id) {
-			SPRINTF("----- NinjaSCSI-3 host adapter\n");
+			seq_printf(m, "----- NinjaSCSI-3 host adapter\n");
 			continue;
 		}
 
 		switch(data->Sync[id].SyncNegotiation) {
 		case SYNC_OK:
-			SPRINTF(" sync");
+			seq_printf(m, " sync");
 			break;
 		case SYNC_NG:
-			SPRINTF("async");
+			seq_printf(m, "async");
 			break;
 		case SYNC_NOT_YET:
-			SPRINTF(" none");
+			seq_printf(m, " none");
 			break;
 		default:
-			SPRINTF("?????");
+			seq_printf(m, "?????");
 			break;
 		}
 
 		if (data->Sync[id].SyncPeriod != 0) {
 			speed = 1000000 / (data->Sync[id].SyncPeriod * 4);
 
-			SPRINTF(" transfer %d.%dMB/s, offset %d",
+			seq_printf(m, " transfer %d.%dMB/s, offset %d",
 				speed / 1000,
 				speed % 1000,
 				data->Sync[id].SyncOffset
 				);
 		}
-		SPRINTF("\n");
+		seq_printf(m, "\n");
 	}
 	return 0;
 }
-#undef SPRINTF
 
 /*---------------------------------------------------------------*/
 /* error handler                                                 */
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index f94d736..2d7c62f 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1295,9 +1295,6 @@ static void wd7000_revision(Adapter * host)
 }
 
 
-#undef SPRINTF
-#define SPRINTF(args...) { seq_printf(m, ## args); }
-
 static int wd7000_set_info(struct Scsi_Host *host, char *buffer, int length)
 {
 	dprintk("Buffer = <%.*s>, length = %d\n", length, buffer, length);
@@ -1320,43 +1317,43 @@ static int wd7000_show_info(struct seq_file *m, struct Scsi_Host *host)
 #endif
 
 	spin_lock_irqsave(host->host_lock, flags);
-	SPRINTF("Host scsi%d: Western Digital WD-7000 (rev %d.%d)\n", host->host_no, adapter->rev1, adapter->rev2);
-	SPRINTF("  IO base:      0x%x\n", adapter->iobase);
-	SPRINTF("  IRQ:          %d\n", adapter->irq);
-	SPRINTF("  DMA channel:  %d\n", adapter->dma);
-	SPRINTF("  Interrupts:   %d\n", adapter->int_counter);
-	SPRINTF("  BUS_ON time:  %d nanoseconds\n", adapter->bus_on * 125);
-	SPRINTF("  BUS_OFF time: %d nanoseconds\n", adapter->bus_off * 125);
+	seq_printf(m, "Host scsi%d: Western Digital WD-7000 (rev %d.%d)\n", host->host_no, adapter->rev1, adapter->rev2);
+	seq_printf(m, "  IO base:      0x%x\n", adapter->iobase);
+	seq_printf(m, "  IRQ:          %d\n", adapter->irq);
+	seq_printf(m, "  DMA channel:  %d\n", adapter->dma);
+	seq_printf(m, "  Interrupts:   %d\n", adapter->int_counter);
+	seq_printf(m, "  BUS_ON time:  %d nanoseconds\n", adapter->bus_on * 125);
+	seq_printf(m, "  BUS_OFF time: %d nanoseconds\n", adapter->bus_off * 125);
 
 #ifdef WD7000_DEBUG
 	ogmbs = adapter->mb.ogmb;
 	icmbs = adapter->mb.icmb;
 
-	SPRINTF("\nControl port value: 0x%x\n", adapter->control);
-	SPRINTF("Incoming mailbox:\n");
-	SPRINTF("  size: %d\n", ICMB_CNT);
-	SPRINTF("  queued messages: ");
+	seq_printf(m, "\nControl port value: 0x%x\n", adapter->control);
+	seq_printf(m, "Incoming mailbox:\n");
+	seq_printf(m, "  size: %d\n", ICMB_CNT);
+	seq_printf(m, "  queued messages: ");
 
 	for (i = count = 0; i < ICMB_CNT; i++)
 		if (icmbs[i].status) {
 			count++;
-			SPRINTF("0x%x ", i);
+			seq_printf(m, "0x%x ", i);
 		}
 
-	SPRINTF(count ? "\n" : "none\n");
+	seq_printf(m, count ? "\n" : "none\n");
 
-	SPRINTF("Outgoing mailbox:\n");
-	SPRINTF("  size: %d\n", OGMB_CNT);
-	SPRINTF("  next message: 0x%x\n", adapter->next_ogmb);
-	SPRINTF("  queued messages: ");
+	seq_printf(m, "Outgoing mailbox:\n");
+	seq_printf(m, "  size: %d\n", OGMB_CNT);
+	seq_printf(m, "  next message: 0x%x\n", adapter->next_ogmb);
+	seq_printf(m, "  queued messages: ");
 
 	for (i = count = 0; i < OGMB_CNT; i++)
 		if (ogmbs[i].status) {
 			count++;
-			SPRINTF("0x%x ", i);
+			seq_printf(m, "0x%x ", i);
 		}
 
-	SPRINTF(count ? "\n" : "none\n");
+	seq_printf(m, count ? "\n" : "none\n");
 #endif
 
 	spin_unlock_irqrestore(host->host_lock, flags);
-- 
2.0.4
