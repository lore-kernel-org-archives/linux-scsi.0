From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 2/6] fusion: print lan address via %pMR
Date: Sat, 22 Oct 2016 20:32:27 +0300
Message-ID: <20161022173231.170417-3-andriy.shevchenko@linux.intel.com>
References: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47736 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965001AbcJVRcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Oct 2016 13:32:36 -0400
In-Reply-To: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>

LAN MAC addresses can be printed directly using %pMR specifier.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/message/fusion/mptbase.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 89c7ed1..f82745c 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2585,10 +2585,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 				(void) GetLanConfigPages(ioc);
 				a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
 				dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
-					"LanAddr = %02X:%02X:%02X"
-					":%02X:%02X:%02X\n",
-					ioc->name, a[5], a[4],
-					a[3], a[2], a[1], a[0]));
+					"LanAddr = %pMR\n", ioc->name, a));
 			}
 			break;
 
@@ -6783,8 +6780,7 @@ static int mpt_iocinfo_proc_show(struct seq_file *m, void *v)
 		if (ioc->bus_type == FC) {
 			if (ioc->pfacts[p].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) {
 				u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-				seq_printf(m, "    LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
-						a[5], a[4], a[3], a[2], a[1], a[0]);
+				seq_printf(m, "    LanAddr = %pMR\n", a);
 			}
 			seq_printf(m, "    WWN = %08X%08X:%08X%08X\n",
 					ioc->fc_port_page0[p].WWNN.High,
@@ -6861,8 +6857,7 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
 
 	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
 		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-		y += sprintf(buffer+len+y, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
-			a[5], a[4], a[3], a[2], a[1], a[0]);
+		y += sprintf(buffer+len+y, ", LanAddr=%pMR", a);
 	}
 
 	y += sprintf(buffer+len+y, ", IRQ=%d", ioc->pci_irq);
@@ -6896,8 +6891,7 @@ static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int
 
 	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
 		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
-			a[5], a[4], a[3], a[2], a[1], a[0]);
+		seq_printf(m, ", LanAddr=%pMR", a);
 	}
 
 	seq_printf(m, ", IRQ=%d", ioc->pci_irq);
-- 
2.9.3

