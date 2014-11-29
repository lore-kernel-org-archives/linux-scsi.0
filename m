From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 4/7] scsi/aha152x: Replace seq_printf with seq_puts
Date: Sat, 29 Nov 2014 01:34:15 +0100
Message-ID: <1417221258-4937-5-git-send-email-linux@rasmusvillemoes.dk>
References: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417221258-4937-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Using seq_printf to print a simple string is a lot more expensive than
it needs to be, since seq_puts exists. Replace seq_printf with
seq_puts when possible.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/aha152x.c | 252 ++++++++++++++++++++++++-------------------------
 1 file changed, 126 insertions(+), 126 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 80823ac..05cad58 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2991,21 +2991,21 @@ static void get_command(struct seq_file *m, Scsi_Cmnd * ptr)
 		ptr->SCp.buffers_residual);
 
 	if (ptr->SCp.phase & not_issued)
-		seq_printf(m, "not issued|");
+		seq_puts(m, "not issued|");
 	if (ptr->SCp.phase & selecting)
-		seq_printf(m, "selecting|");
+		seq_puts(m, "selecting|");
 	if (ptr->SCp.phase & disconnected)
-		seq_printf(m, "disconnected|");
+		seq_puts(m, "disconnected|");
 	if (ptr->SCp.phase & aborted)
-		seq_printf(m, "aborted|");
+		seq_puts(m, "aborted|");
 	if (ptr->SCp.phase & identified)
-		seq_printf(m, "identified|");
+		seq_puts(m, "identified|");
 	if (ptr->SCp.phase & completed)
-		seq_printf(m, "completed|");
+		seq_puts(m, "completed|");
 	if (ptr->SCp.phase & spiordy)
-		seq_printf(m, "spiordy|");
+		seq_puts(m, "spiordy|");
 	if (ptr->SCp.phase & syncneg)
-		seq_printf(m, "syncneg|");
+		seq_puts(m, "syncneg|");
 	seq_printf(m, "; next=0x%p\n", SCNEXT(ptr));
 }
 
@@ -3016,256 +3016,256 @@ static void get_ports(struct seq_file *m, struct Scsi_Host *shpnt)
 	seq_printf(m, "\n%s: %s(%s) ", CURRENT_SC ? "on bus" : "waiting", states[STATE].name, states[PREVSTATE].name);
 
 	s = GETPORT(SCSISEQ);
-	seq_printf(m, "SCSISEQ( ");
+	seq_puts(m, "SCSISEQ( ");
 	if (s & TEMODEO)
-		seq_printf(m, "TARGET MODE ");
+		seq_puts(m, "TARGET MODE ");
 	if (s & ENSELO)
-		seq_printf(m, "SELO ");
+		seq_puts(m, "SELO ");
 	if (s & ENSELI)
-		seq_printf(m, "SELI ");
+		seq_puts(m, "SELI ");
 	if (s & ENRESELI)
-		seq_printf(m, "RESELI ");
+		seq_puts(m, "RESELI ");
 	if (s & ENAUTOATNO)
-		seq_printf(m, "AUTOATNO ");
+		seq_puts(m, "AUTOATNO ");
 	if (s & ENAUTOATNI)
-		seq_printf(m, "AUTOATNI ");
+		seq_puts(m, "AUTOATNI ");
 	if (s & ENAUTOATNP)
-		seq_printf(m, "AUTOATNP ");
+		seq_puts(m, "AUTOATNP ");
 	if (s & SCSIRSTO)
-		seq_printf(m, "SCSIRSTO ");
-	seq_printf(m, ");");
+		seq_puts(m, "SCSIRSTO ");
+	seq_puts(m, ");");
 
-	seq_printf(m, " SCSISIG(");
+	seq_puts(m, " SCSISIG(");
 	s = GETPORT(SCSISIG);
 	switch (s & P_MASK) {
 	case P_DATAO:
-		seq_printf(m, "DATA OUT");
+		seq_puts(m, "DATA OUT");
 		break;
 	case P_DATAI:
-		seq_printf(m, "DATA IN");
+		seq_puts(m, "DATA IN");
 		break;
 	case P_CMD:
-		seq_printf(m, "COMMAND");
+		seq_puts(m, "COMMAND");
 		break;
 	case P_STATUS:
-		seq_printf(m, "STATUS");
+		seq_puts(m, "STATUS");
 		break;
 	case P_MSGO:
-		seq_printf(m, "MESSAGE OUT");
+		seq_puts(m, "MESSAGE OUT");
 		break;
 	case P_MSGI:
-		seq_printf(m, "MESSAGE IN");
+		seq_puts(m, "MESSAGE IN");
 		break;
 	default:
-		seq_printf(m, "*invalid*");
+		seq_puts(m, "*invalid*");
 		break;
 	}
 
-	seq_printf(m, "); ");
+	seq_puts(m, "); ");
 
 	seq_printf(m, "INTSTAT (%s); ", TESTHI(DMASTAT, INTSTAT) ? "hi" : "lo");
 
-	seq_printf(m, "SSTAT( ");
+	seq_puts(m, "SSTAT( ");
 	s = GETPORT(SSTAT0);
 	if (s & TARGET)
-		seq_printf(m, "TARGET ");
+		seq_puts(m, "TARGET ");
 	if (s & SELDO)
-		seq_printf(m, "SELDO ");
+		seq_puts(m, "SELDO ");
 	if (s & SELDI)
-		seq_printf(m, "SELDI ");
+		seq_puts(m, "SELDI ");
 	if (s & SELINGO)
-		seq_printf(m, "SELINGO ");
+		seq_puts(m, "SELINGO ");
 	if (s & SWRAP)
-		seq_printf(m, "SWRAP ");
+		seq_puts(m, "SWRAP ");
 	if (s & SDONE)
-		seq_printf(m, "SDONE ");
+		seq_puts(m, "SDONE ");
 	if (s & SPIORDY)
-		seq_printf(m, "SPIORDY ");
+		seq_puts(m, "SPIORDY ");
 	if (s & DMADONE)
-		seq_printf(m, "DMADONE ");
+		seq_puts(m, "DMADONE ");
 
 	s = GETPORT(SSTAT1);
 	if (s & SELTO)
-		seq_printf(m, "SELTO ");
+		seq_puts(m, "SELTO ");
 	if (s & ATNTARG)
-		seq_printf(m, "ATNTARG ");
+		seq_puts(m, "ATNTARG ");
 	if (s & SCSIRSTI)
-		seq_printf(m, "SCSIRSTI ");
+		seq_puts(m, "SCSIRSTI ");
 	if (s & PHASEMIS)
-		seq_printf(m, "PHASEMIS ");
+		seq_puts(m, "PHASEMIS ");
 	if (s & BUSFREE)
-		seq_printf(m, "BUSFREE ");
+		seq_puts(m, "BUSFREE ");
 	if (s & SCSIPERR)
-		seq_printf(m, "SCSIPERR ");
+		seq_puts(m, "SCSIPERR ");
 	if (s & PHASECHG)
-		seq_printf(m, "PHASECHG ");
+		seq_puts(m, "PHASECHG ");
 	if (s & REQINIT)
-		seq_printf(m, "REQINIT ");
-	seq_printf(m, "); ");
+		seq_puts(m, "REQINIT ");
+	seq_puts(m, "); ");
 
 
-	seq_printf(m, "SSTAT( ");
+	seq_puts(m, "SSTAT( ");
 
 	s = GETPORT(SSTAT0) & GETPORT(SIMODE0);
 
 	if (s & TARGET)
-		seq_printf(m, "TARGET ");
+		seq_puts(m, "TARGET ");
 	if (s & SELDO)
-		seq_printf(m, "SELDO ");
+		seq_puts(m, "SELDO ");
 	if (s & SELDI)
-		seq_printf(m, "SELDI ");
+		seq_puts(m, "SELDI ");
 	if (s & SELINGO)
-		seq_printf(m, "SELINGO ");
+		seq_puts(m, "SELINGO ");
 	if (s & SWRAP)
-		seq_printf(m, "SWRAP ");
+		seq_puts(m, "SWRAP ");
 	if (s & SDONE)
-		seq_printf(m, "SDONE ");
+		seq_puts(m, "SDONE ");
 	if (s & SPIORDY)
-		seq_printf(m, "SPIORDY ");
+		seq_puts(m, "SPIORDY ");
 	if (s & DMADONE)
-		seq_printf(m, "DMADONE ");
+		seq_puts(m, "DMADONE ");
 
 	s = GETPORT(SSTAT1) & GETPORT(SIMODE1);
 
 	if (s & SELTO)
-		seq_printf(m, "SELTO ");
+		seq_puts(m, "SELTO ");
 	if (s & ATNTARG)
-		seq_printf(m, "ATNTARG ");
+		seq_puts(m, "ATNTARG ");
 	if (s & SCSIRSTI)
-		seq_printf(m, "SCSIRSTI ");
+		seq_puts(m, "SCSIRSTI ");
 	if (s & PHASEMIS)
-		seq_printf(m, "PHASEMIS ");
+		seq_puts(m, "PHASEMIS ");
 	if (s & BUSFREE)
-		seq_printf(m, "BUSFREE ");
+		seq_puts(m, "BUSFREE ");
 	if (s & SCSIPERR)
-		seq_printf(m, "SCSIPERR ");
+		seq_puts(m, "SCSIPERR ");
 	if (s & PHASECHG)
-		seq_printf(m, "PHASECHG ");
+		seq_puts(m, "PHASECHG ");
 	if (s & REQINIT)
-		seq_printf(m, "REQINIT ");
-	seq_printf(m, "); ");
+		seq_puts(m, "REQINIT ");
+	seq_puts(m, "); ");
 
-	seq_printf(m, "SXFRCTL0( ");
+	seq_puts(m, "SXFRCTL0( ");
 
 	s = GETPORT(SXFRCTL0);
 	if (s & SCSIEN)
-		seq_printf(m, "SCSIEN ");
+		seq_puts(m, "SCSIEN ");
 	if (s & DMAEN)
-		seq_printf(m, "DMAEN ");
+		seq_puts(m, "DMAEN ");
 	if (s & CH1)
-		seq_printf(m, "CH1 ");
+		seq_puts(m, "CH1 ");
 	if (s & CLRSTCNT)
-		seq_printf(m, "CLRSTCNT ");
+		seq_puts(m, "CLRSTCNT ");
 	if (s & SPIOEN)
-		seq_printf(m, "SPIOEN ");
+		seq_puts(m, "SPIOEN ");
 	if (s & CLRCH1)
-		seq_printf(m, "CLRCH1 ");
-	seq_printf(m, "); ");
+		seq_puts(m, "CLRCH1 ");
+	seq_puts(m, "); ");
 
-	seq_printf(m, "SIGNAL( ");
+	seq_puts(m, "SIGNAL( ");
 
 	s = GETPORT(SCSISIG);
 	if (s & SIG_ATNI)
-		seq_printf(m, "ATNI ");
+		seq_puts(m, "ATNI ");
 	if (s & SIG_SELI)
-		seq_printf(m, "SELI ");
+		seq_puts(m, "SELI ");
 	if (s & SIG_BSYI)
-		seq_printf(m, "BSYI ");
+		seq_puts(m, "BSYI ");
 	if (s & SIG_REQI)
-		seq_printf(m, "REQI ");
+		seq_puts(m, "REQI ");
 	if (s & SIG_ACKI)
-		seq_printf(m, "ACKI ");
-	seq_printf(m, "); ");
+		seq_puts(m, "ACKI ");
+	seq_puts(m, "); ");
 
 	seq_printf(m, "SELID(%02x), ", GETPORT(SELID));
 
 	seq_printf(m, "STCNT(%d), ", GETSTCNT());
 
-	seq_printf(m, "SSTAT2( ");
+	seq_puts(m, "SSTAT2( ");
 
 	s = GETPORT(SSTAT2);
 	if (s & SOFFSET)
-		seq_printf(m, "SOFFSET ");
+		seq_puts(m, "SOFFSET ");
 	if (s & SEMPTY)
-		seq_printf(m, "SEMPTY ");
+		seq_puts(m, "SEMPTY ");
 	if (s & SFULL)
-		seq_printf(m, "SFULL ");
+		seq_puts(m, "SFULL ");
 	seq_printf(m, "); SFCNT (%d); ", s & (SFULL | SFCNT));
 
 	s = GETPORT(SSTAT3);
 	seq_printf(m, "SCSICNT (%d), OFFCNT(%d), ", (s & 0xf0) >> 4, s & 0x0f);
 
-	seq_printf(m, "SSTAT4( ");
+	seq_puts(m, "SSTAT4( ");
 	s = GETPORT(SSTAT4);
 	if (s & SYNCERR)
-		seq_printf(m, "SYNCERR ");
+		seq_puts(m, "SYNCERR ");
 	if (s & FWERR)
-		seq_printf(m, "FWERR ");
+		seq_puts(m, "FWERR ");
 	if (s & FRERR)
-		seq_printf(m, "FRERR ");
-	seq_printf(m, "); ");
+		seq_puts(m, "FRERR ");
+	seq_puts(m, "); ");
 
-	seq_printf(m, "DMACNTRL0( ");
+	seq_puts(m, "DMACNTRL0( ");
 	s = GETPORT(DMACNTRL0);
 	seq_printf(m, "%s ", s & _8BIT ? "8BIT" : "16BIT");
 	seq_printf(m, "%s ", s & DMA ? "DMA" : "PIO");
 	seq_printf(m, "%s ", s & WRITE_READ ? "WRITE" : "READ");
 	if (s & ENDMA)
-		seq_printf(m, "ENDMA ");
+		seq_puts(m, "ENDMA ");
 	if (s & INTEN)
-		seq_printf(m, "INTEN ");
+		seq_puts(m, "INTEN ");
 	if (s & RSTFIFO)
-		seq_printf(m, "RSTFIFO ");
+		seq_puts(m, "RSTFIFO ");
 	if (s & SWINT)
-		seq_printf(m, "SWINT ");
-	seq_printf(m, "); ");
+		seq_puts(m, "SWINT ");
+	seq_puts(m, "); ");
 
-	seq_printf(m, "DMASTAT( ");
+	seq_puts(m, "DMASTAT( ");
 	s = GETPORT(DMASTAT);
 	if (s & ATDONE)
-		seq_printf(m, "ATDONE ");
+		seq_puts(m, "ATDONE ");
 	if (s & WORDRDY)
-		seq_printf(m, "WORDRDY ");
+		seq_puts(m, "WORDRDY ");
 	if (s & DFIFOFULL)
-		seq_printf(m, "DFIFOFULL ");
+		seq_puts(m, "DFIFOFULL ");
 	if (s & DFIFOEMP)
-		seq_printf(m, "DFIFOEMP ");
-	seq_printf(m, ")\n");
+		seq_puts(m, "DFIFOEMP ");
+	seq_puts(m, ")\n");
 
-	seq_printf(m, "enabled interrupts( ");
+	seq_puts(m, "enabled interrupts( ");
 
 	s = GETPORT(SIMODE0);
 	if (s & ENSELDO)
-		seq_printf(m, "ENSELDO ");
+		seq_puts(m, "ENSELDO ");
 	if (s & ENSELDI)
-		seq_printf(m, "ENSELDI ");
+		seq_puts(m, "ENSELDI ");
 	if (s & ENSELINGO)
-		seq_printf(m, "ENSELINGO ");
+		seq_puts(m, "ENSELINGO ");
 	if (s & ENSWRAP)
-		seq_printf(m, "ENSWRAP ");
+		seq_puts(m, "ENSWRAP ");
 	if (s & ENSDONE)
-		seq_printf(m, "ENSDONE ");
+		seq_puts(m, "ENSDONE ");
 	if (s & ENSPIORDY)
-		seq_printf(m, "ENSPIORDY ");
+		seq_puts(m, "ENSPIORDY ");
 	if (s & ENDMADONE)
-		seq_printf(m, "ENDMADONE ");
+		seq_puts(m, "ENDMADONE ");
 
 	s = GETPORT(SIMODE1);
 	if (s & ENSELTIMO)
-		seq_printf(m, "ENSELTIMO ");
+		seq_puts(m, "ENSELTIMO ");
 	if (s & ENATNTARG)
-		seq_printf(m, "ENATNTARG ");
+		seq_puts(m, "ENATNTARG ");
 	if (s & ENPHASEMIS)
-		seq_printf(m, "ENPHASEMIS ");
+		seq_puts(m, "ENPHASEMIS ");
 	if (s & ENBUSFREE)
-		seq_printf(m, "ENBUSFREE ");
+		seq_puts(m, "ENBUSFREE ");
 	if (s & ENSCSIPERR)
-		seq_printf(m, "ENSCSIPERR ");
+		seq_puts(m, "ENSCSIPERR ");
 	if (s & ENPHASECHG)
-		seq_printf(m, "ENPHASECHG ");
+		seq_puts(m, "ENPHASECHG ");
 	if (s & ENREQINIT)
-		seq_printf(m, "ENREQINIT ");
-	seq_printf(m, ")\n");
+		seq_puts(m, "ENREQINIT ");
+	seq_puts(m, ")\n");
 }
 
 static int aha152x_set_info(struct Scsi_Host *shpnt, char *buffer, int length)
@@ -3317,7 +3317,7 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 
-	seq_printf(m, AHA152X_REVID "\n");
+	seq_puts(m, AHA152X_REVID "\n");
 
 	seq_printf(m, "ioports 0x%04lx to 0x%04lx\n",
 		shpnt->io_port, shpnt->io_port + shpnt->n_io_port - 1);
@@ -3331,7 +3331,7 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 	seq_printf(m, "%d commands currently queued\n", HOSTDATA(shpnt)->commands);
 
 	if(SYNCHRONOUS) {
-		seq_printf(m, "synchronously operating targets (tick=50 ns):\n");
+		seq_puts(m, "synchronously operating targets (tick=50 ns):\n");
 		for (i = 0; i < 8; i++)
 			if (HOSTDATA(shpnt)->syncrate[i] & 0x7f)
 				seq_printf(m, "target %d: period %dT/%dns; req/ack offset %d\n",
@@ -3344,7 +3344,7 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 #define PDEBUG(flags,txt) \
 	if (HOSTDATA(shpnt)->debug & flags) seq_printf(m, "(%s) ", txt);
 
-	seq_printf(m, "enabled debugging options: ");
+	seq_puts(m, "enabled debugging options: ");
 
 	PDEBUG(debug_procinfo, "procinfo");
 	PDEBUG(debug_queue, "queue");
@@ -3360,31 +3360,31 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 	PDEBUG(debug_locking, "locks");
 	PDEBUG(debug_phases, "phases");
 
-	seq_printf(m, "\n");
+	seq_puts(m, "\n");
 #endif
 
-	seq_printf(m, "\nqueue status:\n");
+	seq_puts(m, "\nqueue status:\n");
 	DO_LOCK(flags);
 	if (ISSUE_SC) {
-		seq_printf(m, "not yet issued commands:\n");
+		seq_puts(m, "not yet issued commands:\n");
 		for (ptr = ISSUE_SC; ptr; ptr = SCNEXT(ptr))
 			get_command(m, ptr);
 	} else
-		seq_printf(m, "no not yet issued commands\n");
+		seq_puts(m, "no not yet issued commands\n");
 	DO_UNLOCK(flags);
 
 	if (CURRENT_SC) {
-		seq_printf(m, "current command:\n");
+		seq_puts(m, "current command:\n");
 		get_command(m, CURRENT_SC);
 	} else
-		seq_printf(m, "no current command\n");
+		seq_puts(m, "no current command\n");
 
 	if (DISCONNECTED_SC) {
-		seq_printf(m, "disconnected commands:\n");
+		seq_puts(m, "disconnected commands:\n");
 		for (ptr = DISCONNECTED_SC; ptr; ptr = SCNEXT(ptr))
 			get_command(m, ptr);
 	} else
-		seq_printf(m, "no disconnected commands\n");
+		seq_puts(m, "no disconnected commands\n");
 
 	get_ports(m, shpnt);
 
-- 
2.0.4
