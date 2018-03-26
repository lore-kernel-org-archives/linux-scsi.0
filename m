From: Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: [PATCH] scsi: devinfo: Add Microsoft iSCSI target to 1024 sector blacklist
Date: Mon, 26 Mar 2018 14:56:51 +0100
Message-ID: <20180326135651.8193-1-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>
List-Id: linux-scsi@vger.kernel.org

The Windows Server 2016 iSCSI target doesn't work with the Linux kernel
initiator since the kernel started sending larger requests by default,
nor does it implement the block limits VPD page. Apply the sector limit
workaround for these targets.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
---
 drivers/scsi/scsi_devinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f3b1172..5cb748a 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -213,7 +213,7 @@ static struct {
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
-	{"MSFT", "Virtual HD", NULL, BLIST_NO_RSOC},
+	{"MSFT", "Virtual HD", NULL, BLIST_MAX_1024 | BLIST_NO_RSOC},
 	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
2.9.5
