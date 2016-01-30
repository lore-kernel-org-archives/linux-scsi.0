From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] bfa: use strncpy() instead of memcpy()
Date: Sat, 30 Jan 2016 17:36:03 +0300
Message-ID: <20160130143603.GB3462@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

BFA_MFG_NAME is "QLogic" which is only 7 bytes, but we are copying 8
bytes.  It's harmless because the badding byte is likely zero but it
makes static checkers complain.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Technically the memset() is not needed because strncpy() will pad the
rest of the buffer with zeros but I was worried that people would be
paranoid.

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 251e2ff..a1ada4a 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -2803,7 +2803,7 @@ void
 bfa_ioc_get_adapter_manufacturer(struct bfa_ioc_s *ioc, char *manufacturer)
 {
 	memset((void *)manufacturer, 0, BFA_ADAPTER_MFG_NAME_LEN);
-	memcpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
+	strncpy(manufacturer, BFA_MFG_NAME, BFA_ADAPTER_MFG_NAME_LEN);
 }
 
 void
