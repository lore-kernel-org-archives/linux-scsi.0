From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 4/9] target/spc: Only expose PI mode page bits when supported by fabric
Date: Thu,  3 Apr 2014 09:35:48 +0000
Message-ID: <1396517753-23546-5-git-send-email-nab@daterainc.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Only expose the control modepage bit for Application Tag Owner (ATO)
if the session + fabric support DIX PASS operations.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index d4c6a31..8653666 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -769,7 +769,7 @@ out:
 	return ret;
 }
 
-static int spc_modesense_rwrecovery(struct se_device *dev, u8 pc, u8 *p)
+static int spc_modesense_rwrecovery(struct se_cmd *cmd, u8 pc, u8 *p)
 {
 	p[0] = 0x01;
 	p[1] = 0x0a;
@@ -782,8 +782,11 @@ out:
 	return 12;
 }
 
-static int spc_modesense_control(struct se_device *dev, u8 pc, u8 *p)
+static int spc_modesense_control(struct se_cmd *cmd, u8 pc, u8 *p)
 {
+	struct se_device *dev = cmd->se_dev;
+	struct se_session *sess = cmd->se_sess;
+
 	p[0] = 0x0a;
 	p[1] = 0x0a;
 
@@ -875,8 +878,10 @@ static int spc_modesense_control(struct se_device *dev, u8 pc, u8 *p)
 	 * type, shall not modify the contents of the LOGICAL BLOCK REFERENCE
 	 * TAG field.
 	 */
-	if (dev->dev_attrib.pi_prot_type)
-		p[5] |= 0x80;
+	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
+		if (dev->dev_attrib.pi_prot_type)
+			p[5] |= 0x80;
+	}
 
 	p[8] = 0xff;
 	p[9] = 0xff;
@@ -886,8 +891,10 @@ out:
 	return 12;
 }
 
-static int spc_modesense_caching(struct se_device *dev, u8 pc, u8 *p)
+static int spc_modesense_caching(struct se_cmd *cmd, u8 pc, u8 *p)
 {
+	struct se_device *dev = cmd->se_dev;
+
 	p[0] = 0x08;
 	p[1] = 0x12;
 
@@ -903,7 +910,7 @@ out:
 	return 20;
 }
 
-static int spc_modesense_informational_exceptions(struct se_device *dev, u8 pc, unsigned char *p)
+static int spc_modesense_informational_exceptions(struct se_cmd *cmd, u8 pc, unsigned char *p)
 {
 	p[0] = 0x1c;
 	p[1] = 0x0a;
@@ -919,7 +926,7 @@ out:
 static struct {
 	uint8_t		page;
 	uint8_t		subpage;
-	int		(*emulate)(struct se_device *, u8, unsigned char *);
+	int		(*emulate)(struct se_cmd *, u8, unsigned char *);
 } modesense_handlers[] = {
 	{ .page = 0x01, .subpage = 0x00, .emulate = spc_modesense_rwrecovery },
 	{ .page = 0x08, .subpage = 0x00, .emulate = spc_modesense_caching },
@@ -1057,7 +1064,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 			 * the only two possibilities).
 			 */
 			if ((modesense_handlers[i].subpage & ~subpage) == 0) {
-				ret = modesense_handlers[i].emulate(dev, pc, &buf[length]);
+				ret = modesense_handlers[i].emulate(cmd, pc, &buf[length]);
 				if (!ten && length + ret >= 255)
 					break;
 				length += ret;
@@ -1070,7 +1077,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	for (i = 0; i < ARRAY_SIZE(modesense_handlers); ++i)
 		if (modesense_handlers[i].page == page &&
 		    modesense_handlers[i].subpage == subpage) {
-			length += modesense_handlers[i].emulate(dev, pc, &buf[length]);
+			length += modesense_handlers[i].emulate(cmd, pc, &buf[length]);
 			goto set_length;
 		}
 
@@ -1102,7 +1109,6 @@ set_length:
 
 static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 {
-	struct se_device *dev = cmd->se_dev;
 	char *cdb = cmd->t_task_cdb;
 	bool ten = cdb[0] == MODE_SELECT_10;
 	int off = ten ? 8 : 4;
@@ -1138,7 +1144,7 @@ static sense_reason_t spc_emulate_modeselect(struct se_cmd *cmd)
 		if (modesense_handlers[i].page == page &&
 		    modesense_handlers[i].subpage == subpage) {
 			memset(tbuf, 0, SE_MODE_PAGE_BUF);
-			length = modesense_handlers[i].emulate(dev, 0, tbuf);
+			length = modesense_handlers[i].emulate(cmd, 0, tbuf);
 			goto check_contents;
 		}
 
-- 
1.7.10.4
