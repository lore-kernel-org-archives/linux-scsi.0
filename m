From: Eric Moore <eric.moore@lsi.com>
Subject: RE: [PATCH] - export scsilun_to_int
Date: Thu, 1 Feb 2007 10:24:43 -0700
Message-ID: <20070201172442.GA8322@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43023 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXBARYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 12:24:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Wednesday, January 31, 2007 6:52 PM, James Bottomley wrote:
> 
> what's wrong with
> 
> memcmp(lun1->scsi_lun, lun2->scsi_lun, 8)
> 
> rather than introducing a wrapper?  The compiler can even optimise
> memcmp for a fixed size nicely.
> 
> James
> 


Changed to using memcmp. This replaces the prevous patch.


Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-27 19:09:00.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-02-01 10:09:24.000000000 -0700
@@ -1016,7 +1016,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 	int		 ii;
 	int		 max = hd->ioc->req_depth;
 	struct scsi_cmnd *sc;
-	int		 lun;
+	struct scsi_lun  lun;
 
 	dsprintk((KERN_INFO MYNAM ": search_running channel %d id %d lun %d max %d\n",
 	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun, max));
@@ -1027,13 +1027,14 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			mf = (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(hd->ioc, ii);
 			if (mf == NULL)
 				continue;
-			lun = scsilun_to_int((struct scsi_lun *)mf->LUN);
-			dsprintk(( "search_running: found (sc=%p, mf = %p) chanel %d id %d, lun %d \n",
-			    hd->ScsiLookup[ii], mf, mf->Bus, mf->TargetID, lun));
+			int_to_scsilun(vdevice->lun, &lun);
 			if ((mf->Bus != vdevice->vtarget->channel) ||
 			    (mf->TargetID != vdevice->vtarget->id) ||
-			    (lun != vdevice->lun))
+			    memcmp(lun.scsi_lun, mf->LUN, 8))
 				continue;
+			dsprintk(( "search_running: found (sc=%p, mf = %p) "
+			    "channel %d id %d, lun %d \n", hd->ScsiLookup[ii],
+			    mf, mf->Bus, mf->TargetID, vdevice->lun));
 
 			/* Cleanup
 			 */

