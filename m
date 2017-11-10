From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] megaraid: use ktime_get_real for firmware time
Date: Fri, 10 Nov 2017 16:41:15 +0100
Message-ID: <20171110154121.1934289-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.com>, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

do_gettimeofday() overflows in 2038 on 32-bit architectures and
is deprecated, so convert this driver to call ktime_get_real()
directly. This also simplifies the calculation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 65dc4fea6352..b8ada27d84a4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -983,7 +983,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	MFI_CAPABILITIES *drv_ops;
 	u32 scratch_pad_2;
 	unsigned long flags;
-	struct timeval tv;
+	ktime_t time;
 	bool cur_fw_64bit_dma_capable;
 
 	fusion = instance->ctrl_context;
@@ -1042,10 +1042,9 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	IOCInitMessage->HostMSIxVectors = instance->msix_vectors;
 	IOCInitMessage->HostPageSize = MR_DEFAULT_NVME_PAGE_SHIFT;
 
-	do_gettimeofday(&tv);
+	time = ktime_get_real();
 	/* Convert to milliseconds as per FW requirement */
-	IOCInitMessage->TimeStamp = cpu_to_le64((tv.tv_sec * 1000) +
-						(tv.tv_usec / 1000));
+	IOCInitMessage->TimeStamp = cpu_to_le64(ktime_to_ms(time));
 
 	init_frame = (struct megasas_init_frame *)cmd->frame;
 	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
-- 
2.9.0
