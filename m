From: Joe Malicki <jmalicki@metacarta.com>
Subject: megaraid_sas dbg_lvl permissions
Date: Thu, 14 Aug 2008 17:14:48 -0400 (EDT)
Message-ID: <31647799.1118451218748488466.JavaMail.root@ouachita>
References: <25702243.1118401218748366053.JavaMail.root@ouachita>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from silene.metacarta.com ([208.80.142.18]:35317 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYHNVj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Aug 2008 17:39:57 -0400
In-Reply-To: <25702243.1118401218748366053.JavaMail.root@ouachita>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bo Yang <Bo.Yang@lsi.com>
Cc: linux-scsi@vger.kernel.org

/sys/bus/pci/drivers/megaraid_sas/dbg_lvl defaults to being world-writable, which
seems bad (letting any user affect kernel driver behavior and logging level).

This turns off group and user write permissions, so that on typical production systems
only root can write to it.

Signed-off-by: Joseph Malicki <jmalicki@metacarta.com>
--
--- drivers/scsi/megaraid/megaraid_sas.c.orig	2008-01-31 10:49:57.000000000 -0500
+++ drivers/scsi/megaraid/megaraid_sas.c	2008-01-31 10:52:10.000000000 -0500
@@ -3044,7 +3044,7 @@
 	return retval;
 }
 
-static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUGO, megasas_sysfs_show_dbg_lvl,
+static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUSR, megasas_sysfs_show_dbg_lvl,
 		   megasas_sysfs_set_dbg_lvl);
 
 /**
--
