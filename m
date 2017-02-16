From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 07/15] aacraid: Fix sync fibs time out on controller reset
Date: Thu, 16 Feb 2017 12:51:16 -0800
Message-ID: <20170216205124.20271-8-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0058.outbound.protection.outlook.com ([104.47.40.58]:50176
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755308AbdBQD2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:12 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

After controller shutdown, all sync fibs time out due to not knowing
about the switch to INT-x mode

Fixed by replacing aac_src_access_devreg() to aac_set_intx_mode() call.

Cc: stable@vger.kernel.org
Fixes: 495c021767bd78c998 (aacraid: MSI-x support)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes in V2:
None

 drivers/scsi/aacraid/aacraid.h  | 1 +
 drivers/scsi/aacraid/comminit.c | 2 +-
 drivers/scsi/aacraid/src.c      | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index b5a2c87..9281e72 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2639,6 +2639,7 @@ void aac_hba_callback(void *context, struct fib *fibptr);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib_va->data)
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
 void aac_src_access_devreg(struct aac_dev *dev, int mode);
+void aac_set_intx_mode(struct aac_dev *dev);
 int aac_get_config_status(struct aac_dev *dev, int commit_flag);
 int aac_get_containers(struct aac_dev *dev);
 int aac_scsi_cmd(struct scsi_cmnd *cmd);
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index d0c7724..cd3456e 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -326,7 +326,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 	     dev->pdev->device == PMC_DEVICE_S8 ||
 	     dev->pdev->device == PMC_DEVICE_S9) &&
 	     dev->msi_enabled)
-		aac_src_access_devreg(dev, AAC_ENABLE_INTX);
+		aac_set_intx_mode(dev);
 	return status;
 }
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index c17b060..b23c818 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -657,7 +657,7 @@ static int aac_srcv_ioremap(struct aac_dev *dev, u32 size)
 	return 0;
 }
 
-static void aac_set_intx_mode(struct aac_dev *dev)
+void aac_set_intx_mode(struct aac_dev *dev)
 {
 	if (dev->msi_enabled) {
 		aac_src_access_devreg(dev, AAC_ENABLE_INTX);
-- 
2.7.4
