From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in scsi_scan_host_selected()
Date: Tue, 23 May 2006 10:29:28 +0200
Message-ID: <4472C7E8.2000108@suse.de>
References: <1148080489.23417.18.camel@amitarora.in.ibm.com> <20060520042132.GC2826@parisc-linux.org> <1148108792.13190.36.camel@amitarora.in.ibm.com> <1148345675.3320.77.camel@mulgrave.il.steeleye.com> <20060523011619.GG4093@parisc-linux.org> <4472BE29.4020106@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050800050400020904030505"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:20646 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932100AbWEWI3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 May 2006 04:29:31 -0400
In-Reply-To: <4472BE29.4020106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Amit Arora <aarora@in.ibm.com>, linux-scsi@vger.kernel.org, patmans@us.ibm.com

This is a multi-part message in MIME format.
--------------050800050400020904030505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hannes Reinecke wrote:
> Matthew Wilcox wrote:
>> On Mon, May 22, 2006 at 07:54:35PM -0500, James Bottomley wrote:
>>> Actually, we've got another cockup here with drivers: some have set this
>>> to 8 or 16 and others to 7 or 15.  If we apply this without auditing
>>> them, for those who set it to 7 or 15, the last target will end up
>>> inaccessible.
>> So as scsi maintainer, what's your preference for the 'right way' to fix
>> this?  Clearly a whole-scale driver audit is needed, so my preference is
>> to rename the variable (how about id_limit?) and then do a sweep
>> checking that everybody's using it correctly.
>>
> Ah. I see a pattern emerging.
> 
> ncr53c7xx.c has this:
> 
> #ifdef LINUX_1_2
> 	|| cmd->device->id > 7
> #else
> 	|| cmd->device->id > host->max_id
> #endif
> 
> So appearently in the good old days max_id was indeed defined as the
> highest available target number. Whereas most 'modern' drivers define
> this c-style-wise as the first non-available number.
> 
> So I would go for the latter approach and audit the drivers.
> 
Wasn't too bad actually. Only some very old drivers did it wrong.
I don't think we'd need to redo everything by renaming variables.
Some fixing will be sufficient (see attached patch).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------050800050400020904030505
Content-Type: text/plain;
 name="scsi-scan-fix-max_id"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-scan-fix-max_id"

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 6a0f950..b767918 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -376,7 +376,7 @@ NCR_700_detect(struct scsi_host_template
 	dma_sync_single_for_device(hostdata->dev, pScript, sizeof(SCRIPT), DMA_TO_DEVICE);
 	hostdata->state = NCR_700_HOST_FREE;
 	hostdata->cmd = NULL;
-	host->max_id = 7;
+	host->max_id = 8;
 	host->max_lun = NCR_700_MAX_LUNS;
 	BUG_ON(NCR_700_transport_template == NULL);
 	host->transportt = NCR_700_transport_template;
diff --git a/drivers/scsi/53c7xx.c b/drivers/scsi/53c7xx.c
index 7894b8e..cfc9912 100644
--- a/drivers/scsi/53c7xx.c
+++ b/drivers/scsi/53c7xx.c
@@ -709,7 +709,7 @@ request_synchronous (int host, int targe
 	printk (KERN_ALERT "target %d is host ID\n", target);
 	return -1;
     } 
-    else if (target > h->max_id) {
+    else if (target >= h->max_id) {
 	printk (KERN_ALERT "target %d exceeds maximum of %d\n", target,
 	    h->max_id);
 	return -1;
@@ -3622,7 +3622,7 @@ #endif
 #ifdef LINUX_1_2
 	|| cmd->device->id > 7
 #else
-	|| cmd->device->id > host->max_id
+	|| cmd->device->id >= host->max_id
 #endif
 	|| cmd->device->id == host->this_id
 	|| hostdata->state == STATE_DISABLED) {
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 08771f6..e14244a 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9396,8 +9396,8 @@ ahd_find_tmode_devs(struct ahd_softc *ah
 	} else {
 		u_int max_id;
 
-		max_id = (ahd->features & AHD_WIDE) ? 15 : 7;
-		if (ccb->ccb_h.target_id > max_id)
+		max_id = (ahd->features & AHD_WIDE) ? 16 : 8;
+		if (ccb->ccb_h.target_id >= max_id)
 			return (CAM_TID_INVALID);
 
 		if (ccb->ccb_h.target_lun >= AHD_NUM_LUNS)
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index d375669..50a3dd0 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6774,8 +6774,8 @@ ahc_find_tmode_devs(struct ahc_softc *ah
 	} else {
 		u_int max_id;
 
-		max_id = (ahc->features & AHC_WIDE) ? 15 : 7;
-		if (ccb->ccb_h.target_id > max_id)
+		max_id = (ahc->features & AHC_WIDE) ? 16 : 8;
+		if (ccb->ccb_h.target_id >= max_id)
 			return (CAM_TID_INVALID);
 
 		if (ccb->ccb_h.target_lun >= AHC_NUM_LUNS)
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a198d86..58d7e34 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3047,7 +3047,7 @@ #endif		
 		if (atp_dev.chip_ver == 4)
 			shpnt->max_id = 16;
 		else		
-			shpnt->max_id = 7;
+			shpnt->max_id = 8;
 		shpnt->this_id = host_id;
 		shpnt->unique_id = base_io;
 		shpnt->io_port = base_io;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f85d910..fd97d07 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1503,7 +1503,7 @@ int scsi_scan_host_selected(struct Scsi_
 		__FUNCTION__, channel, id, lun));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
-	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)) ||
+	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
 		return -EINVAL;
 

--------------050800050400020904030505--
