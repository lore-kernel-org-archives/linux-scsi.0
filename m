From: Colin King <colin.king@canonical.com>
Subject: [PATCH][next] scsi: hpsa: fix an uninitialized read and dereference of pointer dev
Date: Wed, 22 May 2019 09:39:03 +0100
Message-ID: <20190522083903.18849-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check for a lockup_detected failure exits via the
label return_reset_status that reads and dereferences an uninitialized
pointer dev.  Fix this by ensuring dev is inintialized to null.

Addresses-Coverity: ("Uninitialized pointer read")
Fixes: 14991a5bade5 ("scsi: hpsa: correct device resets")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c560a4532733..ac8338b0571b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5947,7 +5947,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	int rc = SUCCESS;
 	int i;
 	struct ctlr_info *h;
-	struct hpsa_scsi_dev_t *dev;
+	struct hpsa_scsi_dev_t *dev = NULL;
 	u8 reset_type;
 	char msg[48];
 	unsigned long flags;
-- 
2.20.1
