From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] target/pscsi: fix return value check
Date: Fri, 25 Oct 2013 21:53:33 +0800
Message-ID: <CAPgLHd9hx7fOqn5QJoxqbmnV5ueKasX_QNbSyzKBrYGKq3Hj-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function scsi_host_lookup() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/target_core_pscsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 551c96c..0f199f6 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -134,10 +134,10 @@ static int pscsi_pmode_enable_hba(struct se_hba *hba, unsigned long mode_flag)
 	 * pSCSI Host ID and enable for phba mode
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
-	if (IS_ERR(sh)) {
+	if (!sh) {
 		pr_err("pSCSI: Unable to locate SCSI Host for"
 			" phv_host_id: %d\n", phv->phv_host_id);
-		return PTR_ERR(sh);
+		return -EINVAL;
 	}
 
 	phv->phv_lld_host = sh;
@@ -515,10 +515,10 @@ static int pscsi_configure_device(struct se_device *dev)
 			sh = phv->phv_lld_host;
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
-			if (IS_ERR(sh)) {
+			if (!sh) {
 				pr_err("pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return PTR_ERR(sh);
+				return -EINVAL;
 			}
 		}
 	} else {
