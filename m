From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] wd7000 iomem annotations and fixes
Date: Sun, 28 Nov 2004 14:18:09 +0000
Message-ID: <20041128141809.GH26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16016 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261480AbUK1OSL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2004 09:18:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

	direct dereferencing of iomem pointer (by memcmp())
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC10-rc2-bk9-seagate/drivers/scsi/wd7000.c RC10-rc2-bk9-wd7000/drivers/scsi/wd7000.c
--- RC10-rc2-bk9-seagate/drivers/scsi/wd7000.c	Sun Nov 21 10:49:06 2004
+++ RC10-rc2-bk9-wd7000/drivers/scsi/wd7000.c	Sun Nov 28 02:50:02 2004
@@ -1429,16 +1429,16 @@
 						break;
 
 				if (i == pass) {
-					void *biosaddr = ioremap(wd7000_biosaddr[biosaddr_ptr] + signatures[sig_ptr].ofs,
+					void __iomem *biosaddr = ioremap(wd7000_biosaddr[biosaddr_ptr] + signatures[sig_ptr].ofs,
 								 signatures[sig_ptr].len);
-					short bios_match = 0;
+					short bios_match = 1;
 
 					if (biosaddr)
-						bios_match = memcmp((char *) biosaddr, signatures[sig_ptr].sig, signatures[sig_ptr].len);
+						bios_match = check_signature(biosaddr, signatures[sig_ptr].sig, signatures[sig_ptr].len);
 
 					iounmap(biosaddr);
 
-					if (!bios_match)
+					if (bios_match)
 						goto bios_matched;
 				}
 			}
