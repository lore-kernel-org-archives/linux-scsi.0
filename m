From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/5] Staging: hv: storvsc: Cleanup storvsc_device_alloc()
Date: Thu,  1 Dec 2011 04:59:17 -0800
Message-ID: <1322744360-13067-2-git-send-email-kys@microsoft.com>
References: <1322744315-13017-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322744360-13067-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

The code in storvsc_device_alloc() is not needed as this would be
done by default. Get rid of it. We still keep the function as we use
this hook to allocate per-LUN memory pools in a later patch.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9153f98..14ecb69 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -790,11 +790,6 @@ static void storvsc_get_ide_info(struct hv_device *dev, int *target, int *path)
 
 static int storvsc_device_alloc(struct scsi_device *sdevice)
 {
-	/*
-	 * This enables luns to be located sparsely. Otherwise, we may not
-	 * discovered them.
-	 */
-	sdevice->sdev_bflags |= BLIST_SPARSELUN | BLIST_LARGELUN;
 	return 0;
 }
 
-- 
1.7.4.1
