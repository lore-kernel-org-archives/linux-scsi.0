From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] target: Fix missing length check in spc_emulate_evpd_83()
Date: Mon,  3 Feb 2014 00:35:03 -0800
Message-ID: <1391416503-22022-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:41040 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751010AbaBCIfJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 03:35:09 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa1so6820565pad.13
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2014 00:35:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Commit fbfe858fea2a ("target_core_spc: Include target device
descriptor in VPD page 83") added a new length variable, but (due to a
cut and paste mistake?) just checks scsi_name_len against 256 twice.
Fix this to check scsi_target_len for overflow too.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_spc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 43c5ca9878bc..3bebc71ea033 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -440,8 +440,8 @@ check_scsi_name:
 		padding = ((-scsi_target_len) & 3);
 		if (padding)
 			scsi_target_len += padding;
-		if (scsi_name_len > 256)
-			scsi_name_len = 256;
+		if (scsi_target_len > 256)
+			scsi_target_len = 256;
 
 		buf[off-1] = scsi_target_len;
 		off += scsi_target_len;
-- 
1.9.rc1

