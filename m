From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] megaraid_sas_fusion: Return correct error value in megasas_get_ld_map_info()
Date: Thu, 16 Jan 2014 11:25:35 +0100
Message-ID: <1389867936-118685-6-git-send-email-hare@suse.de>
References: <1389867936-118685-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39937 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaAPKZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 05:25:40 -0500
In-Reply-To: <1389867936-118685-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, Adam Radford <aradford@gmail.com>

When no HBA is found we should be returning '-ENXIO' to be consistent
with the other return values.

Cc: Kashyap Desai <kashyap.desai@lsi.com>
Cc: Adam Radford <aradford@gmail.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index be6de80..c2dc033 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -726,7 +726,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 
 	if (!fusion) {
 		megasas_return_cmd(instance, cmd);
-		return 1;
+		return -ENXIO;
 	}
 
 	dcmd = &cmd->frame->dcmd;
-- 
1.7.12.4

