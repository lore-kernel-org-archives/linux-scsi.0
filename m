From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: megaraid_sas dbg_lvl permissions
Date: Fri, 15 Aug 2008 08:44:54 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3232D97DD@cosmail02.lsi.com>
References: <31647799.1118451218748488466.JavaMail.root@ouachita>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46801 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189AbYHOOpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 10:45:17 -0400
In-Reply-To: <31647799.1118451218748488466.JavaMail.root@ouachita>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Malicki <jmalicki@metacarta.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

ACK.

Thanks,

Bo Yang

-----Original Message-----
From: Joe Malicki [mailto:jmalicki@metacarta.com]
Sent: Thursday, August 14, 2008 5:15 PM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org
Subject: megaraid_sas dbg_lvl permissions

/sys/bus/pci/drivers/megaraid_sas/dbg_lvl defaults to being world-writable, which seems bad (letting any user affect kernel driver behavior and logging level).

This turns off group and user write permissions, so that on typical production systems only root can write to it.

Signed-off-by: Joseph Malicki <jmalicki@metacarta.com>
--
--- drivers/scsi/megaraid/megaraid_sas.c.orig   2008-01-31 10:49:57.000000000 -0500
+++ drivers/scsi/megaraid/megaraid_sas.c        2008-01-31 10:52:10.000000000 -0500
@@ -3044,7 +3044,7 @@
        return retval;
 }

-static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUGO, megasas_sysfs_show_dbg_lvl,
+static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUSR,
+megasas_sysfs_show_dbg_lvl,
                   megasas_sysfs_set_dbg_lvl);

 /**
--
