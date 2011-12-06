From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] target: Set response format in INQUIRY response
Date: Tue,  6 Dec 2011 10:02:09 -0800
Message-ID: <1323194529-17886-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Current SCSI specs say that the "response format" field in the standard
INQUIRY response should be set to 2, and all the real SCSI devices I
have do put 2 here.  So let's do that too.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_cdb.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 957fac7..0a96bbb 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -96,6 +96,18 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 	buf[2] = dev->transport->get_device_rev(dev);
 
 	/*
+	 * NORMACA and HISUP = 0, RESPONSE DATA FORMAT = 2
+	 *
+	 * SPC4 says:
+	 *   A RESPONSE DATA FORMAT field set to 2h indicates that the
+	 *   standard INQUIRY data is in the format defined in this
+	 *   standard. Response data format values less than 2h are
+	 *   obsolete. Response data format values greater than 2h are
+	 *   reserved.
+	 */
+	buf[3] = 2;
+
+	/*
 	 * Enable SCCS and TPGS fields for Emulated ALUA
 	 */
 	if (dev->se_sub_dev->t10_alua.alua_type == SPC3_ALUA_EMULATED)
-- 
1.7.5.4
