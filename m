From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix up SCSI netlink build
Date: Thu, 07 Sep 2006 11:43:59 -0500
Message-ID: <1157647439.3462.49.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10669 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161040AbWIGQoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 12:44:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James.Smart@emulex.com

The configuration change I introduced was overly optimistic.  We need to
account for the fact that CONFIG_SCSI_NETLINK can be a module.

James

Index: BUILD-2.6/drivers/scsi/Makefile
===================================================================
--- BUILD-2.6.orig/drivers/scsi/Makefile	2006-09-07 10:42:51.000000000 -0500
+++ BUILD-2.6/drivers/scsi/Makefile	2006-09-07 10:47:20.000000000 -0500
@@ -144,7 +144,8 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioct
 				   scsicam.o scsi_error.o scsi_lib.o \
 				   scsi_scan.o scsi_sysfs.o \
 				   scsi_devinfo.o
-scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
+scsi_nl-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
+scsi_mod-y			+= $(scsi_nl-m) $(scsi_nl-y)
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 
Index: BUILD-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_priv.h	2006-09-07 10:42:51.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_priv.h	2006-09-07 10:46:31.000000000 -0500
@@ -112,7 +112,7 @@ extern void __scsi_remove_device(struct 
 extern struct bus_type scsi_bus_type;
 
 /* scsi_netlink.c */
-#ifdef CONFIG_SCSI_NETLINK
+#if defined(CONFIG_SCSI_NETLINK) || defined(CONFIG_SCSI_NETLINK_MODULE)
 extern void scsi_netlink_init(void);
 extern void scsi_netlink_exit(void);
 extern struct sock *scsi_nl_sock;


