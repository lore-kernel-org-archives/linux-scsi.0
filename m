From: Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 01/02] drivers/scsi: use module_pcmcia_driver() in pcmcia
 drivers
Date: Tue, 16 Apr 2013 09:51:43 -0700
Message-ID: <20130416165143.GA3950@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63288 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935704Ab3DPQvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 12:51:52 -0400
Received: by mail-pb0-f43.google.com with SMTP id md4so395281pbc.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 09:51:52 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Juergen E. Fischer" <fischer@norbit.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, H Hartley Sweeten <hsweeten@visionengravers.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hsweeten@visionengravers.com>

Use the new module_pcmcia_driver() macro to remove the boilerplate
module init/exit code in the pcmcia drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Note, this needs the module_pcmcia_driver() macro, which is in my
char-misc-next branch and will be showing up in 3.10-rc1 - gregkh


 drivers/scsi/pcmcia/aha152x_stub.c | 14 +-------------
 drivers/scsi/pcmcia/fdomain_stub.c | 14 +-------------
 drivers/scsi/pcmcia/nsp_cs.c       | 17 +----------------
 drivers/scsi/pcmcia/qlogic_stub.c  | 13 +------------
 drivers/scsi/pcmcia/sym53c500_cs.c | 16 +---------------
 5 files changed, 5 insertions(+), 69 deletions(-)

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
index b61a753..76ca00c 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1773,19 +1773,4 @@ static struct pcmcia_driver nsp_driver = {
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
-
-/* end */
+module_pcmcia_driver(nsp_driver);
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index bcaf89f..8d4fdc2 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -300,19 +300,8 @@ static struct pcmcia_driver qlogic_cs_driver = {
 	.id_table       = qlogic_ids,
 	.resume		= qlogic_resume,
 };
-
-static int __init init_qlogic_cs(void)
-{
-	return pcmcia_register_driver(&qlogic_cs_driver);
-}
-
-static void __exit exit_qlogic_cs(void)
-{
-	pcmcia_unregister_driver(&qlogic_cs_driver);
-}
+module_pcmcia_driver(qlogic_cs_driver);
 
 MODULE_AUTHOR("Tom Zerucha, Michael Griffith");
 MODULE_DESCRIPTION("Driver for the PCMCIA Qlogic FAS SCSI controllers");
 MODULE_LICENSE("GPL");
-module_init(init_qlogic_cs);
-module_exit(exit_qlogic_cs);
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index f5b5273..55b0b2b 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -881,18 +881,4 @@ static struct pcmcia_driver sym53c500_cs_driver = {
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
1.8.2.1.368.g99c2266

