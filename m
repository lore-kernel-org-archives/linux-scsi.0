From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] fusion: endianess fixes
Date: Thu, 18 Aug 2005 16:25:44 +0200
Message-ID: <20050818142544.GD24589@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:61626 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932091AbVHROZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 10:25:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

Assorted endianess fixes.  I'll work on full endianess annotations
later.


Index: scsi-misc-2.6/drivers/message/fusion/mptbase.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.c	2005-08-17 19:47:15.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.c	2005-08-17 19:48:53.000000000 +0200
@@ -2171,7 +2171,7 @@
 		facts->IOCExceptions = le16_to_cpu(facts->IOCExceptions);
 		facts->IOCStatus = le16_to_cpu(facts->IOCStatus);
 		facts->IOCLogInfo = le32_to_cpu(facts->IOCLogInfo);
-		status = facts->IOCStatus & MPI_IOCSTATUS_MASK;
+		status = le16_to_cpu(facts->IOCStatus) & MPI_IOCSTATUS_MASK;
 		/* CHECKME! IOCStatus, IOCLogInfo */
 
 		facts->ReplyQueueDepth = le16_to_cpu(facts->ReplyQueueDepth);
@@ -4800,8 +4800,8 @@
 	pReq->Reserved3 = 0;
 	pReq->NumAddressBytes = 0x01;
 	pReq->Reserved4 = 0;
-	pReq->DataLength = 0x04;
-	pdev = (struct pci_dev *) ioc->pcidev;
+	pReq->DataLength = cpu_to_le16(0x04);
+	pdev = ioc->pcidev;
 	if (pdev->devfn & 1)
 		pReq->DeviceAddr = 0xB2;
 	else
Index: scsi-misc-2.6/drivers/message/fusion/mptctl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptctl.c	2005-08-17 19:46:11.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptctl.c	2005-08-17 19:47:37.000000000 +0200
@@ -242,7 +242,7 @@
 		/* Set the command status to GOOD if IOC Status is GOOD
 		 * OR if SCSI I/O cmd and data underrun or recovered error.
 		 */
-		iocStatus = reply->u.reply.IOCStatus & MPI_IOCSTATUS_MASK;
+		iocStatus = le16_to_cpu(reply->u.reply.IOCStatus) & MPI_IOCSTATUS_MASK;
 		if (iocStatus  == MPI_IOCSTATUS_SUCCESS)
 			ioc->ioctl->status |= MPT_IOCTL_STATUS_COMMAND_GOOD;
 
Index: scsi-misc-2.6/drivers/message/fusion/mptscsih.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptscsih.c	2005-08-17 19:46:46.000000000 +0200
+++ scsi-misc-2.6/drivers/message/fusion/mptscsih.c	2005-08-17 19:47:37.000000000 +0200
@@ -3453,7 +3453,7 @@
 				 * some type of error occurred.
 				 */
 				MpiRaidActionReply_t	*pr = (MpiRaidActionReply_t *)mr;
-				if (pr->ActionStatus == MPI_RAID_ACTION_ASTATUS_SUCCESS)
+				if (le16_to_cpu(pr->ActionStatus) == MPI_RAID_ACTION_ASTATUS_SUCCESS)
 					completionCode = MPT_SCANDV_GOOD;
 				else
 					completionCode = MPT_SCANDV_SOME_ERROR;
@@ -4002,9 +4002,9 @@
 			dnegoprintk(("syncronize cache: id=%d width=0 factor=MPT_ASYNC "
 				"offset=0 negoFlags=%x request=%x config=%x\n",
 				id, flags, requested, configuration));
-			pcfg1Data->RequestedParameters = le32_to_cpu(requested);
+			pcfg1Data->RequestedParameters = cpu_to_le32(requested);
 			pcfg1Data->Reserved = 0;
-			pcfg1Data->Configuration = le32_to_cpu(configuration);
+			pcfg1Data->Configuration = cpu_to_le32(configuration);
 			cfg.pageAddr = (bus<<8) | id;
 			mpt_config(hd->ioc, &cfg);
 		}
@@ -5254,7 +5254,7 @@
 		/* Update tmax values with those from Device Page 0.*/
 		pPage0 = (SCSIDevicePage0_t *) pPage;
 		if (pPage0) {
-			val = cpu_to_le32(pPage0->NegotiatedParameters);
+			val = le32_to_cpu(pPage0->NegotiatedParameters);
 			dv->max.width = val & MPI_SCSIDEVPAGE0_NP_WIDE ? 1 : 0;
 			dv->max.offset = (val&MPI_SCSIDEVPAGE0_NP_NEG_SYNC_OFFSET_MASK) >> 16;
 			dv->max.factor = (val&MPI_SCSIDEVPAGE0_NP_NEG_SYNC_PERIOD_MASK) >> 8;
@@ -5282,12 +5282,12 @@
 				dv->now.offset, &val, &configuration, dv->now.flags);
 			dnegoprintk(("Setting Max: id=%d width=%d factor=%x offset=%x negoFlags=%x request=%x config=%x\n",
 				id, dv->now.width, dv->now.factor, dv->now.offset, dv->now.flags, val, configuration));
-			pPage1->RequestedParameters = le32_to_cpu(val);
+			pPage1->RequestedParameters = cpu_to_le32(val);
 			pPage1->Reserved = 0;
-			pPage1->Configuration = le32_to_cpu(configuration);
+			pPage1->Configuration = cpu_to_le32(configuration);
 		}
 
-		ddvprintk(("id=%d width=%d factor=%x offset=%x flags=%x request=%x configuration=%x\n",
+		ddvprintk(("id=%d width=%d factor=%x offset=%x negoFlags=%x request=%x configuration=%x\n",
 				id, dv->now.width, dv->now.factor, dv->now.offset, dv->now.flags, val, configuration));
 		break;
 
@@ -5307,9 +5307,9 @@
 				offset, &val, &configuration, negoFlags);
 			dnegoprintk(("Setting Min: id=%d width=%d factor=%x offset=%x negoFlags=%x request=%x config=%x\n",
 				id, width, factor, offset, negoFlags, val, configuration));
-			pPage1->RequestedParameters = le32_to_cpu(val);
+			pPage1->RequestedParameters = cpu_to_le32(val);
 			pPage1->Reserved = 0;
-			pPage1->Configuration = le32_to_cpu(configuration);
+			pPage1->Configuration = cpu_to_le32(configuration);
 		}
 		ddvprintk(("id=%d width=%d factor=%x offset=%x request=%x config=%x negoFlags=%x\n",
 				id, width, factor, offset, val, configuration, negoFlags));
@@ -5383,12 +5383,12 @@
 		if (pPage1) {
 			mptscsih_setDevicePage1Flags (width, factor, offset, &val,
 						&configuration, dv->now.flags);
-			dnegoprintk(("Finish: id=%d width=%d offset=%d factor=%x flags=%x request=%x config=%x\n",
+			dnegoprintk(("Finish: id=%d width=%d offset=%d factor=%x negoFlags=%x request=%x config=%x\n",
 			     id, width, offset, factor, dv->now.flags, val, configuration));
 
-			pPage1->RequestedParameters = le32_to_cpu(val);
+			pPage1->RequestedParameters = cpu_to_le32(val);
 			pPage1->Reserved = 0;
-			pPage1->Configuration = le32_to_cpu(configuration);
+			pPage1->Configuration = cpu_to_le32(configuration);
 		}
 
 		ddvprintk(("Finish: id=%d offset=%d factor=%x width=%d request=%x config=%x\n",
