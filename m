From: Guennadi Liakhovetski <gl@dsa-ac.de>
Subject: Re: TMSCSIM [2.6]
Date: Fri, 28 Nov 2003 10:05:09 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0311280917570.2137-100000@pcgl.dsa-ac.de>
References: <1069954227.1667.1.camel@work.thl.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dsa-ac.de ([62.112.80.99]:48903 "EHLO k2.dsa-ac.de")
	by vger.kernel.org with ESMTP id S262074AbTK1JFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 04:05:15 -0500
In-Reply-To: <1069954227.1667.1.camel@work.thl.home>
List-Id: linux-scsi@vger.kernel.org
To: Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>
Cc: linux-scsi@vger.kernel.org, Chiaki Ishikawa <ishikawa@yk.rim.or.jp>

Sorry, you'll eventually get this patch twice - couldn't send from home
(provider busy:-().

Also, could you try compiling it without preemption (don't know, uf you,
Torsten, have it on too). Not that I suspected a bug there - rather
tmscsim's incompatibility with it (although I also have it on).

I think, also, it would make it easier for me, if we agree on the same key
configuea-options for the testing - no SMP, no preemption and the
following hacking options on:
CONFIG_DEBUG_KERNEL
CONFIG_MAGIC_SYSRQ
CONFIG_FRAME_POINTER
Not sure if there are any other options in the kernel, that will change
macros / inlines? And the 2.95.3. compiler, please. I want to try to make
our binaries compatible, so, that I can follow your backtrace on my
compiled binaries. Also, the CPU optimisation could be important. Should
we agree on some minimum common CPU, say, Pentium Classic? But, anyway,
try the patch below first.

Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany

diff -u linux/drivers/scsi/scsiiom.c~ linux/drivers/scsi/scsiiom.c
--- linux/drivers/scsi/scsiiom.c~	Thu Nov 27 23:02:35 2003
+++ linux/drivers/scsi/scsiiom.c	Fri Nov 28 08:29:40 2003
@@ -1439,7 +1439,7 @@
 		goto ckc_e;
 	    }
 	    SET_RES_DRV(pcmd->result,DRIVER_SENSE);
-//	    pcmd->use_sg	 = pSRB->SavedSGCount;
+	    pcmd->use_sg	 = pSRB->SavedSGCount;
 	    //pSRB->ScsiCmdLen	 = (UCHAR) (pSRB->Segment1[0] >> 8);
 	    DEBUG0 (printk ("DC390: RETRY pid %li (%02x), target %02i-%02i\n", pcmd->pid, pcmd->cmnd[0], pcmd->device->id, pcmd->device->lun));
 	    pSRB->SGIndex = 0;
@@ -1734,22 +1734,22 @@
 static void __inline__
 dc390_RequestSense( PACB pACB, PDCB pDCB, PSRB pSRB )
 {
-//    PSCSICMD  pcmd;
+    PSCSICMD  pcmd;
+
+    pcmd = pSRB->pcmd;

     REMOVABLEDEBUG(printk (KERN_INFO "DC390: RequestSense (Cmd %02x, Id %02x, LUN %02x)\n",\
-	    pSRB->pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));
+	    pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN));

     pSRB->SRBFlag |= AUTO_REQSENSE;
     //pSRB->Segment0[0] = (UINT) pSRB->CmdBlock[0];
     //pSRB->Segment0[1] = (UINT) pSRB->CmdBlock[4];
-    //pSRB->Segment1[0] = ((UINT)(pSRB->pcmd->cmd_len) << 8) + pSRB->SGcount;
+    //pSRB->Segment1[0] = ((UINT)(pcmd->cmd_len) << 8) + pSRB->SGcount;
     //pSRB->Segment1[1] = pSRB->TotalXferredLen;
-    pSRB->SavedSGCount = pSRB->SGcount;
+    pSRB->SavedSGCount = pcmd->use_sg;
     pSRB->SavedTotXLen = pSRB->TotalXferredLen;
     pSRB->AdaptStatus = 0;
     pSRB->TargetStatus = 0; /* CHECK_CONDITION<<1; */
-
-//    pcmd = pSRB->pcmd;

     /* We are called from SRBdone, original PCI mapping has been removed
      * already, new one is set up from StartSCSI */

