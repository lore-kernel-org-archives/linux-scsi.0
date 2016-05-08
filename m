From: Petros Koutoupis <petros@petroskoutoupis.com>
Subject: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Sat, 07 May 2016 19:40:11 -0500
Message-ID: <1462668011.32105.7.camel@petros-ultrathin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:54305 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbcEHAkQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 May 2016 20:40:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

The current state of the code checks to see if the reference to scsi_cmnd is
not null, but it never checks to see if it is null and always assumes it is valid
before its use in below switch statement. This patch addresses that.

--- linux/drivers/scsi/megaraid/megaraid_sas_fusion.c.orig	2016-05-07 09:12:56.748969851 -0500
+++ linux/drivers/scsi/megaraid/megaraid_sas_fusion.c	2016-05-07 09:15:29.612967113 -0500
@@ -2277,6 +2277,10 @@ complete_cmd_fusion(struct megasas_insta
 
 		if (cmd_fusion->scmd)
 			cmd_fusion->scmd->SCp.ptr = NULL;
+		else if ((!cmd_fusion->scmd) &&
+			 ((scsi_io_req->Function == MPI2_FUNCTION_SCSI_IO_REQUEST) ||
+			 (scsi_io_req->Function == MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST)))
+			goto next;
 
 		scmd_local = cmd_fusion->scmd;
 		status = scsi_io_req->RaidContext.status;
@@ -2336,7 +2340,7 @@ complete_cmd_fusion(struct megasas_insta
 				megasas_complete_cmd(instance, cmd_mfi, DID_OK);
 			break;
 		}
-
+next:
 		fusion->last_reply_idx[MSIxIndex]++;
 		if (fusion->last_reply_idx[MSIxIndex] >=
 		    fusion->reply_q_depth)


