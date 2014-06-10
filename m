From: Laurence Oberman <oberman.l@gmail.com>
Subject: debug_flag added to st tape driver
Date: Tue, 10 Jun 2014 16:57:06 -0400
Message-ID: <CAAzz28jMu0VeQHZNHWD0jM3YREZrPERnPvTxONStyaV7foFc_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49575 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaFJU5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 16:57:08 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so4300601lbi.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 13:57:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello

I am tired of building modules to enable SCSI tape driver debug so I
am hoping this patch is acceptable.
Tested using kernel 3.14.6

Usage example:
modprobe st debug_flag=1

diff -Nur a/st.c b/st.c
--- a/st.c        2014-06-10 16:45:18.522354105 -0400
+++ b/st.c        2014-06-10 16:45:33.953765908 -0400
@@ -80,6 +80,7 @@
 static int try_direct_io = TRY_DIRECT_IO;
 static int try_rdio = 1;
 static int try_wdio = 1;
+static int debug_flag = 0;

 static struct class st_sysfs_class;
 static const struct attribute_group *st_dev_groups[];
@@ -100,6 +101,9 @@
 MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather
segments to use (256)");
 module_param_named(try_direct_io, try_direct_io, int, 0);
 MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer
and tape drive (1)");
+module_param_named(debug_flag, debug_flag, int, 0);
+MODULE_PARM_DESC(debug_flag, "Enable DEBUG, same as setting DEBUG 1
in source");
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
@@ -4277,7 +4284,9 @@
 static int __init init_st(void)
 {
         int err;
-
+        debugging = (debug_flag > 0) ? debug_flag : DEBUG;
+        if (debugging)
+                printk(KERN_INFO "st: Debugging enabled debug_flag =
%d\n",debugging);
         validate_options();

         printk(KERN_INFO "st: Version %s, fixed bufsize %d, s/g segs %d\n",

Thanks
Laurence
