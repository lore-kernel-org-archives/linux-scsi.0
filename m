From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: [PATCH] scsi: Use module_pcmcia_driver
Date: Sat, 4 Jul 2015 09:19:09 +0530
Message-ID: <20150704034909.GA5052@vaishali-Ideapad-Z570>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34923 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbbGDDtQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2015 23:49:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Juergen E. Fischer" <fischer@norbit.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Use module_pcmcia_driver for drivers whose init and exit functions
only register and unregister, respectively.

A simplified version of the Coccinelle semantic patch that performs
this transformation is as follows:

@a@
identifier f, x;
@@
-static f(...) { return pcmcia_register_driver(&x); }

@b depends on a@
identifier e, a.x;
@@
-static e(...) { pcmcia_unregister_driver(&x); }

@c depends on a && b@
identifier a.f;
declarer name module_init;
@@
-module_init(f);

@d depends on a && b && c@
identifier b.e, a.x;
declarer name module_exit;
declarer name module_pcmcia_driver;
@@
-module_exit(e);
+module_pcmcia_driver(x);

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/scsi/pcmcia/aha152x_stub.c | 14 +-------------
 drivers/scsi/pcmcia/fdomain_stub.c | 14 +-------------
 drivers/scsi/pcmcia/nsp_cs.c       | 15 +--------------
 drivers/scsi/pcmcia/nsp_cs.h       |  4 ----
 drivers/scsi/pcmcia/qlogic_stub.c  | 13 +------------
 drivers/scsi/pcmcia/sym53c500_cs.c | 16 +---------------
 6 files changed, 5 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 7d1609f..df82a34 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -220,16 +220,4 @@ static struct pcmcia_driver aha152x_cs_driver = {
 	.id_table       = aha152x_ids,
 	.resume		= aha152x_resume,
 };
-
-static int __init init_aha152x_cs(void)
-{
-	return pcmcia_register_driver(&aha152x_cs_driver);
-}
-
-static void __exit exit_aha152x_cs(void)
-{
-	pcmcia_unregister_driver(&aha152x_cs_driver);
-}
-
-module_init(init_aha152x_cs);
-module_exit(exit_aha152x_cs);
+module_pcmcia_driver(aha152x_cs_driver);
diff --git a/drivers/scsi/pcmcia/fdomain_stub.c b/drivers/scsi/pcmcia/fdomain_stub.c
index 714b248..ba84769 100644
--- a/drivers/scsi/pcmcia/fdomain_stub.c
+++ b/drivers/scsi/pcmcia/fdomain_stub.c
@@ -194,16 +194,4 @@ static struct pcmcia_driver fdomain_cs_driver = {
 	.id_table       = fdomain_ids,
 	.resume		= fdomain_resume,
 };
-
-static int __init init_fdomain_cs(void)
-{
-	return pcmcia_register_driver(&fdomain_cs_driver);
-}
-
-static void __exit exit_fdomain_cs(void)
-{
-	pcmcia_unregister_driver(&fdomain_cs_driver);
-}
-
-module_init(init_fdomain_cs);
-module_exit(exit_fdomain_cs);
+module_pcmcia_driver(fdomain_cs_driver);
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5fb6eef..f323049 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1742,19 +1742,6 @@ static struct pcmcia_driver nsp_driver = {
 	.suspend	= nsp_cs_suspend,
 	.resume		= nsp_cs_resume,
 };
-
-static int __init nsp_cs_init(void)
-{
-	return pcmcia_register_driver(&nsp_driver);
-}
-
-static void __exit nsp_cs_exit(void)
-{
-	pcmcia_unregister_driver(&nsp_driver);
-}
-
-
-module_init(nsp_cs_init)
-module_exit(nsp_cs_exit)
+module_pcmcia_driver(nsp_driver);
 
 /* end */
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index afd64f0..ea5122f 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -326,10 +326,6 @@ static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 /* Interrupt handler */
 //static irqreturn_t nspintr(int irq, void *dev_id);
 
-/* Module entry point*/
-static int  __init nsp_cs_init(void);
-static void __exit nsp_cs_exit(void);
-
 /* Debug */
 #ifdef NSP_DEBUG
 static void show_command (struct scsi_cmnd *SCpnt);
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index c670dc7..1f601a7 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -300,18 +300,7 @@ static struct pcmcia_driver qlogic_cs_driver = {
 	.resume		= qlogic_resume,
 };
 
-static int __init init_qlogic_cs(void)
-{
-	return pcmcia_register_driver(&qlogic_cs_driver);
-}
-
-static void __exit exit_qlogic_cs(void)
-{
-	pcmcia_unregister_driver(&qlogic_cs_driver);
-}
-
 MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
 MODULE_DESCRIPTION("Driver for the PCMCIA Qlogic FAS SCSI controllers");
 MODULE_LICENSE("GPL");
-module_init(init_qlogic_cs);
-module_exit(exit_qlogic_cs);
+module_pcmcia_driver(qlogic_cs_driver);
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 20011c8..a3b63be 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -880,18 +880,4 @@ static struct pcmcia_driver sym53c500_cs_driver = {
 	.id_table       = sym53c500_ids,
 	.resume		= sym53c500_resume,
 };
-
-static int __init
-init_sym53c500_cs(void)
-{
-	return pcmcia_register_driver(&sym53c500_cs_driver);
-}
-
-static void __exit
-exit_sym53c500_cs(void)
-{
-	pcmcia_unregister_driver(&sym53c500_cs_driver);
-}
-
-module_init(init_sym53c500_cs);
-module_exit(exit_sym53c500_cs);
+module_pcmcia_driver(sym53c500_cs_driver);
-- 
1.9.1

