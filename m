From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 06/10] Use SPI messages where possible
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <11435618242974-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.magma.ca ([206.191.0.250]:38326 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1751205AbWC1QDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:31 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Now sym2 is using spi_print_msg, we don't need to have our own messages
for IGNORE WIDE RESIDUE and MODIFY DATA POINTER, so provide the option
of passing NULL for the label.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

63492c20b95a7cae585076a01e3932f8da0725af
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index a6cbb90..1d01c24 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -72,7 +72,10 @@ static void sym_printl_hex(u_char *p, in
 
 static void sym_print_msg(struct sym_ccb *cp, char *label, u_char *msg)
 {
-	sym_print_addr(cp->cmd, "%s: ", label);
+	if (label)
+		sym_print_addr(cp->cmd, "%s: ", label);
+	else
+		sym_print_addr(cp->cmd, "");
 
 	spi_print_msg(msg);
 	printf("\n");
@@ -4486,7 +4489,7 @@ static void sym_int_sir (struct sym_hcb 
 			switch (np->msgin [2]) {
 			case M_X_MODIFY_DP:
 				if (DEBUG_FLAGS & DEBUG_POINTER)
-					sym_print_msg(cp,"modify DP",np->msgin);
+					sym_print_msg(cp, NULL, np->msgin);
 				tmp = (np->msgin[3]<<24) + (np->msgin[4]<<16) + 
 				      (np->msgin[5]<<8)  + (np->msgin[6]);
 				sym_modify_dp(np, tp, cp, tmp);
@@ -4513,7 +4516,7 @@ static void sym_int_sir (struct sym_hcb 
 		 */
 		case M_IGN_RESIDUE:
 			if (DEBUG_FLAGS & DEBUG_POINTER)
-				sym_print_msg(cp,"ign wide residue", np->msgin);
+				sym_print_msg(cp, NULL, np->msgin);
 			if (cp->host_flags & HF_SENSE)
 				OUTL_DSP(np, SCRIPTA_BA(np, clrack));
 			else
-- 
1.2.4.g375a5


