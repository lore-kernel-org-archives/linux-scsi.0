From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] fd_mcs: fix __setup function
Date: Tue, 3 Aug 2004 22:50:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040803225045.05fdaa20.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:45470 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267285AbUHDGHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 02:07:30 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


Use correct __setup function type and parameters.
Return result from __setup function.
Don't confuse <ints> and <interrupts>.

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>


diffstat:=
 drivers/scsi/fd_mcs.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -Naurp ./drivers/scsi/fd_mcs.c~fd_mcs_init ./drivers/scsi/fd_mcs.c
--- ./drivers/scsi/fd_mcs.c~fd_mcs_init	2004-08-03 20:42:12.685739040 -0700
+++ ./drivers/scsi/fd_mcs.c	2004-08-03 21:30:01.501612736 -0700
@@ -78,6 +78,7 @@
  **************************************************************************/
 
 #include <linux/module.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <linux/errno.h>
@@ -288,7 +289,7 @@ static irqreturn_t fd_mcs_intr(int irq, 
 
 static unsigned long addresses[] = { 0xc8000, 0xca000, 0xce000, 0xde000 };
 static unsigned short ports[] = { 0x140, 0x150, 0x160, 0x170 };
-static unsigned short ints[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
+static unsigned short interrupts[] = { 3, 5, 10, 11, 12, 14, 15, 0 };
 
 /* host information */
 static int found = 0;
@@ -297,16 +298,19 @@ static struct Scsi_Host *hosts[FD_MAX_HO
 static int user_fifo_count = 0;
 static int user_fifo_size = 0;
 
-static void fd_mcs_setup(char *str, int *ints)
+static int __init fd_mcs_setup(char *str)
 {
 	static int done_setup = 0;
+	int ints[3];
 
 	if (done_setup++ || ints[0] < 1 || ints[0] > 2 || ints[1] < 1 || ints[1] > 16) {
 		printk("fd_mcs: usage: fd_mcs=FIFO_COUNT, FIFO_SIZE\n");
+		return 0;
 	}
 
 	user_fifo_count = ints[0] >= 1 ? ints[1] : 0;
 	user_fifo_size = ints[0] >= 2 ? ints[2] : 0;
+	return 1;
 }
 
 __setup("fd_mcs=", fd_mcs_setup);
@@ -391,7 +395,7 @@ static int fd_mcs_detect(Scsi_Host_Templ
 			} else {
 				bios = addresses[pos2 >> 6];
 				port = ports[(pos2 >> 4) & 0x03];
-				irq = ints[(pos2 >> 1) & 0x07];
+				irq = interrupts[(pos2 >> 1) & 0x07];
 			}
 
 			if (irq) {


--
