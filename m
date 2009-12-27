From: Dan Carpenter <error27@gmail.com>
Subject: [patch] off by one in FlashPoint.c
Date: Sun, 27 Dec 2009 15:14:46 +0200
Message-ID: <20091227131446.GI6075@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60203 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbZL0NPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Dec 2009 08:15:10 -0500
Received: by fxm25 with SMTP id 25so4069763fxm.21
        for <linux-scsi@vger.kernel.org>; Sun, 27 Dec 2009 05:15:09 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

The check should be >= instead of > or we could go past the end of the
array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/scsi/FlashPoint.c	2009-12-27 11:35:58.000000000 +0200
+++ devel/drivers/scsi/FlashPoint.c	2009-12-27 11:36:19.000000000 +0200
@@ -3924,7 +3924,7 @@
 {
 	struct sccb_mgr_tar_info *currTar_Info;
 
-	if ((p_sccb->TargID > MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN)) {
+	if ((p_sccb->TargID >= MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN)) {
 		return;
 	}
 	currTar_Info = &FPT_sccbMgrTbl[p_card][p_sccb->TargID];


