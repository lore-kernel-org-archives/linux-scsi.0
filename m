From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support [3/4]
Date: Mon, 14 Apr 2003 11:41:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414184125.GD4162@beaverton.ibm.com>
References: <20030414183759.GA4162@beaverton.ibm.com> <20030414183918.GB4162@beaverton.ibm.com> <20030414184008.GC4162@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:41954 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263723AbTDNS1l (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 14:27:41 -0400
Content-Disposition: inline
In-Reply-To: <20030414184008.GC4162@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mochel@osdl.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This patch adds a scsi subsystem to the sysfs tree.
EDESC


 drivers/scsi/scsi_sysfs.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/scsi/scsi_sysfs.c~sysfs-scsi-subsys drivers/scsi/scsi_sysfs.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_sysfs.c~sysfs-scsi-subsys	Mon Apr 14 10:11:35 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_sysfs.c	Mon Apr 14 10:11:35 2003
@@ -107,10 +107,12 @@ static struct bus_type scsi_bus_type = {
         .match		= scsi_bus_match,
 };
 
+static decl_subsys(scsi, NULL);
 
 int scsi_sysfs_register(void)
 {
 	bus_register(&scsi_bus_type);
+	subsystem_register(&scsi_subsys);
 	devclass_register(&shost_devclass);
 
 	return 0;
@@ -119,6 +121,7 @@ int scsi_sysfs_register(void)
 void scsi_sysfs_unregister(void)
 {
 	devclass_unregister(&shost_devclass);
+	subsystem_unregister(&scsi_subsys);
 	bus_unregister(&scsi_bus_type);
 }
 

_
