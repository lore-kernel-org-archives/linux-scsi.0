From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] target: fix possible memory leak in core_tpg_register()
Date: Fri, 15 Mar 2013 17:19:26 +0800
Message-ID: <CAPgLHd-_WeOFu7-FedBnneXwdTkWNBc8iUpypJdtCpCG29h0TA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

'se_tpg->tpg_lun_list' is malloced in core_tpg_register() and should be freed
before leaving from the error handling cases, otherwise it will cause memory
leak. 
'se_tpg' is malloced out of this function, and will be freed if we return error, so
remove free for 'se_tpg'.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/target_core_tpg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 9169d6a..aac9d27 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -711,7 +711,8 @@ int core_tpg_register(
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) {
 		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
-			kfree(se_tpg);
+			array_free(se_tpg->tpg_lun_list,
+				   TRANSPORT_MAX_LUNS_PER_TPG);
 			return -ENOMEM;
 		}
 	}
