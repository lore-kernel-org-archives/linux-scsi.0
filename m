From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH]fix irq handling for DC395
Date: Fri, 16 May 2003 18:56:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305161856.22151.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.KONTENT.De ([81.88.34.36]:36258 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264493AbTEPQnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 12:43:04 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Hi,

this fix makes sure that all test in irq handling in that
driver are for NULL thus fixing an oops.

	Regards
		Oliver

You can import this changeset into BK by piping this whole message to:
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1094, 2003-05-14 08:45:30+02:00, oliver@oenone.homelinux.org
  - fix IRQ problem


 dc395x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Wed May 14 10:40:10 2003
+++ b/drivers/scsi/dc395x.c	Wed May 14 10:40:10 2003
@@ -5364,7 +5364,7 @@
 	eeprom = &dc395x_trm_eepromBuf[index];
 	pTempACB = DC395x_pACB_start;
 	if (pTempACB != NULL) {
-		for (; (pTempACB != (struct AdapterCtlBlk *) -1);) {
+		while (pTempACB) {
 			if (pTempACB->IRQLevel == irq) {
 				used_irq = 1;
 				break;
@@ -5842,11 +5842,11 @@
 		if (!DC395x_pACB_start) {
 			DC395x_pACB_start = pACB;
 			DC395x_pACB_current = pACB;
-			pACB->pNextACB = (struct AdapterCtlBlk *) -1;
+			pACB->pNextACB = NULL;
 		} else {
 			DC395x_pACB_current->pNextACB = pACB;
 			DC395x_pACB_current = pACB;
-			pACB->pNextACB = (struct AdapterCtlBlk *) -1;
+			pACB->pNextACB = NULL;
 		}
 		/*DC395x_ACB_UNLOCK(pACB,acb_flags); */
 		return host;
@@ -6077,13 +6077,13 @@
 
 	pACB = DC395x_pACB_start;
 
-	while (pACB != (struct AdapterCtlBlk *) -1) {
+	while (pACB) {
 		shpnt = pACB->pScsiHost;
 		if (shpnt->host_no == hostno)
 			break;
 		pACB = pACB->pNextACB;
 	}
-	if (pACB == (struct AdapterCtlBlk *) -1)
+	if (!pACB)
 		return -ESRCH;
 
 	if (!shpnt)
@@ -6306,7 +6306,7 @@
 		 */
 		int irq_count;
 		for (irq_count = 0, pACB = DC395x_pACB_start;
-		     pACB != (struct AdapterCtlBlk *) -1;
+		     pACB;
 		     pACB = pACB->pNextACB) {
 			if (pACB->IRQLevel == host->irq)
 				++irq_count;

===================================================================


This BitKeeper patch contains the following changesets:
1.1094
## Wrapped with gzip_uu ##


begin 664 bkpatch3163
M'XL(`.H`PCX``[U4VVK;0!!]UG[%E+RD!$NSVHLNP<&YE#;4I*X;?X`LCV,E
MNAA)=ARJC^]*=FT*P;2A[4HPPYS#W/:P)S"IJ`RM(DW65+(3^%14=6CEM'I:
M978>961BXZ(P,6=19.1LB<Y]250YLU@$BAG&**KC!1B@"BUNBWVD?EE2:(T_
M?)P,+\>,]?MPO8CR!_I&-?3[K"[*=93.JD%4+](BM^LRRJN,ZLB.BZS94QL7
MT36?XIY`I1NN47I-S&><1Y+3#%WI:WG(UC9Z+)=)P@5JXZE&R8"[[`:XS3&0
M@,)!Y7#C^*%4H<`S=$-$V(X]*"@O<K+;`FF2KS9V43[`&8<>LBOXN]-<LQAZ
M,$\V<#O^"LNRF*:4L<^@%'<]-CHLDO7^\#"&$;*+8S,UL[+%*J>*JV1[S1L[
MWNY.NMKEW$.OD;[P@F9.@<!HS@,NIY+\Z5OS*BY12X&\42A%T*GE57JKG'_4
M.WNDQ^F@C-:4VTEJ5S512B_47>"QUELQ<2UDHR6JH).3^%5+(D3^.UK2T-/_
M3TO=HK]`KWSN?J.-T>L[?X/(;I30'G!VN[.6];Q(4H+3Y3UER\OKJ_?PW9!\
MJ3K2UEJ6U4*]B^4=;6KC01_N)L/A><<,=LS@.%.CCRUS9_=U?]8T<;W#6VLE
J<SA]UZ$&$]A5V5G+@O:TX/GAH8L7%#]5JZP_G_NHA2O8#ZX.86!(!0``
`
end

