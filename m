From: David Miller <davem@davemloft.net>
Subject: [PATCH] scsi: Remove warnings after vsprintf %pV introducation.
Date: Tue, 31 Aug 2010 13:35:31 -0700 (PDT)
Message-ID: <20100831.133531.186321637.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51114
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073Ab0HaUfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2010 16:35:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, joe@perches.com, sfr@canb.auug.org.au


GCC warns about empty printf format strings, and after
the addition of %pV these existing such cases in the
scsi driver layer were exposed enough for the compiler
to start seeing them.

Based almost entirely upon a patch by Joe Perches.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index cd05e04..d0c8234 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1404,13 +1404,13 @@ void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
 {
 	struct scsi_sense_hdr sshdr;
 
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_decode_sense_buffer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
 	scsi_show_sense_hdr(&sshdr);
 	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				 &sshdr);
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
 }
 EXPORT_SYMBOL(scsi_print_sense);
@@ -1453,7 +1453,7 @@ EXPORT_SYMBOL(scsi_show_result);
 
 void scsi_print_result(struct scsi_cmnd *cmd)
 {
-	scmd_printk(KERN_INFO, cmd, "");
+	scmd_printk(KERN_INFO, cmd, " ");
 	scsi_show_result(cmd->result);
 }
 EXPORT_SYMBOL(scsi_print_result);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2714bec..cd71f46 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2625,15 +2625,15 @@ module_exit(exit_sd);
 static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
-	sd_printk(KERN_INFO, sdkp, "");
+	sd_printk(KERN_INFO, sdkp, " ");
 	scsi_show_sense_hdr(sshdr);
-	sd_printk(KERN_INFO, sdkp, "");
+	sd_printk(KERN_INFO, sdkp, " ");
 	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
 {
-	sd_printk(KERN_INFO, sdkp, "");
+	sd_printk(KERN_INFO, sdkp, " ");
 	scsi_show_result(result);
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index a7bc8b7..d740a5b 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -72,10 +72,7 @@ static void sym_printl_hex(u_char *p, int n)
 
 static void sym_print_msg(struct sym_ccb *cp, char *label, u_char *msg)
 {
-	if (label)
-		sym_print_addr(cp->cmd, "%s: ", label);
-	else
-		sym_print_addr(cp->cmd, "");
+	sym_print_addr(cp->cmd, "%s: ", label);
 
 	spi_print_msg(msg);
 	printf("\n");
@@ -4558,7 +4555,8 @@ static void sym_int_sir(struct sym_hcb *np)
 			switch (np->msgin [2]) {
 			case M_X_MODIFY_DP:
 				if (DEBUG_FLAGS & DEBUG_POINTER)
-					sym_print_msg(cp, NULL, np->msgin);
+					sym_print_msg(cp, "extended msg ",
+						      np->msgin);
 				tmp = (np->msgin[3]<<24) + (np->msgin[4]<<16) + 
 				      (np->msgin[5]<<8)  + (np->msgin[6]);
 				sym_modify_dp(np, tp, cp, tmp);
@@ -4585,7 +4583,7 @@ static void sym_int_sir(struct sym_hcb *np)
 		 */
 		case M_IGN_RESIDUE:
 			if (DEBUG_FLAGS & DEBUG_POINTER)
-				sym_print_msg(cp, NULL, np->msgin);
+				sym_print_msg(cp, "half byte ", np->msgin);
 			if (cp->host_flags & HF_SENSE)
 				OUTL_DSP(np, SCRIPTA_BA(np, clrack));
 			else
