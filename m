From: Dan Carpenter <error27@gmail.com>
Subject: [patch] off by one in FlashPoint.c (v2)
Date: Mon, 28 Dec 2009 20:08:39 +0200
Message-ID: <20091228180839.GI17645@bicker>
References: <20091227131446.GI6075@bicker> <4B38E77F.2070201@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:41171 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZL1SI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Dec 2009 13:08:56 -0500
Received: by fxm25 with SMTP id 25so4740920fxm.21
        for <linux-scsi@vger.kernel.org>; Mon, 28 Dec 2009 10:08:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B38E77F.2070201@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

The check on MAX_SCSI_TAR should be >= instead of > or we could go past the 
end of the array.

Joe Eykholt aslo correctly points out that the check on MAX_LUN should be
>= as well.  That matches with how it is used in the rest of the file.

Signed-off-by:  Dan Carpenter <error27@gmail.com>

--- orig/drivers/scsi/FlashPoint.c	2009-12-27 11:35:58.000000000 +0200
+++ devel/drivers/scsi/FlashPoint.c	2009-12-28 19:59:33.000000000 +0200
@@ -3924,7 +3924,7 @@ static void FPT_sinits(struct sccb *p_sc
 {
 	struct sccb_mgr_tar_info *currTar_Info;
 
-	if ((p_sccb->TargID > MAX_SCSI_TAR) || (p_sccb->Lun > MAX_LUN)) {
+	if ((p_sccb->TargID >= MAX_SCSI_TAR) || (p_sccb->Lun >= MAX_LUN)) {
 		return;
 	}
 	currTar_Info = &FPT_sccbMgrTbl[p_card][p_sccb->TargID];
