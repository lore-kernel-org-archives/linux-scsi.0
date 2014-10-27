From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 01/36] ncr5380: Use printk() not pr_debug()
Date: Mon, 27 Oct 2014 16:26:08 +1100
Message-ID: <20141027052607.355423344@telegraphics.com.au>
References: <20141027052607.105914311@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-use-printk-not-pr_debug
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Having defined NDEBUG, and having set the console log level, I'd like to see
some output. Don't use pr_debug(), it's annoying to have to define DEBUG as
well.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---

Use of pr_debug() here was a bad idea of mine. Joe was right when
he questioned it.

---
 drivers/scsi/NCR5380.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2014-10-27 16:18:00.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2014-10-27 16:25:06.000000000 +1100
@@ -296,7 +296,8 @@ struct NCR5380_hostdata {
 #endif
 
 #define dprintk(flg, fmt, ...) \
-	do { if ((NDEBUG) & (flg)) pr_debug(fmt, ## __VA_ARGS__); } while (0)
+	do { if ((NDEBUG) & (flg)) \
+		printk(KERN_DEBUG fmt, ## __VA_ARGS__); } while (0)
 
 #if NDEBUG
 #define NCR5380_dprint(flg, arg) \
