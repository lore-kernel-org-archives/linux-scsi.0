From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] fix advansys.c if !CONFIG_PROC_FS
Date: Fri, 29 Aug 2003 20:56:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030829185631.GG7038@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:37618 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S261672AbTH2S4m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2003 14:56:42 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: support@connectcom.net
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@rustcorp.com.au

The patch below fixes a compile error in drivers/scsi/advansys.c if 
!CONFIG_PROC_FS.

Please apply
Adrian

--- linux-2.6.0-test4-mm1/drivers/scsi/advansys.c.old	2003-08-27 16:14:32.000000000 +0200
+++ linux-2.6.0-test4-mm1/drivers/scsi/advansys.c	2003-08-27 16:15:54.000000000 +0200
@@ -6199,7 +6199,9 @@
 
 static Scsi_Host_Template driver_template = {
     .proc_name                  = "advansys",
+#ifdef CONFIG_PROC_FS
     .proc_info                  = advansys_proc_info,
+#endif
     .name                       = "advansys",
     .detect                     = advansys_detect, 
     .release                    = advansys_release,
