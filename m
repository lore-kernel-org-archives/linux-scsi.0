From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] aic94xx: compile warning cleanups
Date: Mon, 17 Apr 2006 21:35:23 -0700
Message-ID: <20060418043523.GA32350@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:31417 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932205AbWDREfa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 00:35:30 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3I4ZTAe010416
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 00:35:29 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3I4ZUVb225400
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 00:35:30 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k3I4ZT3b009999
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 00:35:30 -0400
Received: from hmsbounty.us.ibm.com (sig-9-49-139-99.mts.ibm.com [9.49.139.99])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id k3I4ZSRb009801
	for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2006 00:35:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Compile warning cleanups when driver built with debug selected.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/aic94xx/aic94xx_dump.c |   15 +++++++++------
 drivers/scsi/aic94xx/aic94xx_scb.c  |   10 ++++++----
 drivers/scsi/aic94xx/aic94xx_seq.c  |    4 ++--
 drivers/scsi/sas/expander_conf.c    |    4 +---
 include/scsi/sas/sas.h              |    2 +-
 5 files changed, 19 insertions(+), 16 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_dump.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_dump.c	2006-04-14 16:23:51.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_dump.c	2006-04-17 11:31:24.000000000 -0700
@@ -216,7 +216,7 @@ static struct lseq_cio_regs LSEQmOOBREGS
 #define STR_8BIT   "   %30s[0x%04x]:0x%02x\n"
 #define STR_16BIT  "   %30s[0x%04x]:0x%04x\n"
 #define STR_32BIT  "   %30s[0x%04x]:0x%08x\n"
-#define STR_64BIT  "   %30s[0x%04x]:0x%016Lx\n"
+#define STR_64BIT  "   %30s[0x%04x]:0x%llx\n"
 
 #define PRINT_REG_8bit(_ha, _n, _r) asd_printk(STR_8BIT, #_n, _n,      \
 					     asd_read_reg_byte(_ha, _r))
@@ -253,7 +253,7 @@ static struct lseq_cio_regs LSEQmOOBREGS
                    asd_read_reg_dword(_ha, CSEQ_##_n))
 #define PRINT_MIS_qword(_ha, _n)                                       \
         asd_printk(STR_64BIT, #_n,CSEQ_##_n-CMAPPEDSCR,                \
-                   (u64)(((u64)asd_read_reg_dword(_ha, CSEQ_##_n))     \
+                   (unsigned long long)(((u64)asd_read_reg_dword(_ha, CSEQ_##_n))     \
                  | (((u64)asd_read_reg_dword(_ha, (CSEQ_##_n)+4))<<32)))
 
 #define CMDP_REG(_n, _m) (_m*(CSEQ_PAGE_SIZE*2)+CSEQ_##_n)
@@ -459,8 +459,10 @@ static void asd_dump_cseq_state(struct a
 		   asd_read_reg_dword(_h, LmSEQ_##_n(_lseq)))
 #define PRINT_LMIP_qword(_h, _lseq, _n)                                \
 	asd_printk(STR_64BIT, #_n, LmSEQ_##_n(_lseq)-LmSCRATCH(_lseq), \
-		   (u64)(((u64)asd_read_reg_dword(_h, LmSEQ_##_n(_lseq)))\
-	          | (((u64)asd_read_reg_dword(_h, LmSEQ_##_n(_lseq)+4))<<32)))
+		 (unsigned long long)(((unsigned long long) \
+		 asd_read_reg_dword(_h, LmSEQ_##_n(_lseq))) \
+	          | (((unsigned long long) \
+		 asd_read_reg_dword(_h, LmSEQ_##_n(_lseq)+4))<<32)))
 
 static void asd_print_lseq_cio_reg(struct asd_ha_struct *asd_ha,
 				   u32 lseq_cio_addr, int i)
@@ -925,10 +927,11 @@ void asd_dump_frame_rcvd(struct asd_phy 
 
 static inline void asd_dump_scb(struct asd_ascb *ascb, int ind)
 {
-	asd_printk("scb%d: vaddr: 0x%p, dma_handle: 0x%08llx, next: 0x%08llx, "
+	asd_printk("scb%d: vaddr: 0x%p, dma_handle: 0x%llx, next: 0x%llx, "
 		   "index:%d, opcode:0x%02x\n",
 		   ind, ascb->dma_scb.vaddr,
-		   (u64)ascb->dma_scb.dma_handle,
+		   (unsigned long long)ascb->dma_scb.dma_handle,
+		   (unsigned long long)
 		   le64_to_cpu(ascb->scb->header.next_scb),
 		   le16_to_cpu(ascb->scb->header.index),
 		   ascb->scb->header.opcode);
Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/expander_conf.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/expander_conf.c	2006-04-14 16:23:51.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/expander_conf.c	2006-04-14 16:32:46.000000000 -0700
@@ -50,6 +50,7 @@
 #include <byteswap.h>
 #include <stdint.h>
 #include <stdlib.h>
+#include <scsi/sas/sas.h>
 
 #define LEFT_FIELD_SIZE 25
 
@@ -69,9 +70,6 @@
 #define cpu_to_be16(_x)  (_x)
 #endif
 
-#define SAS_ADDR(_x) ((unsigned long long) be64_to_cpu(*(uint64_t *)(_x)))
-#define SAS_ADDR_SIZE 8
-
 const char *prog;
 
 struct route_table_entry {
Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas.h	2006-04-14 16:23:51.000000000 -0700
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas.h	2006-04-17 11:42:42.000000000 -0700
@@ -32,7 +32,7 @@
 
 #define SAS_ADDR_SIZE        8
 #define HASHED_SAS_ADDR_SIZE 3
-#define SAS_ADDR(_sa)   (be64_to_cpu(*(__be64 *)(_sa)))
+#define SAS_ADDR(_sa) ((unsigned long long) be64_to_cpu(*(__be64 *)(_sa)))
 
 enum sas_oob_mode {
 	OOB_NOT_CONNECTED,
Index: aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_scb.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_scb.c	2006-04-14 16:23:51.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_scb.c	2006-04-17 11:30:38.000000000 -0700
@@ -351,10 +351,11 @@ static void escb_tasklet_complete(struct
 		ASD_DPRINTK("sb_opcode : 0x%x, phy_id: 0x%x\n",
 			    sb_opcode, phy_id);
 		ASD_DPRINTK("escb: vaddr: 0x%p, "
-			    "dma_handle: 0x%08llx, next: 0x%08llx, "
+			    "dma_handle: 0x%llx, next: 0x%llx, "
 			    "index:%d, opcode:0x%02x\n",
 			    ascb->dma_scb.vaddr,
-			    (u64)ascb->dma_scb.dma_handle,
+			    (unsigned long long)ascb->dma_scb.dma_handle,
+			    (unsigned long long)
 			    le64_to_cpu(ascb->scb->header.next_scb),
 			    le16_to_cpu(ascb->scb->header.index),
 			    ascb->scb->header.opcode);
@@ -413,10 +414,11 @@ static void escb_tasklet_complete(struct
 		ASD_DPRINTK("sb_opcode : 0x%x, phy_id: 0x%x\n",
 			    sb_opcode, phy_id);
 		ASD_DPRINTK("escb: vaddr: 0x%p, "
-			    "dma_handle: 0x%08llx, next: 0x%08llx, "
+			    "dma_handle: 0x%llx, next: 0x%llx, "
 			    "index:%d, opcode:0x%02x\n",
 			    ascb->dma_scb.vaddr,
-			    (u64)ascb->dma_scb.dma_handle,
+			    (unsigned long long)ascb->dma_scb.dma_handle,
+			    (unsigned long long)
 			    le64_to_cpu(ascb->scb->header.next_scb),
 			    le16_to_cpu(ascb->scb->header.index),
 			    ascb->scb->header.opcode);
Index: aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_seq.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/aic94xx/aic94xx_seq.c	2006-04-14 16:23:51.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/aic94xx/aic94xx_seq.c	2006-04-17 11:27:31.000000000 -0700
@@ -582,8 +582,8 @@ static void asd_init_cseq_mdp(struct asd
 	/* Tell the sequencer the bus address of the first SCB. */
 	asd_write_reg_addr(asd_ha, CSEQ_HQ_NEW_POINTER,
 			   asd_ha->seq.next_scb.dma_handle);
-	ASD_DPRINTK("First SCB dma_handle: 0x%08llx\n",
-		    (u64)asd_ha->seq.next_scb.dma_handle);
+	ASD_DPRINTK("First SCB dma_handle: 0x%llx\n",
+		    (unsigned long long)asd_ha->seq.next_scb.dma_handle);
 
 	/* Tell the sequencer the first Done List entry address. */
 	asd_write_reg_addr(asd_ha, CSEQ_HQ_DONE_BASE,
