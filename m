From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc 8.2.4 fixup: always use stack waitqueue
Date: Mon, 14 Jan 2008 13:15:56 -0500
Message-ID: <1200334556.395.1.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:36922 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYANSPr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 13:15:47 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0EIFkI7010267
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jan 2008 10:15:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Found one area that needed to be fixed in the 8.2.4 patches.

Remove incorrect use of #ifdef for an on stack waitqueue. Upstream driver
always uses DECLARE_WAIT_QUEUE_HEAD_ONSTACK();

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-01-14 13:06:49.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-01-14 13:11:06.000000000 -0500
@@ -1041,12 +1041,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	struct lpfc_scsi_buf *lpfc_cmd;
 	IOCB_t *cmd, *icmd;
 	int ret = SUCCESS;
-#ifdef DECLARE_WAIT_QUEUE_HEAD_ONSTACK
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
-#else
-	DECLARE_WAIT_QUEUE_HEAD(waitq);
-#endif
-
 
 	lpfc_block_error_handler(cmnd);
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;


