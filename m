From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 12/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:13:56 +0900 (JST)
Message-ID: <20050222.161356.08385274.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:55310 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262236AbVBVHN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:13:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/pcmcia/nsp_io.h	2004-10-19 06:55:36.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/pcmcia/nsp_io.h	2004-07-27 00:24:21.000000000 +0900
@@ -1,40 +1,39 @@
-/*
+/***********************************************************************
   NinjaSCSI I/O funtions 
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+      By: YOKOTA Hiroshi <yokota (at) netlab (dot) is (dot) tsukuba (dot) ac (dot) jp>
  
   This software may be used and distributed according to the terms of
   the GNU General Public License.
+************************************************************************/
 
-  */
-
-/* $Id: nsp_io.h,v 1.3 2003/08/04 21:15:26 elca Exp $ */
+/* $Id: nsp_io.h,v 1.5 2004/07/26 15:24:21 elca Exp $ */
 
 #ifndef __NSP_IO_H__
 #define __NSP_IO_H__
 
-static inline          void nsp_write(unsigned int base,
+inline static          void nsp_write(unsigned int base,
 				      unsigned int index,
 				      unsigned char val);
-static inline unsigned char nsp_read(unsigned int base,
+inline static unsigned char nsp_read(unsigned int base,
 				     unsigned int index);
-static inline          void nsp_index_write(unsigned int BaseAddr,
+inline static          void nsp_index_write(unsigned int BaseAddr,
 					    unsigned int Register,
 					    unsigned char Value);
-static inline unsigned char nsp_index_read(unsigned int BaseAddr,
+inline static unsigned char nsp_index_read(unsigned int BaseAddr,
 					   unsigned int Register);
 
 /*******************************************************************
  * Basic IO
  */
 
-static inline void nsp_write(unsigned int  base,
+inline static void nsp_write(unsigned int  base,
 			     unsigned int  index,
 			     unsigned char val)
 {
 	outb(val, (base + index));
 }
 
-static inline unsigned char nsp_read(unsigned int base,
+inline static unsigned char nsp_read(unsigned int base,
 				     unsigned int index)
 {
 	return inb(base + index);
@@ -44,14 +43,14 @@
 /**********************************************************************
  * Indexed IO
  */
-static inline unsigned char nsp_index_read(unsigned int BaseAddr,
+inline static unsigned char nsp_index_read(unsigned int BaseAddr,
 					   unsigned int Register)
 {
 	outb(Register, BaseAddr + INDEXREG);
 	return inb(BaseAddr + DATAREG);
 }
 
-static inline void nsp_index_write(unsigned int  BaseAddr,
+inline static void nsp_index_write(unsigned int  BaseAddr,
 				   unsigned int  Register,
 				   unsigned char Value)
 {
@@ -64,7 +63,7 @@
  */
 
 /* read 8 bit FIFO */
-static inline void nsp_multi_read_1(unsigned int   BaseAddr,
+inline static void nsp_multi_read_1(unsigned int   BaseAddr,
 				    unsigned int   Register,
 				    void          *buf,
 				    unsigned long  count)
@@ -72,7 +71,7 @@
 	insb(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo8_read(unsigned int   base,
+inline static void nsp_fifo8_read(unsigned int   base,
 				  void          *buf,
 				  unsigned long  count)
 {
@@ -83,7 +82,7 @@
 /*--------------------------------------------------------------*/
 
 /* read 16 bit FIFO */
-static inline void nsp_multi_read_2(unsigned int   BaseAddr,
+inline static void nsp_multi_read_2(unsigned int   BaseAddr,
 				    unsigned int   Register,
 				    void          *buf,
 				    unsigned long  count)
@@ -91,7 +90,7 @@
 	insw(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo16_read(unsigned int   base,
+inline static void nsp_fifo16_read(unsigned int   base,
 				   void          *buf,
 				   unsigned long  count)
 {
@@ -102,7 +101,7 @@
 /*--------------------------------------------------------------*/
 
 /* read 32bit FIFO */
-static inline void nsp_multi_read_4(unsigned int   BaseAddr,
+inline static void nsp_multi_read_4(unsigned int   BaseAddr,
 				    unsigned int   Register,
 				    void          *buf,
 				    unsigned long  count)
@@ -110,7 +109,7 @@
 	insl(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo32_read(unsigned int   base,
+inline static void nsp_fifo32_read(unsigned int   base,
 				   void          *buf,
 				   unsigned long  count)
 {
@@ -121,7 +120,7 @@
 /*----------------------------------------------------------*/
 
 /* write 8bit FIFO */
-static inline void nsp_multi_write_1(unsigned int   BaseAddr,
+inline static void nsp_multi_write_1(unsigned int   BaseAddr,
 				     unsigned int   Register,
 				     void          *buf,
 				     unsigned long  count)
@@ -129,7 +128,7 @@
 	outsb(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo8_write(unsigned int   base,
+inline static void nsp_fifo8_write(unsigned int   base,
 				   void          *buf,
 				   unsigned long  count)
 {
@@ -139,7 +138,7 @@
 /*---------------------------------------------------------*/
 
 /* write 16bit FIFO */
-static inline void nsp_multi_write_2(unsigned int   BaseAddr,
+inline static void nsp_multi_write_2(unsigned int   BaseAddr,
 				     unsigned int   Register,
 				     void          *buf,
 				     unsigned long  count)
@@ -147,7 +146,7 @@
 	outsw(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo16_write(unsigned int   base,
+inline static void nsp_fifo16_write(unsigned int   base,
 				    void          *buf,
 				    unsigned long  count)
 {
@@ -157,7 +156,7 @@
 /*---------------------------------------------------------*/
 
 /* write 32bit FIFO */
-static inline void nsp_multi_write_4(unsigned int   BaseAddr,
+inline static void nsp_multi_write_4(unsigned int   BaseAddr,
 				     unsigned int   Register,
 				     void          *buf,
 				     unsigned long  count)
@@ -165,7 +164,7 @@
 	outsl(BaseAddr + Register, buf, count);
 }
 
-static inline void nsp_fifo32_write(unsigned int   base,
+inline static void nsp_fifo32_write(unsigned int   base,
 				    void          *buf,
 				    unsigned long  count)
 {
@@ -175,7 +174,7 @@
 
 /*====================================================================*/
 
-static inline void nsp_mmio_write(unsigned long base,
+inline static void nsp_mmio_write(unsigned long base,
 				  unsigned int  index,
 				  unsigned char val)
 {
@@ -184,7 +183,7 @@
 	writeb(val, ptr);
 }
 
-static inline unsigned char nsp_mmio_read(unsigned long base,
+inline static unsigned char nsp_mmio_read(unsigned long base,
 					  unsigned int  index)
 {
 	unsigned char *ptr = (unsigned char *)(base + NSP_MMIO_OFFSET + index);
@@ -194,7 +193,7 @@
 
 /*-----------*/
 
-static inline unsigned char nsp_mmio_index_read(unsigned long base,
+inline static unsigned char nsp_mmio_index_read(unsigned long base,
 						unsigned int  reg)
 {
 	unsigned char *index_ptr = (unsigned char *)(base + NSP_MMIO_OFFSET + INDEXREG);
@@ -204,7 +203,7 @@
 	return readb(data_ptr);
 }
 
-static inline void nsp_mmio_index_write(unsigned long base,
+inline static void nsp_mmio_index_write(unsigned long base,
 					unsigned int  reg,
 					unsigned char val)
 {
@@ -216,7 +215,7 @@
 }
 
 /* read 32bit FIFO */
-static inline void nsp_mmio_multi_read_4(unsigned long  base,
+inline static void nsp_mmio_multi_read_4(unsigned long  base,
 					 unsigned int   Register,
 					 void          *buf,
 					 unsigned long  count)
@@ -234,7 +233,7 @@
 	}
 }
 
-static inline void nsp_mmio_fifo32_read(unsigned int   base,
+inline static void nsp_mmio_fifo32_read(unsigned int   base,
 					void          *buf,
 					unsigned long  count)
 {
@@ -242,7 +241,7 @@
 	nsp_mmio_multi_read_4(base, FIFODATA, buf, count);
 }
 
-static inline void nsp_mmio_multi_write_4(unsigned long  base,
+inline static void nsp_mmio_multi_write_4(unsigned long  base,
 					  unsigned int   Register,
 					  void          *buf,
 					  unsigned long  count)
@@ -260,7 +259,7 @@
 	}
 }
 
-static inline void nsp_mmio_fifo32_write(unsigned int   base,
+inline static void nsp_mmio_fifo32_write(unsigned int   base,
 					 void          *buf,
 					 unsigned long  count)
 {
