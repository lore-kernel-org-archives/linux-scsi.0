From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH 2.4] MPT fusion data transfer residuals
Date: Wed, 13 Oct 2004 11:39:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Oct13.113932edt.333165@cyborg.cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:16390 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S269748AbUJMQve
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 12:51:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: mpt_linux_developer@lsil.com
Cc: linux-scsi@vger.kernel.org

This patch to lk 2.4.27 fixes two problems with the MPT fusion driver:

1) Data transfer commands that transfer no data but have GOOD status should
not return DID_SOFT_ERROR.

2) Set the data transfer residual for commands that return CHECK CONDITION
status.  Without this patch, only commands that return GOOD status have the
data transfer residual set.

Anthony J. Battersby
Cybernetics

--- linux-2.4.27-vanilla/drivers/message/fusion/mptscsih.c	Sat Aug  7 19:26:04 2004
+++ linux-2.4.27-mpt/drivers/message/fusion/mptscsih.c	Wed Oct 13 10:34:22 2004
@@ -885,7 +885,7 @@
 				 */
 				;
 			} else {
-				if ( (xfer_cnt == 0) || (sc->underflow > xfer_cnt)) {
+				if (sc->underflow > xfer_cnt) {
 					sc->result = DID_SOFT_ERROR << 16;
 				}
 				if (scsi_state & (MPI_SCSI_STATE_AUTOSENSE_FAILED | MPI_SCSI_STATE_NO_SCSI_STATUS)) {
@@ -1004,6 +1004,10 @@
 						sc->buffer,
 						xfer_cnt);
 			}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,3,0)
+			sc->resid = sc->request_bufflen - xfer_cnt;
+#endif
 			break;
 
 		case MPI_IOCSTATUS_SCSI_PROTOCOL_ERROR:		/* 0x0047 */

