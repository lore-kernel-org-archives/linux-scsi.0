From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6]
Date: Fri, 28 Nov 2003 08:33:58 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311280831330.1470-100000@poirot.grange>
References: <3FC6A7B0.3050401@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:25747 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263378AbTK1Sqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 13:46:31 -0500
In-Reply-To: <3FC6A7B0.3050401@yk.rim.or.jp>
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>, gl@dsa-ac.de

On Fri, 28 Nov 2003, Chiaki wrote:

> I am afraid that it didn't solve the problem.
> I got the same kernel bug triggered at the same place.

Ok, then, please, try this one (on the top of yesterday's):

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

Thanks
Guennadi
---
Guennadi Liakhovetski


