From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] libfcoe: fix section mismatches
Date: Wed, 11 Jul 2012 13:02:11 +0200
Message-ID: <20120711110210.GA3619@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:57349 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2GKLCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2012 07:02:17 -0400
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Wed, 11 Jul 2012 12:02:15 +0100
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q6BB2DNC2281560
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jul 2012 12:02:13 +0100
Received: from d06av10.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q6BAfPDm011081
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jul 2012 06:41:26 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: Robert Love <robert.w.love@intel.com>, linux-scsi@vger.kernel.org

Fix this warning:

WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x7c):
 Section mismatch in reference from the function init_module()
 to the function .exit.text:fcoe_transport_exit()

libfcoe_init() calls fcoe_transport_exit() which is annotated with
__exit which puts it into the exit section.
If the driver would be compiled into the kernel the exit section
could be discarded at compile time, so all calls to functions which
reside in the exit section would be jumps to random data.

Not really an issue currently since the exit section is currently
only discarded at runtime together with the init section. So this
patch only removes the compile time warning.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/scsi/fcoe/fcoe_sysfs.c     |    2 +-
 drivers/scsi/fcoe/fcoe_transport.c |    4 ++--
 include/scsi/fcoe_sysfs.h          |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 2bc1631..7d6c119 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -826,7 +826,7 @@ int __init fcoe_sysfs_setup(void)
 	return 0;
 }
 
-void __exit fcoe_sysfs_teardown(void)
+void fcoe_sysfs_teardown(void)
 {
 	bus_unregister(&fcoe_bus_type);
 }
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b46f43d..ea87f6b 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -502,7 +502,7 @@ static int __init fcoe_transport_init(void)
 	return 0;
 }
 
-static int __exit fcoe_transport_exit(void)
+static int fcoe_transport_exit(void)
 {
 	struct fcoe_transport *ft;
 
@@ -832,7 +832,7 @@ module_init(libfcoe_init);
 /**
  * libfcoe_exit() - Tear down libfcoe.ko
  */
-static void __exit libfcoe_exit(void)
+static void libfcoe_exit(void)
 {
 	fcoe_sysfs_teardown();
 	fcoe_transport_exit();
diff --git a/include/scsi/fcoe_sysfs.h b/include/scsi/fcoe_sysfs.h
index 604cb9b..8e7a41a 100644
--- a/include/scsi/fcoe_sysfs.h
+++ b/include/scsi/fcoe_sysfs.h
@@ -119,6 +119,6 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *,
 void fcoe_fcf_device_delete(struct fcoe_fcf_device *);
 
 int __init fcoe_sysfs_setup(void);
-void __exit fcoe_sysfs_teardown(void);
+void fcoe_sysfs_teardown(void);
 
 #endif /* FCOE_SYSFS */
-- 
1.7.10.5

