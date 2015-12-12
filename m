From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/7] iscsi-target: Use a variable initialisation in
 iscsi_set_default_param() directly
Date: Sat, 12 Dec 2015 15:34:50 +0100
Message-ID: <566C308A.6000109@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <566C2F7B.6030704@users.sourceforge.net>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Dec 2015 11:36:02 +0100

Omit the unnecessary setting to a null pointer for the variable "param"
at the beginning of the function "iscsi_set_default_param"
because it can be directly initialized with the return value
from the function "kzalloc".

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 3a1f9a7..0a8bd3f 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -127,9 +127,8 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 		char *name, char *value, u8 phase, u8 scope, u8 sender,
 		u16 type_range, u8 use)
 {
-	struct iscsi_param *param = NULL;
+	struct iscsi_param *param = kzalloc(sizeof(*param), GFP_KERNEL);
 
-	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 	if (!param) {
 		pr_err("Unable to allocate memory for parameter.\n");
 		goto out;
-- 
2.6.3
