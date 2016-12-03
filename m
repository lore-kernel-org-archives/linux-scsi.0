From: Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] scsi: csiostor: fix improper return value
Date: Sat,  3 Dec 2016 18:34:17 +0800
Message-ID: <1480761257-4667-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

Function csio_hw_flash_erase_sectors() will always return 0, even on
failures. Thus, its callers will not detect the errors, and may produce
unexpected behavior. To avoid bugs, this patch replaces "return 0;" with
"return ret;".

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188681

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/csiostor/csio_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 622bdab..8970df2 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -613,7 +613,7 @@ struct t4_vpd_hdr {
 		csio_err(hw, "erase of flash sector %d failed, error %d\n",
 			 start, ret);
 	csio_wr_reg32(hw, 0, SF_OP_A);    /* unlock SF */
-	return 0;
+	return ret;
 }
 
 static void
-- 
1.9.1
