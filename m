From: "Saxena, Sumit" <Sumit.Saxena@lsi.com>
Subject: RE: [PATCH] megaraid: Use resource_size_t for PCI resources, not
 long
Date: Fri, 13 Sep 2013 22:40:08 +0530
Message-ID: <088E451FE1854947BD9145EF8C016FF413A01F373F@inbmail01.lsi.com>
References: <D74A8430-BF73-488F-8CD1-0E00B5FE75A6@servergy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:25971
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab3IMRKT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Sep 2013 13:10:19 -0400
In-Reply-To: <D74A8430-BF73-488F-8CD1-0E00B5FE75A6@servergy.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <ben.c@servergy.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>



>-----Original Message-----
>From: Ben Collins [mailto:ben.c@servergy.com]
>Sent: Friday, September 13, 2013 10:17 PM
>To: linux-scsi
>Cc: Saxena, Sumit; DL-MegaRAID Linux
>Subject: [PATCH] megaraid: Use resource_size_t for PCI resources, not
>long
>
>The assumption that sizeof(long) >= sizeof(resource_size_t) can lead to
>truncation of the PCI resource address, meaning this driver didn't work
>on 32-bit systems with 64-bit PCI adressing ranges.
>
>Signed-off-by: Ben Collins <ben.c@servergy.com>
>Cc: Sumit Saxena <Sumit.Saxena@lsi.com>
>Cc: DL-MegaRAID Linux <megaraidlinux@lsi.com>
>---
> drivers/scsi/megaraid/megaraid_sas.h      | 1 -
> drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
> 2 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>b/drivers/scsi/megaraid/megaraid_sas.h
>index 04a42a5..2f58758 100644
>--- a/drivers/scsi/megaraid/megaraid_sas.h
>+++ b/drivers/scsi/megaraid/megaraid_sas.h
>@@ -1460,7 +1460,6 @@ struct megasas_instance {
> 	u32 *reply_queue;
> 	dma_addr_t reply_queue_h;
>
>-	unsigned long base_addr;
> 	struct megasas_register_set __iomem *reg_set;
> 	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
> 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 1f0ca68..5df5522 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -3498,6 +3498,7 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	u32 max_sectors_1;
> 	u32 max_sectors_2;
> 	u32 tmp_sectors, msix_enable, scratch_pad_2;
>+	resource_size_t base_addr;
> 	struct megasas_register_set __iomem *reg_set;
> 	struct megasas_ctrl_info *ctrl_info;
> 	unsigned long bar_list;
>@@ -3506,14 +3507,14 @@ static int megasas_init_fw(struct
>megasas_instance *instance)
> 	/* Find first memory bar */
> 	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
> 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
>-	instance->base_addr = pci_resource_start(instance->pdev, instance-
>>bar);
> 	if (pci_request_selected_regions(instance->pdev, instance->bar,
> 					 "megasas: LSI")) {
> 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
> 		return -EBUSY;
> 	}
>
>-	instance->reg_set = ioremap_nocache(instance->base_addr, 8192);
>+	base_addr = pci_resource_start(instance->pdev, instance->bar);
>+	instance->reg_set = ioremap_nocache(base_addr, 8192);
>
> 	if (!instance->reg_set) {
> 		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");
>--
>1.8.3.2
>
>
>--
>Ben Collins - Principal Architect
>Servergy, Inc. - www.servergy.com

Acked-by: Sumit Saxena <sumit.saxena@lsi.com>


