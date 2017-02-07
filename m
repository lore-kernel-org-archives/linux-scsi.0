From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: aacraid: fix information leak on hbainfo.driver_name
Date: Tue,  7 Feb 2017 13:55:13 +0000
Message-ID: <20170207135513.21392-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The driver_name field is not initialized and hence information
on the stack is being leaked to userspace on the copy_to_user.
Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/commctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 614842a..eb48d0a 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1015,7 +1015,7 @@ static int aac_get_pci_info(struct aac_dev* dev, void __user *arg)
 
 static int aac_get_hba_info(struct aac_dev *dev, void __user *arg)
 {
-	struct aac_hba_info hbainfo;
+	struct aac_hba_info hbainfo = { 0 };
 
 	hbainfo.adapter_number		= (u8) dev->id;
 	hbainfo.system_io_bus_number	= dev->pdev->bus->number;
-- 
2.10.2
