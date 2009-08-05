From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/7] mptsas : Handle INSUFFICIENT resources status as similar to IOC BUSY  status
Date: Wed, 5 Aug 2009 12:51:25 +0530
Message-ID: <20090805072111.GD14031@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:41367 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378AbZHEHmY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 03:42:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Handle insufficient resources status as similar to busy status.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index abdc727..1466a5a 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -689,6 +689,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 
 		switch(status) {
 		case MPI_IOCSTATUS_BUSY:			/* 0x0002 */
+		case MPI_IOCSTATUS_INSUFFICIENT_RESOURCES:	/* 0x0006 */
 			/* CHECKME!
 			 * Maybe: DRIVER_BUSY | SUGGEST_RETRY | DID_SOFT_ERROR (retry)
 			 * But not: DID_BUS_BUSY lest one risk
@@ -872,7 +873,6 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 		case MPI_IOCSTATUS_INVALID_SGL:			/* 0x0003 */
 		case MPI_IOCSTATUS_INTERNAL_ERROR:		/* 0x0004 */
 		case MPI_IOCSTATUS_RESERVED:			/* 0x0005 */
-		case MPI_IOCSTATUS_INSUFFICIENT_RESOURCES:	/* 0x0006 */
 		case MPI_IOCSTATUS_INVALID_FIELD:		/* 0x0007 */
 		case MPI_IOCSTATUS_INVALID_STATE:		/* 0x0008 */
 		case MPI_IOCSTATUS_SCSI_IO_DATA_ERROR:		/* 0x0046 */
