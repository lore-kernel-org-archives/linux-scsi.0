From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: don't try to load a device handler during async probing
Date: Thu,  8 Oct 2015 09:25:32 +0100
Message-ID: <1444292732-8571-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48424 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbJHI3R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 04:29:17 -0400
Received: from [193.120.165.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zk6Zg-0003aC-LG
	for linux-scsi@vger.kernel.org; Thu, 08 Oct 2015 08:29:17 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Request_module gets really unhappy when called from async probing, so
revert to not auto load device handler modules during the SCSI bus
scan.  While autoloading would be really useful we never did this
until 4.3-rc and it turns out that functionality doesn't actually
work.

Fixes: 566079 ("dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Paul Mackerras <paulus@ozlabs.org>
Tested-by: Paul Mackerras <paulus@ozlabs.org>
---
 drivers/scsi/scsi_dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 0a2168e..d771bec 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -226,7 +226,7 @@ int scsi_dh_add_device(struct scsi_device *sdev)
 
 	drv = scsi_dh_find_driver(sdev);
 	if (drv)
-		devinfo = scsi_dh_lookup(drv);
+		devinfo = __scsi_dh_lookup(drv);
 	if (devinfo)
 		err = scsi_dh_handler_attach(sdev, devinfo);
 	return err;
-- 
1.9.1

