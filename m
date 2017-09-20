From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: libfc: fix potential null lport dereference
Date: Wed, 20 Sep 2017 14:25:41 +0100
Message-ID: <20170920132541.13691-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't pass a null lport to FC_LPORT_DBG as this causes a null pointer
dereference when accessing lport->host and lport->port_id. Instead
use the FC_CHECK_LOGGING macro to print the kernel message via pr_info.

Detected by CoverityScan, CID#113198 ("Dereference after null check")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/libfc/fc_exch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 42bcf7f3a0f9..46d842d238f1 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2603,8 +2603,8 @@ void fc_exch_recv(struct fc_lport *lport, struct fc_frame *fp)
 
 	/* lport lock ? */
 	if (!lport || lport->state == LPORT_ST_DISABLED) {
-		FC_LPORT_DBG(lport, "Receiving frames for an lport that "
-			     "has not been initialized correctly\n");
+		FC_CHECK_LOGGING(FC_LPORT_LOGGING,
+				 pr_info("Receiving frames for an lport that has not been initialized correctly\n"));
 		fc_frame_free(fp);
 		return;
 	}
-- 
2.14.1
