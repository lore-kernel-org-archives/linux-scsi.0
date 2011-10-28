From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 1/4] drivers/firmware/edd: Treat "XPRS" host bus type the same
 as "PCI"
Date: Fri, 28 Oct 2011 11:34:07 -0700
Message-ID: <20111028183407.15165.37840.stgit@localhost6.localdomain6>
References: <20111028183305.15165.96974.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab1J1Sp3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2011 14:45:29 -0400
In-Reply-To: <20111028183305.15165.96974.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: robert.w.love@intel.com, Michael Chan <mchan@broadcom.com>, Yi Zou <yi.zou@intel.com>

From: Michael Chan <mchan@broadcom.com>

PCI Express devices will return "XPRS" host bus type during BIOS EDD
call.  "XPRS" should be treated just like "PCI" so that the proper
pci_dev symlink will be created.  Scripts such as fcoe_edd.sh will
then work correctly.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Reviewed-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/firmware/edd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index f1b7f65..e229576 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -151,7 +151,8 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 		p += scnprintf(p, left, "\tbase_address: %x\n",
 			     info->params.interface_path.isa.base_address);
 	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
-		   !strncmp(info->params.host_bus_type, "PCI", 3)) {
+		   !strncmp(info->params.host_bus_type, "PCI", 3) ||
+		   !strncmp(info->params.host_bus_type, "XPRS", 4)) {
 		p += scnprintf(p, left,
 			     "\t%02x:%02x.%d  channel: %u\n",
 			     info->params.interface_path.pci.bus,
@@ -159,7 +160,6 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
 			     info->params.interface_path.pci.function,
 			     info->params.interface_path.pci.channel);
 	} else if (!strncmp(info->params.host_bus_type, "IBND", 4) ||
-		   !strncmp(info->params.host_bus_type, "XPRS", 4) ||
 		   !strncmp(info->params.host_bus_type, "HTPT", 4)) {
 		p += scnprintf(p, left,
 			     "\tTBD: %llx\n",
@@ -668,7 +668,7 @@ edd_get_pci_dev(struct edd_device *edev)
 {
 	struct edd_info *info = edd_dev_get_info(edev);
 
-	if (edd_dev_is_type(edev, "PCI")) {
+	if (edd_dev_is_type(edev, "PCI") || edd_dev_is_type(edev, "XPRS")) {
 		return pci_get_bus_and_slot(info->params.interface_path.pci.bus,
 				     PCI_DEVFN(info->params.interface_path.pci.slot,
 					       info->params.interface_path.pci.

