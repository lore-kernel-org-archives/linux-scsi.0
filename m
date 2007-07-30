From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 16/23] advansys: delete AscGetChipBusType
Date: Mon, 30 Jul 2007 10:57:01 -0600
Message-ID: <11858146282891-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx> <1185814628978-git-send-email-matthew@wil.cx> <11858146282602-git-send-email-matthew@wil.cx> <11858146283106-git-send-email-matthew@wil.cx> <11858146282252-git-send-email-matthew@wil.cx> <11858146281790-git-send-email-matthew@wil.cx> <11858146281215-git-send-email-matthew@wil.cx> <11858146282469-git-send-email-matthew@wil.cx> <11858146281137-git-send-email-matthew@wil.cx> <11858146282332-git-send-email-matthew@wil.cx> <11858146283924-git-send-email-matthew@wil.cx> <1185814628436-git-send-email-matthew@wil.cx> <11858146281677-git-send-email-matthew@wil.cx> <11858146282603-git-send-email-matthew@wil.cx> <11858146281750-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43706 "EHLO
	smtp-04.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937188AbXG3Q5M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:12 -0400
In-Reply-To: <11858146281750-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

By moving a test from AscGetChipBusType into its only caller, we can delete
the whole function

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   36 ++++--------------------------------
 1 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index dc9dca3..e661986 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8001,34 +8001,6 @@ AscGetChipVersion(PortAddr iop_base, unsigned short bus_type)
 	return AscGetChipVerNo(iop_base);
 }
 
-static ushort __devinit AscGetChipBusType(PortAddr iop_base)
-{
-	ushort chip_ver;
-
-	chip_ver = AscGetChipVerNo(iop_base);
-	if ((chip_ver >= ASC_CHIP_MIN_VER_VL)
-	    && (chip_ver <= ASC_CHIP_MAX_VER_VL)
-	    ) {
-		if (((iop_base & 0x0C30) == 0x0C30)
-		    || ((iop_base & 0x0C50) == 0x0C50)
-		    ) {
-			return (ASC_IS_EISA);
-		}
-		return (ASC_IS_VL);
-	}
-	if ((chip_ver >= ASC_CHIP_MIN_VER_ISA) &&
-	    (chip_ver <= ASC_CHIP_MAX_VER_ISA)) {
-		if (chip_ver >= ASC_CHIP_MIN_VER_ISA_PNP) {
-			return (ASC_IS_ISAPNP);
-		}
-		return (ASC_IS_ISA);
-	} else if ((chip_ver >= ASC_CHIP_MIN_VER_PCI) &&
-		   (chip_ver <= ASC_CHIP_MAX_VER_PCI)) {
-		return (ASC_IS_PCI);
-	}
-	return (0);
-}
-
 static ASC_DCNT
 AscLoadMicroCode(PortAddr iop_base,
 		 ushort s_addr, uchar *mcode_buf, ushort mcode_size)
@@ -10468,12 +10440,12 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	}
 
 	asc_dvc->cfg->isa_dma_speed = ASC_DEF_ISA_DMA_SPEED;
-	if (AscGetChipBusType(iop_base) == ASC_IS_ISAPNP) {
-		AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
-		asc_dvc->bus_type = ASC_IS_ISAPNP;
-	}
 #ifdef CONFIG_ISA
 	if ((asc_dvc->bus_type & ASC_IS_ISA) != 0) {
+		if (chip_version >= ASC_CHIP_MIN_VER_ISA_PNP) {
+			AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
+			asc_dvc->bus_type = ASC_IS_ISAPNP;
+		}
 		asc_dvc->cfg->isa_dma_channel =
 		    (uchar)AscGetIsaDmaChannel(iop_base);
 	}
-- 
1.4.4.4

