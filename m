From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 8/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:09:18 +0900 (JST)
Message-ID: <20050222.160918.39222021.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:50190 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262230AbVBVHJU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:09:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/nsp32_io.h	2004-10-19 06:55:28.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/nsp32_io.h	2004-07-27 00:21:25.000000000 +0900
@@ -9,40 +9,40 @@
 #ifndef _NSP32_IO_H
 #define _NSP32_IO_H
 
-static inline void nsp32_write1(unsigned int  base,
+inline static void nsp32_write1(unsigned int  base,
 				unsigned int  index,
 				unsigned char val)
 {
 	outb(val, (base + index));
 }
 
-static inline unsigned char nsp32_read1(unsigned int base,
+inline static unsigned char nsp32_read1(unsigned int base,
 					unsigned int index)
 {
 	return inb(base + index);
 }
 
-static inline void nsp32_write2(unsigned int   base,
+inline static void nsp32_write2(unsigned int   base,
 				unsigned int   index,
 				unsigned short val)
 {
 	outw(val, (base + index));
 }
 
-static inline unsigned short nsp32_read2(unsigned int base,
+inline static unsigned short nsp32_read2(unsigned int base,
 					 unsigned int index)
 {
 	return inw(base + index);
 }
 
-static inline void nsp32_write4(unsigned int  base,
+inline static void nsp32_write4(unsigned int  base,
 				unsigned int  index,
 				unsigned long val)
 {
 	outl(val, (base + index));
 }
 
-static inline unsigned long nsp32_read4(unsigned int base,
+inline static unsigned long nsp32_read4(unsigned int base,
 					unsigned int index)
 {
 	return inl(base + index);
@@ -50,7 +50,7 @@
 
 /*==============================================*/
 
-static inline void nsp32_mmio_write1(unsigned long base,
+inline static void nsp32_mmio_write1(unsigned long base,
 				     unsigned int  index,
 				     unsigned char val)
 {
@@ -61,7 +61,7 @@
 	writeb(val, ptr);
 }
 
-static inline unsigned char nsp32_mmio_read1(unsigned long base,
+inline static unsigned char nsp32_mmio_read1(unsigned long base,
 					     unsigned int  index)
 {
 	volatile unsigned char *ptr;
@@ -71,7 +71,7 @@
 	return readb(ptr);
 }
 
-static inline void nsp32_mmio_write2(unsigned long  base,
+inline static void nsp32_mmio_write2(unsigned long  base,
 				     unsigned int   index,
 				     unsigned short val)
 {
@@ -82,7 +82,7 @@
 	writew(cpu_to_le16(val), ptr);
 }
 
-static inline unsigned short nsp32_mmio_read2(unsigned long base,
+inline static unsigned short nsp32_mmio_read2(unsigned long base,
 					      unsigned int  index)
 {
 	volatile unsigned short *ptr;
@@ -92,7 +92,7 @@
 	return le16_to_cpu(readw(ptr));
 }
 
-static inline void nsp32_mmio_write4(unsigned long base,
+inline static void nsp32_mmio_write4(unsigned long base,
 				     unsigned int  index,
 				     unsigned long val)
 {
@@ -103,7 +103,7 @@
 	writel(cpu_to_le32(val), ptr);
 }
 
-static inline unsigned long nsp32_mmio_read4(unsigned long base,
+inline static unsigned long nsp32_mmio_read4(unsigned long base,
 					     unsigned int  index)
 {
 	volatile unsigned long *ptr;
@@ -115,14 +115,14 @@
 
 /*==============================================*/
 
-static inline unsigned char nsp32_index_read1(unsigned int base,
+inline static unsigned char nsp32_index_read1(unsigned int base,
 					      unsigned int reg)
 {
 	outb(reg, base + INDEX_REG);
 	return inb(base + DATA_REG_LOW);
 }
 
-static inline void nsp32_index_write1(unsigned int  base,
+inline static void nsp32_index_write1(unsigned int  base,
 				      unsigned int  reg,
 				      unsigned char val)
 {
@@ -130,14 +130,14 @@
 	outb(val, base + DATA_REG_LOW);
 }
 
-static inline unsigned short nsp32_index_read2(unsigned int base,
+inline static unsigned short nsp32_index_read2(unsigned int base,
 					       unsigned int reg)
 {
 	outb(reg, base + INDEX_REG);
 	return inw(base + DATA_REG_LOW);
 }
 
-static inline void nsp32_index_write2(unsigned int   base,
+inline static void nsp32_index_write2(unsigned int   base,
 				      unsigned int   reg,
 				      unsigned short val)
 {
@@ -145,7 +145,7 @@
 	outw(val, base + DATA_REG_LOW);
 }
 
-static inline unsigned long nsp32_index_read4(unsigned int base,
+inline static unsigned long nsp32_index_read4(unsigned int base,
 					      unsigned int reg)
 {
 	unsigned long h,l;
@@ -157,7 +157,7 @@
 	return ((h << 16) | l);
 }
 
-static inline void nsp32_index_write4(unsigned int  base,
+inline static void nsp32_index_write4(unsigned int  base,
 				      unsigned int  reg,
 				      unsigned long val)
 {
@@ -173,8 +173,8 @@
 
 /*==============================================*/
 
-static inline unsigned char nsp32_mmio_index_read1(unsigned long base,
-						   unsigned int reg)
+inline static unsigned char nsp32_mmio_index_read1(unsigned long base,
+						   unsigned int  reg)
 {
 	volatile unsigned short *index_ptr, *data_ptr;
 
@@ -185,7 +185,7 @@
 	return readb(data_ptr);
 }
 
-static inline void nsp32_mmio_index_write1(unsigned long base,
+inline static void nsp32_mmio_index_write1(unsigned long base,
 					   unsigned int  reg,
 					   unsigned char val)
 {
@@ -198,7 +198,7 @@
 	writeb(val, data_ptr );
 }
 
-static inline unsigned short nsp32_mmio_index_read2(unsigned long base,
+inline static unsigned short nsp32_mmio_index_read2(unsigned long base,
 						    unsigned int  reg)
 {
 	volatile unsigned short *index_ptr, *data_ptr;
@@ -210,7 +210,7 @@
 	return le16_to_cpu(readw(data_ptr));
 }
 
-static inline void nsp32_mmio_index_write2(unsigned long  base,
+inline static void nsp32_mmio_index_write2(unsigned long  base,
 					   unsigned int   reg,
 					   unsigned short val)
 {
@@ -225,7 +225,7 @@
 
 /*==============================================*/
 
-static inline void nsp32_multi_read4(unsigned int   base,
+inline static void nsp32_multi_read4(unsigned int   base,
 				     unsigned int   reg,
 				     void          *buf,
 				     unsigned long  count)
@@ -233,14 +233,14 @@
 	insl(base + reg, buf, count);
 }
 
-static inline void nsp32_fifo_read(unsigned int   base,
+inline static void nsp32_fifo_read(unsigned int   base,
 				   void          *buf,
 				   unsigned long  count)
 {
 	nsp32_multi_read4(base, FIFO_DATA_LOW, buf, count);
 }
 
-static inline void nsp32_multi_write4(unsigned int   base,
+inline static void nsp32_multi_write4(unsigned int   base,
 				      unsigned int   reg,
 				      void          *buf,
 				      unsigned long  count)
@@ -248,7 +248,7 @@
 	outsl(base + reg, buf, count);
 }
 
-static inline void nsp32_fifo_write(unsigned int   base,
+inline static void nsp32_fifo_write(unsigned int   base,
 				    void          *buf,
 				    unsigned long  count)
 {
