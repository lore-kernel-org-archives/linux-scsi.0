From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] scsi: arm: fas216: Use %llu to print 'u64' format
Date: Thu, 10 Jul 2014 20:33:07 -0300
Message-ID: <1405035187-27737-1-git-send-email-festevam@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:36857 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGJXd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 19:33:29 -0400
Received: by mail-yh0-f47.google.com with SMTP id v1so139694yhn.34
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2014 16:33:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>

From: Fabio Estevam <fabio.estevam@freescale.com>

The following warning is seen when building for ARM:

drivers/scsi/arm/fas216.c:3003:3: warning: format '%d' expects argument of type
'int', but argument 4 has type 'u64' [-Wformat=]

Use %llu to print 'u64' format.

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/scsi/arm/fas216.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index b46a6f6..aeddd11 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -3000,7 +3000,7 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
 
 	shost_for_each_device(scd, info->host) {
 		dev = &info->device[scd->id];
-		seq_printf(m, "     %d/%d   ", scd->id, scd->lun);
+		seq_printf(m, "     %d/%llu   ", scd->id, scd->lun);
 		if (scd->tagged_supported)
 			seq_printf(m, "%3sabled(%3d) ",
 				     scd->simple_tags ? "en" : "dis",
-- 
1.8.3.2

