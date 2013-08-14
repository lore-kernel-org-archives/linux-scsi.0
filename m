From: Ben Collins <ben.c@servergy.com>
Subject: State of big-endian for MegaRAID SAS driver
Date: Wed, 14 Aug 2013 12:57:35 -0400
Message-ID: <658ABE5F-B2AA-4EC1-BC34-B4FD428C7A8E@servergy.com>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58969 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab3HNQ5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2013 12:57:38 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so2659853pab.20
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2013 09:57:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi folks,

Based on some searching, back when the megaraid_sas driver was first introduced in 2005, issues were raised with the lack of support for big-endian architectures[1]. In this conversation, it was said that LSI would revisit this later, and thus the driver was included without support for big-endian architectures. Here it is 8 years later, and I'm wondering if this will ever get resolved.

The platform in question is a 32-bit powerpc system. I've already fixed one issue with regard to inaccurate assumptions about pci resource sizes (attached). Basically, it is possible for 32-bit systems to support 64-bit PCI resources (as is the case on this system). I'll submit it properly at some point, or feel free to snip it off from here. I've already fixed the aacraid SRC support on this hardware (same resource size assumptions and big-endian fixes), and I'm hoping to do the same with megaraid_sas (at least as it pertains to the gen2 card).

I notice that LSI does support a Solaris/SPARCv9 driver for mr_sas, so I know that there is at least some base knowledge and working expertise on supporting big-endian. Any chance of the Solaris driver source being tossed out to get a look a what it will take to get the Linux driver in working order.

[1]: http://lkml.indiana.edu/hypermail/linux/kernel/0506.0/1525.html

megaraid_sas: Fix assumptions about PCI resource sizes

Signed-off-by: Ben Collins <ben.c@servergy.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 04a42a5..f509d14 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1460,7 +1460,6 @@ struct megasas_instance {
 	u32 *reply_queue;
 	dma_addr_t reply_queue_h;
 
-	unsigned long base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1f0ca68..5df5522 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3498,6 +3498,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	u32 max_sectors_1;
 	u32 max_sectors_2;
 	u32 tmp_sectors, msix_enable, scratch_pad_2;
+	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
@@ -3506,14 +3507,14 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Find first memory bar */
 	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
 	instance->bar = find_first_bit(&bar_list, sizeof(unsigned long));
-	instance->base_addr = pci_resource_start(instance->pdev, instance->bar);
 	if (pci_request_selected_regions(instance->pdev, instance->bar,
 					 "megasas: LSI")) {
 		printk(KERN_DEBUG "megasas: IO memory region busy!\n");
 		return -EBUSY;
 	}
 
-	instance->reg_set = ioremap_nocache(instance->base_addr, 8192);
+	base_addr = pci_resource_start(instance->pdev, instance->bar);
+	instance->reg_set = ioremap_nocache(base_addr, 8192);
 
 	if (!instance->reg_set) {
 		printk(KERN_DEBUG "megasas: Failed to map IO mem\n");


--
Ben Collins - Principal Architect
Servergy, Inc. - www.servergy.com

