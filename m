From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [Dc395x] Re: The oops
Date: Mon, 5 May 2003 15:13:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305051513.40726.oliver@neukum.org>
References: <1051757703.898.7.camel@localhost> <20030501090800.GA12766@twibble.org> <1052099389.839.5.camel@localhost>
Reply-To: oliver@neukum.name
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.KONTENT.De ([81.88.34.36]:62423 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S262171AbTEENBO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2003 09:01:14 -0400
In-Reply-To: <1052099389.839.5.camel@localhost>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Ali Akcaagac <aliakc@web.de>, dc395x@twibble.org
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dougg@torque.net>


> Ok I wanted to let you know that your NULL fixes are working fine now.
> The driver works in good state and didn't caused any crashes. I'm now on
> -bk12.

Hi Douglas,

according to Linus' new policy of accepting only reviewed patches,
could you have a look at the included patch, bless it and send it to
Linus?
It fixes IRQ handling for the DC395 by properly putting a NULL check
in place to mark the end of the list of DC395 cards.

	Regards
		Oliver

You can import this changeset into BK by piping this whole message to:
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.1133, 2003-05-01 12:06:58+02:00, oliver@oenone.homelinux.org
  dc395x-adapter-list.patch


 dc395x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Thu May  1 12:08:12 2003
+++ b/drivers/scsi/dc395x.c	Thu May  1 12:08:12 2003
@@ -5363,7 +5363,7 @@
 	eeprom = &dc395x_trm_eepromBuf[index];
 	pTempACB = DC395x_pACB_start;
 	if (pTempACB != NULL) {
-		for (; (pTempACB != (struct AdapterCtlBlk *) -1);) {
+		for (; (pTempACB != (struct AdapterCtlBlk *)NULL);) {
 			if (pTempACB->IRQLevel == irq) {
 				used_irq = 1;
 				break;
@@ -5841,11 +5841,11 @@
 		if (!DC395x_pACB_start) {
 			DC395x_pACB_start = pACB;
 			DC395x_pACB_current = pACB;
-			pACB->pNextACB = (struct AdapterCtlBlk *) -1;
+			pACB->pNextACB = (struct AdapterCtlBlk *)NULL;
 		} else {
 			DC395x_pACB_current->pNextACB = pACB;
 			DC395x_pACB_current = pACB;
-			pACB->pNextACB = (struct AdapterCtlBlk *) -1;
+			pACB->pNextACB = (struct AdapterCtlBlk *)NULL;
 		}
 		/*DC395x_ACB_UNLOCK(pACB,acb_flags); */
 		return host;
@@ -6076,13 +6076,13 @@
 
 	pACB = DC395x_pACB_start;
 
-	while (pACB != (struct AdapterCtlBlk *) -1) {
+	while (pACB != (struct AdapterCtlBlk *)NULL) {
 		shpnt = pACB->pScsiHost;
 		if (shpnt->host_no == hostno)
 			break;
 		pACB = pACB->pNextACB;
 	}
-	if (pACB == (struct AdapterCtlBlk *) -1)
+	if (pACB == (struct AdapterCtlBlk *)NULL)
 		return -ESRCH;
 
 	if (!shpnt)
@@ -6305,7 +6305,7 @@
 		 */
 		int irq_count;
 		for (irq_count = 0, pACB = DC395x_pACB_start;
-		     pACB != (struct AdapterCtlBlk *) -1;
+		     pACB != (struct AdapterCtlBlk *)NULL;
 		     pACB = pACB->pNextACB) {
 			if (pACB->IRQLevel == host->irq)
 				++irq_count;

===================================================================


This BitKeeper patch contains the following changesets:
1.1133
## Wrapped with gzip_uu ##


begin 664 bkpatch6943
M'XL(``SRL#X``[64;4_;,!#'7\>?XB;>P*HD=W'BI*F"@+('M(HA-CZ`25U:
M-6VBQ`6FY<//>1`PJ>N`#2?2)3[?SW?GO[P'5Y4J8RO/%K>J9'OP.:^T^57K
M?*V<>;Y2V6*]N7?R\L8X+_/<.-UFVNTBW.NEK4NE*K=2A1<PL^A"ZG0.QE?%
M%CG\84;_*%1L77[X=#4YOF0L26`\E^L;]4UI2!*F\_)69M/J2.IYEJ\=7<IU
MM5):.FF^JA^6UAZB9YZ`0HZ!J$F@']8I38FD3VJ*GA\)GW79'6VKXW<61]\3
M'GG$T;"$)]@ID$/$.2!W,7"1@+P811Q$`S0?"#O8,""PD9W`_ZUFS%*8IGP8
MW-MR*@NM2CM;5-HIFL:R+T#"CXA=/#:4V2\<C*%$=KBKMGI:-CYSTFFU<+MT
MG/1)#RG$L/8C'@[KF1IRE#,:DG_MJ^@:VDQ?C`V0"%&8Q@@>>-B*9NOR1D!O
ME/J_<J-:>#SJ9.4]T13%&,04])KZ<W]@(,`6;R*ILU61E[K;>X>^/@(/D8S,
MND/X"G9YU[Y&-A?;S^,5^CL-N!!`[*RWEC7+2]@?P7[Q7:V*X_$)O$M@O]+E
M)M5PW*4YUME)MH3W!^=7D\G!Z`!^&D[D^RVGLY9E-<'V87&N[G6#V4T9M82H
M)T2O(P@,APVAM];=?)$I4\ESJFAJ$!@%77QKK<6L#T[^$FQ".;;)]]:RH!G/
<V7GT>'NG<Y4NJ\TJ"167<B@4^P6\K]_F*08`````
`
end

