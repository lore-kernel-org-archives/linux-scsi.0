From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: [PATCH] Fix qla4xxx build on 32-bit platforms
Date: Wed, 5 Jan 2011 09:14:05 -0500
Message-ID: <20110105141404.GD2364@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:39452 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1AEOPS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2011 09:15:18 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p05E5O4k028185
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jan 2011 07:05:24 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p05EFDMT047538
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jan 2011 07:15:13 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p05EFCYv029532
	for <linux-scsi@vger.kernel.org>; Wed, 5 Jan 2011 07:15:13 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com
Cc: Adrian Reber <adrian@lisas.de>, linux-scsi@vger.kernel.org

The qla4xxx driver uses readq/writeq unconditionally.  However, those
functions are only defined in include/asm-generic/io.h when CONFIG_64BIT
is set.  This leads to compile errors on 32-bit platforms such as ppc:

drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_read_direct':
drivers/scsi/qla4xxx/ql4_nx.c:717: error: implicit declaration of function 'readq'
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_write_direct':
drivers/scsi/qla4xxx/ql4_nx.c:788: error: implicit declaration of function 'writeq'

Guard their use in the driver with the same #ifdef.

Reported-by: Adrian Reber <adrian@lisas.de>
Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 474b10d..792c3ae 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -713,9 +713,11 @@ static int qla4_8xxx_pci_mem_read_direct(struct scsi_qla_host *ha,
 	case 4:
 		*(u32 *)data = readl(addr);
 		break;
+#ifdef CONFIG_64BIT
 	case 8:
 		*(u64 *)data = readq(addr);
 		break;
+#endif
 	default:
 		ret = -1;
 		break;
@@ -784,9 +786,11 @@ qla4_8xxx_pci_mem_write_direct(struct scsi_qla_host *ha, u64 off,
 	case 4:
 		writel(*(u32 *)data, addr);
 		break;
+#ifdef CONFIG_64BIT
 	case 8:
 		writeq(*(u64 *)data, addr);
 		break;
+#endif
 	default:
 		ret = -1;
 		break;
