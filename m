From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Allow x86-64 compilation for ips.c
Date: Sun, 10 Aug 2003 16:15:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030810141510.GA13602@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:20999 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S268702AbTHJOPU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2003 10:15:20 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, ipslinux@adaptec.com


ips.c seems to work on x86-64 fine. Disable the rogue error checking
for unsupported architectures.

Also make this check a soft error, not a hard error.

-Andi

diff -burpN -X ../KDIFX linux/drivers/scsi/ips.c linux-2.6.0test3-amd64/drivers/scsi/ips.c
--- linux/drivers/scsi/ips.c	2003-08-09 16:48:09.000000000 +0200
+++ linux-2.6.0test3-amd64/drivers/scsi/ips.c	2003-08-09 16:50:20.000000000 +0200
@@ -198,8 +198,8 @@
 #define IPS_VERSION_LOW         ".01-BETA"
 
 
-#if !defined(__i386__) && !defined(__ia64__)
-   #error "This driver has only been tested on the x86/ia64 platforms"
+#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
+   #warning "This driver has only been tested on the x86/ia64 platforms"
 #endif
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
