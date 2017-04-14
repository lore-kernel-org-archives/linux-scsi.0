From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: fc: remove redundant check of an unsigned long being less than zero
Date: Fri, 14 Apr 2017 14:58:02 +0100
Message-ID: <20170414135802.6991-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The check for an unsigned long being less than zero is always false
so it is a redundant check and can be removed.

Detected by static analysis with by PVS-Studio

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 2d753c93e07a..87b8f9d64d9b 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -850,7 +850,7 @@ static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
 	char *cp;
 
 	*val = simple_strtoul(buf, &cp, 0);
-	if ((*cp && (*cp != '\n')) || (*val < 0))
+	if (*cp && (*cp != '\n'))
 		return -EINVAL;
 	/*
 	 * Check for overflow; dev_loss_tmo is u32
-- 
2.11.0
