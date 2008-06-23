From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/4] Fix SES timeout
Date: Mon, 23 Jun 2008 09:14:31 -0600
Message-ID: <20080623151431.GD4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54230 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbYFWPOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2008 11:14:47 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Timeouts are measured in jiffies, not in seconds.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 45df83b..351bce7 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -61,7 +61,7 @@ static int ses_probe(struct device *dev)
 	return err;
 }
 
-#define SES_TIMEOUT 30
+#define SES_TIMEOUT (30 * HZ)
 #define SES_RETRIES 3
 
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
