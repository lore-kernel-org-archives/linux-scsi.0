From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 2/2] fusion :  VMWare guest OS remounted as read only fix
Date: Mon, 19 Mar 2007 10:31:51 -0600
Message-ID: <20070319163150.GA28077@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33616 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030361AbXCSQiq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Mar 2007 12:38:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This address the issue of VMWare guest OS being remounted as read-only becuase the underlying device was held busy too long, , and at the same time address Engenio MPP driver concerns over infinite retries.  This patch removes the code that snoops the SAM STATUS on busy, which would be returning DID_BUS_BUSY, instead we return the status as is.   Retry hanlding seems to be properly handled in scsi_softirq_done, where a busy sam status would only occurr for the time specified by (cmd->allowed  +1) * cmd->timeout_per_command.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-03-15 18:20:01.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-03-18 12:07:26.000000000 -0600
@@ -819,10 +819,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 			sc->resid=0;
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
-			if (scsi_status == MPI_SCSI_STATUS_BUSY)
-				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
-			else
-				sc->result = (DID_OK << 16) | scsi_status;
+			sc->result = (DID_OK << 16) | scsi_status;
 			if (scsi_state == 0) {
 				;
 			} else if (scsi_state & MPI_SCSI_STATE_AUTOSENSE_VALID) {
