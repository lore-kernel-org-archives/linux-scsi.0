From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Wed, 4 Apr 2007 11:37:08 -0700
Message-ID: <NONAMEBqfT7eEmP9CDB00000710@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:7199 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753933AbXDDSfg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2007 14:35:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "james.Bottomley" <james.Bottomley@SteelEye.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Wednesday, April 04, 2007 10:36 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: RE: [PATCH 1/4] [SCSI]stex: fix id mapping issue
> 
> 
> On Wed, 2007-04-04 at 10:31 -0700, Ed Lin wrote:
> 
> > Sorry. It seems the mail server has problem. The patch is 
> here in plain
> > text. I hope this time it does not mess up. I have problem with
> > linux-scsi
> > mail list, if you have comment please cc me. Thanks.
> > --Ed Lin
> 
> The lines are still broken, I'm afraid ... you can just resend as an
> attachement git-applypatch copes fine with that ... inline is 
> just good
> for quoting and replying.
> > +	if (hba->cardtype == st_shasta) {
> > +		host->max_channel = 7;
> > +		host->max_id = 16 + 1;
> > +	} else if (hba->cardtype == st_yosemite) {
> > +		host->max_channel = 127;
> > +		host->max_id = 1 + 1;
> > +	} else {
> > +		/* st_vsc and st_vsc1 */
> > +		host->max_channel = 0;
> > +		host->max_id = 128 + 1;
> 
> This is OK.  The use of ->channel is still a bit strange ... could we
> not simply use lun instead of channel (i.e. map the adapter id/lun to
> the mid-layer id/lun instead of using id/channel)?
> 

This is because there is a CONFIG_SCSI_MULTI_LUN option.
If this option is not selected, max_scsi_luns will be set to 1 and
the RAID arrays with lun>0 will disappear(because they are not
scanned). That is unacceptable from a user's view point.  I have
also explained this in the code comment:

	/*
	 * firmware uses id/lun pair for a logical drive, but lun would be
	 * always 0 if CONFIG_SCSI_MULTI_LUN not configured, so we use
	 * channel to map lun here
	 */

If it is not allowed to map channel to lun, then maybe I have to
report 128 targets and do the mapping in queuecommand...
After all there must be a mapping somewhere so I don't see
much difference here...

I paste the patch again, is the format ok?



The internal id/lun mapping of st_vsc and st_vsc1 controllers is different
from st_shasta. The original driver code can only  map first 16 'entities'
for st_vsc and st_vsc1 while there are actually 128 available.

The correct mapping should be:
channel:0~7, id:0~15 (st_shasta, console is channel:0, id:16, lun:0)
channel:0~127, id:0 (st_yosemite, console is channel:0, id:1, lun:0)
channel:0, id:0~127 (st_vsc and st_vsc1, console is channel:0, id:128, lun:0)

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 69be132..29a7b61 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -113,10 +113,6 @@ enum {
 	SG_CF_64B				= 0x40,	/* 64 bit item */
 	SG_CF_HOST				= 0x20,	/* sg in host memory */
 
-	ST_MAX_ARRAY_SUPPORTED			= 16,
-	ST_MAX_TARGET_NUM			= (ST_MAX_ARRAY_SUPPORTED+1),
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
 			cmd->result = stex_direct_copy(cmd, &ver, sizeof(ver)) ?
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
 
-	/* firmware uses id/lun pair for a logical drive, but lun would be
-	   always 0 if CONFIG_SCSI_MULTI_LUN not configured, so we use
-	   channel to map lun here */
-	host->max_channel = ST_MAX_LUN_PER_TARGET - 1;
-	host->max_id = ST_MAX_TARGET_NUM;
+	/*
+	 * firmware uses id/lun pair for a logical drive, but lun would be
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



