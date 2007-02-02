From: Edward Goggin <egoggin@vmware.com>
Subject: [PATCH 2/2] fusion: return DID_COND_REQUEUE if SCSI status is
	MPI_SCSI_STATUS_BUSY
Date: Fri, 02 Feb 2007 17:05:23 -0500
Message-ID: <1170453923.14264.75.camel@egoggin-devd.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:33073 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946117AbXBBWFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 17:05:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, eric.moore@lsi.com

From: Ed Goggin <egoggin@vmware.com>

Return DID_COND_REQUEUE instead of DID_BUS_BUSY for IOC status
is SUCCESS and scsi_status is MPI_SCSI_STATUS_BUSY.  Command
will be retried via ADD_TO_MLQUEUE IFF not REQ_FAILFAST.

Signed-off-by: Ed Goggin <egoggin@vmware.com>

diff --git a/drivers/message/fusion/mptscsih.c
b/drivers/message/fusion/mptscsih.c
index f0cca3e..312a75e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -781,7 +781,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
 			if (scsi_status == MPI_SCSI_STATUS_BUSY)
-				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
+				sc->result = (DID_COND_REQUEUE << 16) | scsi_status;
 			else
 				sc->result = (DID_OK << 16) | scsi_status;
 			if (scsi_state == 0) {
