From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] BNX2I: Fixed the override of the error_mask module
 param
Date: Thu, 2 Feb 2012 15:22:00 -0800
Message-ID: <1328224920-26757-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhDds6z5BBoE6i6uGw-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The error_mask module param overrides has a bug which prevented
the new module param values to take effect.

Also changed the type attribute of the error_mask1/2 module params
from int to uint to allow the MSB to be set.

Signed-off-by: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Acked-by: Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

---
 drivers/scsi/bnx2i/bnx2i_hwi.c  |   12 ++++++++----
 drivers/scsi/bnx2i/bnx2i_init.c |    4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 1ad0b82..f9d6f41 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1312,14 +1312,18 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
 		  ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_EXP_DATASN) |
 		/* EMC */
 		(1ULL << ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_LUN));
-	if (error_mask1)
+	if (error_mask1) {
 		iscsi_init2.error_bit_map[0] = error_mask1;
-	else
+		mask64 &= (u32)(~mask64);
+		mask64 |= error_mask1;
+	} else
 		iscsi_init2.error_bit_map[0] = (u32) mask64;
 
-	if (error_mask2)
+	if (error_mask2) {
 		iscsi_init2.error_bit_map[1] = error_mask2;
-	else
+		mask64 &= 0xffffffff;
+		mask64 |= ((u64)error_mask2 << 32);
+	} else
 		iscsi_init2.error_bit_map[1] = (u32) (mask64 >> 32);
 
 	iscsi_error_mask = mask64;
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 1a947f1..cc5a6c1 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -49,11 +49,11 @@ module_param(en_tcp_dack, int, 0664);
 MODULE_PARM_DESC(en_tcp_dack, "Enable TCP Delayed ACK");
 
 unsigned int error_mask1 = 0x00;
-module_param(error_mask1, int, 0664);
+module_param(error_mask1, uint, 0664);
 MODULE_PARM_DESC(error_mask1, "Config FW iSCSI Error Mask #1");
 
 unsigned int error_mask2 = 0x00;
-module_param(error_mask2, int, 0664);
+module_param(error_mask2, uint, 0664);
 MODULE_PARM_DESC(error_mask2, "Config FW iSCSI Error Mask #2");
 
 unsigned int sq_size;
-- 
1.7.7.4


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
