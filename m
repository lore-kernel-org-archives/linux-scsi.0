From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH]: add debug flag parameter for SCSI tape driver - 2nd
 request
Date: Fri, 17 Oct 2014 16:20:29 -0400 (EDT)
Message-ID: <753462044.46450262.1413577229927.JavaMail.zimbra@redhat.com>
References: <101311718.17236924.1402433475036.JavaMail.zimbra@redhat.com> <1374689615.17272341.1402444113231.JavaMail.zimbra@redhat.com> <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:54445 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaJQUUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 16:20:44 -0400
In-Reply-To: <1CAC495F-3A9A-45B1-8E15-4B6D3F17114D@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>, Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

Hello Kai

You have seen this patch before. The first time around, given that we don't enable DEBUG by default, I let it go.
However we have been looking into defining DEBUG 1 by default here at Redhat and then setting the default to disabled.

Are you open to considering changing the driver based on this patch.
i.e. default DEFINE 1 and adding this code with default set to off.

Note that with DEBUG 0, as you know you need to change that and recompile. 
That is exactly what I am trying to avoid with Enterprise customers.

This patch adds a debug_flag parameter that can be set on module load, and allows the DEBUG facility without a module recompile.
Note that now DEBUG 1 is the default with this patch.

Usage: modprobe st debug_flag=1

Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nur a/st.c b/st.c
--- a/st.c	2014-10-17 16:15:54.103810627 -0400
+++ b/st.c	2014-10-17 16:22:12.303810392 -0400
@@ -56,7 +56,7 @@
 
 /* The driver prints some debugging information on the console if DEBUG
    is defined and non-zero. */
-#define DEBUG 0
+#define DEBUG 1
 
 #define ST_DEB_MSG  KERN_NOTICE
 #if DEBUG
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
+        },
+        {
+                "debug_flag", &debug_flag
 	}
 };
 #endif
@@ -4306,6 +4313,11 @@
 
 	validate_options();
 
+        debugging = (debug_flag > 0) ? debug_flag : DEBUG;
+         if (debugging)
+                printk(KERN_INFO "st: Debugging enabled debug_flag = %d\n",debugging);
+
+
 	printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",
 		verstr, st_fixed_buffer_size, st_max_sg_segs);
