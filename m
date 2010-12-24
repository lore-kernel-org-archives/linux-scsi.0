From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 6/8] libfcoe: include libfcoe_transport.c into kernel
 libfcoe module
Date: Thu, 23 Dec 2010 21:18:30 -0800
Message-ID: <1293167910.4676.465.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4561 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab0LXFTU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:19:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, yi.zou@intel.com, michaelc@cs.wisc.edu

From: Yi Zou <yi.zou@intel.com>

Now we can include the libfcoe_transport.c to the build of the kernel libfcoe
module. Move the module information to libfcoe_transport, and it will have
all the module parameters later for the create/destroy/enable/disable of an
FCoE instance.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/Makefile            |    2 +-
 drivers/scsi/fcoe/libfcoe_fip.c       |    8 --------
 drivers/scsi/fcoe/libfcoe_transport.c |    8 ++++++++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index 8382aa2..87da252 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_FCOE) += fcoe.o
 obj-$(CONFIG_LIBFCOE) += libfcoe.o
 
-libfcoe-objs := libfcoe_fip.o
+libfcoe-objs := libfcoe_fip.o libfcoe_transport.o
diff --git a/drivers/scsi/fcoe/libfcoe_fip.c b/drivers/scsi/fcoe/libfcoe_fip.c
index 6457757..775625c 100644
--- a/drivers/scsi/fcoe/libfcoe_fip.c
+++ b/drivers/scsi/fcoe/libfcoe_fip.c
@@ -46,10 +46,6 @@
 
 #include "libfcoe.h"
 
-MODULE_AUTHOR("Open-FCoE.org");
-MODULE_DESCRIPTION("FIP discovery protocol support for FCoE HBAs");
-MODULE_LICENSE("GPL v2");
-
 #define	FCOE_CTLR_MIN_FKA	500		/* min keep alive (mS) */
 #define	FCOE_CTLR_DEF_FKA	FIP_DEF_FKA	/* default keep alive (mS) */
 
@@ -68,10 +64,6 @@ static u8 fcoe_all_enode[ETH_ALEN] = FIP_ALL_ENODE_MACS;
 static u8 fcoe_all_vn2vn[ETH_ALEN] = FIP_ALL_VN2VN_MACS;
 static u8 fcoe_all_p2p[ETH_ALEN] = FIP_ALL_P2P_MACS;
 
-unsigned int libfcoe_debug_logging;
-module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
-
 static const char * const fcoe_ctlr_states[] = {
 	[FIP_ST_DISABLED] =     "DISABLED",
 	[FIP_ST_LINK_WAIT] =    "LINK_WAIT",
diff --git a/drivers/scsi/fcoe/libfcoe_transport.c b/drivers/scsi/fcoe/libfcoe_transport.c
index b52d55a..fec0fb8 100644
--- a/drivers/scsi/fcoe/libfcoe_transport.c
+++ b/drivers/scsi/fcoe/libfcoe_transport.c
@@ -26,6 +26,10 @@
 
 #include "libfcoe.h"
 
+MODULE_AUTHOR("Open-FCoE.org");
+MODULE_DESCRIPTION("FIP discovery protocol support for FCoE HBAs");
+MODULE_LICENSE("GPL v2");
+
 static int fcoe_transport_create(const char *, struct kernel_param *);
 static int fcoe_transport_destroy(const char *, struct kernel_param *);
 static int fcoe_transport_show(char *buffer, const struct kernel_param *kp);
@@ -36,6 +40,10 @@ static int fcoe_transport_disable(const char *, struct kernel_param *);
 static LIST_HEAD(fcoe_transports);
 static DEFINE_MUTEX(ft_mutex);
 
+unsigned int libfcoe_debug_logging;
+module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
+
 module_param_call(show, NULL, fcoe_transport_show, NULL, S_IRUSR);
 __MODULE_PARM_TYPE(show, "string");
 MODULE_PARM_DESC(show, " Show registered FCoE transports");
-- 
1.7.0.6




