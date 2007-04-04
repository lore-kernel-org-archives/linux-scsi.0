From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Wed, 4 Apr 2007 10:31:37 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327ED0C@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:62673 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751922AbXDDRaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 13:30:00 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: Ed Lin 
> Sent: Monday, April 02, 2007 4:01 PM
> To: 'James Bottomley'
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
> 
> 
> 
> 
> > -----Original Message-----
> > From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> > Sent: Saturday, March 31, 2007 7:22 AM
> > To: Ed Lin
> > Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> > Subject: Re: [PATCH 1/4] [SCSI]stex: fix id mapping issue
> > 
> > 
> > On Fri, 2007-03-30 at 15:21 -0700, Ed Lin wrote:
> > > The internal id/lun mapping of st_vsc and st_vsc1 
> > controllers is different
> > > from st_shasta. The original driver code can only  map 
> > first 16 'entities'
> > > for st_vsc and st_vsc1 while there are actually 128 available.
> > > 
> > > Also the  ST_MAX_LUN_PER_TARGET should be 8, although this can do
> > > no harm because inquiries beyond boundary are discarded 
> by firmware.
> > > 
> > > The correct internal mapping should be:
> > > id:0~15, lun:0~7 (st_shasta)
> > > id:0, lun:0~127 (st_yosemite)
> > > id:0~127, lun:0 (st_vsc and st_vsc1)
> > > To scsi mid layer they are all channel:0~7, id:0~15, lun:0, 
> > with a maximun
> > > 'entity' number of 128. The RAID console only interfaces to 
> > scsi mid layer
> > > and is always mapped at channel:0, id:16, lun:0.
> > 
> > I'm with Christoph here ... if we're going to break the backwards
> > compatibility of the mappings (which your code does) then we 
> > could just
> > dump channel and use the SCSI id and lun directly.
> > 
> > Understanding this code is predicated on this quirky definition in
> > stex_queuecommand:
> > 
> > 	id = cmd->device->id;
> > 	lun = cmd->device->channel; /* firmware lun issue work around */
> >                            ^^^^^^^
> > 
> > > @ -645,12 +645,16 @@ stex_queuecommand(struct scsi_cmnd *cmd,
> > >  
> > >  	req = stex_alloc_req(hba);
> > >  
> > > -	if (hba->cardtype == st_yosemite) {
> > > -		req->lun = lun * (ST_MAX_TARGET_NUM - 1) + id;
> > 
> > This looks to be correct, it goes up id 0 to 
> ST_MAX_TARGET_NUM -1 then
> > takes the next channel.
> > 
> > > -		req->target = 0;
> > > -	} else {
> > > +	if (hba->cardtype == st_shasta) {
> > >  		req->lun = lun;
> > >  		req->target = id;
> > > +	} else if (hba->cardtype == st_yosemite){
> > > +		req->lun = id * ST_MAX_LUN_PER_TARGET + lun;
> > > +		req->target = 0;
> > > +	} else {
> > > +		/* st_vsc and st_vsc1 */
> > > +		req->lun = 0;
> > > +		req->target = id * ST_MAX_LUN_PER_TARGET + lun;
> > 
> > These both look to be wrong.  You're taking the channel as 
> the lowest
> > common denominator, so your first target is on channel 1 id 
> > 0, your next
> > on channel 2, id 0 and so on.  That's really going to mess with the
> > ordering (which will be user visible) is that really what you want?
> > 
> 
> How about the attached one? 
> 

Sorry. It seems the mail server has problem. The patch is here in plain
text. I hope this time it does not mess up. I have problem with
linux-scsi
mail list, if you have comment please cc me. Thanks.
--Ed Lin




The internal id/lun mapping of st_vsc and st_vsc1 controllers is
different
from st_shasta. The original driver code can only  map first 16
'entities'
for st_vsc and st_vsc1 while there are actually 128 available.

The correct mapping should be:
channel:0~7, id:0~15 (st_shasta, console is channel:0, id:16, lun:0)
channel:0~127, id:0 (st_yosemite, console is channel:0, id:1, lun:0)
channel:0, id:0~127 (st_vsc and st_vsc1, console is channel:0, id:128,
lun:0)

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 69be132..29a7b61 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -113,10 +113,6 @@ enum {
 	SG_CF_64B				= 0x40,	/* 64 bit item
*/
 	SG_CF_HOST				= 0x20,	/* sg in host
memory */
 
-	ST_MAX_ARRAY_SUPPORTED			= 16,
-	ST_MAX_TARGET_NUM			=
(ST_MAX_ARRAY_SUPPORTED+1),
-	ST_MAX_LUN_PER_TARGET			= 16,
-
 	st_shasta				= 0,
 	st_vsc					= 1,
 	st_vsc1					= 2,
@@ -606,7 +602,7 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 		return 0;
 	}
 	case INQUIRY:
-		if (id != ST_MAX_ARRAY_SUPPORTED)
+		if (id != host->max_id - 1)
 			break;
 		if (lun == 0 && (cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
 			stex_direct_copy(cmd, console_inq_page,
@@ -624,7 +620,7 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			ver.oem = ST_OEM;
 			ver.build = ST_BUILD_VER;
 			ver.signature[0] = PASSTHRU_SIGNATURE;
-			ver.console_id = ST_MAX_ARRAY_SUPPORTED;
+			ver.console_id = host->max_id - 1;
 			ver.host_no = hba->host->host_no;
 			cmd->result = stex_direct_copy(cmd, &ver,
sizeof(ver)) ?
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
@@ -645,13 +641,8 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 
 	req = stex_alloc_req(hba);
 
-	if (hba->cardtype == st_yosemite) {
-		req->lun = lun * (ST_MAX_TARGET_NUM - 1) + id;
-		req->target = 0;
-	} else {
-		req->lun = lun;
-		req->target = id;
-	}
+	req->lun = lun;
+	req->target = id;
 
 	/* cdb */
 	memcpy(req->cdb, cmd->cmnd, STEX_CDB_LENGTH);
@@ -1229,11 +1220,22 @@ stex_probe(struct pci_dev *pdev, const s
 	hba->copy_buffer = hba->dma_mem + MU_BUFFER_SIZE;
 	hba->mu_status = MU_STATE_STARTING;
 
-	/* firmware uses id/lun pair for a logical drive, but lun would
be
-	   always 0 if CONFIG_SCSI_MULTI_LUN not configured, so we use
-	   channel to map lun here */
-	host->max_channel = ST_MAX_LUN_PER_TARGET - 1;
-	host->max_id = ST_MAX_TARGET_NUM;
+	/*
+	 * firmware uses id/lun pair for a logical drive, but lun would
be
+	 * always 0 if CONFIG_SCSI_MULTI_LUN not configured, so we use
+	 * channel to map lun here
+	 */
+	if (hba->cardtype == st_shasta) {
+		host->max_channel = 7;
+		host->max_id = 16 + 1;
+	} else if (hba->cardtype == st_yosemite) {
+		host->max_channel = 127;
+		host->max_id = 1 + 1;
+	} else {
+		/* st_vsc and st_vsc1 */
+		host->max_channel = 0;
+		host->max_id = 128 + 1;
+	}
 	host->max_lun = 1;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = STEX_CDB_LENGTH;
