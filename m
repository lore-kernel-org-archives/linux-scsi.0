From: Ayman Elkhashab <aymane@elkhashab.com>
Subject: [PATCH 1/1] mpt2sas:  Fixes so driver works on 32 bit powerpc with > 32 bit pci space
Date: Wed, 13 Jul 2011 15:04:50 -0500
Message-ID: <1310587490-31821-1-git-send-email-aymane__48279.1814524264$1310587850$gmane$org@elkhashab.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tanisys.com ([207.114.241.63]:3696 "EHLO
	tanisys-ex2.Tanisys.Local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751019Ab1GMUKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2011 16:10:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Kashyap Desai <kashyap.desai@lsi.com>, Greg Kroah-Hartman <gregkh@suse.de>, Eric Moore <eric.moore@lsi.com>, Nick Cheng <nick.cheng@>
Cc: Ayman El-Khashab <ayman@elkhashab.com>

From: Ayman El-Khashab <ayman@elkhashab.com>

Changed the type of chip_phys from a u64 to a phys_addr_t.  Changed ifdef
from BITS_PER_LONG to CONFIG_ARCH_DMA_ADDR_T_64BIT so that it works on
32 bit systems that have pci address spaces larger than 32 bits.

Tested on powerpc 44x with 36 bit pci space

Signed-off-by: Ayman El-Khashab <ayman@elkhashab.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    4 ++--
 drivers/scsi/mpt2sas/mpt2sas_base.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index efa0255..e5bbd0c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1251,7 +1251,7 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
 	u32 pio_sz;
 	int i, r = 0;
 	u64 pio_chip = 0;
-	u64 chip_phys = 0;
+	phys_addr_t chip_phys = 0;
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n",
 	    ioc->name, __func__));
@@ -3243,7 +3243,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request.ReplyFreeQueueDepth =
 	    cpu_to_le16(ioc->reply_free_queue_depth);
 
-#if BITS_PER_LONG > 32
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
 	mpi_request.SenseBufferAddressHigh =
 	    cpu_to_le32(ioc->sense_dma >> 32);
 	mpi_request.SystemReplyAddressHigh =
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index dcc289c..d5f9ed8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -682,7 +682,7 @@ struct MPT2SAS_ADAPTER {
 	char		tmp_string[MPT_STRING_LENGTH];
 	struct pci_dev	*pdev;
 	Mpi2SystemInterfaceRegs_t __iomem *chip;
-	resource_size_t	chip_phys;
+	phys_addr_t	chip_phys;
 	int		logging_level;
 	int		fwfault_debug;
 	u8		ir_firmware;
-- 
1.7.4.3

