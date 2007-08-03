From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc : scsi command accessor fix for 8.2.2
Date: Fri, 3 Aug 2007 16:22:43 +0000 (UTC)
Message-ID: <1186308518.2983.12.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50387 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbXHCQW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 12:22:27 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l73GMQSk014404
	for <linux-scsi@vger.kernel.org>; Fri, 3 Aug 2007 09:22:27 -0700 (PDT)
Date: Sun, 05 Aug 2007 06:08:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


It was pointed out by Boaz Harrosh <bharrosh@panasas.com> that our
8.2.2 lpfc patches revert a change to using SCSI command accessor
functions.

This patch, to be applied on top of the 8.2.2. patches, updates the
driver for the accessor functions.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 03:41:16.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-05 06:06:03.000000000 -0400
@@ -499,7 +499,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 					 "0717 FCP command x%x residual "
 					 "underrun converted to error "
 					 "Data: x%x x%x x%x\n",
-					 cmnd->cmnd[0], cmnd->request_bufflen,
+					 cmnd->cmnd[0], scsi_bufflen(cmnd),
 					 scsi_get_resid(cmnd), cmnd->underflow);
 			host_status = DID_ERROR;
 		}


