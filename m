From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 13/18] be2iscsi: Fix checking Adapter state while  establishing CXN
Date: Fri,  5 Apr 2013 20:38:33 -0700
Message-ID: <1365219519-3457-13-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42011 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422636Ab3DFDjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:09 -0400
Received: by mail-pa0-f44.google.com with SMTP id bi5so2359143pad.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:07 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 Before tyring to establish a CXN with the target, check if the adapter is in
 a stable state

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 49cc2f6..531d4a6 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1128,6 +1128,13 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		return ERR_PTR(ret);
 	}
 
+	if (beiscsi_error(phba)) {
+		ret = -EIO;
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+			    "BS_%d : The FW state Not Stable!!!\n");
+		return ERR_PTR(ret);
+	}
+
 	if (phba->state != BE_ADAPTER_UP) {
 		ret = -EBUSY;
 		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
-- 
1.7.10.4

