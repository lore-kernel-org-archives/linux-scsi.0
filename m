From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: respond to unknown initiators with sensible REPORT LUNS list length
Date: Wed, 22 Jul 2015 15:08:17 -0700
Message-ID: <1437602898-15229-3-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Roland Dreier <roland@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Solaris seems to go beserk if we respond to REPORT LUNS with a
LUN LIST LENGTH of 0.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_spc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 87d4adb..d8a32e5 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1241,6 +1241,13 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	 * See SPC3 r07, page 159.
 	 */
 done:
+	/*
+	 * If no real LUNs are accessible, report an allocation length
+	 * of 1 LUN to account for virtual LUN 0.
+	 */
+	if (lun_count == 0)
+		lun_count = 1;
+
 	lun_count *= 8;
 	buf[0] = ((lun_count >> 24) & 0xff);
 	buf[1] = ((lun_count >> 16) & 0xff);
-- 
2.5.0.rc3
