From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] ppa needs to scsi_unregister(host)
Date: Fri, 15 Aug 2003 10:14:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030815101433.081e3653.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:44219 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270651AbTHORR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2003 13:17:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: campbell@torque.net


When umounting a ppa device, I see (2.6.0-test3):

Releasing ppa0
Iomega VPI0 (ppa) interface did not call scsi_unregister
Call Trace:
 [<f89aeca6>] exit_this_scsi_driver+0xb6/0xfa [ppa]
 [<c013c08d>] sys_delete_module+0x18d/0x1e0
 [<c0155276>] do_munmap+0x136/0x1b0
 [<c0155333>] sys_munmap+0x43/0x70
 [<c0109657>] syscall_call+0x7/0xb

so ppa needs to call scsi_unregister().
Is this all that's needed?

--
~Randy


patch_name:	scsi_ppa_unreg.patch
patch_version:	2003-08-15.09:46:30
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	ppa driver needs to call scsi_unregister(host);
product:	Linux
product_versions: 260-815
maintainer:	campbell@torque.net
diffstat:	=
 drivers/scsi/ppa.c |    1 +
 1 files changed, 1 insertion(+)


diff -Naurp ./drivers/scsi/ppa.c~unreg ./drivers/scsi/ppa.c
--- ./drivers/scsi/ppa.c~unreg	2003-08-15 08:28:45.000000000 -0700
+++ ./drivers/scsi/ppa.c	2003-08-15 09:44:43.000000000 -0700
@@ -76,6 +76,7 @@ int ppa_release(struct Scsi_Host *host)
     int host_no = host->unique_id;
 
     printk("Releasing ppa%i\n", host_no);
+    scsi_unregister(host);
     parport_unregister_device(ppa_hosts[host_no].dev);
     return 0;
 }
