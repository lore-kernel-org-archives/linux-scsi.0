From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH 1/3] isci: remove SCSI host before detaching from SAS transport
Date: Thu,  5 Nov 2015 12:32:29 +0100
Message-ID: <1446723149-9656-1-git-send-email-jinpu.wang@profitbricks.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34570 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbbKELcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 06:32:39 -0500
Received: by wmnn186 with SMTP id n186so11448364wmn.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2015 03:32:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, intel-linux-scu@intel.com
Cc: hch@lst.de, brood@attotech.com, Jack Wang <jinpu.wang@profitbricks.com>

commit cff549e4860f ("scsi: proper state checking and module refcount
handling in scsi_device_get")
, the reference count of scsi device was changed, which could lead to when
rmmod with at least on drive attached, SCSI error handle will
run into infinite loop, and lockup the system.

Fix it by remove scsi host first, this way scsi core will not send
commands down after detaching SAS transport.

This is a follow up fix for Benjamin's fix for pm80xx.

See also:
http://www.spinics.net/lists/linux-scsi/msg90088.html

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/isci/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 0dfcabe..9e0d069 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -272,11 +272,11 @@ static void isci_unregister(struct isci_host *isci_host)
 	if (!isci_host)
 		return;
 
+	shost = to_shost(isci_host);
+	scsi_remove_host(shost);
 	sas_unregister_ha(&isci_host->sas_ha);
 
-	shost = to_shost(isci_host);
 	sas_remove_host(shost);
-	scsi_remove_host(shost);
 	scsi_host_put(shost);
 }
 
-- 
1.9.1

