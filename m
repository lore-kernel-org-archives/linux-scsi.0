From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 7/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:08:48 +0900 (JST)
Message-ID: <20050222.160848.85347547.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:49422 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262229AbVBVHIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:08:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/nsp32_debug.c	2004-10-19 06:55:06.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/nsp32_debug.c	2004-11-15 05:01:22.000000000 +0900
@@ -83,24 +83,24 @@
 	}
 }
 
-static void print_commandk (unsigned char *command)
+static void print_commandk (const unsigned char *command)
 {
-	int i,s;
+	int i, size;
 //	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
 	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
 	if ((command[0] >> 5) == 6 ||
 	    (command[0] >> 5) == 7 ) {
-		s = 12; /* vender specific */
+		size = 12; /* vender specific */
 	} else {
-		s = COMMAND_SIZE(command[0]);
+		size = COMMAND_SIZE(command[0]);
 	}
 
-	for ( i = 1; i < s; ++i) {
+	for ( i = 1; i < size; ++i) {
 		printk("%02x ", command[i]);
 	}
 
-	switch (s) {
+	switch (size) {
 	case 6:
 		printk("LBA=%d len=%d",
 		       (((unsigned int)command[1] & 0x0f) << 16) |
@@ -137,7 +137,7 @@
 	printk("\n");
 }
 
-static void show_command(Scsi_Cmnd *SCpnt)
+static void show_command(const struct scsi_cmnd *SCpnt)
 {
 	print_commandk(SCpnt->cmnd);
 }
@@ -260,4 +260,45 @@
 	}
 }
 
+/*
+ * Byte dumper
+ *
+ * ptr:    start address
+ * offset: offset value for address section
+ * size:   dump size in byte
+ */
+static void nsp32_byte_dump(const void *ptr, int offset, int size)
+{
+	const unsigned char *tmp = ptr;
+	int pos;
+
+	if (size == 0) {
+		return;
+	}
+
+	pos = 0;
+	while(pos < size) {
+		/* address */
+		if (pos % 16 == 0) {
+			printk(/*KERN_DEBUG*/ "%08x:", pos + offset);
+		}
+
+		/* half separator */
+		if (pos % 16 == 8) {
+			printk(" -");
+		}
+
+		printk(" %02x", tmp[pos]);
+
+		/* Don't print "\n" at last line.
+		   Because we can get one more "\n". */
+		if ((pos % 16 == 15) && (pos + 1 != size)) {
+			printk("\n");
+		}
+
+		pos ++;
+	}
+	printk("\n");
+}
+
 /* end */
