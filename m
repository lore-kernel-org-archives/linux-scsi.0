From: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
Subject: [PATCH] drivers: block: Remove unnecessary cast
Date: Wed, 11 Jan 2017 12:41:05 -0600
Message-ID: <20170111184105.GA10766@embeddedgus>
Reply-To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com, gregkh@linuxfoundation.org
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This issue was detected using Coccinelle and the following semantic patch:

@@
expression * e;
expression arg1, arg2;
type T;
@@

- e = (T *)
+ e =
kmalloc(arg1, arg2);

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/block/cciss_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index a18de9d..98ba8fc 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -647,8 +647,7 @@ cciss_scsi_setup(ctlr_info_t *h)
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[h->ctlr].ndevices = 0;
-	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+	shba = kmalloc(sizeof(*shba), GFP_KERNEL);
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;
-- 
2.5.0
