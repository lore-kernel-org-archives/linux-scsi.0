From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: csiostor: remove redundant assignment to pointer 'ln'
Date: Wed, 24 Jan 2018 14:58:01 +0000
Message-ID: <20180124145801.18920-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer ln is assigned a value that is never read, it is re-assigned
a new value in the list_for_each loop hence the initialization is
redundant and can be removed.

Cleans up clang warning:
drivers/scsi/csiostor/csio_lnode.c:117:21: warning: Value stored to 'ln'
during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/csiostor/csio_lnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index be5ee2d37815..7dbbbb81a1e7 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -114,7 +114,7 @@ static enum csio_ln_ev fwevt_to_lnevt[] = {
 static struct csio_lnode *
 csio_ln_lookup_by_portid(struct csio_hw *hw, uint8_t portid)
 {
-	struct csio_lnode *ln = hw->rln;
+	struct csio_lnode *ln;
 	struct list_head *tmp;
 
 	/* Match siblings lnode with portid */
-- 
2.15.1
