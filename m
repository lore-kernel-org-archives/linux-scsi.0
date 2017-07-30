From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 13/29] scsi: fdomain: constify pci_device_id.
Date: Sun, 30 Jul 2017 14:10:29 +0530
Message-ID: <1501404036-9005-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501404036-9005-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/scsi/fdomain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index b87ab38..d46cbe8 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1770,7 +1770,7 @@ struct scsi_host_template fdomain_driver_template = {
 #ifndef PCMCIA
 #if defined(CONFIG_PCI) && defined(MODULE)
 
-static struct pci_device_id fdomain_pci_tbl[] = {
+static const struct pci_device_id fdomain_pci_tbl[] = {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ }
-- 
2.7.4
