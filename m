From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 1/1] megaraid build fix
Date: Wed, 18 Aug 2004 22:22:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040818222220.0b4edd3e.akpm@osdl.org>
References: <200408190359.i7J3xG106754@mail.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:29635 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268063AbUHSFX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 01:23:58 -0400
In-Reply-To: <200408190359.i7J3xG106754@mail.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org


hm, unregister_ioctl32_conversion() isn't implemented either.  Maybe this
would be better: 


diff -puN include/linux/ioctl32.h~megaraid-build-fix include/linux/ioctl32.h
--- 25/include/linux/ioctl32.h~megaraid-build-fix	2004-08-18 22:15:26.126368872 -0700
+++ 25-akpm/include/linux/ioctl32.h	2004-08-18 22:21:01.287416648 -0700
@@ -3,6 +3,15 @@
 
 struct file;
 
+typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int,
+					unsigned long, struct file *);
+
+struct ioctl_trans {
+	unsigned long cmd;
+	ioctl_trans_handler_t handler;
+	struct ioctl_trans *next;
+};
+
 /* 
  * Register an 32bit ioctl translation handler for ioctl cmd.
  *
@@ -13,16 +22,16 @@ struct file;
  *                        struct file *file: file descriptor pointer.
  */ 
 
-extern int register_ioctl32_conversion(unsigned int cmd, int (*handler)(unsigned int, unsigned int, unsigned long, struct file *));
-
+#ifdef CONFIG_COMPAT
+extern int register_ioctl32_conversion(unsigned int cmd,
+				ioctl_trans_handler_t handler);
 extern int unregister_ioctl32_conversion(unsigned int cmd);
 
-typedef int (*ioctl_trans_handler_t)(unsigned int, unsigned int, unsigned long, struct file *);
+#else
 
-struct ioctl_trans {
-	unsigned long cmd;
-	ioctl_trans_handler_t handler;
-	struct ioctl_trans *next;
-};
+#define register_ioctl32_conversion(cmd, handler)	({ 0; })
+#define unregister_ioctl32_conversion(cmd)		({ 0; })
+
+#endif
 
 #endif
_

