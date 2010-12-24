From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/8] libfcoe: add implementation to support fcoe
 transport
Date: Thu, 23 Dec 2010 21:18:25 -0800
Message-ID: <1293167905.4676.462.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3794 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0LXFS4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:18:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, yi.zou@intel.com, michaelc@cs.wisc.edu


From: Yi Zou <yi.zou@intel.com>

Add the new libfcoe_transport.c file that implements basic fcoe transport
interface. Eventually, the sysfs entries to create/destroy/enable/disable
an FCoE instance will be coming to the fcoe transport layer, who does a
look-up to find the corresponding transport provide and pass the corresponding
action over to the identified provider.

The fcoe.ko will become the default fcoe transport provider that can support
FCoE on any given netdev interfaces, as the Open-FCoE.org's default software
FCoE HBA solution. Any vendor specific FCoE HBA driver that is built on top
of Open-FCoE's kernel stack of libfc & libfcoe as well as the user land tool
of fcoe-utils can easily plug-in and start running FCoE on their network
interfaces. The fcoe.ko will be converted to act as the default provider if
no vendor specific transport provider is found, as it is always added to the
very end of the list of attached transports.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/libfcoe.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.h b/drivers/scsi/fcoe/libfcoe.h
index c3fe316..21ff0bb 100644
--- a/drivers/scsi/fcoe/libfcoe.h
+++ b/drivers/scsi/fcoe/libfcoe.h
@@ -4,6 +4,7 @@
 extern unsigned int libfcoe_debug_logging;
 #define LIBFCOE_LOGGING	    0x01 /* General logging, not categorized */
 #define LIBFCOE_FIP_LOGGING 0x02 /* FIP logging */
+#define LIBFCOE_TRANSPORT_LOGGING      0x04 /* FCoE transport logging */
 
 #define LIBFCOE_CHECK_LOGGING(LEVEL, CMD)		\
 do {							\
@@ -22,4 +23,9 @@ do {							\
 			      printk(KERN_INFO "host%d: fip: " fmt,	\
 				     (fip)->lp->host->host_no, ##args);)
 
+#define LIBFCOE_TRANSPORT_DBG(fmt, args...)				\
+	LIBFCOE_CHECK_LOGGING(LIBFCOE_TRANSPORT_LOGGING,		\
+			      printk(KERN_INFO "%s: " fmt,		\
+			      __func__, ##args);)
+
 #endif /* _FCOE_LIBFCOE_H_ */
-- 
1.7.0.6




