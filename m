From: Dan Carpenter <error27@gmail.com>
Subject: [patch] potential null deref in lpfc_els.c
Date: Sat, 5 Dec 2009 14:35:19 +0200
Message-ID: <20091205123519.GF5224@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:58453 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbZLEMgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2009 07:36:06 -0500
Received: by ey-out-2122.google.com with SMTP id d26so796787eyd.19
        for <linux-scsi@vger.kernel.org>; Sat, 05 Dec 2009 04:36:11 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@emulex.com, James.Bottomley@suse.de

This patch is against 2.6.32-rc8.

The issue was found by a static checker.  If cmd == ELS_CMD_PLOGI, it
is possible for ndlp to be NULL.  We do check ndlp further down the 
function so that would also indicate that we should check ndlp here.

Compile tested.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/scsi/lpfc/lpfc_els.c	2009-12-05 10:52:02.000000000 +0200
+++ devel/drivers/scsi/lpfc/lpfc_els.c	2009-12-05 11:43:49.000000000 +0200
@@ -2548,7 +2548,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"Retry ELS:       wd7:x%x wd4:x%x did:x%x",
-		*(((uint32_t *) irsp) + 7), irsp->un.ulpWord[4], ndlp->nlp_DID);
+		*(((uint32_t *) irsp) + 7), irsp->un.ulpWord[4], (ndlp ? ndlp->nlp_DID : 0));
 
 	switch (irsp->ulpStatus) {
 	case IOSTAT_FCP_RSP_ERROR:
