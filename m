From: Eric Moore <eric.moore@lsi.com>
Subject: RE: [PATCH] - export scsilun_to_int
Date: Wed, 31 Jan 2007 15:54:33 -0700
Message-ID: <20070131225433.GA6652@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49138 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbXAaWy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 17:54:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Wednesday, January 31, 2007 1:49 PM, James Bottomley wrote:
> Yes, I missed that.  However, the mf (SCSIIORequest_t) comes back with
> the 8 byte luns, couldn't you just run vdevice->lun through
> int_to_scsilun and compare on that?
> 
> I'm really reluctant to export the lun to int lossy transform 
> because it
> will encourage bad uses.


I've removed usage of  scsilun_to_int.
Now I use int_to_scsilun to convert vdevice->lun, then added a new function
mptscsih_cmp_scsilun which compares the two luns.   This applies over all the
previous patchs I posted this week.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-01-27 19:09:00.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2007-01-31 15:22:34.000000000 -0700
@@ -996,6 +996,26 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 }
 
 /*
+ *	mptscsih_cmp_scsilun - compare two luns, lun1 and lun2
+ *	@lun1: 1st lun
+ *	@lun2: 2nd lun
+ *
+ *	Returns: zero, if they compare, or 1 when it doesn't
+ *
+ */
+static int
+mptscsih_cmp_scsilun(struct scsi_lun * lun1, struct scsi_lun * lun2)
+{
+	int i;
+
+	for (i = 0; i < 8 ; i++)
+		if (lun1->scsi_lun[i] != lun2->scsi_lun[i])
+			return 1;
+
+	return 0;
+}
+
+/*
  *	mptscsih_search_running_cmds - Delete any commands associated
  *		with the specified target and lun. Function called only
  *		when a lun is disable by mid-layer.
@@ -1016,7 +1036,7 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 	int		 ii;
 	int		 max = hd->ioc->req_depth;
 	struct scsi_cmnd *sc;
-	int		 lun;
+	struct scsi_lun  lun;
 
 	dsprintk((KERN_INFO MYNAM ": search_running channel %d id %d lun %d max %d\n",
 	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun, max));
@@ -1027,13 +1047,15 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
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
+			    mptscsih_cmp_scsilun(&lun,
+				(struct scsi_lun *)mf->LUN))
 				continue;
+			dsprintk(( "search_running: found (sc=%p, mf = %p) "
+			    "channel %d id %d, lun %d \n", hd->ScsiLookup[ii],
+			    mf, mf->Bus, mf->TargetID, vdevice->lun));
 
 			/* Cleanup
 			 */
