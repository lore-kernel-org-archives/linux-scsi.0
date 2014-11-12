From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 01/37] ncr5380: Use printk() not pr_debug()
Date: Wed, 12 Nov 2014 16:11:47 +1100
Message-ID: <20141112051146.775450244@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40947 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbaKLFmw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:42:52 -0500
Content-Disposition: inline; filename=ncr5380-use-printk-not-pr_debug
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Having defined NDEBUG, and having set the console log level, I'd like to see
some output. Don't use pr_debug(), it's annoying to have to define DEBUG as
well.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---

Use of pr_debug() here was a bad idea of mine. Joe was right when
he questioned it.

---
 drivers/scsi/NCR5380.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-11-12 16:10:46.000000000 +1100
@@ -296,7 +296,8 @@ struct NCR5380_hostdata {
 #endif
 
 #define dprintk(flg, fmt, ...) \
-	do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
+	do { if ((NDEBUG) & (flg)) \
+		printk(KERN_DEBUG fmt, ## __VA_ARGS__); } while (0)
 
 #if NDEBUG
 #define NCR5380_dprint(flg, arg) \


