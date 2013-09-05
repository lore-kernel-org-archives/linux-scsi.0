From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH V2 3/7] SCSI: esas2r: smatch - Fix dereference that occurs prior to check
Date: Thu, 5 Sep 2013 13:07:56 -0400
Message-ID: <1378400880-14640-4-git-send-email-bgrove@attotech.com>
References: <1378400880-14640-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:15025 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753525Ab3IERI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 13:08:29 -0400
In-Reply-To: <1378400880-14640-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, davej@redhat.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_flash.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 8582929..45e353f 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -860,8 +860,13 @@ bool esas2r_process_fs_ioctl(struct esas2r_adapter *a,
 		return false;
 	}
 
+	if (fsc->command >= cmdcnt) {
+		fs->status = ATTO_STS_INV_FUNC;
+		return false;
+	}
+
 	func = cmd_to_fls_func[fsc->command];
-	if (fsc->command >= cmdcnt || func == 0xFF) {
+	if (func == 0xFF) {
 		fs->status = ATTO_STS_INV_FUNC;
 		return false;
 	}
-- 
1.8.1.4

