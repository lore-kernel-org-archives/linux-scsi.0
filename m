From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: RE: [PATCH] Allow x86-64 compilation for ips.c
Date: Mon, 11 Aug 2003 07:48:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A3B9245C291EEF4785A24A1DBE8D852B3530FF@rtpexc01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:35461 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S272517AbTHKLsd
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 07:48:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Andi Kleen' <ak@muc.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

James,

Please do not apply this patch - It is incomplete.  A complete patch (
there's more to x86_64 than just this one change ) to ips for x86_64 support
is coming from the maintainers at Adaptec ( probably within a week ).

Adaptec Raid Development Team




-----Original Message-----
From: Andi Kleen [mailto:ak@muc.de]
Sent: Sunday, August 10, 2003 10:15 AM
To: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com;
IpsLinux
Subject: [PATCH] Allow x86-64 compilation for ips.c



ips.c seems to work on x86-64 fine. Disable the rogue error checking
for unsupported architectures.

Also make this check a soft error, not a hard error.

-Andi

diff -burpN -X ../KDIFX linux/drivers/scsi/ips.c
linux-2.6.0test3-amd64/drivers/scsi/ips.c
--- linux/drivers/scsi/ips.c	2003-08-09 16:48:09.000000000 +0200
+++ linux-2.6.0test3-amd64/drivers/scsi/ips.c	2003-08-09
16:50:20.000000000 +0200
@@ -198,8 +198,8 @@
 #define IPS_VERSION_LOW         ".01-BETA"
 
 
-#if !defined(__i386__) && !defined(__ia64__)
-   #error "This driver has only been tested on the x86/ia64 platforms"
+#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
+   #warning "This driver has only been tested on the x86/ia64 platforms"
 #endif
 
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,0)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
