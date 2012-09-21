From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] target: fix return value check in sbp_register_configfs()
Date: Fri, 21 Sep 2012 13:57:31 +0800
Message-ID: <CAPgLHd-Ts0ABMCb0Y6Do_ovMVd20_i+XETkm7v17Thc7wR9-fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: bootc@bootc.net, nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function target_fabric_configfs_init() returns
ERR_PTR() not NULL pointer. The NULL test in the return value check
should be replaced with IS_ERR().

dpatch engine is used to auto generated this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/sbp/sbp_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 39ddba5..773303e 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -2556,9 +2556,9 @@ static int sbp_register_configfs(void)
 	int ret;
 
 	fabric = target_fabric_configfs_init(THIS_MODULE, "sbp");
-	if (!fabric) {
+	if (IS_ERR(fabric)) {
 		pr_err("target_fabric_configfs_init() failed\n");
-		return -ENOMEM;
+		return PTR_ERR(fabric);
 	}
 
 	fabric->tf_ops = sbp_ops;
