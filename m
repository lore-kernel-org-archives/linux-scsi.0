From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] iscsi: Fix a sleep-in-atomic bug
Date: Wed, 31 May 2017 11:26:39 +0800
Message-ID: <1496201199-3661-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nab@linux-iscsi.org, bart.vanassche@sandisk.com, davem@davemloft.net, hare@suse.com, elfring@users.sourceforge.net
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep under a spin lock, and the function call path is:
iscsit_tpg_enable_portal_group (acquire the lock by spin_lock)
  iscsi_update_param_value
    kstrdup(GFP_KERNEL) --> may sleep

To fix it, the "GFP_KERNEL" is replaced with "GFP_ATOMIC".

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/target/iscsi/iscsi_target_parameters.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index fce6276..8768916 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -702,7 +702,7 @@ int iscsi_update_param_value(struct iscsi_param *param, char *value)
 {
 	kfree(param->value);
 
-	param->value = kstrdup(value, GFP_KERNEL);
+	param->value = kstrdup(value, GFP_ATOMIC);
 	if (!param->value) {
 		pr_err("Unable to allocate memory for value.\n");
 		return -ENOMEM;
-- 
1.7.9.5
