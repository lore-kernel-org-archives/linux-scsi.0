From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 1/5] Add P3 support, define reg & struct
Date: Fri,  3 Jun 2016 20:11:44 +0800
Message-ID: <1464955904-16738-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com
Cc: Paul <paul.lyu@tw.promise.com>
List-Id: linux-scsi@vger.kernel.org

From: Paul <paul.lyu@tw.promise.com>

1.Change ver
2.Add P3 VID & DID
2.Define device reg
3.Add P3 struct and callback

Signed-off-by: Paul <paul.lyu@tw.promise.com>
---
 drivers/scsi/stex.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 5b23175..f8195c0 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -38,8 +38,8 @@
 #include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION	"5.00.0000.01"
-#define ST_VER_MAJOR		5
+#define ST_DRIVER_VERSION	"6.00.0000.01"
+#define ST_VER_MAJOR		6
 #define ST_VER_MINOR		00
 #define ST_OEM				0000
 #define ST_BUILD_VER		01
@@ -64,6 +64,13 @@ enum {
 	YI2H_INT_C				= 0xa0,
 	YH2I_REQ				= 0xc0,
 	YH2I_REQ_HI				= 0xc4,
+	PSCRATCH0				= 0xb0,
+	PSCRATCH1				= 0xb4,
+	PSCRATCH2				= 0xb8,
+	PSCRATCH3				= 0xbc,
+	PSCRATCH4				= 0xc8,
+	MAILBOX_BASE			= 0x1000,
+	MAILBOX_HNDSHK_STS		= 0x0,
 
 	/* MU register value */
 	MU_INBOUND_DOORBELL_HANDSHAKE		= (1 << 0),
@@ -135,6 +142,7 @@ enum {
 	st_yosemite				= 2,
 	st_seq					= 3,
 	st_yel					= 4,
+	st_P3					= 5,
 
 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
@@ -1414,6 +1422,13 @@ static struct pci_device_id stex_pci_tbl[] = {
 	/* st_yel */
 	{ 0x105a, 0x8650, 0x1033, PCI_ANY_ID, 0, 0, st_yel },
 	{ 0x105a, 0x8760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yel },
+
+	/* st_P3, pluto */
+	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
+		0x8870, 0, 0, st_P3 },
+	/* st_P3, p3 */
+	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
+		0x4300, 0, 0, st_P3 },
 	{ }	/* terminate list */
 };
 
@@ -1482,6 +1497,19 @@ static struct st_card_info stex_card_info[] = {
 		.map_sg		= stex_ss_map_sg,
 		.send		= stex_ss_send_cmd,
 	},
+
+	/* st_P3 */
+	{
+		.max_id		= 129,
+		.max_lun	= 256,
+		.max_channel	= 0,
+		.rq_count	= 801,
+		.rq_size	= 512,
+		.sts_count	= 801,
+		.alloc_rq	= stex_ss_alloc_req,
+		.map_sg		= stex_ss_map_sg,
+		.send		= stex_ss_send_cmd,
+	},
 };
 
 static int stex_set_dma_mask(struct pci_dev * pdev)
-- 
1.9.1
