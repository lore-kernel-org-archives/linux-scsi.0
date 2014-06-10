From: Laurence Oberman <loberman@redhat.com>
Subject: [PATCH]: add debug flag parameter for SCSI tape driver
Date: Tue, 10 Jun 2014 19:48:33 -0400 (EDT)
Message-ID: <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com>
References: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:40628 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaFJXsd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 19:48:33 -0400
Received: from zmail22.collab.prod.int.phx2.redhat.com (zmail22.collab.prod.int.phx2.redhat.com [10.5.83.26])
	by mx6-phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s5ANmXEK002482
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 19:48:33 -0400
In-Reply-To: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello

Take 2 of this patch, changed module description and subject line.

This patch adds a debug_flag parameter that can be set on module load, and allows the DEBUG facility without a module recompile.
Usage: mpdprobe st debug_flag=1

Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nur a/st.c b/st.c
--- a/st.c	2014-06-10 16:45:18.522354105 -0400
+++ b/st.c	2014-06-10 19:40:39.774387990 -0400
@@ -80,6 +80,7 @@
 static int try_direct_io = TRY_DIRECT_IO;
 static int try_rdio = 1;
 static int try_wdio = 1;
+static int debug_flag = 0;
 
 static struct class st_sysfs_class;
 static const struct attribute_group *st_dev_groups[];
@@ -100,6 +101,9 @@
 MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to use (256)");
 module_param_named(try_direct_io, try_direct_io, int, 0);
 MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer and tape drive (1)");
+module_param_named(debug_flag, debug_flag, int, 0);
+MODULE_PARM_DESC(debug_flag, "Enable DEBUG, same as setting debugging=1");
+
 
 /* Extra parameters for testing */
 module_param_named(try_rdio, try_rdio, int, 0);
@@ -124,6 +128,9 @@
 	},
 	{
 		"try_direct_io", &try_direct_io
+	},
+	{
+		"debug_flag", &debug_flag
 	}
 };
 #endif
@@ -4277,7 +4284,9 @@
 static int __init init_st(void)
 {
 	int err;
-
+	debugging = (debug_flag > 0) ? debug_flag : DEBUG;
+        if (debugging) 
+		printk(KERN_INFO "st: Debugging enabled debug_flag = %d\n",debugging);
 	validate_options();
 
 	printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",


Thanks
Laurence
