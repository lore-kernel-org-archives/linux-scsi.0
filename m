From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 06/15] Staging: hv: storvsc: Move and cleanup storvsc_remove()
Date: Thu, 12 Jan 2012 12:37:59 -0800
Message-ID: <1326400688-13544-6-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:56861
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755439Ab2ALUlp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 15:41:45 -0500
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

Relocate the storvsc_remove() function to a different location in the file
and invoke scsi_host_put() only after all the cleanup. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 8340387..e0e471c 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1083,22 +1083,6 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 	return total_copied;
 }
 
-
-static int storvsc_remove(struct hv_device *dev)
-{
-	struct storvsc_device *stor_device = hv_get_drvdata(dev);
-	struct Scsi_Host *host = stor_device->host;
-
-	scsi_remove_host(host);
-
-	scsi_host_put(host);
-
-	storvsc_dev_remove(dev);
-
-	return 0;
-}
-
-
 static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 			   sector_t capacity, int *info)
 {
@@ -1526,6 +1510,18 @@ err_out0:
 	return ret;
 }
 
+static int storvsc_remove(struct hv_device *dev)
+{
+	struct storvsc_device *stor_device = hv_get_drvdata(dev);
+	struct Scsi_Host *host = stor_device->host;
+
+	scsi_remove_host(host);
+	storvsc_dev_remove(dev);
+	scsi_host_put(host);
+
+	return 0;
+}
+
 static struct hv_driver storvsc_drv = {
 	.name = KBUILD_MODNAME,
 	.id_table = id_table,
-- 
1.7.4.1

