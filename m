From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 2/3] aic94xx: remove SCSI host before detaching from SAS transport
Date: Thu,  5 Nov 2015 12:33:45 +0100
Message-ID: <1446723225-9704-1-git-send-email-jinpu.wang@profitbricks.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38599 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbbKELdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 06:33:54 -0500
Received: by wmeg8 with SMTP id g8so10658167wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 03:33:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com
Cc: hch@lst.de, brood@attotech.com, Jack Wang <jinpu.wang@profitbricks.com>

commit cff549e4860f ("scsi: proper state checking and module refcount
handling in scsi_device_get")
the reference count of scsi device was changed, which could lead to
when rmmod with at least on drive attached, SCSI error handle will
run into infinite loop, and lockup the system.

Fix it by remove scsi host first, this way scsi core will not send
commands down after detaching SAS transport.

This is a follow up fix for Benjamin's fix for pm80xx.

See also:
http://www.spinics.net/lists/linux-scsi/msg90088.html

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index f6c336b..4b56976 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -704,10 +704,10 @@ static int asd_unregister_sas_ha(struct asd_ha_struct *asd_ha)
 {
 	int err;
 
+	scsi_remove_host(asd_ha->sas_ha.core.shost);
 	err = sas_unregister_ha(&asd_ha->sas_ha);
 
 	sas_remove_host(asd_ha->sas_ha.core.shost);
-	scsi_remove_host(asd_ha->sas_ha.core.shost);
 	scsi_host_put(asd_ha->sas_ha.core.shost);
 
 	kfree(asd_ha->sas_ha.sas_phy);
-- 
1.9.1

