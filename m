From: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 11/13] nsp32, nsp_cs driver update
Date: Tue, 22 Feb 2005 16:13:18 +0900 (JST)
Message-ID: <20050222.161318.48465403.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Received: from pixy-gw.netlab.cs.tsukuba.ac.jp ([130.158.83.98]:54798 "HELO
	pixy.netlab.cs.tsukuba.ac.jp") by vger.kernel.org with SMTP
	id S262234AbVBVHNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 02:13:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--- linux-2.6.10/drivers/scsi/pcmcia/nsp_debug.c	2004-10-19 06:53:51.000000000 +0900
+++ linux-2.6.10-nsp/drivers/scsi/pcmcia/nsp_debug.c	2004-11-20 17:17:42.000000000 +0900
@@ -1,12 +1,12 @@
 /*========================================================================
     Debug routines for nsp_cs
-      By: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
+      By: YOKOTA Hiroshi <yokota (at) netlab (dot) is (dot) tsukuba (dot) ac (dot) jp>
 
     This software may be used and distributed according to the terms of
     the GNU General Public License.
 =========================================================================*/
 
-/* $Id: nsp_debug.c,v 1.3 2003/07/26 14:21:09 elca Exp $ */
+/* $Id: nsp_debug.c,v 1.8 2004/11/20 08:17:42 elca Exp $ */
 
 /*
  * Show the command data of a command
@@ -17,10 +17,10 @@
 /* 00-03 */ "Test Unit Ready", "Rezero Unit", unknown, "Request Sense",
 /* 04-07 */ "Format Unit", "Read Block Limits", unknown, "Reasssign Blocks",
 /* 08-0d */ "Read (6)", unknown, "Write (6)", "Seek (6)", unknown, unknown,
-/* 0e-12 */ unknown, "Read Reverse", "Write Filemarks", "Space", "Inquiry",  
+/* 0e-12 */ unknown, "Read Reverse", "Write Filemarks", "Space", "Inquiry",
 /* 13-16 */ unknown, "Recover Buffered Data", "Mode Select", "Reserve",
 /* 17-1b */ "Release", "Copy", "Erase", "Mode Sense", "Start/Stop Unit",
-/* 1c-1d */ "Receive Diagnostic", "Send Diagnostic", 
+/* 1c-1d */ "Receive Diagnostic", "Send Diagnostic",
 /* 1e-1f */ "Prevent/Allow Medium Removal", unknown,
 };
 
@@ -30,7 +30,7 @@
 /* 23-28 */ unknown, unknown, "Read Capacity", unknown, unknown, "Read (10)",
 /* 29-2d */ unknown, "Write (10)", "Seek (10)", unknown, unknown,
 /* 2e-31 */ "Write Verify","Verify", "Search High", "Search Equal",
-/* 32-34 */ "Search Low", "Set Limits", "Prefetch or Read Position", 
+/* 32-34 */ "Search Low", "Set Limits", "Prefetch or Read Position",
 /* 35-37 */ "Synchronize Cache","Lock/Unlock Cache", "Read Defect Data",
 /* 38-3c */ "Medium Scan", "Compare","Copy Verify", "Write Buffer", "Read Buffer",
 /* 3d-3f */ "Update Block", "Read Long",  "Write Long",
@@ -38,8 +38,8 @@
 
 
 static const char *group_2_commands[] = {
-/* 40-41 */ "Change Definition", "Write Same", 
-/* 42-48 */ "Read Sub-Ch(cd)", "Read TOC", "Read Header(cd)", "Play Audio(cd)", unknown, "Play Audio MSF(cd)", "Play Audio Track/Index(cd)", 
+/* 40-41 */ "Change Definition", "Write Same",
+/* 42-48 */ "Read Sub-Ch(cd)", "Read TOC", "Read Header(cd)", "Play Audio(cd)", unknown, "Play Audio MSF(cd)", "Play Audio Track/Index(cd)",
 /* 49-4f */ "Play Track Relative(10)(cd)", unknown, "Pause/Resume(cd)", "Log Select", "Log Sense", unknown, unknown,
 /* 50-55 */ unknown, unknown, unknown, unknown, unknown, "Mode Select (10)",
 /* 56-5b */ unknown, unknown, unknown, unknown, "Mode Sense (10)", unknown,
@@ -53,9 +53,9 @@
 #define NOTEXT_GROUP    2
 
 static const char **commands[] = {
-    group_0_commands, group_1_commands, group_2_commands, 
-    (const char **) RESERVED_GROUP, (const char **) RESERVED_GROUP, 
-    (const char **) NOTEXT_GROUP, (const char **) VENDOR_GROUP, 
+    group_0_commands, group_1_commands, group_2_commands,
+    (const char **) RESERVED_GROUP, (const char **) RESERVED_GROUP,
+    (const char **) NOTEXT_GROUP, (const char **) VENDOR_GROUP,
     (const char **) VENDOR_GROUP
 };
 
@@ -68,13 +68,13 @@
 
 	switch ((unsigned long) table) {
 	case RESERVED_GROUP:
-		printk("%s[%02x] ", reserved, opcode); 
+		printk("%s[%02x] ", reserved, opcode);
 		break;
 	case NOTEXT_GROUP:
-		printk("%s(notext)[%02x] ", unknown, opcode); 
+		printk("%s(notext)[%02x] ", unknown, opcode);
 		break;
 	case VENDOR_GROUP:
-		printk("%s[%02x] ", vendor, opcode); 
+		printk("%s[%02x] ", vendor, opcode);
 		break;
 	default:
 		if (table[opcode & 0x1f] != unknown)
@@ -85,23 +85,23 @@
 	}
 }
 
-static void print_commandk (unsigned char *command)
+static void print_commandk (const unsigned char *command)
 {
-	int i, s;
+	int i, size;
 	printk(KERN_DEBUG);
 	print_opcodek(command[0]);
-	/*printk(KERN_DEBUG "%s ", __FUNCTION__);*/
+	/*printk(KERN_DEBUG __FUNCTION__ " ");*/
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
@@ -138,12 +138,12 @@
 	printk("\n");
 }
 
-static void show_command(Scsi_Cmnd *SCpnt)
+static void show_command(const struct scsi_cmnd *SCpnt)
 {
 	print_commandk(SCpnt->cmnd);
 }
 
-static void show_phase(Scsi_Cmnd *SCpnt)
+static void show_phase(const struct scsi_cmnd *SCpnt)
 {
 	int i = SCpnt->SCp.phase;
 
@@ -201,14 +201,30 @@
 	}
 }
 
-static void show_message(nsp_hw_data *data)
+static void show_message(const nsp_hw_data *data)
 {
 	int i;
 
 	printk(KERN_DEBUG "msg:");
-	for(i=0; i < data->MsgLen; i++) {
-		printk(" %02x", data->MsgBuffer[i]);
+
+	switch (data->CurrentSC->SCp.phase) {
+	case PH_MSG_IN:
+		for(i=0; i < data->MsgInLen; i++) {
+			printk(" %02x", data->MsgInBuffer[i]);
+		}
+		break;
+	case PH_MSG_OUT:
+		for(i=0; i < data->MsgOutLen; i++) {
+			printk(" %02x", data->MsgOutBuffer[i]);
+		}
+		break;
+	default:
+		printk("???\n");
+		return;
+		break;
 	}
+
+
 	printk("\n");
 }
 
