From: Eric B Munson <emunson@akamai.com>
Subject: [PATCH] Initialize off value in asd_process_ctrl_a_user()
Date: Tue,  2 Dec 2014 11:34:01 -0500
Message-ID: <1417538041-6850-1-git-send-email-emunson@akamai.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:61281 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbaLBQfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 11:35:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Eric B Munson <emunson@akamai.com>, stable@vger.kernel.org

If the asd_find_flash_de() function returns ENOENT the off value will
be used uninitialized in the call to asd_read_flash_seg().

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/aic94xx/aic94xx_sds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..6f6a5b8 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
 	int err, i;
-	u32 offs, size;
+	u32 offs = 0, size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
-- 
1.9.1

