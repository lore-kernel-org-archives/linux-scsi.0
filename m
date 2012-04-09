From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH 18/26] [SCSI] qla1280: Remove redundant NULL check before
 release_firmware() call
Date: Mon, 9 Apr 2012 22:51:36 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1204092228380.13925@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Reed <mdr@sgi.com>
List-Id: linux-scsi@vger.kernel.org

release_firmware() checks for NULL pointers internally so checking
before calling the function is redundant.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/qla1280.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 6c6486f..538230b 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4473,17 +4473,14 @@ qla1280_exit(void)
 	pci_unregister_driver(&qla1280_pci_driver);
 	/* release any allocated firmware images */
 	for (i = 0; i < QL_NUM_FW_IMAGES; i++) {
-		if (qla1280_fw_tbl[i].fw) {
-			release_firmware(qla1280_fw_tbl[i].fw);
-			qla1280_fw_tbl[i].fw = NULL;
-		}
+		release_firmware(qla1280_fw_tbl[i].fw);
+		qla1280_fw_tbl[i].fw = NULL;
 	}
 }
 
 module_init(qla1280_init);
 module_exit(qla1280_exit);
 
-
 MODULE_AUTHOR("Qlogic & Jes Sorensen");
 MODULE_DESCRIPTION("Qlogic ISP SCSI (qla1x80/qla1x160) driver");
 MODULE_LICENSE("GPL");
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
