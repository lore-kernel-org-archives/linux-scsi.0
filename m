From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] target: iscsi: iscsi_target_tpg.c:  Cleaning up possible size overwriting in conjunction with sprintf
Date: Sun, 12 Oct 2014 19:55:58 +0200
Message-ID: <1413136558-20790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Andy Grover <agrover@redhat.com>, Thomas Glanzmann <thomas@glanzmann.de>, Christophe Vu-Brugier <cvubrugier@yahoo.fr>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changed same snprintf and sprintf to strlcpy and strlcat.
This will guarantee that the string size is not overwritten,
and they are significantly faster than sprintf also.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/target/iscsi/iscsi_target_tpg.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index c3cb5c1..6fc8bfe 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -608,7 +608,6 @@ int iscsit_tpg_set_initiator_node_queue_depth(
 int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 {
 	unsigned char buf1[256], buf2[256], *none = NULL;
-	int len;
 	struct iscsi_param *param;
 	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
 
@@ -626,34 +625,33 @@ int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 		return -EINVAL;
 
 	if (authentication) {
-		snprintf(buf1, sizeof(buf1), "%s", param->value);
+		strlcpy(buf1, param->value, sizeof(buf1));
 		none = strstr(buf1, NONE);
 		if (!none)
 			goto out;
 		if (!strncmp(none + 4, ",", 1)) {
 			if (!strcmp(buf1, none))
-				sprintf(buf2, "%s", none+5);
+				strlcpy(buf2, none+5, sizeof(buf2));
 			else {
 				none--;
 				*none = '\0';
-				len = sprintf(buf2, "%s", buf1);
+				strlcpy(buf2, buf1, sizeof(buf2));
 				none += 5;
-				sprintf(buf2 + len, "%s", none);
+				strlcat(buf2, none, sizeof(buf2));
 			}
 		} else {
 			none--;
 			*none = '\0';
-			sprintf(buf2, "%s", buf1);
+			strlcpy(buf2, buf1, sizeof(buf2));
 		}
 		if (iscsi_update_param_value(param, buf2) < 0)
 			return -EINVAL;
 	} else {
-		snprintf(buf1, sizeof(buf1), "%s", param->value);
+		strlcpy(buf1, param->value, sizeof(buf1));
 		none = strstr(buf1, NONE);
 		if (none)
 			goto out;
-		strncat(buf1, ",", strlen(","));
-		strncat(buf1, NONE, strlen(NONE));
+		strlcat(buf1, ","  NONE , sizeof(buf1));
 		if (iscsi_update_param_value(param, buf1) < 0)
 			return -EINVAL;
 	}
-- 
1.7.10.4
