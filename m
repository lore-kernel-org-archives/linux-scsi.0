From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/11] aacraid: Use scmd_ functions
Date: Mon, 27 Mar 2006 09:43:25 -0800
Message-ID: <1143481405.21975.36.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15807 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750975AbWC0Rn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:43:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

Clean up the remaining scsi id access methods, drop ID_LUN_TO_CONTAINER
macro.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-03-22 11:12:25.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-03-22 11:17:34.000000000 -0800
@@ -908,7 +908,7 @@
 	scsicmd = (struct scsi_cmnd *) context;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+	cid = scmd_id(scsicmd);
 
 	if (nblank(dprintk(x))) {
 		u64 lba;
@@ -1353,7 +1353,7 @@
 	else {
 		struct scsi_device *sdev = cmd->device;
 		struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
-		u32 cid = ID_LUN_TO_CONTAINER(sdev->id, sdev->lun);
+		u32 cid = sdev_id(sdev);
 		printk(KERN_WARNING 
 		     "synchronize_callback: synchronize failed, status = %d\n",
 		     le32_to_cpu(synchronizereply->status));
@@ -1465,13 +1465,14 @@
 	 *	itself.
 	 */
 	if (scmd_id(scsicmd) != host->this_id) {
-		if ((scsicmd->device->channel == CONTAINER_CHANNEL)) {
-			if( (scsicmd->device->id >= dev->maximum_num_containers) || (scsicmd->device->lun != 0)){ 
+		if ((scmd_channel(scsicmd) == CONTAINER_CHANNEL)) {
+			if((scmd_id(scsicmd) >= dev->maximum_num_containers) ||
+					(scsicmd->device->lun != 0)) {
 				scsicmd->result = DID_NO_CONNECT << 16;
 				scsicmd->scsi_done(scsicmd);
 				return 0;
 			}
-			cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
+			cid = scmd_id(scsicmd);
 
 			/*
 			 *	If the target container doesn't exist, it may have
@@ -1547,7 +1548,7 @@
 	{
 		struct inquiry_data inq_data;
 
-		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", scsicmd->device->id));
+		dprintk((KERN_DEBUG "INQUIRY command, ID: %d.\n", scmd_id(scsicmd)));
 		memset(&inq_data, 0, sizeof (struct inquiry_data));
 
 		inq_data.inqd_ver = 2;	/* claim compliance to SCSI-2 */
@@ -1777,7 +1778,7 @@
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
 	if (qd.cnum == -1)
-		qd.cnum = ID_LUN_TO_CONTAINER(qd.id, qd.lun);
+		qd.cnum = qd.id;
 	else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1)) 
 	{
 		if (qd.cnum < 0 || qd.cnum >= dev->maximum_num_containers)
@@ -2067,7 +2068,7 @@
 	u32 timeout;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
-	if (scsicmd->device->id >= dev->maximum_num_physicals || 
+	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
 			scsicmd->device->lun > 7) {
 		scsicmd->result = DID_NO_CONNECT << 16;
 		scsicmd->scsi_done(scsicmd);
@@ -2102,8 +2103,8 @@
 
 	srbcmd = (struct aac_srb*) fib_data(cmd_fibcontext);
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
-	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(scsicmd->device->channel));
-	srbcmd->id   = cpu_to_le32(scsicmd->device->id);
+	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(scmd_channel(scsicmd)));
+	srbcmd->id   = cpu_to_le32(scmd_id(scsicmd));
 	srbcmd->lun      = cpu_to_le32(scsicmd->device->lun);
 	srbcmd->flags    = cpu_to_le32(flag);
 	timeout = scsicmd->timeout_per_command/HZ;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-03-22 11:12:25.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-03-22 11:17:34.000000000 -0800
@@ -25,7 +25,6 @@
  * These macros convert from physical channels to virtual channels
  */
 #define CONTAINER_CHANNEL		(0)
-#define ID_LUN_TO_CONTAINER(id, lun)	(id)
 #define CONTAINER_TO_CHANNEL(cont)	(CONTAINER_CHANNEL)
 #define CONTAINER_TO_ID(cont)		(cont)
 #define CONTAINER_TO_LUN(cont)		(0)

-- 
Mark Haverkamp <markh@osdl.org>

