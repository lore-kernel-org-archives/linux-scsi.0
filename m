From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 3/3] scsi_forget_host - rename scsi_forget_host to scsi_unscan_host
Date: Fri, 11 Jun 2004 21:24:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040612042421.GD21105@us.ibm.com>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:64933 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264637AbUFLEYI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jun 2004 00:24:08 -0400
Received: from westrelay05.boulder.ibm.com (westrelay05.boulder.ibm.com [9.17.193.33])
	by e35.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i5C4O7qF603086
	for <linux-scsi@vger.kernel.org>; Sat, 12 Jun 2004 00:24:07 -0400
Received: from hmsbounty.us.ibm.com (sig-9-49-143-70.mts.ibm.com [9.49.143.70])
	by westrelay05.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i5C4O6vM267726
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jun 2004 22:24:06 -0600
Content-Disposition: inline
In-Reply-To: <20040612042232.GC21105@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

DESC
scsi_forget_host - rename scsi_forget_host to scsi_unscan_host

This patch changes the name of the newly export scsi_forget_host function
to scsi_unscan_host. The scsi_unscan_host function name appears to create
a more symmetric LLDD interface
scsi_add_host
scsi_scan_host
...
scsi_unscan_host
scsi_remove_host

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
EDESC


 patched-2.6-andmike/drivers/scsi/hosts.c      |    2 +-
 patched-2.6-andmike/drivers/scsi/scsi_debug.c |    2 +-
 patched-2.6-andmike/drivers/scsi/scsi_scan.c  |    2 +-
 patched-2.6-andmike/drivers/scsi/scsi_syms.c  |    2 +-
 patched-2.6-andmike/include/scsi/scsi_host.h  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/scsi_syms.c~scsi_unscan_host drivers/scsi/scsi_syms.c
--- patched-2.6/drivers/scsi/scsi_syms.c~scsi_unscan_host	Sat Jun 12 00:47:46 2004
+++ patched-2.6-andmike/drivers/scsi/scsi_syms.c	Sat Jun 12 00:47:46 2004
@@ -36,7 +36,7 @@ EXPORT_SYMBOL(scsi_register_interface);
 EXPORT_SYMBOL(scsi_host_alloc);
 EXPORT_SYMBOL(scsi_add_host);
 EXPORT_SYMBOL(scsi_scan_host);
-EXPORT_SYMBOL(scsi_forget_host);
+EXPORT_SYMBOL(scsi_unscan_host);
 EXPORT_SYMBOL(scsi_remove_host);
 EXPORT_SYMBOL(scsi_host_get);
 EXPORT_SYMBOL(scsi_host_put);
diff -puN include/scsi/scsi_host.h~scsi_unscan_host include/scsi/scsi_host.h
--- patched-2.6/include/scsi/scsi_host.h~scsi_unscan_host	Sat Jun 12 00:47:46 2004
+++ patched-2.6-andmike/include/scsi/scsi_host.h	Sat Jun 12 00:47:46 2004
@@ -501,7 +501,7 @@ struct Scsi_Host {
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int scsi_add_host(struct Scsi_Host *, struct device *);
 extern void scsi_scan_host(struct Scsi_Host *);
-extern void scsi_forget_host(struct Scsi_Host *);
+extern void scsi_unscan_host(struct Scsi_Host *);
 extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
diff -puN drivers/scsi/scsi_debug.c~scsi_unscan_host drivers/scsi/scsi_debug.c
--- patched-2.6/drivers/scsi/scsi_debug.c~scsi_unscan_host	Sat Jun 12 00:47:46 2004
+++ patched-2.6-andmike/drivers/scsi/scsi_debug.c	Sat Jun 12 00:47:46 2004
@@ -1725,7 +1725,7 @@ static int sdebug_driver_remove(struct d
 		return -ENODEV;
 	}
 
-	scsi_forget_host(sdbg_host->shost);
+	scsi_unscan_host(sdbg_host->shost);
         scsi_remove_host(sdbg_host->shost);
 
         list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
diff -puN drivers/scsi/scsi_scan.c~scsi_unscan_host drivers/scsi/scsi_scan.c
--- patched-2.6/drivers/scsi/scsi_scan.c~scsi_unscan_host	Sat Jun 12 00:47:46 2004
+++ patched-2.6-andmike/drivers/scsi/scsi_scan.c	Sat Jun 12 00:47:46 2004
@@ -1259,7 +1259,7 @@ void scsi_scan_host(struct Scsi_Host *sh
 				SCAN_WILD_CARD, 0);
 }
 
-void scsi_forget_host(struct Scsi_Host *shost)
+void scsi_unscan_host(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev, *tmp;
 	unsigned long flags;
diff -puN drivers/scsi/hosts.c~scsi_unscan_host drivers/scsi/hosts.c
--- patched-2.6/drivers/scsi/hosts.c~scsi_unscan_host	Sat Jun 12 00:47:46 2004
+++ patched-2.6-andmike/drivers/scsi/hosts.c	Sat Jun 12 00:47:46 2004
@@ -79,7 +79,7 @@ void scsi_remove_host(struct Scsi_Host *
 {
 	scsi_host_cancel(shost, 0);
 	scsi_proc_host_rm(shost);
-	scsi_forget_host(shost);
+	scsi_unscan_host(shost);
 
 	set_bit(SHOST_DEL, &shost->shost_state);
 

_
