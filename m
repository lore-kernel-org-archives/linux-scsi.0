From: akpm@linux-foundation.org
Subject: [patch 25/30] drivers/scsi/aacraid/: cleanups
Date: Fri, 16 Feb 2007 01:46:43 -0800
Message-ID: <200702160946.l1G9kiKS026697@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37232 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423537AbXBPJt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:49:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

- proper prototypes for global code in aacraid.h
- aac_rx_start_adapter() can now become static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aacraid/aacraid.h |    3 +++
 drivers/scsi/aacraid/linit.c   |    2 --
 drivers/scsi/aacraid/nark.c    |    3 ---
 drivers/scsi/aacraid/rkt.c     |    3 ---
 drivers/scsi/aacraid/rx.c      |    2 +-
 5 files changed, 4 insertions(+), 9 deletions(-)

diff -puN drivers/scsi/aacraid/aacraid.h~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/aacraid.h
@@ -1840,8 +1840,11 @@ struct aac_driver_ident* aac_get_driver_
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
 int aac_probe_container(struct aac_dev *dev, int cid);
+int _aac_rx_init(struct aac_dev *dev);
+int aac_rx_select_comm(struct aac_dev *dev, int comm);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
 extern int startup_timeout;
 extern int aif_timeout;
+extern int expose_physicals;
diff -puN drivers/scsi/aacraid/linit.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/linit.c
@@ -82,8 +82,6 @@ static LIST_HEAD(aac_devices);
 static int aac_cfg_major = -1;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
 
-extern int expose_physicals;
-
 /*
  * Because of the way Linux names scsi devices, the order in this table has
  * become important.  Check for on-board Raid first, add-in cards second.
diff -puN drivers/scsi/aacraid/nark.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/nark.c
--- a/drivers/scsi/aacraid/nark.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/nark.c
@@ -74,9 +74,6 @@ static int aac_nark_ioremap(struct aac_d
 
 int aac_nark_init(struct aac_dev * dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
diff -puN drivers/scsi/aacraid/rkt.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/rkt.c
--- a/drivers/scsi/aacraid/rkt.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/rkt.c
@@ -45,7 +45,6 @@
 static int aac_rkt_select_comm(struct aac_dev *dev, int comm)
 {
 	int retval;
-	extern int aac_rx_select_comm(struct aac_dev *dev, int comm);
 	retval = aac_rx_select_comm(dev, comm);
 	if (comm == AAC_COMM_MESSAGE) {
 		/*
@@ -97,8 +96,6 @@ static int aac_rkt_ioremap(struct aac_de
 
 int aac_rkt_init(struct aac_dev *dev)
 {
-	extern int _aac_rx_init(struct aac_dev *dev);
-
 	/*
 	 *	Fill in the function dispatch table.
 	 */
diff -puN drivers/scsi/aacraid/rx.c~drivers-scsi-aacraid-cleanups drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c~drivers-scsi-aacraid-cleanups
+++ a/drivers/scsi/aacraid/rx.c
@@ -294,7 +294,7 @@ static void aac_rx_notify_adapter(struct
  *	Start up processing on an i960 based AAC adapter
  */
 
-void aac_rx_start_adapter(struct aac_dev *dev)
+static void aac_rx_start_adapter(struct aac_dev *dev)
 {
 	struct aac_init *init;
 
_
