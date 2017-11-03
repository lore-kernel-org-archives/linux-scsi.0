From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] iSCSI-target: Use common error handling code in
 iscsi_decode_text_input()
Date: Fri, 3 Nov 2017 22:33:08 +0100
Message-ID: <d36d5072-3e35-da39-bc0f-af15deb630a8@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 3 Nov 2017 22:20:38 +0100

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 39 ++++++++++++--------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index caab1045742d..29a37b242d30 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1380,10 +1380,8 @@ int iscsi_decode_text_input(
 		char *key, *value;
 		struct iscsi_param *param;
 
-		if (iscsi_extract_key_value(start, &key, &value) < 0) {
-			kfree(tmpbuf);
-			return -1;
-		}
+		if (iscsi_extract_key_value(start, &key, &value) < 0)
+			goto free_buffer;
 
 		pr_debug("Got key: %s=%s\n", key, value);
 
@@ -1396,38 +1394,37 @@ int iscsi_decode_text_input(
 
 		param = iscsi_check_key(key, phase, sender, param_list);
 		if (!param) {
-			if (iscsi_add_notunderstood_response(key,
-					value, param_list) < 0) {
-				kfree(tmpbuf);
-				return -1;
-			}
+			if (iscsi_add_notunderstood_response(key, value,
+							     param_list) < 0)
+				goto free_buffer;
+
 			start += strlen(key) + strlen(value) + 2;
 			continue;
 		}
-		if (iscsi_check_value(param, value) < 0) {
-			kfree(tmpbuf);
-			return -1;
-		}
+		if (iscsi_check_value(param, value) < 0)
+			goto free_buffer;
 
 		start += strlen(key) + strlen(value) + 2;
 
 		if (IS_PSTATE_PROPOSER(param)) {
-			if (iscsi_check_proposer_state(param, value) < 0) {
-				kfree(tmpbuf);
-				return -1;
-			}
+			if (iscsi_check_proposer_state(param, value) < 0)
+				goto free_buffer;
+
 			SET_PSTATE_RESPONSE_GOT(param);
 		} else {
-			if (iscsi_check_acceptor_state(param, value, conn) < 0) {
-				kfree(tmpbuf);
-				return -1;
-			}
+			if (iscsi_check_acceptor_state(param, value, conn) < 0)
+				goto free_buffer;
+
 			SET_PSTATE_ACCEPTOR(param);
 		}
 	}
 
 	kfree(tmpbuf);
 	return 0;
+
+free_buffer:
+	kfree(tmpbuf);
+	return -1;
 }
 
 int iscsi_encode_text_output(
-- 
2.15.0
