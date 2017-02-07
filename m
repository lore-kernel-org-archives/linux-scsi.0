From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: aacraid: avoid open-coded upper_32_bits
Date: Tue,  7 Feb 2017 13:59:30 +0100
Message-ID: <20170207125948.490095-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Thumshirn <jthumshirn@suse.de>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <David.Carroll@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Shifting a dma_addr_t right by 32 bits causes a compile-time warning when
that type is only 32 bit wide:

drivers/scsi/aacraid/src.c: In function 'aac_src_start_adapter':
drivers/scsi/aacraid/src.c:414:29: error: right shift count >= width of type [-Werror=shift-count-overflow]

This changes the driver to use the predefined macros consistently, including
one correct but open-coded upper_32_bits() instance.

Fixes: d1ef4da8487f ("scsi: aacraid: added support for init_struct_8")
Fixes: 423400e64d37 ("scsi: aacraid: Include HBA direct interface")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/aacraid/src.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 46976a3b6952..8e4e2ddbafd7 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -410,8 +410,8 @@ static void aac_src_start_adapter(struct aac_dev *dev)
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3) {
 		init->r8.host_elapsed_seconds = cpu_to_le32(get_seconds());
 		src_sync_cmd(dev, INIT_STRUCT_BASE_ADDRESS,
-			(u32)(ulong)dev->init_pa,
-			(u32)((ulong)dev->init_pa>>32),
+			lower_32_bits(dev->init_pa),
+			upper_32_bits(dev->init_pa),
 			sizeof(struct _r8) +
 			(AAC_MAX_HRRQ - 1) * sizeof(struct _rrq),
 			0, 0, 0, NULL, NULL, NULL, NULL, NULL);
@@ -563,7 +563,7 @@ static int aac_src_deliver_message(struct fib *fib)
 			fib->hw_fib_va->header.SenderFibAddress =
 				cpu_to_le32((u32)address);
 			fib->hw_fib_va->header.u.TimeStamp = 0;
-			WARN_ON(((u32)(((address) >> 16) >> 16)) != 0L);
+			WARN_ON(upper_32_bits(address) != 0L);
 		} else {
 			/* Calculate the amount to the fibsize bits */
 			fibsize = (sizeof(struct aac_fib_xporthdr) +
-- 
2.9.0
