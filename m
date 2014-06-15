From: Joe Perches <joe@perches.com>
Subject: [PATCH -next 20/26] megaraid: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:49 -0700
Message-ID: <c984d1be8d1f03baa81f4d1d319d1de8d51688f1.1402863905.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 2260041..1b18010 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -608,10 +608,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		goto fail_get_cmd;
 	}
 
-	IOCInitMessage =
-	  dma_alloc_coherent(&instance->pdev->dev,
-			     sizeof(struct MPI2_IOC_INIT_REQUEST),
-			     &ioc_init_handle, GFP_KERNEL);
+	IOCInitMessage = dma_zalloc_coherent(&instance->pdev->dev,
+					     sizeof(struct MPI2_IOC_INIT_REQUEST),
+					     &ioc_init_handle, GFP_KERNEL);
 
 	if (!IOCInitMessage) {
 		printk(KERN_ERR "Could not allocate memory for "
@@ -620,8 +619,6 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		goto fail_fw_init;
 	}
 
-	memset(IOCInitMessage, 0, sizeof(struct MPI2_IOC_INIT_REQUEST));
-
 	IOCInitMessage->Function = MPI2_FUNCTION_IOC_INIT;
 	IOCInitMessage->WhoInit	= MPI2_WHOINIT_HOST_DRIVER;
 	IOCInitMessage->MsgVersion = cpu_to_le16(MPI2_VERSION);
-- 
1.8.1.2.459.gbcd45b4.dirty
