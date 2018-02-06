From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: libfc: remove redundant initialization of 'disc'
Date: Tue,  6 Feb 2018 14:21:57 +0000
Message-ID: <20180206142157.32001-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer disc is being intializated a value that is never read and then
re-assigned the same value later on, hence the initialization is redundant
and can be removed.

Cleans up clang warning:
drivers/scsi/libfc/fc_disc.c:734:18: warning: Value stored to 'disc'
during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/libfc/fc_disc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 8660f923ace0..3f3569ec5ce3 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -731,7 +731,7 @@ static void fc_disc_stop_final(struct fc_lport *lport)
  */
 void fc_disc_config(struct fc_lport *lport, void *priv)
 {
-	struct fc_disc *disc = &lport->disc;
+	struct fc_disc *disc;
 
 	if (!lport->tt.disc_start)
 		lport->tt.disc_start = fc_disc_start;
-- 
2.15.1

