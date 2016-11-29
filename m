From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: hisi_sas: shift vs compare typos
Date: Tue, 29 Nov 2016 13:47:25 +0300
Message-ID: <20161129104725.GA7623@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There are some typos where we intended "<<" but have "<".  Seems likely
to cause a bunch of problems.

Fixes: d3b688d3c69d ("scsi: hisi_sas: add v2 hw support for ECC and AXI bus fatal error")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
There is another static checker warning to fix perhaps:

	drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:2015 phy_up_v2_hw()
	warn: was expecting a 64 bit value instead of '(2 | 1)'

The code is doing:

	phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);

phy->phy_type is a u64 and PORT_TYPE_SAS is "1U << 1".  So this code
is clearing out the high 32 bits of ->phy_type uninitentionally.  It's
simple enough to make it 1ULL << 1 but the question is, do we really
need ->phy_type to be a 64 bit variable?  I'm pretty sure that a u32
will suffice.

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 15487f2..93876c0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -64,19 +64,19 @@
 					 HGC_LM_DFX_STATUS2_ITCTLIST_OFF)
 #define HGC_CQE_ECC_ADDR		0x13c
 #define HGC_CQE_ECC_1B_ADDR_OFF	0
-#define HGC_CQE_ECC_1B_ADDR_MSK	(0x3f < HGC_CQE_ECC_1B_ADDR_OFF)
+#define HGC_CQE_ECC_1B_ADDR_MSK	(0x3f << HGC_CQE_ECC_1B_ADDR_OFF)
 #define HGC_CQE_ECC_MB_ADDR_OFF	8
-#define HGC_CQE_ECC_MB_ADDR_MSK (0x3f < HGC_CQE_ECC_MB_ADDR_OFF)
+#define HGC_CQE_ECC_MB_ADDR_MSK (0x3f << HGC_CQE_ECC_MB_ADDR_OFF)
 #define HGC_IOST_ECC_ADDR		0x140
 #define HGC_IOST_ECC_1B_ADDR_OFF	0
-#define HGC_IOST_ECC_1B_ADDR_MSK	(0x3ff < HGC_IOST_ECC_1B_ADDR_OFF)
+#define HGC_IOST_ECC_1B_ADDR_MSK	(0x3ff << HGC_IOST_ECC_1B_ADDR_OFF)
 #define HGC_IOST_ECC_MB_ADDR_OFF	16
-#define HGC_IOST_ECC_MB_ADDR_MSK	(0x3ff < HGC_IOST_ECC_MB_ADDR_OFF)
+#define HGC_IOST_ECC_MB_ADDR_MSK	(0x3ff << HGC_IOST_ECC_MB_ADDR_OFF)
 #define HGC_DQE_ECC_ADDR		0x144
 #define HGC_DQE_ECC_1B_ADDR_OFF	0
-#define HGC_DQE_ECC_1B_ADDR_MSK	(0xfff < HGC_DQE_ECC_1B_ADDR_OFF)
+#define HGC_DQE_ECC_1B_ADDR_MSK	(0xfff << HGC_DQE_ECC_1B_ADDR_OFF)
 #define HGC_DQE_ECC_MB_ADDR_OFF	16
-#define HGC_DQE_ECC_MB_ADDR_MSK (0xfff < HGC_DQE_ECC_MB_ADDR_OFF)
+#define HGC_DQE_ECC_MB_ADDR_MSK (0xfff << HGC_DQE_ECC_MB_ADDR_OFF)
 #define HGC_INVLD_DQE_INFO		0x148
 #define HGC_INVLD_DQE_INFO_FB_CH0_OFF	9
 #define HGC_INVLD_DQE_INFO_FB_CH0_MSK	(0x1 << HGC_INVLD_DQE_INFO_FB_CH0_OFF)
