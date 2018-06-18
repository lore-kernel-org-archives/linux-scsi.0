From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] aacraid: stop using deprated get_seconds()
Date: Mon, 18 Jun 2018 17:26:47 +0200
Message-ID: <20180618152734.1705907-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <david.carroll@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

get_seconds() can overflow on 32-bit architectures and is deprecated
because of that. The use in the aacraid driver has the same problem due
to a limited firmware interface, it also overflows in the year 2106.

This changes all calls to get_seconds() to the non-deprecated
ktime_get_real_seconds(), which unfortunately doesn't solve that problem
but gets rid of one user of the deprecated interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aacraid/rx.c  | 2 +-
 drivers/scsi/aacraid/sa.c  | 2 +-
 drivers/scsi/aacraid/src.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 620166694171..576cdf9cc120 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -319,7 +319,7 @@ static void aac_rx_start_adapter(struct aac_dev *dev)
 	union aac_init *init;
 
 	init = dev->init;
-	init->r7.host_elapsed_seconds = cpu_to_le32(get_seconds());
+	init->r7.host_elapsed_seconds = cpu_to_le32(ktime_get_real_seconds());
 	// We can only use a 32 bit address here
 	rx_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, (u32)(ulong)dev->init_pa,
 	  0, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL);
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index 882f40353b96..efa96c1c6aa3 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -251,7 +251,7 @@ static void aac_sa_start_adapter(struct aac_dev *dev)
 	 * Fill in the remaining pieces of the init.
 	 */
 	init = dev->init;
-	init->r7.host_elapsed_seconds = cpu_to_le32(get_seconds());
+	init->r7.host_elapsed_seconds = cpu_to_le32(ktime_get_real_seconds());
 	/* We can only use a 32 bit address here */
 	sa_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS, 
 			(u32)(ulong)dev->init_pa, 0, 0, 0, 0, 0,
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 4ebb35a29caa..5a299975a289 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -409,7 +409,7 @@ static void aac_src_start_adapter(struct aac_dev *dev)
 
 	init = dev->init;
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) {
-		init->r8.host_elapsed_seconds = cpu_to_le32(get_seconds());
+		init->r8.host_elapsed_seconds = cpu_to_le32(ktime_get_real_seconds());
 		src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS,
 			lower_32_bits(dev->init_pa),
 			upper_32_bits(dev->init_pa),
@@ -417,7 +417,7 @@ static void aac_src_start_adapter(struct aac_dev *dev)
 			(AAC_MAX_HRRQ - 1) * sizeof(struct _rrq),
 			0, 0, 0, NULL, NULL, NULL, NULL, NULL);
 	} else {
-		init->r7.host_elapsed_seconds = cpu_to_le32(get_seconds());
+		init->r7.host_elapsed_seconds = cpu_to_le32(ktime_get_real_seconds());
 		// We can only use a 32 bit address here
 		src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS,
 			(u32)(ulong)dev->init_pa, 0, 0, 0, 0, 0,
-- 
2.9.0
