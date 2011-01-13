From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH v3 06/10] libfcoe: include fcoe_transport.c into kernel
	libfcoe module
Date: Wed, 12 Jan 2011 18:20:16 -0800
Message-ID: <20110113022015.12798.76719.stg.yi.zou@intel.com>
References: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28179 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab1AMCXV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 21:23:21 -0500
In-Reply-To: <20110113021649.12798.71742.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

Now we can include the fcoe_transport.c to the build of the kernel libfcoe
module. Move the module information to fcoe_transport, and it will have
all the module parameters later for the create/destroy/enable/disable of an
FCoE instance.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---

 drivers/scsi/fcoe/Makefile         |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c      |    8 --------
 drivers/scsi/fcoe/fcoe_transport.c |    8 ++++++++
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index b122b7a..f6d37d0 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_FCOE) += fcoe.o
 obj-$(CONFIG_LIBFCOE) += libfcoe.o
 
-libfcoe-objs := fcoe_ctlr.o
+libfcoe-objs := fcoe_ctlr.o fcoe_transport.o
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index a4757ca..113357e 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
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
 static const char *fcoe_ctlr_states[] = {
 	[FIP_ST_DISABLED] =	"DISABLED",
 	[FIP_ST_LINK_WAIT] =	"LINK_WAIT",
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 517c29b..8a630aa 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -26,6 +26,10 @@
 
 #include "libfcoe.h"
 
+MODULE_AUTHOR("Open-FCoE.org");
+MODULE_DESCRIPTION("FIP discovery protocol and FCoE transport for FCoE HBAs");
+MODULE_LICENSE("GPL v2");
+
 static int fcoe_transport_create(const char *, struct kernel_param *);
 static int fcoe_transport_destroy(const char *, struct kernel_param *);
 static int fcoe_transport_show(char *buffer, const struct kernel_param *kp);
@@ -38,6 +42,10 @@ static LIST_HEAD(fcoe_transports);
 static LIST_HEAD(fcoe_netdevs);
 static DEFINE_MUTEX(ft_mutex);
 
+unsigned int libfcoe_debug_logging;
+module_param_named(debug_logging, libfcoe_debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
+
 module_param_call(show, NULL, fcoe_transport_show, NULL, S_IRUSR);
 __MODULE_PARM_TYPE(show, "string");
 MODULE_PARM_DESC(show, " Show registered FCoE transports");

