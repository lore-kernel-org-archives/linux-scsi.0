From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] kmalloc arguments in wrong order (53c700)
Date: Thu, 22 Jun 2006 21:48:13 +0100
Message-ID: <20060622204813.GY27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44687 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1161348AbWFVUsO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jun 2006 16:48:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Could people please run make C=2 at some point?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

---

 drivers/scsi/53c700.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

c14b0d0f9f7df1aeb96e1651927ea902368e3175
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 3c683dc..bff0479 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -2044,7 +2044,7 @@ NCR_700_slave_configure(struct scsi_devi
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
 
-	SDp->hostdata = kmalloc(GFP_KERNEL, sizeof(struct NCR_700_sense));
+	SDp->hostdata = kmalloc(sizeof(struct NCR_700_sense), GFP_KERNEL);
 
 	if (!SDp->hostdata)
 		return -ENOMEM;
-- 
1.3.GIT

