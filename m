From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/4] fusion: print lan address via %pMR
Date: Fri,  6 May 2016 19:23:58 +0300
Message-ID: <1462551839-44380-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbcEFQYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 12:24:04 -0400
In-Reply-To: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Sathya Prakash <sathya.prakash@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com

LAN MAC addresses can be printed directly using %pMR specifier.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/message/fusion/mptbase.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5537f8d..3af67e6 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2584,10 +2584,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
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
 
@@ -6782,8 +6779,7 @@ static int mpt_iocinfo_proc_show(struct seq_file *m, void *v)
 		if (ioc->bus_type == FC) {
 			if (ioc->pfacts[p].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN) {
 				u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-				seq_printf(m, "    LanAddr = %02X:%02X:%02X:%02X:%02X:%02X\n",
-						a[5], a[4], a[3], a[2], a[1], a[0]);
+				seq_printf(m, "    LanAddr = %pMR\n", a);
 			}
 			seq_printf(m, "    WWN = %08X%08X:%08X%08X\n",
 					ioc->fc_port_page0[p].WWNN.High,
@@ -6860,8 +6856,7 @@ mpt_print_ioc_summary(MPT_ADAPTER *ioc, char *buffer, int *size, int len, int sh
 
 	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
 		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-		y += sprintf(buffer+len+y, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
-			a[5], a[4], a[3], a[2], a[1], a[0]);
+		y += sprintf(buffer+len+y, ", LanAddr=%pMR", a);
 	}
 
 	y += sprintf(buffer+len+y, ", IRQ=%d", ioc->pci_irq);
@@ -6895,8 +6890,7 @@ static void seq_mpt_print_ioc_summary(MPT_ADAPTER *ioc, struct seq_file *m, int
 
 	if (showlan && (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_LAN)) {
 		u8 *a = (u8*)&ioc->lan_cnfg_page1.HardwareAddressLow;
-		seq_printf(m, ", LanAddr=%02X:%02X:%02X:%02X:%02X:%02X",
-			a[5], a[4], a[3], a[2], a[1], a[0]);
+		seq_printf(m, ", LanAddr=%pMR", a);
 	}
 
 	seq_printf(m, ", IRQ=%d", ioc->pci_irq);
-- 
2.8.1

