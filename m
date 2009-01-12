From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] iscsi: Kconfig option for debug prints.
Date: Mon, 12 Jan 2009 17:33:12 +0200
Message-ID: <496B62B8.3030402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:5663 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752612AbZALPdS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 10:33:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


Remove the dark ages /* define debug_print */ in code, to use
a Kconfig option. With a system like Kconfig, in code, commented out,
configuration options are slavery and hard work.
(version control, manual edit ... need I say more)

I've used an "int" config bit-mask so more areas of code can be
selected with one Koption, but mainly so that allmodconfig will
not turn it on.

bit-1 - will turn on prints for libiscsi.
bit-2 - will turn on prints for libiscsi_tcp & iscsi_tcp.

More iscsi drivers should use more bits.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/Kconfig        |   15 +++++++++++++++
 drivers/scsi/iscsi_tcp.c    |    7 -------
 drivers/scsi/iscsi_tcp.h    |    6 ++++++
 drivers/scsi/libiscsi_tcp.c |    7 -------
 include/scsi/libiscsi.h     |    3 +--
 5 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d25d21e..6ef42f6 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -352,6 +352,21 @@ config ISCSI_TCP
 
 	 http://open-iscsi.org
 
+config ISCSI_DEBUG
+	int "ISCSI debug prints"
+	depends on SCSI_ISCSI_ATTRS
+	default 0
+	help
+	  This is a bit-mask that turns some debug printing to Kernel's
+	  Messages file. Each bit turns on another area of the code:
+	  1 - Turn on prints from iscsi libraries.
+	  2 - Turns on prints from iscsi_tcp operations.
+	  Note to programmers: Use more bits in this bit-mask for other iscsi
+	  drivers.
+	  If you found a problem with ISCSI, please turn this on to
+	  help us debug the problem. Send the Messages file plus problem
+	  description to open-iscsi@googlegroups.com mailing-list
+
 source "drivers/scsi/cxgb3i/Kconfig"
 
 config SGIWD93_SCSI
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a566aa9..af092a8 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -48,13 +48,6 @@ MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-#undef DEBUG_TCP
-
-#ifdef DEBUG_TCP
-#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
-#else
-#define debug_tcp(fmt...)
-#endif
 
 static struct scsi_transport_template *iscsi_sw_tcp_scsi_transport;
 static struct scsi_host_template iscsi_sw_tcp_sht;
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index ca6b7bc..1341b02 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -25,6 +25,12 @@
 #include <scsi/libiscsi.h>
 #include <scsi/libiscsi_tcp.h>
 
+#if (CONFIG_ISCSI_DEBUG & 2)
+#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
+#else
+#define debug_tcp(fmt...)
+#endif
+
 struct socket;
 struct iscsi_tcp_conn;
 
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 12354c5..4c9f827 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -49,13 +49,6 @@ MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-#undef DEBUG_TCP
-
-#ifdef DEBUG_TCP
-#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
-#else
-#define debug_tcp(fmt...)
-#endif
 
 static int iscsi_tcp_hdr_recv_done(struct iscsi_tcp_conn *tcp_conn,
 				   struct iscsi_segment *segment);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7360e19..2421c2a 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -45,8 +45,7 @@ struct iscsi_session;
 struct iscsi_nopin;
 struct device;
 
-/* #define DEBUG_SCSI */
-#ifdef DEBUG_SCSI
+#if (CONFIG_ISCSI_DEBUG & 1)
 #define debug_scsi(fmt...) printk(KERN_INFO "iscsi: " fmt)
 #else
 #define debug_scsi(fmt...)
-- 
1.6.0.1

