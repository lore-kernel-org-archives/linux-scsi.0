From: michaelc@cs.wisc.edu
Subject: [PATCH 01/13] set proc name
Date: Sun, 29 Jun 2008 13:23:51 -0500
Message-ID: <1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442AbYF2SYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 14:24:10 -0400
In-Reply-To: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

1. Set proc name to fcoe so we can id from userspace.

2. rearrange includes in fcoe_if.c scsi comes after linux ones,
and drop unused includes like the cam and tcq ones.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/fcoe/fcoe_if.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_if.c b/drivers/scsi/fcoe/fcoe_if.c
index e92a354..24efe01 100644
--- a/drivers/scsi/fcoe/fcoe_if.c
+++ b/drivers/scsi/fcoe/fcoe_if.c
@@ -26,10 +26,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsicam.h>
-#include <scsi/scsi_transport.h>
-#include <scsi/scsi_transport_fc.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -40,6 +36,8 @@
 #include <scsi/fc/fc_els.h>
 #include <scsi/fc/fc_encaps.h>
 #include <scsi/fc/fc_fs.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
 
 #include <scsi/libfc/libfc.h>
 #include <scsi/libfc/fc_dbg.h>
@@ -263,6 +261,7 @@ struct device_attribute *fcoe_host_attrs[] = {
 static struct scsi_host_template fcoe_driver_template = {
 	.module = THIS_MODULE,
 	.name = "FCoE Driver",
+	.proc_name = FCOE_DRIVER_NAME,
 	.queuecommand = fc_queuecommand,
 	.eh_abort_handler = fc_eh_abort,
 	.eh_device_reset_handler = fc_eh_device_reset,
-- 
1.5.4.1

