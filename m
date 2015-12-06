From: Colin King <colin.king@canonical.com>
Subject: [PATCH] cciss: print max outstanding commands as a hex value
Date: Sun,  6 Dec 2015 22:19:40 +0000
Message-ID: <1449440380-6161-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The max outstanding commands is being printed with a 0x prefix
to suggest it is a hex value, when in fact the integer decimal %d
format specifier is being used and this is a bit confusing. Use
%x instead to match the proceeding 0x prefix.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/block/cciss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0422c47..2758982 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3854,7 +3854,7 @@ static void print_cfg_table(ctlr_info_t *h)
 	       readl(&(tb->HostWrite.CoalIntDelay)));
 	dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Count = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntCount)));
-	dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%d\n",
+	dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%x\n",
 	       readl(&(tb->CmdsOutMax)));
 	dev_dbg(&h->pdev->dev, "   Bus Types = 0x%x\n",
 		readl(&(tb->BusTypes)));
-- 
2.6.2
