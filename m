From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] seagate iomem annotations, cleanup and isa_-ectomy
Date: Sun, 28 Nov 2004 14:16:52 +0000
Message-ID: <20041128141652.GG26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11664 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261478AbUK1OQz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2004 09:16:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	* switched to ioremap()
	* switched to normal iomem operations
	* killed a bunch of phys_to_virt()
	* killed open-coded (and inferior) instances of memcpy_toio()/
memcpy_fromio().
	* fixed a dumb typo introduced in "kill off isa_check_signature()"
patch (sorry - missed the fact that it was not covered by allmodconfig
and didn't verify until after sending the patch in question ;-/).
	
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC10-rc2-bk9-dtc/drivers/scsi/seagate.c RC10-rc2-bk9-seagate/drivers/scsi/seagate.c
--- RC10-rc2-bk9-dtc/drivers/scsi/seagate.c	Sun Nov 28 01:47:38 2004
+++ RC10-rc2-bk9-seagate/drivers/scsi/seagate.c	Sun Nov 28 02:30:40 2004
@@ -237,13 +237,13 @@
 					   calculate memory mapped register
 					   location.  */
 
-static unsigned long st0x_cr_sr;	/* control register write, status
+static void __iomem *st0x_cr_sr;	/* control register write, status
 					   register read.  256 bytes in
 					   length.
 					   Read is status of SCSI BUS, as per 
 					   STAT masks.  */
 
-static unsigned long st0x_dr;	/* data register, read write 256
+static void __iomem *st0x_dr;	/* data register, read write 256
 				   bytes in length.  */
 
 static volatile int st0x_aborted = 0;	/* set when we are aborted, ie by a
@@ -261,10 +261,10 @@
 
 
 #define retcode(result) (((result) << 16) | (message << 8) | status)
-#define STATUS ((u8) isa_readb(st0x_cr_sr))
-#define DATA ((u8) isa_readb(st0x_dr))
-#define WRITE_CONTROL(d) { isa_writeb((d), st0x_cr_sr); }
-#define WRITE_DATA(d) { isa_writeb((d), st0x_dr); }
+#define STATUS ((u8) readb(st0x_cr_sr))
+#define DATA ((u8) readb(st0x_dr))
+#define WRITE_CONTROL(d) { writeb((d), st0x_cr_sr); }
+#define WRITE_DATA(d) { writeb((d), st0x_dr); }
 
 #ifndef OVERRIDE
 static unsigned int seagate_bases[] = {
@@ -420,6 +420,7 @@
 {
 	struct Scsi_Host *instance;
 	int i, j;
+	unsigned long cr, dr;
 
 	tpnt->proc_name = "seagate";
 /*
@@ -455,7 +456,7 @@
  */
 
 		for (i = 0; i < (sizeof (seagate_bases) / sizeof (unsigned int)); ++i) {
-			void __iomem *p = ioremap(seagate_base[i], 0x2000);
+			void __iomem *p = ioremap(seagate_bases[i], 0x2000);
 			if (!p)
 				continue;
 			for (j = 0; j < NUM_SIGNATURES; ++j)
@@ -477,11 +478,13 @@
 		return 0;
 	}
 
-	st0x_cr_sr = base_address + (controller_type == SEAGATE ? 0x1a00 : 0x1c00);
-	st0x_dr = st0x_cr_sr + 0x200;
+	cr = base_address + (controller_type == SEAGATE ? 0x1a00 : 0x1c00);
+	dr = cr + 0x200;
+	st0x_cr_sr = ioremap(cr, 0x100);
+	st0x_dr = ioremap(dr, 0x100);
 
 	DANY("%s detected. Base address = %x, cr = %x, dr = %x\n",
-	      tpnt->name, base_address, st0x_cr_sr, st0x_dr);
+	      tpnt->name, base_address, cr, dr);
 
 	/*
 	 *	At all times, we will use IRQ 5.  Should also check for IRQ3
@@ -1146,7 +1149,7 @@
 #endif
 						 "loop 1b;"
 				      /* output */ :
-				      /* input */ :"D" (phys_to_virt (st0x_dr)),
+				      /* input */ :"D" (st0x_dr),
 						 "S"
 						 (data),
 						 "c" (SCint->transfersize)
@@ -1154,19 +1157,7 @@
 				      :	 "eax", "ecx",
 						 "esi");
 #else				/* SEAGATE_USE_ASM */
-					{
-#ifdef FAST32
-						unsigned int *iop = phys_to_virt (st0x_dr);
-						const unsigned int *dp =(unsigned int *) data;
-						int xferlen = transfersize >> 2;
-#else
-						unsigned char *iop = phys_to_virt (st0x_dr);
-						const unsigned char *dp = data;
-						int xferlen = transfersize;
-#endif
-						for (; xferlen; --xferlen)
-							*iop = *dp++;
-					}
+					memcpy_toio(st0x_dr, data, transfersize);
 #endif				/* SEAGATE_USE_ASM */
 /* SJT: End */
 					len -= transfersize;
@@ -1218,10 +1209,8 @@
 							"=D" (__dummy_2)
 /* input */
 				      :		"0" (data), "1" (len),
-							"2" (phys_to_virt
-							     (st0x_cr_sr)),
-							"3" (phys_to_virt
-							     (st0x_dr))
+							"2" (st0x_cr_sr),
+							"3" (st0x_dr)
 /* clobbered */
 				      :		"eax");
 #else				/* SEAGATE_USE_ASM */
@@ -1298,7 +1287,7 @@
 #endif
 						 "loop 1b\n\t"
 				      /* output */ :
-				      /* input */ :"S" (phys_to_virt (st0x_dr)),
+				      /* input */ :"S" (st0x_dr),
 						 "D"
 						 (data),
 						 "c" (SCint->transfersize)
@@ -1306,22 +1295,7 @@
 				      :	 "eax", "ecx",
 						 "edi");
 #else				/* SEAGATE_USE_ASM */
-					{
-#ifdef FAST32
-						const unsigned int *iop =
-						    phys_to_virt (st0x_dr);
-						unsigned int *dp =
-						    (unsigned int *) data;
-						int xferlen = len >> 2;
-#else
-						const unsigned char *iop =
-						    phys_to_virt (st0x_dr);
-						unsigned char *dp = data;
-						int xferlen = len;
-#endif
-						for (; xferlen; --xferlen)
-							*dp++ = *iop;
-					}
+					memcpy_fromio(data, st0x_dr, len);
 #endif				/* SEAGATE_USE_ASM */
 /* SJT: End */
 					len -= transfersize;
@@ -1387,10 +1361,8 @@
 							"=b" (__dummy_4)
 /* input */
 				      :		"0" (data), "1" (len),
-							"2" (phys_to_virt
-							     (st0x_cr_sr)),
-							"3" (phys_to_virt
-							     (st0x_dr))
+							"2" (st0x_cr_sr),
+							"3" (st0x_dr)
 /* clobbered */
 				      :		"eax");
 #else				/* SEAGATE_USE_ASM */
