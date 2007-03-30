From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 1/4] [SCSI]stex: fix id mapping issue
Date: Fri, 30 Mar 2007 15:21:33 -0700
Message-ID: <NONAMEBZNuIkdg0MZMt000005d3@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:2362 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933056AbXC3XLi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 19:11:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

The internal id/lun mapping of st_vsc and st_vsc1 controllers is different
from st_shasta. The original driver code can only  map first 16 'entities'
for st_vsc and st_vsc1 while there are actually 128 available.

Also the  ST_MAX_LUN_PER_TARGET should be 8, although this can do
no harm because inquiries beyond boundary are discarded by firmware.

The correct internal mapping should be:
id:0~15, lun:0~7 (st_shasta)
id:0, lun:0~127 (st_yosemite)
id:0~127, lun:0 (st_vsc and st_vsc1)
To scsi mid layer they are all channel:0~7, id:0~15, lun:0, with a maximun
'entity' number of 128. The RAID console only interfaces to scsi mid layer
and is always mapped at channel:0, id:16, lun:0.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 69be132..4d68533 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -115,7 +115,7 @@ enum {
 
 	ST_MAX_ARRAY_SUPPORTED			= 16,
 	ST_MAX_TARGET_NUM			= (ST_MAX_ARRAY_SUPPORTED+1),
-	ST_MAX_LUN_PER_TARGET			= 16,
+	ST_MAX_LUN_PER_TARGET			= 8,
 
 	st_shasta				= 0,
 	st_vsc					= 1,
@@ -645,12 +645,16 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 
 	req = stex_alloc_req(hba);
 
-	if (hba->cardtype == st_yosemite) {
-		req->lun = lun * (ST_MAX_TARGET_NUM - 1) + id;
-		req->target = 0;
-	} else {
+	if (hba->cardtype == st_shasta) {
 		req->lun = lun;
 		req->target = id;
+	} else if (hba->cardtype == st_yosemite){
+		req->lun = id * ST_MAX_LUN_PER_TARGET + lun;
+		req->target = 0;
+	} else {
+		/* st_vsc and st_vsc1 */
+		req->lun = 0;
+		req->target = id * ST_MAX_LUN_PER_TARGET + lun;
 	}
 
 	/* cdb */


