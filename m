From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH] mptscsih: set resid for retried commands
Date: Thu, 27 Apr 2006 14:28:38 -0400
Message-ID: <NDBBLGKNDFLNBMEOAAANGEJBEJAF.tonyb@cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:3089 "EHLO
	cyborg.cybernetics.com") by vger.kernel.org with ESMTP
	id S964919AbWD0S2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 14:28:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com, mpt_linux_developer@lsil.com
Cc: linux-scsi@vger.kernel.org

Most of the time, the data transfer residual is initialized to 0 before the
SCSI command is queued, so it is not necessary to set it to 0 explicitly if
the command completes successfully.  However, if the command fails with e.g.
queue full status, the data transfer residual will be set to a nonzero value
when the command is queued for retry.  This patch ensures that the residual
is set to 0 if the retry completes successfully rather than retaining the
residual from the first execution of the command.

--- linux-2.6.17-rc3/drivers/message/fusion/mptscsih.c.orig	2006-04-27 13:45:48.000000000 -0400
+++ linux-2.6.17-rc3/drivers/message/fusion/mptscsih.c	2006-04-27 13:46:45.000000000 -0400
@@ -569,7 +569,7 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 
 	if (pScsiReply == NULL) {
 		/* special context reply handling */
-		;
+		sc->resid = 0;
 	} else {
 		u32	 xfer_cnt;
 		u16	 status;

Anthony J. Battersby
Cybernetics

