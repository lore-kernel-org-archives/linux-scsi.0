From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH V2 4/7] SCSI: esas2r: smatch - Fix overrun due to sprintf appending NULL
Date: Thu, 5 Sep 2013 13:07:57 -0400
Message-ID: <1378400880-14640-5-git-send-email-bgrove@attotech.com>
References: <1378400880-14640-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:50065 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753919Ab3IERIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 13:08:31 -0400
In-Reply-To: <1378400880-14640-1-git-send-email-bgrove@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, davej@redhat.com, Bradley Grove <bgrove@attotech.com>


Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/esas2r/esas2r_vda.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
index f8ec6d6..fd13928 100644
--- a/drivers/scsi/esas2r/esas2r_vda.c
+++ b/drivers/scsi/esas2r/esas2r_vda.c
@@ -302,6 +302,7 @@ static void esas2r_complete_vda_ioctl(struct esas2r_adapter *a,
 		if (vi->cmd.cfg.cfg_func == VDA_CFG_GET_INIT) {
 			struct atto_ioctl_vda_cfg_cmd *cfg = &vi->cmd.cfg;
 			struct atto_vda_cfg_rsp *rsp = &rq->func_rsp.cfg_rsp;
+			char buf[sizeof(cfg->data.init.fw_release) + 1];
 
 			cfg->data_length =
 				cpu_to_le32(sizeof(struct atto_vda_cfg_init));
@@ -309,11 +310,13 @@ static void esas2r_complete_vda_ioctl(struct esas2r_adapter *a,
 				le32_to_cpu(rsp->vda_version);
 			cfg->data.init.fw_build = rsp->fw_build;
 
-			sprintf((char *)&cfg->data.init.fw_release,
-				"%1d.%02d",
+			snprintf(buf, sizeof(buf), "%1d.%02d",
 				(int)LOBYTE(le16_to_cpu(rsp->fw_release)),
 				(int)HIBYTE(le16_to_cpu(rsp->fw_release)));
 
+			memcpy(&cfg->data.init.fw_release, buf,
+			       sizeof(cfg->data.init.fw_release));
+
 			if (LOWORD(LOBYTE(cfg->data.init.fw_build)) == 'A')
 				cfg->data.init.fw_version =
 					cfg->data.init.fw_build;
-- 
1.8.1.4

