From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] NCR53c406a: fix __setup function
Date: Tue, 3 Aug 2004 22:51:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040803225133.30fb86c2.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:47518 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267293AbUHDGHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 02:07:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>



Use correct __setup function type and parameters.
Return result from __setup function.

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>


diffstat:=
 drivers/scsi/NCR53c406a.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -Naurp ./drivers/scsi/NCR53c406a.c~setup_type ./drivers/scsi/NCR53c406a.c
--- ./drivers/scsi/NCR53c406a.c~setup_type	2004-08-03 14:46:32.147993904 -0700
+++ ./drivers/scsi/NCR53c406a.c	2004-08-03 21:28:44.322345768 -0700
@@ -606,22 +606,23 @@ static int NCR53c406a_release(struct Scs
 }
 
 /* called from init/main.c */
-static void __init NCR53c406a_setup(char *str, int *ints)
+static int __init NCR53c406a_setup(char *str)
 {
 	static size_t setup_idx = 0;
 	size_t i;
+	int ints[4];
 
 	DEB(printk("NCR53c406a: Setup called\n");
 	    );
 
 	if (setup_idx >= PORT_COUNT - 1) {
 		printk("NCR53c406a: Setup called too many times.  Bad LILO params?\n");
-		return;
+		return 0;
 	}
 	if (ints[0] < 1 || ints[0] > 3) {
 		printk("NCR53c406a: Malformed command line\n");
 		printk("NCR53c406a: Usage: ncr53c406a=<PORTBASE>[,<IRQ>[,<FASTPIO>]]\n");
-		return;
+		return 0;
 	}
 	for (i = 0; i < PORT_COUNT && !port_base; i++)
 		if (ports[i] == ints[1]) {
@@ -631,7 +632,7 @@ static void __init NCR53c406a_setup(char
 		}
 	if (!port_base) {
 		printk("NCR53c406a: Invalid PORTBASE 0x%x specified\n", ints[1]);
-		return;
+		return 0;
 	}
 
 	if (ints[0] > 1) {
@@ -654,6 +655,7 @@ static void __init NCR53c406a_setup(char
 		fast_pio = ints[3];
 
 	DEB(printk("NCR53c406a: port_base=0x%x, irq=%d, fast_pio=%d\n", port_base, irq_level, fast_pio);)
+	return 1;
 }
 
 __setup("ncr53c406a=", NCR53c406a_setup);


--
