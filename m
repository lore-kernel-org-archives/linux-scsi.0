From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] scsi: aacraid: rcode is unsigned and should be signed int
Date: Tue,  7 Feb 2017 11:51:29 +0000
Message-ID: <20170207115129.18948-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

aac_fib_send can return -ve error returns and hence rcode should
be signed. Currently the rcode >= 0 check is always true and -ve
errors are not being checked.

Thanks to Dan Carpenter for spotting my original broken fix to this
issue.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/aachba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 3b5ddf4..907f1e8 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1798,7 +1798,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 	struct sgmap64 *sg64;
 	dma_addr_t addr;
 	u32 vbus, vid;
-	u32 rcode = 0;
+	int rcode = 0;
 
 	/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
 	fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry)
-- 
2.10.2
